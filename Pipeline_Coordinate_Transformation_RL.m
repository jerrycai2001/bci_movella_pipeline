
% Load CSV txt files

filename5 = "Trial-2023_08_23{htc}vr_tracker_vive_3_0-output-MAT.txt";
filename15 = "Trial-2023_08_23Generic_Tracker_3) at 0x-output-MAT.txt";

filename20 = "Trial-2023_08_23HTC Vive-TRK-LHR-3E890B4-output-MAT.txt";
filename7 = "Trial-2023_08_23HTC Vive-TRK-LHR-8E0E304-output-MAT.txt";

% Read matrices. [1000 x 4]
pre_A_Rb = readmatrix(filename5);
pre_A_Lb = readmatrix(filename15);

pre_A_Rm = readmatrix(filename20);
pre_A_Lm = readmatrix(filename7);

% Test
spacer = "******** 1. LOAD DATA ********"
pre_A_Rb(1:5,:)

%%
% Convert matrices to positional 1000 x (x,y,z). [1000 x 3]
A_Rb = pre_A_Rb(:,2:4);
A_Lb = pre_A_Lb(:,2:4);

A_Rm = pre_A_Rm(:,2:4);
A_Lm = pre_A_Lm(:,2:4);

% Test
spacer = "******** 2. Create [1000 x 3] Matrices ********"
A_Rb(1:5,1:3)


%% 1st Transformation: Rotation of Movella onto HTC-Brekel of +pi/2 about x axis
theta1 = pi/2;

m_11 = 1;
m_12 = 0;
m_13 = 0;

m_21 = 0;
m_22 = cos(theta1);
m_23 = sin(theta1);

m_31 = 0;
m_32 = -sin(theta1);
m_33 = cos(theta1);

M_r1 = [m_11 m_21 m_31; 
       m_12 m_22 m_32; 
       m_13 m_23 m_33];

%% 2nd Transformation: Rotation of Movella onto HTC-Brekel of -pi/2 about y axis
theta2 = -pi/2;

m_11 = cos(theta2);
m_12 = 0;
m_13 = -sin(theta2);

m_21 = 0;
m_22 = 1;
m_23 = 0;

m_31 = sin(theta2);
m_32 = 0;
m_33 = cos(theta2);

M_r2 = [m_11 m_21 m_31; 
       m_12 m_22 m_32; 
       m_13 m_23 m_33];

%% 3rd Transformation: Flip of x axis across yz-plane

m_11 = -1;
m_12 = 0;
m_13 = 0;

m_21 = 0;
m_22 = 1;
m_23 = 0;

m_31 = 0;
m_32 = 0;
m_33 = 1;

M_r3 = [m_11 m_21 m_31; 
       m_12 m_22 m_32; 
       m_13 m_23 m_33];

%% Apply Rotations to Movella vectors (t: indicates transformed)
A_Rm_i = A_Rm * M_r1;
A_Lm_i = A_Lm * M_r1;

A_Rm_ii = A_Rm_i * M_r2;
A_Lm_ii = A_Lm_i * M_r2;

A_Rmt = A_Rm_ii * M_r3;
A_Lmt = A_Lm_ii * M_r3;

% A_Rmt = A_Rm_i;
% A_Lmt = A_Lm_i;

A_Rmt = A_Rm_ii;
A_Lmt = A_Lm_ii;

% Test
spacer = "******** 3. Apply Rotation ********"
A_Rm_i(1:5,1:3)
A_Rm_ii(1:5,1:3)
A_Rmt(1:5,1:3)

%% Find inter-tracker vectors. [1000 x 3]

spacer = "******** 3. Inter-tracker vectors ********"

% Apply scale factor of 100x to Movella trackers
pre_A_RLb = A_Lb - A_Rb;
pre_A_RLmt = (A_Lmt - A_Rmt) * 100;

% Time shift adjustments

epoch_length = 300;
b_initial = 60;
mt_initial = 176; 

b_adj_factor = 0;
mt_adj_factor = 0

b_initial = b_initial + b_adj_factor;
b_final = b_initial + epoch_length;

mt_initial = mt_initial + mt_adj_factor;
mt_final = mt_initial + epoch_length;

A_RLb = pre_A_RLb(b_initial:b_final,1:3);
A_RLmt = pre_A_RLmt(mt_initial:mt_final,1:3);

% DIFFERENCE BETWEEN BREKEL-MOVELLA INTER-AXIAL VECTORS
dA_RL = A_RLmt - A_RLb;

% Test
spacer = "******** DIFFERENCE BETWEEN BREKEL-MOVELLA INTER-AXIAL VECTORS ********"
A_RLb(1:150,1:3)
A_RLmt(1:150,1:3)

%% Plot Difference Vectors
% Example [1000 x 3] matrix A (replace this with your actual matrix)
A = dA_RL;  % Create a random [1000 x 3] matrix

% Plot each column separately using the plot function
figure;
plot(A(:, 1), 'b');  % Blue line for the first column
hold on;
plot(A(:, 2), 'g');  % Green line for the second column
plot(A(:, 3), 'r');  % Red line for the third column
hold off;

% Add labels and title (optional)
xlabel('Time Series');
ylabel('Position (cm)');
title('Diff-Diff Vector <x,y,z> Components (Right-Left)');
legend('x_array', 'y_array', 'z_array');

%% Cross Correlation Analysis

% x coordinates from each array (brekel-HTC, Movella)
A_RLb_x = A_RLb(1:5,1);
A_RLmt_x = A_RLmt(1:5,1);

% y coordinates from each array (brekel-HTC, Movella)
A_RLb_y = A_RLb(1:5,2);
A_RLmt_y = A_RLmt(1:5,2);

% z coordinates from each array (brekel-HTC, Movella)
A_RLb_z = A_RLb(1:5,3);
A_RLmt_z = A_RLmt(1:5,3);

%%
% x-coordinate cross correlation
[c,lags] = xcorr(A_RLb_x, A_RLmt_x, 'biased');
stem(lags,c)
title('x-coordinate Cross-Correlation between HTC and Movella Time Series');
xlabel('Lag');
ylabel('Correlation');

% y-coordinate cross correlation
[c,lags] = xcorr(A_RLb_y, A_RLmt_y, 'biased');
stem(lags,c)
title('y-coordinate Cross-Correlation between HTC and Movella Time Series');
xlabel('Lag');
ylabel('Correlation');

% z-coordinate cross correlation
[c,lags] = xcorr(A_RLb_z, A_RLmt_z, 'biased');
stem(lags,c)
title('z-coordinate Cross-Correlation between HTC and Movella Time Series');
xlabel('Lag');
ylabel('Correlation');
