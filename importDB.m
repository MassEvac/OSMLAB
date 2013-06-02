function [DataMat] = importDB(sqlquery)
% IMPORTDB(DBase, username, password)
% Imports data into MATLAB from a database.  Assumes database is called
% 'rsc'.
% 
% 
% INPUT: (optional)
%   DBase     string containing the name of the database you're connecting to
%   username  string of the database user's name
%   password  string with user's password
% OUTPUT:
%   DataMat   a matrix of the data in the table, in cell array format
%   selCols   a string containing all the column names in order
% POSTCONDITION:
%   prints out the column headings that were selected

javaclasspath('postgresql-9.2-1002.jdbc4.jar');

[~, name] = system('hostname');

%nargin = 1;

if (strcmp(name(1:13),'bharat-ubuntu'))
    DBase = 'osm';
    username = 'postgres'; %username = '';
    password = 'postgres'; %password = '';  
    databaseURL = 'jdbc:postgresql://localhost:5432/';
elseif (nargin == 1)
    DBase = 'osm';
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
%ping(reference);

% Open cursor and execute SQL statement.
% for some reason, 'select time from table' doesn't seem to work

connection=exec(reference, [sqlquery]);

disp(connection);

%% Fetch the first 10 rows of data.
%cursorA=fetch(cursorA, 10)
cursor=fetch(connection);
 
% Display the data.
DataMat = cursor.Data;

% Close the cursor and the connection.
close(cursor);
close(reference);