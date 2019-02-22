clear all,close all;

load workspace.mat;
%[audio_in Fs] = audioread('..\NeuralAudio\tracks_guitar\clean_riff.wav');

[audio_in Fs] = audioread('..\NeuralAudio\tracks_guitar\net_out_audio.wav');
[audio_out Fs] = audioread('..\NeuralAudio\tracks_guitar\distorted_riff.wav');


%SAMPLES = 100;
INIT_FRAME = 1;
END_FRAME = SAMPLES;
CHOP_SIZE = SAMPLES;

FRAMES_QTY = length(audio_in)/CHOP_SIZE;
for i=1:FRAMES_QTY
    
    input_signal = audio_in(INIT_FRAME:END_FRAME)';
    
    net_output(INIT_FRAME:END_FRAME) = get_audio_frame( W_in, W_out, audio_in(INIT_FRAME:END_FRAME)',beta );
     
    INIT_FRAME = INIT_FRAME + CHOP_SIZE;
    END_FRAME = END_FRAME + CHOP_SIZE;
end

%sound(net_output,Fs)

figure
hold on
plot(net_output)
plot(audio_out)
legend('NET Output','Real Output')
return
d = fdesign.lowpass('N,Fc',10,5e3,48000);
Hd = design(d);
filt_audio = filter(Hd,net_output);

% subplot(2,1,1)
% plot(filt_audio);
% title('NET Output Filtrada')
% subplot(2,1,2)
% plot(net_output);
% title('NET Output')
% 
% sound(filt_audio(1:76800),Fs)

return
SAMPLES = 512;
INIT_FRAME = 1;
END_FRAME = SAMPLES;
CHOP_SIZE = SAMPLES;

for i = 1:5
    large_output(INIT_FRAME:END_FRAME) = net_output(1:20000);
    INIT_FRAME = INIT_FRAME + CHOP_SIZE;
    END_FRAME = END_FRAME + CHOP_SIZE;
end
sound(large_output,Fs)
return
play(nnAudio)
play(audioObj)
return