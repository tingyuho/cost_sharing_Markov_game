%A = rand(3, 1e6);
tic;
fid = fopen('C:\Users\user\Dropbox\Paper\2016_journal of health economics\Cost_Sharing_Markov_Game\Cost_Sharing_Markov_Game.dat', 'w+');
%fid = fopen('C:\Users\TingYu Ho\Dropbox\Paper\2016_journal of health economics\Cost_Sharing_Markov_Game\Cost_Sharing_Markov_Game.dat', 'w+');

NbStates = 5 ; %normal, PH, HS1, HS2, CVD
NbAction_L = 3; %10% 20% 30%
NbAction_F = 2; %do nothing, treatment

NbDiscreteP= 6;

%parameter
CostTreatment = [0, 3000] ; %[Action_F] 
BenefitFormulary  = [0,0.1;0,0.3;0,0.5]; %[Action_L][Action_F]
Probability  =  [0, 0.2, 0.4, 0.6, 0.8, 1]; %P_K
%Beta = [0.3,0.2,0.2,0.2,0.1]  ; %[State]
Beta = [0.3,0.3,0.15,0.15,0.1]  ; %[State]
%Beta = [0,0.2,0.3,0.3,0.2]  ; %[State]
%Beta = [0,0.1,0.4,0.4,0.1]
Gamma_L = 0.8;
Gamma_F = 0.8;
PmtAction_F  = [0,10]; %[Action_F]
PmtHealth_L = [2000,0,0,0,-1500]; %State
PmtHealth_F = [2000,-50,-100,-300,-1500]; %State
R_L  = zeros(NbStates,NbAction_L,NbAction_F);%[State][Action_L][Action_F]
R_F  = zeros(NbStates,NbAction_L,NbAction_F); %[State][Action_L][Action_F]
T  = zeros(NbAction_F,NbStates,NbStates);%[Action_F][State][State]			

T(1,:,:)=[0.8, 0.2, 0, 0,0; 
    0, 0.5, 0.5, 0, 0; 
    0, 0, 0.2, 0.6, 0.2; 
    0, 0, 0, 0.8, 0.2;
    0, 0, 0, 0, 1];

T(2,:,:)=[1, 0, 0, 0, 0;
    0.5, 0.3, 0.2, 0, 0;
    0, 0.6, 0.25, 0.1, 0.05;
    0, 0, 0.6, 0.3, 0.1;
    0, 0, 0, 0, 1];
   
%{
T(2,:,:)=[1, 0, 0, 0, 0;
    0.5, 0.3, 0.2, 0, 0;
    0, 0.6, 0.25, 0.1, 0.05;
    0, 0, 0.6, 0.3, 0.1;
    0, 0, 0.3, 0.3, 0.4];
%} 
%{ 
T(1,:,:)=[0.8, 0.2, 0, 0,0; 
    0, 0.6, 0.4, 0, 0; 
    0, 0, 0.4, 0.5, 0.1; 
    0, 0, 0, 0.9, 0.1;
    0, 0, 0, 0, 1];
T(2,:,:)=[1, 0, 0, 0, 0;
    0.65, 0.2, 0.15, 0, 0;
    0, 0.7, 0.25, 0.05, 0;
    0, 0, 0.7, 0.2, 0.1;
    0, 0, 0, 0, 1];
%} 
for i=1:NbAction_F
    for j=1:NbStates
        if round(sum(T(i,j,:))*10000)~=10000
            i
            j
            fprintf('transition probability data error: sum doesnot equal to 1');
        end
    end
end

for s=1:NbStates
    for al=1:NbAction_L
        for af=1:NbAction_F
            R_L (s,al,af) =-(1-BenefitFormulary(al,af))*CostTreatment(af)+PmtHealth_L(s);
            R_F (s,al,af) = -BenefitFormulary(al,af)*CostTreatment(af)+PmtHealth_F(s)+(PmtAction_F(af))^2; 
        end
    end
end


fprintf(fid, 'NbStates = %i', NbStates); 
fprintf(fid, ';\n');
fprintf(fid, 'NbAction_L = %i', NbAction_L); 
fprintf(fid, ';\n');
fprintf(fid, 'NbAction_F = %i', NbAction_F); 
fprintf(fid, ';\n');
fprintf(fid, 'NbDiscreteP = %i', NbDiscreteP); 
fprintf(fid, ';\n');

%parameter
fprintf(fid, 'CostTreatment = ['); 
for i=1:size(CostTreatment,2)
    fprintf(fid, '%d', CostTreatment(i));
    if i<size(CostTreatment,2)
        fprintf(fid, ',');
    end
