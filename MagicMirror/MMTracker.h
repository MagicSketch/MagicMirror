//
//  MMTracker.h
//  MagicMirror2
//
//  Created by James Tang on 11/1/2016.
//  Copyright © 2016 James Tang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MMTracker <NSObject>

- (void)track:(NSString *)event;

@end

@interface MMTracker : NSObject <MMTracker>


@end
