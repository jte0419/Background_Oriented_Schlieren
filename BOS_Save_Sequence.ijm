// Get directory
dir  = getDirectory("Select a Save Directory");
dir2 = replace(dir,"\\","/");

// Ask user which images to keep
Dialog.create("Slice Keeper");
Dialog.addNumber("First:", 1);
Dialog.addNumber("Last:", 5);
Dialog.addNumber("Increment:", 1);
Dialog.show();

// Get dialog numbers user entered
firstVal     = Dialog.getNumber();
lastVal      = Dialog.getNumber();
incrementVal = Dialog.getNumber();

// Stack length
stackLength = lastVal - firstVal + 1
print(stackLength)

// Get currently selectes stack name
stackName = getTitle();
selectWindow(stackName);

// Run the slice keeper
run("Slice Keeper", "first=&firstVal last=&lastVal increment=&incrementVal");

// Create images from saved stack
stackNameKept = getTitle();
run("8-bit");
run("Stack to Images");

// Loop through and save all images and save to desired directory
imgInd = 1;
for (i = 1; i <= stackLength; i++)
{
	// Save Raw data file
	selectWindow("slice:"+(firstVal+i-1));
	if (imgInd < 10) {
		saveAs("Tiff", dir2 + "Raw_0" + (imgInd));
	}
	else {
		saveAs("Tiff", dir2 + "Raw_" + (imgInd));
	}
	imgInd = imgInd + 1;
}

// Close all images
while (nImages>0) { 
  selectImage(nImages); 
  close(); 
}
