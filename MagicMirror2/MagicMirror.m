//
//  MMViewController.m
//  MagicMirror2
//
//  Created by James Tang on 7/12/2015.
//  Copyright © 2015 James Tang. All rights reserved.
//

#import "MagicMirror.h"
#import "MMWindowController.h"
#import "COScript.h"
@import AppKit;

@interface MagicMirror ()

@property (nonatomic, strong) MMWindowController *controller;

@property (nonatomic, strong) MSPluginBundle *plugin;
@property (nonatomic, strong) MSPluginCommand *command;
@property (nonatomic, copy) NSArray *selection;
@property (nonatomic, strong) MSDocument *document;
@property (nonatomic, strong) id <COScript> coscript;

@end

@implementation MagicMirror

- (id)initWithPlugin:(MSPluginBundle *)plugin
            document:(MSDocument *)document
           selection:(NSArray *)selection
             command:(MSPluginCommand *)command {
    if (self = [super init]) {
        _plugin = plugin;
        _command = command;
        _selection = [selection copy];
        _document = document;
        _coscript = (id <COScript>)command.session;
        return self;
    }
    return nil;
}

- (void)log {
    MMLog(@"logged something");
}

- (void)showWindow {
    [self keepAround];
    NSStoryboard *storyboard = [NSStoryboard storyboardWithName:@"Storyboard" bundle:[NSBundle bundleForClass:[MMWindowController class]]];
    _controller = [storyboard instantiateInitialController];
    _controller.magicmirror = self;
    [_controller showWindow:self];
}

- (void)keepAround {
    _coscript.shouldKeepAround = YES;
    MMLog(@"keepAround");
}

- (void)goAway {
    _coscript.shouldKeepAround = NO;
    MMLog(@"goAway");
}

@end
