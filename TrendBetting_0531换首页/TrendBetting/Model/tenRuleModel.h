//
//  tenRuleModel.h
//  TrendBetting
//
//  Created by jiazhen-mac-01 on 2017/9/15.
//  Copyright © 2017年 yxy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface tenRuleModel : NSObject
@property(copy,nonatomic)NSString*nameStr;
@property(copy,nonatomic)NSString*gotwoLu;
@property(copy,nonatomic)NSString*goLu;
@property(copy,nonatomic)NSString*goXiaoLu;
@property(copy,nonatomic)NSString*oneNORule;
@property(copy,nonatomic)NSString*noRuleOne;
@property(copy,nonatomic)NSString*oneRule;
@property(copy,nonatomic)NSString*ruleOne;
@property(copy,nonatomic)NSString*sameRule;
@property(copy,nonatomic)NSString*wordRule;
@property(copy,nonatomic)NSString*tRule;
@property(copy,nonatomic)NSString*reverseRule;
-(void)initWithYes;
-(void)initWithDic:(NSDictionary*)dic;
@end
