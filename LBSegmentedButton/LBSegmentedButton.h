//
//  LBSegmentedButton.h
//  LamojiPreferences
//
//  Created by Laurin Brandner on 01.06.11.
//  Copyright 2011 Larcus. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface LBSegmentedButton : NSView {
    
    //Drawing Infos
    NSDictionary* data;
    NSInteger cellHeight;
    NSInteger radius;
    NSColor* borderColor;
    
    //Button Infos
    id target;
    NSInteger selectedSegment;
}

@property (readwrite, copy) NSDictionary* data;
@property (readwrite) NSInteger cellHeight;
@property (readwrite) NSInteger radius;
@property (readwrite, copy) NSColor* borderColor;

@property (readwrite, retain) IBOutlet id target;
@property (readwrite) NSInteger selectedSegment;

-(id)initWithFrame:(NSRect)frameRect titles:(NSArray*)titles selectors:(NSArray*)selectorsAsStrings target:(id)target;

-(NSInteger)numberOfCells;

-(void)drawBase;
-(void)drawCellInRect:(NSRect)rect index:(NSInteger)index;
-(void)drawTitleWithIndex:(NSInteger)index;

@end
