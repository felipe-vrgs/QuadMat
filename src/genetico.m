%% Genetico: function description
function [gainsOut, fitOut] = Genetico(Target,SetPoint)
    Geracoes = 20;
    global Individuos NumGenes;
    Individuos = 12;
    NumGenes = 3; % Kp Kd e Ki
    OldFit = zeros(Individuos);
    FitnessIn = zeros(Individuos);
    Gains = zeros(Geracoes,Individuos,NumGenes);
    Selected = zeros(Geracoes,Individuos,NumGenes);
    for G = 1:Geracoes
        disp(['Entrando na Geração: ',num2str(G)])
        if (G == 1)
            for I = 1:Individuos
                Gains(G,I,1) = 5*rand(); % Kp
                Gains(G,I,2) = rand(); % Ki
                Gains(G,I,3) = 15*rand(); % Kd
                disp(['Calculando Fitness do individuo: ',num2str(I)])
                FitnessIn(I) =  Fitness(Target,Gains(1,I,:),SetPoint);
                disp(['Valor do Fitness do individuo: ',num2str(FitnessIn(I))])
            end
        else
            Gains(G,:,:) =  Selected(G-1,:,:);
            FitnessIn(:) = OldFit(:)
        end
        [Selected(G,:,:), OldFit(:)] = Select(Gains(G,:,:),SetPoint,Target,FitnessIn(:));
        % Selected
        if (G == Geracoes)
            Selected(G,1,:)
        end
    end
end

%% Mutations: function description
function [Selected, OldFit] = Select(Gains,SetPoint,Target,FitnessIn)
    global Individuos NumGenes
    Selected = zeros(1,Individuos,NumGenes);
    OldFit = zeros(Individuos);
    % Ordena colocando os melhores primeiro para a Pre-seleção
    [BestFitIn,OldIdxIn] = sort(FitnessIn,'descend');
    % Vamos utilizar somente os melhores
    SelectedInd = Individuos/2;
    Pai1 = zeros(SelectedInd,NumGenes);
    Pai2 = zeros(SelectedInd,NumGenes);
    Filhos1 = zeros(SelectedInd,NumGenes);
    Filhos2 = zeros(SelectedInd,NumGenes);
    Filhos3 = zeros(SelectedInd,NumGenes);
    FitnessPai = zeros(SelectedInd);
    FitnessFilhos1 = zeros(SelectedInd);
    FitnessFilhos2 = zeros(SelectedInd);
    FitnessFilhos3 = zeros(SelectedInd);
    % Crossover usando os melhores pais
    for C = 1:SelectedInd
        Pai1(C,:) = Gains(1,round((SelectedInd - 1)*(rand())) + 1,:);
        Pai2(C,:) = Gains(1,OldIdxIn(C),:);
        FitnessPai(C) = BestFitIn(C);
        Alpha = rand();
        for NG = 1:NumGenes
            Filhos1(C,NG) = Mutation((1 - Alpha)*Pai1(C,NG) + Alpha*Pai2(C,NG));
            Filhos2(C,NG) = Mutation((1 - Alpha)*Pai2(C,NG) + Alpha*Pai1(C,NG));
            Filhos3(C,NG) = Mutation(Pai2(C,NG)/2 + Pai1(C,NG)/2);
        end
        disp(['Calculando Fitness do filho 1 para o individuo: ',num2str(OldIdxIn(C))])
        FitnessFilhos1(C) = Fitness(Target,Filhos1(C,:),SetPoint);
        disp(['Valor do Fitnees do filho: ',num2str(FitnessFilhos1(C))])
        disp(['Calculando Fitness do filho 2 para o individuo: ',num2str(OldIdxIn(C))])
        FitnessFilhos2(C) = Fitness(Target,Filhos2(C,:),SetPoint);
        disp(['Valor do Fitnees do filho: ',num2str(FitnessFilhos2(C))])
        disp(['Calculando Fitness do filho 3 para o individuo: ',num2str(OldIdxIn(C))])
        FitnessFilhos3(C) = Fitness(Target,Filhos3(C,:),SetPoint);
        disp(['Valor do Fitnees do filho: ',num2str(FitnessFilhos2(C))])
    end
    % Seleção
    Population = cat(1,Pai2(:,:),Filhos1(:,:),Filhos2(:,:),Filhos3(:,:));
    FitPop = cat(1,FitnessPai(:,1),FitnessFilhos1(:,1),FitnessFilhos2(:,1),FitnessFilhos3(:,1));
    PopSize = size(Population);
    [BestFit,OldI] = sort(FitPop,'descend');
    for S = 1:(PopSize(1)/2)
        Selected(:,S,:) = Population(OldI(S),:);
        OldFit(S) = BestFit(S);
    end
end

%% Mutation: function description
function [NewVal] = Mutation(OldVal)
    Chance = 0.15;
    if (rand < Chance)
        NewVal = OldVal  + (4*rand() - 1.9)*OldVal;
    else
        NewVal = OldVal;
    end
end
