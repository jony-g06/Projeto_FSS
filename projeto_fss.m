%% Projeto de FSS

% Carregar os ficheiros de referência para a memória do programa
load ref_sim.txt
load ref_nao.txt
% load ref_passe.txt

SIM = TimbreVoz(ref_sim);
NAO = TimbreVoz(ref_nao);
% PASSE = PropriedadesVoz(ref_passe);

while(true)
    resposta_raw = recording();
    resposta = getaudiodata(resposta_raw);

    tent = TimbreVoz(resposta);

    identified_s = (abs(tent - SIM)/SIM * 100 <= 10);
    identified_n = (abs(tent - NAO)/NAO * 100 <= 10);

    if(identified_s)
        disp('Sim')
    elseif (identified_n)
        disp('Não')
    else
        disp('Utilizador não reconhecido')
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


%% Sampling de audio
% 
% criação de uma matriz de partes do sinal, cada parte demorando 10 ms,
% para subsequente análise do sinal
% 
% Input:
% a matriz linha do audio e a frequencia a que foi amostrado
% 
% Output:
% matriz com vetores de 10 ms cada da amostra de audio

function analysis = SpeechSampling(fala, fa)
    % 
    % 132300 = 3s, 10ms = x
    % 132300*10*10^-3 
    % 1323 / 3 = 441
    %
    tempo = length(fala)/fa;
    sample_size = length(fala) * 10 * 10^-3 / tempo
    %analysis = (0:length(fala)/sample_size -1),(0:sample_size -1)
    analysis = createArray(sample_size, length(fala)/sample_size)
    for k = 0:length(fala)/sample_size -1 
        start = int32(k * sample_size) + 1
        finish = int32((k + 1) * sample_size)
        temp = fala(start : finish)
        analysis(:,k+1) = temp;
    end
end
