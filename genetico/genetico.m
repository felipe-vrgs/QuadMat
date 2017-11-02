%% PARTE 1 - DEFINIÇÕES
clear %Limpa as variáveis
clc %Limpa a tela
close all %Fecha todas as figuras
fclose('all'); %Fecha todos os arquivos

Funcao = 'expcirc'; % schwefel, rastrigin, expcirc
Crossover = 'aritmetico'; % aritmetico, ponto
Selecao = 'torneio'; %roleta, torneio

Nome = [Funcao '_' Crossover '_' Selecao];
d = 2;
switch Funcao
    case 'schwefel'
        Custo = @(dim,x1,x2) 418.9829*d - (x1.*sin(sqrt(abs(x1)))-x2.*sin(sqrt(abs(x2))));
        Dominio = [-500 500]; %Limite superior e inferior do domínio
    case 'rastrigin'
        Custo = @(dim,x1,x2) 20+x1.^2+x2.^2-10*(cos(2*pi.*x1)+cos(2*pi.*x2));
        Dominio = [-5 5]; %Limite superior e inferior do domínio
    case 'expcirc'
        Custo = @(dim,x1,x2) x1.*exp(-((x1.^2)+(x2.^2)));
        Dominio = [-2 2];
    otherwise
        error('Nenhuma função custo válida foi definida');
end

[X,Y] = meshgrid(Dominio(1):((Dominio(2)-Dominio(1))/200):Dominio(2));
Z = Custo(d,X,Y);
Pop = 200;
PopVector = zeros(Pop,d);
FitnessPop = zeros(Pop,1);
GeracaoMax = 1000;
ErroMax = 1e-4;
MaximoGeracaoFitness = 50; %Número máximo de gerações com o mesmo fitness máximo
Pc = 0.7; %Percentual de crossover
PopTorneio = 20; %População concorrendo no torneio
Treinos = 10;
CorInicial = [0.2 0.2 0.8];
CorFinal = [0.8 0.2 0.2];
FitnessTreinos = zeros(GeracaoMax,Treinos);
FitnessMaximoTreinos = zeros(GeracaoMax,Treinos);
FitnessMinimoTreinos = zeros(GeracaoMax,Treinos);

GeracoesConv = zeros(Treinos,1);

%% PARTE 2 - INICIALIZAÇÃO
IniLog = clock(); %Pega a data e hora atual
fileID = fopen(sprintf('logs\\log_genetico_%s_%d_%02d_%02d_%02d_%02d_%02d.txt',Nome,IniLog(1),IniLog(2),IniLog(3),IniLog(4),IniLog(5),floor(IniLog(6))),'wt'); %Abre o arquivo de log
fprintf(fileID,'INICIO DO LOG\n%d-%02d-%02d %02d:%02d:%02.0f\n',IniLog(1),IniLog(2),IniLog(3),IniLog(4),IniLog(5),IniLog(6)); %Grava no log
fprintf('INICIO DO LOG\n%d-%02d-%02d %02d:%02d:%02.0f\n',IniLog(1),IniLog(2),IniLog(3),IniLog(4),IniLog(5),IniLog(6)); %Exibe na tela

