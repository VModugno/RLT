classdef SoftMax < handle
   
   properties
      arm_stc_vec      % vector of arm_stc
      action_value     % vector of the current value associated to the i-th action
      reward_matrix    % matrix with the sum of reward for each action
      number_of_update % define the number of time that i selected a lever 
      tau              % "temperature" of the boltzman 
   end
   
   
   methods
      function obj = SoftMax(arm_stc,start_action_value,tau)
      
         obj.arm_stc_vec = arm_stc;
         obj.tau = tau;
         
         %obj.number_of_update = zeros(size(obj.arm_stc_vec,2),1);
         for i=1:size(obj.arm_stc_vec,2)
            obj.number_of_update(i,:) = zeros(1,obj.arm_stc_vec{i}.n);
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
         
         action_probability =  exp(obj.action_value(cur_bandit,:)./obj.tau);
         action_probability =  action_probability/sum(action_probability,2);
         n = SampleDiscrete(action_probability, 1, 1);
         
      end
      
      function CleanPolicy(obj)
         for i=1:size(obj.arm_stc_vec,2)
            obj.action_value(i,:) = zeros(1,obj.arm_stc_vec{i}.n);
            obj.number_of_update(i,:) = zeros(1,obj.arm_stc_vec{i}.n);
         end
      end
      
   end
   
end