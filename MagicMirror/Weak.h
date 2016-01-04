//
//  Weak.h
//  MagicMirror2
//
//  Created by James Tang on 4/1/2016.
//  Copyright © 2016 James Tang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Weak : NSObject

@property (weak) id object;

+ (instancetype)weakWithObject:(id)object;

@end
