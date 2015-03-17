%% N-armed bandit class
% arm_stc.n = number of lever
% arm_stc.mean(i) = mean of curent bandit
% arm_stc.var(i)  = vafr of current bandit


classdef Bandit
   
   properties
      average_range   % range of mean value to randomly generate the reward function
      variance_range  % range of mean value to randomly generate the reward function
      reward_function % to each lever associate a reward function (gaussian) cell vector
   end
   
   
   methods
      function obj = Bandit(arm_stc,average_range,variance_range)
         
         obj.average_range = average_range;
         obj.variance_range = variance_range;
         % if it is empty i randomly choose the distribution parameters in
         % the ranges
         if(isempty(arm_stc.mean))
            for ii = 1 : arm_stc.n
                arm_stc.mean(ii) = RandomValue(obj.average_range);
                arm_stc.var(ii) = RandomValue(obj.variance_range);
            end
         end
         
         for i=1:arm_stc.n
            obj.reward_function{i} = makedist('Normal','mu',arm_stc.mean(i),'sigma',arm_stc.var(i));
         end
        
        
      end
      
      
      function reward = PullLever(obj,n)
         reward = random(obj.reward_function{n});
      end
      
      function n=NofLever(obj)
         n=size(obj.reward_function,2);
      end
      
      
   end
   
end




function val = RandomValue(range)
val = (range(1)-range(0)).*rand(1000,1) + range(0);
end
