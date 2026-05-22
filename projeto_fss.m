%% Projeto de FSS
%%
%load PLACEHOLDER.coiso
load basevoice.txt

resposta_audirec = recording();
resposta = getaudiodata(resposta_audirec)
%freq_resp = fft(resposta)/length(resposta);

%PLACEHOLDER = fft(basevoice)/length(basevoice)

%erros = diferenca(freq_resp, PLACEHOLDER);

%recon = identify(erros);

pbase = PropriedadesVoz(basevoice)
ptent = PropriedadesVoz(resposta)

recon = (ptent >= pbase - 10 & ptent <= pbase + 10);

if(recon)
    disp('Bem vindo, mestre')
else
    disp('Utilizador não reconhecido')
end


%% Leitura de uma amostra vinda do microfone:
% Esta função lê uma amostra de áudio, com 3 segundos, e armazena-a numa
% variável
%
% Entradas:
% N/A
%
% Saída:
% amostra: Variável contentora do áudio gravado através do microfone 

function amostra = receber()
    amostra = audiorecorder(44100, 8, 1);
    recordblocking(amostra, 3);
end

%% Cálculo da diferença entre o sinal recebido e o esperado:
% Esta função calcula a diferença relativa entre os valores das frequências
% presentes no áudio recebido pelo microfone e as frequências presentes na
% amostra de áudio usada como referência.
%
% Entradas:
% tent: Vetor das frequências presentes no aúdio recebido, obtido através
% de uma transformada de Fourrier (fft)
%
% base: Vetor das frequências presentes no aúdio de referência, obtido 
% através de uma transformada de Fourrier (fft)
%
% Saída:
% dif: Vetor que contêm os valores das diferenças relativas entre os
% valores recebidos pelo microfone e os da amostra-base, em %
%
% Nota: Nesta função, considera-se apenas metade do comprimento dos vetores
% de entrada, dada a simetria que existe a partir do ponto médio deste

function dif = diferenca(tent, base)
    dif = zeros(0:length(base)/2);
    for k = 1:length(base)/2
        dif(k) = 100*abs(tent(k) - base(k))/base(k);
    end
end

%% Reconhecimento de afinação
% Esta função retira a nota do audio a testar a partir da FFt do sinal.
%
% Entrada:
% audio: o vetor dos valores do audio dado
%
% Saída:
% a nota de afinação do dado audio
% 

function [Pitch] = PropriedadesVoz(audio)
    transf = fft(audio(:,1));
    plot(real(transf));
    m = max(real(transf))
    Pitch = find(real(transf) == m, 1)
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

%% Reconhecimento do falador
% Esta função calcula, com base no vetor criado na função 'diferenca', o nº
% de amostras que não se enquadra na tolerância imposta (10%) e, com base
% na tolerância definida para esta amostra (10% do total de amostras)
% confirma se o falador é o mesmo das amostras de referência.
%
% Entrada:
% err: o vetor dos desvios gerado pela função 'diferenca' 
%
% Saída:
% id: flag que indica se o falador foi reconhecido (1) ou não (0)

function id = identify(err)
    tol = 0;
    for k = 1:length(err)
        if(err(k) > 10)
            tol = tol + 1;
        end
    end

    if(tol <= 13230) % 13230 porque é 10% de 132300 amostras 
                    % (fa = 44100, durante 3s => 44100 * 3 = 132300)
        id = 1;
    else
        id = 0;
    end
end
