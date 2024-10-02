function [snr50_DinnerParty_2] = RealHINT_EHF2251F_DinnerParty_2(start, sentences, subject_num)
%%%%%%%%%%%%%%%%%%%%%%%%%
%
%%%%%%%%%%%%%%%%%%%%%%%%%

addpath("BKB_EHF2251_female_dinnerParty");

% call audio device
playRec = audioPlayerRecorder(48000);
devices = getAudioDevices(playRec);
playRec.Device = 'MOTU Pro Audio';
%asiosettings(playRec.Device) % only if you need to bring up MOTU ProAudio

% PRELIMINARY STEPS
clc;

load RealHINT_EHF2251F.mat BKBDinnerParty_EHF2251F BKBSentences Lnoise % get the  info

Lnoise = Lnoise.DinnerParty;

RealHINTDinnerParty_Scores = zeros(1,20);
RealHINTDinnerParty_SNRs = zeros(1,20);

targets = sentences(start:start+19); % 

uiwait(msgbox('DINNER PARTY'));

% double check participant
waitfor(msgbox("Please make sure the participant is sitting up straight.", "Warning", "warn"));
waitfor(msgbox("Start DinnerParty (DinnerParty_8_B36Cal) Noise in a Random Spot", "Warning", "warn"));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% START THE TEST
correctionFactor = 0; %set correction factor 

% 4 dB steps %
% Trial 1

snr = -12; % starting SNR

for ii = 1:4

    snrAdjust = snr - correctionFactor;

    % Get speech target
    % Read in sentence audio file
    sentenceFile = char(BKBDinnerParty_EHF2251F{targets(ii),1});
    [speech, fs] = audioread(sentenceFile);
    % Speech level estimate 
    Lspeech = 20*log10( rms(sum(speech,2)) / 2e-5 ); 
    % Gain required to add the target speech to the background noise at the given SNR
    gT = 10^( (snrAdjust-(Lspeech)+Lnoise)/20 );
    % multiply speech file by gain to set RMS
    speechTrial = gT*speech;

    % write speech
    filename = 'Trial.wav';
    audiowrite(filename, speechTrial, fs);

    % prompt
    prompt = BKBSentences{targets(ii),1};
   
    % PRESENT TRIAL
    afr = dsp.AudioFileReader(filename);
    adw = playRec;

        while ~isDone(afr)
            audio = afr();
            adw(audio);
        end
        release(afr); 
        release(adw);

    answer = questdlg(prompt, 'Trial', 'Correct', 'Incorrect', 'Cancel', 'Cancel');
    % Handle response
    switch answer
        case 'Correct'
            answer = 1;
        case 'Incorrect'
            answer = 0;
        case 'Cancel'
            answer = 3;
    end

    RealHINTDinnerParty_Scores(ii) = answer;
    RealHINTDinnerParty_SNRs(ii) = snr;

    if answer == 1
        snr = snr - 4;
    elseif answer == 0
        snr = snr + 4;
    else
    msgbox('You have canceled the test!');
    return
    end

end

% 2 dB steps %

for ii = 5:20

    snrAdjust = snr - correctionFactor;

    % Get speech target
    % Read in sentence audio file
    sentenceFile = char(BKBDinnerParty_EHF2251F{targets(ii),1});
    [speech, fs] = audioread(sentenceFile);
    % Speech level estimate 
    Lspeech = 20*log10( rms(sum(speech,2)) / 2e-5 ); 
    % Gain required to add the target speech to the background noise at the given SNR
    gT = 10^( (snrAdjust-(Lspeech)+Lnoise)/20 );
    % multiply speech file by gain to set RMS
    speechTrial = gT*speech;

    % write speech
    filename = 'Trial.wav';
    audiowrite(filename, speechTrial, fs);

    % prompt
    prompt = BKBSentences{targets(ii),1};

    % PRESENT TRIAL
    afr = dsp.AudioFileReader(filename);
    adw = playRec;

        while ~isDone(afr)
            audio = afr();
            adw(audio);
        end
        release(afr); 
        release(adw);

    answer = questdlg(prompt, 'Trial', 'Correct', 'Incorrect', 'Cancel', 'Cancel');
    % Handle response
    switch answer
        case 'Correct'
            answer = 1;
        case 'Incorrect'
            answer = 0;
        case 'Cancel'
            answer = 3;
    end

    RealHINTDinnerParty_Scores(ii) = answer;
    RealHINTDinnerParty_SNRs(ii) = snr;

    if answer == 1
        snr = snr - 2;
    elseif answer == 0
        snr = snr + 2;
    else
    msgbox('You have canceled the test!');
    return
    end

end
% calculate SNR50
snr50_DinnerParty_2 = mean(RealHINTDinnerParty_SNRs(4:20));

% save data
nameSave = sprintf('Subject_%3d_RealHINT_EHF2251F_DinnerParty_2', subject_num);
% Generate text file
fid = fopen([nameSave '_info.txt'],'w');
fprintf(fid,'%s %s\r\n','File generated on: ', datetime("now"));
fprintf(fid,'%s %.2f\r\n','Environment Check Lnoise ', Lnoise);
fprintf(fid,'%s %d\r\n','Subject ', subject_num);
fprintf(fid,'%s %.2f\r\n','SNR50 = ',snr50_DinnerParty_2);
fprintf(fid,'%s %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f\n','SNRs = ', RealHINTDinnerParty_SNRs);
fprintf(fid,'%s %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n','TRACING = ', RealHINTDinnerParty_Scores);
fclose(fid);

waitfor(msgbox("Stop DinnerParty (DinnerParty_8_B36Cal) Noise", "Warning", "warn"));

% display SNR
message = sprintf('The SNR50 is %.2f dB', snr50_DinnerParty_2);
waitfor(msgbox(message));

movefile('*.txt', sprintf('Subject_%03d', subject_num)); 
delete Trial.wav

end

