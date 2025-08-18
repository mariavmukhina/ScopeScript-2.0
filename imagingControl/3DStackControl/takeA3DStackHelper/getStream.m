function [stack] = getStream(n)
%GETSTREAM runs acquisition of zstacks defined in fcScope in scopeParams.m

global mmc;

width = mmc.getImageWidth;
height = mmc.getImageHeight;
stack   = zeros(width,height,n,'uint16');
mmc.prepareSequenceAcquisition(mmc.getCameraDevice);
mmc.startSequenceAcquisition(n, 0, false);
j = 0;
tFirstFrame = tic;
tCurrFrame = 0;

while(mmc.isSequenceRunning(mmc.getCameraDevice()) || (j < n) )
	tCurrFrame = toc(tFirstFrame);
	if (tCurrFrame > 15)
 		break
    end
    if (mmc.getRemainingImageCount() == 0)
		continue
    end
	j = j+1;
	stack(:,:,j) = reshape(typecast(mmc.popNextImage(),'uint16'),width,height);
end

mmc.stopSequenceAcquisition();

end

