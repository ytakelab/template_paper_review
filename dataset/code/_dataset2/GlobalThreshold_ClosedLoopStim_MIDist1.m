% This script calcurates and clusters modulation index of HPC electrographic seizures.
% Copyright (c) Yuichi Takeuchi 2020
clc; clear; close all
%% Organizing MetaInfo
FigureNo = 2;
FgNo = 999;
Panel = '';
bitLabel = [1 0]; % for [open or closed, estim or optogenetic]
if bitLabel(1)
    control = 'Closed';
    graphSuffix = 'Dly';
else
    control = 'Open';
    graphSuffix = 'Hz';
end
MetaInfo = struct(...
    'MatlabFolder', 'C:\Users\Lenovo\Documents\MATLAB',...
    'DataFolder', ['C:\Users\Lenovo\Dropbox\Scrivener\MSTLE\Dataset\Dataset' num2str(FigureNo) '\Analysis'],...
    'outputFileName', ['Dataset' num2str(FigureNo) Panel '_Fg' num2str(FgNo) '_' control 'LoopStim_MIDist.mat'],...
    'bitLabel', bitLabel,...
    'control', control,...
    'graphSuffix', graphSuffix,...
    'FigureNo', FigureNo,...
    'FgNo', FgNo...
    );
clear FigureNo FgNo control graphSuffix bitLabel Panel

%% Move to MATLAB folder
cd(MetaInfo.MatlabFolder)

%% Move to data folder
cd(MetaInfo.DataFolder)

%% Data import 1
orgTb1 = readtable('Figure3_Fg641_ClosedLoopStim.csv');
C1 = table2cell(orgTb1);
orgTb2 = readtable('Figure4_Fg603_ClosedLoopStim.csv');
C2 = table2cell(orgTb2);
orgTb3 = readtable('Figure5_Fg627_ClosedLoopStim.csv');
C3 = table2cell(orgTb3);
orgTb4 = readtable('FigureS3_Fg624_ClosedLoopStim.csv');
C4 = table2cell(orgTb4);
orgTb5 = readtable('FigureS6_Fg602_ClosedLoopStim.csv');
C5 = table2cell(orgTb5);
C = [C1;C2;C3;C4;C5];
orgTb = cell2table(C, 'VariableNames', orgTb1.Properties.VariableNames);

subTb = orgTb(~logical(orgTb.Supra),:); % 
supraTb = orgTb(logical(orgTb.Supra),:); % 
VarNames = orgTb.Properties.VariableNames; VarNames = VarNames(15:19); % {RS, WDS, ADDrtn, HPCDrtn, CtxDrtn}
clear orgTb1 orgTb2 orgTb3 orgTb4 orgTb5 C1 C2 C3 C4 C5 C

%% Data import 2
% orgTb1 = readtable('Figure3_Fg641_ClosedLoopStim.csv');
% C1 = table2cell(orgTb1);
% orgTb2 = readtable('Figure4_Fg603_ClosedLoopStim.csv');
% C2 = table2cell(orgTb2);
% orgTb4 = readtable('FigureS3_Fg624_ClosedLoopStim.csv');
% C4 = table2cell(orgTb4);
% C = [C1;C2;C4];
% orgTb = cell2table(C, 'VariableNames', orgTb1.Properties.VariableNames);
% 
% subTb = orgTb(~logical(orgTb.Supra),:); % 
% supraTb = orgTb(logical(orgTb.Supra),:); % 
% VarNames = orgTb.Properties.VariableNames; VarNames = VarNames(15:19); % {RS, WDS, ADDrtn, HPCDrtn, CtxDrtn}
% clear orgTb1 orgTb2 orgTb3 orgTb4 orgTb5 C1 C2 C3 C4 C5 C

%% Basic statistics and Statistical tests
if ~MetaInfo.bitLabel(1)
    % sub
    [ sBasicStatsSub, sStatsTestSub ] = statsf_getBasicStatsAndTestStructs1( subTb, VarNames, subTb.(10) );
