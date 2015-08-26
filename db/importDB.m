function [DataMat] = importDB(sqlquery,DBase)
% Imports data into MATLAB from a database.  Assumes database is called 'osm'.
% 
% INPUT:
%   DBase     string containing the name of the database you're connecting to
% OUTPUT:
%   DataMat   a matrix of the data in the table, in cell array format
%   selCols   a string containing all the column names in order
% EXAMPLE:
%   test = importDB('SELECT a');
%   Should return 'cursor object: 1-by-1'
% POSTCONDITION:
%   prints out the column headings that were selected

javaclasspath('./db/postgresql-9.2-1002.jdbc4.jar');

[~, name] = system('hostname');

if (strcmp(name(1:8),'IT050339'))
    username = 'bk12369'; %username = '';
    password = 'postgres'; %password = '';  
    databaseURL = 'jdbc:postgresql://localhost:5432/';
else
    username = 'bharatkunwar'; %username = '';
    password = ''; %password = '';
    databaseURL = 'jdbc:postgresql://localhost:5432/';    
end

% Set maximum time allowed for establishing a connection.
setdbprefs('DataReturnFormat','cellarray');
% Connect to the RSC database via JDBC
reference=database(DBase, username, password,...
               'org.postgresql.Driver', databaseURL);          
           
% Check the database status.
% ping(reference);

% Open cursor and execute SQL statement.
% for some reason, 'select time from table' doesn't seem to work

connection=exec(reference, [sqlquery]);

disp(connection);
disp(connection.Message);

%% Fetch the first 10 rows of data.
%cursorA=fetch(cursorA, 10)
cursor=fetch(connection);
 
% Display the data.
DataMat = cursor.Data;

% Close the cursor and the connection.
close(cursor);
close(reference);