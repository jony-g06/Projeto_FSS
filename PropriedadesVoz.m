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
    transf = fft(audio(:,1))/length(audio);
    plot(real(transf));
    m = max(real(transf))
    Pitch = find(real(transf) == m, 1)