end
% supra
[ sBasicStatsSupra, sStatsTestSupra ] = statsf_getBasicStatsAndTestStructs1( supraTb, VarNames, supraTb.(10) );

%% Calculation of parameters (MI)
% getting parameters (supra)
HPCOff = supraTb.(VarNames{4})(logical(supraTb.(10)) == false);
HPCOn  = supraTb.(VarNames{4})(logical(supraTb.(10)) == true);
supraMI = (HPCOn-HPCOff)./(HPCOn+HPCOff);
clear HPCOff HPCOn

if ~MetaInfo.bitLabel(1) % sub    
    % getting parameters
    subHPCOff = subTb.(VarNames{4})(logical(subTb.(10)) == false);
    subHPCOn  = subTb.(VarNames{4})(logical(subTb.(10)) == true);
    subMI = (subHPCOn-subHPCOff)./(subHPCOn+subHPCOff);
    clear subHPCOff subHPCOn

    index = isnan(subMI);
    subMI(index) = 0;
    clear index
end

%% Skewness test
supraMIpos = supraMI(supraMI >= 0);
supraMIneg = supraMI(supraMI <= 0);
[ sBasicStatsSupraMI, sStatsTestSupraMI ] = statsf_getBasicStatsAndTestStructs2( supraMIpos, abs(supraMIneg) );
clear supraMIpos supraMIneg

if ~MetaInfo.bitLabel(1) % sub    
    subMIpos = subMI(subMI >= 0);
    subMIneg = subMI(subMI <= 0);
    [ sBasicStatsSubMI, sStatsTestSubMI ] = statsf_getBasicStatsAndTestStructs2( subMIpos, abs(subMIneg) );
    clear supraMIpos supraMIneg
end

%% Get the threshold
[ indForSeparation, ~ ] = fitf_gmm2fitFor1DdataSeparation1( supraMI );
x = linspace(-1, 1, 1000);
globalIndex = indForSeparation;
disp(globalIndex)
globalThrshld = x(indForSeparation);
disp(globalThrshld)
clear x indForSeparation

%% Curve fitting of two Gaussian components
condition = [1]; % 0 for sub, 1 for supra
outputGraph = [1 1]; % pdf, png
colorMat = [0.75 0.75 0.75; 0 0 0; 0 0 1; 0 0 0]; % [R G B]

if condition
    % supra
    outputFileNameBase = ['Supra' MetaInfo.control 'Loop_MIDistWithFit'];
    [ flag ] = figsf_HistogramWTwoGaussians1( supraMI, 'MI of HPC seizures', 'Probability', 'Modulation index', colorMat, outputGraph, outputFileNameBase);
    clear flag; close all
else
    % sub
    outputFileNameBase = ['Sub' MetaInfo.control 'Loop_MIDistWithFit'];
    [ flag ] = figsf_HistogramWTwoGaussians1( subMI, 'MI of HPC seizures', 'Probability', 'Modulation index', colorMat, outputGraph, outputFileNameBase);
    clear flag; close all
end
clear condition outputGraph colorMat outputFileNameBase

%% Separation of data by a threshold (two-Gaussian)
% condition = [1]; % 0 for sub, 1 for supra
% 
% if condition
%     [ indForSeparation, ~ ] = fitf_gmm2fitFor1DdataSeparation1( supraMI );
%     indsupraMI = interleave(supraMI, supraMI);
%     indThrshld = supraMI < indForSeparation*0.002-1;
%     indThrshld = interleave(indThrshld, indThrshld);
%     tempTb = table(indsupraMI, indThrshld, 'VariableNames',{'MI','Thresholded'});
%     supraTbTh = [supraTb, tempTb];
%     writetable(supraTbTh, ['Figure' num2str(MetaInfo.FigureNo) '_supraTbTh.csv'])
% else
%     [ indForSeparation, ~ ] = fitf_gmm2fitFor1DdataSeparation1( subMI );
%     indThrshld = subMI < indForSeparation*0.002-1;
%     indsubMI = interleave(subMI, subMI);
%     indThrshld = subMI > indForSeparation*0.002-1;
%     indThrshld = interleave(indThrshld, indThrshld);
%     tempTb = table(indsubMI, indThrshld, 'VariableNames',{'MI','Thresholded'});
%     subTbTh = [subTb, tempTb];
%     writetable(subTbTh, ['Figure' num2str(MetaInfo.FigureNo) '_subTbTh.csv'])
% end
% clear indsupraMI indForSeparation condition indInterleaved indMI indThrshld interleaved tempTb

