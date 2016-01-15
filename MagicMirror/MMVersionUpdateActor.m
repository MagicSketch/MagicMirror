//
//  MMVersionUpdateActor.m
//  MagicMirror2
//
//  Created by James Tang on 15/1/2016.
//  Copyright © 2016 James Tang. All rights reserved.
//

#import "MMVersionUpdateActor.h"
#import "MagicMirror-Private.h"

@implementation MagicMirror (MMVersionUpdateActor)

- (void)showUpdateDialog {
    NSString *info = [NSString stringWithFormat:@"v%@ is avaliable!\n\nDownload the update to enjoy new features and bug fixes :)", self.checker.remote.version];
    NSAlert *alert = [NSAlert alertWithMessageText:@"Magic Mirror" defaultButton:@"Update" alternateButton:nil otherButton:@"Not now" informativeTextWithFormat:info, nil];
    [alert setIcon:[self.loader imageNamed:@"logo"]];
    NSModalResponse response = [alert runModal];
    switch (response) {
        case NSModalResponseContinue:
            [self openURL:@"http://magicmirror.design"];
            break;
        default:

            break;
    }
}

- (void)showErrorDialog:(NSError *)error {
    NSString *info = [NSString stringWithFormat:@"Update checking failed... (%@)", [error localizedDescription]];
    NSAlert *alert = [NSAlert alertWithMessageText:@"Magic Mirror" defaultButton:@"Update" alternateButton:nil otherButton:@"Not now" informativeTextWithFormat:info, nil];
    [alert setIcon:[self.loader imageNamed:@"logo"]];
    NSModalResponse response = [alert runModal];
    switch (response) {
        case NSModalResponseContinue:
            break;
        default:
            break;
    }
}

- (void)showLatestDialog {
    NSString *info = [NSString stringWithFormat:@"v%@ is the latest version :)", self.checker.local.version];
    NSAlert *alert = [NSAlert alertWithMessageText:@"Magic Mirror" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:info, nil];
    [alert setIcon:[self.loader imageNamed:@"logo"]];
    NSModalResponse response = [alert runModal];
    switch (response) {
        default:
            break;
    }
}

@end
