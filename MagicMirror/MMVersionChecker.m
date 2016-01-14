//
//  MMVersionChecker.m
//  MagicMirror2
//
//  Created by James Tang on 14/1/2016.
//  Copyright © 2016 James Tang. All rights reserved.
//

#import "MMVersionChecker.h"
#import "MMManifest.h"
#import "MagicMirror.h"

@interface MMVersionChecker ()

@property (nonatomic, strong) MMManifest *local;
@property (nonatomic, strong) MMManifest *remote;

@end

@implementation MMVersionChecker

- (void)fetchLocal {
    NSString *path = [self.magicmirror manifestFilePath];
    self.local = [MMManifest manifestFromFilePath:path];

    MMLog(@"magicmirror %@", self.magicmirror);
    MMLog(@"path %@", path);
    MMLog(@"self.local %@", self.local);
    MMLog(@"self.local.checkULR %@", self.local.checkURL);
    MMLog(@"self.local.version %@", self.local.version);
}

- (void)fetchRemoteCompletion:(MMManifestURLCompletionHandler)completion {
    NSURL *url = [NSURL URLWithString:@"https://raw.githubusercontent.com/jamztang/MagicMirror/master/Magic%20Mirror.sketchplugin/Contents/Sketch/manifest.json"];
     __weak __typeof (self) weakSelf = self;
    [[NSURLCache sharedURLCache] setMemoryCapacity:0];
    [[NSURLCache sharedURLCache] setDiskCapacity:0];
    [MMManifest manifestFromURL:url
                     completion:^(MMManifest *manifest, NSError *error) {
                         if ( ! error) {
                             weakSelf.remote = manifest;
                         }
                         completion(manifest, error);
                     }];

}

- (void)checkForUpdates {
    [self fetchLocal];
    [self fetchRemoteCompletion:^(MMManifest *manifest, NSError *error) {

        NSComparisonResult result = [self.local compare:self.remote];
        switch (result) {
            default:
            case NSOrderedSame:
                MMLog(@"using the latest version");
                [self.magicmirror showLatestDialog];
                break;

            case NSOrderedAscending:
                MMLog(@"version %@ updates avaliable", self.remote.version);
                [self.magicmirror showUpdateDialog];
                break;

            case NSOrderedDescending:
                MMLog(@"your version is newer than the public version");
                [self.magicmirror showLatestDialog];
                break;
        }
    }];
    
}

@end
