//
//  MMPersister.m
//  MagicMirror2
//
//  Created by James Tang on 25/1/2016.
//  Copyright © 2016 James Tang. All rights reserved.
//

#import "MMPersister.h"

@implementation MagicMirror (Persister)

- (void)removePersistedDictionaryForIdentifier:(NSString *)identifier {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:identifier];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (id)persistedDictionaryForIdentifier:(NSString *)identifier {
    return [[NSUserDefaults standardUserDefaults] objectForKey:identifier];
}

- (void)persistDictionary:(id)dictionary withIdentifier:(NSString *)identifier {
    [[NSUserDefaults standardUserDefaults] setObject:dictionary
                                              forKey:identifier];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
