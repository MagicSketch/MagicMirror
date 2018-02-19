/*

 - (NSString *)contentsOfFile:(NSString *)fileName {
     NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:fileName ofType:nil];
     NSString *content = [NSString stringWithContentsOfFile:path
                                                   encoding:NSUTF8StringEncoding
                                                      error:nil];
     return content;
 }

 - (void)getArtboards:(void (^)(JSValue *result))completion {

     NSString *script = [self contentsOfFile:@"getArtboards.js"];
     COScript *coscript = [[COScript alloc] init];

     dispatch_async(dispatch_get_global_queue(0, 0), ^{
         id evalResult = [coscript executeString:script];
         id result = [coscript callFunctionNamed:@"getArtboards" withArguments:@[]];

         dispatch_async(dispatch_get_main_queue(), ^{
     
             completion(result);
         });
     });

 }
*/

var _document = [MSDocument currentDocument];

var getArtboards = function() {
    var artboards = _document.valueForKeyPath("pages.artboards").valueForKeyPath("@unionOfArrays.self").mutableCopy()
    var slices = _document.allExportableLayers()
    for (var i = 0; i < slices.count(); i++) {
        var slice = slices[i];
        if ([slice isKindOfClass:MSSliceLayer]) {
            artboards.addObject(slice);
        }
    }
    return artboards;
}
