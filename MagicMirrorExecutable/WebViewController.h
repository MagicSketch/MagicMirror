//
//  WebViewController.h
//  MagicMirror2
//
//  Created by James Tang on 25/1/2016.
//  Copyright © 2016 James Tang. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@import WebKit;

@interface WebViewController : NSViewController
@property (weak) IBOutlet WebView *webView;

@end
