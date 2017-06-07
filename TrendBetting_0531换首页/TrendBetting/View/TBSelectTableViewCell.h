//
//  TBSelectTableViewCell.h
//  TrendBetting
//
//  Created by jiazhen-mac-01 on 17/2/23.
//  Copyright © 2017年 yxy. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TBSelectTableViewCellDelegate <NSObject>
-(void)backSelected:(NSInteger)selectedIndex;
@end
@interface TBSelectTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (assign, nonatomic)  NSInteger selectedInp;
@property(strong,nonatomic)id <TBSelectTableViewCellDelegate>delegate;
- (IBAction)selectedBtnAction:(id)sender;
+(id)loadSelectTableViewCell:(UITableView*)tableview;
@end
