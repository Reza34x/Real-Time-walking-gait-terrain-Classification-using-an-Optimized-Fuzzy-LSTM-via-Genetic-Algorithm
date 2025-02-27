
%%  with normalization
clear input_data label

for m=1:1260
    input_data{m,1}(1,:) = normalize(smoothdata(extra_input.batch(m).ax, 'movmean', 200), "range")';
    input_data{m,1}(2,:) = normalize(smoothdata(extra_input.batch(m).az, 'movmean', 200), "range")';
    input_data{m,1}(3,:) = normalize(smoothdata(extra_input.batch(m).wy, 'movmean', 200), "range")';
    label(m,1) = extra_input.batch(m).Label;
end
label = categorical(label);


%% training/validation/test
numtraining = 1000;
numvalidation = 84;
numtest = 1260-numvalidation-numtraining;
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
numClasses = 7;


for count = 1 : numel(input_data)
    minlength(count) = size(input_data{count},2);
end

layers = [ ...
    sequenceInputLayer(inputSize, 'Normalization','rescale-zero-one', 'MinLength',min(minlength)) 
    convolution1dLayer(10, 32)
    batchNormalizationLayer
    reluLayer
    maxPooling1dLayer(15, 'Stride', 15)
    flattenLayer
    bilstmLayer(numHiddenUnits, 'OutputMode', 'sequence')
    lstmLayer(numHiddenUnits, 'OutputMode', 'last')
    dropoutLayer(0.5)  % Add dropout regularization
    fullyConnectedLayer(numClasses)
    softmaxLayer
    classificationLayer];

options = trainingOptions("rmsprop", ...
    'ExecutionEnvironment', 'gpu', ...
    'InitialLearnRate', 0.01, ...
    'ValidationData',{validation_input,validation_label},...
    'ValidationFrequency', 200,...
    'MaxEpochs', 60, ...
    'MiniBatchSize', miniBatchSize, ...
    'SequenceLength', 'longest', ...
    'Shuffle', 'once', ...
    'Verbose', 0, ...
    'OutputNetwork','best-validation-loss', ...
    'Plots', 'training-progress');

net = trainNetwork(training_input, training_label, layers, options);

%%  test the network

 predict_label = classify(net,test_input);
 accuarcy = 100 * mean( predict_label == test_label);
 disp("the accuracy of network is " +  accuarcy + "%")

%% F1_Score

% Calculate the confusion matrix
C = confusionmat(test_label, predict_label);
figure
confusionchart(C, {'Flat Even', 'Stone', 'upstarirs'...
    'downstairs', 'Slope up', 'Slope down', 'grass'});
title('Confusion Matrix');
% 
% % Calculate F1-score for each class
% precision = zeros(1, size(C, 1));
% recall = zeros(1, size(C, 1));
% f1_score = zeros(1, size(C, 1));
% 
% for i = 1:size(C, 1)
%     precision(i) = C(i,i) / sum(C(:,i));
%     recall(i) = C(i,i) / sum(C(i,:));
%     f1_score(i) = 2 * precision(i) * recall(i) / (precision(i) + recall(i));
% end
% 
% % Calculate weighted average F1-score
% num_instances = sum(sum(C));
% weighted_f1_score = sum(f1_score .* sum(C, 2)') / num_instances;
% 
% % Display the F1 score
% 
% disp("Total F1 score is: "+ mean(f1_score))




