function [GSR_feats] = GSR_feat_extr(GSRsignal,varargin)
%Computes GSR features
% Inputs:
%  GSRsignal: the GSR signal.
%  varargin: you can choose which features to extract
% Outputs:
%  GSR_feats: the 1x3 feature vector including:
%  nbPeaks: the # of peaks in the signal divided by its duration
%  ampPeaks : the averaged amplitude of the peaks (maxima - minima)
%  riseTime : the averaged duration of the rise time of each peak
%Copyright XXX 2011
%Copyright Frank Villaro-Dixon, BSD Simplified, 2014
if isempty(varargin)
    varargin = {'all'};
end

GSRsignal = GSR__assert_type(GSRsignal);
samprate = Signal__get_samprate(GSRsignal);
%Make sure we have a GSR signal
if any(strcmp('all',varargin)) || any(strcmp('nbPeaks',varargin)) ...
        ||any(strcmp('ampPeaks',varargin)) || any(strcmp('riseTime',varargin))
    ampThresh = 100;%Ohm
    [nbPeaks, ampPeaks, riseTime, posPeaks] = GSR_feat_peaks(GSRsignal,ampThresh);
    nbPeaks = nbPeaks/(length(GSRsignal)/samprate);
    ampPeaks = mean(ampPeaks);
    riseTime = mean(riseTime);
    %to do what is this good for? posPeaks
    GSRsignal = GSR__assert_type(GSRsignal);
    
    if(~Signal__has_preproc_lowpass(GSRsignal))
        warning(['For the function to work well, you should low-pass the signal' ...
            '. Preferably with a median filter']);
    end
    
    if(nargin < 1)
        error('Usage: [GSR_feats] = GSR_feat_peaks(GSRsignal)');
    end
    
end

if  any(strcmp('all',varargin))
    GSR_feats = [nbPeaks, ampPeaks, riseTime];
else
    for i = 1:length(varargin)
        eval(['GSR_feats(i) = ' varargin{i} ';']);
    end
end
end

