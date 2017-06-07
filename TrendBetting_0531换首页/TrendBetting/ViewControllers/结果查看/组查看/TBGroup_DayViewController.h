//
//  TBGroup_DayViewController.h
//  TrendBetting
//
//  Created by jiazhen-mac-01 on 17/4/20.
//  Copyright © 2017年 yxy. All rights reserved.
//

#import "TBBaseViewController.h"

@interface TBGroup_DayViewController : TBBaseViewController

@property(copy,nonatomic)NSString * selectedTitle;
@property(copy,nonatomic)NSString * houseStr;
@property(copy,nonatomic)NSDictionary * dayDic;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@end
@interface groupDayCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *qtyLab;


@end
