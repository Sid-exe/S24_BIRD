#!/usr/bin/env python

"""Load NCBI annotations for TCRD from NCBI api.

Usage:
    load-NCBIGene.py [--debug | --quiet] [--dbhost=<str>] [--dbname=<str>] [--pwfile=<str>] [--dbuser=<str>] [--logfile=<file>] [--loglevel=<int>]
    load-NCBIGene.py -? | --help

Options:
  -h --dbhost DBHOST   : MySQL database host name [default: localhost]
  -n --dbname DBNAME   : MySQL database name [default: S24_BIRD]
  -u --dbuser DBUSER   : MySQL login user name [default: root]
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
import slm_util_functions as slmf
from collections import defaultdict
import shelve
import requests
from bs4 import BeautifulSoup

__author__='Sidharth K S'
__email__='sidharthks82@gmail.com'
__version__='8.0.0'

BIRD_VER='8'

PROGRAM=os.path.basename(sys.argv[0])
LOGDIR=f"../log/rose{BIRD_VER}logs/"
LOGFILE = f"{LOGDIR}/{PROGRAM}.log"
EFETCH_GENE_URL='http://www.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=Gene&rettype=xml&id='
SHELF_FILE = '%s/load-NCBIGene.db'%LOGDIR


def load(args, dba, dataset_id, logger, logfile):
    s = shelve.open(SHELF_FILE, writeback=True)
    s.setdefault('loaded', [])
    s.setdefault('retries', {})
    s.setdefault('counts', defaultdict(int))

    try:
        ct = 0
        skip_ct = 0
        pct = len(dba.get_protein_ids())
        logger.info(f'Loading NCBI Gene annotation for {pct} TCRD proteins')
        avails_proteins = dba.ncbigene_avail_proteins()

        for t in dba.get_proteins():
            try:
                ct += 1
                slmf.update_progress(ct / pct)
                pid = t['id']

                if pid in avails_proteins or pid in s['loaded']:
                    continue

                if t['geneid'] is None:
                    skip_ct += 1
                    continue

                geneid = str(t['geneid'])
                logger.info(f"Processing protein with protein ID: {pid} and gene ID: {geneid}")
                status, headers, xml = get_ncbigene(geneid)

                if not status:
                    logger.warning(f"Failed to get gene ID: {geneid}")
                    s['retries'][pid] = True
                    continue

                if status != 200:
                    logger.warning(f"Bad API response for Gene ID {geneid}: status: {status}")
                    s['retries'][pid] = True
                    continue

                gene_annotations = parse_genexml(xml)

                if not gene_annotations:
                    s['counts']['xml_err'] += 1
                    logger.error(f"XML error for gene ID: {geneid}")
                    s['retries'][pid] = True
                    continue

                load_annotations(dba, t, dataset_id, gene_annotations, s)
                s['loaded'].append(pid)  # Mark protein as loaded

                time.sleep(0.5)

            except requests.exceptions.RequestException as e:
                logger.error(f"RequestException occurred: {e}")
                logger.info("Pausing execution due to internet disconnection. Waiting for connectivity...")
                time.sleep(60)  # Wait for 1 minute before retrying

            except Exception as e:
                logger.error(f"An unexpected error occurred: {e}")
                continue

        print(f"Processed {ct} proteins")
        if skip_ct > 0:
            print(f"Skipped {skip_ct} proteins with no gene ID")
        print(f"Loaded NCBI annotations for {len(s['loaded'])} proteins")
        if len(s['retries']) > 0:
            print(f"Total targets remaining for retries: {len(s['retries'])}")

        # Retry loop
        loop = 1
        while len(s['retries']) > 0:
            print(f"Retry loop {loop}: Loading NCBI gene annotations for {len(s['retries'])} MKDEV proteins")
            logger.info(f"Retry loop {loop}: Loading NCBI gene annotations for {len(s['retries'])} MKDEV proteins")
            ct = 0
            act = 0
            retry_items = list(s['retries'].items())  # Create a list of (pid, _) tuples

            for pid, _ in retry_items:
                slmf.update_progress(ct / len(s['retries']))
                ct += 1
                p = dba.get_protein(pid)
                geneid = p['geneid']
                logger.info(f"Processing protein {pid}: gene ID {geneid}")

                try:
                    status, headers, xml = get_ncbigene(geneid)

                    if not status:
                        logger.warning(f"Failed to get gene ID {geneid}")
                        continue

                    if status != 200:
                        logger.warning(f"Bad API response for gene ID {geneid}")
                        continue

                    gene_annotations = parse_genexml(xml)

                    if not gene_annotations:
                        s['counts']['xml_err'] += 1
                        logger.error(f"XML error for gene ID {geneid}")
                        continue

                    load_annotations(dba, p, dataset_id, gene_annotations, s)
                    act += 1
                    del s['retries'][pid]
                    time.sleep(0.5)

                except requests.exceptions.RequestException as e:
                    logger.error(f"RequestException occurred: {e}")
                    logger.info("Pausing execution due to internet disconnection. Waiting for connectivity...")
                    time.sleep(60)  # Wait for 1 minute before retrying

                except Exception as e:
                    logger.error(f"An unexpected error occurred: {e}")
                    continue

            loop += 1
            if loop == 5:
                print("Completed 5 retry loops. Aborting.")
                break

            print(f"Processed {ct} proteins")
            print(f"Total annotated proteins: {act}")
            print(f"Total annotated proteins: {len(s['loaded'])}")
            if len(s['retries']) > 0:
                print(f"Total proteins remaining for retries: {len(s['retries'])}")

        print(f"Inserted {s['counts']['alias']} aliases")
        print(f"Inserted {s['counts']['summary']} NCBI Gene Summary tdl_infos")
        print(f"Inserted {s['counts']['summary']} NCBI Gene PubMed Count tdl_infos")
        print(f"Inserted {s['counts']['generif']} GeneRIFs")
        print(f"Inserted {s['counts']['pmxr']} PubMed xrefs")

        if s['counts']['xml_err'] > 0:
            print(f"WARNING: {s['counts']['xml_err']} XML parsing errors occurred. See logfile {logfile}")
        if s['counts']['dba_err'] > 0:
            print(f"WARNING: {s['counts']['dba_err']}. See logfile {logfile} for details.")

    except Exception as e:
        logger.error(f"An unexpected error occurred: {e}")
        raise

    finally:
        s.close()


def get_ncbigene(id):
    url = EFETCH_GENE_URL + str(id) + ".xml"
    r = None
    attempts = 0
    while attempts <= 5:
        try:
            r = requests.get(url)
            break
        except requests.exceptions.RequestException:
            attempts += 1
            time.sleep(2)

    if r:
        return r.status_code, r.headers, r.text
    else:
        return False, False, False


def parse_genexml(xml):
    annotations = {}
    soup = BeautifulSoup(xml, "xml")
    
    if not soup:
        return False

    try:
        g = soup.find('Entrezgene')
    except:
        return False

    if not g:
        return False

    comments = g.find('Entrezgene_comments')
    annotations['aliases'] = []

    if g.find('Gene-ref_syn'):
        for grse in g.find('Gene-ref_syn').findAll('Gene-ref_syn_E'):
            annotations['aliases'].append(grse.text)

    if g.find('Entrezgene_summary'):
        annotations['summary'] = g.find('Entrezgene_summary').text

    annotations['pmids'] =    []
    gcrefs = comments.find('Gene-commentary_refs')

    if gcrefs:
        annotations['pmids'] = set([pmid.text for pmid in gcrefs.findAll('PubMedId')])

    annotations['generifs'] = []

    for gc in comments.findAll('Gene-commentary', recursive=False):
        if gc.findChild('Gene-commentary_heading') and gc.find('Gene-commentary_heading').text == 'Interactions':
            continue

        gctype = gc.findChild('Gene-commentary_type')

        if gctype.attrs['value'] == 'generif':
            gctext = gc.find('Gene-commentary_text')

            if gctext:
                annotations['generifs'].append({'pubmed_ids': "|".join([pmid.text for pmid in gc.findAll('PubMedId')]),
                                                'text': gctext.text})

    return annotations


def load_annotations(dba, p, dataset_id, gene_annotations, shelf):
    pid = p['id']

    for a in gene_annotations['aliases']:
        rv = dba.ins_alias({'protein_id': pid, 'type': 'symbol', 'dataset_id': dataset_id, 'value': a})

        if rv:
            shelf['counts']['alias'] += 1
        else:
            shelf['counts']['dba_err'] += 1

    if 'summary' in gene_annotations:
        rv = dba.ins_tdl_info({'protein_id': pid, 'itype': 'NCBI Gene Summary', 'string_value': gene_annotations['summary']})

        if rv:
            shelf['counts']['summary'] += 1
        else:
            shelf['counts']['dba_err'] += 1

    if 'pmids' in gene_annotations:
        pmct = len(gene_annotations['pmids'])
    else:
        pmct = 0

    rv = dba.ins_tdl_info({'protein_id': pid, 'itype': 'NCBI Gene PubMed Count', 'integer_value': pmct})

    if rv:
        shelf['counts']['pmc'] += 1
    else:
        shelf['counts']['dba_err'] += 1

    for pmid in gene_annotations['pmids']:
        rv = dba.ins_xref({'protein_id': pid, 'xtype': 'PubMed', 'dataset_id': dataset_id, 'value': pmid})

        if rv:
            shelf['counts']['pmxr'] += 1
        else:
            shelf['counts']['dba_err'] += 1

    if 'generifs' in gene_annotations:
        for grd in gene_annotations['generifs']:
            grd['protein_id'] = pid
            rv = dba.ins_generif(grd)

            if rv:
                shelf['counts']['generif'] += 1
            else:
                shelf['counts']['dba_err'] += 1

    shelf['loaded'].append(pid)


if __name__ == '__main__':
    print(f"\n{PROGRAM} (v{__version__}) [{time.strftime('%c')}]:\n")
    start_time = time.time()

    args = docopt(__doc__, version=__version__)

    if args['--debug']:
        print(f"\n[*DEBUG*] ARGS:\n{args}\n")

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
    fmtr = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s', datefmt='%Y-%m-%d %H:%M:%S')
    fh.setFormatter(fmtr)
    logger.addHandler(fh)

    dba_params = {'dbname': args['--dbname'], 'dbhost': args['--dbhost'], 'pwfile': args['--pwfile'], 'logger_name': __name__}
    dba = DBAdaptor(dba_params)
    dbi = dba.get_dbinfo()

    logger.info(f"Connected to database {args['--dbname']} Schema_ver: {dbi['schema_ver']}, data ver: {dbi['data_ver']}")

    if not args['--quiet']:
        print(f"Connected to database {args['--dbname']} Schema_ver: {dbi['schema_ver']}, data ver: {dbi['data_ver']}")

    dataset_id = dba.ins_dataset({'name': 'NCBI Gene',
                                  'source': "EUtils web API at http://www.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=Gene&rettype=xml&id=",
                                  'app': PROGRAM, 'app_version': __version__,
                                  'url': 'http://www.ncbi.nlm.nih.gov/gene'})

    assert dataset_id, f"Error inserting data. For more info, see logfile: {logfile}"

    provs = [{'dataset_id': dataset_id, 'table_name': 'tdl_info', 'where_clause': "itype = 'NCBI Gene Summary'"},
             {'dataset_id': dataset_id, 'table_name': 'tdl_info', 'where_clause': "itype = 'NCBI Gene PubMed Count'"},
             {'dataset_id': dataset_id, 'table_name': 'generif'},
             {'dataset_id': dataset_id, 'table_name': 'xref', 'where_clause': f"dataset_id = {dataset_id}"},
             {'dataset_id': dataset_id, 'table_name': 'alias', 'where_clause': f"dataset_id = {dataset_id}"}]

    for prov in provs:
        rv = dba.ins_provenance(prov)
        assert rv, f"Error inserting the data into prov for {prov}"

    load(args, dba, dataset_id, logger, logfile)

    time_taken = time.time() - start_time
    print(f"\n{PROGRAM} done. Total time: {slmf.secs2str(time_taken)}")

