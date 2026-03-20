# MATLAB Script for Speech-Noise Mixing

## Description
This repository provides MATLAB scripts used to generate speech-in-noise stimuli for the speech intelligibility experiment described in:

Gao, S. H., et al. (2026).  
*Speech intelligibility in aging voices: Effects of dysphonia severity, background noise, and sentence length.*  
Journal of the Acoustical Society of America.

## Script name
`mix_noise_with_speech.m`

## Purpose
This script mixes clean speech recordings with a real-world restaurant noise sample at a specified signal-to-noise ratio (SNR). It was used to generate the noisy stimuli for the speech intelligibility experiment.

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
3. Selects a random noise segment for each speech file
4. Scales the noise to achieve the target SNR
5. Saves the noisy output file in `output_folder`

## Parameters
- **snr_dB**: Desired signal-to-noise ratio, set to 0 dB in the present study

## Example
```matlab
input_folder = 'PATH_TO_SPEECH_FILES';
output_folder = 'PATH_TO_OUTPUT_FOLDER';
noise_file = 'PATH_TO_NOISE_FILE';
snr_dB = 0;

## Notes
- Noise scaling uses overall signal energy to match the target SNR
- Each speech file is paired with a random noise segment to avoid repetition
- Speech signals are normalized to a dataset-derived reference level (mean standard deviation = 0.0353) prior to SNR-based noise mixing to ensure consistent signal power across stimuli.

## Availability
This script is publicly available to support reproducibility of the study.  
Repository: https://github.com/GabbyGaoHKU/speech-intelligibility-noise-mixing