%% PARTE 3 - TREINAMENTOS
for iTreino = 1:Treinos
    fprintf('\nInicando execução #%d...\n',iTreino);
    fprintf(fileID,'\nInicando execução #%d...\n',iTreino);
    FitnessGeracao = zeros(GeracaoMax,1);
    
    %Geração da população inicial
    for i = 1:Pop
        PopVector(i,1) = (rand()*(Dominio(2)-Dominio(1)))+Dominio(1);
        PopVector(i,2) = (rand()*(Dominio(2)-Dominio(1)))+Dominio(1);
        FitnessPop(i) = Custo(d,PopVector(i,1),PopVector(i,2));
        %FitnessPop(i) = 418.9829*d - (PopVector(i,1).*sin(sqrt(abs(PopVector(i,1))))-PopVector(i,2).*sin(sqrt(abs(PopVector(i,2)))));
    end
    
    %Gráfico da população inicial
    fprintf('Plotando gráfico da população inicial da execução #%d\n',iTreino); %Exibe na tela
    fprintf(fileID,'Plotando gráfico da população inicial da execução #%d\n',iTreino); %Exibe na tela
    Plot_PopIni = figure(); %Gera a Figura 1
    mesh(X,Y,Z,'LineWidth',0.3);
    hold on
    scatter3(PopVector(:,1),PopVector(:,2),FitnessPop(:),'*','MarkerEdgeColor',CorInicial);
    hold off
    Plot_Title  = title(sprintf('População Inicial da Execução #%d',iTreino)); %Adiciona o título
    Plot_xLabel = xlabel('x_1'); %Define o rótulo do eixo X
    Plot_yLabel = ylabel('x_2'); %Define o rótulo do eixo Y
    Plot_zLabel = zlabel('f(x_1,x_2)'); %Define o rótulo do eixo Z
    set(gcf,'Color',[1,1,1]) %Define a cor de fundo do gráfico
    set(Plot_Title,'FontName','Helvetica','FontSize',14,'FontWeight','bold') %Formata o título
    %set(Plot_Leg,'FontName','Helvetica','FontSize',10,'FontAngle','oblique','FontName','Helvetica') %Formata a legenda
    set(Plot_PopIni, 'Position', [0, 0, 1024, 768]); %Formata o tamanho da figura
    NomeArquivo = strcat(['graficos\\Grafico_genetico_' Nome '_PopInicial_Treino' int2str(iTreino) '.png']); %Prepara o nome do arquivo do gráfico
    print(Plot_PopIni,NomeArquivo,'-dpng','-r300','-opengl') %Salva em png
    FitnessMax = zeros(MaximoGeracaoFitness,1);
    
    for Geracao = 1:GeracaoMax
        FitnessMedioAnt = mean(FitnessPop);
        
        %Crossover
        switch Crossover
            case 'aritmetico'
                for i = 1:Pop
                    if(Pc>rand())
                       Pai1 = PopVector(i,:);
                       Pai2 = PopVector(ceil(rand*length(PopVector)),:);
                       Alpha = rand();
                       Filho1 = (1-Alpha)*Pai1 + Alpha*Pai2;
                       Filho2 = Alpha*Pai1 + (1-Alpha)*Pai2;
                       FitnessFilho1 = Custo(d,Filho1(1,1),Filho1(1,2));
                       FitnessFilho2 = Custo(d,Filho2(1,1),Filho2(1,2));
                       PopVector = [PopVector; Filho1; Filho2];
                       FitnessPop = [FitnessPop; FitnessFilho1; FitnessFilho2];
                    end
                end   
           case 'ponto' 
                for i = 1:Pop
                    if(Pc>rand())
                        Pai1 = PopVector(i,:);
                        Pai2 = PopVector(ceil(rand*length(PopVector)),:);
                        Alpha = rand();
                        Filho1 = [Pai1(1) Pai2(2)];
                        Filho2 = [Pai1(2) Pai2(1)];
                        FitnessFilho1 = Custo(d,Filho1(1,1),Filho1(1,2));
                        FitnessFilho2 = Custo(d,Filho2(1,1),Filho2(1,2));
                        PopVector = [PopVector; Filho1; Filho2];
                        FitnessPop = [FitnessPop; FitnessFilho1; FitnessFilho2];
                    end
                end   
           otherwise
               error('Nenhum crossover válido foi especificado.');
        end
               
               
               

        %Seleção por roleta
        
        switch Selecao
            case 'roleta'
                FitnessAjustado = FitnessPop - min(FitnessPop); %Ajusta o zero
                if(sum(FitnessAjustado)==0)
                   FitnessAjustado = FitnessPop; 
                end
                FitnessAjustado = FitnessAjustado/max(FitnessAjustado); %Normaliza
                SomaFitness = 0;
                for iPop = 1:length(PopVector)
                   SomaFitness = SomaFitness + FitnessAjustado(iPop); 
                end
                
                FitnessProbabilidade = FitnessAjustado/SomaFitness;
                FitnessAcumulado = zeros(length(FitnessProbabilidade),1);
                for iFit = 1:length(FitnessProbabilidade)
                    FitnessAcumulado(iFit) = sum(FitnessProbabilidade(1:iFit));
                end
                PopVectorNovo = [];
                FitnessNovo = [];
                while(length(PopVectorNovo)<Pop)
                    Indice = rand();
                    for iPop = 1:length(PopVector)
                       if(FitnessAcumulado(iPop)>Indice)
                           PopVectorNovo = [PopVectorNovo; PopVector(iPop,:)];
                           FitnessNovo = [FitnessNovo; FitnessPop(iPop,:)];
                           break
                       end
                    end
                end
                PopVector = PopVectorNovo;
                FitnessPop = FitnessNovo;
            case 'torneio'
                FitnessMax = zeros(MaximoGeracaoFitness,1);
                while(length(PopVector)>Pop)
                    FitnessTorneio = zeros(PopTorneio, 1);
                    IndicePop = zeros(PopTorneio, 1);
                    for iTorneio = 1:PopTorneio
                        IndicePop(iTorneio) = ceil(rand*length(PopVector));
                        FitnessTorneio(iTorneio) = FitnessPop(IndicePop(iTorneio));
                    end
                    [FitnessMin,iFitnessMin] = min(FitnessTorneio);
                    PopVector(IndicePop(iFitnessMin),:) = [];
                    FitnessPop(IndicePop(iFitnessMin),:) = [];
                end  
            otherwise
                error('Nehum critério de seleção válido foi informado');
        end
         
        FitnessMedioAtual = mean(FitnessPop);
        FitnessTreinos(Geracao,iTreino) = mean(FitnessPop);
        FitnessMaximoTreinos(Geracao,iTreino) = max(FitnessPop);
        FitnessMinimoTreinos(Geracao,iTreino) = min(FitnessPop);
        
        FitnessGeracao(Geracao) = mean(FitnessPop);
        FitnessMax(1:(length(FitnessMax)-1)) = FitnessMax(2:length(FitnessMax));
        FitnessMax(length(FitnessMax)) = max(FitnessPop);
        DifFitness = abs(FitnessMedioAtual-FitnessMedioAnt)/abs(FitnessMedioAtual);
        
        GeracoesConv(iTreino) = Geracao;
        fprintf('Época %4d -> Fitness Médio %5.4f  Fitness Máximo %4.4f Diferença no Fitness %.4f\n',Geracao,mean(FitnessPop),max(FitnessPop),DifFitness);
        fprintf(fileID,'Época %4d -> Fitness Médio %5.4f  Fitness Máximo %4.4f Diferença no Fitness %.4f\n',Geracao,mean(FitnessPop),max(FitnessPop),DifFitness);

        %Critério de parada
        if(DifFitness<ErroMax)
            fprintf('CRITÉRIO DE PARADA ATINGIDO NA ÉPOCA %d: Diferença de fitness médio\n',Geracao);
            fprintf(fileID,'CRITÉRIO DE PARADA ATINGIDO NA ÉPOCA %d: Diferença de fitness médio\n',Geracao);
            break;
        end
        if(max(FitnessMax) == mean(FitnessMax))
            fprintf('CRITÉRIO DE PARADA ATINGIDO NA ÉPOCA %d: Valor máximo se manteve por várias gerações\n',Geracao);
            fprintf(fileID,'CRITÉRIO DE PARADA ATINGIDO NA ÉPOCA %d: Valor máximo se manteve por várias gerações\n',Geracao);
            break;
        end
        if(Geracao == GeracaoMax)
            fprintf('CRITÉRIO DE PARADA ATINGIDO NA ÉPOCA %d: Número máximo de gerações\n',Geracao);
            fprintf(fileID,'CRITÉRIO DE PARADA ATINGIDO NA ÉPOCA %d: Número máximo de gerações\n',Geracao);
            break;
        end
    end
    
    %Gráfico da população final
    fprintf('Plotando gráfico da população final da execução #%d\n',iTreino); %Exibe na tela
    fprintf(fileID,'Plotando gráfico da população final da execução #%d\n',iTreino); %Exibe na tela
    Plot_PopFinal = figure(); %Gera a Figura 1
    mesh(X,Y,Z,'LineWidth',0.3);
    hold on
    scatter3(PopVector(:,1),PopVector(:,2),FitnessPop(:),'*','MarkerEdgeColor',CorFinal);
    hold off
    Plot_Title  = title(sprintf('População final da Execução #%d',iTreino)); %Adiciona o título
    Plot_xLabel = xlabel('x_1'); %Define o rótulo do eixo X
    Plot_yLabel = ylabel('x_2'); %Define o rótulo do eixo Y
    Plot_zLabel = zlabel('f(x_1,x_2)'); %Define o rótulo do eixo Z
    set(gcf,'Color',[1,1,1]) %Define a cor de fundo do gráfico
    set(Plot_Title,'FontName','Helvetica','FontSize',14,'FontWeight','bold') %Formata o título
    %set(Plot_Leg,'FontName','Helvetica','FontSize',10,'FontAngle','oblique','FontName','Helvetica') %Formata a legenda
    set(Plot_PopFinal, 'Position', [0, 0, 1024, 768]); %Formata o tamanho da figura
    NomeArquivo = strcat(['graficos\\Grafico_genetico_' Nome '_PopFinal_Treino' int2str(iTreino) '.png']); %Prepara o nome do arquivo do gráfico
    print(Plot_PopFinal,NomeArquivo,'-dpng','-r300','-opengl') %Salva em png
    
    FitnessGeracao = FitnessGeracao(1:Geracao);
