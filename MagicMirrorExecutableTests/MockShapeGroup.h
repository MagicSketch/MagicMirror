//
//  MockShapeGroup.h
//  MagicMirror2
//
//  Created by James Tang on 11/1/2016.
//  Copyright © 2016 James Tang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSShapeGroup.h"

@interface MockShapeGroup : NSObject <MSShapeGroup>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSArray *layers;
@property (nonatomic, copy) NSBezierPath *bezierPathInBounds;
@property (nonatomic) NSRect bounds;
@property (nonatomic) BOOL isFlippedHorizontal;
@property (nonatomic, strong) MSStyle *style;

@end
