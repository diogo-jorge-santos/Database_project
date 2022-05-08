#!/usr/bin/python3
import psycopg2, cgi
import login
form = cgi.FieldStorage()
#getvalue uses the names from the form in previous page
id = form.getvalue('id')
iso_code = form.getvalue('iso_code')
name=form.getvalue('name')
birthdate=form.getvalue('birthdate')
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

	sql1='INSERT INTO person VALUES (%s, %s, %s) ON CONFLICT DO NOTHING;'
	data1 = (id,name, iso_code)
	# The string has the {}, the variables inside format() will replace the {}
	print('<p>{}</p>'.format(sql1 % data1))
	# Feed the data to the SQL query as follows to avoid SQL injection
	cursor.execute(sql1, data1)


	sql2='INSERT INTO owner VALUES (%s, %s, %s);'
	data2 = (id, iso_code,birthdate)
	# The string has the {}, the variables inside format() will replace the {}
	print('<p>{}</p>'.format(sql2 % data2))
	# Feed the data to the SQL query as follows to avoid SQL injection
	cursor.execute(sql2, data2)
	# Commit the update (without this step the database will not change)
	print('<p><a href="owner.cgi">Go back</a></p>')
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
