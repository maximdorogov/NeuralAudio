clear all,close all,clc


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%% Levanto los datos para entrenar la red %%%%%%%%%%%%%%

[audio_in Fs] = audioread('..\NeuralAudio\tracks_guitar\clean_guitar_5s.wav');
[audio_out Fs] = audioread('..\NeuralAudio\tracks_guitar\distorted_guitar_5s.wav');

[y1,xf1] = myNeuralNetworkFunction(audio_in',[0.1 ; 0.1]');

figure
hold on

plot(audio_out)
plot(y1)


