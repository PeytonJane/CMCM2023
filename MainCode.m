V = 20; % number of vines per square
num_squares = 100; % number of squares
N0 = 21000; % initial number of nymphs
new_SLF = 120; % expected number of adults entering the farm daily
time1 = 122; % period when there are no adults (April 1 - July 31)
time2 = 31; % adults appear, no harvesting yet (August 1- August 31)
time3 = 62; % adults present, harvesting period (September 1 - October 31)
time = time1+time2+time3; % overall number of days in the simulation
max_income = 150; % maximal income from the harvest from 1 square
vine_loss = 320; % income loss from 1 square of vines dying
max_vine_damage = 120000; % bulk num of insects that kills a vine with probability 1
min_vine_damage = 36000; % minimal bulk num of insects that influences vine health
max_grape_damage = 117000; % bulk num of insects that destroys harvest
min_grape_damage = 31200; % minimal bulk num that influences grape quality
ripe_peak = 7; % period after ripening when the grape has its maximum cost
ripe_decrease = 14; % period after ripening peak when the cost decreases to 0
effective_period_arr = [30, 540, 54]; % number of days insecticide is effective after application
half_life_arr = [5, 90, 9]; % half-life period of insecticide
max_effectiveness_arr = [0.95, 0.95, 0.95]; % maximal effectiveness of insecticide
max_application_arr = [6, 2, 6]; % maximal seasonal dose
application_cost_arr = [8.88, 8.89, 8.83]; % cost of 1 application to 1 square
phi_arr = [1, 30, 3]; % number of days after application that farmer should wait before harvesting
k = N0*3/4*1/25*1/50;
fun = @(x, y) k.*( (x-5).^2 + (y-5).^2 );

