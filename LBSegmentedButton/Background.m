//
//  Background.m
//  segmentedButton
//
//  Created by Laurin Brandner on 02.06.11.
//  Copyright 2011 Larcus. All rights reserved.
//

#import "Background.h"

@implementation Background

- (void)drawRect:(NSRect)dirtyRect
{
    [[NSColor colorWithCalibratedRed:230.0/255.0 green:230.0/255.0 blue:235.0/255.0 alpha:1.0] set];
    NSRectFill(dirtyRect);
}

@end
