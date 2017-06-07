//
//  TBGroup_RoomViewController.h
//  TrendBetting
//
//  Created by jiazhen-mac-01 on 17/4/20.
//  Copyright © 2017年 yxy. All rights reserved.
//

#import "TBBaseViewController.h"

@interface TBGroup_RoomViewController : TBBaseViewController
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end
@interface groupRoomCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *roomLab;
@end
