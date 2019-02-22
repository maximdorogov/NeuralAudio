clear all,close all;

load 10FRAMES_1024SAMPLES_3LAYERS.mat;

[audio_in Fs] = audioread('..\NeuralAudio\tracks_guitar\clean_riff.wav');
[audio_out Fs] = audioread('..\NeuralAudio\tracks_guitar\distorted_riff.wav');

%audio_in = audio_in*0.5;

%SAMPLES = 100;
INIT_FRAME = 1;
END_FRAME = SAMPLES;
CHOP_SIZE = SAMPLES;

FRAMES_QTY = length(audio_in)/CHOP_SIZE;

for i=1:FRAMES_QTY
    
    input_signal = audio_in(INIT_FRAME:END_FRAME)';
    
    net_output(INIT_FRAME:END_FRAME) = get_audio_frameV3( W_in, W_out,W_hidden, audio_in(INIT_FRAME:END_FRAME)',beta_1,beta_2 );
     
    INIT_FRAME = INIT_FRAME + CHOP_SIZE;
    END_FRAME = END_FRAME + CHOP_SIZE;
end

d = fdesign.lowpass('N,Fc',5,5e3,48000);
Hd = design(d);
filt_audio = filter(Hd,net_output);
% 
% subplot(2,1,1)
% plot(filt_audio);
% title('NET Output Filtrada')
% subplot(2,1,2)
% plot(net_output);
% title('NET Output')
figure
hold on
plot(net_output)
plot(audio_out)
%plot(filt_audio)
legend('NET Output','Real Output')
return
%sound(filt_audio,Fs)


figure
hold on
plot(net_output)
plot(audio_out)
legend('NET Output','Real Output')
