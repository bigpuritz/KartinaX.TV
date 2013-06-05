//
// Created by mk on 04.06.13.
// Copyright (c) 2013 Maxim Kalina. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "ScopeBarView.h"

#define SCOPE_BAR_START_COLOR_GRAY        [NSColor colorWithCalibratedWhite:0.75 alpha:1.0]                        // bottom color of gray gradient
#define SCOPE_BAR_END_COLOR_GRAY        [NSColor colorWithCalibratedWhite:0.90 alpha:1.0]                        // top color of gray gradient
#define SCOPE_BAR_BORDER_COLOR            [NSColor colorWithCalibratedWhite:0.5 alpha:1.0]                        // bottom line's color

@implementation ScopeBarView {

}


- (void)drawRect:(NSRect)dirtyRect; {
    // Draw gradient background
    NSGradient *gradient = [[NSGradient alloc] initWithStartingColor:SCOPE_BAR_START_COLOR_GRAY
                                                         endingColor:SCOPE_BAR_END_COLOR_GRAY];
    [gradient drawInRect:self.bounds angle:90.0];

    // Draw border
    NSRect lineRect = NSMakeRect(0, 0, self.bounds.size.width, 1);
    [SCOPE_BAR_BORDER_COLOR set];
    NSRectFill(lineRect);

}


@end