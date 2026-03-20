% Folder and file paths
% Replace the placeholder paths below with your own local paths before running the script.
input_folder = 'PATH_TO_SPEECH_FILES';
output_folder = 'PATH_TO_OUTPUT_FOLDER';
noise_file = 'PATH_TO_NOISE_FILE';

% Create output folder if it does not exist
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end

% Read the preprocessed noise (convert to mono if needed)
[noise, noise_fs] = audioread(noise_file);
if size(noise, 2) > 1
    noise = mean(noise, 2);  % If stereo, convert to mono
end

% Get all speech files
audio_files = dir(fullfile(input_folder, '*.wav'));

% Set SNR (in dB)
snr_dB = 0;

for i = 1:length(audio_files)
    fprintf('Processing file %d: %s\n', i, audio_files(i).name);

    % Read speech
    input_path = fullfile(input_folder, audio_files(i).name);
    [speech, Fs] = audioread(input_path);
    if size(speech, 2) > 1
        speech = mean(speech, 2);
    end

    % Check sampling rate consistency
    if Fs ~= noise_fs
        error('Sampling rate mismatch between speech file %s and the noise file.', audio_files(i).name);
    end

    len = length(speech);

    % Ensure noise length >= speech length; if not, repeat noise by concatenation
    if length(noise) < len
        rep_times = ceil(len / length(noise));
        noise = repmat(noise, rep_times, 1);   % Repeat noise
    end

    % Random start index
    max_start = length(noise) - len + 1;
    start_idx = randi(max_start);
    noise_segment = noise(start_idx : start_idx + len - 1);

    % Estimate SNR using overall energy
    % Normalize speech signal to a fixed reference level prior to noise scaling
    % Intensity normalization (e.g., ~65 dB in Praat) does not ensure equal signal power across stimuli
    % Since noise is scaled based on speech power, variations in speech power would lead to
    % inconsistent perceived noise levels across files
    % The reference value (0.0353) corresponds to the mean standard deviation of all speech signals
    % in the dataset, ensuring consistent signal power before SNR-based noise mixing
    speech = speech * 0.0353 / std(speech);
    speech_power = mean(speech.^2);
    desired_noise_power = speech_power / (10^(snr_dB / 10));
    actual_noise_power = mean(noise_segment.^2);
    scaling_factor = sqrt(desired_noise_power / actual_noise_power);
    noise_scaled = noise_segment * scaling_factor;

    % Generate noisy speech
    noisy_signal = speech + noise_scaled;

    % Save output
    [~, name, ext] = fileparts(audio_files(i).name);
    output_name = sprintf('%s_snr0dB%s', name, ext);
    output_path = fullfile(output_folder, output_name);
    audiowrite(output_path, noisy_signal, Fs);
end

disp('All speech files have been processed for SNR 0 dB noise addition.');
