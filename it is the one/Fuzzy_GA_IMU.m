function  Fuzzy_GA_IMU (input, numAnd, numOr, weight, numDefuzzi, parameter1, parameter2, numHiddenUnits, numLearningRate)
warning off
accuarcy = 0;

%% defining GA paremeters
 

% "devide" is a parameters ranging from 5 to 150;
% "numAnd" is a parameters [1, 2];
% "numOr" is a parameters [1, 2];
% "weight" is a (1*3)parameter [0, 1];
% "numDefuzzi" is a parameters [1, 4];
% "parameter1 is a (4*3) parameters [-0.5, 0.5];
% "parameter2 is a (4*3) parameters [-2, 2];
% "numHiddenUnits" is a parameters [1, 4];
% "numLearningRate" is a parameters [1, 3];



fis = readfis('original.fis');

And = ["prod", "min"];
fis.AndMethod = And(numAnd);

Or = ["probor", "max"];
fis.OrMethod = Or(numOr);

fis.rules(1,2).weight = weight(1,1);
fis.rules(1,2).weight = weight(1,2);
fis.rules(1,3).weight = weight(1,3);
Defuzzi = ["centroid", "mom", "lom", "som"];
fis.DefuzzificationMethod = Defuzzi(numDefuzzi);


fis.Inputs(1, 1).MembershipFunctions(1, 1).Parameters = [-0.3223 + parameter1(1,1), 4.0836 + parameter2(1,1)];
fis.Inputs(1, 1).MembershipFunctions(1, 2).Parameters = [abs(0.7139 + parameter1(1,2)), 1.3500 + parameter2(1,2)];

fis.Inputs(1, 2).MembershipFunctions(1, 1).Parameters = [ -4.0879 + parameter1(2,1), -1.5516 + parameter2(2,1)];
fis.Inputs(1, 2).MembershipFunctions(1, 2).Parameters = [ abs(0.7500 + parameter1(2,2)), -2.9630 + parameter2(2,2)];
fis.Inputs(1, 2).MembershipFunctions(1, 3).Parameters = [ abs(0.7500 + parameter1(2,3)), -2.0472 + parameter2(2,3)];

fis.Inputs(1, 3).MembershipFunctions(1, 3).Parameters = [ abs(0.3000 + parameter1(3,2)), -0.5000 + parameter2(3,2)];

parameter1(1, 3) = 0;parameter2(1, 3) = 0;
parameter1(3, 1) = 0;parameter2(3, 1) = 0;
parameter1(3, 3) = 0;parameter2(3, 3) = 0;


fis.Inputs(1, 4).MembershipFunctions(1, 1).Parameters = [ 0.9000 + parameter1(4,1), 2.0000 + parameter2(4,1)];
fis.Inputs(1, 4).MembershipFunctions(1, 2).Parameters = [ abs(0.4300 + parameter1(4,2)), 0.9200 + parameter2(4,2)];
fis.Inputs(1, 4).MembershipFunctions(1, 3).Parameters = [ abs(0.4300 + parameter1(4,3)),  0.4000 + parameter2(4,3)];


HiddenUnit = [5, 10, 20, 40];
LearningRate = [0.001, 0.01, 0.1];





%% Normalizing the input

clear inputs
clear label
for m=1:540  %storing in a cell
    inputs{m,1}(1,:) = norma(input.batch(m).ax); 
    inputs{m,1}(2,:) = norma(input.batch(m).az);
    inputs{m,1}(3,:) = norma(input.batch(m).wy);
    label(m,1) = input.batch(m).Label;
end
label = categorical(label);
clear m i


clear fuzzification

%fuzzifying the inputs with regarding to their min and max of each parts
for i = 1:540
    length = numel(inputs{i, 1}(1,:));
    length = round(length/50); %deviding the input into parts with same length 
    tempLength = length;

    for j = 1:10 
        fuzzification{i,1}(1,j) = max(inputs{i, 1}(1,tempLength:tempLength + length));
        tempLength = tempLength + length ;
        if tempLength + length> numel(inputs{i, 1}(1,:)) %check if we get to input's size limit
            break
        end
    end

    tempLength = length;
    for j = 1:10
        fuzzification{i,1}(2,j) = min(inputs{i, 1}(2,tempLength:tempLength + length));
        tempLength = tempLength + length ;
        if tempLength + length> numel(inputs{i, 1}(1,:))%check if we get to input's size limit
            break
        end
    end

    tempLength = length;
    for j = 1:10
        fuzzification{i,1}(3,j) = min(inputs{i, 1}(3,tempLength:tempLength + length));
        tempLength = tempLength + length ;
        if tempLength + length> numel(inputs{i, 1}(1,:))%check if we get to input's size limit
            break
        end
    end

    tempLength = length;
    for j = 1:10
        fuzzification{i,1}(4,j) = max(inputs{i, 1}(2,tempLength:tempLength + length));
        tempLength = tempLength + length ;
        if tempLength + length> numel(inputs{i, 1}(1,:))%check if we get to input's size limit
            break
        end
    end



end

fuzzy_label = label;
%% Fuzzy Infrence systems


%fuzzy preprocessing by applying FIS
for m = 1:540
    for n = 1:size(fuzzification{m})
        fuzzy_input{m, 1}(1, n) = evalfis(fis, fuzzification{m,1}(:,n));
    end
end

