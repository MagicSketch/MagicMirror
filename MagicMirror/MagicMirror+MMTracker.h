//
//  MagicMirror+MMTracker.h
//  MagicMirror2
//
//  Created by James Tang on 11/1/2016.
//  Copyright © 2016 James Tang. All rights reserved.
//

#import "MagicMirror.h"
#import "MMTracker.h"

@interface MagicMirror (MMTracker) <MMTracker>

- (void)trackSelectionEvent:(NSString *)event;
- (void)trackFullPageEvent:(NSString *)event;

@end
