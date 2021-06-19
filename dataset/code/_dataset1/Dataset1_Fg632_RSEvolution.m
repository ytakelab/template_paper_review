% Development of hippocampal kindling, evaluated with Racine's scale and
% wet-dog shakes
% Copyright (c) Yuichi Takeuchi 2018, 2019
clc; clear; close all
%% Organizing MetaInfo
MetaInfo = struct(...
    'MatlabFolder', 'C:\Users\Lenovo\Documents\MATLAB',...
    'DataFolder', 'C:\Users\Lenovo\Dropbox\Scrivener\MSTLE\Dataset\Dataset1\Analysis',...
    'FileName', 'Dataset1_Fg632_RSEvolution.csv'...
    );

%% Move to Matlabfolder
cd(MetaInfo.MatlabFolder)

%% Move to data folder
cd(MetaInfo.DataFolder)

%% Data import
srcTb = readtable(MetaInfo.FileName);
extTb = srcTb(:,(1:7));
VarNames = extTb.Properties.VariableNames; % {x__LTR, Date, ExpNo1, ExpNo2, Num, RS, WDS}

%% Takeing variables
Number = extTb.Num;
RScale = extTb.RS;
WDS = extTb.WDS;

%% Plot for raw view
% figure(1)
% subplot(1,2,1)
% plot(Number, RScale, 'ko')
% title('Racine scale');
% xlabel('Number of stimulation')
% ylabel('Racine scale')
% subplot(1,2,2)
% plot(Number, WDS, 'ko')
% title('Wet-dog shaking')
% xlabel('Number of Stimulation')
% ylabel('# Wet-dog shaking')

%% Descriptive parameters for plotting
uniqueNum = unique(extTb.(VarNames{5}));
MeanRS = zeros(1,length(uniqueNum));
StdRS = zeros(1,length(uniqueNum));
MeanWDS = zeros(1,length(uniqueNum));
StdWDS = zeros(1,length(uniqueNum));

for i = 1:length(uniqueNum)
    tempRS = extTb.RS(extTb.Num == i);
    tempWDS = extTb.WDS(extTb.Num == i);
    MeanRS(i) = mean(tempRS);
    StdRS(i) = std(tempRS);
    MeanWDS(i) = mean(tempWDS);
    StdWDS(i) = std(tempWDS);
end
clear i tempRS tempWDS

%% Organizing figure
close all
hfig = figure(1);
haxes1 = subplot(1,2,1);
hold on
plot(Number, RScale, 'ko', 'LineWidth', 0.5, 'MarkerSize', 3)
plot(uniqueNum, MeanRS, '-ok', 'MarkerFaceColor', 'k', 'LineWidth', 0.5, 'MarkerSize', 3)
% errorbar(uniqueNum, MeanRS, StdRS, '-ok', 'MarkerFaceColor', 'k')
hold off
title('Motor seizure');
xlabel('Cumulative number of stimulation')
ylabel('Racine''s scale')
set(gca,...
    'YLim', [0 5],...
    'YTick',[1:5]...
    )     
haxes2 = subplot(1,2,2);
hold on
plot(Number, WDS, 'ko', 'LineWidth', 0.5, 'MarkerSize', 3)
plot(uniqueNum, MeanWDS, '-ok', 'MarkerFaceColor', 'k', 'LineWidth', 0.5, 'MarkerSize', 3)
% errorbar(uniqueNum, MeanWDS, StdWDS, '-ok', 'MarkerFaceColor', 'k')
hold off
title('Wet-dog shaking')
xlabel('Cumulative number of stimulation')
ylabel('# Wet-dog shaking')

% global parameters
fontname = 'Arial';
fontsize = 8;

% figure parameter settings
set(hfig,...
    'PaperUnits', 'centimeters',...
    'PaperPosition', [0.5 0.5 15 9],... % [h distance, v distance, width, height], origin: left lower corner
    'PaperSize', [16 10],... % width, height
    'NumberTitle','on',...
    'Name','test'...
    );

% axis parameter settings
set(haxes1,...
    'FontName', fontname,...
    'FontSize', fontsize...
    );

set(haxes2,...
    'FontName', fontname,...
    'FontSize', fontsize...
    );

%     'XLim', [0.5 2.5],...
%     'XTick', [1 2],...
%     'XTickLabel', {'Off', 'On'},...

% outputs
print('Dataset1_Fg632.pdf', '-dpdf');
print('Dataset1_Fg632.png', '-dpng');

clear hfig haxes1 haxes2 fontname fontsize

%% Number of rats
ratNum = length(unique(srcTb.LTR))

%% Save
save('RacineWDS')
