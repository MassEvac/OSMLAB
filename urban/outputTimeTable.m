%urban;

af = table(:,6)' % area_after
labels(6) % print the label just to confirm

% Indices of cities with given attribute
% Criteria for PED paper
% in = find(and(af>0.74e7,af<1.26e7));

% Criteria for SCCS
in = find(and(af>1.5e6,af<2.5e6));

% Sorting by best to worst
[~,j]=sort(T_ninetieth_ia_ff(in));
in=in(j);

% Full table
% my_labels = {'n/1000', 'A', '$90_{B}$', '$\mu_{B}$', '$\sigma_{B}$', '$90_{N}$', '$\mu_{N}$', '$\sigma_{N}$', '$90_{I}$', '$\mu_{I}$','$\sigma_{I}$','$90_{N/B}\%$', '$90_{I/B}\%$'};
% my_table = [population(in)/1000; af(in)/1e5; T_ninetieth_ff(in); T_mu_ff(in); T_sigma_ff(in); T_ninetieth_ia(in); T_mu_ia(in); T_sigma_ia(in); T_ninetieth_cd(in); T_mu_cd(in); T_sigma_cd(in); T_ninetieth_ia_ff(in)*100; T_ninetieth_cd_ff(in)*100]';
% latextable(my_table,'format','%0.0f','horiz',my_labels,'vert',cities(in),'name','evacTime.tex','Hline',[1],'Vline',[1]);

%% Table of mean and standard deviation
my_labels = {'n/1000', 'A', '$\mu_{B}$', '$\sigma_{B}$', '$\mu_{N}$', '$\sigma_{N}$', '$\mu_{I}$','$\sigma_{I}$'};
my_table = [population(in)/1000; af(in)/1e5; T_mu_ff(in); T_sigma_ff(in); T_mu_ia(in); T_sigma_ia(in); T_mu_cd(in); T_sigma_cd(in)]';
latextable(my_table,'format','%0.0f','horiz',my_labels,'vert',cities(in),'name','urban/sccsTime.tex','Hline',[1],'Vline',[1]);

%% Table of 90th percentile and ratios
my_labels = {'n/1000', 'A', '$90_{B}$', '$90_{N}$','$90_{I}$', '$90_{N/B}\%$', '$90_{I/B}\%$'};
my_table = [population(in)/1000; af(in)/1e5; T_ninetieth_ff(in); T_ninetieth_ia(in); T_ninetieth_cd(in); T_ninetieth_ia_ff(in)*100; T_ninetieth_cd_ff(in)*100]';
latextable(my_table,'format','%0.0f','horiz',my_labels,'vert',cities(in),'name','urban/sccsRatio.tex','Hline',[1],'Vline',[1]);