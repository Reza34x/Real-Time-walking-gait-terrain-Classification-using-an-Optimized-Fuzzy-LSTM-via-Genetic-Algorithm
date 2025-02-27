% 
% 
% 
% for count = 1:30
%     input.batch(count).ax = data.(sprintf('ID%d', count)).shankR.Acc_X{16, 1};
%     input.batch(count).az = data.(sprintf('ID%d', count)).shankR.Acc_Z{16, 1};
%     input.batch(count).wy = data.(sprintf('ID%d', count)).shankR.Gyr_Y{16, 1};
%     input.batch(count).Label = 2;
% end
% 

count = 1;
 for i = 1:30
        
     for j = 4:9
        input.batch(count).ax = data.(sprintf('ID%d', i)).shankR.Acc_X{j, 1};
        input.batch(count).az = data.(sprintf('ID%d', i)).shankR.Acc_Z{j, 1};
        input.batch(count).wy = data.(sprintf('ID%d', i)).shankR.Gyr_Y{j, 1};
        input.batch(count).Label = 1;
        count = count + 1;
     end

     for j = 16:27
        input.batch(count).ax = data.(sprintf('ID%d', i)).shankR.Acc_X{j, 1};
        input.batch(count).az = data.(sprintf('ID%d', i)).shankR.Acc_Z{j, 1};
        input.batch(count).wy = data.(sprintf('ID%d', i)).shankR.Gyr_Y{j, 1};
        if mod(j, 2) == 1
            input.batch(count).Label = 3;
        else 
            input.batch(count).Label = 2;
        end
        count = count + 1;
    end

end

%% Limited
count = 1;
 for i = 1:5
        
     for j = 5:7
        input.batch(count).ax = data.(sprintf('ID%d', i)).shankR.Acc_X{j, 1};
        input.batch(count).az = data.(sprintf('ID%d', i)).shankR.Acc_Z{j, 1};
        input.batch(count).wy = data.(sprintf('ID%d', i)).shankR.Gyr_Y{j, 1};
        input.batch(count).Label = 1;
        count = count + 1;
     end

     for j = 16:21
        input.batch(count).ax = data.(sprintf('ID%d', i)).shankR.Acc_X{j, 1};
        input.batch(count).az = data.(sprintf('ID%d', i)).shankR.Acc_Z{j, 1};
        input.batch(count).wy = data.(sprintf('ID%d', i)).shankR.Gyr_Y{j, 1};
        if mod(j, 2) == 1
            input.batch(count).Label = 3;
        else 
            input.batch(count).Label = 2;
        end
        count = count + 1;
    end

end
%% Extra Label


count = 1;
 for i = 1:30
        
     for j = 4:9
        extra_input.batch(count).ax = data.(sprintf('ID%d', i)).shankR.Acc_X{j, 1};
        extra_input.batch(count).az = data.(sprintf('ID%d', i)).shankR.Acc_Z{j, 1};
        extra_input.batch(count).wy = data.(sprintf('ID%d', i)).shankR.Gyr_Y{j, 1};
        extra_input.batch(count).Label = 1; %Flat Even
        count = count + 1;
     end

     for j = 10:15
        extra_input.batch(count).ax = data.(sprintf('ID%d', i)).shankR.Acc_X{j, 1};
        extra_input.batch(count).az = data.(sprintf('ID%d', i)).shankR.Acc_Z{j, 1};
        extra_input.batch(count).wy = data.(sprintf('ID%d', i)).shankR.Gyr_Y{j, 1};
        extra_input.batch(count).Label = 2; %Cobble stone
        count = count + 1;
     end



     for j = 16:27
        extra_input.batch(count).ax = data.(sprintf('ID%d', i)).shankR.Acc_X{j, 1};
        extra_input.batch(count).az = data.(sprintf('ID%d', i)).shankR.Acc_Z{j, 1};
        extra_input.batch(count).wy = data.(sprintf('ID%d', i)).shankR.Gyr_Y{j, 1};
        if mod(j, 2) == 0
            extra_input.batch(count).Label = 3; %upstarirs
        else 
            extra_input.batch(count).Label = 4; %downstairs
        end
        count = count + 1;
     end

     for j = 28:39
        extra_input.batch(count).ax = data.(sprintf('ID%d', i)).shankR.Acc_X{j, 1};
        extra_input.batch(count).az = data.(sprintf('ID%d', i)).shankR.Acc_Z{j, 1};
        extra_input.batch(count).wy = data.(sprintf('ID%d', i)).shankR.Gyr_Y{j, 1};
        if mod(j, 2) == 0
            extra_input.batch(count).Label = 5; %Slope up
        else 
            extra_input.batch(count).Label = 6; %Slope down
        end
        count = count + 1;
     end



     for j = 52:57
        extra_input.batch(count).ax = data.(sprintf('ID%d', i)).shankR.Acc_X{j, 1};
        extra_input.batch(count).az = data.(sprintf('ID%d', i)).shankR.Acc_Z{j, 1};
        extra_input.batch(count).wy = data.(sprintf('ID%d', i)).shankR.Gyr_Y{j, 1};
        extra_input.batch(count).Label = 7; %Grass 
        count = count + 1;
     end


