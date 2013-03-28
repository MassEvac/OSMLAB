city = {'Cardiff','Manchester','London'};

[~,nc] = size(city);

for i = 1:nc,
    [a(1,i),~,b(1,i),b(2,i)]=query('bar','atm',city{i});
    [a(2,i),~,c(1,i),c(2,i)]=query('bar','hospital',city{i});
end

f = figure;
colormap(gray);
bar(a);
legend (city);
set(gca,'XTickLabel',{'bar vs atm','bar vs hospital'})
saveas(f,'cities-gray.pdf','pdf');

disp (b);
disp (c);