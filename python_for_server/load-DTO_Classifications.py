#!/usr/bin/env python

"""

Usage:
    load-DTO_Classifications.py [--debug | --quiet] [--dbhost=<str>] [--dbname=<str>] [--pwfile=<str>] [--dbuser=<str>] [--logfile=<file>] [--loglevel=<int>]
    load-DTO_Classification.py -? | --help

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
import slm_util_functions as slmf


__author__='Sidharth K S'
__email__='sidharthks82@gmail.com'
__version__='8.0.0'

BIRD_VER='8'

PROGRAM=os.path.basename(sys.argv[0])
LOGDIR=f"../log/rose{BIRD_VER}logs/"
LOGFILE=f"{LOGDIR}{PROGRAM}.log"


MAPPING_FILE = '../data/UMiami/DTO2UniProt_DTOv2.csv'
CLASS_FILE = '../data/UMiami/Final_ProteomeClassification_Sep232019.csv'
DTO_OWL_FILE = '../data/UMiami/dto_proteome_classification_only.owl'
SRC_FILES = [os.path.basename(MAPPING_FILE),
             os.path.basename(CLASS_FILE),
             os.path.basename(DTO_OWL_FILE)]




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
    dataset_id = dba.ins_dataset( {'name': 'Drug Target Ontology', 'source': 'Files %s from Schurer Group at UMiami'%(", ".join(SRC_FILES)), 'app': PROGRAM, 'app_version': __version__, 'url': 'http://drugtargetontology.org/'} )
    assert dataset_id, "Error inserting dataset See logfile {} for details.".format(logfile)
    # Provenance
    provs = [ {'dataset_id': dataset_id, 'table_name': 'protein', 'column_name': 'dtoid'},
                {'dataset_id': dataset_id, 'table_name': 'protein', 'column_name': 'dtoclass'},
                {'dataset_id': dataset_id, 'table_name': 'dto'} ]
    

    
    print(dataset_id)

    load(args , dba, dataset_id, logger, logfile)
    
    time_taken=time.time()-start_time
    print(f"\n{PROGRAM} done \n total time:{slmf.secs2str(time_taken)}")


    