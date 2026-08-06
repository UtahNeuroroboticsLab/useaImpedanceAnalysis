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

% get in data and put into timetable formate
u1_broke = timetable([u1.date]',[u1.broken]');
u2_broke = timetable([u2.date]',[u2.broken]');
u3_broke = timetable([u3.date]',[u3.broken]');

% generate figure
figure()
hold on;
% pre implant
scatter(datetime('20260129','InputFormat','uuuuMMdd'),u1_pi.broken);
scatter(datetime('20260129','InputFormat','uuuuMMdd'),u2_pi.broken);
scatter(datetime('20260129','InputFormat','uuuuMMdd'),u3_pi.broken);

% post implant
plot(u1_broke.Time, u1_broke.Var1,'-o');
plot(u2_broke.Time, u2_broke.Var1,'-o');
plot(u3_broke.Time, u3_broke.Var1,'-o');
ylabel('Broken Electrodes');
xlabel('Date');
xlim([datetime('20260125','InputFormat','uuuuMMdd') datetime('20260501','InputFormat','uuuuMMdd')])
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

% get in data and put into timetable formate
u1_imp = timetable([u1.date]',[u1.impedance_mean]');
u2_imp = timetable([u2.date]',[u2.impedance_mean]');
u3_imp = timetable([u3.date]',[u3.impedance_mean]');

% generate figure
figure()
hold on;
% pre implant
scatter(datetime('20260129','InputFormat','uuuuMMdd'),u1_pi.impedance_mean);
scatter(datetime('20260129','InputFormat','uuuuMMdd'),u2_pi.impedance_mean);
scatter(datetime('20260129','InputFormat','uuuuMMdd'),u3_pi.impedance_mean);

% post implant
plot(u1_imp.Time, u1_imp.Var1,'-o');
plot(u2_imp.Time, u2_imp.Var1,'-o');
plot(u3_imp.Time, u3_imp.Var1,'-o');
ylabel('Impedance (k\Omega)');
xlabel('Date');
xlim([datetime('20260125','InputFormat','uuuuMMdd') datetime('20260501','InputFormat','uuuuMMdd')])
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