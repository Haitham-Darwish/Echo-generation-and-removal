## Copyright (C) 2021 Haitham 

## -*- texinfo -*- 
## @deftypefn {} {@var{x} = input to the system} 
## deconvolution (@var{y = output }, @var{Fs = sampling  frequency},
##                @var{U_input = system} 
##                @var{time_axis_input = time axis of input})
##
## @seealso{}
## @end deftypefn

## Author: Haitham <@HAITHAM>
## Created: 2021-07-03

function x = deconvolution(y, Fs, U_input, time_axis_input)

% calulate the time value of samples
h = zeros(int64(size(y, 1)/2), 1); %Impulse 

% Generate impulse train 
h(U_input(:, 1)*Fs*0.4)=U_input(:, 2);
figure(1);
% plot the input waveform 
subplot(2, 1, 1);
plot(time_axis_input, y, 'b');
xlabel('Time in seconds');
ylabel('signal strength');

ly=length(y);

% Make the deconv at frequency domain(division) and get the inverse
% X=Y/H
x = ifft(fft(y, ly) ./fft(h, ly));

% Get some statistics
disp(["Mean ", num2str(mean(abs(x)))])


x = x(1:size(x)*.7143, :)./max(abs(x)); % Normalises Signal

% Define the time axis of input
xlen=length(x);
disp(xlen/Fs);
time_axis_out=([1:xlen]-1)/Fs;

subplot(2, 1, 2);

plot(time_axis_out, x, 'r');
xlabel("Time in seconds")
ylabel('signal strength')


endfunction
