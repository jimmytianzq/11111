% 本程序：生成结构面参数，并储存为mat文件以及excel文件。
clc;
clear all;

%% 输入初始参数.

% 输入长轴均值、标准差。
ma = 16;       % 长轴均值
sa = 0;        % 长轴标准差

% 输入研究区域体积：一个10*10*10的立方体。
volume_research = 10*10*10;

% 平均倾角、倾向。
MeanOrientation = [90,90;90,0;0,0];

% 结构面组数。
structure_plane_group = 3;

% 将平均倾向倾角转换成笛卡尔坐标系下的数值
dip_Cartesian = zeros(structure_plane_group,1);          % 倾向，笛卡尔坐标系下
dip_angle_Cartesian = zeros(structure_plane_group,1);    % 倾角，笛卡尔坐标系下
for i = 1:structure_plane_group
    dipi = MeanOrientation(i,2);
    if dipi <= 90
        alphai = 90-dipi;
    elseif dipi > 90
        alphai = 450-dipi;
    else
        alphai = 0;
    end
    dip_Cartesian(i,1) = alphai;
end
dip_angle_Cartesian = MeanOrientation(:,1);   
MeanOrientation_Cartesian = [dip_Cartesian,dip_angle_Cartesian];   % 储存笛卡尔坐标系下的平均倾向倾角。

% 随机结构面数量,三组结构面数量皆为50条。
every_Discontinuity_num = 50;
ObjectNumberDiscontinuity_group = every_Discontinuity_num * ones(structure_plane_group,1);

% 输入初始边界顶点信息，首尾顶点相连。
lengthx = 10; lengthy = 10; lengthz = 10;        
boundary = {[0,0,0],[lengthx,0,0],[lengthx,lengthy,0],[0,lengthy,0],[0,0,0];...
            [0,0,lengthz],[0,lengthy,lengthz],[lengthx,lengthy,lengthz],[lengthx,0,lengthz],[0,0,lengthz];...
            [lengthx,0,0],[lengthx,0,lengthz],[lengthx,lengthy,lengthz],[lengthx,lengthy,0],[lengthx,0,0];...
            [0,0,lengthz],[0,0,0],[0,lengthy,0],[0,lengthy,lengthz],[0,0,lengthz];...
            [0,0,0],[0,0,lengthz],[lengthx,0,lengthz],[lengthx,0,0],[0,0,0];...
            [0,lengthy,0],[lengthx,lengthy,0],[lengthx,lengthy,lengthz],[0,lengthy,lengthz],[0,lengthy,0]};  

%% 计算产状数据（[倾角、倾向]），同组所有结构面平行，地质坐标系下，。
ChanZhuang = [];
% 对第i组结构面，储存产状信息
for i = 1:structure_plane_group
    ChanZhuang_tq = MeanOrientation(i,:);
    ChanZhuang_plus = repmat(ChanZhuang_tq,[every_Discontinuity_num,1]);
    ChanZhuang = [ChanZhuang;ChanZhuang_plus];
end    
writematrix(ChanZhuang,'C:\Users\jimmy\Desktop\3D-block-volume-compare\三组结构面-50-无限大\2_计算结构面的间距\ys_cz.xls');

%% 生成倾向倾角信息，笛卡尔坐标系下。
joint_num_all = 0;
% 计算所有结构面数量
for ii = 1:structure_plane_group
    ObjectNumberDiscontinuity = ObjectNumberDiscontinuity_group(ii,1);
    joint_num = ObjectNumberDiscontinuity;
    joint_num_all = joint_num_all+joint_num;
end

dip = ChanZhuang(:,2);
dip_angle = ChanZhuang(:,1);
alpha = zeros(joint_num_all,1);
for i = 1:joint_num_all
    dipi = dip(i);
    if dipi <= 90
        alphai = 90-dipi;
    elseif dipi > 90
        alphai = 450-dipi;
    else
        alphai = 0;
    end
    alpha(i,1) = alphai;
end
beta = dip_angle; 
cz = [beta,alpha];    % 分别储存倾角、倾向。

% 整理彭总数据格式。
formatSpec = '%.3f';
s_dip = num2str(alpha,formatSpec);
s_dip_angle = num2str(beta,formatSpec);
for i = 1:joint_num_all
    length_dip = 12-strlength(s_dip(i,:));
    length_dip_angle = 12-strlength(s_dip_angle(i,:));
    s_orientation(i,:) = strcat(creatspace(length_dip),s_dip(i,:),creatspace(length_dip_angle),s_dip_angle(i,:));
end

%% 生成中心点信息，三组结构面中心点数据分别在x、y、z上在[0,10]均匀分布。
points_0 = [5,5,5];
e_centerpoint = [];
for i = 1:structure_plane_group
    points_0_plus = repmat(points_0,[every_Discontinuity_num,1]);
    e_centerpoint_i = 10 * rand(every_Discontinuity_num,1);         % 生成中心点坐标信息。
    points_0_plus(:,i) = e_centerpoint_i;      % 第i组结构面的中心点数据
    e_centerpoint = [e_centerpoint;points_0_plus];
