//
//  CVWrapper.h
//  CVOpenTemplate
//
//  Created by foundry on 02/01/2013.
//  Copyright (c) 2013 foundry. All rights reserved.
//
//  Permission is given to use this source code file without charge in any
//  project, commercial or otherwise, entirely at your risk, with the condition
//  that any redistribution (in part or whole) of source code must retain
//  this copyright and permission notice. Attribution in compiled projects is
//  appreciated but not required.
//

#import <Foundation/Foundation.h>

@interface CVWrapper : NSObject

+ (UIImage*) detectedSquaresInImage:(UIImage*) image;

+ (UIImage*) detectedSquaresInImage:(UIImage*) image
                          tolerance:(CGFloat)tolerance
                          threshold:(NSInteger)threshold
                             levels:(NSInteger)levels;

@end
