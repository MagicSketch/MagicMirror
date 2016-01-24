//
//  MMPersister.h
//  MagicMirror2
//
//  Created by James Tang on 25/1/2016.
//  Copyright © 2016 James Tang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MagicMirror.h"

@protocol MMPersister <NSObject>

- (void)persistDictionary:(id)object withIdentifier:(NSString *)identifier;
- (id)persistedDictionaryForIdentifier:(NSString *)identifier;
- (void)removePersistedDictionaryForIdentifier:(NSString *)identifier;

@end

@interface MagicMirror (Persister) <MMPersister>

@end
