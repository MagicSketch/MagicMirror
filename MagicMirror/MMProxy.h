//
//  MMEventHandler.h
//  MagicMirror2
//
//  Created by James Tang on 8/1/2016.
//  Copyright © 2016 James Tang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMProxy <ObjectType> : NSProxy

@property (nonatomic, strong) ObjectType target;

+ (instancetype)proxyWithTarget:(id)target;
- (id)init;

@end
