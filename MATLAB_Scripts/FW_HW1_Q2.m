clc; 
clear; 
close all;

%% 1. Parameters
d_mm      = 20;       
eps_r     = 9;        
tan_delta = 0.17;     

%% 2. Load Data 
data_S11   = load('S11_CST.txt');
data_S21   = load('S21_CST.txt');
data_depth = load('Depth_CST.txt');

f_sim     = data_S11(:, 1); 
S11_sim   = data_S11(:, 2);
S21_sim   = data_S21(:, 2);
depth_sim = data_depth(:, 2);

%% 3. Theoretical Model (Multiple-Reflection / Slab)
d    = d_mm / 1000;         
f_Hz = f_sim * 1e9;
w    = 2 * pi * f_Hz;
mu0  = 4 * pi * 1e-7;
eps0 = 8.854e-12;
eps_c = eps0 * eps_r * (1 - 1i * tan_delta);   

eta1   = sqrt(mu0 / eps0);        
eta2   = sqrt(mu0 ./ eps_c);    
gamma2 = 1i * w .* sqrt(mu0 .* eps_c); 
alpha  = real(gamma2);                 

% Reflection coefficient & multiple reflections logic
Gamma = (eta2 - eta1) ./ (eta2 + eta1);
P     = exp(-gamma2 * d);                       
denom = 1 - (Gamma.^2) .* (P.^2);

S11_theory_complex = Gamma .* (1 - P.^2) ./ denom;
S21_theory_complex = (1 - Gamma.^2) .* P ./ denom;

% Convert to dB
S11_theory_dB = 20 * log10(abs(S11_theory_complex) + 1e-12);
S21_theory_dB = 20 * log10(abs(S21_theory_complex) + 1e-12);

% Penetration Depth
Depth_theory = (1 ./ alpha) * 1000; 

%% 4. Plotting
% Figure 1: S11
figure('Name', 'Reflection Coefficient (S11)', 'Color', 'w');
plot(f_sim, S11_theory_dB, 'b-', 'LineWidth', 2); hold on;
plot(f_sim, S11_sim, 'r--', 'LineWidth', 2);
ylim([-10 -2]);
grid on;
title('Reflection Coefficient (|S_{11}| - dB)');
xlabel('Frequency (GHz)'); ylabel('Magnitude (dB)');
legend('Theory', 'Simulation', 'Location', 'best');

% Figure 2: S21
figure('Name', 'Transmission Coefficient (S21)', 'Color', 'w');
plot(f_sim, S21_theory_dB, 'b-', 'LineWidth', 2); hold on;
plot(f_sim, S21_sim, 'r--', 'LineWidth', 2);
grid on;
title('Transmission Coefficient (|S_{21}| - dB)');
xlabel('Frequency (GHz)'); ylabel('Magnitude (dB)');
legend('Theory', 'Simulation', 'Location', 'best');

% Figure 3: Penetration Depth
figure('Name', 'Penetration Depth', 'Color', 'w');
plot(f_sim, Depth_theory, 'k-', 'LineWidth', 2); hold on;
plot(f_sim, depth_sim, 'm--', 'LineWidth', 2);
grid on;
title('Skin Depth (\delta)');
xlabel('Frequency (GHz)'); ylabel('Depth (mm)');
legend('Theory', 'Simulation', 'Location', 'best');