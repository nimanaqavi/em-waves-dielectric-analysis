clc; 
clear;
close all;

c = 3e8;
eps0 = 8.854e-12;
mu0 = 4*pi*1e-7;
eta1 = sqrt(mu0/eps0);
eta3 = eta1;

% Material Properties (Plexiglass)
eps_r = 2.6;
loss_tangent = 0.009;
fc = 65e9;

% Calculate Half-Wavelength Thickness
d = c / (2 * fc * sqrt(eps_r));

% Frequency Range (30% Bandwidth)
f = linspace(0.85*fc, 1.15*fc, 500);
omega = 2 * pi * f;
gamma3 = 1i * omega .* sqrt(mu0*eps0);

eps2_lossy = eps0 * eps_r;
sigma2_lossy = omega .* eps0 .* eps_r .* loss_tangent;
mu2 = mu0;

eta2_lossy = sqrt(1i*omega.*mu2 ./ (sigma2_lossy + 1i*omega.*eps2_lossy));
gamma2_lossy = sqrt(1i*omega.*mu2 .* (sigma2_lossy + 1i*omega.*eps2_lossy));

% Reflection and Transmission Coefficients (Lossy)
Gamma12_lossy = (eta2_lossy - eta1) ./ (eta2_lossy + eta1);
Gamma23_lossy = (eta3 - eta2_lossy) ./ (eta3 + eta2_lossy);

T12_lossy = 2 * eta2_lossy ./ (eta2_lossy + eta1);
T23_lossy = 2 * eta3 ./ (eta3 + eta2_lossy);

exp_term_lossy = exp(-2 * gamma2_lossy * d);

Gamma_slab_lossy = (Gamma12_lossy + Gamma23_lossy .* exp_term_lossy) ./ ...
                   (1 + Gamma12_lossy .* Gamma23_lossy .* exp_term_lossy);

T_slab_lossy = (T12_lossy .* T23_lossy .* exp(-gamma2_lossy*d) .* exp(gamma3*d)) ./ ...
               (1 + Gamma12_lossy .* Gamma23_lossy .* exp_term_lossy);

% Convert Theoretical Results to dB
Gamma_theory_dB = 20 * log10(abs(Gamma_slab_lossy));
T_theory_dB = 20 * log10(abs(T_slab_lossy));

% ---------------------------------------------------------
% Read CST Results (Directly in GHz and dB)
% ---------------------------------------------------------
cst_S11 = readmatrix('S11.txt'); 
f_cst_S11 = cst_S11(:, 1);  
S11_cst_dB = cst_S11(:, 2); 


cst_S21 = readmatrix('S21.txt');
f_cst_S21 = cst_S21(:, 1);  
S21_cst_dB = cst_S21(:, 2);

% ---------------------------------------------------------
% Plotting
% ---------------------------------------------------------

% --- Figure 1: Reflection (Gamma / S11) ---
figure('Name', 'Reflection Coefficient (S11)', 'Position', [100, 150, 600, 450]);
plot(f/1e9, Gamma_theory_dB, 'r', 'LineWidth', 2); hold on;
plot(f_cst_S11, S11_cst_dB, 'k--', 'LineWidth', 1.5);
title('|S_{11}| - Lossy (dB)');
xlabel('Frequency (GHz)');
ylabel('Magnitude (dB)');
legend('MATLAB (Analytical)', 'CST (Simulation)', 'Location', 'best');
grid on;

% --- Figure 2: Transmission (T / S21) ---
figure('Name', 'Transmission Coefficient (S21)', 'Position', [750, 150, 600, 450]);
plot(f/1e9, T_theory_dB, 'b', 'LineWidth', 2); hold on;
plot(f_cst_S21, S21_cst_dB, 'k--', 'LineWidth', 1.5);
title('|S_{21}| - Lossy (dB)');
xlabel('Frequency (GHz)');
ylabel('Magnitude (dB)');
legend('MATLAB (Analytical)', 'CST (Simulation)', 'Location', 'best');
grid on;