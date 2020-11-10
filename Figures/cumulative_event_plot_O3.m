%% script to plot cumulative number of events vs days in O1, O2, O3 (not including breaks)
clear all
%%
gw_event = [20150914,20151012,20151226,...
    20170104,20170608,20170729,20170809,20170814,20170817,20170818,20170823,...
    20190408,20190412,20190413,20190413,20190421,20190424,20190425,20190426,...
    20190503,20190512,20190513,20190514,20190517,20190519,20190521,20190521,...
    20190527,20190602,20190620,20190630,20190701,20190706,20190707,20190708,...
    20190719,20190720,20190727,20190728,20190731,20190803,20190814,20190828,...
    20190828,20190909,20190910,20190915,20190924,20190929,20190930,...
    20191105,20191109,20191129,20191204,20191205,20191213,20191215,...
    20191216,20191222,20200105,20200112,20200114,20200115,20200128,20200129,...
    20200208,20200213,20200219,20200224,20200225,20200302,20200311,20200316];

datetime_event = datetime(gw_event,'ConvertFrom','yyyymmdd');
num_event = length(datetime_event);
%%

O1_start  = datetime(2015,09,12);
O1_end    = datetime(2016,01,19);
len_O1    = caldays(between(O1_start,O1_end,'days'));

O2_start  = datetime(2016,11,30);
O2_end    = datetime(2017,08,25);
len_O2    = caldays(between(O2_start,O2_end,'days'));

O3a_start = datetime(2019,04,01);
O3a_end   = datetime(2019,09,30);
len_O3a   = caldays(between(O3a_start,O3a_end,'days'));


O3b_start = datetime(2019,11,01);
O3b_end   = datetime(2020,04,30);
len_O3b   = caldays(between(O3b_start,O3b_end,'days'));

total_days = len_O1 + len_O2 + len_O3a + len_O3b;
O1  = len_O1;
O2  = len_O1 + len_O2;
O3a = len_O1 + len_O2 + len_O3a;
O3b = len_O1 + len_O2 + len_O3a + len_O3b;

nev_O1 = 3;
nev_O2 = 8;
nev_O3a = 39;
nev_O3b = num_event - nev_O1 - nev_O2 - nev_O3a;

%%
for i = 1:num_event
    if (datetime_event(i)>=O1_start && datetime_event(i)<=O1_end)
        event_days(i) = caldays(between(O1_start,datetime_event(i),'days'));
    elseif (datetime_event(i)>=O2_start && datetime_event(i)<=O2_end)
        event_days(i) = caldays(between(O2_start,datetime_event(i),'days'));
        event_days(i) = event_days(i) + len_O1;
    elseif (datetime_event(i)>=O3a_start && datetime_event(i)<=O3a_end)
        event_days(i) = caldays(between(O3a_start,datetime_event(i),'days'));
        event_days(i) = event_days(i) + len_O1 + len_O2;
    elseif (datetime_event(i)>=O3b_start && datetime_event(i)<=O3b_end)
        event_days(i) = caldays(between(O3b_start,datetime_event(i),'days'));
        event_days(i) = event_days(i) + len_O1 + len_O2 + len_O3a;
    end
end
%%
cum = linspace(1,num_event,num_event);

figure(1)

hp=stairs(event_days,cum, 'k', 'LineWidth',3);
% set shading
y1 = 0; 
y2 = max(ylim);
xlim([0 total_days])

hold on
patch([0 O1 O1 0], [y1 y1 y2 y2], [0.9 0.7 0.7]);
text(O1*0.3, y2*0.6, 'O1', 'Color', 'k', 'FontSize', 30, 'FontWeight', 'bold');
patch([O1 O2 O2 O1], [y1 y1 y2 y2], [0.7 0.9 0.7]);
text((O1+(O2-O1)*0.3), y2*0.6, 'O2', 'Color', 'k', 'FontSize', 30, 'FontWeight', 'bold');
patch([O2 O3a O3a O2], [y1 y1 y2 y2], [0.7 0.7 0.9]);
text((O2+(O3a-O2)*0.25), y2*0.6, 'O3a', 'Color', 'k', 'FontSize', 30, 'FontWeight', 'bold');
patch([O3a O3b O3b O3a], [y1 y1 y2 y2], [1.0 0.7 0.3]);
text((O3a+(O3b-O3a)*0.25), y2*0.6, 'O3b', 'Color', 'k', 'FontSize', 30, 'FontWeight', 'bold');

%generate and prettify plot
stairs(event_days,cum, 'k', 'LineWidth',3);
grid on;
hold off
title({'Cumulative Count of Events and (non-retracted) Alerts',['O1 = ',num2str(nev_O1),...
    ', O2 = ', num2str(nev_O2),', O3a = ',num2str(nev_O3a),', O3b = ',num2str(nev_O3b),', Total = ',num2str(num_event)]})
xlabel('Time (Days)','FontSize',18,'FontWeight','bold');
ylabel('Cumulative #Events/Candidates','FontSize',18,'FontWeight','bold');
set(gca,'FontSize', 14, 'FontWeight','bold','LineWidth', 1.5);
xx = get(gca,'xlim');
yy = get(gca,'ylim');
text(xx(2)*0.85, yy(1)-yy(2)/10., 'Credit: LIGO-Virgo Collaboration', 'Color', 'k', 'FontSize', 8, 'FontAngle', 'italic');
text(0.85, yy(1)-yy(2)/10., 'LIGO-G2001862', 'Color', 'k', 'FontSize', 8, 'FontAngle', 'italic');
grid on;

fnam = ['cumulative_events_',datestr(datetime_event(end),'yymmdd')];

print('-dpng',fnam)
print('-dpdf',fnam)
