//
//  SNFacebookSDK.m
//  TestSocialNetworkKit
//
//  Created by Le Hoang Vu on 2/24/19.
//  Copyright © 2019 Le Hoang Vu. All rights reserved.
//

#import "SNFacebookSDK.h"
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface SNFacebookSDK () <FBSDKSharingDelegate>

@property (nonatomic, weak) id<SocialNetworkSDKDelegate> currentDelegate;
@property (nonatomic) dispatch_queue_t fetchBigDataQueue;

@end

@implementation SNFacebookSDK

- (instancetype)init
{
    if (!(self = [super init])) {
        return nil;
    }
    
    _fetchBigDataQueue = dispatch_queue_create("tikky.SNFacebookSDK.FetchBigDataQueue", DISPATCH_QUEUE_SERIAL);
    
    return self;
}

- (BOOL)login {
    FBSDKLoginButton* fbLoginButton = [[FBSDKLoginButton alloc] init];
    [fbLoginButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    return FBSDKAccessToken.currentAccessToken ? YES : NO;
}

- (void)logout {
    FBSDKLoginManager* fbLoginManager = [[FBSDKLoginManager alloc] init];
    [fbLoginManager logOut];
}

- (BOOL)isLogin {
    return FBSDKAccessToken.currentAccessToken ? YES : NO;
}


- (void)sharePhotoWithPhoto:(NSArray<UIImage *> *)photos
                    caption:(NSString *)caption
              userGenerated:(BOOL)userGenerated
              hashtagString:(NSString *)hashtagString
       showedViewController:(UIViewController *)showedViewController
                   delegate:(id<SocialNetworkSDKDelegate>)delegate {
    [self sharePhotoWithAssets:photos
                    assetClass:UIImage.class
                       caption:caption
                 userGenerated:userGenerated
                 hashtagString:hashtagString
          showedViewController:showedViewController
                      delegate:delegate];
}

- (void)sharePhotoWithURL:(NSArray<NSURL *> *)photoURLs
                  caption:(NSString *)caption
            userGenerated:(BOOL)userGenerated
            hashtagString:(NSString *)hashtagString
     showedViewController:(UIViewController *)showedViewController
                 delegate:(id<SocialNetworkSDKDelegate>)delegate {
    [self sharePhotoWithAssets:photoURLs
                    assetClass:NSURL.class
                       caption:caption
                 userGenerated:userGenerated
                 hashtagString:hashtagString
          showedViewController:showedViewController
                      delegate:delegate];
}

- (void)sharePhotoWithAssets:(NSArray *)assets
                  assetClass:(Class)assetClass
                     caption:(NSString *)caption
               userGenerated:(BOOL)userGenerated
               hashtagString:(NSString *)hashtagString
        showedViewController:(UIViewController *)showedViewController
                    delegate:(id<SocialNetworkSDKDelegate>)delegate {
    if (!assets || (![assetClass isKindOfClass:UIImage.class] && ![assetClass isKindOfClass:NSURL.class])) {
        return;
    }
    
    BOOL isURL = YES;
    if ([assetClass isKindOfClass:UIImage.class]) {
        isURL = NO;
    }
    
    NSMutableArray* fbPhotos = [NSMutableArray arrayWithCapacity:assets.count];
    for (NSObject* asset in assets) {
        FBSDKSharePhoto* fbSharePhoto = [[FBSDKSharePhoto alloc] init];
        if (isURL) {
            fbSharePhoto.imageURL = (NSURL *)asset;
        } else {
            fbSharePhoto.image = (UIImage *)asset;
        }
        
        fbSharePhoto.userGenerated = userGenerated;
        fbSharePhoto.caption = caption;
        [fbPhotos addObject:fbSharePhoto];
    }
    FBSDKSharePhotoContent* fbSharePhotoContent = [[FBSDKSharePhotoContent alloc] init];
    
    fbSharePhotoContent.photos = fbPhotos;
    fbSharePhotoContent.hashtag = [FBSDKHashtag hashtagWithString:hashtagString];
    [FBSDKShareDialog showFromViewController:showedViewController withContent:fbSharePhotoContent delegate:self];
    _currentDelegate = delegate;
}

- (void)shareLinkWithURL:(NSURL *)url
           hashtagString:(NSString *)hashtagString
    showedViewController:(UIViewController *)showedViewController
                delegate:(id<SocialNetworkSDKDelegate>)delegate {
    if (!url) {
        return;
    }
    
    FBSDKShareLinkContent* fbShareLinkContent = [[FBSDKShareLinkContent alloc] init];
    fbShareLinkContent.contentURL = url;
    fbShareLinkContent.hashtag = [FBSDKHashtag hashtagWithString:hashtagString];
    
    [FBSDKShareDialog showFromViewController:showedViewController withContent:fbShareLinkContent delegate:self];
    _currentDelegate = delegate;
    
}

- (void)userInfoWithCompletionHandler:(void (^)(SNUserInfo *, NSError* error))completion {
    if (!completion) {
        return;
    }
    
    FBSDKGraphRequest* grapRequest = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{ @"fields" : @"id, name, first_name, middle_name, last_name, email, phone" }];
    [grapRequest startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        if (error) {
            completion(nil, error);
            return;
        }
        SNUserInfo* userInfo = [[SNUserInfo alloc] init];
        NSDictionary* userInfoDict = (NSDictionary *)result;
        
        userInfo.uid = (NSString *)userInfoDict[@"id"];
        userInfo.name = (NSString *)userInfoDict[@"name"];
        userInfo.firstName = (NSString *)userInfoDict[@"first_name"];
        userInfo.middleName = (NSString *)userInfoDict[@"middle_name"];
        userInfo.lastName = (NSString *)userInfoDict[@"last_name"];
        completion(userInfo, nil);
    }];
    
    
