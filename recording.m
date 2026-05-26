%% Leitura de uma amostra vinda do microfone:
% Esta função lê uma amostra de áudio, vinda do microfone do dispositivo, 
% com 3 segundos, e armazena-a na variável 'amostra'
%
% Entradas:
% N/A
%
% Saída:
% amostra: Variável contentora do áudio gravado através do microfone 
% fs : Frequência de amostragem do áudio gravado

function [amostra, fs] = recording()
    
    % As amostras de áudio são recolhidas a uma frequência de 8000 Hz
    fs = 8000;

    % O programa cria uma janela vazia que aguarda até que seja premida uma
    % tecla. 
    fig = uifigure('WindowKeyPressFcn', @(src,event)uiresume(src));
    uiwait(fig);

    % Depois de premir a tecla, o programa indicará ao utilizador,
    % no terminal, quando pode começar a falar e, após 3 segundos, o
    % programa sinalizará quando a gravação termina.
    amostra = audiorecorder(fs, 8, 1);
    disp('Comece a falar: ')
    recordblocking(amostra, 2);
    disp('Gravação terminada')

    % Quando terminada a gravação, a janela vazia fecha-se.
    close(fig)
