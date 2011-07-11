//
//  LBSegmentedButton.m
//  LamojiPreferences
//
//  Created by Laurin Brandner on 01.06.11.
//  Copyright 2011 Larcus. All rights reserved.
//

#import "LBSegmentedButton.h"

#define DEFAULT_cellHeight 35
#define DEFAULT_borderColor [NSColor colorWithCalibratedRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0]
#define DEFAULT_radius 5

#define shadowColor [NSColor colorWithCalibratedRed:251.0/255.0 green:251.0/255.0 blue:251.0/255.0 alpha:1.0]
#define lightTextColor [NSColor colorWithCalibratedRed:186.0/255.0 green:168.0/255.0 blue:168.0/255.0 alpha:1.0]
#define darkTextColor [NSColor colorWithCalibratedRed:88.0/255.0 green:88.0/255.0 blue:88.0/255.0 alpha:1.0]
#define highlightColor [NSColor colorWithCalibratedRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0]

#define gradientColor1 [NSColor colorWithCalibratedRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0]
#define gradientColor2 [NSColor colorWithCalibratedRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0]

NSInteger previouslySelectedSegment = -1;

@implementation LBSegmentedButton

@synthesize borderColor, cellHeight, radius, data, target;

#pragma mark Accessors

-(NSInteger)selectedSegment {
    return selectedSegment;
}

-(void)setSelectedSegment:(NSInteger)value {
    if (selectedSegment != value) {
        selectedSegment = value;
        [self setNeedsDisplay:YES];
    }
}

-(NSInteger)numberOfCells {
    if (self.data) {
        return [self.data count];
    }
    return 0;
}

#pragma mark -
#pragma mark Initialization

-(id)initWithFrame:(NSRect)frameRect titles:(NSArray *)allTitles selectors:(NSArray *)allSelectors target:(id)targetValue {
    self = [super initWithFrame:frameRect];
    if (self) {
        self.data = [NSDictionary dictionaryWithObjects:allSelectors forKeys:allTitles];
        self.target = targetValue;
        
        self.selectedSegment = -1;
        
        //set default drawing info
        self.borderColor = DEFAULT_borderColor;
        self.cellHeight = DEFAULT_cellHeight;
        self.radius = DEFAULT_radius;
    }
    return self;
}

-(id)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    if (self) {
        self.data = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"buttonClicked:",@"buttonClicked:",@"buttonClicked:", nil] forKeys:[NSArray arrayWithObjects:@"!", @"YOURSELF", @"CHECK", nil]];
        self.target = nil;
        
        self.selectedSegment = -1;
        
        //set default drawing info
        self.borderColor = DEFAULT_borderColor;
        self.cellHeight = DEFAULT_cellHeight;
        self.radius = DEFAULT_radius;
        
        if (NSHeight(frameRect) != [self numberOfCells] * (self.cellHeight +2)+1) {
            NSLog(@"The height doesn't match to the cellHeight. The proper height would be %ld", [self numberOfCells] * (self.cellHeight +2)+1);
        }
        
    }
    return self;
}

#pragma mark -
#pragma mark Memory

-(void)dealloc {
    self.borderColor = nil;
    self.data = nil;
    self.target = nil;
    
    [super dealloc];
}

#pragma mark -
#pragma mark Lifecycle

-(void)awakeFromNib {
    [self drawTitles];
}

#pragma mark -
#pragma mark Drawing

-(void)drawTitles {
    int i = 0;
    for (NSString* title in self.data.allKeys) {
        NSTextField* label = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, NSWidth(self.bounds), 17)];
        
        long centerDistance = (self.cellHeight -17)/2;
        long borders = (i+1)*2;
        
        [label setBordered:NO];
        [label setDrawsBackground:NO];
        [label setSelectable:NO];
        [label setEditable:NO];
        [label setAlignment:NSCenterTextAlignment];
        [label setTextColor:darkTextColor];
        
        [label setStringValue:title];
        [label setFrameOrigin:NSMakePoint(0, borders+ centerDistance + i*self.cellHeight)];
        
        [self addSubview:label];
        [label release];
        i++;
    }
}

