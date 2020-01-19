close all;
clear;
clc;
libPath = ['..',filesep(),'lib'];
tanquesPath = ['..',filesep(),'..',filesep(),'Identificacao',filesep(),'tanques_acoplados'];
addpath(libPath);
addpath(tanquesPath);
loadDependencies();
