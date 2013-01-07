    //
    //  CVViewController.m
    //  CVOpenTemplate
    //
    //  Created by Washe on 02/01/2013.
    //  Copyright (c) 2013 Washe / Foundry. All rights reserved.
    //
    //  Permission is given to use this source code file without charge in any
    //  project, commercial or otherwise, entirely at your risk, with the condition
    //  that any redistribution (in part or whole) of source code must retain
    //  this copyright and permission notice. Attribution in compiled projects is
    //  appreciated but not required.
    //

#import "CVViewController.h"
#import "CVWrapper.h"

#define IMAGE_NAME @"testimage3.jpg"

@interface CVViewController () 
@property (nonatomic, strong) UIImage* image;
- (void) modifyImage;
- (void) adjustTolerance;
- (void) adjustLevels;
- (void) adjustThreshold;
- (void) toggleControlsView;
- (BOOL) controlsAreVisible;
- (void) layoutScrollView;
- (void) layoutControls;
- (void) centerScrollViewContents;
@end

@implementation CVViewController

@synthesize image = _image;


    //views
@synthesize imageView = _imageView;
@synthesize scrollView = _scrollView;

@synthesize controlsView = _controlsView;
@synthesize spinner = _spinner;


    //sliders
@synthesize tolerance = _tolerance;

@synthesize toleranceSlider = _toleranceSlider;
@synthesize toleranceLabel = _toleranceLabel;

@synthesize levels = _levels;

@synthesize levelsSlider = _levelsSlider;
@synthesize levelsLabel = _levelsLabel;

@synthesize threshold = _threshold;

@synthesize thresholdSlider = _thresholdSlider;
@synthesize thresholdLabel = _thresholdLabel;




#define SLIDER_PADDING 12.0f

#pragma mark - slider actions

- (IBAction)toleranceChanged:(UISlider*)sender {
    [self modifyImage];
}

- (IBAction)toleranceTouchDragInside:(id)sender {
    [self adjustTolerance];
}

- (IBAction)levelsChanged:(UISlider*)sender {
    [self modifyImage];
}

- (IBAction)levelsTouchDragInside:(id)sender {
    [self adjustLevels];
}

- (IBAction)thresholdChanged:(UISlider*)sender {
    [self modifyImage];
}

- (IBAction)thresholdTouchDragInside:(id)sender {
    [self adjustThreshold];
}

- (void) adjustTolerance
{
    self.tolerance = sinf([self toleranceSlider].value*M_PI/180);
    self.toleranceLabel.text = [NSString stringWithFormat:@"%.0f", self.toleranceSlider.value];
}

- (void) adjustLevels
{
    self.levels = (int)floor(self.levelsSlider.value);
    self.levelsLabel.text = [NSString stringWithFormat:@"%d", self.levels];
}

- (void) adjustThreshold
{
    self.threshold = (int)floor(self.thresholdSlider.value);
    self.thresholdLabel.text = [NSString stringWithFormat:@"%d", self.threshold];
}

- (void) setSpinnerLocation:(UISlider*)slider
{
    UILabel* label =
    ([slider isEqual:self.toleranceSlider])? self.toleranceLabel:
    ([slider isEqual:self.levelsSlider])? self.levelsLabel:
    ([slider isEqual:self.thresholdSlider])? self.thresholdLabel:nil;
    
    
    CGFloat valueWidth = slider.maximumValue -  slider.minimumValue;
    CGFloat valueRatio = ([label.text intValue]- slider.minimumValue)/valueWidth;
    CGFloat originX = valueRatio*(slider.bounds.size.width-2*SLIDER_PADDING)
    
    + slider.frame.origin.x
    + SLIDER_PADDING;
    CGFloat centerX = originX;
    
    CGFloat centerY = slider.center.y;
    self.spinner.center = CGPointMake (centerX, centerY);
    
}


- (void) modifyImage
{
    METHOD_LOG_CLASS;
    [self.spinner startAnimating];
#ifndef VERSION_SL
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
#endif
        UIImage* myImage =
        [CVWrapper detectedSquaresInImage:self.image
                                tolerance:self.tolerance
                                threshold:self.threshold
                                   levels:self.levels];
#ifndef VERSION_SL
        dispatch_async(dispatch_get_main_queue(), ^{
#endif
            self.imageView.image = myImage;
            [self.spinner stopAnimating];
#ifndef VERSION_SL
        });
    });
#endif
    
}



