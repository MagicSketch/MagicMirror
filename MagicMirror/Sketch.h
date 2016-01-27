
#import "COScript.h"

#import "MSDocument.h"
#import "MSPluginCommand.h"
#import "MSPluginBundle.h"
#import "MSLayer.h"
#import "MSLayerFlattener.h"
#import "MSLayerArray.h"
#import "MSShapePath.h"
#import "MSPage.h"
#import "MSExportRenderer.h"
#import "MSExportRequest.h"

@interface Sketch : NSObject

+ (id <MSExportRenderer>)exportRendererForRequest:(id <MSExportRequest>)request colorSpace:(NSColorSpace *)colorSpace;
+ (id <MSExportRequest>)requestWithRect:(NSRect)rect scale:(CGFloat)scale;
+ (void)setPage:(MSPage *)page forRequest:(id <MSExportRequest>)request;

@end