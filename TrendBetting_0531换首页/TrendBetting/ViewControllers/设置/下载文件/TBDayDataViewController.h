//
//  TBDayDataViewController.h
//  TrendBetting
//
//  Created by WX on 2017/10/20.
//  Copyright © 2017年 yxy. All rights reserved.
//

#import "TBBaseViewController.h"

@protocol downBtnActionDelegate;

@interface dayCell : UITableViewCell
@property (strong, nonatomic) id<downBtnActionDelegate>delegate;
@property (weak, nonatomic) IBOutlet UILabel *dayLab;
@property (weak, nonatomic) IBOutlet UIButton *downBtn;
- (IBAction)downBtnAction:(UIButton *)sender;

@end

@protocol downBtnActionDelegate <NSObject>

-(void)downBtnClick:(NSInteger)tag;


@end


@interface TBDayDataViewController : TBBaseViewController

@property(nonatomic,strong) NSString *selectedMonth;
@property(nonatomic,strong) NSString *selectedRoom;

@end
