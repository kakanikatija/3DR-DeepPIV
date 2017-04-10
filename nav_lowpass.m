function xfil = nav_lowpass(x, sample_freq_hz, filter_order, cutoff_freq_hz, causality)
%
% function xfil = nav_lowpass(x, sample_freq_hz, filter_order, cutoff_freq_hz)
%
% Function for lowpass filtering signal X, of frequency "sample_freq_hz"
% with a lowpass filter of order "filter_order", with
% cutoff frequency of cutoff_freq_hz
%
% Data in X are arranged as column vectors
%
% 2004-02-10  LLW Created and Written
% 2012-09-15  GT  Added causality option

% Causality input option
if(~exist('causality','var'))
    causality='noncausal';
end

switch(causality)
    case 'causal'
        f_causal=true;
    case {'noncausal','non-causal','no causal','acausal'}
        f_causal=false;
    otherwise
        f_causal=false;
end

% Filter Design
wn =  cutoff_freq_hz / (0.5 * sample_freq_hz);

if( wn > 1.0)
    fprintf(1,'LOWPASS.M: Error: the cutoff frequency cannot exceed 1/2 the sample frequency.\n');
    fprintf(1,'LOWPASS.M: Error: you have requested a cutoff frequency of %f HZ.\n',cutoff_freq_hz);
    fprintf(1,'LOWPASS.M: Error: for a sample frequency of %f HZ.\n', sample_freq_hz);
    return;
end

% create nth order butterworth filter
[B,A] = butter(filter_order,  wn, 'low');


% filter the colums of X
num_rows = length(x(:,1));
num_cols = length(x(1,:));

%fprintf(1,'LOWPASS.M: %d order butterworth filter. samples at %g HZ, cutoff freq at %g HZ\n',filter_order, sample_freq_hz, cutoff_freq_hz);
%fprintf(1,'LOWPASS.M: input data has %d samples in %d columns, wn=%g\n',num_rows, num_cols,wn);
 
% pre-allocate output matrix
xfil = x * 0;
for(col = 1:num_cols)
    if(f_causal)
        % Causal
        xfil(:,col) = filter(B,A,x(:,col));
    else
        % non-causal (default)
        xfil(:,col) = filtfilt(B,A,x(:,col));
    end
end