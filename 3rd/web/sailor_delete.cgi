#!/usr/bin/python3
import psycopg2, cgi
import login
form = cgi.FieldStorage()
#getvalue uses the names from the form in previous page
id = form.getvalue('id')
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
	sql = 'DELETE FROM sailor WHERE id = %s and iso_code= %s;'
	data = (id, iso_code)
	# The string has the {}, the variables inside format() will replace the {}
	print('<p>{}</p>'.format(sql % data))
	# Feed the data to the SQL query as follows to avoid SQL injection
	cursor.execute(sql, data)
	# Commit the update (without this step the database will not change)
	connection.commit()
	print('<p><a href="sailor.cgi">Go back</a></p>')
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
