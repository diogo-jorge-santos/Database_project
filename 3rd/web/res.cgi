#!/usr/bin/python3
import psycopg2
import login
print('Content-type:text/html\n\n')
print('<html>')
print('<head>')
print('<title>Lab 09</title>')
print('</head>')
print('<body>')
print('<h3>Reservation</h3>')
connection = None
try:
	# Creating connection
	print('<h3>Create Resevation:</h3>')
	print('<form action="create_res.cgi" method="post">')
	print('<p>cni: <input type="text" name="cni"/></p>')
	print('<p>iso_code_boat: <input type="text" name="iso_code_boat"/></p>')
	print('<p>id_sailor: <input type="text" name="id_sailor"/></p>')
	print('<p>iso_code_sailor: <input type="text" name="iso_code_sailor"/></p>')
	print('<p>start_date: <input type="date" name="start_date"/></p>')
	print('<p>end_date: <input type="date" name="end_date"/></p>')


	print('<p><input type="submit" value="Submit"/></p>')
	print('</form>')
	connection = psycopg2.connect(login.credentials)
	cursor = connection.cursor()
	# Making query
	cursor.execute("SET search_path TO 'Project_3';")
	sql = """
	SELECT * from reservation;
	;"""
	cursor.execute(sql)
	result = cursor.fetchall()
	num = len(result)
	# Displaying results
	print('<table border="0" cellspacing="5">')
	print('<tr><td>cni</td><td>iso_code_boat</td><td>id_sailor</td><td>iso_code_sailor</td><td>start_date</td><td>end_date</td></tr>')
	for row in result:
		print('<tr>')
		for value in row:
			# The string has the {}, the variables inside format() will replace the {}
			print('<td>{}</td>'.format(value))
		print('<td><a href="res_delete.cgi?cni={};iso_code_boat={};id_sailor={};iso_code_sailor={};start_date={};end_date={}  ">Delete</a></td>'.format(row[0],row[1],row[2],row[3],row[4],row[5]))
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