income_array = zeros(1, length(effective_period_arr)*25*15);
eco_damage_array = zeros(1, length(effective_period_arr)*25*15);
for insecticide = 1:length(effective_period_arr)
    for spring_threshold=1:25
      for fall_threshold=1:15
          s_threshold = 20*spring_threshold;
          f_threshold = 20*fall_threshold;
          effective_period = effective_period_arr(1, insecticide);
          half_life = half_life_arr(1, insecticide);
          max_effectiveness = max_effectiveness_arr(1, insecticide);
          max_application = max_application_arr(1, insecticide);
          application_cost = application_cost_arr(1, insecticide);
          phi = phi_arr(1, insecticide);
          num_sprays = 0;

          total_income = 0;
          I = zeros(num_squares, time); % numbers of insects in each square each day
          ins_status = zeros(num_squares, time); % displays the effectiveness of insecticide in each square on each day
          applic_num = zeros(1, num_squares); % tracks number of insecticide applications so far
          harvest_eligibility = true(num_squares, time); % tells weather grape can be harvested
          harvest_time = round(rand(1, num_squares)*time3); % the day of harvest period at which each square ripens
          harvest_delay = zeros(1, num_squares); % counter of number of days a harvest of each square is delayed
          harvested = false(1, num_squares); % keep track of squares that have been harvested
          insects_bulk = zeros(1, num_squares); % overall number of insects that have been in each square
        
          N11_0 = integral2(fun, 0, 1, 0, 1);
          N12_0 = integral2(fun, 0, 1, 1, 2);
          N13_0 = integral2(fun, 0, 1, 2, 3);
          N14_0 = integral2(fun, 0, 1, 3, 4);
          N15_0 = integral2(fun, 0, 1, 4, 5);
          N22_0 = integral2(fun, 1, 2, 1, 2);
          N23_0 = integral2(fun, 1, 2, 2, 3);
          N24_0 = integral2(fun, 1, 2, 3, 4);
          N25_0 = integral2(fun, 1, 2, 4, 5);
          N33_0 = integral2(fun, 2, 3, 2, 3);
          N34_0 = integral2(fun, 2, 3, 3, 4);
          N35_0 = integral2(fun, 2, 3, 4, 5);
          N44_0 = integral2(fun, 3, 4, 3, 4);
          N45_0 = integral2(fun, 3, 4, 4, 5);
          N55_0 = integral2(fun, 4, 5, 4, 5);
          Nc1 = [N11_0 N12_0 N13_0 N14_0 N15_0 N15_0 N14_0 N13_0 N12_0 N11_0];
          Nc2 = [N12_0 N22_0 N23_0 N24_0 N25_0 N25_0 N24_0 N23_0 N22_0 N12_0];
          Nc3 = [N13_0 N23_0 N33_0 N34_0 N35_0 N35_0 N34_0 N33_0 N23_0 N13_0];
          Nc4 = [N14_0 N24_0 N34_0 N44_0 N45_0 N45_0 N44_0 N34_0 N24_0 N14_0];
          Nc5 = [N15_0 N25_0 N35_0 N45_0 N55_0 N55_0 N45_0 N35_0 N25_0 N15_0];
          Nc6 = Nc5;
          Nc7 = Nc4;
          Nc8 = Nc3;
          Nc9 = Nc2;
          Nc10 = Nc1;
          Nctot = [Nc1 Nc2 Nc3 Nc4 Nc5 Nc6 Nc7 Nc8 Nc9 Nc10];
          I(:, 1) = Nctot;
          N11 = zeros(1, time);
          N12 = zeros(1, time);
          N13 = zeros(1, time);
          N14 = zeros(1, time);
          N15 = zeros(1, time);
      
          N22 = zeros(1, time);
          N23 = zeros(1, time);
          N24 = zeros(1, time);
          N25 = zeros(1, time);
           N33 = zeros(1, time);
          N34 = zeros(1, time);
          N35 = zeros(1, time);
     
          N44 = zeros(1, time);
          N45 = zeros(1, time);
     
          N55 = zeros(1, time);     
     
          N11(1) = N11_0;
          N12(1) = N12_0;
          N13(1) = N13_0;
          N14(1) = N14_0;
          N15(1) = N15_0;
      
          N22(1) = N22_0;
          N23(1) = N23_0;
          N24(1) = N24_0;
          N25(1) = N25_0;
      
          N33(1) = N33_0;
          N34(1) = N34_0;
          N35(1) = N35_0;
      
          N44(1) = N44_0;
          N45(1) = N45_0;
      
          N55(1) = N55_0;
     
          q = 0.01;
       
        
      
          for day = 1:time1
              % spraying
              [newI, new_ins_status, new_aplic_num, new_harvest_eligibility, new_total_income, new_num_sprays] = spray(I, day, s_threshold, ins_status, applic_num, harvest_eligibility, effective_period, phi, max_application, application_cost, total_income, half_life, max_effectiveness, num_sprays);
              I = newI;
              ins_status = new_ins_status;
              applic_num = new_aplic_num;
              harvest_eligibility = new_harvest_eligibility;
              total_income = new_total_income;
              num_sprays = new_num_sprays;
    
              N11(day+1) = N11(day)*(1-q) + q/3*(N12(day)*2);
              N12(day+1) = N12(day)*(1-q) + q/3*N13(day) + q/4*N22(day) + q/2*(N11(day));
              N13(day+1) = N13(day)*(1-q) + q/3*(N14(day)+N12(day)) + q/4*N23(day);
              N14(day+1) = N14(day)*(1-q) + q/3*(N13(day) + N15(day)) + q/4*N24(day);
              N15(day+1) = N15(day)*(1-q) + q/3*(N14(day) + N15(day)) + q/4*N25(day);
               N22(day+1) = N22(day)*(1-q) + q/3*(N12(day)*2) + q/4*(N23(day)*2);
               N23(day+1) = N23(day)*(1-q) + q/3*(N13(day)) + q/4*(N22(day) + N24(day) + N33(day));
              N24(day+1) = N24(day)*(1-q) + q/3*(N14(day)) + q/4*(N23(day) + N25(day) + N34(day));
              N25(day+1) = N25(day)*(1-q) + q/3*(N15(day)) + q/4*(N24(day) + N25(day) + N35(day));
               N33(day+1) = N33(day)*(1-q) + q/4*(2*N23(day) + 2*N34(day));
              N34(day+1) = N34(day)*(1-q) + q/4*(N33(day) + N35(day) + N24(day) + N44(day));
              N35(day+1) = N35(day)*(1-q) + q/4*(N34(day) + N35(day) + N25(day) + N45(day));
               N44(day+1) = N44(day)*(1-q) + q/4*(N34(day)*2+N45(day)*2);
              N45(day+1) = N45(day)*(1-q) + q/4*(N44(day) + N45(day) + N35(day) + N55(day));
               N55(day+1) = N55(day)*(1-q) + q/4*(N45(day)*2+N55(day)*2);     
              
              % Update according to spraying status
              for j = 1:100              
                I(j, day+1) = I(j, day)*(1-ins_status(j, day+1));
                if j == 1
                N11(day+1) = N11(day)*(1-ins_status(j, day+1));
                end
                if j == 2
                N12(day+1) = N12(day)*(1-ins_status(j, day+1));
                end
                if j == 3
                N13(day+1) = N13(day)*(1-ins_status(j, day+1));
                end
                if j == 4
                N14(day+1) = N14(day)*(1-ins_status(j, day+1));
                end
                if j == 5
                N15(day+1) = N15(day)*(1-ins_status(j, day+1));
                end
                if j == 12
                N22(day+1) = N22(day)*(1-ins_status(j, day+1));
                end
                if j == 13
                N23(day+1) = N23(day)*(1-ins_status(j, day+1));
                end
                if j == 14
                N24(day+1) = N24(day)*(1-ins_status(j, day+1));
                end
                if j == 15
                N25(day+1) = N25(day)*(1-ins_status(j, day+1));
                end
                if j == 23
                N33(day+1) = N33(day)*(1-ins_status(j, day+1));
                end
                if j == 24
                N34(day+1) = N34(day)*(1-ins_status(j, day+1));
                end
                if j == 25
                N35(day+1) = N35(day)*(1-ins_status(j, day+1));
                end
                if j == 34
                N44(day+1) = N44(day)*(1-ins_status(j, day+1));
                end
                if j == 35
                N45(day+1) = N45(day)*(1-ins_status(j, day+1));
                end
                if j == 45
                N55(day+1) = N55(day)*(1-ins_status(j, day+1));
                end               
              end
            Nc1 = [N11(day+1) N12(day+1) N13(day+1) N14(day+1) N15(day+1) N15(day+1) N14(day+1) N13(day+1) N12(day+1) N11(day+1)];
            Nc2 = [N12(day+1) N22(day+1) N23(day+1) N24(day+1) N25(day+1) N25(day+1) N24(day+1) N23(day+1) N22(day+1) N12(day+1)];
            Nc3 = [N13(day+1) N23(day+1) N33(day+1) N34(day+1) N35(day+1) N35(day+1) N34(day+1) N33(day+1) N23(day+1) N13(day+1)];
            Nc4 = [N14(day+1) N24(day+1) N34(day+1) N44(day+1) N45(day+1) N45(day+1) N44(day+1) N34(day+1) N24(day+1) N14(day+1)];
            Nc5 = [N15(day+1) N25(day+1) N35(day+1) N45(day+1) N55(day+1) N55(day+1) N45(day+1) N35(day+1) N25(day+1) N15(day+1)];
            Nc6 = Nc5; Nc7 = Nc4; Nc8 = Nc3; Nc9 = Nc2; Nc10 = Nc1;
     
            Nctot = [Nc1 Nc2 Nc3 Nc4 Nc5 Nc6 Nc7 Nc8 Nc9 Nc10];
            I(:, day+1) = Nctot;
          end
      for day = (time1):(time1+time2)
          % spray
          [newI, new_ins_status, new_aplic_num, new_harvest_eligibility, new_total_income, new_num_sprays] = spray(I, day, f_threshold, ins_status, applic_num, harvest_eligibility, effective_period, phi, max_application, application_cost, total_income, half_life, max_effectiveness, num_sprays);
          I = newI;
          ins_status = new_ins_status;
          applic_num = new_aplic_num;
          harvest_eligibility = new_harvest_eligibility;
          total_income = new_total_income;
          num_sprays = new_num_sprays;
          
         q = 0.05;
         N11(day+1) = N11(day)*(1-q) + q/3*(N12(day)*2) + new_SLF/36;
         N12(day+1) = N12(day)*(1-q) + q/3*N13(day) + q/4*N22(day) + q/2*(N11(day)) + new_SLF/36;
         N13(day+1) = N13(day)*(1-q) + q/3*(N14(day)+N12(day)) + q/4*N23(day) + new_SLF/36;
         N14(day+1) = N14(day)*(1-q) + q/3*(N13(day) + N15(day)) + q/4*N24(day) + new_SLF/36;
         N15(day+1) = N15(day)*(1-q) + q/3*(N14(day) + N15(day)) + q/4*N25(day) + new_SLF/36;
          N22(day+1) = N22(day)*(1-q) + q/3*(N12(day)*2) + q/4*(N23(day)*2);
         N23(day+1) = N23(day)*(1-q) + q/3*(N13(day)) + q/4*(N22(day) + N24(day) + N33(day));
         N24(day+1) = N24(day)*(1-q) + q/3*(N14(day)) + q/4*(N23(day) + N25(day) + N34(day));
         N25(day+1) = N25(day)*(1-q) + q/3*(N15(day)) + q/4*(N24(day) + N25(day) + N35(day));
          N33(day+1) = N33(day)*(1-q) + q/4*(2*N23(day) + 2*N34(day));
         N34(day+1) = N34(day)*(1-q) + q/4*(N33(day) + N35(day) + N24(day) + N44(day));
         N35(day+1) = N35(day)*(1-q) + q/4*(N34(day) + N35(day) + N25(day) + N45(day));
          N44(day+1) = N44(day)*(1-q) + q/4*(N34(day)*2+N45(day)*2);
         N45(day+1) = N45(day)*(1-q) + q/4*(N44(day) + N45(day) + N35(day) + N55(day));
          N55(day+1) = N55(day)*(1-q) + q/4*(N45(day)*2+N55(day)*2);
        
        % Update according to spraying status
              for j = 1:100              
                I(j, day+1) = I(j, day)*(1-ins_status(j, day+1));
                if j == 1
                N11(day+1) = N11(day)*(1-ins_status(j, day+1));
                end
                if j == 2
                N12(day+1) = N12(day)*(1-ins_status(j, day+1));
                end
                if j == 3
                N13(day+1) = N13(day)*(1-ins_status(j, day+1));
                end
                if j == 4
                N14(day+1) = N14(day)*(1-ins_status(j, day+1));
                end
                if j == 5
                N15(day+1) = N15(day)*(1-ins_status(j, day+1));
                end
                if j == 12
                N22(day+1) = N22(day)*(1-ins_status(j, day+1));
                end
                if j == 13
                N23(day+1) = N23(day)*(1-ins_status(j, day+1));
                end
                if j == 14
                N24(day+1) = N24(day)*(1-ins_status(j, day+1));
                end
                if j == 15
                N25(day+1) = N25(day)*(1-ins_status(j, day+1));
                end
                if j == 23
                N33(day+1) = N33(day)*(1-ins_status(j, day+1));
                end
                if j == 24
                N34(day+1) = N34(day)*(1-ins_status(j, day+1));
                end
                if j == 25
                N35(day+1) = N35(day)*(1-ins_status(j, day+1));
                end
                if j == 34
                N44(day+1) = N44(day)*(1-ins_status(j, day+1));
                end
                if j == 35
                N45(day+1) = N45(day)*(1-ins_status(j, day+1));
                end
                if j == 45
                N55(day+1) = N55(day)*(1-ins_status(j, day+1));
                end               
              end     
         
         
         Nc1 = [N11(day+1) N12(day+1) N13(day+1) N14(day+1) N15(day+1) N15(day+1) N14(day+1) N13(day+1) N12(day+1) N11(day+1)];
         Nc2 = [N12(day+1) N22(day+1) N23(day+1) N24(day+1) N25(day+1) N25(day+1) N24(day+1) N23(day+1) N22(day+1) N12(day+1)];
         Nc3 = [N13(day+1) N23(day+1) N33(day+1) N34(day+1) N35(day+1) N35(day+1) N34(day+1) N33(day+1) N23(day+1) N13(day+1)];
         Nc4 = [N14(day+1) N24(day+1) N34(day+1) N44(day+1) N45(day+1) N45(day+1) N44(day+1) N34(day+1) N24(day+1) N14(day+1)];
         Nc5 = [N15(day+1) N25(day+1) N35(day+1) N45(day+1) N55(day+1) N55(day+1) N45(day+1) N35(day+1) N25(day+1) N15(day+1)];
         Nc6 = Nc5; Nc7 = Nc4; Nc8 = Nc3; Nc9 = Nc2; Nc10 = Nc1;
         Nctot = [Nc1 Nc2 Nc3 Nc4 Nc5 Nc6 Nc7 Nc8 Nc9 Nc10];
         I(:, day+1) = Nctot;
      end
       for day = (time1+time2):(time-1)
          % update bulk
          for i = 1: num_squares
              insects_bulk(1, i) = sum(I(i, :));
          end
          % harvest grapes
          [new_income, new_harvested] = harvest(I, total_income, day-(time1+time2), insects_bulk, harvest_time, harvest_eligibility, harvest_delay, harvested, max_income, max_grape_damage, min_grape_damage, ripe_peak, ripe_decrease);
          total_income = new_income;
          harvested = new_harvested;   
          
          % spray
          [newI, new_ins_status, new_aplic_num, new_harvest_eligibility, new_total_income, new_num_sprays] = spray(I, day, f_threshold, ins_status, applic_num, harvest_eligibility, effective_period, phi, max_application, application_cost, total_income, half_life, max_effectiveness, num_sprays);
          I = newI;
          ins_status = new_ins_status;
          applic_num = new_aplic_num;
          harvest_eligibility = new_harvest_eligibility;
          total_income = new_total_income;
          num_sprays = new_num_sprays;
          
          q = 0.05;
          N11(day+1) = N11(day)*(1-q) + q/3*(N12(day)*2) + new_SLF/36;
          N12(day+1) = N12(day)*(1-q) + q/3*N13(day) + q/4*N22(day) + q/2*(N11(day)) + new_SLF/36;
          N13(day+1) = N13(day)*(1-q) + q/3*(N14(day)+N12(day)) + q/4*N23(day) + new_SLF/36;
          N14(day+1) = N14(day)*(1-q) + q/3*(N13(day) + N15(day)) + q/4*N24(day) + new_SLF/36;
          N15(day+1) = N15(day)*(1-q) + q/3*(N14(day) + N15(day)) + q/4*N25(day) + new_SLF/36;
          N22(day+1) = N22(day)*(1-q) + q/3*(N12(day)*2) + q/4*(N23(day)*2);
          N23(day+1) = N23(day)*(1-q) + q/3*(N13(day)) + q/4*(N22(day) + N24(day) + N33(day));
          N24(day+1) = N24(day)*(1-q) + q/3*(N14(day)) + q/4*(N23(day) + N25(day) + N34(day));
          N25(day+1) = N25(day)*(1-q) + q/3*(N15(day)) + q/4*(N24(day) + N25(day) + N35(day));
          N33(day+1) = N33(day)*(1-q) + q/4*(2*N23(day) + 2*N34(day));
          N34(day+1) = N34(day)*(1-q) + q/4*(N33(day) + N35(day) + N24(day) + N44(day));
          N35(day+1) = N35(day)*(1-q) + q/4*(N34(day) + N35(day) + N25(day) + N45(day));
          N44(day+1) = N44(day)*(1-q) + q/4*(N34(day)*2+N45(day)*2);
          N45(day+1) = N45(day)*(1-q) + q/4*(N44(day) + N45(day) + N35(day) + N55(day));
          N55(day+1) = N55(day)*(1-q) + q/4*(N45(day)*2+N55(day)*2);
         
          % Update according to spraying status
              for j = 1:100              
                I(j, day+1) = I(j, day)*(1-ins_status(j, day+1));
                if j == 1
                N11(day+1) = N11(day)*(1-ins_status(j, day+1));
                end
                if j == 2
                N12(day+1) = N12(day)*(1-ins_status(j, day+1));
                end
                if j == 3
                N13(day+1) = N13(day)*(1-ins_status(j, day+1));
                end
                if j == 4
                N14(day+1) = N14(day)*(1-ins_status(j, day+1));
                end
                if j == 5
                N15(day+1) = N15(day)*(1-ins_status(j, day+1));
                end
                if j == 12
                N22(day+1) = N22(day)*(1-ins_status(j, day+1));
                end
                if j == 13
                N23(day+1) = N23(day)*(1-ins_status(j, day+1));
                end
                if j == 14
                N24(day+1) = N24(day)*(1-ins_status(j, day+1));
                end
                if j == 15
                N25(day+1) = N25(day)*(1-ins_status(j, day+1));
                end
                if j == 23
                N33(day+1) = N33(day)*(1-ins_status(j, day+1));
                end
                if j == 24
                N34(day+1) = N34(day)*(1-ins_status(j, day+1));
                end
                if j == 25
                N35(day+1) = N35(day)*(1-ins_status(j, day+1));
                end
                if j == 34
                N44(day+1) = N44(day)*(1-ins_status(j, day+1));
                end
                if j == 35
                N45(day+1) = N45(day)*(1-ins_status(j, day+1));
                end
                if j == 45
                N55(day+1) = N55(day)*(1-ins_status(j, day+1));
                end               
              end 
         
         
          Nc1 = [N11(day+1) N12(day+1) N13(day+1) N14(day+1) N15(day+1) N15(day+1) N14(day+1) N13(day+1) N12(day+1) N11(day+1)];
          Nc2 = [N12(day+1) N22(day+1) N23(day+1) N24(day+1) N25(day+1) N25(day+1) N24(day+1) N23(day+1) N22(day+1) N12(day+1)];
          Nc3 = [N13(day+1) N23(day+1) N33(day+1) N34(day+1) N35(day+1) N35(day+1) N34(day+1) N33(day+1) N23(day+1) N13(day+1)];
          Nc4 = [N14(day+1) N24(day+1) N34(day+1) N44(day+1) N45(day+1) N45(day+1) N44(day+1) N34(day+1) N24(day+1) N14(day+1)];
          Nc5 = [N15(day+1) N25(day+1) N35(day+1) N45(day+1) N55(day+1) N55(day+1) N45(day+1) N35(day+1) N25(day+1) N15(day+1)];
          Nc6 = Nc5; Nc7 = Nc4; Nc8 = Nc3; Nc9 = Nc2; Nc10 = Nc1;
          Nctot = [Nc1 Nc2 Nc3 Nc4 Nc5 Nc6 Nc7 Nc8 Nc9 Nc10];
          I(:, day+1) = Nctot; 
       end
      
           % update income according to losses of vines
          for square=1:num_squares
              death_prob = death_probability(insects_bulk(1, square), max_vine_damage, min_vine_damage);
              total_income = total_income - vine_loss*death_prob;
          end
          % record total income for this combination of parameters
          index = 25*15*(insecticide-1)+15*(spring_threshold-1)+fall_threshold;
          income_array(1, index) = total_income;
          eco_damage_array(1, index) = num_sprays;
      end
    end
