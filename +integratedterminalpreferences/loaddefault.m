function loaddefault()
%LOADDEFAULT Summary of this function goes here
%   Detailed explanation goes here
if isfile('+integratedterminalpreferences/integratedterminalpreferences.json')
    return;
end

if computer == "PCWIN64"
    copyfile +integratedterminalpreferences/defaultwindows.json ...
        +integratedterminalpreferences/integratedterminalpreferences.json;
elseif computer == "GLNXA64"
    copyfile +integratedterminalpreferences/defaultlinux.json ...
        +integratedterminalpreferences/integratedterminalpreferences.json;
elseif computer == "MACI64"
    copyfile +integratedterminalpreferences/defaultmacos.json ...
        +integratedterminalpreferences/integratedterminalpreferences.json;
else
    error('Unsupported operating system.');
end

end