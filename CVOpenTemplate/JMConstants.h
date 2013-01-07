//
//  JMConstants.h
//
//  Created by jonathan on 07/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//   http://stackoverflow.com/questions/338195/global-variables-in-cocoa-objective-c

    #define METHOD_LOG_THREAD (NSLog(@"%@ %@ %s\n%@", \
    NSStringFromSelector(_cmd), \
    [NSThread currentThread], \
    __FILE__, self))

    #define METHOD_LOG (NSLog(@"method: %@", NSStringFromSelector(_cmd)))

    #define METHOD_LOG_CLASS (NSLog(@"%30.s -|- %-30.s", [[[self class] description] UTF8String], [NSStringFromSelector(_cmd) UTF8String]))

    #define METHOD_LOG_CALLER (NSLog(@"sender: %@",[[[NSThread callStackSymbols] objectAtIndex:1] substringWithRange:NSMakeRange([[[NSThread callStackSymbols] objectAtIndex:1] rangeOfString:@"["].location-1,([[[NSThread callStackSymbols] objectAtIndex:1] rangeOfString:@"]"].location-[[[NSThread callStackSymbols] objectAtIndex:1] rangeOfString:@"["].location+2))]))