-(void)drawCell:(RoundedRectPartType)type rect:(NSRect)rect index:(NSInteger)index {
    CGContextRef context = (CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
    
    CGFloat maxX = NSMaxX(rect);
    CGFloat minX = NSMinX(rect);
    CGFloat minY = NSMinY(rect);
    
    if (type == bottomPart) {
        
        //Bottom shadow
        CGMutablePathRef bottomShadow = CGPathCreateMutable();
        
        CGPathMoveToPoint(bottomShadow, NULL, minX, minY+self.radius);
        
        CGPathAddQuadCurveToPoint(bottomShadow, NULL, minX, minY, minX+self.radius , minY); //90degrees curve (left bottom)
        CGPathAddLineToPoint(bottomShadow, NULL, maxX-self.radius, minY);
        CGPathAddQuadCurveToPoint(bottomShadow, NULL, maxX, minY, maxX, self.radius); //90degrees curve (right bottom)
        
        [shadowColor setStroke];
        CGContextAddPath(context, bottomShadow);
        CGContextDrawPath(context, kCGPathStroke);
         
        //Box
        
        minY++;
        
        CGMutablePathRef box = CGPathCreateMutable();
    
        CGPathMoveToPoint(box, NULL, minX, self.cellHeight+3);
        CGPathAddLineToPoint(box, NULL, minX, minY+self.radius);
        CGPathAddQuadCurveToPoint(box, NULL, minX, minY, minX+self.radius , minY); //90degrees curve (left bottom)
        CGPathAddLineToPoint(box, NULL, maxX-self.radius, minY);
        CGPathAddQuadCurveToPoint(box, NULL, maxX, minY, maxX, minY+self.radius); //90degrees curve (right bottom)
        CGPathAddLineToPoint(box, NULL, maxX, self.cellHeight+3);
        
        CGContextAddPath(context, box);
        
        [self.borderColor setStroke];
        if (self.selectedSegment == index) {
            [highlightColor setFill];
            CGContextDrawPath(context, kCGPathFillStroke);
        }
        else {
            CGContextDrawPath(context, kCGPathStroke);
        }
        
        CGPathRelease(box);
        CGPathRelease(bottomShadow);
    }
    else if (type == middlePart) {
        
        //Box
        
        CGMutablePathRef box = CGPathCreateMutable();
        
        CGPathMoveToPoint(box, NULL, minX, minY+3+self.cellHeight);
        CGPathAddLineToPoint(box, NULL, minX, minY+1);
        CGPathAddLineToPoint(box, NULL, maxX, minY+1);
        CGPathAddLineToPoint(box, NULL, maxX, minY+self.cellHeight+3);
        
        CGContextAddPath(context, box);
        
        [self.borderColor setStroke];
        if (self.selectedSegment == index) {
            [highlightColor setFill];
            CGContextDrawPath(context, kCGPathFillStroke);
        }
        else {
            CGContextDrawPath(context, kCGPathStroke);
        }
        
        //Seperator shadow
        
        CGMutablePathRef shadow = CGPathCreateMutable();
        
        CGPathMoveToPoint(shadow, NULL, minX+1, minY);
        CGPathAddLineToPoint(shadow, NULL, maxX-1, minY);
        
        if (self.selectedSegment+1==index) {
            [highlightColor setStroke];
        }
        else {
            [shadowColor setStroke];
        }
        
        CGContextAddPath(context, shadow);
        CGContextDrawPath(context, kCGPathStroke);
        
        CGPathRelease(box);
        CGPathRelease(shadow);
    }
    else {
        
        //Box
        
        CGMutablePathRef box = CGPathCreateMutable();
        
        CGPathMoveToPoint(box, NULL, minX, minY+1);
        CGPathAddLineToPoint(box, NULL, maxX, minY+1);
        CGPathAddLineToPoint(box, NULL, maxX, minY+self.cellHeight-self.radius+2);
        CGPathAddQuadCurveToPoint(box, NULL, maxX, minY+self.cellHeight+2, maxX-self.radius, minY+self.cellHeight+2);
        CGPathAddLineToPoint(box, NULL, minX+self.radius, minY+self.cellHeight+2);
        CGPathAddQuadCurveToPoint(box, NULL, minX, minY+self.cellHeight+2, minX, minY+self.cellHeight-self.radius+2);
        CGPathAddLineToPoint(box, NULL, minX, minY+1);
        CGPathCloseSubpath(box);
        
        CGContextAddPath(context, box);
        
        [self.borderColor setStroke];
        if (self.selectedSegment == index) {
            [highlightColor setFill];
            CGContextDrawPath(context, kCGPathFillStroke);
        }
        else {
            CGContextDrawPath(context, kCGPathStroke);
        }
        
        //Seperator shadow
        
        CGMutablePathRef shadow = CGPathCreateMutable();
        
        CGPathMoveToPoint(shadow, NULL, minX+1, minY);
        CGPathAddLineToPoint(shadow, NULL, maxX-1, minY);
        
        if (self.selectedSegment+1==index) {
            [highlightColor setStroke];
        }
        else {
            [shadowColor setStroke];
        }
        
        CGContextAddPath(context, shadow);
        CGContextDrawPath(context, kCGPathStroke);
        
        CGPathRelease(box);
        CGPathRelease(shadow);
    }
}

-(void)drawBackground {
    NSBezierPath* clipPath = [NSBezierPath bezierPathWithRoundedRect:self.bounds xRadius:self.radius yRadius:self.radius];
    NSGradient* gradient = [[[NSGradient alloc] initWithStartingColor:gradientColor1 endingColor:gradientColor2] autorelease];
    [gradient drawInBezierPath:clipPath angle:90.0f];
}

-(void)drawRect:(NSRect)dirtyRect {
    [self drawBackground];
    for (int i = 0; i<= [self numberOfCells]-1; i++) {
        //If it is the bottom
        if (i == 0) {
            [self drawCell:bottomPart rect:NSInsetRect(NSMakeRect(0, 0, NSWidth(self.bounds), self.cellHeight+2), 0.5, 0.5) index:i];
        }
        else if (i== [self numberOfCells]-1) {
            [self drawCell:topPart rect:NSInsetRect(NSMakeRect(0, (self.cellHeight+2)*i, NSWidth(self.bounds), self.cellHeight+2), 0.5, 0.5) index:i];
        }
        else {
            [self drawCell:middlePart rect:NSInsetRect(NSMakeRect(0, (self.cellHeight+2)*i, NSWidth(self.bounds), self.cellHeight+2), 0.5, 0.5) index:i];
        }
    }
}

#pragma mark -
#pragma mark Mouse Interaction

-(void)mouseDown:(NSEvent *)theEvent {
    [super mouseDown:theEvent];
    NSPoint locationInWindow = [theEvent locationInWindow];
    NSPoint location = [self convertPoint:locationInWindow fromView:[self.window contentView]];
    
    for (int i = 0; i<[self numberOfCells]; i++) {
        if (CGRectContainsPoint(CGRectMake(0, i*(self.cellHeight+3), NSWidth(self.bounds), self.cellHeight+3), NSPointToCGPoint(location)) ) {
            self.selectedSegment = i;
            previouslySelectedSegment = i;
        }
    }
}

-(void)mouseDragged:(NSEvent *)theEvent {
    NSPoint locationInWindow = [theEvent locationInWindow];
    NSPoint location = [self convertPoint:locationInWindow fromView:[self.window contentView]];
    
    self.selectedSegment = (CGRectContainsPoint(self.bounds, NSPointToCGPoint(location))) ? previouslySelectedSegment : -1;
}

-(void)mouseUp:(NSEvent *)theEvent {
    [super mouseUp:theEvent];
    
    NSPoint locationInWindow = [theEvent locationInWindow];
    NSPoint location = [self convertPoint:locationInWindow fromView:[self.window contentView]];
    
    if (CGRectContainsPoint(self.bounds, NSPointToCGPoint(location))) {
        NSArray* allValues = self.data.allValues;
        NSString* sel = [allValues objectAtIndex:self.selectedSegment];
        SEL selector = NSSelectorFromString(sel);
        
        if ([self.target respondsToSelector:selector]) {
            [self.target performSelector:selector withObject:self];
        }
    }
    
    self.selectedSegment = -1;
    previouslySelectedSegment = -1;
}

#pragma mark -

@end
