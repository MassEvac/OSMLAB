function [p]=getFileOrQuery(f,q,varargin)
if exist(f,'file')
    p = csvread(f);
else
    p = importDB(q);
    
    if (nargin > 2)
        if (strmatch(varargin{1},'highway'))
            highways = varargin{2};
            highwayType = varargin{3};
            v=p(:,4);
            p(:,4)=cellfun(@(x) highwayType(strmatch(x,highways,'exact')),p(:,4),'UniformOutput',false);
            pp=cellfun(@isempty,p(:,4));
            [i,j] = find(pp);
            if(i)
                disp('Omitting the following tags:');
                disp(unique(v(i)));
                p(i,:)=[];
            end
        end
    end

    %cell2num = @(x) reshape(cat(1,x{:}), size(x));
    
    p = cell2mat(p);
    dlmwrite(f, p, 'delimiter', ',', 'precision', 10); 
    
end