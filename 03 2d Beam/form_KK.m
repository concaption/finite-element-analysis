function[KK]=form_KK(KK, kg, g)
%
% This function assembles the global stiffness matrix
%
    global eldof
%
% This function assembles the global stiffness matrix
%
    for i=1:eldof
        if g(i) ~= 0
            for j=1: eldof
                if g(j) ~= 0
                    KK(g(i),g(j))= KK(g(i),g(j)) + kg(i,j);
                end
            end
        end
    end
end
%
%%%%%%%%%%%%% end function form_KK %%%%%%%%%%%%%%%%%