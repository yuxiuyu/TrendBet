//
//  TBSwitchTableViewCell.h
//  TrendBetting
//
//  Created by jiazhen-mac-01 on 2017/9/15.
//  Copyright © 2017年 yxy. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol switchOnOrOffProtocol <NSObject>
-(void)switchClick:(NSString*)indexStr;
@end
@interface TBSwitchTableViewCell : UITableViewCell
@property(strong,nonatomic)id <switchOnOrOffProtocol> delegate;
@property (strong, nonatomic)  NSString *indexStr;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UISwitch *mySwitch;
- (IBAction)switchChange:(id)sender;
+(id)loadSwitchTableViewCell:(UITableView*)tableview;
@end
