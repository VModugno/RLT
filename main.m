clear variable
close all
clc


arm_stc.n = 5;
arm_stc.mean = [3 5 1 4 7];
arm_stc.var  = [4 1 3 5 2];
average_range = [0,10];
variance_range = [0,5];

bandit = Bandit(arm_stc,average_range,variance_range);