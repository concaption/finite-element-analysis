clc

%% 

w1 = 2;        % width at the base
w2 = 2;        % width at the free end
t  = 0.125;    % thickness of the bar
L  = 10;       % length of the bar
B  = 3000;     % heating strength
k  = 100;      % conductivity
Tr = 300;      % temperature at the right hand side of the bar

%% 

Ne = 100;
Nn = Ne+1;
dx = L/Ne;

x  = mesh(Nn,dx);
w  = w1-(w1-w2)*x/L;
A  = w*t;
H  = global_condcution(A,k,dx);
F  = forcing(dx,A,B,k,x);
T  = H\F;
plot(x,T)

if w1==w2
    T_exact=B*(x(Nn)+sin(x)-sin(x(Nn))-x)/k+Tr;
    hold on
    plot(x,T_exact,'x')
    hold off
end

%% 

function x=mesh(Nn,dx)
    x=zeros(Nn,1);
    for i=1:Nn
        x(i)=(i-1)*dx;
    end
end

function H = global_condcution(A,k,dx)
    n = size(A,1);
    H = zeros(n);
    H(1,1)=1;
    H(1,2)=-1;
    H(n,n)=(dx^2)/(2*k);
    for i=2:n-1
        H(i,i)=A(i-1)+A(i+1);
        H(i,i+1)=-A(i+1);
        H(i,i-1)=-A(i-1);
    end
end

function F  = forcing(dx,A,B,k,x)
    n=size(A,1);
    F=zeros(n,1);
    F(n,1)=300;
    for i=2:n-1
        F(i)=B*sin(x(i))*(A(i-1)+A(i+1));
    end
    F=F*dx^2/(2*k);
end
