#!/usr/bin/env python

"""

Usage:
    update_tinx_articlerank.py [--debug | --quiet] [--dbhost=<str>] [--dbname=<str>] [--pwfile=<str>] [--dbuser=<str>] [--logfile=<file>] [--loglevel=<int>] [--datalevel=<int>]
    update_tinx_articlerank.py -? | --help

Options:
  -dl --datalevel DATALEVEL : 1 or 2 or 3 or 4
  -h --dbhost DBHOST   : MySQL database host name [default: localhost]
  -n --dbname DBNAME   : MySQL database name [default: SR_24]
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
import re


__author__='Sidharth K S'
__email__='sidharthks82@gmail.com'
__version__='8.0.0'

BIRD_VER='8'

PROGRAM=os.path.basename(sys.argv[0])
LOGDIR=f"../log/rose{BIRD_VER}logs/"
LOGFILE=f"{LOGDIR}{PROGRAM}.log"
# run tin-x.py to get these files






def load(args, dba, dataset_id, logger, logfile):
    datalvl= int(args['--datalevel'])
    print(datalvl)
    PMID_RANKING_FILE = f'../data/TIN-X/TCRDv8/{datalvl}.csv'
    imap = dba.get_imap()
    print(list(imap.keys())[0:5])
    print(list(imap.values())[0:5])
    line_ct = slmf.wcl(PMID_RANKING_FILE)
    print("\nProcessing {} lines in file {}".format(line_ct, PMID_RANKING_FILE))
    regex = re.compile(r"^DOID:0*")
    with open(PMID_RANKING_FILE, 'r') as csvfile:
        csvreader = csv.reader(csvfile)
        header = csvreader.__next__() # skip header line
        # DOID,Protein ID,UniProt,PubMed ID,Rank
        ct = 0
        tar_ct = 0
        skips = set()
        dba_err_ct = 0
        for row in csvreader:
            ct += 1
            slmf.update_progress(ct/line_ct)
            #print(row)
            k = "%s|%s"%(row[0],row[1])
            if k not in imap:
                logger.warn("%s not in imap" % k)
                skips.add(k)
                continue
            iid = imap[k]
            rv = dba.ins_tinx_articlerank( {'importance_id': int(iid), 'pmid': int(row[3]), 'rank': int(row[4]),'datalevel':datalvl} )
            if rv:
                tar_ct += 1
            else:
                dba_err_ct += 1
            
    
    print("\n{} lines processed.".format(ct))
    print("  Inserted {} new tinx_articlerank rows".format(tar_ct))
    if len(skips) > 0:
        print("WARNNING: No importance found in imap for {} keys. See logfile {} for details.".format(len(skips), logfile))
    if dba_err_ct > 0:
        print("WARNNING: {} DB errors occurred. See logfile {} for details.".format(dba_err_ct, logfile))     


            
                    
            
      
  
  


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
    dataset_id = dba.ins_dataset( {'name': 'TIN-X Data', 'source': 'IDG-KMC generated data by Steve Mathias at UNM.', 'app': PROGRAM, 'app_version': __version__, 'comments': 'Data is generated by python/TIN-X.py from mentions files http://download.jensenlab.org/human_textmining_mentions.tsv and http://download.jensenlab.org/disease_textmining_mentions.tsv.'} )
    assert dataset_id, "Error inserting dataset See logfile {} for details.".format(logfile)
    # Provenance
    provs = [ {'dataset_id': dataset_id, 'table_name': 'tinx_novelty', 'comment': "Protein novelty scores are generated from results of JensenLab textmining of PubMed in the file http://download.jensenlab.org/human_textmining_mentions.tsv. To calculate novelty scores, each paper (PMID) is assigned a fractional target (FT) score of one divided by the number of targets mentioned in it. The novelty score of a given protein is one divided by the sum of the FT scores for all the papers mentioning that protein."},
                {'dataset_id': dataset_id, 'table_name': 'tinx_disease', 'comment': "Disease novelty scores are generated from results of JensenLab textmining of PubMed in the file http://download.jensenlab.org/disease_textmining_mentions.tsv. To calculate novelty scores, each paper (PMID) is assigned a fractional disease (FD) score of one divided by the number of targets mentioned in it. The novelty score of a given disease is one divided by the sum of the FT scores for all the papers mentioning that disease."},
                {'dataset_id': dataset_id, 'table_name': 'tinx_importance', 'comment': "To calculate importance scores, each paper is assigned a fractional disease-target (FDT) score of one divided by the product of the number of targets mentioned and the number of diseases mentioned. The importance score for a given disease-target pair is the sum of the FDT scores for all papers mentioning that disease and protein."},
                {'dataset_id': dataset_id, 'table_name': 'tinx_articlerank', 'comment': "PMIDs are ranked for a given disease-target pair based on a score calculated by multiplying the number of targets mentioned and the number of diseases mentioned in that paper. Lower scores have a lower rank (higher priority). If the scores do not discriminate, PMIDs are reverse sorted by value with the assumption that larger PMIDs are newer and of higher priority."}]
    for prov in provs:
        rv = dba.ins_provenance(prov)
        assert rv, "Error inserting provenance. See logfile {} for details.".format(logfile)
    
   
    
    print(dataset_id)

    load(args , dba, dataset_id, logger, logfile)
    
    time_taken=time.time()-start_time
    print(f"\n{PROGRAM} done \n total time:{slmf.secs2str(time_taken)}")


    