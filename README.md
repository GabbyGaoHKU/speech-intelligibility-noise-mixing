# MATLAB Script for Speech-Noise Mixing

## Description
This repository provides a MATLAB script used to generate speech-in-noise stimuli for the speech intelligibility experiment described in:

Gao, S. H., et al. (2026).  
*Speech intelligibility in aging voices: Effects of dysphonia severity, background noise, and sentence length.*  
Journal of the Acoustical Society of America.

## Script name
`mix_noise_with_speech.m`

## Purpose
This script mixes clean speech recordings with a real-world restaurant noise sample at a specified signal-to-noise ratio (SNR). The public script corresponds to the 0 dB SNR condition used in the formal speech intelligibility experiment.

## Requirements
- MATLAB R2020b or later
- Audio Toolbox
- Input speech files in `.wav` format
- A background noise file in `.wav` format

## Inputs
- **input_folder**: Path to the folder containing clean speech `.wav` files
- **output_folder**: Path to the folder where noisy speech files will be saved
- **noise_file**: Path to the background noise recording

## How it works
1. Reads all speech `.wav` files from `input_folder`
2. Reads the noise file and converts it to mono if needed
3. Scales each speech waveform to a dataset-derived reference standard deviation of 0.0353 before SNR-based noise mixing
4. Extracts a duration-matched noise segment from the restaurant noise recording using a fixed starting point
5. Scales the extracted noise segment to achieve the target SNR
6. Saves the noisy output file in `output_folder`

## Parameters
- **snr_dB**: Desired signal-to-noise ratio, set to 0 dB in the formal experiment
- **reference_std**: Dataset-derived reference standard deviation for speech waveform scaling, set to 0.0353
- **fixed_start_time_sec**: Fixed starting point for extracting the restaurant-noise segment, set to 5 seconds

## Example
```matlab
input_folder = 'PATH_TO_SPEECH_FILES';
output_folder = 'PATH_TO_OUTPUT_FOLDER';
noise_file = 'PATH_TO_NOISE_FILE';
snr_dB = 0;
```

## Notes
- Noise scaling uses mean squared amplitude, i.e., digital signal power, to match the target SNR.
- For each speech file, a duration-matched segment was extracted from the same restaurant noise recording using a fixed starting point.
- Speech signals were scaled to a dataset-derived reference level (mean standard deviation = 0.0353) prior to SNR-based noise mixing to ensure comparable signal power across stimuli.
- The 0 dB SNR condition was defined as equal digital signal power between the target speech and the background noise before mixing. This does not mean that the speech and noise signals were independently presented at 65 dB SPL.

## Availability
This script is publicly available to support reproducibility of the study.  
Repository: https://github.com/GabbyGaoHKU/speech-intelligibility-noise-mixing
