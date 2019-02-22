% Monografia final: Redes Neuronales

% En estre trabajo se pretende implementar un perceptron multicapa que
% pueda aprender y emular sistemas analogicos no lineales.
% A partir de trabajos anteriores se espera implementar una red con N
% perceptrones por cada capa, siendo N el tamanio de muestras a
% procesar. 
% En los trabajos usados como referencia se sugiere trabajar con 2 capas
% ocultas y un buffer_size de 40-60 muestras.

clear all,close all,clc

%%%%%%%%%%%%%%% Genero un dataset de prueba %%%%%%%%%%%%%%%%%

% t = linspace(0,2*pi,SAMPLES);
% data_set_in = sin(2*t) + sin(t*5);

%%%%%%%%%%%%%%% Normalizo los datos de entrada %%%%%%%%%%%%%%%

% data_set_in = data_set_in./max(data_set_in);
% data_set_out = tanh(2*data_set_in)';
% 
% dist_out = data_set_out;
% 
% dist_out(dist_out > 0.6) = 0.6;
% dist_out(dist_out < -0.6) = -0.6;
% data_set_out = dist_out;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%% Levanto los datos para entrenar la red %%%%%%%%%%%%%%

[audio_in Fs] = audioread('..\NeuralAudio\tracks_guitar\clean_guitar_5s.wav');
[audio_out Fs] = audioread('..\NeuralAudio\tracks_guitar\distorted_guitar_5s.wav');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%% Imprimo los daturros %%%%%%%%%%%%%%%%%%%%%%%%%%%%

% figure
% hold on
% plot(data_set_in(6000:7000))
% plot(data_set_out(6000:7000))
% legend('Clean Guitar','Distorted Guitar')
% return
% Implementacion con 1 capa oculta y una capa de salida.

BUFFER_SIZE = 20000;
SAMPLES = BUFFER_SIZE;

PERCEPTRONS_HIDDEN_LAYER = BUFFER_SIZE;
PERCEPTRONS_OUTPUT_LAYER = BUFFER_SIZE;

W_in = randn(PERCEPTRONS_HIDDEN_LAYER,BUFFER_SIZE + 1);
W_out = randn(PERCEPTRONS_OUTPUT_LAYER,PERCEPTRONS_HIDDEN_LAYER + 1);

net_output = zeros(SAMPLES,1);
num_iter = 0;

%%%%%%%%%%%%%%% Parametros del aprendizaje (Backpropagation) %%%%%%%%%%%%%

beta = 0.07;
n = 0.05;

FRAMES_QTY = 1;

INIT_FRAME = 1;
END_FRAME = SAMPLES;
CHOP_SIZE = SAMPLES;

for i=1:FRAMES_QTY
    
    data_set_in = audio_in(INIT_FRAME:END_FRAME)';
    data_set_out = audio_out(INIT_FRAME:END_FRAME);
    
    INIT_FRAME = INIT_FRAME + CHOP_SIZE;
    END_FRAME = END_FRAME + CHOP_SIZE;
    
    ecm = immse(data_set_out,net_output); % ecm inicial
    
    while (ecm > 1e-3)

            %%%---CALCULO los H, deberia tener un vector de 20 H's

            X_in = [data_set_in 1]'; %le concateno un 1 debido al modelo

            h = W_in*X_in; 

            v = tanh(h*beta);

            X_out = [v ;1]; %le concateno un 1 debido al modelo

            h_s = W_out*X_out;

            y = tanh(h_s*beta);

            delta_s = tang_prima(h_s,beta).*(data_set_out - y); %ok

            delta_in = ((delta_s'*W_out(:,1:end-1)).*(tang_prima(h,beta))')'; % ok?

            W_out = W_out + n*delta_s*[v ;1]'; % ok

            W_in = W_in + n*delta_in*X_in';

        %calculo las salidas y ver el error cuadratico medio.
        net_output = get_audio_frame( W_in, W_out, data_set_in,beta );

        ecm = immse(data_set_out,net_output) % muestro error actual en pantalla
    end
end



return

figure
hold on
plot(data_set_in);
plot(data_set_out);
plot(net_output);
legend('Input Guitar Signal','Processed Guitar Signal','Emulated Output')


