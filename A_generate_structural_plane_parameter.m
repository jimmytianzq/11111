% ���������ɽṹ�������������Ϊmat�ļ��Լ�excel�ļ���
clc;
clear all;

%% �����ʼ����.

% ���볤���ֵ����׼�
ma = 16;       % �����ֵ
sa = 0;        % �����׼��

% �����о����������һ��10*10*10�������塣
volume_research = 10*10*10;

% ƽ����ǡ�����
MeanOrientation = [90,90;90,0;0,0];

% �ṹ��������
structure_plane_group = 3;

% ��ƽ���������ת���ɵѿ�������ϵ�µ���ֵ
dip_Cartesian = zeros(structure_plane_group,1);          % ���򣬵ѿ�������ϵ��
dip_angle_Cartesian = zeros(structure_plane_group,1);    % ��ǣ��ѿ�������ϵ��
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
MeanOrientation_Cartesian = [dip_Cartesian,dip_angle_Cartesian];   % ����ѿ�������ϵ�µ�ƽ��������ǡ�

% ����ṹ������,����ṹ��������Ϊ50����
every_Discontinuity_num = 50;
ObjectNumberDiscontinuity_group = every_Discontinuity_num * ones(structure_plane_group,1);

% �����ʼ�߽綥����Ϣ����β����������
lengthx = 10; lengthy = 10; lengthz = 10;        
boundary = {[0,0,0],[lengthx,0,0],[lengthx,lengthy,0],[0,lengthy,0],[0,0,0];...
            [0,0,lengthz],[0,lengthy,lengthz],[lengthx,lengthy,lengthz],[lengthx,0,lengthz],[0,0,lengthz];...
            [lengthx,0,0],[lengthx,0,lengthz],[lengthx,lengthy,lengthz],[lengthx,lengthy,0],[lengthx,0,0];...
            [0,0,lengthz],[0,0,0],[0,lengthy,0],[0,lengthy,lengthz],[0,0,lengthz];...
            [0,0,0],[0,0,lengthz],[lengthx,0,lengthz],[lengthx,0,0],[0,0,0];...
            [0,lengthy,0],[lengthx,lengthy,0],[lengthx,lengthy,lengthz],[0,lengthy,lengthz],[0,lengthy,0]};  

%% �����״���ݣ�[��ǡ�����]����ͬ�����нṹ��ƽ�У���������ϵ�£���
ChanZhuang = [];
% �Ե�i��ṹ�棬�����״��Ϣ
for i = 1:structure_plane_group
    ChanZhuang_tq = MeanOrientation(i,:);
    ChanZhuang_plus = repmat(ChanZhuang_tq,[every_Discontinuity_num,1]);
    ChanZhuang = [ChanZhuang;ChanZhuang_plus];
end    
writematrix(ChanZhuang,'C:\Users\jimmy\Desktop\3D-block-volume-compare\����ṹ��-50-���޴�\2_����ṹ��ļ��\ys_cz.xls');

%% �������������Ϣ���ѿ�������ϵ�¡�
joint_num_all = 0;
% �������нṹ������
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
cz = [beta,alpha];    % �ֱ𴢴���ǡ�����

% �����������ݸ�ʽ��
formatSpec = '%.3f';
s_dip = num2str(alpha,formatSpec);
s_dip_angle = num2str(beta,formatSpec);
for i = 1:joint_num_all
    length_dip = 12-strlength(s_dip(i,:));
    length_dip_angle = 12-strlength(s_dip_angle(i,:));
    s_orientation(i,:) = strcat(creatspace(length_dip),s_dip(i,:),creatspace(length_dip_angle),s_dip_angle(i,:));
end

%% �������ĵ���Ϣ������ṹ�����ĵ����ݷֱ���x��y��z����[0,10]���ȷֲ���
points_0 = [5,5,5];
e_centerpoint = [];
for i = 1:structure_plane_group
    points_0_plus = repmat(points_0,[every_Discontinuity_num,1]);
    e_centerpoint_i = 10 * rand(every_Discontinuity_num,1);         % �������ĵ�������Ϣ��
    points_0_plus(:,i) = e_centerpoint_i;      % ��i��ṹ������ĵ�����
    e_centerpoint = [e_centerpoint;points_0_plus];