end


%% Limited Extra Label


count = 1;
 for i = 1:5
        
     for j = 4:9
        extra_input_reduced.batch(count).ax = data.(sprintf('ID%d', i)).shankR.Acc_X{j, 1};
        extra_input_reduced.batch(count).az = data.(sprintf('ID%d', i)).shankR.Acc_Z{j, 1};
        extra_input_reduced.batch(count).wy = data.(sprintf('ID%d', i)).shankR.Gyr_Y{j, 1};
        extra_input_reduced.batch(count).Label = 1; %Flat Even
        count = count + 1;
     end

     for j = 10:15
        extra_input_reduced.batch(count).ax = data.(sprintf('ID%d', i)).shankR.Acc_X{j, 1};
        extra_input_reduced.batch(count).az = data.(sprintf('ID%d', i)).shankR.Acc_Z{j, 1};
        extra_input_reduced.batch(count).wy = data.(sprintf('ID%d', i)).shankR.Gyr_Y{j, 1};
        extra_input_reduced.batch(count).Label = 2; %Cobble stone
        count = count + 1;
     end



     for j = 16:27
        extra_input_reduced.batch(count).ax = data.(sprintf('ID%d', i)).shankR.Acc_X{j, 1};
        extra_input_reduced.batch(count).az = data.(sprintf('ID%d', i)).shankR.Acc_Z{j, 1};
        extra_input_reduced.batch(count).wy = data.(sprintf('ID%d', i)).shankR.Gyr_Y{j, 1};
        if mod(j, 2) == 0
            extra_input_reduced.batch(count).Label = 3; %upstarirs
        else 
            extra_input_reduced.batch(count).Label = 4; %downstairs
        end
        count = count + 1;
     end

     for j = 28:39
        extra_input_reduced.batch(count).ax = data.(sprintf('ID%d', i)).shankR.Acc_X{j, 1};
        extra_input_reduced.batch(count).az = data.(sprintf('ID%d', i)).shankR.Acc_Z{j, 1};
        extra_input_reduced.batch(count).wy = data.(sprintf('ID%d', i)).shankR.Gyr_Y{j, 1};
        if mod(j, 2) == 0
            extra_input_reduced.batch(count).Label = 5; %Slope up
        else 
            extra_input_reduced.batch(count).Label = 6; %Slope down
        end
        count = count + 1;
     end



     for j = 52:57
        extra_input_reduced.batch(count).ax = data.(sprintf('ID%d', i)).shankR.Acc_X{j, 1};
        extra_input_reduced.batch(count).az = data.(sprintf('ID%d', i)).shankR.Acc_Z{j, 1};
        extra_input_reduced.batch(count).wy = data.(sprintf('ID%d', i)).shankR.Gyr_Y{j, 1};
        extra_input_reduced.batch(count).Label = 7; %Grass 
        count = count + 1;
     end


end



















