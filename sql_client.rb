#!/usr/bin/env ruby
require 'mysql2'

=begin
	Use remote sql connector as follow

		1. Print help 
			ruby sql_client.rb --help

		2. Enter following command and Enter database details one by one. 
			ruby sql_client.rb

		3. Enter following start command with all database details
			ruby sql_client.rb -host 52.7.111.111 -port 3306 -username root -password root -database mydb

		and then enter valid sql command to get results. If any database details missing then system ask for it.

		Enter 'exit' to exit from sql ruby client
=end

# MysqlConnector wrapper class to create connection using mysql2 library
class MysqlConnector

	def initialize(db_details)
		puts "Initializing db details..."
		@db_details = {
			:host 		=> db_details[:host],
			:port 		=> db_details[:port],
			:username 	=> db_details[:username],
			:password 	=> db_details[:password],
			:database 	=> db_details[:database]
		}
	end

	# Check all values passed are valid and not empty
	# Connect to remote server database and return connection object
	def connect
		@db_details.each do |key, value|
			if value.empty?
				puts "Invalid value for #{key}"
				return false
			end
		end

		puts "Connecting to mysql server using following data..."
		puts @db_details

		Mysql2::Client.new(@db_details)
	end

	# Close connection from remote server
	def close(client)
		puts "Closing mysql connection..."
		client.close
		puts "Closed..."
	end
end

# Simple commend line help displayed when 'ruby sql_client.rb --help' command given
def print_help
	puts '################################### SQL Client ###################################
		Use remote sql connector as follow

		1. Print help 
			ruby sql_client.rb --help

		2. Enter following command and Enter database details one by one. 
			ruby sql_client.rb

		3. Enter following start command with all database details
			ruby sql_client.rb -host 52.7.111.111 -port 3306 -username root -password root -database mydb

		and then enter valid sql command to get results. If any database details missing then system ask for it.

		Enter \'exit\' to exit from sql ruby client
		####################################################################################'
	exit(true)
end

# Find all db details passed from command
# If not passed from command then collect from user using console input
def get_db_details(argv)

	db_details = {
		:host 		=> nil,
		:port 		=> nil,
		:username 	=> nil,
		:password 	=> nil,
		:database 	=> nil
	}
	# Get if passed as console arguments
	argv.each_cons(2) do|arg1, arg2|
		case arg1
		when '-host'
			db_details[:host] = arg2
		when '-port'
			db_details[:port] = arg2
		when '-username'
			db_details[:username] = arg2
		when '-password'
			db_details[:password] = arg2
		when '-database'
			db_details[:database] = arg2
		end
	end

	# Check if all db details given. If not then take from user
	db_details.each do |key, value|
		if value.nil?
			puts "Please enter valid #{key}"
			db_details[key] = $stdin.gets.chomp
		end
	end
	db_details
end

# Get db details from user
# Connect to remote server
# Get sql command from user and execute
# Print sql command result 
# If exit command given then exit the process
begin
	print_help if ARGV[0] == '--help'

	db_details = get_db_details(ARGV)
	@connector = MysqlConnector.new(db_details)
	client = @connector.connect()

	unless client
		puts 'Unable to connect database with given details'
		exit(true)
	end

	while 1
		puts '\nPlease enter valid sql query. Or enter \'exit\' to quit'
		query_str = $stdin.gets.chomp
		
		if query_str == 'exit'
			# close mysql connection before exit
			@connector.close(client)
			exit(true)
		end

		results = client.query(query_str)

		puts 'SQL result >>>>>>>>>> \n'
		results.each do |row|
		  puts row
		end
	end

rescue SystemExit => e
	puts 'Exiting process...'
rescue Exception => e
	puts "#{e.class}: #{e.message}"
	puts e.backtrace.join("\n")
end