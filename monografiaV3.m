% Monografia final: Redes Neuronales

% En estre trabajo se pretende implementar un perceptron multicapa que
% pueda aprender y emular sistemas analogicos no lineales.
% A partir de trabajos anteriores se espera implementar una red con N
% perceptrones por cada capa, siendo N el tamanio de muestras a
% procesar. 
% En los trabajos usados como referencia se sugiere trabajar con 2 capas
% ocultas y un buffer_size de 40-60 muestras.

clear all,close all,clc


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%% Levanto los datos para entrenar la red %%%%%%%%%%%%%%

[audio_in Fs] = audioread('..\NeuralAudio\tracks_guitar\clean_riff.wav');
[audio_out Fs] = audioread('..\NeuralAudio\tracks_guitar\distorted_wha_riff.wav');

audio_in = audio_in;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%% Imprimo los daturros %%%%%%%%%%%%%%%%%%%%%%%%%%%%

% figure
% hold on
% plot(data_set_in(6000:7000))
% plot(data_set_out(6000:7000))
% legend('Clean Guitar','Distorted Guitar')
% return
% Implementacion con 2 capas oculta y una capa de salida.

BUFFER_SIZE = 512;
SAMPLES = BUFFER_SIZE;

PERCEPTRONS_HIDDEN_LAYER_A = BUFFER_SIZE;
PERCEPTRONS_HIDDEN_LAYER = BUFFER_SIZE;
PERCEPTRONS_OUTPUT_LAYER = BUFFER_SIZE;

W_in = randn(PERCEPTRONS_HIDDEN_LAYER,BUFFER_SIZE + 1);
W_out = randn(PERCEPTRONS_OUTPUT_LAYER,PERCEPTRONS_HIDDEN_LAYER + 1);
W_hidden = randn(PERCEPTRONS_HIDDEN_LAYER_A,PERCEPTRONS_HIDDEN_LAYER_A + 1);

net_output = zeros(SAMPLES,1);

%%%%%%%%%%%%%%% Parametros del aprendizaje (Backpropagation) %%%%%%%%%%%%%

beta_1 = 0.1;
beta_2 = 0.1;
n = 0.05;

FRAMES_QTY = 100;

ECM = 0.003;

%uso ventana rectangular porque es mas gg izi

INIT_FRAME = 1;     
END_FRAME = SAMPLES;
CHOP_SIZE = SAMPLES / 2; % no uso ventana de hamming porque alta paja

%load Win_Wout_W_hidden.mat

for i=1:FRAMES_QTY
    
    input_signal = audio_in(INIT_FRAME:END_FRAME)';
    
    net_output(INIT_FRAME:END_FRAME) = get_audio_frameV3( W_in, W_out,W_hidden, audio_in(INIT_FRAME:END_FRAME)',beta_1,beta_2 );
     
    INIT_FRAME = INIT_FRAME + CHOP_SIZE;
    END_FRAME = END_FRAME + CHOP_SIZE;
end

ecm = immse(audio_out(1:length(net_output)),net_output);


while (ecm > ECM)
    
    INIT_FRAME = 1;
    END_FRAME = SAMPLES;
    %CHOP_SIZE = SAMPLES / 2;
    
    for i=1:FRAMES_QTY

        data_set_in = audio_in(INIT_FRAME:END_FRAME)';
        data_set_out = audio_out(INIT_FRAME:END_FRAME);

        INIT_FRAME = INIT_FRAME + CHOP_SIZE;
        END_FRAME = END_FRAME + CHOP_SIZE;
            
        %%%---CALCULO los H,  vector de  H's
        
        X_in = [data_set_in 1]'; %le concateno un 1 debido al modelo
        
        h = W_in*X_in;
        
        v = tanh(h*beta_1);
        
        X_out = [v ;1]; %le concateno un 1 debido al modelo
 %%%%%%%%%%%       
   
        h_hidden = W_hidden*X_out;
        v_hidden = tanh(h_hidden*beta_2);
        X_hidden_out = [v_hidden ;1];        
        h_s = W_out*X_hidden_out;
        
 %%%%%%%%%%%       
        y = tanh(h_s*beta_1);
        
        delta_s = tang_prima(h_s,beta_1).*(data_set_out - y); %ok
        
        delta_hidden = ((delta_s'*W_out(:,1:end-1)).*(tang_prima(h_hidden,beta_2))')'; % ok?
        
        delta_in = ((delta_hidden'*W_hidden(:,1:end-1)).*(tang_prima(h,beta_1))')';
        
        W_out = W_out + n*delta_s*[v_hidden ;1]'; % ok
        
        W_hidden = W_hidden + n*delta_hidden*[v ;1]';
        
        W_in = W_in + n*delta_in*X_in';
        
        %calculo las salidas y ver el error cuadratico medio.
        net_output = get_audio_frameV3( W_in, W_out, W_hidden, data_set_in, beta_1,beta_2 ); 
        
    end
    
    INIT_FRAME = 1;
    END_FRAME = SAMPLES;
    
    for i=1:FRAMES_QTY
               
        input_signal = audio_in(INIT_FRAME:END_FRAME)';
        
        net_output(INIT_FRAME:END_FRAME) = get_audio_frameV3( W_in, W_out,W_hidden, audio_in(INIT_FRAME:END_FRAME)',beta_1,beta_2 );
        
        INIT_FRAME = INIT_FRAME + CHOP_SIZE;
        END_FRAME = END_FRAME + CHOP_SIZE;
    end
    
    ecm = immse(audio_out(1:length(net_output)),net_output)
    
end



return

figure
hold on
plot(data_set_in);
plot(data_set_out);
plot(net_output);
legend('Input Guitar Signal','Processed Guitar Signal','Emulated Output')


