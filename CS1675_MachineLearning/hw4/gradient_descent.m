function w = gradient_descent(X, y)
%weights calculated using gradient descent 

   %Initialize weights to 0s
   w = zeros(size(X,2),1);
   n = size(X,1);
   for i=0:1000
       k=mod(i,n)+1;
       alpha = 0.05/(i+1);
       prediction = LR_predict(X(k,:),w);
       w = w + alpha*(y(k) - prediction)*X(k,:)';
   end

end

