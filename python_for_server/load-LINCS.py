#!/usr/bin/env python

"""

Usage:
    load-LINCS.py [--debug | --quiet] [--dbhost=<str>] [--dbname=<str>] [--pwfile=<str>] [--dbuser=<str>] [--logfile=<file>] [--loglevel=<int>]
    load-LINCS.py -? | --help

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

import os,sys,time
from docopt import docopt
from TCRD.DBAdaptor import DBAdaptor
import logging
import slm_util_functions as slmf


__author__='Sidharth K S'
__email__='sidharthks82@gmail.com'
__version__='8.0.0'

BIRD_VER='8'

PROGRAM=os.path.basename(sys.argv[0])
LOGDIR=f"../log/rose{BIRD_VER}logs/"
LOGFILE=f"{LOGDIR}{PROGRAM}.log"

# The input file is exported from Oleg's lincs PostgreSQL database on seaborgium with:
# COPY (SELECT level5_lm.pr_gene_id, level5_lm.zscore, perturbagen.dc_id, perturbagen.canonical_smiles, signature.cell_id FROM level5_lm, perturbagen, signature where level5_lm.sig_id = signature.sig_id and signature.pert_id = perturbagen.pert_id and perturbagen.dc_id is NOT NULL) TO '/tmp/LINCS.csv';
# INPUT_FILE = '../data/LINCS.csv'



def load(args, dba, dataset_id, logger, logfile):
    pass     
    

            
                    
            
      
  
  


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
    dataset_id = dba.ins_dataset( {'name': 'LINCS', 'source': "CSV file exported from Oleg Ursu's lincs PostgreSQL database on seaborgium.", 'app': PROGRAM, 'app_version': __version__, 'url': 'http://lincsproject.org/LINCS/'} )
    assert dataset_id, "Error inserting dataset See logfile {} for details.".format(logfile)
    # Provenance
    rv = dba.ins_provenance({'dataset_id': dataset_id, 'table_name': 'lincs'})
    assert rv, "Error inserting provenance. See logfile {} for details.".format(logfile)
    
    #dataset_id = 60
    
    print(dataset_id)

    load(args , dba, dataset_id, logger, logfile)
    
    time_taken=time.time()-start_time
    print(f"\n{PROGRAM} done \n total time:{slmf.secs2str(time_taken)}")


    