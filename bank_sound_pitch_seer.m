%% banco de voz
% vamos a ver isto
%

diferenciais = 1:20

for k = 0:19
    alo = append('amostrasvoz', num2str(k));
    SampleFileCret(alo)
    algo = append(alo, '.txt')
    diferenciais(k + 1) = PropriedadesVoz(load(algo))
end

%%

sort(diferenciais)

%%