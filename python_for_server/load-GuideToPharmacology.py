#!/usr/bin/env python

"""Load HGNC annotations for TCRD targets from downloaded TSV file.

Usage:
    load-GuideToPharmacology.py [--debug | --quiet] [--dbhost=<str>] [--dbname=<str>] [--pwfile=<str>] [--dbuser=<str>] [--logfile=<file>] [--loglevel=<int>]
    load-GuideToPharmacology.py -? | --help

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
import os
import sys
import time
from docopt import docopt
from TCRD.DBAdaptor import DBAdaptor
import logging
import csv
import slm_util_functions as slmf
from collections import defaultdict

__author__ = 'Sidharth K S'
__email__ = 'sidharthks82@gmail.com'
__version__ = '8.0.0'

BIRD_VER = '8'

PROGRAM = os.path.basename(sys.argv[0])
LOGDIR=f"../log/rose{BIRD_VER}logs/"
LOGFILE = f"{LOGDIR}/{PROGRAM}.log"
DOWNLOAD_DIR = '../data/GuideToPharmacology/'
L_FILE = 'ligands.csv'
I_FILE = 'interactions.csv'

def count_lines(filename):
    with open(filename, 'r', encoding='utf-8') as f:
        return sum(1 for line in f)

def load(args, dba, dataset_id, logger, logfile):
    # Load ligands
    fn = DOWNLOAD_DIR + L_FILE
    line_ct = count_lines(fn) - 2  # Subtract 2 for the header rows
    ligands = {}
    skip_ct = 0
    with open(fn, 'r', encoding='utf-8') as lfh:
        csvreader = csv.reader(lfh)
        next(csvreader)  # Skip first header row
        next(csvreader)  # Skip second header row
        ct = 1
        for row in csvreader:
            ct += 1
            slmf.update_progress(ct / line_ct)
            ligand_id = int(row[0])
            ligand_type = row[3]
            if ligand_type == 'Antibody' or ligand_type == 'Peptide':
                skip_ct += 1
                continue
            ligands[ligand_id] = {'name': row[1], 'pubchem_cid': row[9], 'smiles': row[19]}

    # Load interactions
    fn = DOWNLOAD_DIR + I_FILE
    line_ct = count_lines(fn) - 2  # Subtract 2 for the header rows
    k2ts = defaultdict(list)
    with open(fn, 'r', encoding='utf-8') as ifh:
        csvreader = csv.reader(ifh)
        next(csvreader)  # Skip first header row
        next(csvreader)  # Skip second header row
        ct = 1
        tmark = {}
        ca_ct = 0
        ap_ct = 0
        md_ct = 0
        ba_ct = 0
        notfnd = set()
        dba_err_ct = 0
        for row in csvreader:
            ct += 1
            slmf.update_progress(ct / line_ct)
            lid = int(row[14])
            if lid not in ligands:
                ap_ct += 1
                continue
            if row[31] == '':
                md_ct += 1
                continue
            if '|' in row[4]:
                skip_ct += 1
                continue
            val = "%.8f" % float(row[31])
            act_type = row[33]
            up = row[4]
            sym = row[3]
            k = f"{up}|{sym}"
            if k == '|':
                md_ct += 1
                continue
            if k in k2ts:
                ts = k2ts[k]
            elif k in notfnd:
                continue
            else:
                pids = dba.find_protein_ids({'uniprot': up})
                if not pids:
                    pids = dba.find_protein_ids({'sym': sym})
                    if not pids:
                        notfnd.add(k)
                        logger.warn(f"No target found for {k}")
                        continue
                ts = []
                for pid in pids:
                    targets = dba.get_target(pid)
                    ts.append({'id': pid, 'fam': targets['fam']})
                    k2ts[k] = ts
            if row[41] and row[41] != '':
                pmids = row[41]
            else:
                pmids = None
            if ligands[lid]['pubchem_cid'] == '':
                pccid = None
            else:
                pccid = ligands[lid]['pubchem_cid']
            for t in ts:
                if t['fam'] == 'GPCR':
                    cutoff = 7.0  # 100nM
                elif t['fam'] == 'IC':
                    cutoff = 5.0  # 10uM
                elif t['fam'] == 'Kinase':
                    cutoff = 7.52288  # 30nM
                elif t['fam'] == 'NR':
                    cutoff = 7.0  # 100nM
                else:
                    cutoff = 6.0  # 1uM for non-IDG Family targets
                if float(val) >= cutoff:
                    tmark[t['id']] = True
                    rv = dba.ins_cmpd_activity({
                        'target_id': t['id'], 'catype': 'Guide to Pharmacology',
                        'cmpd_id_in_src': lid,
                        'cmpd_name_in_src': ligands[lid]['name'],
                        'smiles': ligands[lid]['smiles'], 'act_value': val,
                        'act_type': act_type, 'pubmed_ids': pmids,
                        'cmpd_pubchem_cid': pccid
                    })
                    if not rv:
                        dba_err_ct += 1
                        continue
                    ca_ct += 1
                else:
                    ba_ct += 1

    print("{} rows processed.".format(ct))
    print("  Inserted {} new cmpd_activity rows for {} targets".format(ca_ct, len(tmark)))
    print("  Skipped {} with below cutoff activity values".format(ba_ct))
    print("  Skipped {} activities with multiple targets".format(skip_ct))
    print("  Skipped {} antibody/peptide activities".format(ap_ct))
    print("  Skipped {} activities with missing data".format(md_ct))
    if notfnd:
        print("No target found for {} uniprots/symbols. See logfile {} for details.".format(len(notfnd), logfile))
    if dba_err_ct > 0:
        print("WARNING: {} DB errors occurred. See logfile {} for details.".format(dba_err_ct, logfile))

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

    dataset_id = dba.ins_dataset({
        'name': 'Guide to Pharmacology',
        'source': "Files ligands.csv, interactions.csv from http://www.guidetopharmacology.org/DATA/",
        'app': PROGRAM, 'app_version': __version__,
        'url': 'http://www.guidetopharmacology.org/'
    })
    assert dataset_id, f"Error inserting data, for more info see logfile:{logfile}"

    provs = [{'dataset_id': dataset_id, 'table_name': 'cmpd_activity', 'where_clause': 'ctype = "Guide to Pharmacology"'}]
    for prov in provs:
        rv = dba.ins_provenance(prov)
        assert rv, f"Error inserting the data into prov for {prov}"

    load(args, dba, dataset_id, logger, logfile)
    
    time_taken = time.time() - start_time
    print(f"\n{PROGRAM} done \n total time:{slmf.secs2str(time_taken)}")








