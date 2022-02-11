% -------------------------------------------------------------------------
%       Acoustic wave equation finite difference simulator
% -------------------------------------------------------------------------

% --------------------------------------------------
% Create your own model and example....
% --------------------------------------------------
% ----------------------------------------
% 1. Model parameters

% model=load('marmousi');
vel2 = imread ('Earth1.jpg');
vel2 = rgb2gray (vel2);
figure, imshow (rot90(vel2));
title ('Converted image');
vel = im2double(vel2);  % convert to double
vel = round (rot90 (vel*3333),-3); % multiply by 3333 to increase the contrast
                                   % also round it to multiplication of
                                   % 1000 in order to be like the
                                   % "marmousi" dataset
save('MyModel.mat','vel');
model = load ("MyModel");


[Nz,Nx]=size(model.vel);

dx=5;
dz=5;

model.x   = (0:Nx-1)*dx;
model.z   = (0:Nz-1)*dz;

% optional receivers in (recx, recz)
% the program round the position on the velocity grid

model.recx  = [50:100:model.x(end)];
Nreceivers  = numel(model.recx);

model.recz  = ones(1,Nreceivers) * 20;
model.dtrec = 0.004;

% ----------------------------------------
% 2. Source parameters

source.x=400;
source.z=250;
source.f0=5;
source.t0=0.1;
source.type=1;
source.amp=1;

% ----------------------------------------
% 3. Simulation and graphic parameters in structure simul

simul.borderAlg=1;
simul.timeMax=3.5;

simul.printRatio=10;
simul.higVal=.03;
simul.lowVal=0.001;
simul.bkgVel=1;

simul.cmap='gray';   % gray, cool, hot, parula, hsv

% ----------------------------------------
% 4. Program call

recfield=acu2Dpro(model,source,simul);

% Plot receivers traces

figure
scal   = 1;  % 1 for global max, 0 for global ave, 2 for trace max
pltflg = 0;  % 1 plot only filled peaks, 0 plot wiggle traces and filled peaks,
             % 2 plot wiggle traces only, 3 imagesc gray, 4 pcolor gray
scfact = 10; % scaling factor
colour = ''; % trace colour, default is black
clip   = []; % clipping of amplitudes (if <1); default no clipping

seisplot2(recfield.data,recfield.time,[],scal,pltflg,scfact,colour,clip)
xlabel('receiver nr')
