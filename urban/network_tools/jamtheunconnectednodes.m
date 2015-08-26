function [HAM,DAM,nodes]=jamtheunconnectednodes(HAM,DAM,nodes,nodenumber)

x=graphtraverse(HAM,nodenumber); % x is a node list of all connected nodes
y=length(HAM)-length(x); % y is the number of unconnected nodes
disp(['Number of unconnected nodes = ' num2str(y)]);
nodestoremove=1:length(nodes); %set up a list of all nodes

   %for i=1:(nodestoremove);
   %   nodestoremove(x(i))=[]; % remove connected nodes from list
   %end
   %disp(nodestoremove);
   % for j=1:nodesto
   %if nodestoremove(j)==0
   %     nodestoremove(j)=[];
   % end
    
   %making a list of unconnected nodes
   ind=graphtraverse(HAM,nodenumber);
   A=1:length(nodes);
   A=A(setdiff(1:length(A),ind));
   %disp(A);
   
    for i=1:length(A);
        remove=(A(i)-i+1);
        %disp(remove);
        HAM(remove,:)=[];
        HAM(:,remove)=[];
        DAM(remove,:)=[];
        DAM(:,remove)=[];
        nodes(remove,:)=[];
    end
save('jHAM.mat','HAM');
save('jDAM.mat','DAM');
save('jnodes.mat','nodes');
    
%disp(length(HAM));
%disp(length(DAM));
%disp(length(nodes));

    %for i=1:length(y)
    %   HAM(y(i,1),:)=[];
    %   HAM(:,y(i,1))=[];
    %   nodes(y(i,1),:)=0;
    %end

end