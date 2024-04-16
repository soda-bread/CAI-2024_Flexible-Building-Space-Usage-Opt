%% warning do not run this code, it will not work, the sections must be used in the 'Case1' and 'Case2' folders respectively


%%
file_list=ls;
file_list=file_list(3:end,:);

base1='Data_Case1_obj_';
base2='Data_Case1_sol_';
base3='Data_Case2_obj_';
base4='Data_Case2_sol_';

tags=[];
for ln=1:40
%     if contains(tags,[repmat(' ',1,4-length(char(file_list(ln,(find(file_list(ln,:)=='_',1,'last')+1):(find(file_list(ln,:)=='.')-1))))) ...
%             file_list(ln,(find(file_list(ln,:)=='_',1,'last')+1):(find(file_list(ln,:)=='.')-1))])~=1
       tags=[tags; [repmat(' ',1,4-length(char(file_list(ln,(find(file_list(ln,:)=='_',1,'last')+1):(find(file_list(ln,:)=='.')-1))))) ...
           file_list(ln,(find(file_list(ln,:)=='_',1,'last')+1):(find(file_list(ln,:)=='.')-1))]];
%     end
end

for ln=1:40
    src1=[base1 strtrim(tags(ln,:)) '.txt'];
    src2=[base2 strtrim(tags(ln,:)) '.txt'];
    dest1=[cd '\renamed\' base3 num2str(ln) '.txt'];
    dest2=[cd '\renamed\' base4 num2str(ln) '.txt'];
    movefile(src1,dest1);
    movefile(src2,dest2);
end

%%
file_list=ls;
file_list=file_list(3:end,:);

base1='Data_Case1_obj_';
base2='Data_Case1_sol_';
base3='Data_Case2_obj_';
base4='Data_Case2_sol_';

tags=[];
for ln=1:40
%     if contains(tags,[repmat(' ',1,4-length(char(file_list(ln,(find(file_list(ln,:)=='_',1,'last')+1):(find(file_list(ln,:)=='.')-1))))) ...
%             file_list(ln,(find(file_list(ln,:)=='_',1,'last')+1):(find(file_list(ln,:)=='.')-1))])~=1
       tags=[tags; [repmat(' ',1,4-length(char(file_list(ln,(find(file_list(ln,:)=='_',1,'last')+1):(find(file_list(ln,:)=='.')-1))))) ...
           file_list(ln,(find(file_list(ln,:)=='_',1,'last')+1):(find(file_list(ln,:)=='.')-1))]];
%     end
end

for ln=1:40
    src1=[base3 strtrim(tags(ln,:)) '.txt'];
    src2=[base4 strtrim(tags(ln,:)) '.txt'];
    dest1=[cd '\renamed\' base3 num2str(ln) '.txt'];
    dest2=[cd '\renamed\' base4 num2str(ln) '.txt'];
    movefile(src1,dest1);
    movefile(src2,dest2);
end