end
writematrix(e_centerpoint,'C:\Users\jimmy\Desktop\3D-block-volume-compare\����ṹ��-50-���޴�\2_����ṹ��ļ��\ys_ZXD.xls')   

%  ���ܳ�����أ����ݸ�ʽ����  
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

%% ���ɰ뾶��Ϣ���뾶��Ϊ������
radius = [];
for i = 1:structure_plane_group
    joint_num = ObjectNumberDiscontinuity_group(i,1);     % ��ȡ����ṹ��������
    radius_i = ma/2*ones(joint_num,1);   % ���ɰ뾶��Ϣ��
    radius = [radius;radius_i];     % �ϳɰ뾶��Ϣ��
end
writematrix(radius,'C:\Users\jimmy\Desktop\3D-block-volume-compare\����ṹ��-50-���޴�\2_����ṹ��ļ��\ys_radius.xls');

% �������ݸ�ʽ����
formatSpec = '%.3f';
s_r = num2str(radius,formatSpec);
for i = 1:joint_num_all
    length_radius = 12-strlength(s_r(i,:));
    s_radius(i,:) = strcat(creatspace(length_radius),s_r(i,:));
end

%% �������ݸ�ʽ��
% ���һ�У�0.00����
last_col = zeros(joint_num_all,1);
formatSpec = '%.3f';
s_col = num2str(last_col,formatSpec);
for i = 1:joint_num_all
    length_lastcol = 12-strlength(s_col(i,:));
    s_last_col(i,:) = strcat(creatspace(length_lastcol),s_col(i,:));
end

% ��һ��,S(xxx����
mark = char('S');
xh = 1:joint_num_all; xh = xh.';
s_xh = strjust(num2str(xh),'left');
strlength(s_xh(1,:));
for i = 1:joint_num_all
    length_firstcol = 15-1-strlength(s_xh(i,:));
    s_first_col(i,:) = [mark,s_xh(i,:),creatspace(length_firstcol)];
end

% ��һ���Լ�������С�
first_row = num2str(joint_num_all);
last_2row = num2str(zeros(2,1));

% ƴ���ַ�����
structure_plane = [s_first_col,s_coordinate,s_orientation,s_radius,s_last_col];
total_length = strlength(structure_plane(1,:));
length_firstrow = total_length-strlength(first_row);
s_first_row = strcat(first_row,creatspace(length_firstrow));
for i = 1:2
    length_last2row = total_length-strlength(last_2row(i,:));
    s_last_2row(i,:) = strcat(last_2row(i,:),creatspace(length_last2row));
end
structure_plane = strvcat(s_first_row,structure_plane,s_last_2row);

% ����ַ�����Ϊ�ı���ʽ��
fid = fopen('structure_plane','wt');
num_row = joint_num_all+3; 
for i = 1:num_row
    fprintf(fid,'%s\n',structure_plane(i,:));
end
fclose(fid);

% ����ṹ�������ָ���ļ��У��ֱ�Ϊ���ṹ���������߽�����Ϣ��(ÿ��)�ṹ����������״��Ϣ(�ѿ�������ϵ)��
% ���ĵ�������Ϣ���뾶��Ϣ���ѿ�������ϵ�µ�ƽ����״��Ϣ��ƽ��������ǣ����ṹ������
filename = 'structural_plane_parameters.mat';
save(['C:\Users\jimmy\Desktop\3D-block-volume-compare\����ṹ��-50-���޴�\2_����ṹ��ļ��\', filename],...
    'structure_plane_group','boundary','ObjectNumberDiscontinuity_group','cz','e_centerpoint','radius',...
    'MeanOrientation_Cartesian','joint_num_all');
save(['C:\Users\jimmy\Desktop\3D-block-volume-compare\����ṹ��-50-���޴�\4_��Ч�ߴ����-������\', filename],...
    'structure_plane_group','boundary','ObjectNumberDiscontinuity_group','cz','e_centerpoint','radius',...
    'MeanOrientation_Cartesian','joint_num_all');
save(['C:\Users\jimmy\Desktop\3D-block-volume-compare\����ṹ��-50-���޴�\6_ֱ�Ӽ������-��֤\', filename],...
    'structure_plane_group','boundary','ObjectNumberDiscontinuity_group','cz','e_centerpoint','radius',...
    'MeanOrientation_Cartesian','joint_num_all');