end
writematrix(e_centerpoint,'C:\Users\jimmy\Desktop\3D-block-volume-compare\三组结构面-50-无限大\2_计算结构面的间距\ys_ZXD.xls')   

%  彭总程序相关：数据格式整理。  
formatSpec = '%.3f';
e_x = e_centerpoint(:,1);
e_y = e_centerpoint(:,2);
e_z = e_centerpoint(:,3);
s_x = num2str(e_x,formatSpec);
s_y = num2str(e_y,formatSpec);
s_z = num2str(e_z,formatSpec);

for i = 1:joint_num_all
    length_x = 12-strlength(s_x(i,:));
    length_y = 12-strlength(s_y(i,:));
    length_z = 12-strlength(s_z(i,:));
    s_coordinate(i,:) = strcat(creatspace(length_x),s_x(i,:),creatspace(length_y),s_y(i,:),creatspace(length_z),s_z(i,:));
end

%% 生成半径信息，半径均为常数。
radius = [];
for i = 1:structure_plane_group
    joint_num = ObjectNumberDiscontinuity_group(i,1);     % 提取该组结构面数量。
    radius_i = ma/2*ones(joint_num,1);   % 生成半径信息。
    radius = [radius;radius_i];     % 合成半径信息。
end
writematrix(radius,'C:\Users\jimmy\Desktop\3D-block-volume-compare\三组结构面-50-无限大\2_计算结构面的间距\ys_radius.xls');

% 彭总数据格式整理
formatSpec = '%.3f';
s_r = num2str(radius,formatSpec);
for i = 1:joint_num_all
    length_radius = 12-strlength(s_r(i,:));
    s_radius(i,:) = strcat(creatspace(length_radius),s_r(i,:));
end

%% 调整数据格式。
% 最后一列（0.00）。
last_col = zeros(joint_num_all,1);
formatSpec = '%.3f';
s_col = num2str(last_col,formatSpec);
for i = 1:joint_num_all
    length_lastcol = 12-strlength(s_col(i,:));
    s_last_col(i,:) = strcat(creatspace(length_lastcol),s_col(i,:));
end

% 第一列,S(xxx）。
mark = char('S');
xh = 1:joint_num_all; xh = xh.';
s_xh = strjust(num2str(xh),'left');
strlength(s_xh(1,:));
for i = 1:joint_num_all
    length_firstcol = 15-1-strlength(s_xh(i,:));
    s_first_col(i,:) = [mark,s_xh(i,:),creatspace(length_firstcol)];
end

% 第一行以及最后两行。
first_row = num2str(joint_num_all);
last_2row = num2str(zeros(2,1));

% 拼接字符串。
structure_plane = [s_first_col,s_coordinate,s_orientation,s_radius,s_last_col];
total_length = strlength(structure_plane(1,:));
length_firstrow = total_length-strlength(first_row);
s_first_row = strcat(first_row,creatspace(length_firstrow));
for i = 1:2
    length_last2row = total_length-strlength(last_2row(i,:));
    s_last_2row(i,:) = strcat(last_2row(i,:),creatspace(length_last2row));
end
structure_plane = strvcat(s_first_row,structure_plane,s_last_2row);

% 输出字符串作为文本格式。
fid = fopen('structure_plane','wt');
num_row = joint_num_all+3; 
for i = 1:num_row
    fprintf(fid,'%s\n',structure_plane(i,:));
end
fclose(fid);

% 储存结构面参数于指定文件夹，分别为：结构面组数、边界面信息、(每组)结构面数量、产状信息(笛卡尔坐标系)、
% 中心点坐标信息、半径信息、笛卡尔坐标系下的平均产状信息（平均倾向、倾角）、结构面总数
filename = 'structural_plane_parameters.mat';
save(['C:\Users\jimmy\Desktop\3D-block-volume-compare\三组结构面-50-无限大\2_计算结构面的间距\', filename],...
    'structure_plane_group','boundary','ObjectNumberDiscontinuity_group','cz','e_centerpoint','radius',...
    'MeanOrientation_Cartesian','joint_num_all');
save(['C:\Users\jimmy\Desktop\3D-block-volume-compare\三组结构面-50-无限大\4_等效尺寸块体-解析解\', filename],...
    'structure_plane_group','boundary','ObjectNumberDiscontinuity_group','cz','e_centerpoint','radius',...
    'MeanOrientation_Cartesian','joint_num_all');
save(['C:\Users\jimmy\Desktop\3D-block-volume-compare\三组结构面-50-无限大\6_直接计算体积-验证\', filename],...
    'structure_plane_group','boundary','ObjectNumberDiscontinuity_group','cz','e_centerpoint','radius',...
    'MeanOrientation_Cartesian','joint_num_all');







