# **Real-Time walking gait terrain Classification using an Optimized Fuzzy Long Short-Term Memory Neural Network via Genetic Algorithm**

## Abstract
The intelligent classification of human walking states is a challenge we face. The importance of this issue lies in the coordination of humans with wearable 
rehabilitation devices. Additionally, there is uncertainty in identifying an individual’s walking state compared to others, 
and even with each step relative to the previous one. By training with various datasets, the proposed model can be generalized. 
In the referenced paper [1], a Convolutional Long Short-Term Memory (LSTM) network was used to instantly detect the type of terrain with high accuracy and speed. 
However, the proposed method has inputs with high uncertainty. To overcome these issues, fuzzy logic rules were used to convert raw inputs into fuzzy sets, 
which form the network’s input. Then, to select the best parameters with higher efficiency, the Genetic Algorithm (GA) optimization method was applied. 
By using fuzzy logic, the uncertainty in the inputs was resolved. The F1-score metric was used to evaluate the performance of the proposed model. 
In this research, data from an Inertial Measurement Unit (IMU) sensor, based on the prepared information from the study of Yu et al. [2], was used.
Keywords: Genetic Algorithm Optimization, Fuzzy Logic, Inertial Measurement Unit

## Introduction
Walking can be very difficult for some individuals due to dealing with various illnesses, including stroke or disabilities resulting from accidents. 
One of the ways that helps such individuals is the use of wearable devices, orthoses, and prostheses. 
These tools require detecting the type of terrain, which includes flat surfaces, downward slopes, upward slopes, stairs, and more. 
One method for determining the terrain type is using IMU sensors. Delays in receiving and analyzing such information can result in catastrophic outcomes. 
If the terrain type is misidentified, applying force in the wrong direction may cause injury to the individual. 
Therefore, finding the fastest and most accurate method for detecting terrain type is of high importance. 
IMUs usually consist of various sensors such as accelerometers, gyroscopes, and gravimeters. These sensors are capable of recording movement and angular information in the environment.
However, one of the main challenges in using IMU sensors is analyzing and extracting useful and accurate information from the data collected by these sensors. 
Due to noise and potential errors in the sensor data, the use of artificial intelligence algorithms to analyze and process these data is crucial.
In this paper, we employ the Fuzzy-LSTM algorithm for detecting walking terrain using data from IMU sensors in wearable devices like orthoses and prostheses. 
This algorithm combines neural networks with Long Short-Term Memory (LSTM) and fuzzy logic, capable of extracting the required information from sensor data and improving the
detection accuracy.
## Research Methodology
1. **Data Collection**  
In this study, the prepared data from the research by Yu et al. [2] was used.
This data was collected from 30 young participants with no reported neurological or musculoskeletal diseases that could affect their walking or posture,
and no injury history in the past two years. All participants provided written consent [2]. The participants performed multiple walking trials on 9 different surfaces while
 wearing six IMU sensors. The 9 walking surfaces included: 1) flat surface (horizontal, zero-degree, pavement), 2) ascending stairs (cement), 3) descending stairs (cement), 4) downward slope (cement), 5) upward slope (cement), 6) grass, 7) left incline (asphalt), 8) right incline (asphalt), and 9) uneven stone brick [2]. Among these surfaces, the research by Yu et al. [1] focused on stair surfaces (upward and downward) and the flat surface. Additionally, the data used in our research only included data from the sensor mounted on the right shin.

