//
//  SocialNetworkSDK.h
//  TestSocialNetworkKit
//
//  Created by Le Hoang Vu on 2/24/19.
//  Copyright © 2019 Le Hoang Vu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SNUserInfo.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SNGetAvatarType) {
    SNGetAvatarTypeLarge,
    SNGetAvatarTypeSmall,
};

@protocol SocialNetworkSDKDelegate;

@interface SocialNetworkSDK : NSObject

@property (nonatomic, readonly) BOOL isLogin;

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

- (void)userInfoWithCompletionHandler:(void (^)(SNUserInfo * userInfo, NSError* error))completion;

- (void)avatarWithPictureType:(SNGetAvatarType)pictureType completionHandler:(void (^)(UIImage * avatar, NSError* error))completion;

@end

@protocol SocialNetworkSDKDelegate <NSObject>

- (void)socialNetworkSDK:(SocialNetworkSDK *)socialNetworkSDK didCompleteWithResults:(NSDictionary *)results;

- (void)socialNetworkSDK:(SocialNetworkSDK *)socialNetworkSDK didFailWithError:(NSError *)error;

- (void)socialNetworkSDKDidCancel:(SocialNetworkSDK *)socialNetworkSDK;

@end

NS_ASSUME_NONNULL_END
