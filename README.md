# Background_Oriented_Schlieren

This post contains all the code (or links to code/programs) that you will need for BOS processing.  This post accompanies my [YouTube video](https://www.youtube.com/watch?v=VCUN59x0LF4) on the subject, which I recommend you watch.  If you would rather read, I have a comprehensive [PDF document](http://www.joshtheengineer.com/2019/10/20/how-to-take-pictures-like-nasa-using-background-oriented-schlieren-bos/) on the topic as well (it is too big for GitHub, so you can find it at my website).  All of these files can also be downloaded from my [website](http://www.joshtheengineer.com/2019/10/20/how-to-take-pictures-like-nasa-using-background-oriented-schlieren-bos/).

There are some free programs you will need for this project.  Below is a comprehensive list of those used in my video.

* [youtube-dl](https://ytdl-org.github.io/youtube-dl/index.html)
* [FFmpeg](https://www.ffmpeg.org/)
* [ImageJ/Fiji](https://fiji.sc/)
* [Anaconda](https://www.anaconda.com/)
* [Python](https://www.python.org/)

If you are running my Python GUI program, you will also need to download the following function file.

* [normxcorr2.py](https://github.com/Sabrewarrior/normxcorr2-python/blob/master/normxcorr2.py)

Again, all the files can also be found on my website.

# Notes

* If you are running this program on a Mac and get an error, there is a good chance it's because of the difference between Windows and Mac when it comes to folder/directory naming.  Try switching all the slashes in the directory name to "/".  For instance, one location where you'll need to change it in the MATLAB code is in the *pushSelectVideoDirectory_Callback* function callback.
* As of 01/16/21, a new version of the ImageJ script for saving a sequence of images is available.  If you are using the most up-to-date ImageJ version, you should download [BOS_Save_Sequence_v2.ijm](./BOS_Save_Sequence_v2.ijm).  If you want to make this script available automatically every time you open ImageJ (without having to install it every time), add the code in the script to the file called *StartupMacros.fiji.ijm* (the startup macro script for FIJI/ImageJ).  This should be located in the *macros* folder of your installation.  You'll need to copy-paste the code from [BOS_Save_Sequence_v2.ijm](./BOS_Save_Sequence_v2.ijm) in between the braces of the code shown here:
```
macro "BOS Save Sequence 2" {

}
```
* An updated version of the MATLAB code ([GUI_BOS_v3.m](./GUI_BOS_v3.m)) was uploaded on 01/17/21, which works with the new filenames from the updated ImageJ macro ([BOS_Save_Sequence_v2.ijm](./BOS_Save_Sequence_v2.ijm)).  Note that this updated code only affects the video processing, not the image processing.
