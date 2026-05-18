%% sampling of the audio files
% 
% 
% 
% 
% 
% 

function SampleFileCret( nameoffile)
    [file, fa] = receber();
    %[xq, fa]= audioread()
    xq = getaudiodata(file)
    writematrix(xq, nameoffile)
    fastr = append(nameoffile, 'fa')
    writematrix(fa, fastr)
