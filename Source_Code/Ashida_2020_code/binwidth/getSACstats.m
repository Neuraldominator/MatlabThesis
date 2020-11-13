%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Script to analyze the effect of bin width BW on SAC/CI 
% May-Oct 2020, Go Ashida (go.ashida@uni-oldenburg.de)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% BW values [us]
BWall = [2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,...
         25,30,35,40,45,50,55,60,65,70,75,80,85,90,95,100,...
         105,110,115,120,125,130,135,140,145,150,155,160,...
         165,170,175,180,185,190,195,200,205,210,240,250,...
         300,305,350,400,450,500,505,550,600,650,700,705,...
         750,800,850,900,905,950,1000,1100,1200,1300,1400,...
         1500,1600,1700,1800,1900,2000 ]; 

BWodd = [2,6,10,14,18,30,50,70,90,110,130,150,170,190,...
         210,250,350,450,550,650,750,850,950];
[~,IDodd] = ismember(BWodd,BWall); % get the corresponding indices

BWevn = [4,8,12,16,20,40,60,80,100,120,140,160,180,200,240,...
         300,400,500,600,700,800,900,1000];
[~,IDevn] = ismember(BWevn,BWall); % get the corresponding indices

BWnon = [3,5,7,9,11,13,15,17,19,25,35,45,55,65,75,85,95,105,...
         115,125,135,145,155,165,175,185,195,205,305,505,705,905];
[~,IDnon] = ismember(BWnon,BWall); % get the corresponding indices

BWbig = [1100,1200,1300,1400,1500,1600,1700,1800,1900,2000];
[~,IDbig] = ismember(BWbig,BWall); % get the corresponding indices

disp([length(BWall), length(BWodd), length(BWevn), length(BWnon), length(BWbig)]);



%% calculating SAC/CI for varied BW

% loading data file
infile = 'SPv60all.mat'; 
load(infile); 

% data vector
CIall = zeros(length(BWall),Nreps); 

% outer loop for BW
for b = 1:length(BWall)

% analysis parameters
T1 = 0; 
T2 = Ddef;
BW = BWall(b)/1000; % [ms]
TL = 5;

 % inner loop 
 for r = 1:Nreps

 % show progress
 if(mod(r,100)==0); disp([BWall(b),r]); end 

 % assigning spikes
 SPin = cell(1,Mdef);
 SPdum = SPall{r}; 
 for c = 1:Mdef
  T8 = Ddef*(c-1);
  T9 = Ddef*c;
  SPin{c} = SPdum( SPdum>=T8 & SPdum<T9 ) - T8; 
 end

 % get SAC
 [SAC,SACtv,CI,CN,NS] = calcSAC(SPin,BW,T1,T2,TL);
 CIall(b,r) = CI;

 end % inner loop r

end % outer loop b

% saving CI values
outfile = sprintf('CIv%.0fall.mat',R*100);
%save(outfile,'CIall','Ddef','Mdef','F','K','BWall','IDodd','IDevn','IDnon','IDbig'); % uncomment this to save data

