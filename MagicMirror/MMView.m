//
//  MMView.m
//  MagicMirror2
//
//  Created by James Tang on 23/12/2015.
//  Copyright © 2015 James Tang. All rights reserved.
//

#import "MMView.h"

@implementation MMView

-(instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    [self commonInit];
    return self;
}

- (void)commonInit {
    CALayer *viewLayer = [CALayer layer];
    [viewLayer setBackgroundColor:[NSColor controlColor].CGColor]; //RGB plus Alpha Channel
    [self setWantsLayer:YES]; // view's backing store is using a Core Animation Layer
    [self setLayer:viewLayer];
    self.acceptsTouchEvents = YES;
}


- (IBAction)closeButtonDidPress:(id)sender {
    //    [self close];
}
@end
