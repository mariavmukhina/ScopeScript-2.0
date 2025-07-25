function [stack] = getStream(n)
%GETSTREAM runs acquisition of zstacks defined in fcScope in scopeParams.m

global mmc;

width = mmc.getImageWidth;
height = mmc.getImageHeight;
stack   = zeros(width,height,n,'uint16');
mmc.prepareSequenceAcquisition(mmc.getCameraDevice);
mmc.startSequenceAcquisition(n, 0, false);
j = 0;
tFrame = tic;

while(mmc.isSequenceRunning(mmc.getCameraDevice()) || j ~= n && (toc - tFrame < 5))
    if (mmc.getRemainingImageCount() > 0)
            j = j+1;
			stack(:,:,j) = reshape(typecast(mmc.popNextImage(),'uint16'),width,height);
            tFrame = tic;
    end
end
mmc.stopSequenceAcquisition();

end

