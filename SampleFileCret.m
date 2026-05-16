%% sampling of the audio files
% 
% 
% 
% 
% 
% 

function SampleFileCret( nameoffile, audiof)
    [xq, fa]= audioread(audiof)
    writematrix(xq, nameoffile)
    fastr = append(nameoffile, 'fa')
    writematrix(fa, fastr)
