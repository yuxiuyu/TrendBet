//
//  TBGroup_RoomViewController.m
//  TrendBetting
//
//  Created by jiazhen-mac-01 on 17/4/20.
//  Copyright © 2017年 yxy. All rights reserved.
//

#import "TBGroup_RoomViewController.h"

@interface TBGroup_RoomViewController ()
{
    NSMutableArray*allHouseArr;
}
@end
@implementation groupRoomCollectionViewCell



@end
@implementation TBGroup_RoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"房间";
     [[Utils sharedInstance] getSelectedGroupArr];
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.navigationController.navigationBarHidden=NO;
    allHouseArr=[[NSMutableArray alloc]initWithArray:[[Utils sharedInstance] getAllFileName:nil]];
    for (int i=0;i<allHouseArr.count;i++)
    {
        NSString*houseStr = allHouseArr[i];
        if ([houseStr isEqualToString:SAVE_DATA_FILENAME]||[houseStr isEqualToString:SAVE_RULE_FILENAME])
        {
            [allHouseArr removeObject:houseStr];
            i--;
            continue;
        }
    }
   
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return allHouseArr.count;
}
-(__kindof UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    groupRoomCollectionViewCell*cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"groupRoomCollectionIdentifier" forIndexPath:indexPath];
    NSString*str=allHouseArr[indexPath.item];
    cell.roomLab.text=[NSString stringWithFormat:@"%@房间",str];
    return cell;
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"show_groupRoomDetailVC" sender:@{@"selectedTitle":allHouseArr[indexPath.item]}];
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UIViewController*vc=[segue destinationViewController];
    [vc setValuesForKeysWithDictionary:(NSDictionary*)sender];
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
