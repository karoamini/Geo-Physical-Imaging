% -------------------------------------------------------------------------
%       Acoustic wave equation finite diference simulator
% -------------------------------------------------------------------------

% ----------------------------------------
% Design an example with 2 layers, and build a plane wave by 
% using a line of sources (see examples). Now change the incident angle
% of the plane wave by activating the sources in the line 
% delayed in sequence. Check the Snell law.

clear all

% ----------------------------------------
% 1. Model parameters

model.x   = 0:1:1100;     % horizontal x axis sampling
model.z   = 0:1:300;     % vertical   z axis sampling

% temporary variables to compute size of velocity matrix
Nx = numel(model.x);
Nz = numel(model.z);

% velocity model assignement
% two layers with an interface at z_interface meters depth
% model.vel=zeros(Nz,Nx)+1000;      % initialize matrix

z_interface = 200;
model.vel=zeros(Nz,Nx);    % initialize matrix


for kx=1:Nx
  x=model.x(kx);
  for kz=1:Nz
    z=model.z(kz);
    
    if z>z_interface
      model.vel(kz,kx)=900;   
    else
      model.vel(kz,kx)=500;
    end
    
  end
end


% ----------------------------------------
% 2. Source parameters

source.x    = [40:1:(model.x(end)-50)];
Nsources    = numel(source.x);

source.z    = ones(1,Nsources) * 50 ; 
source.f0   = ones(1,Nsources) * 30; 
source.t0   = [0.04:  0.0015  :0.04+0.0015*Nsources];
source.amp  = ones(1,Nsources) * 1 ;
source.type = ones(1,Nsources) * 1;    % 1: ricker, 2: sinusoidal  at f0

% optional receivers in (recx, recz)
% the program round their position on the nearest velocity grid

model.recx  = [50:10:(model.x(end)-50)];
Nreceivers  = numel(model.recx);

model.recz  = ones(1,Nreceivers) * model.z(end)-50;
model.dtrec = 0.004;

% ----------------------------------------
% 3. Simulation and graphic parameters in structure simul

simul.borderAlg=1;
simul.timeMax=1;

simul.printRatio=10;
simul.higVal=.6;
simul.lowVal=.1;
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
scfact = 1;  % scaling factor
colour = ''; % trace colour, default is black
clip   = []; % clipping of amplitudes (if <1); default no clipping

seisplot2(recfield.data,recfield.time,[],scal,pltflg,scfact,colour,clip)
xlabel('receiver nr')