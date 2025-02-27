% clear input_data
% clear label
% for m=1:45
%     input_data{m,1}(1,:) = input.batch(m).ax';
%     input_data{m,1}(2,:) = input.batch(m).az';
%     input_data{m,1}(3,:) = input.batch(m).wy';
%     label(m,1) = input.batch(m).Label;
% end
% label = categorical(label);
%%  with normalization
clear input_data label

for m=1:540
    input_data{m,1}(1,:) = normalize(smoothdata(input.batch(m).ax, 'movmean', 150), "range")';
    input_data{m,1}(2,:) = normalize(smoothdata(input.batch(m).az, 'movmean', 150), "range")';
    input_data{m,1}(3,:) = normalize(smoothdata(input.batch(m).wy, 'movmean', 150), "range")';
    label(m,1) = input.batch(m).Label;
end
label = categorical(label);
% plot(normalize(smoothdata(input.batch(m).az, 'movmean', 1), "range"));
% hold on
% plot(input.batch(m).az);
% normalize(input.batch(m).az, "range")

% %% log
% clear input_data
% for m=1:numel(input_data)
%     input_data{m,1}(1,:) = log(input.batch(m).ax - min(input.batch(m).ax) +10)';
%     input_data{m,1}(2,:) = log(input.batch(m).az - min(input.batch(m).az) +10)';
%     input_data{m,1}(3,:) = log(input.batch(m).wy - min(input.batch(m).wy) +10)';
% %     label(m,1) = input.batch(m).Label;
% end
% 
% plot(log(input.batch(m).az - min(input.batch(m).az) +100));
% hold on
% plot(input.batch(m).az);
%% butterworth
% 
% [a, b] = butter(2,0.1, "low");
% plot(filter(b,a,(input_data{1, 1}(2,:))))



%% training/validation/test
numtraining = 378;
numvalidation = 81;
numtest = 540-numvalidation-numtraining;
clear training_input validation_input test_input training_label validation_label test_label

for i = 1:numtraining
    training_input{i,1} = input_data{i};
    training_label(i,1) = label(i,1);
end

for i = 1:numvalidation
    validation_input{i,1} = input_data{i+numtraining};
    validation_label(i,1) = label(i+numtraining,1);
end

for i = 1:numtest
    test_input{i,1} = input_data{i+numtraining+numvalidation,1};
    test_label(i,1) = label(i+numtraining+numvalidation,1);
end




%%  Network
miniBatchSize = 32;
inputSize = 3;
numHiddenUnits = 20;
numClasses = 3;


for count = 1 : numel(input_data)
    minlength(count) = size(input_data{count},2);
end

layers = [ ...
    sequenceInputLayer(inputSize, 'Normalization','rescale-symmetric', 'MinLength', 35)%min(minlength)) 
    convolution1dLayer(15, 32)
    batchNormalizationLayer
    reluLayer
    maxPooling1dLayer(15, 'Stride', 15)
    flattenLayer
    bilstmLayer(numHiddenUnits, 'OutputMode', 'last')
    dropoutLayer(0.5)  % Add dropout regularization
    fullyConnectedLayer(numClasses)
    softmaxLayer
    classificationLayer];

options = trainingOptions("rmsprop", ...
    'ExecutionEnvironment', 'gpu', ...
    'InitialLearnRate', 0.001, ...
    'ValidationData',{validation_input,validation_label},...
    'ValidationFrequency', 10,...
    'MaxEpochs', 25, ...
    'MiniBatchSize', miniBatchSize, ...
    'SequenceLength', 'longest', ...
    'Shuffle', 'every-epoch', ...
    'Verbose', 0, ...
    'OutputNetwork','best-validation-loss', ...
    'Plots', 'training-progress');

net = trainNetwork(training_input, training_label, layers, options);

%%  test the network

 predict_label = classify(net,test_input);
 accuarcy = 100 * mean( predict_label == test_label);
 disp("the accuracy of network is " +  accuarcy + "%")

%% real-time
% for i = 35:35:1100
%     predict_label(i/35) = classify(net,test_input{13,1}(1:3,1:i))
% end
%% F1-score

C = confusionmat(test_label, predict_label);

% Plot the confusion matrix
figure
confusionchart(C, {'Flat Even' 'upstarirs' 'downstairs'});
title('Confusion Matrix');


% Calculate F1-score for each class
precision = zeros(1, size(C, 1));
recall = zeros(1, size(C, 1));
f1_score = zeros(1, size(C, 1));

for i = 1:size(C, 1)
    precision(i) = C(i,i) / sum(C(:,i));
    recall(i) = C(i,i) / sum(C(i,:));
    f1_score(i) = 2 * precision(i) * recall(i) / (precision(i) + recall(i));
end

% Calculate weighted average F1-score
num_instances = sum(sum(C));
weighted_f1_score = sum(f1_score .* sum(C, 2)') / num_instances;

% Display the F1 score
disp("F1 score of flat-even is: "+ f1_score(1))
disp("F1 score of flat-even is: "+ f1_score(2))
disp("F1 score of flat-even is: "+ f1_score(3))
disp("Total F1 score is: "+ mean(f1_score))





