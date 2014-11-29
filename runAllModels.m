
setup

%% MODEL 1
model1runme('gridApprox')
model1plot('tempModel1run_gridApprox')

model1runme('mcmcCustom')
model1plot('tempModel1run_mcmcCustom')

model1runme('mcmcJAGS')
model1plot('tempModel1run_mcmcJAGS')

% model 1 JAGS
model1MCMCconvergence	% check chain convergence

% accuracy of MCMC chain derived MAP estimates of sigma^2
model1MCMCse('calculate')
model1MCMCse('plot')

%% MODEL 2
model2runme				% parameter estimation + model prediction
model2plot

%% MODEL 3
model3runme				% parameter estimation + model prediction
model3plot


% calculate psychometric functions
model3psychometric('calculate')
model3psychometric('plot')

