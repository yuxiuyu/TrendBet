//
//  TBResultRoomDetail_DayViewController.h
//  TrendBetting
//
//  Created by jiazhen-mac-01 on 17/2/15.
//  Copyright © 2017年 yxy. All rights reserved.
//

#import "TBBaseViewController.h"

@interface TBRoomDetail_DayViewController : TBBaseViewController
@property (weak, nonatomic) IBOutlet UILabel *resultCountLab;
@property (weak, nonatomic) IBOutlet UILabel *winCountLab;
@property(copy,nonatomic)NSString * selectedTitle;
@property(copy,nonatomic)NSDictionary * dayDic;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@end
@interface dayCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *qtyLab;
@property (weak, nonatomic) IBOutlet UILabel *winLab;

@end
