//
//  tenRuleModel.m
//  TrendBetting
//
//  Created by jiazhen-mac-01 on 2017/9/15.
//  Copyright © 2017年 yxy. All rights reserved.
//

#import "tenRuleModel.h"
#define NameStr @"nameStr"
#define GotwoLu @"gotwoLu"
#define GoLu @"goLu"
#define GoXiaoLu @"goXiaoLu"
#define OneNORule @"oneNORule"
#define TrueOneNORule @"trueOneNORule"
#define NoRuleOne @"noRuleOne"
#define OneRule  @"oneRule"
#define TrueOneRule  @"trueOneRule"
#define RuleOne @"ruleOne"
#define SameRule @"sameRule"
#define WordRule @"wordRule"
#define TRule @"TRule"
#define ResverseRule @"resverseRule"

@implementation tenRuleModel
-(void)initWithYes{
    _nameStr = @"默认";
    _gotwoLu = @"YES";
    _goLu = @"YES";
    _goXiaoLu  = @"YES";
    _oneNORule = @"YES";
    _trueOneNORule = @"NO";
    _noRuleOne  = @"YES";
    _oneRule  = @"YES";
    _trueOneRule = @"NO";
    _ruleOne  = @"YES";
    _sameRule  = @"YES";
    _wordRule  = @"YES";
    _tRule  = @"YES";
    _reverseRule =@"NO";
}
-(void)initWithDic:(NSDictionary*)dic{
    NSArray*arr=dic[@"listTen"];
    _gotwoLu = arr[0];
    _goLu = arr[1];
    _goXiaoLu  = arr[2];
    _oneNORule = arr[3];
    _trueOneNORule = arr[4];
    _noRuleOne  = arr[5];
    _oneRule  = arr[6];
    _trueOneRule  = arr[7];
    _ruleOne  = arr[8];
    _sameRule  = arr[9];
    _wordRule  = arr[10];
    _tRule  = arr[11];
    _reverseRule =arr[12];
    
    
    
}
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.nameStr forKey:NameStr];
    [aCoder encodeObject:self.gotwoLu forKey:GotwoLu];
    [aCoder encodeObject:self.goLu forKey:GoLu];
    [aCoder encodeObject:self.goXiaoLu forKey:GoXiaoLu];
    [aCoder encodeObject:self.oneNORule forKey:OneNORule];
    [aCoder encodeObject:self.trueOneNORule forKey:TrueOneNORule];
    [aCoder encodeObject:self.noRuleOne forKey:NoRuleOne];
    [aCoder encodeObject:self.oneRule  forKey:OneRule];
    [aCoder encodeObject:self.trueOneRule  forKey:TrueOneRule];
    [aCoder encodeObject:self.ruleOne forKey:RuleOne];
    [aCoder encodeObject:self.sameRule forKey:SameRule];
    [aCoder encodeObject:self.wordRule forKey:WordRule];
    [aCoder encodeObject:self.tRule forKey:TRule];
    [aCoder encodeObject:self.reverseRule forKey:ResverseRule];
}
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.nameStr = [aDecoder decodeObjectForKey:NameStr];
        self.gotwoLu = [aDecoder decodeObjectForKey:GotwoLu];
        self.goLu = [aDecoder decodeObjectForKey:GoLu];
        self.goXiaoLu = [aDecoder decodeObjectForKey:GoXiaoLu];
        self.oneNORule = [aDecoder decodeObjectForKey:OneNORule];
        self.trueOneNORule = [aDecoder decodeObjectForKey:TrueOneNORule];
        self.noRuleOne = [aDecoder decodeObjectForKey:NoRuleOne];
        self.oneRule  = [aDecoder decodeObjectForKey:OneRule];
        self.trueOneRule  = [aDecoder decodeObjectForKey:TrueOneRule];
        self.ruleOne = [aDecoder decodeObjectForKey:RuleOne];
        self.sameRule = [aDecoder decodeObjectForKey:SameRule];
        self.wordRule = [aDecoder decodeObjectForKey:WordRule];
        self.tRule = [aDecoder decodeObjectForKey:TRule];
        self.reverseRule = [aDecoder decodeObjectForKey:ResverseRule];
    }
    
    return self;
}
@end
