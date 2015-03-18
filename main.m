clear variables
close all
clc


%rng('shuffle')


arm_stc1.n = 10;
arm_stc1.mean = [1.5 1.2 1.55 0.8 .85 0.9 1.05 1.1 1.25 1.3];
arm_stc1.var  = [1   1   1    1   1   1   1    1   1    1];
average_range = [0,10];
variance_range = [0,5];


arm_stc_vec{1} = arm_stc1; 
start_action_value = zeros(1,arm_stc1.n);
eps = 0.1;

trials = 1000;
plays  = 1000;


bandit = Bandit(arm_stc1,average_range,variance_range);
policy = RL.EpsGreedy(arm_stc_vec,start_action_value,eps);


all_reward =zeros(trials,plays);
cur_reward = zeros(1,plays);

for i =1:trials
%    up = 0;
   for j = 1:plays

      [act,flag_max] = policy.ActionSelection(1);
      reward = bandit.PullLever(act);
      policy.UpdatePolicy(1,act,reward);

      % in this way i take into account only the exploitation reward and 
      % and i dont register the exploration reward
%      if(flag_max)
         cur_reward(j) = policy.action_value(1,act);
%         up = up + 1;
%      end

   end
   policy.CleanPolicy();
   all_reward(i,:) = cur_reward;
end


   avg_reward_per_play = sum(all_reward)/trials;

