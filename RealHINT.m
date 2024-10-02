function [] = RealHINT()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This protocol measures SNR50s using the HINT protocol (Nilsson et al.,
% 1994; Wu et al., 2019) in different real-world environments (Weisser et
% al., 2019) using high-fidelity BKB recordings (Monson et al., 2022).
%
% Speech material: https://osf.io/w4h9f/
% Noise material: https://zenodo.org/record/2261633#.ZEl0l3bMKUk
%
% This version uses and 8-speaker array. BKB sentences are convolved with the 
% RIRs of each environment before running this protocol.
%
% Directions:
%
% Follow the calibration procedure in Weisser et al., 2019 to calibrate the 
% noise. Noise environments should be calibrated using the Diffuse file so 
% that the LAeq in the sound field is 65.9 dBA. 
% 
% Speech noise matching the spectro-temporal characteristics of the BKB 
% sentences were used to determine that in this booth the SPL of the speech
% at the algorithm output is accurate. But correction factors for speech 
% levels can be added separately for each environment if required based on 
% the measured level of the speech at the output of the algorithm. 
% Correction factors should be included to meet the appropriate SNR as 
% measured in the sound field if required.
%
% Noise environments must be played from a separate source.
% 
% Adaptive HINT protocol is automatically implemented. Simply mark the
% sentence correct or incorrect and SNR50s for each environment are
% automatically stored as an excel file for the subject.
%
% HINT is performed 2x per environment. 
%
% Erik Jorgensen
% UW-Madison 2023
% erik.jorgensen@wisc.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
beep off;

%p = genpath('Y:\Projects\Musician SPIN');
p = genpath('R:\Projects\Musician SPIN');
addpath(p);

% dialogue box to prompt user for subject_number
prompt = {'Enter subject number:'};
dlgtitle = 'Start RealHINT';
dims = [1 20];
answer = inputdlg(prompt,dlgtitle,dims);

% change string input to num
subject_num = str2double(answer{1}); 

% index BKB sentences
sentences = randperm(336);
startVector = 1:20:316;

% practice 
RealHINT_EHF2251F_Diffuse_Practice(startVector(15), sentences);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

f = {@RealHINT_EHF2251F_Cafe1_1, @RealHINT_EHF2251F_Cafe1_2, @RealHINT_EHF2251F_Cafe2_1, @RealHINT_EHF2251F_Cafe2_2, @RealHINT_EHF2251F_DinnerParty_1, @RealHINT_EHF2251F_DinnerParty_2...
    @RealHINT_EHF2251F_Diffuse_1, @RealHINT_EHF2251F_Diffuse_2, @RealHINT_EHF2251F_FoodCourt1_1, @RealHINT_EHF2251F_FoodCourt1_2, @RealHINT_EHF2251F_FoodCourt2_1, @RealHINT_EHF2251F_FoodCourt2_2...
    @RealHINT_EHF2251F_Church_1, @RealHINT_EHF2251F_Church_2};


rng("shuffle");
% randomize conditions
ix = randperm(14);

% get randomized order of scenes
ScenesCell = cell(size(f));
for ii = 1:numel(f)
    functionHandle = f{ii};
    functionString = func2str(functionHandle);
    parts = strsplit(functionString, '_');
    scene = [parts{end-1}, '_', parts{end}];
    ScenesCell{ii} = scene;
end

% run tests
eval([ScenesCell{ix(1)} ' = f{ix(1)}(startVector(1), sentences, subject_num);']);
eval([ScenesCell{ix(2)} ' = f{ix(2)}(startVector(2), sentences, subject_num);']);
eval([ScenesCell{ix(3)} ' = f{ix(3)}(startVector(3), sentences, subject_num);']);
eval([ScenesCell{ix(4)} ' = f{ix(4)}(startVector(4), sentences, subject_num);']);
eval([ScenesCell{ix(5)} ' = f{ix(5)}(startVector(5), sentences, subject_num);']);
eval([ScenesCell{ix(6)} ' = f{ix(6)}(startVector(6), sentences, subject_num);']);
eval([ScenesCell{ix(7)} ' = f{ix(7)}(startVector(7), sentences, subject_num);']);
eval([ScenesCell{ix(8)} ' = f{ix(8)}(startVector(8), sentences, subject_num);']);
eval([ScenesCell{ix(9)} ' = f{ix(9)}(startVector(9), sentences, subject_num);']);
eval([ScenesCell{ix(10)} ' = f{ix(10)}(startVector(10), sentences, subject_num);']);
eval([ScenesCell{ix(11)} ' = f{ix(11)}(startVector(11), sentences, subject_num);']);
eval([ScenesCell{ix(12)} ' = f{ix(12)}(startVector(12), sentences, subject_num);']);
eval([ScenesCell{ix(13)} ' = f{ix(13)}(startVector(13), sentences, subject_num);']);
eval([ScenesCell{ix(14)} ' = f{ix(14)}(startVector(14), sentences, subject_num);']);

f = waitbar(.75, 'writing data sheet...');

% write score sheet to excel file and move
snr50s = [Cafe1_1, Cafe1_2, Cafe2_1, Cafe2_2 DinnerParty_1, DinnerParty_2...
    Diffuse_1, Diffuse_2, FoodCourt1_1, FoodCourt1_2, FoodCourt2_1, FoodCourt2_2, Church_1, Church_2]; 
snr50s = array2table(snr50s);
snr50s.Properties.VariableNames = {'Cafe1_1','Cafe1_2', 'Cafe2_1', 'Cafe2_2', 'DinnerParty_1','DinnerParty_2'...
    'Diffuse_1', 'Diffuse_2', 'FoodCourt1_1', 'FoodCourt1_2', 'FoodCourt2_1', 'FoodCourt2_2', 'Church_1', 'Church_2'}; %set column names
rootName = 'SE_Subject_%03d_RealHINT';
fileName = sprintf(rootName, subject_num);
fileName = [fileName, '.xlsx'];
writetable(snr50s,fileName,'Sheet',1)
movefile('*.xlsx', sprintf('Subject_%03d', subject_num)); 

close(f)

end

