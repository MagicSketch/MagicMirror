//
//  Sketch.m
//  MagicMirror2
//
//  Created by James Tang on 27/1/2016.
//  Copyright © 2016 James Tang. All rights reserved.
//

#import "Sketch.h"
#import <Foundation/Foundation.h>
#import "MSImmutablePage.h"

@interface NSObject (Sketch35)

// MSExportRequest
- (void)setImmutablePage:(MSImmutablePage *)page;

// MSExportRendererWithSVGSupport
+ (id)exporterForRequest:(id)arg1 colorSpace:(id)arg2 allowSubpixelAntialiasing:(BOOL)arg3;

@end


@interface NSObject (Sketch36)

// MSExportRendererWithSVGSupport
+ (id)exporterForRequest:(id)arg1 colorSpace:(id)arg2;

@end


@implementation Sketch

+ (id <MSExportRenderer>)exportRendererForRequest:(id <MSExportRequest>)request colorSpace:(NSColorSpace *)colorSpace {

    id renderer = nil;

    if (NSClassFromString(@"MSExportRenderer")) {
        renderer = [NSClassFromString(@"MSExportRenderer") exportRendererForRequest:request colorSpace:colorSpace];
    } else if (NSClassFromString(@"MSExportRendererWithSVGSupport")) {
      Class exporterClass = NSClassFromString(@"MSExportRendererWithSVGSupport");
      if ([exporterClass respondsToSelector:@selector(exporterForRequest:colorSpace:)]) {
        renderer = [NSClassFromString(@"MSExportRendererWithSVGSupport") exporterForRequest:request colorSpace:colorSpace];
      } else if ([exporterClass respondsToSelector:@selector(exporterForRequest:colorSpace:allowSubpixelAntialiasing:)]) {
        renderer = [NSClassFromString(@"MSExportRendererWithSVGSupport") exporterForRequest:request colorSpace:colorSpace allowSubpixelAntialiasing:YES];
      }
    }
    return renderer;
}

+ (id <MSExportRequest>)requestWithRect:(NSRect)rect scale:(CGFloat)scale {
    return [NSClassFromString(@"MSExportRequest") requestWithRect:rect scale:scale];
}

+ (void)setPage:(MSPage *)page forRequest:(NSObject <MSExportRequest>*)request {
    if ([request respondsToSelector:@selector(setPage:)]) {
        [request setPage:page];
    } else {
        [request setImmutablePage:[page immutableModelObject]];
    }
}

@end
