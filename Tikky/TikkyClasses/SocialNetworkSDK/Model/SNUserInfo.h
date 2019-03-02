//
//  SNUserInfo.h
//  TestSocialNetworkKit
//
//  Created by Le Hoang Vu on 2/24/19.
//  Copyright © 2019 Le Hoang Vu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SNUserInfo : NSObject

@property (nonatomic, copy) NSString* uid;
@property (nonatomic, copy) NSString* firstName;
@property (nonatomic, copy) NSString* middleName;
@property (nonatomic, copy) NSString* lastName;
@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* email;
@property (nonatomic, copy) NSString* phone;

- (instancetype)initWithUID:(NSString *)uid
                  firstName:(NSString *)firstName
                 middleName:(NSString *)middleName
                   lastName:(NSString *)lastName
                       name:(NSString *)name
                      email:(NSString *)email
                      phone:(NSString *)phone;

@end
