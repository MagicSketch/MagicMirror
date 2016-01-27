//
//  WebViewController.m
//  MagicMirror2
//
//  Created by James Tang on 25/1/2016.
//  Copyright © 2016 James Tang. All rights reserved.
//

#import "WebViewController.h"

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.webView setMainFrameURL:@"http://magicmirror.design/how-to"];
}

@end
