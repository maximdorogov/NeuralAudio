function [ output ] = tang_prima( h ,beta )
%UNTITLED Summary of this function goes here

        output = beta*(1 - tanh(beta*h).^2);


end

