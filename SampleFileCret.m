%% sampling of the audio files
% 
% Input:
% name of the file we want to create. be aware of the files in the directory used, as this can replace files already there.
% 
% Output:
% It outputs two files in the current directory, one with the given name in the input, inwhich resides the audio sampled in time, and the other file with the name given in the
% input plus an fa in the back, in with resides the sampling frequency of the sampled audio
% 

function SampleFileCret( nameoffile)
    [file, fa] = recording();          %this starts the function recording, that returns an object of the class audiorecord and the sampling frequency
    %[xq, fa]= audioread()             %this was an oldline of code, not needed to the function
    xq = getaudiodata(file)            %this gets the matrix of the audio samples from the audiorecord object
    writematrix(xq, nameoffile)        %this writes a file of the audio samples with the name given in the input
    fastr = append(nameoffile, 'fa')   %this appends the word 'fa' in the end of the word given in the input, to name the file of the sample frequency
    writematrix(fa, fastr)             %this writes a file of the sampling frequency with the name givne in the input appended with 'fa'
