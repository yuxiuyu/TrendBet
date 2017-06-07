//
//  UIView+border.m
//  svuLibrary
//
//  Created by jiazhen-mac-01 on 16/12/26.
//  Copyright © 2016年 yxy. All rights reserved.
//

#import "UIView+border.h"

@implementation UIView (border)
-(void)circle:(CGFloat)width
{
    self.layer.masksToBounds=YES;
    self.layer.cornerRadius=width;
}
-(void)border:(CGFloat)width
{
    self.layer.borderWidth=width;
    self.layer.borderColor=TBLineColor.CGColor;
}
-(void)borderColor:(UIColor*)borderColor
{
    self.layer.borderWidth=0.5f;
    self.layer.borderColor=borderColor.CGColor;
}
-(void)borderWidthColor:(CGFloat)width borderColor:(UIColor*)borderColor
{
    self.layer.borderWidth=width;
    self.layer.borderColor=borderColor.CGColor;
}
@end
