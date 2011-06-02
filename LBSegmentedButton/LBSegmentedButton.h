//
//  LBSegmentedButton.h
//  LamojiPreferences
//
//  Created by Laurin Brandner on 01.06.11.
//  Copyright 2011 Larcus. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef enum _RoundedRectPartType {
    middlePart = 0,
    topPart = 1,
    bottomPart = 2
}RoundedRectPartType;

@interface LBSegmentedButton : NSView {
    
    //Drawing Infos
    NSArray* titles;
    NSInteger cellHeight;
    NSInteger radius;
    NSColor* borderColor;
    
    //Button Infos
    id target;
    NSInteger selectedSegment;
}

@property (readwrite, copy) NSArray* titles;
@property (readwrite) NSInteger cellHeight;
@property (readwrite) NSInteger radius;
@property (readwrite, copy) NSColor* borderColor;

@property (readwrite, retain) IBOutlet id target;
@property (readwrite) NSInteger selectedSegment;

-(id)initWithFrame:(NSRect)frameRect titles:(NSArray*)bottomUpTitles target:(id)target;

-(NSInteger)numberOfCells;

-(void)drawBackground;
-(void)drawCell:(RoundedRectPartType)type rect:(NSRect)rect index:(NSInteger)index;
-(void)drawTitles;

@end
