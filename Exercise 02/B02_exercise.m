% -------------------------------------------------------------------------
%       Acoustic wave equation finite diference simulator
% -------------------------------------------------------------------------

% ----------------------------------------
% Design an example with 2 layers, source and receivers in the first layer
% check the polarity of the reflected and transmitted waves with respect 
% to the incident one, as a function of the velocity change at the interface
% Be prepared to identify different wavefronts 
% (direct, reflected from 1st interface, ...)

clear all;


% ----------------------------------------
% 1. Model parameters

model.x   = 0:1:1000;    % horizontal x axis sampling
model.z   = 0:1:450;     % vertical   z axis sampling

% temporary variables to compute size of velocity matrix
Nx = numel(model.x);
Nz = numel(model.z);


% example of velocity model assignement
% two layers with an interface at z_interface meters depth
z_interface=250;
model.vel=zeros(Nz,Nx);      % initialize matrix

for kx=1:Nx
  x=model.x(kx);
  for kz=1:Nz
    z=model.z(kz);
    
    if z>z_interface
      model.vel(kz,kx)=800;
    else
      model.vel(kz,kx)=1200;
    end
    
  end
end


% optional receivers in (recx, recz)
% the program round their position on the nearest velocity grid
model.recx  = 30:50:1000;
model.recz  = model.recx*0+20;  % ... a trick to have same nr elements  of recx
model.dtrec = 0.004;


source.x    = [100];
source.z    = [60 ]; 
source.f0   = [25 ];
source.t0   = [0.1  ];
source.amp  = [1 ];
source.type = [1];    % 1: ricker, 2: sinusoidal  at f0

% ----------------------------------------
% 3. Simulation and graphic parameters in structure simul

simul.borderAlg=1;
simul.timeMax=1.2;

simul.printRatio=10;
simul.higVal=.05;
simul.lowVal=0.02;
simul.bkgVel=1;

simul.cmap='gray';   % gray, cool, hot, parula, hsv

% ----------------------------------------
% 4. Program call

recfield=acu2Dpro(model,source,simul);

% Plot receivers traces

figure

scal   = 2;  % 1 for global max, 0 for global ave, 2 for trace max
pltflg = 0;  % 1 plot only filled peaks, 0 plot wiggle traces and filled peaks,
             % 2 plot wiggle traces only, 3 imagesc gray, 4 pcolor gray
scfact = 5; % scaling factor
colour = ''; % trace colour, default is black
clip   = []; % clipping of amplitudes (if <1); default no clipping

seisplot2(recfield.data,recfield.time,[],scal,pltflg,scfact,colour,clip)
xlabel('receiver nr')


axis xy




