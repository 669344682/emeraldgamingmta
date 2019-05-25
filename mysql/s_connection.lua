--[[
 _____                         _     _   _____                 _             
|  ___|                       | |   | | |  __ \               (_)            
| |__ _ __ ___   ___ _ __ __ _| | __| | | |  \/ __ _ _ __ ___  _ _ __   __ _ 
|  __| '_ ` _ \ / _ \ '__/ _` | |/ _` | | | __ / _` | '_ ` _ \| | '_ \ / _` |
| |__| | | | | |  __/ | | (_| | | (_| | | |_\ \ (_| | | | | | | | | | | (_| |
\____/_| |_| |_|\___|_|  \__,_|_|\__,_|  \____/\__,_|_| |_| |_|_|_| |_|\__, |
																		__/ |
																	   |___/ 
______ _____ _      ___________ _       _____   __                           
| ___ \  _  | |    |  ___| ___ \ |     / _ \ \ / /                           
| |_/ / | | | |    | |__ | |_/ / |    / /_\ \ V /                            
|    /| | | | |    |  __||  __/| |    |  _  |\ /          Created by                   
| |\ \\ \_/ / |____| |___| |   | |____| | | || |         Zil & Skully          
\_| \_|\___/\_____/\____/\_|   \_____/\_| |_/\_/                             
																			 
Copyright of the Emerald Gaming Development Team, do not distribute - All rights reserved.]]

local serverIP = "localhost" -- IP address of server, leave if database is running on the same host as server.
local username ="root" -- Database username.
local password =  "password" -- Database password.
local database = "emerald" -- Database name.
local port = 3306 -- MySQL port, usually does not need to be changed.

--[[==================== DO NOT TOUCH BELOW UNLESS YOU KNOW WHAT YOU ARE DOING! ========================
======================== DO NOT TOUCH BELOW UNLESS YOU KNOW WHAT YOU ARE DOING! ========================
======================== DO NOT TOUCH BELOW UNLESS YOU KNOW WHAT YOU ARE DOING! ========================]]

local hostname = "dbname=" .. database .. ";host=" .. serverIP .. ";"

local MySQLConnection = nil

-- connectToDatabase - Internal function, used to connect to the database when resource starts.
function connectToDatabase(res)
	MySQLConnection = dbConnect("mysql", hostname, username, password, "share=0")
	print("[MYSQL] Opening connection to MySQL database..")
	
	if (MySQLConnection) then -- If the connect exists and was successful.
		print("[MYSQL] Connection to the MySQL database was successfully established!")
	elseif (not MySQLConnection) then -- If there is no mySQL connection made.
		cancelEvent(true, "[MYSQL] FATAL ERROR: Failed connect to the database!")
		print("[MYSQL] FATAL ERROR: Failed to connect to MySQL database!")
		return nil
	end
	return nil
end
addEventHandler("onResourceStart", resourceRoot, connectToDatabase, false)
	
-- destroyDatabaseConnection - Internal function, kills the active database connection if one is active.
function destroyDatabaseConnection()
	if (not MySQLConnection) then -- if there is no mySQL connection then happy days, don't need to destroy anything! :D
		return nil
	end
	destroyElement(MySQLConnection)
	print("[MYSQL] Closed connection to MySQL database.")
	return nil
end
addEventHandler("onResourceStop", resourceRoot, destroyDatabaseConnection, false)

-- Used to run SQL queries and polls the result.
function Query(...)
	if MySQLConnection then
		local query = dbQuery(MySQLConnection, ...)
		local result = dbPoll(query, -1)
		return result
	else
		outputDebugString("@Query: Failed to execute query, no MySQL connection is active.", 3)
		return false
	end
end

-- Runs a database query and returns the first result from the table.
function QuerySingle(str, ...)
	if MySQLConnection then
		local result = Query(str, ...)
		if (type(result) == 'table') then
			return result[1]
		end
	else
		outputDebugString("@QuerySingle: Failed to execute query, no MySQL connection is active.", 3)
		return false
	end
end

-- Executes the query given.
function Execute(str, ...)
	if MySQLConnection then
		local query = dbExec(MySQLConnection, str, ...)
		return query
	else
		outputDebugString("@Execute: Failed to execute query, no MySQL connection is active.", 3)
		return false
	end
end

-- Runs the query and returns the result as a string.
function QueryString(query, ...)
	if MySQLConnection then
		local query = dbQuery(MySQLConnection, query, ...)
		local result = dbPoll(query, -1)
		
		if result then
			for rid, row in pairs (result) do
				for column, value in pairs (row) do
					return value -- returns the result as a string
				end
			end
		else
			outputDebugString("@QueryString: Failed to execute query, no MySQL connection is active.", 3)
			return false
		end
	end
end

-- Takes the given result and turns it into a string output.
function Poll(result)
	if result then
		local answer = dbPoll(result, -1)
		
		for rid, row in pairs (answer) do
			for column, value in pairs (row) do
				return value -- returns the result as a string.
			end
		end
	else
		outputDebugString("[FATAL] @Poll: Failed to poll result, no result received.", 3)
		return false
	end
end

-- Returns the active mySQL connection.
function getConnection() if MySQLConnection then return MySQLConnection else return false end end