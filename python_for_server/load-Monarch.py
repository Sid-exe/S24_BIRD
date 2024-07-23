#!/usr/bin/env python

"""

Usage:
    update-Monarch.py [--debug | --quiet] [--dbhost=<str>] [--dbname=<str>] [--pwfile=<str>] [--dbuser=<str>] [--logfile=<file>] [--loglevel=<int>]
    update-Monarch.py -? | --help

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


__author__ = 'Sidharth K S'
__email__ = 'sidharthks82@gmail.com'
__version__ = '8.0.0'

BIRD_VER = '8'

PROGRAM=os.path.basename(sys.argv[0])
LOGDIR=f"../log/"
LOGFILE=f"{LOGDIR}{PROGRAM}.log"

            
                    
            
      
  
  


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

    dataset_id = dba.ins_dataset( {'name': 'Monarch Disease Associations', 'source': "Imported from biokg", 'app': PROGRAM, 'app_version': __version__, 'url': 'http://diseases.jensenlab.org/'} )
    assert dataset_id ,f"Error inserting data, for more infor see logfile:{logfile}"
    provs = [ {'dataset_id': dataset_id, 'table_name': 'disease','where_clause':"dtype = 'Monarch'"}]
    for prov in provs:
        rv=dba.ins_provenance(prov)
        assert rv, f"Error inserting the data into prov for {prov}"
    print(dataset_id)
    
    dataset_id = dba.ins_dataset( {'name': 'Monarch Ortholog Disease Associations', 'source': "Imported from biokg", 'app': PROGRAM, 'app_version': __version__, 'url': 'http://diseases.jensenlab.org/'} )
    assert dataset_id ,f"Error inserting data, for more infor see logfile:{logfile}"
    provs = [ {'dataset_id': dataset_id, 'table_name': 'ortholog_disease'}]
    for prov in provs:
        rv=dba.ins_provenance(prov)
        assert rv, f"Error inserting the data into prov for {prov}"
    

    
    print(dataset_id)

    
    time_taken=time.time()-start_time
    print(f"\n{PROGRAM} done \n total time:{slmf.secs2str(time_taken)}")