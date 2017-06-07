//
//  style+size.h
//  svuLibrary
//
//  Created by jiazhen-mac-01 on 16/12/23.
//  Copyright © 2016年 yxy. All rights reserved.
//

#ifndef Utils_size_h
#define Utils_size_h
#import <Foundation/Foundation.h>
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ? YES : NO)
#define IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 ? YES : NO)
#define IOS9 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0 ? YES : NO)
#define NAVBAR_HEIGHT (IOS7?64:44)

#endif /* Utils_size_h */
