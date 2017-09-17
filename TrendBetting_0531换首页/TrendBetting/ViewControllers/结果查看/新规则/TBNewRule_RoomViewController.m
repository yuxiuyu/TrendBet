//
//  TBNewRule_RoomViewController.m
//  TrendBetting
//
//  Created by jiazhen-mac-01 on 17/6/20.
//  Copyright © 2017年 yxy. All rights reserved.
//

#import "TBNewRule_RoomViewController.h"
#import "TBFixGroupListViewController.h"
@interface TBNewRule_RoomViewController ()
{
    NSMutableArray*allHouseArr;
//    NSMutableDictionary*houseMoneyDic;
//    NSThread*thread;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionview;

@end

@implementation newroomCollectionViewCell



@end
@implementation TBNewRule_RoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"房间";
    self.edgesForExtendedLayout=UIRectEdgeNone;
    UIBarButtonItem*item=[[UIBarButtonItem alloc]initWithTitle:@"规则选择" style:UIBarButtonItemStylePlain target:self action:@selector(tenRuleBtnAction)];
    self.navigationItem.rightBarButtonItem=item;
    
    
    
    self.navigationController.navigationBarHidden=NO;
      allHouseArr=[[NSMutableArray alloc]init];
    [allHouseArr addObjectsFromArray:[[Utils sharedInstance] getAllFileName:nil]];
    
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

//    houseMoneyDic=[[NSMutableDictionary alloc]init];
    
//    thread=[[NSThread alloc] initWithTarget:self selector:@selector(getDataRead) object:nil];
//    [thread start];
    
    
    
   
}

//-(void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    [thread cancel];
//    thread=nil;
//    
//}
//-(void)getDataRead
//{

//    [self showProgress:YES];
//    [allHouseArr addObjectsFromArray:[[Utils sharedInstance] getAllFileName:nil]];
//    NSMutableDictionary* housesDic=[[NSMutableDictionary alloc]init];
//    
//    for (int i=0;i<allHouseArr.count;i++)
//    {
//        NSString*houseStr = allHouseArr[i];
//        if ([houseStr isEqualToString:SAVE_DATA_FILENAME]||[houseStr isEqualToString:SAVE_RULE_FILENAME])
//        {
//            [allHouseArr removeObject:houseStr];
//            i--;
//            continue;
//        }
//    }
    
//    for (int i=0;i<allHouseArr.count;i++)
//    {
//        NSString*houseStr = allHouseArr[i];
//        NSArray*monthsArr=[[Utils sharedInstance] getAllFileName:houseStr];////房间里的数据
//        NSMutableDictionary*monthsDic=[[NSMutableDictionary alloc] init];
//        float winMoney=0;
//        for (NSString*monthstr in monthsArr)
//        {
//            NSString*monthFileNameStr=[NSString stringWithFormat:@"%@/%@",houseStr,monthstr];
//            NSArray*daysArr=[[Utils sharedInstance] getAllFileName:monthFileNameStr];/////月份里的数据
//            NSMutableDictionary*daysDic=[[NSMutableDictionary alloc]init];
//            for (NSString*dayStr in daysArr)
//            {
//                if ([[NSThread currentThread] isCancelled])
//                {
//                    [self hidenProgress];
//                    [NSThread exit];
//                    return;
//                }
//                NSArray*array=[dayStr componentsSeparatedByString:@"."];
//                NSDictionary*tepDic=[[Utils sharedInstance] getNewRuleDayData:monthFileNameStr dayStr:array[0] ];
//                NSArray*tepArr=tepDic[@"daycount"];
//                winMoney=winMoney+[tepArr[5] floatValue];
//                [daysDic setObject:tepDic forKey:array[0]];
//            }
//            [monthsDic setObject:daysDic forKey:monthstr];
//        }
//        [housesDic setObject:monthsDic forKey:houseStr];
//        [houseMoneyDic setObject:[NSString stringWithFormat:@"%0.2f",winMoney] forKey:houseStr];
//    }
//    [Utils sharedInstance].housesDic=[[NSDictionary alloc] initWithDictionary:housesDic];
//    [self performSelectorOnMainThread:@selector(runMainThread) withObject:nil waitUntilDone:YES];
//   }
//-(void)runMainThread
//{
//    [self hidenProgress];
//    [_collectionview reloadData];
//}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return allHouseArr.count;
}
-(__kindof UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    newroomCollectionViewCell*cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"newroomCollectionIdentifier" forIndexPath:indexPath];
    NSString*str=allHouseArr[indexPath.item];
    cell.roomLab.text=[NSString stringWithFormat:@"%@房间",str];
//    cell.resultCountLab.text=[[Utils sharedInstance] removeFloatAllZero:houseMoneyDic[str]];
    return cell;
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSUserDefaults* defaults=[NSUserDefaults standardUserDefaults];
    NSData*data=[defaults objectForKey:SAVE_TenListBlodRule];
    if (!data) {
        data=[defaults objectForKey:SAVE_TenBlodRule];
    }
    tenRuleModel*tenM=[NSKeyedUnarchiver unarchiveObjectWithData:data];
  
    [Utils sharedInstance].tenModel=tenM;
    [self performSegueWithIdentifier:@"showNewRuleRoomVC" sender:@{@"selectedTitle":allHouseArr[indexPath.item]}];
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
-(void)tenRuleBtnAction{
    TBFixGroupListViewController*vc=[[UIStoryboard storyboardWithName:@"setting" bundle:nil] instantiateViewControllerWithIdentifier:@"fixGroupListViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