- (IBAction)imageTapped:(UITapGestureRecognizer*)sender
{
    CGPoint tapLocationInSelfView = [sender locationInView:self.view];
    
    if (!CGRectContainsPoint(self.controlsView.frame
                             , tapLocationInSelfView)) {
        [self toggleControlsView];
    }
}

- (void) toggleControlsView
{
    METHOD_LOG_CLASS;
        //FRAME is unreliable on rotation
        //SELF.VIEW.FRAME does not change on rotation
        //SELF.VIEW.CENTER likewise
        //use bounds for calculation wherever possible
        //then center
    self.controlsView.center = CGPointMake( self.view.bounds.size.width/2
                                           ,self.controlsView.center.y);
    CGPoint center = CGPointZero;
    if ([self controlsAreVisible]) {
        center = CGPointMake(self.view.bounds.size.width/2
                             ,self.view.bounds.size.height + self.controlsView.bounds.size.height/2);
    } else {
        center = CGPointMake (self.view.bounds.size.width/2
                              ,self.view.bounds.size.height - self.controlsView.bounds.size.height/2);
    }
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    [UIView setAnimationDelay:0.0];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    self.controlsView.center = center;
    [UIView commitAnimations];
}

- (void) toggleControlsView:(NSTimer*)theTimer
{
    [self toggleControlsView];
}


#pragma mark - setup and takedown

- (void) viewDidLoad
{
    METHOD_LOG_CLASS;
    
    [super viewDidLoad];
    UITapGestureRecognizer* tapGR =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(imageTapped:)];
    [self.view addGestureRecognizer:tapGR];
    
    self.image = [UIImage imageNamed:IMAGE_NAME];
}



- (void)viewWillAppear:(BOOL)animated
{
    METHOD_LOG_CLASS;
    [super viewWillAppear:animated];
    
    self.imageView.image = self.image;
    
    self.imageView.bounds =
    CGRectMake(0,0,self.image.size.width,self.image.size.height);
    [self layoutScrollView];
    [self layoutControls];
    [self adjustThreshold];
    [self adjustTolerance];
    [self adjustLevels];
    
}

- (void) viewDidAppear:(BOOL)animated
{
    METHOD_LOG_CLASS;
    [super viewDidAppear:animated];
    [self modifyImage];
    [NSTimer scheduledTimerWithTimeInterval:0.5
                                     target:self
                                   selector:@selector(toggleControlsView:)
                                   userInfo:nil
                                    repeats:NO];
}

- (void) layoutScrollView
{
    METHOD_LOG_CLASS;
    
    [self.scrollView setFrame:self.view.bounds];
    self.scrollView.contentSize = self.imageView.bounds.size;
    CGFloat zoomScale;
    if (self.imageView.image.size.width/self.imageView.image.size.height >
        self.scrollView.bounds.size.width/self.scrollView.bounds.size.height) {
            //if image is more landscape than scrollview; size to scrollview width
        zoomScale = self.scrollView.bounds.size.width/self.imageView.bounds.size.width;
    } else {
            //image is more portrait than scrollview; size to scrollview height
        zoomScale = self.scrollView.bounds.size.height/self.imageView.bounds.size.height;
    }
    self.scrollView.zoomScale = zoomScale;
    self.scrollView.maximumZoomScale = zoomScale*4;
    self.scrollView.minimumZoomScale = zoomScale/4;
    [self centerScrollViewContents];
    
}

- (void) layoutControls
{
    return;
}

- (BOOL) controlsAreVisible
{
    BOOL result = NO;
    if (CGRectIntersectsRect(self.controlsView.frame, self.view.bounds)) {
        result = YES;
    } else {
        result = NO;
    }
    return result;
}


- (void)centerScrollViewContents {
    METHOD_LOG_CLASS;
    CGSize      scrollSize = self.scrollView.bounds.size;
    CGPoint   scrollCenter = self.scrollView.center;
    CGRect  contentsBounds = self.imageView.bounds;
    CGPoint contentsCenter = self.imageView.center;
    CGFloat      zoomScale = self.scrollView.zoomScale;
    if (contentsBounds.size.width*zoomScale < scrollSize.width) {
        contentsCenter.x = scrollCenter.x;
    }
    if (contentsBounds.size.height*zoomScale < scrollSize.height) {
        contentsCenter.y = scrollCenter.y;
    }
    self.imageView.center = contentsCenter;
}


- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    METHOD_LOG_CLASS;
    [self layoutScrollView];
    [self layoutControls];
}


//- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
//{
//        //don't rotate for iphone, camera screws up;
//        //if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
//        return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
//        //else return YES;
//}


#pragma mark - scroll view delegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    [self centerScrollViewContents];
}


@end


