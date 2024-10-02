This protocol measures SNR50s using the HINT protocol (Nilsson et al.,1994; Wu et al., 2019) in different real-world environments (Weisser etal., 2019) using high-fidelity BKB recordings (Monson et al., 2022).
 
Speech material: https://osf.io/w4h9f/
Noise material: https://zenodo.org/record/2261633#.ZEl0l3bMKUk

This version uses and 8-speaker array. BKB sentences must be convolved with the RIRs of each environment before running this protocol and saved in folders that match the path names in the scripts for each environment.

This version starts with a practice list and then test lists in Cafe1, Cafe2, Dinner Party, Diffuse, FoodCourt1, FoodCourt2, and Church2. Each environment is tested twice. Code is easily modifiable to test more, fewer, or other environments.

Directions: Follow the calibration procedure in Weisser et al., 2019 to calibrate the noise. Noise environments should be calibrated using the Diffuse file so that the LAeq in the sound field is 65.9 dBA. 

Speech noise matching the spectro-temporal characteristics of the BKB sentences was used to determine that in this booth the SPL of the speechat the algorithm output is accurate. But correction factors for speech levels can be added separately for each environment if required based on the measured level of the speech at the output of the algorithm in your booth. Correction factors should be included to meet the appropriate SNR as measured in the sound field if required. The RMS levels required to present the noise and speech at the correct levels in our booth are stored in RealHINT_EHF2251F.mat. You should change these based on your calibration.

Noise environments must be played from a separate source.
 
Adaptive HINT protocol is automatically implemented. Simply mark the sentence correct or incorrect and SNR50s for each environment are automatically stored as an excel file for the subject.

The main function to run the experiment is RealHINT.m. That function will call the dependencies included in the repository.

Code is provided "as-is" without any warranties or guarantees of any kind. The user assumes full responsibility for using this code and any outcomes resulting from its use. The code is provided without any form of support maintenance, or updates. Use at your own risk.

Erik Jorgensen
UW-Madison 2023
erik.jorgensen@wisc.edu

