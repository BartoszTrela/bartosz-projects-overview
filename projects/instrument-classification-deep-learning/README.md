# Musical Instrument Classification Using Deep Learning

A MATLAB project focused on the **classification of musical instruments** using **transfer learning** and the pre-trained **AlexNet** convolutional neural network. The task involved generating a custom dataset of spectrograms from short audio fragments and training a modified AlexNet model to recognize instrument type based on timbre features.

---

### Project Overview
- Created a custom dataset from synthesized recordings of **cello, flute, and piano**.
- Converted audio signals into **log-scaled spectrograms** resized to **227×227×3** for AlexNet input.
- Applied **transfer learning** to adapt AlexNet for 3-class classification.
- Tuned parameters of the **Adam optimizer** (learning rate, epochs) to reduce overfitting.

---

### Key Results
- Achieved **~91% accuracy** in instrument classification on a self-recorded dataset.
- Demonstrated that fine-tuned pre-trained CNNs can effectively classify musical timbre from short audio samples.

---

### Tools & Techniques
- **MATLAB** (Deep Learning Toolbox)
- **Spectrogram generation** and image preprocessing
- **Transfer learning** using AlexNet
- **Parallel computing** for dataset creation

---

*Authors: Bartosz Trela, Michał Zienkowicz*  
*Date of completion: 2024*
