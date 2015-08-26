urban;
load('sccs_results.mat');
%% Table of 90th percentile and ratios

% in is from outputTimeTable file to put into SCCS presentation
%trimmed_table = table(in,:);

my_labels = {'$r_{N/B}$', '$p_{N/B}$', '$r_{I/B}$', '$p_{I/B}$'};
my_table = R_P_ia_R_P_cd;
latextable(my_table,'format','%0.2f','horiz',my_labels,'vert',sorted_labels','name','urban/sccRP.tex','Hline',[1],'Vline',[1]);

