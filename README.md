# Echo-generation-and-removal
This project add echo to signal and remove it
# Introduction
In this report we will show the procedure to make an echo generation system and how to fix it.
Table of content 
* [Generate_Echo_audio_Conv.m](#Generate_Echo_audio_Conv.m)
* [convolveDelayedDecayed](#convolveDelayedDecayed.m)
* [deconvolution](#deconvolution.m)
## Generate_Echo_audio_Conv.m 
we will import the audio, we used native to read the original audio
[x, Fs] = audioread("input.wav", 'native');
We compute the mean, mode and median, to make sure the original voice is greater than the 
others.
disp(["Mean ", num2str(mean(abs(x)))])
disp(["Mode ", num2str(mode(x))])
disp(["Median ", num2str(median(x))])
We get the size of the audio to get the input from it then listen to the sound.
We asked the user to enter the input or get the our inputs.
choice=input("Would you like to:\n1- Enter the input\n2- Take our input\n>>");
%{ if the choice is 2 then use our input}%
if choice==2 || size(choice) == 0, 
if T < 1,
 fprintf("Length of the song should be greater than 1\ Closing.")
 i=0;
 while i++<T
 fprintf(".")
 pause(1);
 end
 quit
 end
If the input time less than 1 then the song will be too short.
If the user enters 2 or doesn't enter any i/p, he will use our i/ps.
% Get weak input
 for i=1:int64(T);
 U_input_weak(i, 1)= i;
 %{
 Take random input and multiply the input by 0.001 to get weak signal
 we took the mean of rand(5, 1) to get all the input approximately equal
 ((-1)^randi(5)) to make the weight +ve/-ve
 %}
 U_input_weak(i, 2)= ((-1)^randi(5))*mean(rand(5, 1))*0.001;
 end
 U_input_weak 
 % Normal 
 for i=1:int64(T);
 U_input_normal(i, 1)= i;
 %{
 Take random input and multiply the input by 0.01 to get normal signal
 we took the mean of rand(5, 1) to get all the input approximately equal
 ((-1)^randi(5)) to make the weight +ve/-ve
 %}
 U_input_normal(i, 2)= ((-1)^randi(5))*mean(rand(5, 1))*0.01;
 end
 U_input_normal 
 % Strong 
 for i=1:int64(T);
 U_input_strong(i, 1)= i;
 %{
 Take random input and multiply the input by 0.1 to get strong signal
 we took the mean of rand(5, 1) to get all the input approximately equal
 ((-1)^randi(5)) to make the weight +ve/-ve
 %}
 U_input_strong(i, 2)= ((-1)^randi([5, 10]))*mean(rand(5,1))*0.1;
 end
 U_input_strong
If the user enter choice=1 he will enter the i/p else the program will close
Then we will make the convolution using convolveDelayedDecayed function to get the echo 
and use deconvolution to get the echo removed.
## convolveDelayedDecayed.m 
Get the impulse response to make convolution with the input to get the echo
% calulate the time value of samples
h = zeros(size(x, 1), 1); %Impulse 
% Generate impulse train (get h[n])
h(U_input(:, 1)*Fs*0.4)=U_input(:, 2);
We will put h as 𝑘𝛿[𝑛 − 𝑖] then h[i*Fs*0.4]=k
We plot the input, get the length of output then make convolution in frequency domain 
(Multiplication) to get the echo.
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
Get the mean to make sure strong > normal > weak
disp(["Mean ", num2str(mean(abs(y_out)))])
disp(["Mode ", num2str(mode(y_out))])
disp(["Median ", num2str(median(y_out))])
Normalize if and take only the part that we want
y_out = (y_out./mean(abs(x)))(1:size(y_out)*0.7,:);
Plot the impulse response 
subplot(3, 1, 2);
plot(time_axis_input(1:0.25*size(time_axis_input(:)))'*Fs, h(1:size(h)*0.25), 'g');
xlabel('Time in seconds');
ylabel('Impulses')
title("Impulse Train");
Plot the out put and get the o/p axis 
time_axis_out=([1:y_outlen]-1)/Fs;
subplot(3, 1, 3);
plot(time_axis_out, y_out, 'r');
xlabel("Time in seconds")
ylabel('signal strength')
## deconvolution.m 
Get the impulse response 
% calulate the time value of samples
h = zeros(int64(size(y, 1)/2), 1); %Impulse 
% Generate impulse train 
h(U_input(:, 1)*Fs*0.4)=U_input(:, 2); 
Plot the output
subplot(2, 1, 1);
plot(time_axis_input, y, 'b');
xlabel('Time in seconds');
ylabel('signal strength');
Make deconvolution at frequency domain (division), we used the same impulse response that we 
used to make the echo and by converting output and impulse response to frequency domain and 
divide Y/H ➔ X with no echo, then use inverse fourier transform we get x with no echo.
x = ifft(fft(y, ly) ./fft(h, ly));
Make the axis and plot the input
time_axis_out=([1:xlen]-1)/Fs;
subplot(2, 1, 2);
plot(time_axis_out, x, 'r');
xlabel("Time in seconds")
ylabel('signal strength')
