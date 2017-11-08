//
//  TBNewRule_DayViewController.h
//  TrendBetting
//
//  Created by jiazhen-mac-01 on 17/6/20.
//  Copyright © 2017年 yxy. All rights reserved.
//

#import "TBBaseViewController.h"

@interface TBNewRule_DayViewController : TBBaseViewController
@property (weak, nonatomic) IBOutlet UILabel *resultCountLab;
@property (weak, nonatomic) IBOutlet UILabel *winCountLab;
@property(copy,nonatomic)NSString * selectedTitle;
@property(copy,nonatomic)NSDictionary * dayDic;

@property(copy,nonatomic)NSString * houseStr;
@property(copy,nonatomic)NSString * isCurrentDay;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@end
@interface newRuleDayCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *qtyLab;
@property (weak, nonatomic) IBOutlet UILabel *winLab;
@end
