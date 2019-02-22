clear all,close all,clc;

%Fs es la misma para ambos tracks
[data_set_in Fs1] = audioread('..\NeuralAudio\tracks_guitar\GUITDIBASE_2.wav');
[data_set_out Fs2] = audioread('..\NeuralAudio\tracks_guitar\GUIT57BASE_2.wav');

data_set_in = data_set_in(:,1);
data_set_out = data_set_out(:,1);

data_set_in = data_set_in(9e4:288000);
data_set_out = data_set_out(9e4:288000);

sound(data_set_out,Fs1)
x = linspace(0,1,200);
window = ones(1,length(data_set_in));
window(1:200) = x;
% plot(window(1:500));



x = linspace(1,0,200);
window(end-199:end) = x;

data_set_in = data_set_in.*window';
data_set_out = data_set_out.*window';


figure
hold on
plot(data_set_in)
plot(data_set_out)

%me voy a quedar con los primeros  segundos de cada track
% elimino los silencios al inicio de cada track


audiowrite('clean_riff.wav',data_set_in,Fs1);
audiowrite('distorted_riff.wav',data_set_out,Fs2);
% 
% subplot(2,1,1)
% plot(data_set_in);
% title('Clean Guitar')
% 
% subplot(2,1,2)
% plot(data_set_out);
% title('Distorted Guitar')
% 
% diff = data_set_in - data_set_out;
% audioObj = audioplayer(data_set_out,Fs);
% play(audioObj,Fs)



return
