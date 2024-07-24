import os
import obo
import mysql.connector
from urllib.request import urlretrieve

# Example CONFIG dictionary for demonstration purposes
CONFIG = [
    {
        'name': 'disease_ontology',
        'BASE_URL': 'https://raw.githubusercontent.com/DiseaseOntology/HumanDiseaseOntology/main/src/ontology/',
        'FILENAME': 'doid.obo',
        'DOWNLOAD_DIR': '../data/do'
    }
]

# Database Configuration
db_config = {
    'host': 'localhost',
    'user': 'root',
    'password': '********',
    'database': 'S24_BIRD'
}

def download(name):
    try:
        cfg = next(d for d in CONFIG if d['name'] == name)
    except StopIteration:
        print(f"No configuration found for {name}")
        return None

    # Ensure the download directory exists
    os.makedirs(cfg['DOWNLOAD_DIR'], exist_ok=True)
    fn = os.path.join(cfg['DOWNLOAD_DIR'], cfg['FILENAME'])
    
    # If file already exists, remove it before downloading a fresh copy
    if os.path.exists(fn):
        os.remove(fn)
        print(f"Existing file {fn} removed.")
    
    url = cfg['BASE_URL'] + cfg['FILENAME']
    
    print(f"\nDownloading {url} to {fn}")
    
    # Download the file
    try:
        urlretrieve(url, fn)
        print("Download complete.")
        return fn
    except Exception as e:
        print(f"Error downloading the file: {e}")
        return None

def parse_doid(fn):
    if not fn:
        print("No file to parse")
        return None

    print(f"Parsing do file {fn}")
    parser = obo.Parser(fn)
    raw_doid = {}
    for stanza in parser:
        if stanza.name != 'Term':
            continue
        raw_doid[stanza.tags['id'][0].value] = stanza.tags
    # mondod = {}

    doid_dict = {}
    for do_id ,dd in raw_doid.items():
        if 'name' not in dd:
            continue
        init = {'doid': do_id, 'name': dd['name'][0].value}
        if 'def' in dd:
            init['def'] = dd['def'][0].value
        if 'is_a' in dd:
            init['parents'] = dd['is_a'][0].value
        if 'xref' in dd:
            init['xrefs'] = []
            for xref in dd['xref']:
                if xref.value.startswith('http') or xref.value.startswith('url'):
                    continue
                (db, val) = xref.value.split(':')
                init['xrefs'].append({'db': db, 'value': val})
        doid_dict[do_id] = init 
        # print("  Got {} do terms".format(len(doid_dict)))
    return doid_dict

def load_do(parsed_data):
    try:
        conn = mysql.connector.connect(**db_config)
        cursor = conn.cursor()
        insert_query = """
        INSERT INTO do (doid, name, def)
        VALUES (%s, %s, %s)
        """

        insert_query2="""INSERT INTO do_parent(doid,parent_id) VALUES (%s,%s)"""

        insert_query3="""INSERT INTO do_xref(doid,db,value) VALUES (%s,%s,%s)"""
        xref_cnt = 1
        
        for doid, data in parsed_data.items():
            doid_val = data.get('doid', None)
            name_val = data.get('name', None)
            def_val = data.get('def', None)
            

            # Inserting data into the table
            cursor.execute(insert_query, (doid_val, name_val, def_val))

            parents_val=data.get('parents','Null')
            
            
            cursor.execute(insert_query2,(doid_val,parents_val))

            xref_val = data.get('xrefs',None)

            if xref_val is not None:
                for dict1 in xref_val:
                   # "equiv" is in dict['source']? equiv_to=1:equiv_to=0
                    # if "equiv" in str(dict1['source']):
                    #     equiv_to=1
                    # else:
                    
                    #if xref_cnt==1:
                        #print(xref_val)
                        #print(type(xref_val))
                        #print(dict1)
                        #print(type(dict1))
                        #print(dict1['source'])
                        #print(type(dict1['source']))
                        #print(dict1.keys())
                    
                    # s1 = 'NULL'  
                    # if 'source' in dict1.keys():
                    #     if "equiv" in dict1['source']:
                    #         equiv_to=1
                    #     else:
                    #         equiv_to=0
                    #     s1 = dict1['source']
                    # dict['db']
                    # dict['val']
                    # dict['source']
                    cursor.execute(insert_query3,(doid_val, dict1['db'], dict1['value']))
                  

        # Commit the transaction
        conn.commit()
        print("Data inserted successfully.")
    except mysql.connector.Error as err:
        print(f"Error: {err}")
    finally:
        if conn.is_connected():
            cursor.close()
            conn.close()
            print("Database connection closed.")

if __name__ == '__main__':
    fn = download('disease_ontology')
    if fn:
        parsed_data = parse_doid(fn)
        if parsed_data:
            load_do(parsed_data)
        else:
            print("Failed to parse the file")
    else:
        print("Failed to download the file")