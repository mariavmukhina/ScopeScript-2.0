// You can use this script if, after the application of the Fred filter, you want to create a merged image (bright field + red and green channels)
// 1) Run script
// 2) Choose the folder containing the brightfield image, e.g. 'H:\muxika\20260521-test-LLRontheFly-test\takeA3DStack\'
// The folder with super resolution images should be located inside this folder: "[findSpotsStage1V2cubed(qf3DgQ)]" → "LLRatio"
// (automatic organization after applying FCfilter_MM_recipe.m)
// 3) The script will open the brightfield, Lsr561, and Lsr640 images
// (and save their original names)
// 4) The script will reverse the Lsr640 image
// 5) Then it will merge all 3 channels into a single image



// Ask user to type/paste folder path
Dialog.create("Select Folder");
Dialog.addString("Folder path:", "");
Dialog.show();

baseDir = Dialog.getString();

// Ensure trailing separator exists
if (!endsWith(baseDir, "/") && !endsWith(baseDir, "\\")) {
    baseDir = baseDir + File.separator;
}

if (!File.exists(baseDir))
    exit("Folder does not exist:\n" + baseDir);


list = getFileList(baseDir);
brightFieldPath = "";

for (i = 0; i < list.length; i++) {
	// -------------------------
	// 1. Open BrightFieldTTL tif
	// -------------------------
	
    if (endsWith(list[i], ".tif") && indexOf(list[i], "BrightFieldTTL") != -1) {
        brightFieldPath = baseDir + list[i];
        open(brightFieldPath);
        brightName = getTitle();
        break;
    }
}

if (brightFieldPath == "") {
    exit("brightFieldPath is empty");
}

// -------------------------
// 2. Get paths to LLRatio fits for Laser channels
// -------------------------
subDir = "";

for (i = 0; i < list.length; i++) {

    path = baseDir + list[i];

    if (File.isDirectory(path) &&
        startsWith(list[i], "[findSpotsStage1V2cubed(")) {

        subDir = path + "LLRatio/";
        break;
    }
}

if (subDir == "")
    exit("Could not find matching findSpotsStage1V2cubed folder");

if (!File.exists(subDir)) {
    exit("LLRatio files do not exist:\n" + subDir);
}




// -------------------------
// 3. Open FITS images
// -------------------------
list2 = getFileList(subDir);
names = newArray();
count = 0;

for (i = 0; i < list2.length; i++) {
    if (endsWith(list2[i], ".fits")) {
        open(subDir + list2[i]);
        names[count] = getTitle();
        count++;
    }
}

// -------------------------
// 4. Save all opened image names
// -------------------------
namesAll = "BrightField image:\n" + brightName + "\n\nFITS images:\n";

for (i = 0; i < names.length; i++) {
    namesAll = namesAll + names[i] + "\n";
}

// Save file in base directory
outPath = baseDir + "opened_image_names.txt";
File.saveString(namesAll, outPath);


// Find the three open images by title and merge them:
// Red channel <- image containing "Laser640"
// Green channel <- image containing "Laser561"
// Gray channel <- image containing "BrightField"

redTitle = "";
greenTitle = "";
grayTitle = "";

// Search through all open images
for (i = 1; i <= nImages; i++) {
    selectImage(i);
    title = getTitle();

    if (indexOf(title, "Lsr640") != -1)
        redTitle = title;

    if (indexOf(title, "Lsr561") != -1)
        greenTitle = title;

    if (indexOf(title, "BrightField") != -1)
        grayTitle = title;
}



// Check that all required images were found
if (redTitle == "" || greenTitle == "" || grayTitle == "") {
    exit("One or more required images were not found.");
}
// Apply "Reverse" to the image whose title contains "Laser640"
selectWindow(redTitle);
run("Reverse");


// Convert the BrightField image to 32-bit

selectWindow(grayTitle);
run("32-bit");



// Merge channels
run("Merge Channels...",
    "c1=[" + redTitle + "] " + // Red channel
    "c2=[" + greenTitle + "] " + // Green channel
    "gray=[" + grayTitle + "]" + // Gray channel
    "create"); 