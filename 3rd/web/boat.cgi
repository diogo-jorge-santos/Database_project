#!/usr/bin/python3
import psycopg2
import login
print('Content-type:text/html\n\n')
print('<html>')
print('<head>')
print('<title>Lab 09</title>')
print('</head>')
print('<body>')
print('<h3>Boat</h3>')
connection = None
try:
	# Creating connection
	print('<h3>Create boat:</h3>')
	print('<form action="create_boat.cgi" method="post">')
	print('<p>Name: <input type="text" name="name"/></p>')
	print('<p>year: <input type="int" name="year"/></p>')
	print('<p>cni: <input type="text" name="cni"/></p>')
	print('<p>iso_code: <input type="text" name="iso_code"/></p>')
	print('<p>id_owner: <input type="text" name="id_owner"/></p>')
	print('<p>iso_code_owner: <input type="text" name="iso_code_owner"/></p>')
	print('<p><input type="submit" value="Submit"/></p>')
	print('</form>')

	print('<h3>Create boat with vhf:</h3>')
	print('<form action="create_boat_vhf.cgi" method="post">')
	print('<p>Name: <input type="text" name="name"/></p>')
	print('<p>year: <input type="int" name="year"/></p>')
	print('<p>cni: <input type="text" name="cni"/></p>')
	print('<p>iso_code: <input type="text" name="iso_code"/></p>')
	print('<p>id_owner: <input type="text" name="id_owner"/></p>')
	print('<p>iso_code_owner: <input type="text" name="iso_code_owner"/></p>')
	print('<p>mmsi: <input type="int" name="mmsi"/></p>')


	print('<p><input type="submit" value="Submit"/></p>')
	print('</form>')
	connection = psycopg2.connect(login.credentials)
	cursor = connection.cursor()
	# Making query
	cursor.execute("SET search_path TO 'Project_3';")
	sql = """
	SELECT b.name,b.year,b.cni, b.iso_code,b.id_owner,b.iso_code_owner,v.mmsi
	from boat b left join boat_vhf v
	on (b.cni=v.cni and b.iso_code=v.iso_code);
	;"""
	cursor.execute(sql)
	result = cursor.fetchall()
	num = len(result)
	# Displaying results
	print('<table border="0" cellspacing="5">')
	print('<tr><td>name</td><td>year</td><td>cni</td><td>iso_code</td><td>id_owner</td><td>iso_code_owner</td><td>mmsi</td></tr>')
	for row in result:
		print('<tr>')
		for value in row:
			# The string has the {}, the variables inside format() will replace the {}
			print('<td>{}</td>'.format(value))
		print('<td><a href="boat_delete.cgi?cni={};iso_code={}">Delete</a></td>'.format(row[2],row[3]))
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
