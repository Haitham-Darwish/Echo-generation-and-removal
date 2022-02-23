## Copyright (C) 2021 Haitham
## 
## This program is free software: you can redistribute it and/or modify it
## under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.
## 
## This program is distributed in the hope that it will be useful, but
## WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
## 
## You should have received a copy of the GNU General Public License
## along with this program.  If not, see
## <https://www.gnu.org/licenses/>.

## -*- texinfo -*- 
## @deftypefn {} {@var{y_out} = output signal} 
##                @var{time_axis_out = time axis of output})
##            convolveDelayedDecayed (@var{x=input}, @var{Fs=sampling freqency},
##            @var{U_input=system}) @var{time_axis_input = time axis of input})
##
## @seealso{}
## @end deftypefn

## Author: Haitham <@HAITHAM>
## Created: 2021-07-01

function [y_out time_axis_out] = convolveDelayedDecayed (x, Fs, U_input, 
                                                          time_axis_input)

% calulate the time value of samples
h = zeros(size(x, 1), 1); %Impulse 

% Generate impulse train (get h[n])
h(U_input(:, 1)*Fs*0.4)=U_input(:, 2);

figure(1);
% plot the input waveform 
subplot(3, 1, 1);
plot(time_axis_input, x, 'b');
xlabel('Time in seconds');
ylabel('signal strength');

lx=length(x);
lh=length(h);
outlength=lx+lh-1;

% Make the cov at frequency domain and get the inverse
% y=X(omega)*H(e^omega)
y_out = ifft(fft(x, outlength) .* fft(h, outlength));

% Get some statistics
%{
  To make sure that strong voice > noraml > weak
%}
disp(["Mean ", num2str(mean(abs(y_out)))])
disp(["Mode ", num2str(mode(y_out))])
disp(["Median ", num2str(median(y_out))])

% Normalize
y_out = (y_out./mean(abs(x)))(1:size(y_out)*0.7,:);

subplot(3, 1, 2);
plot(time_axis_input(1:0.25*size(time_axis_input(:)))'*Fs, 
      h(1:size(h)*0.25), 'g');
xlabel('Time in seconds');
ylabel('Impulses')
title("Impulse Train");

% Get the lengh of o/p
y_outlen=length(y_out);

% Define the time axis of o/p
time_axis_out=([1:y_outlen]-1)/Fs;

subplot(3, 1, 3);

plot(time_axis_out, y_out, 'r');
xlabel("Time in seconds")
ylabel('signal strength')




endfunction
