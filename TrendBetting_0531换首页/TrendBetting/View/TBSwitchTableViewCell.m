//
//  TBSwitchTableViewCell.m
//  TrendBetting
//
//  Created by jiazhen-mac-01 on 2017/9/15.
//  Copyright © 2017年 yxy. All rights reserved.
//

#import "TBSwitchTableViewCell.h"

@implementation TBSwitchTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)switchChange:(id)sender {
    if ([self.delegate respondsToSelector:@selector(switchClick:)]) {
        [self.delegate switchClick:_indexStr];
    }
}
+(id)loadSwitchTableViewCell:(UITableView*)tableview
{
    TBSwitchTableViewCell*cell=[tableview dequeueReusableCellWithIdentifier:@"switchCell"];
    if (cell==nil)
    {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"TBSwitchTableViewCell" owner:self options:nil] lastObject];
    }
    return cell;
}

@end
