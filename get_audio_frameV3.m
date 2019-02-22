function [ output_frame ] = get_audio_frameV3( W_in, W_out, W_hidden, input, beta_1,beta_2 )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    
        X_in = [input 1]'; %le concateno un 1 debido al modelo

        h = W_in*X_in; 
        
        out_first_layer = tanh(h*beta_1);
                
        X_out = [ out_first_layer ;1]; %le concateno un 1 debido al modelo
        
        h_hidden = W_hidden*X_out;
        
        v_hidden = tanh(h_hidden*beta_2);
        X_hidden_out = [v_hidden ;1];  
        
        h_s = W_out* X_hidden_out;
        
        output_frame = tanh(h_s*beta_1);

end