| ![Placement of IMU sensors use in [2]](https://github.com/user-attachments/assets/a8266f93-64ff-4d07-9b34-3e40a6a46c3a) |
|:--:|
| *Placement of IMU sensors use in [2]* |

| ![Going upstairs or downstairs in[2]](https://github.com/user-attachments/assets/2fe256ff-0463-4968-9284-f32f61e0429b) |
|:--:|
| *Going upstairs or downstairs in[2]* |


2. **Terrain Detection**  
Zero-speed torque detection is used to automatically classify walking phases from the initial phase to the next standing phase.
The data used in this research includes linear acceleration forward and vertical $$(ax)^n$$ and $$(az)^n$$, angular velocity in the sagittal plane $$(wy)^n$$,
normalized measurements recorded by the IMU sensor. Walking on different terrains can have common characteristics, so the tools face difficulty in classifying terrain types.
Therefore, features of flat surfaces, ascending stairs, descending stairs, upward slopes, downward slopes, cobblestone, and grass need to be identified.

3. **Fuzzy Long Short-Term Memory Neural Network Classifier**  
Linear acceleration forward and vertical $$(ax)^n$$ and $$(az)^n$$, angular velocity in the sagittal plane $$(wy)^n$$,
 normalized data are given as inputs to the combined algorithm. Each input signal passes through N_C filters of length L_C.
Initially, three different terrains, including flat surface, upward stairs, and downward stairs, were detected using the proposed model
 from the work by Yu et al. [1] with slight modifications, and the execution time was measured, along with the accuracy and F1-score metrics.

| ![CNN-LSTM architecture with 3 labels](https://github.com/user-attachments/assets/a74255f5-d779-4f5d-9577-d28e7d17f970) |
|:--:|
| *CNN-LSTM architecture with 3 labels* |


Each signal is sequentially fed into the convolutional neural network, then passes through a ReLU activation function, which converts negative numbers to zero. The maximum value in the region covered by the filter (Max Pooling) is selected. Its output is fed into an LSTM layer.
Finally, the data are normalized and converted to a probability distribution using the SoftMax function.
Each signal is sequentially fed into the convolutional neural network, then passes through a ReLU activation function, which converts negative numbers to zero. The maximum value in the region covered by the filter (Max Pooling) is selected. Its output is fed into an LSTM layer.
Finally, the data are normalized and converted to a probability distribution using the SoftMax function.

| ![Learning process of CNN-LSTM with 3 label](https://github.com/user-attachments/assets/289eb8ce-0d9b-4d2e-b4fd-2d307576027a) |
|:--:|
| *Learning process of CNN-LSTM with 3 label* |  

Afterward, four more types of terrain, including upward stairs, downward stairs, pavement, and grass, were added,
and their parameters were optimized by the Genetic Algorithm,followed by measuring their accuracy and F1-score.

| ![Learning process of CNN-LSTM with 7 label](https://github.com/user-attachments/assets/121ece35-7183-4335-96ac-75480d523d63) |
|:--:|
| *Learning process of CNN-LSTM with 7 label* |  
  

| **Hyperparameters** | **Description** |
|-----------------|-------------|
| $L_{P} $                  | Max Pooling Size           |
| $L_{C} $                  | Length of the Covolutional Channels          |
| $N_{C} $                  | Number of Convolutional Blocks          |
| $N_{L} $                  | LSTM Hiddent units          |


The inputs are then fed again into the new Fuzzy Long Short-Term Memory (LSTM) neural network model. This model was used to identify whether the use of fuzzy logic instead of 
convolutional neural networks would lead to better results.

In this proposed model, fuzzy logic rules derived from human knowledge were used for preprocessing. 
The fuzzy rules and membership functions were selected based on features that distinguished the parameters across different terrain types. 
For example, in the $ω_{y}$ data, by dividing each consecutive data point into equal sections (e.g., 10 equal sections), it was observed that the minimum value of each section, 
the smaller it is, the more it belongs to label 2 (ascending stairs).

The necessary parameters were optimized using the Genetic Algorithm. These parameters include the LSTM and fuzzy network parameters, such as: 
**changing membership functions**, the **type of AND operator**, the **type of OR operator**, 
the **weight associated with each output** (e.g., a weight of 0.9 for ascending and descending slopes, and a weight of 1 for flat surfaces, which results in better outcomes), 
the **defuzzification method** for each rule’s membership functions, as well as the number of hidden units and the **learning rate** of the LSTM network. 
Afterward, the fuzzy inputs are fed into the LSTM network.

| ![Membership functions obtained from human knowledge(up) and the Membership functions obtained after the GA optimization(down)](https://github.com/user-attachments/assets/e94dfdcd-ae29-4bfc-9859-0d7c10c4d47d) |
|:--:|
| *Membership functions obtained from human knowledge(up) and the Membership functions obtained after the GA optimization(down)* |

| ![Learning process of Optimized Fuzzy-LSTM with 3 labels](https://github.com/user-attachments/assets/ff99283b-2a8d-491f-838c-9bcd49a3d9cc) |
|:--:|
| *Learning process of Optimized Fuzzy-LSTM with 3 labels* |

In this research, the aim is to detect the terrain type immediately after the toe of the foot lifts off the ground (toe off). 
The separation of the toe from the ground occurs between the peaks of $(ωy)^n$, $ω_{max}$, and the first crossing of zero in $(ωy)^n$, $ω0$, from positive to negative.  
This research requires real-time classification because its application is in assistive devices for walking.

| ![Optimized Fuzzy-LSTM](https://github.com/user-attachments/assets/b880ee93-29c6-4369-9da9-3928ab01f59c) |
|:--:|
| *Optimized Fuzzy-LSTM* |

4. **Validation**

For validation and evaluation of the models, we used the accuracy and F1-score metrics. Accuracy is the number of correctly predicted instances divided by the total number of 
predictions made. The formula for accuracy is given by:

Accuracy = 

$$
\frac{TP + TN}{TP + TN + FP + FN}
$$


Recall is a metric where the maximum value is 1 or 100%, and the minimum value is 0. 
The higher the number of expected predictions not made by the model compared to the correct predictions, the lower the recall value will be.
Recall = 

$$
\frac{TP}{TP + FN}
$$

Recall is a metric where the maximum value is 1 or 100%, and the minimum value is 0. The higher the number of expected predictions not made by the model compared to the correct predictions, the lower the recall value will be.
Recall = 

$$
\frac{TP}{TP + FN}
$$

When we want the evaluation metric to average accuracy and recall, we use the harmonic mean of these two metrics, called the F1-score.
F1 = 2 / (1/Recall + 1/Accuracy) = 2 * (Accuracy * Recall) / (Accuracy + Recall)

$$
F1 = \frac{2}{\frac{1}{Recall} + \frac{1}{Accuracy}} = \frac{2 \cdot (Accuracy \cdot Recall)}{Accuracy + Recall}
$$

The confusion matrix is a method used for evaluating the precision and performance of algorithms in machine learning. 
It is displayed as a table where the columns represent the algorithm’s predictions, and the rows represent the actual labels. 
Each cell in the table shows the number of samples that were correctly identified by the algorithm based on their actual labels.

| ![CNN-LSTM confusion matrix with 3 labels](https://github.com/user-attachments/assets/93be92ff-236e-422a-a882-3f6c0785f06b) |
|:--:|
| *CNN-LSTM confusion matrix with 3 labels* |


## Results
By implementing the model used in the paper by Yu et al. [1], with 3 types of terrain (flat surface, upward slope, and downward slope), the model achieved 95% accuracy for real-time classification.

| ![Given the data sampling rate of 100hz, this model could classify the terrain type after 690 ms](https://github.com/user-attachments/assets/90db5601-6b13-4a1c-8a2d-ca2f61f3e6e8) |
|:--:|
| *Given the data sampling rate of 100hz, this model could classify the terrain type after 690 ms* |

Then, by adding 4 additional terrain types (upward stairs, downward stairs, pavement, and grass) and optimizing the parameters using the Genetic Algorithm, the real-time classification accuracy dropped to 86.6%.

| ![CNN-LSTM confusion matrix with 7 labels](https://github.com/user-attachments/assets/196722e8-7c6b-4279-ac90-d6a4687d71aa) |
|:--:|
| *CNN-LSTM confusion matrix with 7 labels* |

![image](https://github.com/user-attachments/assets/3f2a4e6a-6ec9-4a98-8826-5f7a849523a6)

Finally, the Fuzzy-LSTM model was developed to detect 3 types of terrain (flat surface, upward stairs, and downward stairs), and its parameters were optimized using the Genetic Algorithm, achieving real-time accuracy of 73.3%.

| ![Optimized Fuzzy-LSTM confusion matrix with 3 labels](https://github.com/user-attachments/assets/b7914698-c7f2-473d-9174-92d24b788639) |
|:--:|
| *Optimized Fuzzy-LSTM confusion matrix with 3 labels* |

| ![Genetic Algorithm Process](https://github.com/user-attachments/assets/e73d6b1a-3371-472f-a8d0-7f02e8733796)|
|:--:|
| *Genetic Algorithm Process* |



| ![Accuracy of different models](https://github.com/user-attachments/assets/21c9f75a-f113-4b49-b4cc-3272ffa0eeb5) |
|:--:|
| *Accuracy of different models* |

| ![F1-Score of different models](https://github.com/user-attachments/assets/57a9eb90-4c25-44f9-9079-8b4802470f11) |
|:--:|
| *F1-Score of different models* |

## Conclusion
The proposed CNN-LSTM model performed well with 95% accuracy for real-time classification of walking terrain types. As the number of labels increased, the model’s performance decreased. The use of fuzzy logic instead of CNN reduced the accuracy, but with further optimization, better results could be achieved. Further improvements might lead to better real-time classification of walking terrain types.

## Future Research
Future research can benefit from applying genetic algorithms more effectively to identify suitable fuzzy rules for optimal labeling of data. The algorithm could allow adding and removing different fuzzy rules and membership functions. In the genetic algorithms' fitness function, both the labeling accuracy and the labeling speed should be considered to ensure the best performance for real-time labeling.






























