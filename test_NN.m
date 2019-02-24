clear all,close all;

load workspace.mat;
[audio_in Fs] = audioread('acordes_clean.wav');

[audio_out Fs] = audioread('acordes_distor.wav');

 audio_in = audio_in(1.71e5:6.69e5,1);
 audio_out = audio_out(1.71e5:6.69e5,1);


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


sound(large_output,Fs)
return
play(nnAudio)
play(audioObj)
return