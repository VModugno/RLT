clear variables
close all
clc


%rng('shuffle')


arm_stc1.n = 10;
arm_stc1.mean = [];
arm_stc1.var  = [];
average_range = [0,10];
variance_range = [0,5];
update_distribution = 'Normal';
lever_distribution  = 'Normal';


arm_stc_vec{1} = arm_stc1; 
start_action_value = zeros(1,arm_stc1.n);
% epsilon greedy
eps = 0.1;
% soft max
tau = 0.01;

% simulation value
trials = 1000;
plays  = 1000;
update = 'no';

% object
bandit = Bandit(arm_stc1,average_range,variance_range,update_distribution,lever_distribution);
% policy search method
policy1 = RL.EpsGreedy(arm_stc_vec,start_action_value,eps);
policy2 = RL.SoftMax(arm_stc_vec,start_action_value,tau);
% policy selected
policy{1} = policy1;
%policy{2} = policy2;


all_reward =zeros(trials,plays);
cur_reward = zeros(1,plays);

for i =1:trials
   i % current trial
   for j = 1:plays
      
      reward = bandit.PullAllLever();
      
      for k = 1:size(policy,2)
         act = policy{k}.ActionSelection(1);
         policy{k}.UpdatePolicy(1,act,reward(1,act));
         cur_reward(k,j) = policy{k}.action_value(1,act);
      end
      
   end
   
   for kk = 1:size(policy,2)
      policy{kk}.CleanPolicy();
       all_reward(i,:,k) = cur_reward(k,:);
   end
   
   if(strcmp(update,'yes'))
      bandit.UpdateLever();
   end
   
  
end

% compute the mean value for each play on every trial
for kk = 1:size(policy,2)
   avg_reward_per_play(:,kk) = mean(all_reward(:,:,k),1)';
end


% plot result for each policy
plot(avg_reward_per_play);


