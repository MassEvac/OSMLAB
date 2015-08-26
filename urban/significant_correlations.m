urban;

trimmed_table = table(:,:);

[~,P]=corrcoef(trimmed_table);
[value,index]=sort(sum(P.^2));
sorted_table = trimmed_table(:,index);
[R,P]=corrcoef(sorted_table);

sorted_labels=labels(index);
yticklabels = sorted_labels;
yticks = 1:length(yticklabels);

yticklabels = {};

for i = 1:length(sorted_labels)
    yticklabels{i} = [sorted_labels{i} ': ' num2str(i)];
end    
    
figure;
imagesc(R);colorbar;
set(gca, 'YTick', yticks, 'YTickLabel', yticklabels(:))
set(gca, 'XTick', yticks, 'XTickLabel', yticks)
title('R-corrcoef')

figure;
imagesc(P);colorbar;
set(gca, 'YTick', yticks, 'YTickLabel', yticklabels(:))
set(gca, 'XTick', yticks, 'XTickLabel', yticks)
title('P-value')