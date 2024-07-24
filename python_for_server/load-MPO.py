#!/usr/bin/env python

"""

Usage:
    load-MPO.py [--debug | --quiet] [--dbhost=<str>] [--dbname=<str>] [--pwfile=<str>] [--dbuser=<str>] [--logfile=<file>] [--loglevel=<int>]
    load-MPO.py -? | --help

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
import json

__author__ = 'Sidharth K S'
__email__ = 'sidharthks82@gmail.com'
__version__ = '8.0.0'

BIRD_VER = '8'

PROGRAM = os.path.basename(sys.argv[0])
LOGDIR=f"../log/rose{BIRD_VER}logs/"
LOGFILE = f"{LOGDIR}/{PROGRAM}.log"
MPO_JSON_FILE = '../data/MPO/mp.json'

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
    line_ct = count_lines(MPO_JSON_FILE)
    if not args['--quiet']:
        print(f"\nProcessing {line_ct} lines in file {MPO_JSON_FILE}")

    ct = 0
    db_err_ct = 0
    total_mp = 0
    mapping = {}

    with open(MPO_JSON_FILE, 'r', encoding='utf-8') as ifh:
        data = json.load(ifh)
        for i in data['graphs']:
            for edge in i['edges']:
                if 'pred' in edge and edge['pred'] == 'is_a':
                    if 'obj' in edge and 'sub' in edge:
                        first_value = edge['sub'].split('/')[-1].replace('_', ':')
                        second_value = edge['obj'].split('/')[-1].replace('_', ':')
                        mapping[first_value] = second_value
            
            for node in i['nodes']:
                ct += 1
                if 'id' in node:
                    id_value = node['id'].split('/')[-1].replace('_', ':')
                    if not id_value.startswith('MP:'):
                        continue
                else:
                    continue
                
                lbl = node.get('lbl', None)
                defi = node['meta']['definition']['val'] if 'meta' in node and 'definition' in node['meta'] else None
                parent_id = mapping.get(id_value, None)

                rv = dba.ins_mpo({'mpid': id_value, 'parent_id': parent_id, 'name': lbl, 'def': defi})
                if rv:
                    total_mp += 1
                else:
                    db_err_ct += 1

    print(f"Inserted {total_mp} records into database.")

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

    dataset_id = dba.ins_dataset({'name': 'Mammalian Phenotype Ontology', 'source': "OWL file downloaded from http://www.informatics.jax.org/downloads/reports/mp.owl", 'app': PROGRAM, 'app_version': __version__, 'url': 'http://www.genenames.org/'})
    assert dataset_id, f"Error inserting data, for more info see logfile:{logfile}"
    
    provs = [{'dataset_id': dataset_id, 'table_name': 'mpo'}]
    for prov in provs:
        rv = dba.ins_provenance(prov)
        assert rv, f"Error inserting the data into prov for {prov}"

    load(args, dba, dataset_id, logger, logfile)

    time_taken = time.time() - start_time
    print(f"\n{PROGRAM} done \nTotal time: {time_taken:.2f} seconds")