end

% find optimal parameters
objective = 0.2*income_array - 0.8*eco_damage_array;
max_obj = max(objective);
i = find(objective ==max_obj);
index = i(1, length(i));
ins_maximizer = min(floor(index/25/15)+1, 3)
r = index-(ins_maximizer-1)*25*15;
st_maximizer = min(floor(r/15)+1, 25)
ft_maximizer = index -(ins_maximizer-1)*25*15 - (st_maximizer-1)*15

function gc = grapes_cost(t, d, max_grape_damage, min_grape_damage, max_income, ripe_peak, ripe_decrease)
  if(d<=min_grape_damage)
      gc = max_income;
  elseif (d>=max_grape_damage)
          gc = 0;
  else
      gc = max_income*(1 - (d-min_grape_damage)/(max_grape_damage-min_grape_damage));
  end
  if (gc>0)
      if(t>=ripe_peak+ripe_decrease)
      gc = 0;
      elseif (t>ripe_peak)
      gc = gc*(1-(t-ripe_peak)/ripe_decrease);
      end
  end
end
function dp = death_probability(d, max_vine_damage, min_vine_damage)
  if (d<=min_vine_damage)
      dp = 0;
  elseif(d>=max_vine_damage)
      dp = 1;
  else
      dp = (d-min_vine_damage)/(max_vine_damage-min_vine_damage);
  end
