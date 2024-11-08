#!/usr/bin/env python

"""

Usage:
    load-EBI-PatentCounts.py [--debug | --quiet] [--dbhost=<str>] [--dbname=<str>] [--pwfile=<str>] [--dbuser=<str>] [--logfile=<file>] [--loglevel=<int>]
    load-EBI-PatentCounts.py -? | --help

Options:
  -h --dbhost DBHOST   : MySQL database host name [default: localhost]
  -n --dbname DBNAME   : MySQL database name [default: SR24_BIRD]
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

import os,sys,time
from docopt import docopt
from TCRD.DBAdaptor import DBAdaptor
import logging
import csv
import slm_util_functions as slmf


__author__='Sidharth K S'
__email__='sidharthks82@gmail.com'
__version__='8.0.0'

BIRD_VER='8'

PROGRAM=os.path.basename(sys.argv[0])
LOGDIR=f"../log/rose{BIRD_VER}logs/"
LOGFILE=f"{LOGDIR}{PROGRAM}.log"

BASE_URL = 'ftp://ftp.ebi.ac.uk/pub/databases/chembl/IDG/patent_counts/'
DOWNLOAD_DIR = '../data/EBI/'
FILENAME = 'latest.txt'



def load(args, dba, dataset_id, logger, logfile):
    patent_cts = {}
    notfnd = set()
    pc_ct = 0
    dba_err_ct = 0
    fname = DOWNLOAD_DIR + FILENAME
    line_ct = slmf.wcl(fname)
    with open(fname, 'r') as csvfile:
        csvreader = csv.reader(csvfile,delimiter='\t')
        header = csvreader.__next__() # skip header line
        ct = 0
        for row in csvreader:
            row = row[0].split(',')
            ct += 1
            slmf.update_progress(ct/line_ct)
            up = row[0]
            #print(up)
            targets = dba.find_protein_ids({'uniprot': up})
            if not targets:
                targets = dba.find_targets_by_alias({'type': 'UniProt', 'value': up})
            if not targets:
                notfnd.add(up)
                print('not found')
                continue
            pid = targets[0]
            rv = dba.ins_patent_count({'protein_id': pid, 'year': row[2], 'count': row[3]} )
            if rv:
                pc_ct += 1
            else:
                dba_err_ct += 1
            if pid in patent_cts:
                patent_cts[pid] += int(row[3])
            else:
                patent_cts[pid] = int(row[3])
            
    print('\nDone')    
    

            
                    
            
      
  
  


if __name__ == '__main__':
    print("\n{} (v{}) [{}]:\n".format(PROGRAM, __version__, time.strftime("%c")))
    start_time = time.time()

    args = docopt(__doc__, version=__version__)
    if args['--debug']:
        print(f"\n[*DEBUG*] ARGS:\nargs\n")

    if args['--logfile']:
        logfile=args['--logfile']
    else:
        logfile=LOGFILE

    loglevel=int(args['--loglevel'])
    logger =logging.getLogger(__name__)
    logger.setLevel(loglevel)

    if not args['--debug']:
        logger.propagate=False
    fh=logging.FileHandler(logfile)
    fmtr=logging.Formatter('%(asctime)s-%(name)s-%(levelname)s-%(message)s',datefmt='%Y-%m-%d %H:%M:%S')
    fh.setFormatter(fmtr)
    logger.addHandler(fh)

    dba_params={'dbname':args['--dbname'],'dbhost':args['--dbhost'],'pwfile':args['--pwfile'],'logger_name':__name__}

    dba=DBAdaptor(dba_params)
    dbi=dba.get_dbinfo()
    logger.info(f"Connected to database {args['--dbname']} Schema_ver:{dbi['schema_ver']},data ver:{dbi['data_ver']}")
    if not args['--quiet']:
        print(f"Connected to database {args['--dbname']} Schema_ver:{dbi['schema_ver']},data ver:{dbi['data_ver']}")

    # Dataset
    dataset_id = dba.ins_dataset( {'name': 'EBI Patent Counts', 'source': 'File %s'%BASE_URL+FILENAME, 'app': PROGRAM, 'app_version': __version__, 'url': 'https://www.surechembl.org/search/', 'comments': 'Patents from SureChEMBL were tagged using the JensenLab tagger.'} )
    assert dataset_id, "Error inserting dataset See logfile {} for details.".format(logfile)
    # Provenance
    provs = [ {'dataset_id': dataset_id, 'table_name': 'patent_count'},
                {'dataset_id': dataset_id, 'table_name': 'tdl_info', 'where_clause': "itype = 'EBI Total Patent Count'"} ]
    for prov in provs:
        rv = dba.ins_provenance(prov)
        assert rv, "Error inserting provenance. See logfile {} for details.".format(logfile)
    

    
    print(dataset_id)

    load(args , dba, dataset_id, logger, logfile)
    
    time_taken=time.time()-start_time
    print(f"\n{PROGRAM} done \n total time:{slmf.secs2str(time_taken)}")


    