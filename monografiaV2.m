% Monografia final: Redes Neuronales

% En estre trabajo se pretende implementar un perceptron multicapa que
% pueda aprender y emular sistemas analogicos no lineales.
% A partir de trabajos anteriores se espera implementar una red con N
% perceptrones por cada capa, siendo N el tamanio de muestras a
% procesar. 
% En los trabajos usados como referencia se sugiere trabajar con 2 capas
% ocultas y un buffer_size de 40-60 muestras.

%% Aplicar ventana triangular a cada frame.
%  randomizar la seleccion de frames en el aprendizaje.
% Probar con un ecm maximo en el orden de 0.02
%%

clear all,close all,clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%% Levanto los datos para entrenar la red %%%%%%%%%%%%%%
%[audio_in Fs] = audioread('..\NeuralAudio\tracks_guitar\net_out_audio.wav');
[audio_in Fs] = audioread('..\NeuralAudio\tracks_guitar\clean_riff.wav');
[audio_out Fs] = audioread('..\NeuralAudio\tracks_guitar\distorted_riff.wav');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%audio_in = audio_in(44000:end);

%audio_out = audio_out(44000:end);

%%%%%%%%%%%%%%%%%%%%%% Imprimo los datos %%%%%%%%%%%%%%%%%%%%%%%%%%%%

% figure
% hold on
% plot(audio_in)
% plot(audio_out)
% legend('Clean Guitar','Distorted Guitar')
% return
% Implementacion con 1 capa oculta y una capa de salida.

BUFFER_SIZE = 512;
SAMPLES = BUFFER_SIZE;
NOVERLAP = BUFFER_SIZE / 2;

%%%%%%%%%%%%%%% Ventana triangular %%%%%%%%%%%%%%%

window = triang(BUFFER_SIZE)';

PERCEPTRONS_HIDDEN_LAYER = BUFFER_SIZE + 100;
PERCEPTRONS_OUTPUT_LAYER = BUFFER_SIZE;

W_in = randn(PERCEPTRONS_HIDDEN_LAYER,BUFFER_SIZE + 1);
W_out = randn(PERCEPTRONS_OUTPUT_LAYER,PERCEPTRONS_HIDDEN_LAYER + 1);

net_output = zeros(SAMPLES,1);

%%%%%%%%%%%%%%% Parametros del aprendizaje (Backpropagation) %%%%%%%%%%%%%

beta = 0.09;
n = 0.05;
ECM = 0.005;

FRAMES_QTY = 200;

%uso ventana rectangular para separar los frames

CHOP_SIZE = SAMPLES; 

ecm = 1;

load Win_Wout.mat

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
%plot(filt_audio);
% figure 
% hold on
% plot(nn_out);
% plot(filt_audio);
%legend('Processed Guitar Signal','Emulated Output','Filtered output')


