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

[imp_data] = analyzeAllImpedance(folder_path);

%% SEPARATE DATA

% get list of array types
arrays = {imp_data.array};

% sort out different arrays
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
plot(u1_broke.Time, u1_broke.Var1,'-o');
plot(u2_broke.Time, u2_broke.Var1,'-o');
plot(u3_broke.Time, u3_broke.Var1,'-o');
ylabel('Broken Electrodes');
xlabel('Date');
legend('USEA1','USEA2','USEA3');


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
plot(u1_imp.Time, u1_imp.Var1,'-o');
plot(u2_imp.Time, u2_imp.Var1,'-o');
plot(u3_imp.Time, u3_imp.Var1,'-o');
ylabel('Impedance (k\Omega)');
xlabel('Date');
legend('USEA1','USEA2','USEA3');


% save plot if given a save path
if save_path ~= ""
    fname = [char(save_path) '\impElects.svg'];
    saveas(gcf, fname, 'svg');
    fname = [char(save_path) '\impElects.png'];
    saveas(gcf, fname, 'png');
end

end % visualizeTimeSeriesImp