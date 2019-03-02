
//
//  SNUserInfo.m
//  TestSocialNetworkKit
//
//  Created by Le Hoang Vu on 2/24/19.
//  Copyright © 2019 Le Hoang Vu. All rights reserved.
//

#import "SNUserInfo.h"

@implementation SNUserInfo

- (instancetype)initWithUID:(NSString *)uid
                  firstName:(NSString *)firstName
                 middleName:(NSString *)middleName
                   lastName:(NSString *)lastName
                       name:(NSString *)name
                      email:(NSString *)email
                      phone:(NSString *)phone {
    if (!(self = [super init])) {
        return nil;
    }
    
    _uid = uid;
    _firstName = firstName;
    _middleName = middleName;
    _lastName = lastName;
    _name = name;
    _email = email;
    _phone = phone;
    
    return self;
}

@end
