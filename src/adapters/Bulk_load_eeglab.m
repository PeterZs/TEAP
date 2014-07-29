function [BulkSig] = Bulk_load_eeglab(EEGV)
%Loads an EEGLab variable, into a TEAPhysio bulk signal, containing EEG, ECG,
%GSR, etc.
% Inputs:
%  EEGV: the variable given by EEGLab (ex: load A.mat; Bulk_load_eeglab(EEG))
% Outputs:
%  BulkSig: a TEAPhysio bulk signal vector
%
%Copyright Frank Villaro-Dixon Creative Commons BY-SA 4.0 2014

if(nargin ~= 1)
	error('Usage: BulkSig = Bulk_load_eeglab(EEGV)');
end


%Number of epochs:
nEpochs = length(EEGV.epoch);


%foreach epoch
for iEpoch = [1:nEpochs]
	clear Bulk;
	Bulk.tatat = 42;

%%%%%	Bulk = addGSR(Bulk, iEpoch); %%%FIXME data wrong
	Bulk = addHST(Bulk, iEpoch);

	BulkSig(iEpoch) = Bulk;
end



%GSR
function BulkSig = addGSR(BulkSig, iEpoch);
	GSRChannel = findMyChannel('GSR1');
	if(GSRChannel == 0)
		return;
	end

	data = EEGV.data(GSRChannel, :, iEpoch);
	reshaped = reshape(data, 1, length(data));

	GSRSig = GSR_aqn_variable(reshaped, EEGV.srate);
	Bulk.(GSR_get_name()) = GSRSig;
end

%Temp/HST
function BulkSig = addHST(BulkSig, iEpoch);
	GSRChannel = findMyChannel('Temp');
	if(GSRChannel == 0)
		return;
	end

	data = EEGV.data(GSRChannel, :, iEpoch);
	reshaped = reshape(data, 1, length(data));

	GSRSig = HST_aqn_variable(reshaped, EEGV.srate);
	Bulk.(HST_get_name()) = GSRSig;
end


%Find my channel
function iChannel = findMyChannel(chanName)
	for iChannel = [1:length(EEGV.chanlocs)]
		disp(EEGV.chanlocs(iChannel).labels);
		if(strcmp(chanName, EEGV.chanlocs(iChannel).labels) == 1)
			return;
		end
	end
	iChannel = 0;
end


end

