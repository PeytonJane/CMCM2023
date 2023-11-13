%Gather statistics
tic
trials = 50;
lst1 = [];
lst2 = [];
lst3 = [];
for k = 1:trials
   run("Version3.m");
   lst1 = [lst1, ins_maximizer];
   lst2 = [lst2, st_maximizer];
   lst3 = [lst3, ft_maximizer];   
end
lst1
lst2
lst3
mean_ins_maximizer = mean(lst1)
standard_deviation_ins_maximizer = std(lst1)

mean_st_maximizer = mean(lst2)
standard_deviation_st_maximizer = std(lst2)

mean_ft_maximizer = mean(lst3)
standard_deviation_ft_maximizer = std(lst3)

bar(lst3)
toc

