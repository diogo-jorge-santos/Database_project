#!/usr/bin/python3
import psycopg2, cgi
import login
form = cgi.FieldStorage()
#getvalue uses the names from the form in previous page
cni = form.getvalue('cni')
iso_code = form.getvalue('iso_code')
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
	sql1 = 'DELETE FROM boat_vhf WHERE cni = %s and iso_code= %s;'
	data1 = (cni, iso_code)
	# The string has the {}, the variables inside format() will replace the {}
	print('<p>{}</p>'.format(sql1 % data1))
	# Feed the data to the SQL query as follows to avoid SQL injection
	cursor.execute(sql1, data1)

	sql2 = 'DELETE FROM boat WHERE cni = %s and iso_code= %s;'
	data2 = (cni, iso_code)
	# The string has the {}, the variables inside format() will replace the {}
	print('<p>{}</p>'.format(sql2 % data2))
	# Feed the data to the SQL query as follows to avoid SQL injection
	cursor.execute(sql2, data2)
	# Commit the update (without this step the database will not change)
	connection.commit()

	# Closing connection
	print('<p><a href="boat.cgi">Go back</a></p>')
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
