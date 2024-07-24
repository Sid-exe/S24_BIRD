
import mysql.connector
from mysql.connector import Error
from mysql.connector import errorcode
from contextlib import closing
import logging
from TCRD.Create import CreateMethodsMixin
from TCRD.Read import ReadMethodsMixin
from TCRD.Update import UpdateMethodsMixin
from TCRD.Delete import DeleteMethodsMixin
  
class DBAdaptor(CreateMethodsMixin, ReadMethodsMixin, UpdateMethodsMixin, DeleteMethodsMixin):
  # Default config
  _LogFile = 'home/dhanush/tcrd/log/'  
  _LogLevel = logging.WARNING

  _db_config = {
    'host': 'localhost',
    'user': 'root',
    'password': '*******',
    'database': 'S24_BIRD'
  }

  def __init__(self, init):
    # Logging
    if 'logger_name' in init:
      # use logger from calling module
      ln = init['logger_name'] + '.auxiliary.DBAdaptor'
      self._logger = logging.getLogger(ln)
    else:
      if 'logfile' in init:
        lfn = init['logfile']
      else:
        lfn = self._LogFile
      if 'loglevel' in init:
        ll = init['loglevel']
      else:
        ll = self._LogLevel
      self._logger = logging.getLogger(__name__)
      self._logger.propagate = False # turns off console logging
      fh = logging.FileHandler(lfn)
      self._logger.setLevel(ll)
      fmtr = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s: %(message)s', datefmt='%Y-%m-%d %H:%M:%S')
      fh.setFormatter(fmtr)
      self._logger.addHandler(fh)

    self._logger.debug('Instantiating new TCRD DBAdaptor')
    self._connect()
      
    self._cache_info_types()
    self._cache_xref_types()
    self._cache_expression_types()
    self._cache_phenotype_types()

  def __del__(self):
    self._conn.close()
    self._logger.debug('connection closed')

  def get_dbinfo(self):
    self._logger.debug('get_dbinfo() entry')
    sql = 'SELECT * FROM dbinfo'
    self._logger.debug('creating cursor')
    try:
      cur = self._conn.cursor(dictionary=True)
    except Error as e:
      self._logger.error(f"Error creating cursor: {e}")
    self._logger.debug(f"executing query: '{sql}'")
    try:
      cur.execute(sql)
    except Error as e:
      self._logger.error(f"Error executing query: {e}")
    self._logger.debug("fetching data")
    try:
      row = cur.fetchone()
    except Error as e:
      self._logger.error(f"Error fetching data: {e}")
    cur.close()
    return row

  #
  # Private Methods
  #
  def _connect(self):
    '''
    Function  : Connect to a SR24_BIRD database
    Arguments : N/A
    Returns   : N/A
    Scope     : Private
    Comments  : Database connection object is stored as private instance variable
    '''
    try:
      self._conn = mysql.connector.connect(**self._db_config, charset='utf8')
    except Error as e:
      if e.errno == errorcode.ER_ACCESS_DENIED_ERROR:
        self._logger.error("Error connecting to MySQL: Bad user name or password")
      elif e.errno == errorcode.ER_BAD_DB_ERROR:
        self._logger.error("Error connecting to MySQL: Database does not exist")
      else:
        self._logger.error(f"Error connecting to MySQL: {e}")
    self._logger.debug(f"Successful connection to database {self._db_config['database']}: {self._conn}")

  def _cache_info_types(self):
    if hasattr(self, '_info_types'):
        return
    else:
      with closing(self._conn.cursor()) as curs:
        curs.execute("SELECT name, data_type FROM info_type")
        self._info_types = {}
        for it in curs:
          k = it[0]
          t = it[1]
          if t == 'String':
            v = 'string_value'
          elif t == 'Integer':
            v = 'integer_value'
          elif t == 'Number':
            v = 'number_value'
          elif t == 'Boolean':
            v = 'boolean_value'
          elif t == 'Date':
            v = 'date_value'
          self._info_types[k] = v

  def _cache_xref_types(self):
    if hasattr(self, '_xref_types'):
        return
    else:
      with closing(self._conn.cursor()) as curs:
        curs.execute("SELECT name FROM xref_type")
        self._xref_types = []
        for xt in curs:
          self._xref_types.append(xt[0])

  def _cache_expression_types(self):
    if hasattr(self, '_expression_types'):
        return
    else:
      with closing(self._conn.cursor()) as curs:
        curs.execute("SELECT name, data_type FROM expression_type")
        self._expression_types = {}
        for ex in curs:
          k = ex[0]
          t = ex[1]
          if t == 'String':
            v = 'string_value'
          elif t == 'Number':
            v = 'number_value'
          elif t == 'Boolean':
            v = 'boolean_value'
          self._expression_types[k] = v

  def _cache_phenotype_types(self):
    if hasattr(self, '_gene_phenotype_types'):
        return
    else:
      with closing(self._conn.cursor()) as curs:
        curs.execute("SELECT name FROM phenotype_type")
        self._phenotype_types = []
        for row in curs:
          self._phenotype_types.append(row[0])

if __name__ == '__main__':
  dba = DBAdaptor({'loglevel': 10, 'logfile': './TCRD-DBA.log'})
  dbi = dba.get_dbinfo()
  print("DBInfo: {}\n".format(dbi))
