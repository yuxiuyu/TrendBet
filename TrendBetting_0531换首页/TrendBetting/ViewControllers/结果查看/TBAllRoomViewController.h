//
//  TBAllRoomViewController.h
//  TrendBetting
//
//  Created by jiazhen-mac-01 on 17/2/20.
//  Copyright © 2017年 yxy. All rights reserved.
//

#import "TBBaseViewController.h"
#import "Utils+rule.h"
@interface TBAllRoomViewController : TBBaseViewController
//@property(assign,nonatomic)TBTrendCode selectedTrendCode;
@end
@interface roomCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *roomLab;
@property (weak, nonatomic) IBOutlet UILabel *resultCountLab;

@end
