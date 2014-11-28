function generate_common_data
% This function uses the trial-to-trial model of 2AFC to common data with
% which all the models can use. By converting the trial-to-trial
% performance into a number correct responses (k) then the data can be used
% by models 1 and 2 in addition to model 3 which will use the full
% trial-to-trial data.

clear, clc, %close all, drawnow

%% Double check this is what we want to do
choice = questdlg('Do you REALLY want to proceed? This will overwrite any existing common dataset.', ...
	'Careful', ...
	'Yes, create new common dataset','No thank you','No thank you');
% Handle response
switch choice
    case 'No thank you'
        error('Aborted')
end


%% MODEL PARAMETERS

params.T			= 100;                  % trials per signal level
params.sioriginal	= logspace(-2,1,10);    % define the signal intensities
params.v			= 1;                    % internal noise variance
params.lr			= 0.01;                 % true lapse rate
params.b			= 0;					% true bias
params.pdist		= [0.5 0.5];			% true spatial prior 

%% INFERENCE OPTIONS: just for generating the datasets
mcmcparams.doparallel = 0; 
mcmcparams.JAGSmodel = 'funcs/model2JAGS.txt';

mcmcparams.generate.nchains = 1;
mcmcparams.generate.nburnin = 500;
mcmcparams.generate.nsamples = params.T;

mcmcparams.infer.nchains = 2;
mcmcparams.infer.nburnin = 500;
mcmcparams.infer.nsamples = round(5000/mcmcparams.infer.nchains);  % 50000 in the paper



%%
% in order to conduct model prediction on si values that we do not have
% response data for, we will actually generate simulated data for all these
% additional si values now. But the data we generate will be used in step
% 2 where we only provide the model with response data for the actual si
% values run in an experiment. In other words, we are just using this step
% now to generate simulated 2AFC trial data (L) for these additional si
% values we wish to examine.
ni = 41; % number of si levels to examine
params.sii = logspace(-2,1,ni);

%params.si = [params.sioriginal params.sii];
params.si = [params.sioriginal params.sioriginal params.sii];

%% Step 1: Generate simulated dataset

% model 2 requires [si si sii]
[params] = model2generate(params, mcmcparams);

%% Export for Model 2
params.koriginal = params.k;
save('data/commondata_model2.mat', 'params')


%% Export for Model 3
params.si = [params.sioriginal params.sii];

% These models do not use trial level data of location and response, so
% this will be removed to keep things tidy
params = rmfield(params,'L');
params = rmfield(params,'R');
params = rmfield(params,'lr');
params = rmfield(params,'b');
params = rmfield(params,'pdist');
params = rmfield(params,'pc');

% Add unknowns which we want to make inferenes over for the interpolated
% signal intensity values
params.koriginal = params.k;
params.k(:,[numel(params.k)+1:numel(params.si)]) = NaN;
%params.pc(:,[numel(params.sioriginal)+1:numel(params.si)]) = NaN;

save('data/commondata_model3.mat', 'params')

%% Export for Model 1
save('data/commondata_model1.mat', 'params')

%%
fprintf('Generated and saved common data\n')

return