%% Proportion of thresholded (labeled) conditions
condition = [1];  % 0 for sub, 1 for supra
if condition
    tempTbTh = supraTbTh;
else
    tempTbTh = subTbTh;
end
condVec = tempTbTh.(12);
unqcond = unique(condVec);
stimVec = tempTbTh.(10);
thrshldVec = tempTbTh.(23);
for i = 1:length(unqcond)
    n(i) = nnz(stimVec(condVec == unqcond(i) & thrshldVec == 1)); % Number of thresholded trials
    N(i) = nnz(stimVec(condVec == unqcond(i))); % No trial
end
if condition
    [ chi2hSupra, chi2pSupra, chi2statsSupra ] = statsf_chi2test( n, N ); % chi-square test
else
    [ chi2hSub, chi2pSub, chi2statsSub ] = statsf_chi2test( n, N ); % chi-square test
end
percThrshlded = n./N;
clear i n N condVec unqcond stimVec thrshldVec tempTbTh condition

%% Figure prepration (Supra)
% parameters
unqcond = unique(supraTbTh.(12));
CTitle = {'Fraction of success trial pairs'};
CVLabel = {'Fraction'};
outputGraph = [1 1]; % pdf, png

if MetaInfo.bitLabel(2) % optogenetics
    colorMat = [0 0 1];
    if MetaInfo.bitLabel(1)
        CHLabel = 'MS illumination delay (ms)';
    else
        CHLabel = 'MS illumination frequency (Hz)';
    end
    outputFileNameBase = ['Supra' MetaInfo.control 'Loop_PercThrshlded'];
    [ flag ] = figsf_Plot1( unqcond, percThrshlded, CTitle, CVLabel, CHLabel, colorMat, outputGraph, outputFileNameBase);
else
    colorMat = [0 0 0];
    if MetaInfo.bitLabel(1)
        CHLabel = 'MS stimulation delay (ms)';
    else
        CHLabel = 'MS stimulation frequency (Hz)';
    end
    outputFileNameBase = ['Supra' MetaInfo.control 'Loop_PercThrshlded'];
    [ flag ] = figsf_Plot1( unqcond, percThrshlded, CTitle, CVLabel, CHLabel, colorMat, outputGraph, outputFileNameBase);
end
clear flag outputFileNameBase colorMat CTitle CVLabel CHLabel outputGraph unqcond; close all

%% Number of rats and trials
No.subRats = length(unique(subTb.LTR));
No.subTrials = length(subTb.LTR);
No.supraRats = length(unique(supraTb.LTR));
No.supraTrials = length(supraTb.LTR)

%% Save
cd(MetaInfo.DataFolder)
save(MetaInfo.outputFileName)

%% Copy this script to the data folder
% cd(MetaInfo.MatlabFolder)
% copyfile([MetaInfo.MatlabFolder '\Yuichi\Epilepsy\template\eplpsys_MIDistribution1.m'],...
%     [MetaInfo.DataFolder '\' MetaInfo.mFileCopyName]);
% % dependency
% [ flag ] = dpf_getDependencyAndFiles( [MetaInfo.MatlabFolder '\Yuichi\Epilepsy\template\eplpsys_MIDistribution1.m'],...
%     MetaInfo.DataFolder );
% clear flag
% % cd(MetaInfo.DataFolder)
