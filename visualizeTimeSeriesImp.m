function visualizeTimeSeriesImp(folder_path, save_path)
%VISUALIZETIMESERIESIMP Runs the impedance analysis on data in folder path
%and plots the impedance data over time. Saves the plots in the save_path
%directory if provided.

%% DEFINE INPUTS
arguments (Input)
    folder_path char % mandatory inpute
    save_path string = "" % default to no path
end

%% RUN ANALYSIS

% pre implant data
pre_imp_data = getBlackrockImp(preImplantImpPath());

% post implant data
[imp_data] = analyzeImpedance(folder_path);

%% SEPARATE DATA

% get list of array types pre implant
arrays_pi = {pre_imp_data.array};

% sort out different arrays for pre implant data
u1_pi = pre_imp_data(contains(arrays_pi, 'USEA1'));
u2_pi = pre_imp_data(contains(arrays_pi, 'USEA2'));
u3_pi = pre_imp_data(contains(arrays_pi, 'USEA3'));

% get list of array types
arrays = {imp_data.array};

% sort out different arrays post implant
u1 = imp_data(contains(arrays, 'USEA1'));
u2 = imp_data(contains(arrays, 'USEA2'));
u3 = imp_data(contains(arrays, 'USEA3'));

%% VISUALIZE BROKEN ELECTRODES

% get in data and put into timetable formate (disregard disconnects)
u1_broke = timetable([u1(~isnan([u1.impedance_mean])).date]',[u1(~isnan([u1.impedance_mean])).broken]');
u2_broke = timetable([u2(~isnan([u2.impedance_mean])).date]',[u2(~isnan([u2.impedance_mean])).broken]');
u3_broke = timetable([u3(~isnan([u3.impedance_mean])).date]',[u3(~isnan([u3.impedance_mean])).broken]');

% generate figure
figure()
hold on;
% pre implant
scatter(datetime('20260129','InputFormat','uuuuMMdd'),u1_pi.broken,'red');
scatter(datetime('20260129','InputFormat','uuuuMMdd'),u2_pi.broken,'green');
scatter(datetime('20260129','InputFormat','uuuuMMdd'),u3_pi.broken,'blue');

% post implant
plot(u1_broke.Time, u1_broke.Var1,'r-o');
plot(u2_broke.Time, u2_broke.Var1,'g-o');
plot(u3_broke.Time, u3_broke.Var1,'b-o');
ylabel('Broken Electrodes');
xlabel('Date');
xlim([datetime('20260125','InputFormat','uuuuMMdd') datetime('20260907','InputFormat','uuuuMMdd')])
legend('USEA1','USEA2','USEA3');
hold off

% save plot if given a save path
if save_path ~= ""
    fname = [char(save_path) '\brokenElects.svg'];
    saveas(gcf, fname, 'svg');
    fname = [char(save_path) '\brokenElects.png'];
    saveas(gcf, fname, 'png');
end

%% VISUALIZE IMPEDANCE

% get in data and put into timetable formate (disregard bad connections)
u1_imp = timetable([u1(~isnan([u1.impedance_mean])).date]',[u1(~isnan([u1.impedance_mean])).impedance_mean]');
u2_imp = timetable([u2(~isnan([u2.impedance_mean])).date]',[u2(~isnan([u2.impedance_mean])).impedance_mean]');
u3_imp = timetable([u3(~isnan([u3.impedance_mean])).date]',[u3(~isnan([u3.impedance_mean])).impedance_mean]');

% generate figure
figure()
hold on;
% pre implant
scatter(datetime('20260129','InputFormat','uuuuMMdd'),u1_pi.impedance_mean,'red');
scatter(datetime('20260129','InputFormat','uuuuMMdd'),u2_pi.impedance_mean,'green');
scatter(datetime('20260129','InputFormat','uuuuMMdd'),u3_pi.impedance_mean,'blue');

% post implant
plot(u1_imp.Time, u1_imp.Var1,'r-o');
plot(u2_imp.Time, u2_imp.Var1,'g-o');
plot(u3_imp.Time, u3_imp.Var1,'b-o');
ylabel('Impedance (k\Omega)');
xlabel('Date');
xlim([datetime('20260125','InputFormat','uuuuMMdd') datetime('20260907','InputFormat','uuuuMMdd')])
legend('USEA1','USEA2','USEA3');
hold off

% save plot if given a save path
if save_path ~= ""
    fname = [char(save_path) '\impElects.svg'];
    saveas(gcf, fname, 'svg');
    fname = [char(save_path) '\impElects.png'];
    saveas(gcf, fname, 'png');
end

end % visualizeTimeSeriesImp