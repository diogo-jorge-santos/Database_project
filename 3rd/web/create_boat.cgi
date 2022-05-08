#!/usr/bin/python3
import psycopg2, cgi
import login
form = cgi.FieldStorage()
#getvalue uses the names from the form in previous page
name = form.getvalue('name')
year = form.getvalue('year')
cni=form.getvalue('cni')
iso_code=form.getvalue('iso_code')
id_owner=form.getvalue('id_owner')
iso_code_owner=form.getvalue('iso_code_owner')

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

	sql1='INSERT INTO boat VALUES (%s, %s, %s,%s,%s,%s);'
	data1 = (name,year,cni,iso_code,id_owner,iso_code_owner)
	# The string has the {}, the variables inside format() will replace the {}
	print('<p>{}</p>'.format(sql1 % data1))
	# Feed the data to the SQL query as follows to avoid SQL injection
	cursor.execute(sql1, data1)

	connection.commit()
	# Closing connection
	cursor.close()
	print('<p><a href="boat.cgi">Go back</a></p>')

except Exception as e:
	# Print errors on the webpage if they occur
	print('<h1>An error occurred.</h1>')
	print('<p>{}</p>'.format(e))
finally:
	if connection is not None:
		connection.close()
print('</body>')
print('</html>')
