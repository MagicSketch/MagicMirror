//
//  MMVersionChecker-Private.h
//  MagicMirror2
//
//  Created by James Tang on 15/1/2016.
//  Copyright © 2016 James Tang. All rights reserved.
//

#import "MMVersionChecker.h"

@interface MMVersionChecker (Private)

- (void)skipThisVersion;
- (void)remindLater;
- (void)download;

@end
