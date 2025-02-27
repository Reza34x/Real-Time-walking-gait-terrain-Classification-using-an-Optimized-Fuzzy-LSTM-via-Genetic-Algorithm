
clear  input_sequence

for m = 1:10

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

%% figure

to_show = 10;
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
legend('level' , 'ascend', 'descend')
xticks(0:100:size(delay_label{to_show, 1},2))
grid("on")


subplot(2,1,2)
plot(test_input{5,1}(1,:), linewidth = 1, Marker=".",...
    MarkerSize=15,MarkerIndices=100:100:size(delay_label{to_show, 1},2))
xticks(0:100:1500)
grid("on")







