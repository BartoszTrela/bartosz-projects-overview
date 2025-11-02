# Voice Processing in a Stormtrooper Helmet

An engineering thesis project focused on designing and implementing a **real-time voice modulation system** embedded inside a **Stormtrooper helmet replica**. The system captures live speech, processes it in C++ using the **JUCE framework**, and outputs a modified version of the voice with minimal delay.

---

### Objective
To recreate the distinctive **Stormtrooper vocal timbre** from the *Star Wars* films through real-time digital signal processing, while integrating all hardware inside a wearable helmet.

---

### System Overview
- **Platform:** Raspberry Pi 4B running Raspberry Pi OS  
- **Audio I/O:** SPH0645 MEMS I²S microphone and 3W internal loudspeaker  
- **Software:** Real-time DSP chain implemented in **C++/JUCE**  
- **Filtering:** 5th-order filters (755–2800 Hz) matched to original Stormtrooper recordings  
- **Hardware design:** Custom 3D-printed PET-G helmet with acoustic isolation for speaker and microphone

---

### Results
- Achieved desired processing latency (meeting real-time criteria)  
- Speaker isolation chamber reduced acoustic feedback by **≈14 dB**  
- Direct voice leakage decreased by **≈5 dB** through mechanical sealing  
- **93% of test listeners** identified the processed sound as Stormtrooper-like  
- All electronics successfully integrated within the helmet shell

---

### Tools & Methods
- C++ / JUCE Framework  
- MATLAB (filter design and spectral analysis)  
- Raspberry Pi 4B  
- 3D printing (PET-G) and acoustic prototyping

---

*Author: Bartosz Trela*  
*Date of completion: 2024*
