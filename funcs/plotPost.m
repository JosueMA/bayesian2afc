function [h]=plotPost(x)

% % PLOT AS A FILLED HISTOGRAM -----------------
% [f,xi]=hist(x,64);
% 
% h.bar = bar(xi,f,32,...
% 	'BarWidth',1,...
% 	'FaceColor',[0.8 0.8 0.8],...
% 	'EdgeColor','none');
% % --------------------------------------------

% PLOT AS AN OUTLINED HISTOGRAM --------------
[f,xx] = hist(x, 50);
% normalise it to a probability mass function
f=f./sum(f);
% plot
h = stairs(xx, f, 'k-');
% --------------------------------------------

% zoom in on both axes
axis tight
% scale the y-axis
ylim([0 max(f)])

% format axes
box off

% remove YTicks, and make the axis white (i.e. invisible)
% set(gca,'YTick',[],...
% 	'YColor',[1 1 1])
% keep y axis, but remove labels
set(gca,'yticklabel',{},...
	'YTick',[])





% Plot 95% CI
hold on
Y = prctile(x,[5 95]);
a = axis; top = a(4); k=0.03; 
plot(Y,[top*k top*k],'k-',...
 	'LineWidth',3);

hold off