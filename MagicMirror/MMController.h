//
//  MMController.h
//  MagicMirror2
//
//  Created by James Tang on 11/12/2015.
//  Copyright © 2015 James Tang. All rights reserved.
//

#ifndef MMController_h
#define MMController_h

@class MagicMirror;
@protocol SketchEventsController;

@protocol MMController <NSObject, SketchEventsController>

@property MagicMirror *magicmirror;

@end

#endif /* MMController_h */