%% training/validation/test
numtraining = 300;
numvalidation = 30;
numtest = 540-numvalidation-numtraining;
clear training_input validation_input test_input training_label validation_label test_label

for i = 1:numtraining
    training_input{i,1} = fuzzy_input{i};
    training_label(i,1) = label(i,1);
end

for i = 1:numvalidation
    validation_input{i,1} = fuzzy_input{i+numtraining};
    validation_label(i,1) = label(i+numtraining,1);
end

for i = 1:numtest
    test_input{i,1} = fuzzy_input{i+numtraining+numvalidation,1};
    test_label(i,1) = label(i+numtraining+numvalidation,1);
end




%%  Network
miniBatchSize = 32;
inputSize = 1;
numClasses = 3;


for count = 1 : numel(fuzzy_input)
    minlength(count) = size(fuzzy_input{count},2);
end

layers = [ ...
    sequenceInputLayer(inputSize, 'MinLength', min(minlength)) 
    lstmLayer(HiddenUnit(numHiddenUnits), 'OutputMode', 'last')
    dropoutLayer(0.5)  % Add dropout regularization
    fullyConnectedLayer(numClasses)
    softmaxLayer
    classificationLayer];

options = trainingOptions("rmsprop", ...
    'ExecutionEnvironment', 'gpu', ...
    'InitialLearnRate', LearningRate(numLearningRate), ...
    'ValidationData',{validation_input,validation_label},...
    'ValidationFrequency', 10,...
    'MaxEpochs', 100, ...
    'MiniBatchSize', miniBatchSize, ...
    'SequenceLength', 'longest', ...
    'Shuffle', 'once', ...
    'Verbose', 0, ...
    'OutputNetwork','last-iteration', ...
    'Plots', 'training-progress');

net = trainNetwork(training_input, training_label, layers, options);

%%  test the network

 predict_label = classify(net,test_input);
 accuarcy = 100 * mean( predict_label == test_label);
 disp("The accuarcy is " +  accuarcy + "%")
     disp(" AndMethod = "+ And(numAnd) ...
     +" + OrMethod = "+ Or(numOr) ...
     +" + rules weights of " + weight(1,1) +" and "+  weight(1,2) +" and "+ weight(1,3)...
     +" + DefuzzificationMethod = " + Defuzzi(numDefuzzi)...
     +" + parameter1 = " + parameter1(1,1) +" + "+ parameter1(1,2) +" + "+ parameter1(2,1) +" + "+ parameter1(2,2)...
     +" + "+ parameter1(2,3) +" + "+  parameter1(3,2) +" + "+ parameter1(4,1) +" + "+ parameter1(4,2) +" + "+ parameter1(4,3)...
     +" + parameter2 = " + parameter2(1,1) +" + "+ parameter2(1,2) +" + "+ parameter2(2,1) +" + "+ parameter2(2,2)...
     +" + "+ parameter2(2,3) +" + "+  parameter2(3,2) +" + "+ parameter2(4,1) +" + "+ parameter2(4,2) +" + "+ parameter2(4,3)...
     +" + Hiddenunit of " + HiddenUnit(numHiddenUnits)...
     +" + LearningRate of "+ LearningRate(numLearningRate));
     disp("---------------------------------------------------------------------------------------------------------------------------------------------")

%% F1-score

C = confusionmat(test_label, predict_label);

% Plot the confusion matrix
figure(1)
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
%% Delay time
for m = 1:20

    desired_min_length = 35;
%     data_start = randi([200 300]);    %start of data point
      data_start = 200;
    sequence_length = size(test_input{m}, 2)-data_start;
    correct_classifications = zeros(1, sequence_length); 

    for i = 1:sequence_length
        input_sequence = test_input{m}(:, data_start:data_start+i); 
    

        if size(input_sequence, 2) < desired_min_length
            zeros_length = desired_min_length - size(input_sequence, 2);
%             input_sequence = padarray(input_sequence, [0 zeros_length], 0, 'post');
            input_sequence = [input_sequence zeros(3, zeros_length)];
        end
    
        delay_label{m,1}(1:3,i)= predict(net, input_sequence);
      
    end

end

%% figure delay

    figure()
    to_show = 10; %what batch you want to see?
    subplot(2,1,1)
    plot(smoothdata(delay_label{to_show, 1}(1,:), "gaussian", 35), linewidth = 1,...
        Marker=".", MarkerSize=15,MarkerIndices=100:100:size(delay_label{to_show, 1},2))
    hold on
    plot(smoothdata(delay_label{to_show, 1}(2,:), "gaussian", 35), linewidth = 1,...
        Marker=".", MarkerSize=15,MarkerIndices=100:100:size(delay_label{to_show, 1},2))
    hold on
    plot(smoothdata(delay_label{to_show, 1}(3,:), "gaussian", 35), linewidth = 1,...
        Marker=".", MarkerSize=15,MarkerIndices=100:100:size(delay_label{to_show, 1},2))
    hold off
    title("Predicted labels")
    legend('level' , 'ascend', 'descend')
    xticks(0:100:size(delay_label{to_show, 1},2))
    grid("on")
    
    
    subplot(2,1,2)
    plot(test_input{to_show,1}(1,:), linewidth = 1, Marker=".",...
        MarkerSize=15,MarkerIndices=100:100:size(delay_label{to_show, 1},2))
    title("IMU Data")
    xticks(0:100:1500)
    grid("on")









end






























