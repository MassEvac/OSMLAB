load('AMcities');
[a,b] = size(AMcities);

% Delete the nominated cities
% for i = 1:a
%     dir = strcat('./cache/highway/',AMcities{i,1});
%     disp(dir);
%     try
%         rmdir(dir);
%     catch err
%     end
% end

nonExistent = {};

for i = 1:a
    % It seems that the global DBase has to be defined here because
    % javaclasspath seems to keep clearing the global variables
    DBase = AMcities{i,2};

    try        
        getAM(AMcities{i,1},true);
    catch err
        nonExistent = [nonExistent AMcities{i,1}];
    end
end

for i = 1:length(nonExistent);
    dir = ['./cache/highway/' DBase '/' nonExistent{i}];
    disp(dir);
    try
        rmdir(dir);
    catch err
    end
end