end

%% PARTE 4 - GRÁFICOS
%Gráfico 3 - Fitness Médio x Geração
FitnessTreinos = FitnessTreinos(1:max(GeracoesConv),:);
FitnessMaximoTreinos = FitnessMaximoTreinos(1:max(GeracoesConv),:);
FitnessMinimoTreinos = FitnessMinimoTreinos(1:max(GeracoesConv),:);

for iT = 1:Treinos
    for iG = 1:max(GeracoesConv)
        if(FitnessTreinos(iG,iT)==0)
           FitnessTreinos(iG,iT) =  FitnessTreinos(iG-1,iT);
           FitnessMaximoTreinos(iG,iT) = FitnessMaximoTreinos(iG-1,iT);
           FitnessMinimoTreinos(iG,iT) = FitnessMinimoTreinos(iG-1,iT);
        end
    end
end

fprintf('\nRESULTADOS \n'); %Exibe na tela
fprintf(fileID,'\nRESULTADOS \n'); %Exibe na tela
fprintf('Média de gerações para convergência: %.4f \n', mean(GeracoesConv)); %Exibe na tela
fprintf(fileID,'Média de gerações para convergência: %.4f \n', mean(GeracoesConv)); %Exibe na tela

%Gráfico Fitness Médio
fprintf('Plotando gráfico Fitness Médio x Geração \n'); %Exibe na tela
fprintf(fileID,'Plotando gráfico Fitness Médio x Geração \n'); %Exibe na tela
Plot_Fitness = figure(); %Gera a Figura
Legenda = {}; %Inica a legenda como um conjunto de células vazio 
for iTreino = 1:Treinos %Para cada um dos treinos
    Legenda = [Legenda, ['Fitness Médio Execução #' int2str(iTreino)]]; %Concatena a legenda
    %loglog(1:EpocasConv(iTreino),Erros(1:EpocasConv(iTreino),iTreino)); %Plota o gráfico
    plot(1:max(GeracoesConv),FitnessTreinos(:,iTreino));
    hold on %Ativa o superposicionamento dos gráficos
    %semilogy(Epocas,ErroEpoca) %Cria o gráfico logaritmico em y com o erro em função da época
