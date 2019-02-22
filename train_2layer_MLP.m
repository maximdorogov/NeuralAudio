function [ W_in, W_out ] = train_2layer_MLP( data_set_in, data_set_out,W_in, W_out, beta, n )

%Entrena un MLP de 2 capas con back propagation
%Recibe el data set y los pesos sinapticos de cada capa.

        X_in = [data_set_in 1]'; %le concateno un 1 debido al modelo
        
        h = W_in*X_in;
        
        v = tanh(h*beta);
        
        X_out = [v ;1]; %le concateno un 1 debido al modelo
        
        h_s = W_out*X_out;
        
        y = tanh(h_s*beta);
      
        delta_s = tang_prima(h_s,beta).*(data_set_out - y); %ok
        
        delta_in = ((delta_s'*W_out(:,1:end-1)).*(tang_prima(h,beta))')'; % ok?
        
        W_out = W_out + n*delta_s*[v ;1]'; % ok
        
        W_in = W_in + n*delta_in*X_in';

end

