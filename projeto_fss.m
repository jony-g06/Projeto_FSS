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

function analysis = SpeechSampling(fala, fa)
    % 
    % 132300 = 3s, 10ms = x
    % 132300*10*10^-3 
    % 1323 / 3 = 441
    % 1323 será o tamanho, para
    % comportar o overlaping de sianl, não se eprdendo informação pelo meio

    % Cada segmento (de 10ms) contêm 441 amostras. como queremos overlapping
    % (para consistência do sinal transformado), teremos overlapping de 
    % 441 amostras para cada lado. As matirzes finais e iniciais terâo 
    % 0's a preencher o resto do vetor
    
    tempo = length(fala)/fa;
    sample_size = length(fala) * 10 * 10^-3 / tempo;
    
    % Criar uma matriz de dimensões (3 x Nº de amostras do segmento) x (Nº de
    % segmentos)
    analysis = zeros(3.*sample_size, length(fala)/sample_size);

    % instauro a variável sizing para o matlab não a calcular constantemente
    sizing = length(fala)/sample_size -1 ;
    
    for k = 0:sizing
        % no caso de ser a primeira amostra
        if k == 0
             % ... identifica-se os índices de início e de fim do mesmo...
            start = 1;
            finish = 882;
            temp = fala(start : finish);
            % ... e, em cada coluna, escreve-se os dados de cada segmento
            analysis((442:1323), k+1) = temp;
        end
        % no caso de não ser nem a primeira nem a última
        if k > 0 & k < sizing
             % ... identifica-se os índices de início e de fim do mesmo...
            start = (k-1) * sample_size + 1;
            finish = (k + 2) * sample_size;
            temp = fala(start : finish);
            % ... e, em cada coluna, escreve-se os dados de cada segmento
            analysis(:,k+1) = temp;
        end
        % no caso de ser a última
        if k == sizing 
             % ... identifica-se os índices de início e de fim do mesmo...
            start = (k - 1) * sample_size + 1;
            finish = (k + 1) * sample_size;
            temp = fala(start : finish);
            % ... e, em cada coluna, escreve-se os dados de cada segmento
            analysis((1:882), k+1) = temp;
        end
    end
end

%% Tratamento de audio
%
%
%

function coeficients = AudioProcessing(samp_audio)
    % definição de parametros para a função de hanning e implementação da
    % funcão no sinal em intervalos
    M = length(samp_audio(:,1));
    hann_func =.5*(1 - cos(2*pi*(0:M-1)'/(M-1)));
    temp = zeros(length(samp_audio(:,1)), length(samp_audio(1,:)));
    for k = 1:length(samp_audio(1,:))
        temp(:,k) = hann_func.* samp_audio(:,k)
    end
    
    % transformadas de fourier aplicadas a cada frame de 10ms
    temp2 = zeros(length(samp_audio(:,1)), length(samp_audio(1,:)));
    for k = 1:length(samp_audio(1,:))
        temp2(:,k) = fft(temp(:,k))/length(temp(:,k))
    end

    % aplicação do banco de filtros de mel

    % banco de filtros de Mel usa a magnitude ao quadrado para o calculo
    % dos filtros

    mag_sig = abs(temp2).^2;
    
    

end