end
hold off %Desativa o superposicionamento dos gráficos
grid on
Plot_Leg = legend(Legenda,'Location','SouthEast'); %Adiciona a legenda
Plot_Title  = title('Fitness Médio x Execução'); %Adiciona o título
Plot_xLabel = xlabel('Geração'); %Define o rótulo do eixo X
Plot_yLabel = ylabel('Fitness médio'); %Define o rótulo do eixo Y
%Plot_zLabel = zlabel('f(x_1,x_2)'); %Define o rótulo do eixo Z
set(gcf,'Color',[1,1,1]) %Define a cor de fundo do gráfico
set(Plot_Title,'FontName','Helvetica','FontSize',14,'FontWeight','bold') %Formata o título
set(Plot_Leg,'FontName','Helvetica','FontSize',10,'FontAngle','oblique','FontName','Helvetica') %Formata a legenda
set(Plot_Fitness, 'Position', [0, 0, 1024, 768]); %Formata o tamanho da figura
NomeArquivo = strcat(['graficos\\Grafico_genetico_' Nome '_FitnessMedio.png']); %Prepara o nome do arquivo do gráfico
print(Plot_Fitness,NomeArquivo,'-dpng','-r300','-opengl') %Salva em png

%Gráfico Fitness Máximo
fprintf('Plotando gráfico Fitness Máximo x Geração \n'); %Exibe na tela
fprintf(fileID,'Plotando gráfico Fitness Máximo x Geração \n'); %Exibe na tela
Plot_Fitness = figure(); %Gera a Figura
Legenda = {}; %Inica a legenda como um conjunto de células vazio 
for iTreino = 1:Treinos %Para cada um dos treinos
    Legenda = [Legenda, ['Fitness Máximo Execução #' int2str(iTreino)]]; %Concatena a legenda
    %loglog(1:EpocasConv(iTreino),Erros(1:EpocasConv(iTreino),iTreino)); %Plota o gráfico
    plot(1:max(GeracoesConv),FitnessMaximoTreinos(:,iTreino));
    hold on %Ativa o superposicionamento dos gráficos
    %semilogy(Epocas,ErroEpoca) %Cria o gráfico logaritmico em y com o erro em função da época
