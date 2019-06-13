% Final Work: Neural Networks Subject

% In this work a MLP is implemented.
% The goal of the porject is predict the output of a tube amplifier modeled
% as a black box model. The training set is formed by recorded clean
% signals and their output from a real amplifier.
% N samples input frames - N samples output frames. 


% To Do
%  Randomize the Training Frames
%  Filter the output before ECM calc (use paper's suggestion)
%  Modify the Loss Function (Must use a signal to noise relation)
% Try again windowing the frames
%%

clear all,close all,clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%% Read the training frames %%%%%%%%%%%%%%

[audio_in Fs] = audioread('DATA_SET\Arpegio_clean.wav');
[audio_out Fs] = audioread('DATA_SET\Arpegio_MARSHALL_J45.wav');

audio_in = audio_in(:,1);
audio_out = audio_out(:,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

data_set_in = audio_in;
data_set_out = audio_out;

%audio_in = audio_in(44000:end);
%audio_out = audio_out(44000:end);

%%%%%%%%%%%%%%%%%%%%%% Plot the data %%%%%%%%%%%%%%%%%%%%%%%%%%%%

% figure
% hold on
% plot(audio_in)
% plot(audio_out)
% legend('Clean Guitar','Distorted Guitar')
% return

% Implementation with one hidden layer and one output layer

BUFFER_SIZE = 512;
SAMPLES = BUFFER_SIZE;
NOVERLAP = BUFFER_SIZE / 2;

%%%%%%%%%%%%%%%  Windowing %%%%%%%%%%%%%%%

%window = triang(BUFFER_SIZE)';

%%%%%%%%%%%%%%%  Layer Size Assignment %%%%%%%%%%%%%%%

PERCEPTRONS_HIDDEN_LAYER = BUFFER_SIZE + 100;
PERCEPTRONS_OUTPUT_LAYER = BUFFER_SIZE;

W_in = randn(PERCEPTRONS_HIDDEN_LAYER,BUFFER_SIZE + 1);
W_out = randn(PERCEPTRONS_OUTPUT_LAYER,PERCEPTRONS_HIDDEN_LAYER + 1);

net_output = zeros(SAMPLES,1); %Prealocate Memory (Its not C but ...)

%%%%%%%%%%%%%%% Learning Parameters (Backpropagation) %%%%%%%%%%%%%

beta = 0.09;
n = 0.05;
ECM = 0.0012; %Target ECM

FRAMES_QTY = 221;

%Use rectangular frame to separate the frames

CHOP_SIZE = SAMPLES; 

% Initial ECM
ecm = 1;

%load Win_Wout.mat %Accelerate the training if I load pre-trained weights

while (ecm >= ECM)
    
    INIT_FRAME = 1;
    END_FRAME = SAMPLES;
    
    for i=1:FRAMES_QTY

        data_set_in = audio_in(INIT_FRAME:END_FRAME)';
       
        %data_set_in = data_set_in.*window;
        data_set_out = audio_out(INIT_FRAME:END_FRAME)';
        %data_set_out = data_set_out.*window;

        INIT_FRAME = INIT_FRAME + CHOP_SIZE;
        END_FRAME = END_FRAME + CHOP_SIZE;
         
        [ W_in, W_out ] = train_2layer_MLP( data_set_in, data_set_out',W_in, W_out, beta, n );
                
    end
    
    INIT_FRAME = 1;
    END_FRAME = SAMPLES;
    
    for i=1:FRAMES_QTY
               
        input_signal = audio_in(INIT_FRAME:END_FRAME)';
        
        net_output(INIT_FRAME:END_FRAME) = get_audio_frame( W_in, W_out, audio_in(INIT_FRAME:END_FRAME)',beta);
        
        INIT_FRAME = INIT_FRAME + CHOP_SIZE;
        END_FRAME = END_FRAME + CHOP_SIZE;
    end
    
    ecm = immse(audio_out(1:length(net_output)),net_output)
    
end


d = fdesign.lowpass('N,Fc',6,4e3,48000);
Hd = design(d);
filt_audio = filter(Hd,net_output);

figure
hold on
plot(audio_out);
plot(net_output);
legend('Real Output','Emulated Output')

%plot(filt_audio);
% figure 
% hold on
% plot(nn_out);
% plot(filt_audio);
%legend('Processed Guitar Signal','Emulated Output','Filtered output')


