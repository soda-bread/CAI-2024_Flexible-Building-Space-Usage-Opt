%EAF example

% Load all example data
datapath='C:\Users\herrindg\OneDrive - University of Birmingham\Desktop\Students\Huanbo\2023.12 Building space usage optimization encoding algorithm\Data\';
filename_base=[datapath 'Case1\Data_Case1_obj_']; %Change to 'Case2\Data_Case2_obj_' for other case
filename_suffix='.txt';
filename_index_range=1:40; 

%Data containers:
decs={};
objs={};

nM=2;

%Load:
for i=1:length(filename_index_range)
    temp=load([filename_base num2str(filename_index_range(i)) filename_suffix]);
%     decs=[decs temp(:,1:nD)];
%     objs=[objs temp(:,(nD+1):(nD+nM))];
    objs=[objs temp];
    
end
sets=[];
for i=1:length(filename_index_range)
    sets=[sets; objs{i} repmat(i,size(objs{i},1),1)];
end
%%
%Visualize all solution sets:
try dhconfig; catch end

figure('Position',[488   234   595   528]); hold on; axis square

% nadir=[1 2];
% for i=1:length(sets) % Visual representation of the EAF - how to quantify this
%     patch([sets(i,1) sets(i,1) nadir(1) nadir(1)],[sets(i,2) nadir(2) nadir(2) sets(i,2)],[0 0 0],'FaceAlpha',1/length(sets),'EdgeAlpha',0,'HandleVisibility','off')
% end

for i=1:length(filename_index_range)
    scatter(objs{i}(:,1),objs{i}(:,2),100,'.','HandleVisibility','off') %Different colours
%     scatter(objs{i}(:,1),objs{i}(:,2),100,'k.','HandleVisibility','off') %All points black
%     scatter3(objs{i}(:,1),objs{i}(:,2),repmat(i,1,size(objs{1},1)),100,'.') %This allows you to see which solutions are from which runs
end





%%

%EAF attempt

% compare each solution set to each other and measure the number of times that a solution is outperformed 


% R-code for compute-eaf
% compute_eaf <- function(data, percentiles = NULL)
% {
%   data <- check_eaf_data(data)
%   setcol <- ncol(data)
%   nobjs <- setcol - 1L
%   # The C code expects points within a set to be contiguous.
%   data <- data[order(data[, setcol]), , drop=FALSE]
%   sets <- data[, setcol]
%   nsets <- length(unique(sets))
%   npoints <- tabulate(sets)
%   if (is.null(percentiles)) {
%     # FIXME: We should compute this in the C code.
%     percentiles <- 1L:nsets * 100.0 / nsets
%   }
%   # FIXME: We should handle only integral levels inside the C code. 
%   percentiles <- unique.default(sort.int(percentiles))
%   return(.Call(compute_eaf_C,
%                as.double(t(as.matrix(data[, 1L:nobjs]))),
%                as.integer(nobjs),
%                as.integer(cumsum(npoints)),
%                as.integer(nsets),
%                as.numeric(percentiles)))
% }


% For each set (run of an algorithm), for each solution, how many of the other sets contain a solution that dominates it. 
dom_count_stack=[];
for ind=1:length(filename_index_range)
    run_data=sets(sets(:,nM+1)==ind,:);
    other_run_data=sets(sets(:,nM+1)~=ind,:);
    dom_count=zeros(size(run_data,1),1);
    
    for j=1:size(run_data,1)
        dom_count(j)=dom_count(j)+length(unique(sets(sum([other_run_data(:,1)<=run_data(j,1) other_run_data(:,2)<=run_data(j,2)],2)>1,3)));
    end

    dom_count_stack=[dom_count_stack; dom_count];
end


%Isolate into groups based on percentiles? 
%e.g. isolate all points with 0 domination, those with 100 and those with 7 (~50%)

sets=[sets dom_count_stack];
prctile_order=sortrows(sets,[size(sets,2) 1]);

%%
% figure; hold on; axis square;
% prctiles=round([0 50 100]/100.*(max(filename_index_range)-1)); style={'-',':','-.',':','--'};
prctiles=[0 19 39]; style={'-','-.',':'};

xmax=1; xmin=0;
ymax=max(prctile_order(:,2));
ymin=min(prctile_order(:,2));

for prct=1:length(prctiles)
    x=prctile_order(prctile_order(:,end)==prctiles(prct),1);
    y=prctile_order(prctile_order(:,end)==prctiles(prct),2);

    if x(end)~=xmax
        x=[x; xmax];
        y=[y; y(end)];
    end
    if x(1)~=xmin
        x=[xmin; x];
        y=[ymax; y];
    end

    plot(x,y,'color',[0 0 0],'LineStyle',style{prct})
end
%legend(cellstr(num2str(round(100*(prctiles'+1)./length(unique(sets(:,3)))))))
legend({'Best','Median','Worst'})
titlestring=['NSGA-II on ' filename_base(find(filename_base=='\',1,'last')+6:end-5) ': 50 gens, 40 reps']; titlestring(titlestring=='_')=' ';
title(titlestring)
ylim([ymin*0.99 ymax*1.01])
xlabel('f_{cost} - (cost)')
ylabel('f_{tc} - (thermal comfort)')
box on

%uncomment to pring a png version of the graph
% im_name=titlestring; im_name(im_name==' ')='_'; im_name(im_name==',')='';  im_name(im_name==':')=''; 
% print(gcf,[im_name '.png'],'-dpng','-r1000')

%%



