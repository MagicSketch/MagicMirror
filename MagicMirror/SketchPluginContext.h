//
//  SketchContext.h
//  MagicMirror2
//
//  Created by James Tang on 8/12/2015.
//  Copyright © 2015 James Tang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CDUnknownBlockType.h"
#import "Sketch.h"

@interface SketchPluginContext : NSObject

@property (nonatomic) BOOL shouldKeepAround;

- (id)initWithPlugin:(MSPluginBundle *)plugin
            document:(MSDocument *)document
           selection:(NSArray *)selection
             command:(MSPluginCommand *)command;

@end
