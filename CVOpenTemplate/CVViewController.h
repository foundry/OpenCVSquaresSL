//
//  CVViewController.h
//  CVOpenTemplate
//
//  Created by Washe on 02/01/2013.
//  Copyright (c) 2013 Red Art Foundry. All rights reserved.
//
//  Permission is given to use this source code file without charge in any
//  project, commercial or otherwise, entirely at your risk, with the condition
//  that any redistribution (in part or whole) of source code must retain
//  this copyright and permission notice. Attribution in compiled projects is
//  appreciated but not required.
//

#import <UIKit/UIKit.h>
#import "CVImagePickerSegmentedControl.h"

@interface CVViewController : UIViewController
<UINavigationControllerDelegate,
UIScrollViewDelegate,
UIImagePickerControllerDelegate,
CVImagePickerSegmentedControlDelegate,
UIPopoverControllerDelegate>


    //views
@property (weak, nonatomic) IBOutlet UIScrollView* scrollView;
@property (weak, nonatomic) IBOutlet UIImageView* imageView;
@property (weak, nonatomic) IBOutlet UIView *controlsView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView* spinner;



    //sliders
@property (assign) CGFloat tolerance;

@property (weak, nonatomic) IBOutlet UISlider *toleranceSlider;
@property (weak, nonatomic) IBOutlet UILabel *toleranceLabel;
- (IBAction)toleranceChanged:(id)sender;
- (IBAction)toleranceTouchDragInside:(id)sender;

@property (assign) int levels;

@property (weak, nonatomic) IBOutlet UISlider *levelsSlider;
@property (weak, nonatomic) IBOutlet UILabel *levelsLabel;
- (IBAction)levelsChanged:(id)sender;
- (IBAction)levelsTouchDragInside:(id)sender;

@property (assign) int threshold;

@property (weak, nonatomic) IBOutlet UISlider *thresholdSlider;
@property (weak, nonatomic) IBOutlet UILabel *thresholdLabel;
- (IBAction)thresholdChanged:(id)sender;
- (IBAction)thresholdTouchDragInside:(id)sender;



@end
