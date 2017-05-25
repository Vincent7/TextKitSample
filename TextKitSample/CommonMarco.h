//
//  CommonMarco.h
//  TextKitSample
//
//  Created by Vincent on 2017/4/20.
//  Copyright © 2017年 Vincent. All rights reserved.
//

#ifndef CommonMarco_h
#define CommonMarco_h

#if !defined _BUILD_FOR_DEVELOP && !defined TKS_BUILD_FOR_TEST && !defined TKS_BUILD_FOR_RELEASE && !defined TKS_BUILD_FOR_PRERELEASE

#define TKS_BUILD_FOR_DEVELOP
//#define TKS_BUILD_FOR_TEST
//#define TKS_BUILD_FOR_PRERELEASE
//#define TKS_BUILD_FOR_HOTFIX
//#define TKS_BUILD_FOR_RELEASE
#endif

typedef enum {
    GET,
    POST,
    PUT,
    DELETE,
    HEAD
} HTTPMethod;
#define WS(weakSelf)     __weak typeof(self) weakSelf = self
#define SERVERADDRESS @"http://localhost:3000/"
#define SCREEN_WIDTH ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?[UIScreen mainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale:[UIScreen mainScreen].bounds.size.width)
#define SCREENH_HEIGHT ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?[UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale:[UIScreen mainScreen].bounds.size.height)
#define SCREEN_SIZE ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?CGSizeMake([UIScreen mainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale,[UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale):[UIScreen mainScreen].bounds.size)

#define rgb(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f]
#define rgba(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

#endif /* CommonMarco_h */
