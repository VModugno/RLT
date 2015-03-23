%% N-armed bandit class
% arm_stc.n = number of lever
% arm_stc.mean(i) = mean of curent bandit
% arm_stc.var(i)  = vafr of current bandit


classdef Bandit < handle
   
   properties
      average_range             % range of mean value to randomly generate the reward function
      variance_range            % range of mean value to randomly generate the reward function
      update_distribution       % if i dont specify the value of each lever 
      parameter_matrix          % for each lever i define a set of parameters. this is a M x N matrix where M is the number of param and N is the number of levers
      lever_distribution        % define one distribution for all the levers
      
   end
   
   
   methods
      function obj = Bandit(arm_stc,average_range,variance_range,update_distribution,lever_distribution)
         
         obj.average_range = average_range;
         obj.variance_range = variance_range;
         obj.update_distribution = update_distribution;
         obj.lever_distribution = lever_distribution;
         % if it is empty i randomly choose the distribution parameters in
         % the ranges
         if(isempty(arm_stc.mean))
            switch obj.update_distribution
               case 'Uniform'
                  for ii = 1 : arm_stc.n
                      arm_stc.mean(ii) = RandomValue(obj.average_range);
                      arm_stc.var(ii) = RandomValue(obj.variance_range);
                  end
               case 'Normal'
                  arm_stc.mean = mvnrnd( zeros(1,arm_stc.n)  , eye(arm_stc.n)); 
                  arm_stc.var  = ones(1,arm_stc.n);        
            end
         end
         
        obj.parameter_matrix(1,:) =  arm_stc.mean;
        obj.parameter_matrix(2,:) =  arm_stc.var;
        
      end
      
      %
      function reward = PullLever(obj,n)
         reward = random(obj.lever_distribution,obj.parameter_matrix(1,n),obj.parameter_matrix(2,n));
      end
      
      function reward = PullAllLever(obj)
         reward = random(obj.lever_distribution,obj.parameter_matrix(1,:),obj.parameter_matrix(2,:));
      end
      
      
      function n=NofLever(obj)
         n=size(obj.parameter_matrix,2);
      end
      
      function UpdateLever(obj)
         switch obj.update_distribution
               case 'Uniform' 
                  mean = RandomValue(obj.average_range,size(obj.parameter_matrix,2));
                  var = RandomValue(obj.variance_range,size(obj.parameter_matrix,2));
                  obj.parameter_matrix(1,:) =  mean;
                  obj.parameter_matrix(2,:) =  var;
               case 'Normal'
                  mean = mvnrnd( zeros(1,size(obj.parameter_matrix,2))  , eye(size(obj.parameter_matrix,2))); 
                  obj.parameter_matrix(1,:) =  mean;      
         end
      end
   
   end

end


function val = RandomValue(range,len)
val = (range(1)-range(0)).*rand(1,len) + range(0);
end
