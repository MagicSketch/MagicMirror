//
//  MMLicenseInfo.h
//  MagicMirror2
//
//  Created by James Tang on 30/12/2015.
//  Copyright © 2015 James Tang. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MMLicenseInfo : NSObject

@property (copy) NSString *email;
@property (copy) NSString *firstName;
@property (copy) NSString *lastName;
@property (copy) NSString *method;
@property (copy) NSString *license;

+ (instancetype)licenseInfoWithDictionary:(NSDictionary *)dictionary error:(NSError **)error;

+ (instancetype)licenseInfoWithEmail:(NSString *)email
                           firstName:(NSString *)firstName
                            lastName:(NSString *)lastName
                              method:(NSString *)method
                             license:(NSString *)license;

@end
