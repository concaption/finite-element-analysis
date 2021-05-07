clc
w1=2;   %width at the base
w2=2;   %width at the free end
t=0.125;    %thickness of the bar
L=10;   %length of the bar
T_L=300;  %temprature at right hand side of the bar
B=3000; %heating strength
k=100;   %conductivity

N_e=10;
N_n=N_e+1;

dx=L/N_e;  %length of each element

x=mesh(N_n,dx);

w=w1-(w1-w2)*x/L;
A=w*t;

H=global_conduction(A,k,dx);

F=forcing(dx,A,B,k,T_L,x);

T=H\F;

figure;
plot(x,T);

if w1==w2
    T_exact=B*(x(N_n)+sin(x)-sin(x(N_n))-x)/k+T_L;
    hold on
    plot(x,T_exact,'x')
end

post=visual(x,w,T);




function F=forcing(dx,A,B,k,T_L,x)
    n=size(A,1);
    
    F=zeros(n,1);
    
    for i=2:n-1
       F(i)=B*sin(x(i))*(A(i-1)+A(i+1)); 
    end
    
    F(n,1)=300;
    
    F=F*dx^2/(2*k);

end

function H=global_conduction(A,k,dx)
    n=size(A,1);
    
    H=zeros(n);
    
    for i=2:n-1
        H(i,i)=A(i-1)+A(i+1);
        H(i,i-1)=-A(i-1);
        H(i,i+1)=-A(i+1);
    end
    
    H(1,1)=1;
    H(1,2)=-1;
    
    H(n,n)=dx^2/(2*k);
    
    
end


function x=mesh(N_n,dx)

    x=zeros(N_n,1);
    
    for i=1:N_n
        x(i)=(i-1)*dx;
    end

end




function post=visual(x,w,T)
    
    n=size(w,1)-1;

    cmap=jet(n+2); % some colours are created.   
    
   
    TT=T-min(T);  % a new stress array is created which starts from zero instead of min(sigma)
    TT=TT/max(TT);  % it is normalized so that the max stress location is one and min. stress location is 0 
   
    index=floor(TT*n)+1;  
    
   del=TT*n+1-index;
  
    post=figure;
    for i=1:n
        
            
        c=del(i)*cmap(index(i),:)+(1-del(i))*cmap(index(i)+1,:);
        %c=cmap(index(i));
        
        X=[-w(i+1)/2 -w(i)/2 w(i)/2 w(i+1)/2];
        Y=[-x(i+1) -x(i) -x(i) -x(i+1)];
        
        
        fill(X,Y,c,'LineStyle','none');
        hold on
    end
  
    colormap(jet);
    colorbar;
    
end