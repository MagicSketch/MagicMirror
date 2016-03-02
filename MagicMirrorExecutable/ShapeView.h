//
//  ShapeView.h
//  MagicMirror2
//
//  Created by James Tang on 29/2/2016.
//  Copyright © 2016 James Tang. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ShapeView : NSView IB_DESIGNABLE

@property (nonatomic, strong) NSBezierPath *path;
@property (nonatomic, strong) NSImage *image;

@end
