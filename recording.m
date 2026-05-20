%% Leitura de uma amostra vinda do microfone:
% Esta função lê uma amostra de áudio, com 3 segundos, e armazena-a numa
% variável
%
% Entradas:
% N/A
%
% Saída:
% amostra: Variável contentora do áudio gravado através do microfone 
% fs : Frequencia de amostragem do audio gravado
%

function [amostra, fs] = recording()
    
    fig = uifigure('WindowKeyPressFcn',@(src,event)uiresume(src));
    uiwait(fig);

    fs = 44100;

    amostra = audiorecorder(fs, 8, 1);
    fprintf('begin speaking: ')
    recordblocking(amostra, 3);
    fprintf('\njob done\n')
    close(fig)
