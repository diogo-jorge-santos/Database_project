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
	sql = 'DELETE FROM reservation WHERE cni = %s and iso_code_boat= %s and id_sailor=%s and iso_code_sailor=%s and start_date=%s and end_date=%s;'
	data = (cni,iso_code_boat,id_sailor,iso_code_sailor,start_date,end_date)
	# The string has the {}, the variables inside format() will replace the {}
	print('<p>{}</p>'.format(sql % data))
	# Feed the data to the SQL query as follows to avoid SQL injection
	cursor.execute(sql, data)
	# Commit the update (without this step the database will not change)
	connection.commit()
	print('<p><a href="res.cgi">Go back</a></p>')
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
