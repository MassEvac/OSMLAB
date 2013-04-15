function [p]=fileorquery(f,q)
if exist(f,'file')
    p = csvread(f);
else    
    p = cell2mat(importDB(q));
    csvwrite(f,p);
end