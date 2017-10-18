//
//  TBDown_RoomViewController.m
//  TrendBetting
//
//  Created by 于秀玉 on 17/10/19.
//  Copyright © 2017年 yxy. All rights reserved.
//

#import "TBDown_RoomViewController.h"

@interface TBDown_RoomViewController ()

{
    NSArray*allHouseArr;
    //    NSMutableDictionary*houseMoneyDic;
    //    NSThread*thread;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionview;

@end

@implementation downroomCollectionViewCell



@end

@implementation TBDown_RoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"房间";
    self.edgesForExtendedLayout=UIRectEdgeNone;
 
    
    
    
    self.navigationController.navigationBarHidden=NO;
    allHouseArr=@[@"1",@"2",@"3",@"4"];
    
    
    
    
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return allHouseArr.count;
}
-(__kindof UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    downroomCollectionViewCell*cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"downroomCollectionIdentifier" forIndexPath:indexPath];
    NSString*str=allHouseArr[indexPath.item];
    cell.roomLab.text=[NSString stringWithFormat:@"%@号房间",str];
    //    cell.resultCountLab.text=[[Utils sharedInstance] removeFloatAllZero:houseMoneyDic[str]];
    return cell;
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    [[Utils sharedInstance] initSetTenModel];
//    [self performSegueWithIdentifier:@"showNewRuleRoomVC" sender:@{@"selectedTitle":allHouseArr[indexPath.item]}];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"showNewRuleRoomVC"])
    {
        UIViewController*vc=[segue destinationViewController];
        [vc setValuesForKeysWithDictionary:(NSDictionary*)sender];
    }
}


@end
