clc

%% 

w1=2;       % width at the base
w2=1;       % width at the free end
t=0.125;    % thickness of the bar
L=10;       % length of the bar
P=1000;     % applied loading at the free end
E=10.4E6;   % elastic modulus

%% 

N_e = 10;
N_n = N_e+1;
dy  = L/N_e;

y = mesh(N_n,dy);
w = w1-(w1-w2)*y/L;
A = w*t;
k = stiffness(A,E,dy);
K = global_stiffness(k);
F = zeros(N_n,1);
F(N_n)=P;
u=K\F;
sigma=stress(E,u,dy)

%% 

plot(y,u,'x','markersize',12)
hold on
u_exact = P*L*(log(w1+(w2-w1)*y/L)-log(w1))/(E*t)/(w2-w1);
plot(y,u_exact,'o',"MarkerSize",12)
hold off

%% 

function y=mesh(N_n,dy)
y=zeros(N_n,1);
for i=1:N_n
    y(i)=(i-1)*dy;
end
end

function k=stiffness(A,E,dy)
    n=size(A,1)-1;      % number of elements
    k=zeros(n,1);
    for i=1:n
        k(i)=E*(A(i)+A(i+1))/(2*dy);
    end
end

function K=global_stiffness(k)
    n=size(k,1)+1;      % number of nodes
    K=zeros(n);
    for i=2:n-1
        K(i,i)=k(i-1)+k(i);
        K(i,i-1)=-k(i-1);
        K(i,i+1)=-k(i);
    end
    K(1,1)=1;
    K(n,n)=k(n-1);
    K(n,n-1)=-k(n-1);
end

function sigma=stress(E,u,dy)
    n=size(u,1)-1;       % number of elements
    sigma = zeros(n,1);
    
    for i=1:n
        sigma(i)=E*(u(i+1)-u(i))/dy;
    end
end