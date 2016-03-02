//
//  ShapeView.m
//  MagicMirror2
//
//  Created by James Tang on 29/2/2016.
//  Copyright © 2016 James Tang. All rights reserved.
//

#import "ShapeView.h"
#import "NSImage+Transform.h"

@interface ShapeView ()

@end

@implementation ShapeView

- (instancetype)initWithFrame:(NSRect)frameRect {

  self = [super initWithFrame:frameRect];
  if (self) {
    [self commonInit];
  }
  return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
  self = [super initWithCoder:coder];
  if (self) {
    [self commonInit];
  }
  return self;
}

- (void)commonInit {
  NSBezierPath* bezierPath = [NSBezierPath bezierPath];
  [bezierPath moveToPoint: NSMakePoint(64.5, 3.5)];
  [bezierPath lineToPoint: NSMakePoint(10.5, 103.5)];
  [bezierPath lineToPoint: NSMakePoint(160.5, 191.5)];
  [bezierPath lineToPoint: NSMakePoint(190.5, 25.5)];
  [bezierPath lineToPoint: NSMakePoint(64.5, 3.5)];
  [bezierPath closePath];
  self.path = bezierPath;
}

- (BOOL)isFlipped {
  return YES;
}

- (void)drawRect:(NSRect)dirtyRect {
  NSBezierPath *bezierPath = _path;
  [NSColor.grayColor setFill];
  [bezierPath fill];
  [NSColor.blackColor setStroke];
  [bezierPath setLineWidth: 1];
  [bezierPath stroke];

  NSImage *image = [self.image imageForPath:bezierPath scale:1];
  NSLog(@"image %@", image);
  [image drawInRect:self.bounds];
}

-(void)setImage:(NSImage *)image {
  _image = image;
  [self setNeedsDisplayInRect:self.bounds];
}

@end
