//
//  CVAppDelegate.m
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

#import "CVAppDelegate.h"
#import "CVViewController.h"
@implementation CVAppDelegate

@synthesize window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    
#ifdef FORMAT_XIB
    NSLog (@"XIB VERSION");
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    CVViewController *myViewController = [ [CVViewController alloc] initWithNibName:@"CVViewController_iPhone" bundle:nil ];
    self.window.rootViewController = myViewController;
    [self.window makeKeyAndVisible];
#else
    NSLog (@"STORYBOARD VERSION");
#endif
    return YES;
}
							


@end
