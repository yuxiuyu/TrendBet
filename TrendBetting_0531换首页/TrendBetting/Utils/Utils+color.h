//
//  style+Color.h
//  svuLibrary
//
//  Created by jiazhen-mac-01 on 16/12/23.
//  Copyright © 2016年 yxy. All rights reserved.
//

#ifndef Utils_color_h
#define Utils_color_h

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define TBBackgroundColor UIColorFromRGB(0xefeff4)
#define TBMainColor UIColorFromRGB(0x139647)
#define TBLineColor UIColorFromRGB(0xE8E8E8)
#endif /* style_Color_h */
