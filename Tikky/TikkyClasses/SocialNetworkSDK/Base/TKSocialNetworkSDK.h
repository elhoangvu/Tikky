//
//  SocialNetworkSDK.h
//  TestSocialNetworkKit
//
//  Created by Le Hoang Vu on 2/24/19.
//  Copyright © 2019 Le Hoang Vu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TKSNUserInfo.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SNGetAvatarType) {
    SNGetAvatarTypeLarge,
    SNGetAvatarTypeSmall,
};

@protocol SocialNetworkSDKDelegate;

@interface TKSocialNetworkSDK : NSObject

@property (nonatomic, readonly) BOOL isLogin;
    
+ (instancetype)sharedInstance;

- (BOOL)login;

- (void)logout;

- (void)sharePhotoWithPhoto:(NSArray<UIImage *> *)photos
                    caption:(NSString *)caption
              userGenerated:(BOOL)userGenerated
              hashtagString:(NSString *)hashtagString
       showedViewController:(UIViewController *)showedViewController
                   delegate:(id<SocialNetworkSDKDelegate>)delegate;

- (void)sharePhotoWithURL:(NSArray<NSURL *> *)photoURLs
                  caption:(NSString *)caption
            userGenerated:(BOOL)userGenerated
            hashtagString:(NSString *)hashtagString
     showedViewController:(UIViewController *)showedViewController
                 delegate:(id<SocialNetworkSDKDelegate>)delegate;

- (void)shareLinkWithURL:(NSURL *)url
           hashtagString:(NSString *)hashtagString
    showedViewController:(UIViewController *)showedViewController
                delegate:(id<SocialNetworkSDKDelegate>)delegate;

- (void)userInfoWithCompletionHandler:(void (^)(TKSNUserInfo * userInfo, NSError* error))completion;

- (void)avatarWithPictureType:(SNGetAvatarType)pictureType completionHandler:(void (^)(UIImage * avatar, NSError* error))completion;

@end

@protocol SocialNetworkSDKDelegate <NSObject>

- (void)socialNetworkSDK:(TKSocialNetworkSDK *)socialNetworkSDK didCompleteWithResults:(NSDictionary *)results;

- (void)socialNetworkSDK:(TKSocialNetworkSDK *)socialNetworkSDK didFailWithError:(NSError *)error;

- (void)socialNetworkSDKDidCancel:(TKSocialNetworkSDK *)socialNetworkSDK;

@end

NS_ASSUME_NONNULL_END
