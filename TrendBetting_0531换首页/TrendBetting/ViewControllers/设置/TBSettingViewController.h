//
//  TBSettingViewController.h
//  TrendBetting
//
//  Created by jiazhen-mac-01 on 17/3/7.
//  Copyright © 2017年 yxy. All rights reserved.
//

#import "TBBaseViewController.h"
@protocol switchOnOrOffProtocol <NSObject>
-(void)switchClick:(NSString*)indexStr;
@end
@interface switchUItableViewCell:UITableViewCell
@property(strong,nonatomic)id <switchOnOrOffProtocol> delegate;
@property (strong, nonatomic)  NSString *indexStr;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UISwitch *mySwitch;
- (IBAction)switchChange:(id)sender;
@end


@interface TBSettingViewController : TBBaseViewController
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@end
