#!/usr/bin/env python

"""

Usage:
    load-RDO.py [--debug | --quiet] [--dbhost=<str>] [--dbname=<str>] [--pwfile=<str>] [--dbuser=<str>] [--logfile=<file>] [--loglevel=<int>]
    load-RDO.py -? | --help

Options:
  -h --dbhost DBHOST   : MySQL database host name [default: localhost]
  -n --dbname DBNAME   : MySQL database name [default: S24_BIRD]
  -u --dbuser DBUSER   : MySQL login user name [default: root]
  -p --pwfile PWFILE   : MySQL password File path [default: ./tcrd_pass]
  -l --logfile LOGF    : set log file name
  -v --loglevel LOGL   : set logging level [default: 30]
                         50: CRITICAL
                         40: ERROR
                         30: WARNING
                         20: INFO
                         10: DEBUG
                          0: NOTSET
  -q --quiet           : set output verbosity to minimal level
  -d --debug           : turn on debugging output
  -? --help            : print this message and exit 
"""
import os, sys, time
from docopt import docopt
from TCRD.DBAdaptor import DBAdaptor
import logging
import obo

__author__ = 'Sidharth K S'
__email__ = 'sidharthks82@gmail.com'
__version__ = '8.0.0'

BIRD_VER = '8'

PROGRAM = os.path.basename(sys.argv[0])
LOGDIR=f"../log/rose{BIRD_VER}logs/"
LOGFILE = f"{LOGDIR}/{PROGRAM}.log"
RDO_OBO_FILE = '../data/RDO/rdo.obo'

def count_lines(filename):
    """
    Count the number of lines in a file.
    """
    line_count = 0
    with open(filename, 'r', encoding='utf-8') as f:
        for line in f:
            line_count += 1
    return line_count

def load(args, dba, dataset_id, logger, logfile):
    line_ct = count_lines(RDO_OBO_FILE)
    eco = {}
    parser = obo.Parser(RDO_OBO_FILE)
    for stanza in parser:
        eco[stanza.tags['id'][0].value] = stanza.tags
    
    total_rdo = 0
    db_err_ct = 0
    total_rdo_xref = 0
    
    for e, d in eco.items():
        doid = str(e)
        name = str(d['name'][0]) if 'name' in d else None
        defi = str(d['def'][0]) if 'def' in d else None
        
        # Insert into rdo table
        rv = dba.ins_rdo({'doid': doid, 'name': name, 'def': defi})
        if rv:
            total_rdo += 1
        else:
            db_err_ct += 1
        
        # Insert into rdo_xref table for alt_id
        if 'alt_id' in d:
            for alt in d['alt_id']:
                try:
                    db = str(alt).split(':')[0]
                    value = str(alt).split(':')[1]
                    rv = dba.ins_rdo_xref({'doid': doid, 'db': db, 'value': value})
                    if rv:
                        total_rdo_xref += 1
                    else:
                        db_err_ct += 1
                except Exception as e:
                    logger.error(f"Error processing alt_id: {e}")
        
        # Insert into rdo_xref table for xref
        if 'xref' in d:
            for xref in d['xref']:
                try:
                    db = str(xref).split(':')[0]
                    value = str(xref).split(':')[1]
                    rv = dba.ins_rdo_xref({'doid': doid, 'db': db, 'value': value})
                    if rv:
                        total_rdo_xref += 1
                    else:
                        db_err_ct += 1
                except Exception as e:
                    logger.error(f"Error processing xref: {e}")

    print(f"Inserted {total_rdo} records into rdo table.")
    print(f"Inserted {total_rdo_xref} records into rdo_xref table.")

if __name__ == '__main__':
    print("\n{} (v{}) [{}]:\n".format(PROGRAM, __version__, time.strftime("%c")))
    start_time = time.time()

    args = docopt(__doc__, version=__version__)
    if args['--debug']:
        print(f"\n[*DEBUG*] ARGS:\nargs\n")

    if args['--logfile']:
        logfile = args['--logfile']
    else:
        logfile = LOGFILE

    loglevel = int(args['--loglevel'])
    logger = logging.getLogger(__name__)
    logger.setLevel(loglevel)

    if not args['--debug']:
        logger.propagate = False
    fh = logging.FileHandler(logfile)
    fmtr = logging.Formatter('%(asctime)s-%(name)s-%(levelname)s-%(message)s', datefmt='%Y-%m-%d %H:%M:%S')
    fh.setFormatter(fmtr)
    logger.addHandler(fh)

    dba_params = {'dbname': args['--dbname'], 'dbhost': args['--dbhost'], 'pwfile': args['--pwfile'], 'logger_name': __name__}

    dba = DBAdaptor(dba_params)
    dbi = dba.get_dbinfo()
    logger.info(f"Connected to database {args['--dbname']} Schema_ver:{dbi['schema_ver']},data ver:{dbi['data_ver']}")
    if not args['--quiet']:
        print(f"Connected to database {args['--dbname']} Schema_ver:{dbi['schema_ver']},data ver:{dbi['data_ver']}")

    dataset_id = dba.ins_dataset({'name': 'RGD Disease Ontology', 'source': "rdo.obo file downloaded from https://download.rgd.mcw.edu/ontology/disease/", 'app': PROGRAM, 'app_version': __version__, 'url': 'https://download.rgd.mcw.edu/'})
    assert dataset_id, f"Error inserting data, for more info see logfile:{logfile}"
    
    provs = [{'dataset_id': dataset_id, 'table_name': 'rdo'},
            {'dataset_id': dataset_id, 'table_name': 'rdo_xref'}]
    
    for prov in provs:
        rv = dba.ins_provenance(prov)
        assert rv, f"Error inserting the data into prov for {prov}"

    load(args, dba, dataset_id, logger, logfile)

    time_taken = time.time() - start_time
    print(f"\n{PROGRAM} done \nTotal time: {time_taken:.2f} seconds")








