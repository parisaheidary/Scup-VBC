%this function reads the previous run final water content and concentration
%in the profile and re-writes them as initial conditions in the next run
function[]=domain_cont(folder ,longsimulation,runN,simulation,nodes)

fid=fopen([folder simulation runN '\h.out']);
h=fread(fid,inf,'float');
h_final=h(nodes+3:(nodes*2+2),:);
fclose(fid);
%This part reads the domain file from the previous run and re-writes a new
%Domain.dat file that will be used for the next simulation. The data added
%to the new domain.dat file are the final h and conc conditions from the
%last simulation that are the initial conditions for this simulation.
%----the same can be done with the roots for a plant that is growing!!!

fid = fopen([longsimulation '\DOMAIN.dat'], 'r');%CHECK that this file is updated!!!
i = 1;
lines{i} = fgets(fid);
while ischar(lines{i})
    i = i + 1;
    lines{i} = fgets(fid);
end
fclose(fid);
%% Se convierten y almacenan los datos numericos en la variable data
for ind = 7 : nodes+6
    v= lines{ind};
    C=strsplit(v,' ');
    %here we save the final conditions from last simulations as initial
    %conditionso of the next one. if we have standard solute transport we
    %need to add it here as well.
    hf={num2str(h_final(ind-6))};
    C(4)=hf;
    lines{ind}=strjoin(C);
end
%----Writing the new domain.dat file
fid = fopen([longsimulation '\DOMAIN.dat'], 'w');
for ind = 1:(size(lines,2)-1)
    fprintf(fid, lines{ind});
end
fclose(fid);
end