end
fprintf(fid, ']'); 
fprintf(fid, ';\n');

fprintf(fid, 'BenefitFormulary =['); 
for i=1:size(BenefitFormulary,1)
    fprintf(fid, '['); 
    for j=1:size(BenefitFormulary,2)
        fprintf(fid, '%.1f', BenefitFormulary(i,j));
        if j<size(BenefitFormulary,2)
            fprintf(fid, ',');
        end
    end
    fprintf(fid, ']');
    if i<size(BenefitFormulary,1)
    	fprintf(fid, ',');
    end
end
fprintf(fid, ']'); 
fprintf(fid, ';\n');

fprintf(fid, 'Probability =['); 
for i=1:size(Probability,2)
    fprintf(fid, '%.2f', Probability(i));
    if i<size(Probability,2)
        fprintf(fid, ',');
    end
end
fprintf(fid, ']'); 
fprintf(fid, ';\n');

fprintf(fid, 'Beta =['); 
for i=1:size(Beta,2)
    fprintf(fid, '%.2f', Beta(i));
    if i<size(Beta,2)
        fprintf(fid, ',');
    end
end
fprintf(fid, ']');
fprintf(fid, ';\n');

fprintf(fid, 'Gamma_L = %f', Gamma_L); 
fprintf(fid, ';\n');
fprintf(fid, 'Gamma_F = %f', Gamma_F); 
fprintf(fid, ';\n');

fprintf(fid, 'PmtAction_F=['); 
for i=1:size(PmtAction_F,2)
    fprintf(fid, '%d', PmtAction_F(i));
    if i<size(PmtAction_F,2)
        fprintf(fid, ',');
    end
end
fprintf(fid, ']');
fprintf(fid, ';\n');

fprintf(fid, 'PmtHealth_L=['); 
for i=1:size(PmtHealth_L,2)
    fprintf(fid, '%d', PmtHealth_L(i));
    if i<size(PmtHealth_L,2)
        fprintf(fid, ',');
    end
end
fprintf(fid, ']');
fprintf(fid, ';\n');

fprintf(fid, 'PmtHealth_F=['); 
for i=1:size(PmtHealth_F,2)
    fprintf(fid, '%d', PmtHealth_F(i));
    if i<size(PmtHealth_F,2)
        fprintf(fid, ',');
    end
end
fprintf(fid, ']');
fprintf(fid, ';\n');

fprintf(fid, 'R_L=[');
for s=1:size(R_L,1)
    fprintf(fid, '['); 
    for al=1:size(R_L,2)
            fprintf(fid, '['); 
        for af=1:size(R_L,3)
            fprintf(fid, '%.1f', R_L(s,al,af));
            if af<size(R_L,3)
                fprintf(fid, ',');
            end
        end
        fprintf(fid, ']');
        if al<size(R_L,2)
            fprintf(fid, ',');
        end
    end
    fprintf(fid, ']');
    if s<size(R_L,1)
    	fprintf(fid, ',');
    end
end
fprintf(fid, ']');
fprintf(fid, ';\n');

fprintf(fid, 'R_F= [');
for s=1:size(R_F,1)
    fprintf(fid, '['); 
    for al=1:size(R_F,2)
            fprintf(fid, '['); 
        for af=1:size(R_F,3)
            fprintf(fid, '%.1f', R_F(s,al,af));
            if af<size(R_F,3)
                fprintf(fid, ',');
            end
        end
        fprintf(fid, ']');
        if al<size(R_F,2)
            fprintf(fid, ',');
        end
    end
    fprintf(fid, ']');
    if s<size(R_F,1)
    	fprintf(fid, ',');
    end
end
fprintf(fid, ']');
fprintf(fid, ';\n');

fprintf(fid, 'T = [');
for s=1:size(T,1)
    fprintf(fid, '['); 
    for al=1:size(T,2)
            fprintf(fid, '['); 
        for af=1:size(T,3)
            fprintf(fid, '%.2f', T(s,al,af));
            if af<size(T,3)
                fprintf(fid, ',');
            end
        end
        fprintf(fid, ']');
        if al<size(T,2)
            fprintf(fid, ',');
        end
    end
    fprintf(fid, ']');
    if s<size(T,1)
    	fprintf(fid, ',');
    end
end
fprintf(fid, ']');
fprintf(fid, ';\n');

fprintf(fid, 'Z = %i', 10000000); 
fprintf(fid, ';\n');

fclose(fid);
toc