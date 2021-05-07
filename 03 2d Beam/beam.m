% beam.m
%
% LINEAR STATIC ANALYSIS OF A CONTINUOUS BEAM
%
clc % Clear screen
clear % Clear all variables in memory
%
% Make these variables global so they can be shared
% by other functions
%
global nnd nel nne nodof eldof n 
global geom connec F prop nf Element_loads Joint_loads force Hinge
%

disp('Executing beam.m');
%
% Open file for output of results
%
% ALTER THE NEXT LINES TO CHOOSE AN OUTPUT FILE FOR THE RESULTS
%
disp('Results to be printed to file : beam_1_results.txt '); 
fid=fopen('beam_1_results.txt','w');
%
%
% ALTER THE NEXT LINE TO CHOOSE AN INPUT FILE
%
beam_1_data % Load the input file
%
%
KK =zeros(n) ; % Initialize global stiffness
% matrix to zero

%
F=zeros(n,1); % Initialize global force vector to zero
F = form_beam_F(F); % Form global force vector
%
print_beam_model % Print model data
%
for i=1:nel
    kl=beam_k(i); % Form element matrix
%
    g=beam_g(i);  % Retrieve the element steering
% vector
%
    KK =form_KK(KK, kl, g); % assemble global stiffness
% matrix
%
end
%
%%%%%%%%%%%% End of assembly %%%%%%%%%%%
%
%
delta = KK\F ; % solve for unknown displacements
%
% Extract nodal displacements
%
for i=1:nnd
    for j=1:nodof
        node_disp(i,j) = 0;
        if nf(i,j)~= 0;
            node_disp(i,j) = delta(nf(i,j)) ;
        end
    end
end
%
% Calculate the forces acting on each element
% in local coordinates, and store them in the
% vector force().
%
for i=1:nel
    kl=beam_k(i); % Form element matrix
%
    g=beam_g(i) ; % Retrieve the element steering vector
    for j=1:eldof
        if g(j)== 0
            ed(j)=0.; % displacement = 0. for restrained freedom
        else
            ed(j) = delta(g(j));
        end
    end
    
    fl = kl*ed'; % Element force vector in global XY
    f0 = Element_loads(i,:);
    force(i,:) = fl-f0';
end
%
print_beam_results;
%
fclose(fid);