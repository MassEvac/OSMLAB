    b = 1.5;
    
    for i = 1:nOD
        % calculating the original shortest path
        for j = 1:nOD
            if (i ~= j)
                [SP(i,j),path]=graphshortestpath(DAM,od(i),od(j));
                this = D(i,j);
                L = b * this; % Longest path distance
                % duplicate the adjacency matrix so that
                % the edges with the minimal flow can be removed
                dDAM = DAM;
                isolatedAM = spalloc(nAM,nAM,0);
                while (this < L || this ~= Inf)
                    origin=path(1:end-1);
                    destin=path(2:end);
                    nThis = length(origin);
                    
                    % clear this AM
                    thisAM = spalloc(nAM,nAM,0);
    
                    for k = 1:nThis
                        % copy the edges to a new sparse matrix for use in Ford
                        % Fulkerson algorithm                
                        thisAM(origin(k),destin(k)) = AM(origin(k),destin(k));
                        isolatedAM(origin(k),destin(k)) = thisAM(origin(k),destin(k));
                    end
                    
                    % extract the values of this AM
                    [~,~,o]=find(thisAM);
                    % find the maximum values of this AM
                    [m,n]=find(thisAM==max(o));
                    % remove the maximum values from this AM
                    dDAM(m,n)=0;
                    % recalculate the shortest path and the nodes from the path
                    [this,path]=graphshortestpath(dDAM,od(i),od(j));
                end
                MF(i,j)=max_flow(isolatedAM,od(i),od(j));
                disp([num2str((i-1+j/nOD)/nOD*100) '%']);
            end
        end
        %disp([num2str(i/nOD*100) '%']);
    end
    toc;   