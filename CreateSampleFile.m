%% Recolha da amostra de referência para a voz:
% Este programa, através da função 'recording()', recolhe uma amostra de
% som vinda do microfone do dispositivo e guarda-a num ficheiro a que
% chamaremos 'referencia.txt', para ser usada como referência/base para a
% comparação entre vozes

% Chamada da função 'recording()' definida anteriormente para guardar os
% dados do áudio na variável 'ref'
[ref, fs] = recording(); 

% A variável 'raw_audio' isola apenas a matriz dos valores de áudio 
% registados na gravação 'ref'.
raw_audio = getaudiodata(ref);

% A matriz dos valores registados é escrita num ficheiro chamado
% 'referência'. Este servirá como a base para comparação das gravações
writematrix(raw_audio, 'ref_ornintorrinco');
