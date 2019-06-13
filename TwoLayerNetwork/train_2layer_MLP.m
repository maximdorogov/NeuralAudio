function [ W_in, W_out ] = train_2layer_MLP( data_set_in, data_set_out,W_in, W_out, beta, n )

%This function trains a neural network using N-dimentional backpropagation 
%Receive a input and target data vectors, the Layers weights and the training params.
%Returns updated weights as matrixes


        X_in = [data_set_in 1]'; 
        
        h = W_in*X_in;
        
        v = tanh(h*beta);
        
        X_out = [v ;1];
        
        h_s = W_out*X_out;
        
        y = tanh(h_s*beta);
      
        delta_s = tang_prima(h_s,beta).*(data_set_out - y); %ok
        
        delta_in = ((delta_s'*W_out(:,1:end-1)).*(tang_prima(h,beta))')'; % ok?
        
        W_out = W_out + n*delta_s*[v ;1]'; % ok
        
        W_in = W_in + n*delta_in*X_in';

end

