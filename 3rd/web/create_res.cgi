#!/usr/bin/python3
import psycopg2, cgi
import login
form = cgi.FieldStorage()
#getvalue uses the names from the form in previous page
cni = form.getvalue('cni')
iso_code_boat = form.getvalue('iso_code_boat')
id_sailor = form.getvalue('id_sailor')
iso_code_sailor = form.getvalue('iso_code_sailor')
start_date = form.getvalue('start_date')
end_date = form.getvalue('end_date')


print('Content-type:text/html\n\n')
print('<html>')
print('<head>')
print('<title>Lab 09</title>')
print('</head>')
print('<body>')
connection = None
try:
	# Creating connection
	connection = psycopg2.connect(login.credentials)
	cursor = connection.cursor()
	cursor.execute("SET search_path TO 'Project_3';")

	# Making query

	sql1='INSERT INTO schedule VALUES (%s, %s) ON CONFLICT DO NOTHING;'
	#ON CONFlIT DO NOTHING - recommended way in the documentation to do a "insert if not in" in posgree 
	data1 = (start_date, end_date)
	# The string has the {}, the variables inside format() will replace the {}
	print('<p>{}</p>'.format(sql1 % data1))
	# Feed the data to the SQL query as follows to avoid SQL injection
	cursor.execute(sql1, data1)

	sql2='INSERT INTO reservation VALUES (%s, %s, %s,%s,%s,%s);'
	data2 = (cni,iso_code_boat,id_sailor,iso_code_sailor,start_date,end_date)
	# The string has the {}, the variables inside format() will replace the {}
	print('<p>{}</p>'.format(sql2 % data2))
	# Feed the data to the SQL query as follows to avoid SQL injection
	cursor.execute(sql2, data2)

	print('<p><a href="res.cgi">Go back</a></p>')
	
	# Commit the update (without this step the database will not change)
	connection.commit()
	# Closing connection
	cursor.close()
except Exception as e:
	# Print errors on the webpage if they occur
	print('<h1>An error occurred.</h1>')
	print('<p>{}</p>'.format(e))
finally:
	if connection is not None:
		connection.close()
print('</body>')
print('</html>')
