//
//  CVImagePickerControl.m
//  OpenCVSquares
//
//  Created by jonathan on 06/01/2013.
//  Copyright (c) 2013 foundry. All rights reserved.
//

#import "CVImagePickerSegmentedControl.h"

@implementation CVImagePickerSegmentedControl

@synthesize delegate;

- (IBAction)pictureControl:(id)sender
{
    if ([sender selectedSegmentIndex]==0){
        [self setupImagePicker:UIImagePickerControllerSourceTypePhotoLibrary];
        
        NSLog (@"photo libarary selected");
    }else {
        NSLog (@"camera selected");
        [self setupImagePicker:UIImagePickerControllerSourceTypeCamera];
        
    }
}

- (id) initWithItems:(NSArray *)items  //designated initialiser
{
    self = [super initWithItems:items];
    if (self) {
            //defaults to override
        self.segmentedControlStyle = UISegmentedControlStyleBar;
        self.tintColor = [UIColor lightGrayColor];
        self.momentary = YES;
        [self addTarget:self
                 action:@selector(pictureControl:)
                 forControlEvents:UIControlEventValueChanged];
        _transitionStyle = UIModalTransitionStyleCoverVertical;
        _imagePickerControlsPresenting = YES;
        _imagePickerControlsDismissing = YES;
    }
    return self;
}

- (id)init
{
    return[self initWithItems:[NSArray arrayWithObjects:@"Picture library",@"Camera", nil]];
}




#pragma mark - ##### IMAGEPICKER #####

- (void) setupImagePicker:(UIImagePickerControllerSourceType)type
{
    UIImagePickerController* imagePicker = [[UIImagePickerController alloc] init];
    if (type == UIImagePickerControllerSourceTypeCamera
        && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        imagePicker.mediaTypes =[UIImagePickerController availableMediaTypesForSourceType:imagePicker.sourceType];
        [[self class] setCameraPrefs:imagePicker];
    } else {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        imagePicker.mediaTypes =[UIImagePickerController availableMediaTypesForSourceType:imagePicker.sourceType];

    }
    [imagePicker setDelegate:self];
        // imagePicker.modalPresentationStyle = UIModalPresentationPageSheet; // for iPad only
    imagePicker.modalTransitionStyle = self.transitionStyle; //default
                                                             //[self.delegate presentViewController:imagePicker];
    
    METHOD_LOG_CLASS;
    if (self.imagePickerControlsPresenting) {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self.delegate presentViewController:imagePicker
                           animated:YES
                         completion:nil];
    } else {
            // to do
        /*
         UIPopoverController *popOverController = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
         popOverController.delegate = self;
         
         
         [popOverController presentPopoverFromRect:self.view.frame
         inView:self.view
         permittedArrowDirections:UIPopoverArrowDirectionAny
         animated:YES];
         */
    }
    } else {
        [self.delegate presentViewController:imagePicker];
    }

    
}

#pragma mark - ##### IMAGEPICKER DELEGATE #####

- (void) imagePickerController:(UIImagePickerController *)picker
 didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    METHOD_LOG_CLASS;
    
    UIImage* image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if ([picker sourceType] == UIImagePickerControllerSourceTypeCamera) {
        UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
        [[self class] saveCameraPrefs:picker];
    }
    [self.delegate imagePickerImage:image];
    if (self.imagePickerControlsDismissing) {
        [self.delegate dismissViewControllerAnimated:YES
                                          completion:nil];
    } else {
        [self.delegate dismissViewController];
    }
}

#pragma mark - ##### CLASS UTILITY METHODS #####

#define DEFAULTS_FLASH_MODE @"FlashMode"
#define DEFAULTS_CAMERA_DEVICE @"CameraDevice"

+ (void)saveCameraPrefs:(UIImagePickerController*)picker
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* flashKey = [NSString stringWithFormat:@"%@%@",[self class],DEFAULTS_FLASH_MODE];
    NSString* deviceKey = [NSString stringWithFormat:@"%@%@",[self class],DEFAULTS_CAMERA_DEVICE];
    [defaults setInteger:[picker cameraFlashMode] forKey:flashKey];
    [defaults setInteger:[picker cameraDevice] forKey:deviceKey];
}



+ (void) setCameraPrefs:(UIImagePickerController*)imagePicker
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* flashKey = [NSString stringWithFormat:@"%@%@",[self class],DEFAULTS_FLASH_MODE];
    NSString* deviceKey = [NSString stringWithFormat:@"%@%@",[self class],DEFAULTS_CAMERA_DEVICE];
    
    
    if ([defaults integerForKey:flashKey]) {
        UIImagePickerControllerCameraFlashMode flashMode = [defaults integerForKey:flashKey];
        [imagePicker setCameraFlashMode:flashMode];
    }
    if ([defaults integerForKey:deviceKey]) {
        UIImagePickerControllerCameraDevice cameraDevice = [defaults integerForKey:deviceKey];
        [imagePicker setCameraDevice:cameraDevice];
    }
}
@end
