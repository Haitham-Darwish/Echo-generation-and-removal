% Clear comand window and any 
clc;clear;

%% -------------- read a .wav file -------------------%
%% Use native to read the original audio 
[x, Fs] = audioread("input.wav", 'native');
%% ------- process the .wav file -------
%% ------- convolution based reverb ----
 
% Get some statistics
disp(["Mean ", num2str(mean(abs(x)))])
disp(["Mode ", num2str(mode(x))])
disp(["Median ", num2str(median(x))])

% length of the audio in samples
xlen=length(x);
T = xlen/Fs;
% Print the length of the voice after echo
disp(T);
% Define the time axis of input
time_axis_input=([1:xlen]-1)/Fs;

% play the original audio
disp("let's listen to the original voice") 
sound(x, Fs)

%Pause further process untill the .wav play completly
%pause(T)


%-----------------------define input-----------------------------
%{Ask the user whether want to enter the h or use ours}%
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
  
  %U_input_weak=zeros(int64(T), 2);
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
  %U_input_strong=zeros(int64(T), 2);
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

%{ if choice is 1 then use your input %}  
elseif choice==1,
  loop=1
  
  %{ Loop untill get the right h %}
  while loop
    
    %{ Take the 'h' from user %}
     disp("Please enter the input in form of k*delta[n-i] [i k]") 
     U_input_weak=input("Please enter the input of the weak signal")
     U_input_normal=input("Please enter the input of the normal signal")
     U_input_strong=input("Please enter the input of the strong signal")
     
     %{Make the loop is 0 to exit from the while loop %}
     loop=0
    
    %{ Take the weak input %}
     for i=U_input_weak(:, 1),
       %{ 
          if delta[n+i] then non causal system we can't implement it then will
          make the loop=1 to reenter the weak input and break from for loop.
        %}
       if i<0
        disp("Non-Causal weak input!!!\nPlease enter number greater than 0")
        loop=1;
        break;
       end
     end
     
      %{ Take the normal input %}
     for i=U_input_normal(:, 1),
        %{ 
          if delta[n+i] then non causal or predictive system we can't 
          implement it then will make the loop=1 to reenter the normal input
        %}
       if i<0
         disp("Non-Causal normal input!!!\nPlease enter number greater than 0")
         loop=1
         break;
        end
     end
      
     %{ Take the strong input %} 
     for i=U_input_strong(:, 1),
        %{ 
          if delta[n+i] then non causal system we can't implement it then will 
          assign the loop to 1 to reenter the strong input
        %}
       if i<0
         disp("Non-Causal strong input!!!\nPlease enter number greater than 0")
         loop=1
         break
        end
     end
     
   end %end while 
   
 %{ if the user enter number not 1 or 2 then wrong input and close the program%} 
else 
   fprintf("You entered wrong input closing.")
   i=0;
   while i++<choice
    fprintf(".")
    pause(1);
  end
   quit
   
end% end if
 


%------------------Convolution to make the echo----------------------
% Weak signal
%{ Convolve between input and weak impulse response to get weak output signal %}
[y_out_weak time_axis_out]=convolveDelayedDecayed (x, Fs, U_input_weak,
                                                     time_axis_input);
                                                    
% save the wave
title("Relation between delayed weak version of the signal and time");
saveas(gcf, "Weak signal.png", "PNG")
figure(2);
% Plot the weak wave
plot(time_axis_out, y_out_weak, 'r');
xlabel("Time in seconds")
ylabel('Weak signal')
title("Relation between delayed weak version of the signal and time");
saveas(gcf, "Weak signal2.png", "PNG")
% --------  Write a .wav file------------------
audiowrite('y_out_weak.wav', y_out_weak,Fs);

disp("let's listen to the weak echo")
[temp, Fs] = audioread("y_out_weak.wav", "native");
sound(temp, Fs)

% Normal signal
[y_out_normal time_axis_out]=convolveDelayedDecayed (x, Fs, U_input_normal, 
                                                      time_axis_input);


% save the wave
title("Relation between delayed strong version of the signal and time");
saveas(gcf, "Normal signal.png", "PNG")
figure(2);
% Plot the normal wave
plot(time_axis_out, y_out_normal, 'r');
xlabel("Time in seconds")
ylabel('Normal signal')
title("Relation between delayed normal version of the signal and time");
saveas(gcf, "Normal signal2.png", "PNG")
% --------  Write a .wav file------------------
audiowrite('y_out_normal.wav',y_out_normal,Fs);

disp("let's listen to the normal echo")
[temp, Fs] = audioread("y_out_normal.wav", "native");
sound(temp, Fs)

%Strong signal
[y_out_strong time_axis_out]=convolveDelayedDecayed (x, Fs, U_input_strong,
                                                       time_axis_input);


% Save the wave
title("Relation between delayed strong version of the signal and time");
saveas(gcf, "Strong signal.png", "PNG")
figure(2);
% Plot the strong wave
plot(time_axis_out, y_out_strong, 'r');
xlabel("Time in seconds")
ylabel('Strong signal')
title("Relation between delayed strong version of the signal and time");

saveas(gcf, "Strong signal2.png", "PNG")

% --------  Write a .wav file------------------
audiowrite('y_out_strong.wav',y_out_strong,Fs);

disp("let's listen to the Strong echo")
[temp, Fs] = audioread("y_out_strong.wav", "native");
sound(temp, Fs)

%-------------------------------------------------------------------------------
% Get the deconvolution

% Weak 
y_out_weak_deconv=deconvolution(y_out_weak, Fs, U_input_weak,
                                  time_axis_out);

title("Relation between modified weak version of the signal and time");                                  
saveas(gcf, "y_out_weak_mod.png", "PNG")

audiowrite('y_out_weak_mod.wav',y_out_weak_deconv,Fs);

disp("let's listen to the modified weak echo")
sound(y_out_weak_deconv, Fs);

% Normal
y_out_normal_deconv=deconvolution(y_out_normal, Fs, U_input_normal,
                                  time_axis_out);

title("Relation between modified normal version of the signal and time");
saveas(gcf, "y_out_normal_mod.png", "PNG")
audiowrite('y_out_normal_mod.wav',y_out_normal_deconv,Fs);

disp("let's listen to the modified normal echo")
sound(y_out_normal_deconv, Fs);


% Strong
y_out_strong_deconv=deconvolution(y_out_strong, Fs, U_input_strong,
                                  time_axis_out);
                                  
title("Relation between modified strong version of the signal and time");
saveas(gcf, "y_out_strong_mod.png", "PNG")                                  
audiowrite('y_out_strong_mod.wav',y_out_strong_deconv,Fs);
disp("let's listen to the modified strong echo")
sound(y_out_strong_deconv, Fs);