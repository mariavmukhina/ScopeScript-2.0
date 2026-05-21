function [] = LLR_onTheFly(dataFolder,TTLtrigger)
    
    if ~contains(TTLtrigger, 'Laser')
        return
    end
    currentFolder            = pwd;
    camVarFile               = fullfile(currentFolder,'\postProcessing\dummy_calibration.mat');
    channels                 = {TTLtrigger};
    specimenUnitsInMicrons   = [0.13,0.13,200*0.003];%[0.217,0.217,0];  % pixel/voxel size in µm; DAC->µm conversion coeff for z: 1 DAC unit = 220 µm[max stage range]/65536 ~= 0.003 µm
    nD                       = 3; % number of dimensions in dataset
    multi                    = 0; % 1 - multi-color dataset; 0 - single color
    imageSize                = [1024 1024]; % px
    stackSize                = 100; % for stack of 2D images: number of images in a stack, use 1 for 3D
    phaseROI                 = 'roi.roi';
    if nD == 2 && multi == 0
        Kmatrix              = eye(stackSize); 
    elseif nD == 3 && multi == 0
        Kmatrix              = 1;
    elseif multi ~= 0
        warning('bleed thru Kmatrix has to be supplied with multi spectral data');
    end
    
    % psf generation
    % genGaussKernObj([2,2,2],[15 15 15]: [2,2,2] are gaussian sigma parameters
    % in x,y,z; [15 15 15] - the size of the patch for which likelihood of
    % having a point-like source is estimated; this patch is moved across the
    % whole image with 1 px step
    
    if nD == 2 & stackSize == 1
        % for 2D dataset
        psf = {genGaussKernObj([2,2,2],[15 15 15],nD)};  % 2, 9 - best parameters for HeLa
    elseif nD == 2 & stackSize > 1
        %% gaussian 2D PSF
        psfObj = {genGaussKernObj([2,2],[7 7],nD)};
        psfObj = cellfunNonUniformOutput(@(x) x.returnShape,psfObj);
        psf(1,1,1:stackSize) = psfObj; 
    elseif nD == 3
        % for 3D  dataset
        psfObj = {genGaussKernObj([2,2,2],[15 15 15],nD)};  % 2, 9 - best parameters for HeLa with laser; 2, 15 - for HeLa with LED; 1, 7 - for in vitro sensors with laser
        psfObj = cellfunNonUniformOutput(@(x) x.returnShape,psfObj);
        psf(1,1,1:stackSize) = psfObj; 
    end
    
    % for 2 color 3D multi-spectral dataset
    % psfObj1 = genGaussKernObj([0.9,0.9,0.9],[7 7 7]);
    % psfObj2 = genGaussKernObj([1,1,1],[7 7 7]);
    % psf = {psfObj1,psfObj2};
    
    %% Import
    spotOutputs         = procGetImages(dataFolder,channels,'spotOutputs',specimenUnitsInMicrons,nD);
    
    %% Stage I: rough estimation, imprecise MLE and position, one iteration 
    stageIOutputs       = procStageI(spotOutputs,psf,'stageIFunc',@findSpotsStage1V2cubed,'camVarFile',camVarFile,'Kmatrix',Kmatrix,'doProcParallel',false,'nD',nD,'multi',multi);

end