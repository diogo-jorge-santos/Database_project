
#!/usr/bin/python3
IST_ID = 'ist198529'
host = 'db.tecnico.ulisboa.pt'
port = 5432
password = '1234'
db_name = IST_ID
options="\"-c search_path=Project_3\""
credentials = 'host={} port={} user={} password={} dbname={}'.format(host, port, IST_ID, password, db_name)
credentials1 = 'host={} port={} user={} password={} dbname={} options={}'.format(host, port, IST_ID, password, db_name,options)
