% Figure to Matrix


folder_path = '/Users/jycai/Documents/MATLAB/BCI_Movella_Pipeline/20231213/Test Pipeline/Test_txt/';

path_Rb = strcat(folder_path,'R-Brekel-022.txt');
path_Lb = strcat(folder_path,'L-Brekel-022.txt');
path_Rm = strcat(folder_path,'R-Movella-022.txt');
path_Lm = strcat(folder_path,'L-Movella-022.txt');

% Right, Brekel
pre_A_Rb = readmatrix(path_Rb);
% Left, Brekel
pre_A_Lb = readmatrix(path_Lb);
% Right, Movella
pre_A_Rm = readmatrix(path_Rm);
% Left, Movella
pre_A_Lm = readmatrix(path_Lm);

% Convert matrices to positional 1000 x (x,y,z). [1000 x 3]
A_Rb = pre_A_Rb(:,2:4);
A_Lb = pre_A_Lb(:,2:4);

A_Rm = pre_A_Rm(:,2:4);
A_Lm = pre_A_Lm(:,2:4);


%% Apply 100x Scale and Transform

R_t1 = [0   1   0   ;
        -1  0   0   ;
        0   0   1 ] ;

R_t2 = [1   0   0   ;  
        0   0  -1   ;
        0   1   0 ] ;

A_Rmt = A_Rm * R_t1 * R_t2 * 100;
A_Lmt = A_Lm * R_t1 * R_t2 * 100;

% Apply 100x Factor Scale transformation

pre_A_RLb = A_Lb - A_Rb;
pre_A_RLmt = A_Lmt - A_Rmt;

RLb_x = pre_A_RLb(10:810, 1);
writematrix(RLb_x,'RLb_x.csv');
RLb_y = pre_A_RLb(10:810, 2);
writematrix(RLb_y,'RLb_y.csv');
RLb_z = pre_A_RLb(10:810, 3);
writematrix(RLb_z,'RLb_z.csv');

RLmt_x = pre_A_RLmt(10:810, 1);
writematrix(RLmt_x,'RLmt_x.csv');
RLmt_y = pre_A_RLmt(10:810, 2);
writematrix(RLmt_y,'RLmt_y.csv');
RLmt_z = pre_A_RLmt(10:810, 3);
writematrix(RLmt_z,'RLmt_z.csv');

display("******** 3. Apply Rotation and Scale Transformation ********")

%%
% Plot each column separately using the plot function
figure;
plot(pre_A_RLb(:, 1), 'color', [0, 0, 1]);  % Blue line for the first column
hold on;
plot(pre_A_RLb(:, 2), 'color', [0, 0.5, 1]);  % Green line for the second column
plot(pre_A_RLb(:, 3), 'color', [1, 0, 1]);  % Red line for the third column

plot(pre_A_RLmt(:, 1), 'color', [0, 0, 0.8]);  % Blue line for the first column
plot(pre_A_RLmt(:, 2), 'color', [0, 0.5, 0.8]);  % Green line for the second column
plot(pre_A_RLmt(:, 3), 'color', [1, 0, 0.8]);  % Red line for the third column

hold off;

% Add labels and title (optional)
xlabel('Frame Number (60 Frames/second)');
ylabel('Position (cm)');
title('<x,y,z> Position Components (HTC-Vive Brekel)');
% title('<x,y,z> Position Components (Movella-transformed)');
legend('RLb_x', 'RLb_y', 'RLb_z', 'RLmt_x', 'RLmt_y', 'RLmt_z');

%%
% Plot each column separately using the plot function
figure;
plot(A_Rb(:, 1), 'color', [0, 0, 1]);  % Blue line for the first column
hold on;
plot(A_Rb(:, 2), 'color', [0, 0.5, 1]);  % Green line for the second column
plot(A_Rb(:, 3), 'color', [1, 0, 1]);  % Red line for the third column

plot(A_Rmt(:, 1), 'color', [0, 0, 0.8]);  % Blue line for the first column
plot(A_Rmt(:, 2), 'color', [0, 0.5, 0.8]);  % Green line for the second column
plot(A_Rmt(:, 3), 'color', [1, 0, 0.8]);  % Red line for the third column

plot(A_Lb(:, 1), 'color', [0, 0, 0.5]);  % Blue line for the first column
plot(A_Lb(:, 2), 'color', [0, 0.5, 0.5]);  % Green line for the second column
plot(A_Lb(:, 3), 'color', [1, 0, 0.5]);  % Red line for the third column

plot(A_Lmt(:, 1), 'color', [0, 0, 0.3]);  % Blue line for the first column
plot(A_Lmt(:, 2), 'color', [0, 0.5, 0.3]);  % Green line for the second column
plot(A_Lmt(:, 3), 'color', [1, 0, 0.3]);  % Red line for the third column



hold off;

% Add labels and title (optional)
xlabel('Frame Number (60 Frames/second)');
ylabel('Position (cm)');
title('<x,y,z> Position Components (HTC-Vive Brekel)');
% title('<x,y,z> Position Components (Movella-transformed)');
legend('Rb_x', 'Rb_y', 'Rb_z', 'Rmt_x', 'Rmt_y', 'Rmt_z', 'Lb_x', 'Lb_y', 'Lb_z', 'Lmt_x', 'Lmt_y', 'Lmt_z');

%% Method 1: Find the First Maximum and Minimum
A_RLb_x = readmatrix("RLb_x.csv");
A_RLmt_x = readmatrix("RLmt_x.csv");

A_RLb_y = readmatrix("RLb_y.csv");
A_RLmt_y = readmatrix("RLmt_y.csv");

A_RLb_z = readmatrix("RLb_z.csv");
A_RLmt_z = readmatrix("RLmt_z.csv");

% A_RLb_x
find(A_RLb_x == max(A_RLb_x(:)), 1);
find(A_RLmt_x == max(A_RLmt_x(:)), 1);

find(A_RLb_x == min(A_RLb_x(:)), 1);
find(A_RLmt_x == min(A_RLmt_x(:)), 1);

% A_RLb_y
max_RLb_y = find(A_RLb_y == max(A_RLb_y(:)), 1);
max_RLmt_y = find(A_RLmt_y == max(A_RLmt_y(:)), 1);

min_RLb_y = find(A_RLb_y == min(A_RLb_y(:)), 1);
min_RLmt_y = find(A_RLmt_y == min(A_RLmt_y(:)), 1);

% A_RLb_z
max_RLb_z = find(A_RLb_z == max(A_RLb_z(:)), 1);
max_RLmt_z = find(A_RLmt_z == max(A_RLmt_z(:)), 1);
 
min_RLb_z = find(A_RLb_z == min(A_RLb_z(:)), 1);
min_RLmt_z = find(A_RLmt_z == min(A_RLmt_z(:)), 1);

% ----
display("Y max, Y min")
max_RLmt_y - max_RLb_y
min_RLmt_y - min_RLb_y

display("Z max, Z min")
max_RLmt_z - max_RLb_z
min_RLmt_z - min_RLb_z
%% Method 2: Find Peaks and Valleys
A_RLb_x = readmatrix("RLb_x.csv");
A_RLmt_x = readmatrix("RLmt_x.csv");

A_RLb_y = readmatrix("RLb_y.csv");
A_RLmt_y = readmatrix("RLmt_y.csv");

A_RLb_z = readmatrix("RLb_z.csv");
A_RLmt_z = readmatrix("RLmt_z.csv");

[pks_b_y,locs_y] = findpeaks(A_RLb_y,1)
[pks_mt_y,locs_y] = findpeaks(A_RLmt_y,1)



