//
//  MockVersionUpdateActor.m
//  MagicMirror2
//
//  Created by James Tang on 15/1/2016.
//  Copyright © 2016 James Tang. All rights reserved.
//

#import "MockVersionUpdateActor.h"

@implementation MockVersionUpdateActor

- (void)showUpdateDialog {
    _showedUpdateDialogCount++;
}

- (void)showErrorDialog:(NSError *)error {
    _hasShowErrorDialog = YES;
}

- (void)showLatestDialog {
    _hasShowLatestDialog = YES;
}

- (void)remainSlienceForUpdate {
    _hasRemainedSlience = YES;
}

- (void)proceedToDownload {
    _proceedDownloadCount++;
}

@end
