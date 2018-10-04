Use remote sql connector as follow

		1. Print help 
			ruby sql_client.rb --help

		2. Enter following command and Enter database details one by one. 
			ruby sql_client.rb

		3. Enter following start command with all database details
			ruby sql_client.rb -host 52.7.111.111 -port 3306 -username root -password root -database mydb

		and then enter valid sql command to get results. If any database details missing then system ask for it.

		Enter 'exit' to exit from sql ruby client