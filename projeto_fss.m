%% Projeto de FSS

% Carregar os ficheiros de referência para a memória do programa. Esta será
% a nossa base de dados
load ref_sim.txt
load ref_nao.txt
load ref_talvez.txt
load ref_ornintorrinco.txt

% Correr o programa em loop infinito
while(true)

    % Recolher uma amostra de áudio a analisar
    resposta_raw = recording();
    resposta = getaudiodata(resposta_raw);

    % Executar uma correlação cruzada entre a resposta recolhida e as
    % diferentes possibilidades da base de dados
    sim = xcorr(resposta, ref_sim);
    nao = xcorr(resposta, ref_nao);
    talvez = xcorr(resposta, ref_talvez);
    ornintorrinco = xcorr(resposta, ref_ornintorrinco);
    
    % Para cada palavra da base de dados, verificar se ela foi identificada
    % e imprimi-la no terminal
    if(identify(sim))
        disp('Sim')
    elseif(identify(nao))
        disp('Não')
    elseif(identify(talvez))
        disp('Talvez')
    elseif(identify(ornintorrinco))
        disp('Ornintorrinco')

    % Caso nenhuma palavra tenha sido reconhecida, ...
    else
        % ... verificamos se foi por causa do timbre da pessoa ...
        if(TimbreVoz(resposta) < 0.9*TimbreVoz(ref_sim) & ...
           TimbreVoz(resposta) < 0.9*TimbreVoz(ref_nao) & ...
           TimbreVoz(resposta) < 0.9*TimbreVoz(ref_talvez) & ...
           TimbreVoz(resposta) < 0.9*TimbreVoz(ref_ornintorrinco))
            disp('Utilizador não reconhecido')
        else
        % ... ou se a instrução simplesmente não foi reconhecida.
            disp('Comando não reconhecido')
        end
    end
end

%% Reconhecimento da afinação do som
% Esta função retira a nota de afinação/frequência fundamental do audio a 
% testar a partir da transformada de Fourrier (FFT) do sinal.
%
% Entrada:
% audio: o vetor dos valores do audio dado
%
% Saída:
% Pitch: a nota de afinação do áudio analisado

function [Timbre] = TimbreVoz(audio)
    % A variável 'transform' armazena o vetor dos valores da transformada
    % de Fourrier do áudio
    transform = fft(audio(:,1))/length(audio);

    % A variável 'm' irá armazenar o valor mais elevado da transformada.
    % NOTA: Aqui utiliza-se a função 'real(z)', uma vez que a função
    % 'fft(X)' retorna valores complexos e apenas nos interessa a magnitude
    % real desses valores.
    m = max(real(transform))

    % A variável 'Pitch' vai armazenar a frequência associada a 'm' (neste 
    % caso, corresponde ao índice de 'm').
    % NOTA: O segundo argumento da função 'find', serve apenas para
    % garantir que apenas 1 valor é extraído
    Timbre = find(real(transform) == m, 1)
end

%% Reconhecimento do falador
% Esta função idica, com base no vetor da correlação cruzada entre a
% amostra de referência e a amostra desconhecida se o falador e a palavra
% são os mesmos.
%
% Entrada:
% correl: o vetor da correlação cruzada entre a amostra de referência e a
% amostra desconhecida
%
% Saída:
% id: flag que indica se o falador e a instrução foram reconhecidos (1) ou 
% não (0)
%
% NOTA: Após alguns testes, verificámos que o valor mínimo dos máximos de
% correlação própria da nossa base de dados era cerca de 90, logo, este
% valor serve como referência para a identificação

function id = identify(correl)
    if(max(correl) >= 90)
        id = 1;
    else
        id = 0;
    end
end
