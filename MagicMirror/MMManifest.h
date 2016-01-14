//
//  MMManifestParser.h
//  MagicMirror2
//
//  Created by James Tang on 14/1/2016.
//  Copyright © 2016 James Tang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMManifest : NSObject

@property (nonatomic, copy) NSString *version;
@property (nonatomic, copy) NSString *checkURL;
@property (nonatomic, copy) NSString *name;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
