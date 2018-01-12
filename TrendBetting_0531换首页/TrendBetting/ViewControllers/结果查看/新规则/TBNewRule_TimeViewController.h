//
//  TBNewRule_TimeViewController.h
//  TrendBetting
//
//  Created by jiazhen-mac-01 on 17/6/20.
//  Copyright © 2017年 yxy. All rights reserved.
//

#import "TBBaseViewController.h"


@interface TBNewRule_TimeViewController : TBBaseViewController
@property (weak, nonatomic) IBOutlet UILabel *resultCountLab;
@property (weak, nonatomic) IBOutlet UILabel *winCountLab;
@property(copy,nonatomic)NSString * selectedTitle;
@property(strong,nonatomic)NSArray*dataArray;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionview;

@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (strong, nonatomic) IBOutlet UIView *resultView;
@end


@interface newRuleTimeUICollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *resultLab;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@end
