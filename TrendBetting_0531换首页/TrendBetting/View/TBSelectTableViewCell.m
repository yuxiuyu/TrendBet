//
//  TBSelectTableViewCell.m
//  TrendBetting
//
//  Created by jiazhen-mac-01 on 17/2/23.
//  Copyright © 2017年 yxy. All rights reserved.
//

#import "TBSelectTableViewCell.h"

@implementation TBSelectTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)selectedBtnAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(backSelected:)])
    {
        [self.delegate backSelected:_selectedInp];
    }
}
+(id)loadSelectTableViewCell:(UITableView*)tableview
{
    TBSelectTableViewCell*cell=[tableview dequeueReusableCellWithIdentifier:@"selectedCell"];
    if (cell==nil)
    {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"TBSelectTableViewCell" owner:self options:nil] lastObject];
    }
    return cell;
}
@end
