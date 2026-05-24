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
% Esta função cria uma matriz de partes do sinal, cada uma demorando 10 ms,
% para a subsequente análise dos seus fonemas
% 
% Entradas:
% fala: Vetor contentor do áudio
% fa: Frequência de amostragem do áudio (44100 Hz)
% 
% Saída:
% audio_seg: Matriz composta pelos vetores de segmentos de 10 ms da amostra

function audio_seg = SpeechSampling(fala, fa)
    
    % Cada segmento (de 10ms) contêm 441 amostras
    sample_size = 441;

    %analysis = (0:length(fala)/sample_size -1),(0:sample_size -1)

    % Criar uma matriz de dimensões (Nº de amostras do segmento) x (Nº de
    % segmentos)
    audio_seg = createArray(sample_size, length(fala)/sample_size);

    % Para cada segmento...
    for k = 0:length(fala)/sample_size - 1 
        % ... identifica-se os índices de início e de fim do mesmo...
        start = k * sample_size + 1 
        finish = (k + 1) * sample_size
        % ... e, em cada coluna, escreve-se os dados de cada segmento
        temp = fala(start : finish)
        audio_seg(:,k+1) = temp;
    end
end
