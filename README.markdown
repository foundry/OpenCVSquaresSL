__OpenCVSquares Multitarget version__

opencv2 framework - for Xcode 4.4+/OSX10.7

OpenCV framework -  for XCode 4.2/OSX10.6

Three targets  

- OpenCV_SL - OpenCV framework + Xibs
for Xcode 4.2 and Snow Leopard

- OpenCVSquaresXIB - opencv2 framework + Xibs  
For Xcode 4.4+ and OSX10.7+

- OpenCVSquares - opencv2 framework + Storyboards  
For Xcode 4.4+ and OSX10.7+


__OpenCV computer vision with iOS__  

2/1/2013
openCV library compiled from latest gitHub clone 

UIImage+OpenCV category code from   
<http://aptogo.co.uk/2011/09/opencv-framework-for-ios/>

Requirements: OSX10.7+ XCode4.4+ iOS5.0+


__integrating openCV and C++ with objective-C__
           

This is a sample application using openCV in iOS. It adapts the "squares.cpp" sample code included with the openCV distribution.
<https://github.com/Itseez/opencv/blob/master/samples/cpp/squares.cpp>

Prompted from a question on stack overflow:

<http://stackoverflow.com/questions/13958321/iosretrieve-rectangle-shaped-image-from-the-background-image?lq=1>

=======================

The aim is to keep the original c++ code as pristine as possible, and to keep the bulk of the work with openCV in pure c++ files for (im)portability.

__CVViewController.h / CVViewController.m__

- pure Objective-C

- communicates with openCV c++ code via a WRAPPER... it neither knows nor cares that c++ is processing these method calls behind the wrapper.

__CVWrapper.h / CVWrapper.mm__

- objective-C++

does as little as possible, really only two things...

- calls to UIImage objC++ categories to convert to and from UIImage <> cv::Mat
- mediates between CVViewController's obj-C methods and CVSquares c++ (class) function calls
  
 
__CVSquares.h /  CVSquares.cpp__  

- pure C++
- `CVSquares.cpp` declares public functions inside a class definition (in this case, one static function).   
This replaces the work of  `main{}` in the original file.
-  We try to keep `CVSquares.cpp` as close as possible to the C++ original for portability.

	
__UIImage+OpenCV__
    
This UIImage category is an objC++  file containing the code to convert between UIImage and cv::Mat image formats. 

