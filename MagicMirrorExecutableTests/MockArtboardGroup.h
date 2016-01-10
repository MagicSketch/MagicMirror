//
//  MockArtboardGroup.h
//  MagicMirror2
//
//  Created by James Tang on 11/1/2016.
//  Copyright © 2016 James Tang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSArtboardGroup.h"

@interface MockArtboardGroup : NSObject <MSArtboardGroup>

@property (copy, nonatomic) NSString *name;

@end