end
function [I, ins_status, aplic_num, harvest_eligibility, total_income, num_sprays]=spray(I, day, threshold, ins_status, aplic_num, harvest_eligibility, effective_period, phi, max_application, application_cost, total_income, half_life, max_effectiveness, num_sprays)
  [num_sq, num_days] = size(I);
  for square = 1:num_sq
      if (I(square, day)>=threshold && aplic_num(1, square)<max_application)
          I(square, day) = (1-max_effectiveness)*I(square, day);
          aplic_num(1, square) = aplic_num(1, square)+1;
          num_sprays = num_sprays+1;
          for i = 1:half_life:effective_period
              effectiveness = max_effectiveness/(2^((i-1)/7));
              for d = day+i-1:min(day+i+half_life-2, num_days)
                  ins_status(square, d) = effectiveness;
              end
          end
           
          harvest_eligibility(square, (day:min(day+phi-1, num_days))) = false(1, min(phi, num_days - day+1));
          total_income=total_income - application_cost;
      end
  end  
end
function [total_income, harvested]=harvest(I, total_income, day, insects_bulk, harvest_time, harvest_eligibility, harvest_delay, harvested, max_income, max_grape_damage, min_grape_damage, ripe_peak, ripe_decrease)
  [num_sq, num_days] = size(I);
  for square = 1:num_sq
      if(day>=harvest_time(1, square) && ~harvested(1, square))
          if(harvest_eligibility(1, square) == false)
              harvest_delay(1, square)= harvest_delay(1, square)+1;
          else
              income = grapes_cost(harvest_delay(1, square), insects_bulk(1, square), max_grape_damage, min_grape_damage, max_income, ripe_peak, ripe_decrease);
              total_income = total_income+income;
              harvested(1, square) = true;
          end
      end
  end
end
