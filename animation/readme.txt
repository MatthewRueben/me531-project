Documentation for the ANIMATION function.

The ANIMATION function provides a framework for rendering movies from MATLAB as a sequence of frames that can be joined by ffmpeg, QuicktimePro, or a similar program.

-----------

1. Introduction.

MATLAB's standard movie-making tools (GETFRAME, MOVIE, and MOVIE2AVI) are based on a screen-scraping procedure: GETFRAME records the pixels that MATLAB has rendered to the screen for the target figure. Unfortunately, this process effectively prevents the user from rendering the animation in the background, as GETFRAME captures the viewable pixels (and thus any window that is place on top of the target figure). Additionally, the data structure that GETFRAME creates (effectively, a raw bitmap for each frame) can grow quickly and cause memory constraints, while the final MOVIE2AVI export options are limited.

An alternate approach to producing movies with MATLAB is to use the PRINT command to export each frame to a file, and then use a program such as ffmpeg or QuicktimePro to turn the sequence of frames into a movie. This process works without screen-scraping, and gives access to the more powerful movie formatting options in the external programs.

ANIMATION provides a framework for making movies with this second approach. It allows the user to specify high-level information about the movie, such as duration, framerate, pacing, and frame content, while ANIMATION handles low-level details, such as file numbering and management.

-----------

2. Included files

A) ANIMATION: Main program file; takes arguments describing a movie, and renders out a sequence of frames in a specified directory,

B) ANIMATION_DEMONSTRATION: Example program producing two movie sequences using ANIMATION.

C) COSSPACE and SOFTSPACE: Functions like LINSPACE, but that produce smoother starts and stops when used to select frame pacing.

D) PANZOOM: Finds interpolating axis limits for pan-zoom motions.

-----------

3. Instructions

The ANIMATION_DEMONSTRATION function illustrates the general structure of a   file that uses ANIMATION to produce a movie (or series of movies).

A) The input arguments "export" and "skip" (with default arguments given here as [0 0] for both) are passed on to the ANIMATION function, providing a means for controlling whether the frames are written to disk, and for skipping over movies if only one movie in the series is being worked on. Change the respective elements of "export" to 1 to write those frames to disk, and change the respective elements of "skip" to 1 to skip rendering the corresponding movie

B) Initialize all the elements of the animation figure, using a function like ANIMATION_DEMO_CREATE_ELEMENTS. Matlab generates figures faster if it is updating the properties of figure elements, rather than generating them from scratch in each frame; here we store these elements into a "frame_info" structure.

C) Specify a function to draw the frame, as the "frame_gen_function". This function should take in a "frame_info" structure and a relative time "tau", modify the contents of the axis as desired, and return the "frame_info" structure with a printmethod as specified in the ANIMATION documentation.

Any additional information the frame generation function needs can be specified via anonymous functions. An example of this is in the second movie, where ANIMATION_DEMO_PANZOOM has its "start_limits" parameter set to match the axis limits at the end of the preceding movie, ensuring continuity even if the previous movie is altered.

D) Set the timing of the movie. There are three timing parameters:

i. Duration: Length of time the movie should run for, in seconds

ii. FPS: Frames per second the movie will be compiled at. This code has 15fps, which is reasonable; for production movies I generally export at 30fps.

iii. Pacing: Each frame is a sample of the animation along the timeline. Biasing these samples repaces events when the movie is compiled at a uniform frame rate. The pacing function should be created to take in a number of frames, and then sample that many times across a pre-selected range and bias. The examples given here use the included SOFTSPACE function, which accelerates in and decelerates out of the video. Other options include COSSPACE (which accelerates for the full first half, and decelerates for the second half), LINSPACE (no bias), and LOGSPACE (exponentially increasing or decreasing speed).

E) Declare a path for the frames to be written to

F) Pass variables declared above into the ANIMATION function to create the animation frames (make sure to set "export" to 1 to write the frames to disk). Taking "frame_info" and "endframe" as output arguments from ANIMATION provides the final state of the animation, facilitating the construction of a series of linked movies.

-----------

4. Creating the movie file

The exported frames can be stitched together with programs such as QuicktimePro or ffmpeg. Most of my experience is with using QuicktimePro; various instructions for using ffmeg can be found on the web.

For best results with line-art style drawings, I typically export the files as .png (or, if it's got content that MATLAB's .png render breaks on, export to .eps and then batch convert the frames). More photo-realistic images are likely better-handled as .jpg files.

In QuicktimePro, File>Open_Image_Sequence and navigate to your image directory. Select the first (or any) image in the directory, and click "open". Select your frame rate. Depending on how much memory and processor you have available (and how large your source files are), you may be able to watch the raw animation of your files in the window that Quicktime opens. File>Export the movie, and use the advanced settings to tune the output format and resolution. For line-art I really like the png video format when storage space is not expensive; the h264 codec is a good general purpose choice.