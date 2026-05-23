// ============================================================
// Create composite timelapse hyperstack (xyczt)
// BrightField + Lsr561 + Lsr640
//
// Assumes folder structure:
//
// baseDir/
//    BrightFieldTTL_t1.tif
//    BrightFieldTTL_t2.tif
//    ...
//
//    [findSpotsStage1V2cubed(...)]/
//         LLRatio/
//              ...Lsr561..._t1).fits
//              ...Lsr561..._t2).fits
//              ...
//
//              ...Lsr640..._t1).fits
//              ...Lsr640..._t2).fits
//              ...
//
// ============================================================


// ------------------------------------------------------------
// 1. Ask for base directory
// ------------------------------------------------------------
Dialog.create("Select Folder");
Dialog.addString("Folder path:", "");
Dialog.show();

baseDir = Dialog.getString();

if (!endsWith(baseDir, "/") && !endsWith(baseDir, "\\")) {
    baseDir = baseDir + File.separator;
}

if (!File.exists(baseDir))
    exit("Folder does not exist.");

setBatchMode(true);

// ------------------------------------------------------------
// 2. Find LLRatio folder
// ------------------------------------------------------------
list = getFileList(baseDir);

subDir = "";

for (i = 0; i < list.length; i++) {

    path = baseDir + list[i];

    if (File.isDirectory(path) &&
        startsWith(list[i], "[findSpotsStage1V2cubed(")) {

        subDir = path + "LLRatio" + File.separator;
        break;
    }
}

if (subDir == "")
    exit("Could not find LLRatio folder.");



// ------------------------------------------------------------
// 3. Function: extract t-number
// ------------------------------------------------------------
function getTimeIndex(name) {

    tPos = indexOf(name, "_t");

    if (tPos < 0)
        return -1;

    sub = substring(name, tPos + 2);

    digits = "";

    for (k = 0; k < lengthOf(sub); k++) {

        ch = substring(sub, k, k+1);

        if (ch >= "0" && ch <= "9")
            digits = digits + ch;
        else
            break;
    }

    return parseInt(digits);
}



// ------------------------------------------------------------
// 4. Collect BrightField files
// ------------------------------------------------------------
bfList = newArray();
bfTimes = newArray();
bfCount = 0;

for (i = 0; i < list.length; i++) {

    if (endsWith(list[i], ".tif") &&
        indexOf(list[i], "BrightFieldTTL") != -1) {

        bfList[bfCount] = list[i];
        bfTimes[bfCount] = getTimeIndex(list[i]);
        bfCount++;
    }
}



// ------------------------------------------------------------
// 5. Collect LLRatio files
// ------------------------------------------------------------
list2 = getFileList(subDir);

greenList = newArray();
greenTimes = newArray();
greenCount = 0;

redList = newArray();
redTimes = newArray();
redCount = 0;

for (i = 0; i < list2.length; i++) {

    name = list2[i];

    if (!endsWith(name, ".fits"))
        continue;

    t = getTimeIndex(name);

    if (indexOf(name, "Lsr561") != -1) {

        greenList[greenCount] = name;
        greenTimes[greenCount] = t;
        greenCount++;
    }

    if (indexOf(name, "Lsr640") != -1) {

        redList[redCount] = name;
        redTimes[redCount] = t;
        redCount++;
    }
}



// ------------------------------------------------------------
// 6. Sort function
// ------------------------------------------------------------
function sortByTime(arr, times, count) {

    for (a = 0; a < count-1; a++) {

        for (b = a+1; b < count; b++) {

            if (times[a] > times[b]) {

                tmp = times[a];
                times[a] = times[b];
                times[b] = tmp;

                tmp2 = arr[a];
                arr[a] = arr[b];
                arr[b] = tmp2;
            }
        }
    }
}



// Sort all channels
sortByTime(bfList, bfTimes, bfCount);
sortByTime(greenList, greenTimes, greenCount);
sortByTime(redList, redTimes, redCount);



// ------------------------------------------------------------
// 7. Open BrightField xyz stacks and concatenate into xyzt
// ------------------------------------------------------------

titlesBF = newArray();

// Open all BrightField stacks
for (i = 0; i < bfCount; i++) {

    open(baseDir + bfList[i]);

    titlesBF[i] = getTitle();

    print("Opened BF: " + titlesBF[i]);
}



// Concatenate all stacks
concatArg = "";

for (i = 0; i < bfCount; i++) {

    concatArg = concatArg + " image" + (i+1) + "=[" + titlesBF[i] + "]";
}

run("Concatenate...", concatArg + " title=BrightField_stack");



// Get number of z-slices from first stack
selectWindow("BrightField_stack");

zSlices = nSlices / bfCount;



// Convert concatenated stack into hyperstack
Stack.setDimensions(1, zSlices, bfCount);

run("Stack to Hyperstack...", 
    "order=xyztc channels=1 slices=" + zSlices +
    " frames=" + bfCount + " display=Grayscale");

selectWindow("BrightField_stack");
run("32-bit");


// ------------------------------------------------------------
// 8. Open Lsr561 xyz stacks and concatenate into xyzt
// ------------------------------------------------------------

titles561 = newArray();

// Open all Lsr561 stacks
for (i = 0; i < greenCount; i++) {

    open(subDir + greenList[i]);

    titles561[i] = getTitle();

    print("Opened Lsr561: " + titles561[i]);
}



// Concatenate all stacks
concatArg = "";

for (i = 0; i < greenCount; i++) {

    concatArg = concatArg +
        " image" + (i+1) + "=[" + titles561[i] + "]";
}

run("Concatenate...", concatArg + " title=Lsr561_stack");



// Get number of z-slices from first stack
selectWindow("Lsr561_stack");

zSlices561 = nSlices / greenCount;



// Convert concatenated stack into hyperstack
Stack.setDimensions(1, zSlices561, greenCount);

run("Stack to Hyperstack...",
    "order=xyztc channels=1 slices=" + zSlices561 +
    " frames=" + greenCount + " display=Composite");
    
// ------------------------------------------------------------
// 9. Open Lsr640 xyz stacks, reverse each, concatenate into xyzt
// ------------------------------------------------------------

titles640 = newArray();

// Open + reverse each Lsr640 stack BEFORE concatenation
for (i = 0; i < redCount; i++) {

    open(subDir + redList[i]);

    // reverse Z stack for each timepoint
    run("Reverse");

    titles640[i] = getTitle();

    print("Opened + reversed Lsr640: " + titles640[i]);
}



// Concatenate reversed stacks
concatArg = "";

for (i = 0; i < redCount; i++) {

    concatArg = concatArg +
        " image" + (i+1) + "=[" + titles640[i] + "]";
}

run("Concatenate...", concatArg + " title=Lsr640_stack");



// Get number of z-slices from first stack
selectWindow("Lsr640_stack");

zSlices640 = nSlices / redCount;



// Convert concatenated stack into hyperstack
Stack.setDimensions(1, zSlices640, redCount);

run("Stack to Hyperstack...",
    "order=xyztc channels=1 slices=" + zSlices640 +
    " frames=" + redCount + " display=Composite");
    

// ------------------------------------------------------------
// 10. Merge channels into composite hyperstack
// ------------------------------------------------------------
run("Merge Channels...",
    "c1=[Lsr640_stack] " +
    "c2=[Lsr561_stack] " +
    "gray=[BrightField_stack] " +
    "create");

setBatchMode(false);