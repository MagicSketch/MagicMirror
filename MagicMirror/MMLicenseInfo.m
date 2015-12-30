//
//  MMLicenseInfo.m
//  MagicMirror2
//
//  Created by James Tang on 30/12/2015.
//  Copyright © 2015 James Tang. All rights reserved.
//

#import "MMLicenseInfo.h"

@implementation MMLicenseInfo

+ (instancetype)licenseInfoWithDictionary:(NSDictionary *)dictionary error:(NSError **)error {
    NSString *email = dictionary[@"email"];
    NSString *firstName = dictionary[@"first_name"];
    NSString *lastName = dictionary[@"last_name"];
    NSString *method = dictionary[@"method"];
    NSString *license = dictionary[@"transaction_id"];

    if ( ! email || ! firstName || ! lastName || ! method || ! license) {
        *error = [NSError errorWithDomain:@"design.magicmirror.license" code:0 userInfo:@{
                                                                                         NSLocalizedDescriptionKey: @"Incorrect License",
                                                                                         }];
    }

    return [self licenseInfoWithEmail:email
                            firstName:firstName
                             lastName:lastName
                               method:method
                              license:license];
}

+ (instancetype)licenseInfoWithEmail:(NSString *)email
                           firstName:(NSString *)firstName
                            lastName:(NSString *)lastName
                              method:(NSString *)method
                             license:(NSString *)license {

    MMLicenseInfo *info = [[self alloc] init];
    info.email = email;
    info.firstName = firstName;
    info.lastName = lastName;
    info.method = method;
    info.license = license;
    return info;
}

- (NSString *)description {
    return [[self dictionaryWithValuesForKeys:@[
                                               @"email",
                                               @"firstName",
                                               @"lastName",
                                               @"method",
                                               @"license"
                                               ]] description];
}

@end
