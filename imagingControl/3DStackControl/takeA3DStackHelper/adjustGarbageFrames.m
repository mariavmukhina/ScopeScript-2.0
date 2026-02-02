function flattenedInstructions = adjustGarbageFrames(flattenedInstructions,fcScope)
%ADJUSTGARBAGEFRAMES adjusts the values or the  z stack values in the
%arduino controller to accomodate the fact that there are garbage frames
%after the streaming acquisition.  during garbage frames, the controller
%should ignore these pulses.  for my scmos camera, i have 1 lagging garbage
%frame, but there could be 2.  for generality you can program leading and
%lagging garbage frames
%
%fchang@fas.harvard.edu

leadingGarbageFrames = fcScope.leadingGarbageFrames;
laggingGarbageFrames = fcScope.laggingGarbageFrames;

%if leadingGarbageFrames ~= 0
%  flattenedInstructions.mergedZSteps = padarray(flattenedInstructions.mergedZSteps,[0,leadingGarbageFrames],flattenedInstructions.mergedZSteps(end),'pre');
%  flattenedInstructions.mergedEnergyChannels = padarray(flattenedInstructions.mergedEnergyChannels,[0,leadingGarbageFrames],0,'pre');
 % flattenedInstructions.feedForwardSteps = padarray(flattenedInstructions.feedForwardSteps,[0,leadingGarbageFrames],0,'pre');
%end

%if laggingGarbageFrames ~= 0
%  flattenedInstructions.mergedZSteps = padarray(flattenedInstructions.mergedZSteps,[0,laggingGarbageFrames],'replicate','post');
%  flattenedInstructions.mergedEnergyChannels = padarray(flattenedInstructions.mergedEnergyChannels,[0,laggingGarbageFrames],0,'post');
%  flattenedInstructions.feedForwardSteps = padarray(flattenedInstructions.feedForwardSteps,[0,laggingGarbageFrames],0,'post'); 
%end

% ===== LEADING (PRE) =====
if leadingGarbageFrames ~= 0
    n = leadingGarbageFrames;

    % --- mergedZSteps (replicate last) ---
    v = flattenedInstructions.mergedZSteps;
    val = v(end);
    if isrow(v)
        preZ = repmat(val, 1, n);
        flattenedInstructions.mergedZSteps = [preZ v];
    else
        preZ = repmat(val, size(v,1), n);   % горизонтально по столбцам
        flattenedInstructions.mergedZSteps = [preZ v];
    end

    % --- mergedEnergyChannels (zeros) ---
    v = flattenedInstructions.mergedEnergyChannels;
    if isrow(v)
        preE = zeros(1, n);
        flattenedInstructions.mergedEnergyChannels = [preE v];
    else
        preE = zeros(size(v,1), n);
        flattenedInstructions.mergedEnergyChannels = [preE v];
    end

    % --- feedForwardSteps (zeros) ---
    v = flattenedInstructions.feedForwardSteps;
    if isrow(v)
        preF = zeros(1, n);
        flattenedInstructions.feedForwardSteps = [preF v];
    else
        preF = zeros(size(v,1), n);
        flattenedInstructions.feedForwardSteps = [preF v];
    end
end

% ===== LAGGING (POST) =====
if laggingGarbageFrames ~= 0
    n = laggingGarbageFrames;

    % --- mergedZSteps (replicate last) ---
    v = flattenedInstructions.mergedZSteps;
    val = v(end);
    if isrow(v)
        postZ = repmat(val, 1, n);
        flattenedInstructions.mergedZSteps = [v postZ];
    else
        postZ = repmat(val, size(v,1), n);
        flattenedInstructions.mergedZSteps = [v postZ];
    end

    % --- mergedEnergyChannels (zeros) ---
    v = flattenedInstructions.mergedEnergyChannels;
    if isrow(v)
        postE = zeros(1, n);
        flattenedInstructions.mergedEnergyChannels = [v postE];
    else
        postE = zeros(size(v,1), n);
        flattenedInstructions.mergedEnergyChannels = [v postE];
    end

    % --- feedForwardSteps (zeros) ---
    v = flattenedInstructions.feedForwardSteps;
    if isrow(v)
        postF = zeros(1, n);
        flattenedInstructions.feedForwardSteps = [v postF];
    else
        postF = zeros(size(v,1), n);
        flattenedInstructions.feedForwardSteps = [v postF];
    end
end


end