//    [FBSDKProfile loadCurrentProfileWithCompletion:^(FBSDKProfile *profile, NSError *error) {
//        if (!profile) {
//            completion(nil, error);
//        }
//
//        SNUserInfo* userInfo = [[SNUserInfo alloc] initWithUID:profile.userID
//                                                     firstName:profile.firstName
//                                                    middleName:profile.middleName
//                                                      lastName:profile.lastName
//                                                         email:nil
//                                                         phone:nil];
//        completion(userInfo, nil);
//    }];
}

- (void)avatarWithPictureType:(SNGetAvatarType)pictureType completionHandler:(void (^)(UIImage * avatar, NSError* error))completion; {
    if (!completion) {
        return;
    }
    
    NSString* fetchingString;
    if (pictureType == SNGetAvatarTypeLarge) {
        fetchingString = @"picture.type(large)";
    } else if (pictureType == SNGetAvatarTypeSmall) {
        fetchingString = @"picture.type(small)";
    }
    
    __weak __typeof(self)weakSelf = self;
    FBSDKGraphRequest* grapRequest = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{ @"fields" : fetchingString }];
    [grapRequest startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        if (error) {
            completion(nil, error);
            return;
        }
        
        NSDictionary* userInfoDict = (NSDictionary *)result;
        NSDictionary* dataDict = userInfoDict[@"data"];
        NSString* urlString = dataDict[@"url"];
        NSURL* url = [NSURL URLWithString:urlString];
        
        dispatch_async(weakSelf.fetchBigDataQueue, ^{
            NSData* data = [NSData dataWithContentsOfURL:url];
            UIImage* avatar = [UIImage imageWithData:data];
            completion(avatar, nil);
        });
    }];
}

#pragma mark -
#pragma mark FBSharingDelegate

- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results {
    if (_currentDelegate && [_currentDelegate respondsToSelector:@selector(socialNetworkSDK:didCompleteWithResults:)]) {
        [_currentDelegate socialNetworkSDK:self didCompleteWithResults:results];
    }
}

- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error {
    if (_currentDelegate && [_currentDelegate respondsToSelector:@selector(socialNetworkSDK:didFailWithError:)]) {
        [_currentDelegate socialNetworkSDK:self didFailWithError:error];
    }
}

- (void)sharerDidCancel:(id<FBSDKSharing>)sharer {
    if (_currentDelegate && [_currentDelegate respondsToSelector:@selector(socialNetworkSDKDidCancel:)]) {
        [_currentDelegate socialNetworkSDKDidCancel:self];
    }
}

@end
