# Guitar Tuner App

A MATLAB App Designer project implementing a **six-string guitar tuner**. The application records a short sound sample through a microphone, performs **bandpass filtering**, applies a **Fast Fourier Transform (FFT)** to find the dominant frequency, and compares it with the target tuning frequency.  

The user can select which string to tune, view the real-time spectrum, and see whether the frequency is too low, too high, or in tune.

---

### Key Features
- Developed entirely in **MATLAB App Designer**
- Audio acquisition and signal processing
- Custom bandpass filters for each guitar string (`filtracja_E`, `filtracja_A`, `filtracja_D`, `filtracja_G`, `filtracja_B`, `filtracja_E6`)
- Frequency display and semicircular tuning gauge

---

### How It Works
1. Launch `Tuner_Bartosz_Trela.m` in MATLAB.
2. Select the string you want to tune.
3. Press **Start Strojenia (Start Tuning)**.
4. Play the string — the app records for 5 seconds and processes the sound.
5. View the measured frequency and graphical feedback (too low / in tune / too high).

---

*Author: Bartosz Trela*  
*Date of completion: 2024*
