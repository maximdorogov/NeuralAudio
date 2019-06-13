function [ output_frame ] = get_audio_frame( W_in, W_out, input, beta )

    
        X_in = [input 1]'; 

        h = W_in*X_in; 
        
        out_first_layer = tanh(h*beta);
                
        X_out = [ out_first_layer ;1]; 
        
        h_s = W_out*X_out;
        
        output_frame = tanh(h_s*beta);

end

