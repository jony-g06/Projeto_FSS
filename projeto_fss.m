%% Projeto de FSS
%%
load referencia.coiso

% Continuar

%% Cálculo da diferença entre o sinal recebido e o esperado:
% Esta função calcula a diferença relativa entre os valores das frequências
% presentes no áudio recebido pelo microfone e as frequências presentes na
% amostra de áudio usada como referência.
%
% Entradas:
% tent: Vetor das frequências presentes no aúdio recebido, obtido através
% de uma transformada de Fourrier
%
% base: Vetor das frequências presentes no aúdio de referência, obtido 
% através de uma transformada de Fourrier
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
        dif(k) = abs(tent(k) - base(k))/base(k);
    end
end
