// Save Image Sequence for BOS Processing
// Written by: JoshTheEngineer
// Started on: 10/20/19?
// Updated on: 01/16/21 - Updating from previous version with outdated Slice Keeper naming
//						- Works as expected

// Get directory
dir  = getDirectory("Select a Save Directory");									// Select directory to save output images to
dir2 = replace(dir,"\\","/");													// Change some of the delimiters

// Ask user which images to keep
Dialog.create("Slice Keeper");													// Create a Slice Keeper dialog box
Dialog.addNumber("First:", 1);													// Default first frame
Dialog.addNumber("Last:", 5);													// Default last frame
Dialog.addNumber("Increment:", 1);												// Default increment
Dialog.show();																	// Show the dialog box to user

// Get dialog numbers user entered
firstVal     = Dialog.getNumber();												// Get user-entered first frame
lastVal      = Dialog.getNumber();												// Get user-entered last frame
incrementVal = Dialog.getNumber();												// Get user-entered frame increment

// Stack length
stackLength = lastVal - firstVal + 1											// Number of images user wants to save

// Get currently selected stack name
stackName = getTitle();															// Full name of selected stack, including extension
selectWindow(stackName);														// Make sure that stack is selected

// Remove extension from stack name
strLen 		   = lengthOf(stackName);											// Length of the stack name/string
stackNameShort = substring(stackName,0,strLen-4);								// Remove the extension (.avi) from the stack name

// Get images ready for saving
run("Slice Keeper", "first=&firstVal last=&lastVal increment=&incrementVal");	// Run the Slice Keeper with user inputs from above
run("8-bit");																	// Convert to 8-bit in case user didn't already
run("Stack to Images");															// Extract individual slices from kept stack

// Loop through and save all images to the desired directory
for (i = 0; i < stackLength; i++) 												// Loop over all images
{
	numSelect = firstVal+i;														// Window selection index based on iteration
	numDig    = lengthOf(toString(numSelect));									// Number of digits of selection index (used for 0 prefix)
	
	if (numDig == 1) {															// If image is single-digit
		selectWindow(stackNameShort+"-000"+numSelect);							// Select the appropriate window
		saveAs("Tiff", dir2 + "Raw_000" + (numSelect));							// Save image with appropriate filename
	}
	else if (numDig == 2) {														// If image is double-digit
		selectWindow(stackNameShort+"-00"+numSelect);							// Select the appropriate window
		saveAs("Tiff", dir2 + "Raw_00" + (numSelect));							// Save image with appropriate filename
	}
	else if (numDig == 3) {														// If image is triple-digit
		selectWindow(stackNameShort+"-0"+numSelect);							// Select the appropriate window
		saveAs("Tiff", dir2 + "Raw_0" + (numSelect));							// Save image with appropriate filename
	}
	else if (numDig == 4) {														// If image is quadruple-digit
		selectWindow(stackNameShort+"-"+numSelect);								// Select the appropriate window
		saveAs("Tiff", dir2 + "Raw_" + (numSelect));							// Save image with appropriate filename
	}
}

// Close all images
while (nImages>0) {																// While there are still windows open
  selectImage(nImages); 														// Select the appropriate window
  close(); 																		// Close that window
}
