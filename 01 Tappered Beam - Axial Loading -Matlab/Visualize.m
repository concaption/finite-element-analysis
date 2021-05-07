
function post=visual(y,w,sigma)
    
    n=size(w,1)-1;

    cmap=jet(n+2); % some colours are created.   
    
   
    Sigma=sigma-min(sigma);  % a new stress array is created which starts from zero instead of min(sigma)
    Sigma=Sigma/max(Sigma);  % it is normalized so that the max stress location is one and min. stress location is 0 
   
    index=floor(Sigma*n)+1;  
    
   del=Sigma*n+1-index;
  
    post=figure;
    for i=1:n
        
            
        c=del(i)*cmap(index(i),:)+(1-del(i))*cmap(index(i)+1,:);
        %c=cmap(index(i));
        
        X=[-w(i+1)/2 -w(i)/2 w(i)/2 w(i+1)/2];
        Y=[-y(i+1) -y(i) -y(i) -y(i+1)];
        
        
        fill(X,Y,c,'LineStyle','none');
        hold on
    end
  
    colormap(jet);
    colorbar;
    
end
