#!/usr/bin/python3
import psycopg2
import login
print('Content-type:text/html\n\n')
print('<html>')
print('<head>')
print('<title>Lab 09</title>')
print('</head>')
print('<body>')
print('<h3>Sailor</h3>')
connection = None
try:
	# Creating connection
	print('<h3>Create sailor:</h3>')
	print('<form action="create_sailor.cgi" method="post">')
	print('<p>Name: <input type="text" name="name"/></p>')
	print('<p>id: <input type="int" name="id"/></p>')
	print('<p>iso_code: <input type="text" name="iso_code"/></p>')
	print('<p><input type="submit" value="Submit"/></p>')
	print('</form>')
	connection = psycopg2.connect(login.credentials)
	cursor = connection.cursor()
	# Making query
	cursor.execute("SET search_path TO 'Project_3';")
	sql = """
	SELECT p.name,p.id,p.iso_code
	from person p inner join sailor o
	on (p.id=o.id and p.iso_code=o.iso_code);
	;"""
	cursor.execute(sql)
	result = cursor.fetchall()
	num = len(result)
	# Displaying results
	print('<table border="0" cellspacing="5">')
	print('<tr><td>name</td><td>id</td><td>iso_code</td></tr>')
	for row in result:
		print('<tr>')
		for value in row:
			# The string has the {}, the variables inside format() will replace the {}
			print('<td>{}</td>'.format(value))
		print('<td><a href="sailor_delete.cgi?id={};iso_code={}">Delete</a></td>'.format(row[1],row[2]))
		print('</tr>')
	print('</table>')
	print('<p><a href="app.cgi">Go back</a></p>')
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
