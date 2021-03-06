

classdef EpsGreedy < handle
   
   properties
      arm_stc_vec      % cell array of arm_stc
      action_value     % vector of the current value associated to the i-th action
      reward_matrix    % matrix with the sum of reward for each action
      number_of_update % define the number of time that i selected a lever 
      eps              % epsilon for action selection
   end
   
   
   methods
      function obj = EpsGreedy(arm_stc,start_action_value,eps)
      
         obj.arm_stc_vec = arm_stc;
         obj.eps = eps;
         
         %obj.number_of_update = zeros(size(obj.arm_stc_vec,2),1);
         for i=1:size(obj.arm_stc_vec,2)
            obj.number_of_update(i,:) = zeros(1,obj.arm_stc_vec{i}.n);
         end
         
         for i=1:size(obj.arm_stc_vec,2)
            obj.reward_matrix(i,:) = zeros(1,obj.arm_stc_vec{i}.n);
         end
         
         for i=1:size(obj.arm_stc_vec,2)
            for j = 1:obj.arm_stc_vec{i}.n
               obj.action_value(i,j) = start_action_value(i,j);
            end
         end
         
      end
      
      function UpdatePolicy(obj,n_bandit,n_action,reward)
         %obj.action_value(n_bandit,n_action) = obj.action_value(n_bandit,n_action) + ( 1/(obj.number_of_update(n_bandit,n_action) + 1) )*(reward - obj.action_value(n_bandit,n_action));
         obj.reward_matrix(n_bandit,n_action) = obj.reward_matrix(n_bandit,n_action) + reward;
         obj.number_of_update(n_bandit,n_action)=obj.number_of_update(n_bandit,n_action) + 1; 
         obj.action_value(n_bandit,n_action) = obj.reward_matrix(n_bandit,n_action)/obj.number_of_update(n_bandit,n_action);
      end
      
      function [n]=ActionSelection(obj,cur_bandit)
         
         r = rand();

         if(r<=obj.eps)
            n = randi(obj.arm_stc_vec{cur_bandit}.n);
            flag_max = 0;
         else
            [~,n] = max(obj.action_value(cur_bandit,:));
            flag_max = 1;
         end  
      end
      
      function CleanPolicy(obj)
         for i=1:size(obj.arm_stc_vec,2)
            obj.action_value(i,:) = zeros(1,obj.arm_stc_vec{i}.n);
            obj.number_of_update(i,:) = zeros(1,obj.arm_stc_vec{i}.n);
            obj.reward_matrix(i,:) =  zeros(1,obj.arm_stc_vec{i}.n);
         end
      end
      
   end
   
end