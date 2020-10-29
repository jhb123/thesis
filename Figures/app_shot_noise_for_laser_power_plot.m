clear 
close all
h = 6.626e-34;
c = 3e8;
lambda = 1064e-9;

p = logspace(-4,7,1000);

shot_noise_rin = sqrt(2*(h*c/lambda).*p)./p;

size = 1.1;
aspect_ratio = size.*[6,4];

figure('Name','RIN','units','inches','position',[0 0 aspect_ratio(1) aspect_ratio(2)])
loglog(p,shot_noise_rin)

ylabel('RIN (1/\surd Hz)','fontsize',12)
xlabel('Laser power (W)','fontsize',12)
xlim([1e-4,1e7])
xticks(logspace(-4,7,7+4+1))
%set(gca,'fontsize',12)
print('appendix_RIN','-depsc')