function [ output_frame ] = get_audio_frame( W_in, W_out, input, beta )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    
        X_in = [input 1]'; %le concateno un 1 debido al modelo

        h = W_in*X_in; %h contiene desde h1 a h20
        
        out_first_layer = tanh(h*beta);
                
        X_out = [ out_first_layer ;1]; %le concateno un 1 debido al modelo
        
        h_s = W_out*X_out;
        
        output_frame = tanh(h_s*beta);

end