end
hold off %Desativa o superposicionamento dos gráficos
grid on
Plot_Leg = legend(Legenda,'Location','SouthEast'); %Adiciona a legenda
Plot_Title  = title('Fitness Máximo x Execução'); %Adiciona o título
Plot_xLabel = xlabel('Geração'); %Define o rótulo do eixo X
Plot_yLabel = ylabel('Fitness máximo'); %Define o rótulo do eixo Y
%Plot_zLabel = zlabel('f(x_1,x_2)'); %Define o rótulo do eixo Z
set(gcf,'Color',[1,1,1]) %Define a cor de fundo do gráfico
set(Plot_Title,'FontName','Helvetica','FontSize',14,'FontWeight','bold') %Formata o título
set(Plot_Leg,'FontName','Helvetica','FontSize',10,'FontAngle','oblique','FontName','Helvetica') %Formata a legenda
set(Plot_Fitness, 'Position', [0, 0, 1024, 768]); %Formata o tamanho da figura
NomeArquivo = strcat(['graficos\\Grafico_genetico_' Nome '_FitnessMaximo.png']); %Prepara o nome do arquivo do gráfico
print(Plot_Fitness,NomeArquivo,'-dpng','-r300','-opengl') %Salva em png

%Gráfico Fitness Mínimo
fprintf('Plotando gráfico Fitness Mínimo x Geração \n'); %Exibe na tela
fprintf(fileID,'Plotando gráfico Fitness Mínimo x Geração \n'); %Exibe na tela
Plot_Fitness = figure(); %Gera a Figura
Legenda = {}; %Inica a legenda como um conjunto de células vazio 
for iTreino = 1:Treinos %Para cada um dos treinos
    Legenda = [Legenda, ['Fitness Mínimo Execução #' int2str(iTreino)]]; %Concatena a legenda
    %loglog(1:EpocasConv(iTreino),Erros(1:EpocasConv(iTreino),iTreino)); %Plota o gráfico
    plot(1:max(GeracoesConv),FitnessMinimoTreinos(:,iTreino));
    hold on %Ativa o superposicionamento dos gráficos
    %semilogy(Epocas,ErroEpoca) %Cria o gráfico logaritmico em y com o erro em função da época
end
hold off %Desativa o superposicionamento dos gráficos
grid on
Plot_Leg = legend(Legenda,'Location','SouthEast'); %Adiciona a legenda
Plot_Title  = title('Fitness Mínimo x Execução'); %Adiciona o título
Plot_xLabel = xlabel('Geração'); %Define o rótulo do eixo X
Plot_yLabel = ylabel('Fitness mínimo'); %Define o rótulo do eixo Y
%Plot_zLabel = zlabel('f(x_1,x_2)'); %Define o rótulo do eixo Z
set(gcf,'Color',[1,1,1]) %Define a cor de fundo do gráfico
set(Plot_Title,'FontName','Helvetica','FontSize',14,'FontWeight','bold') %Formata o título
set(Plot_Leg,'FontName','Helvetica','FontSize',10,'FontAngle','oblique','FontName','Helvetica') %Formata a legenda
set(Plot_Fitness, 'Position', [0, 0, 1024, 768]); %Formata o tamanho da figura
NomeArquivo = strcat(['graficos\\Grafico_genetico_' Nome '_FitnessMinimo.png']); %Prepara o nome do arquivo do gráfico
print(Plot_Fitness,NomeArquivo,'-dpng','-r300','-opengl') %Salva em png


%% PARTE 5 - FINALIZA
FimLog = clock(); %Pega a data e hora atual
fprintf(fileID,'\n%d-%02d-%02d %02d:%02d:%02.0f\n',FimLog(1),FimLog(2),FimLog(3),FimLog(4),FimLog(5),FimLog(6)); %Grava no log
fprintf('\n%d-%02d-%02d %02d:%02d:%02.0f\n',FimLog(1),FimLog(2),FimLog(3),FimLog(4),FimLog(5),FimLog(6)); %Exibe na tela
fprintf(fileID,'FIM DO LOG\n'); %Salva no log
fprintf('FIM DO LOG\n'); %Exibe na tela
fclose(fileID); %Fecha o arquivo de log