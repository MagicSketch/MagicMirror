//
//  MSImageData.h
//  MagicMirror2
//
//  Created by James Tang on 16/4/2016.
//  Copyright © 2016 James Tang. All rights reserved.
//

#ifndef MSImageData_h
#define MSImageData_h


@protocol MSImageData <NSObject>

- (id <MSImageData>)initWithImage:(NSImage *)image convertColorSpace:(BOOL)convert;

@end


#endif /* MSImageData_h */
