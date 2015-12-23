//
//  MMWindow.m
//  MagicMirror2
//
//  Created by James Tang on 23/12/2015.
//  Copyright © 2015 James Tang. All rights reserved.
//

#import "MMWindow.h"

@implementation MMWindow

- (id)initWithContentRect:(NSRect)contentRect
                styleMask:(NSUInteger)aStyle
                  backing:(NSBackingStoreType)bufferingType
                    defer:(BOOL)flag
{
    self = [super initWithContentRect:contentRect
                            styleMask:aStyle
                              backing:bufferingType
                                defer:flag];
    if (self) {
        [self setOpaque:NO];
        [self setBackgroundColor:[NSColor clearColor]];
        [self setMovableByWindowBackground:YES];
        [self setStyleMask:NSResizableWindowMask];
    }
    return self;
}

- (void) setContentView:(NSView *)aView
{
    aView.wantsLayer            = YES;
    aView.layer.frame           = aView.frame;
    aView.layer.cornerRadius    = 5.0;
    aView.layer.masksToBounds   = YES;

    [super setContentView:aView];
}

@end
