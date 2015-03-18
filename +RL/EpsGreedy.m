

classdef EpsGreedy < handle
   
   properties
      arm_stc_vec      % vector of arm_stc
      action_value     % vector of the current value associated to the i-th action
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
            for j = 1:obj.arm_stc_vec{i}.n
               obj.action_value(i,j) = start_action_value(i,j);
            end
         end
         
      end
      
      function UpdatePolicy(obj,n_bandit,n_action,reward)
         obj.action_value(n_bandit,n_action) = obj.action_value(n_bandit,n_action) + ( 1/(obj.number_of_update(n_bandit,n_action) + 1) )*(reward - obj.action_value(n_bandit,n_action));
         obj.number_of_update(n_bandit,n_action)=obj.number_of_update(n_bandit,n_action) + 1; 
      end
      
      function [n,flag_max]=ActionSelection(obj,cur_bandit)
         
         r = rand();
         
         if(r<obj.eps)
            n = randi(obj.arm_stc_vec{cur_bandit}.n);
            flag_max = 0;
         else
            [~,n] = max(obj.action_value(cur_bandit,:));
            %[~,n] = ind2sub(size(obj.action_value(cur_bandit,:)),ind)
            flag_max = 1;
         end
         
      end
      
      function CleanPolicy(obj)
         for i=1:size(obj.arm_stc_vec,2)
            obj.action_value(i,:) = zeros(1,obj.arm_stc_vec{i}.n);
            obj.number_of_update(i,:) = zeros(1,obj.arm_stc_vec{i}.n);
         end
      end
      
   end
   
end