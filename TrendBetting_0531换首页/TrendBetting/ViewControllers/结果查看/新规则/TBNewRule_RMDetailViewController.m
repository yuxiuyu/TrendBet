//
//  TBNewRuleRoomDetailViewController.m
//  TrendBetting
//
//  Created by jiazhen-mac-01 on 17/6/20.
//  Copyright © 2017年 yxy. All rights reserved.
//

#import "TBNewRule_RMDetailViewController.h"

@interface TBNewRule_RMDetailViewController ()
{
    
    NSMutableArray*dataArray;
    NSMutableDictionary*dateDic;
    NSMutableArray*houseSumWinCountArray;
    
}
@end

@implementation TBNewRule_RMDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=_selectedTitle;
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.navigationController.navigationBarHidden=NO;
    _tableview.tableFooterView=[[UIView alloc]init];
    dateDic=[[NSMutableDictionary alloc]init];
    dataArray=[[NSMutableArray alloc]init];
    houseSumWinCountArray=[[NSMutableArray alloc]initWithArray:@[@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0"]];
    NSDictionary*monthDic=[Utils sharedInstance].housesDic[_selectedTitle];
    
    ///////
    [monthDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSDictionary*daysDic=monthDic[key];
        [dataArray addObject:key];
        NSMutableArray*winArr= [[NSMutableArray alloc]initWithArray:@[@"0",@"0",@"0",@"0",@"0"]];
        NSMutableArray*failArr=[[NSMutableArray alloc]initWithArray:@[@"0",@"0",@"0",@"0",@"0"]];
        NSMutableArray*monthSumWinCountArray=[[NSMutableArray alloc]initWithArray:@[@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",winArr,failArr]];
        [daysDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            NSDictionary*dic=(NSDictionary*)obj;
            NSArray*array=dic[@"daycount"];
            for (int i=0; i<monthSumWinCountArray.count; i++)
            {
                if (i<=8) {
                    NSString*str1=[NSString stringWithFormat:@"%d",[monthSumWinCountArray[i] intValue]+[array[i] intValue]];
                    NSString*str2=[NSString stringWithFormat:@"%d",[houseSumWinCountArray[i] intValue]+[array[i] intValue]];
                    if (i==5||i==7)
                    {
                        str1=[NSString stringWithFormat:@"%0.2f",[monthSumWinCountArray[i] floatValue]+[array[i] floatValue]];
                        str2=[NSString stringWithFormat:@"%0.2f",[houseSumWinCountArray[i] floatValue]+[array[i] floatValue]];
                    }
                    if (i==8)
                    {
                        str1=[NSString stringWithFormat:@"%0.3f",[monthSumWinCountArray[i] floatValue]+[array[i] floatValue]];
                        str2=[NSString stringWithFormat:@"%0.3f",[houseSumWinCountArray[i] floatValue]+[array[i] floatValue]];
                    }
                    [monthSumWinCountArray replaceObjectAtIndex:i withObject:str1];
                    [houseSumWinCountArray replaceObjectAtIndex:i withObject:str2];
                } else {
                    NSMutableArray*wArr=[[NSMutableArray alloc]initWithArray:monthSumWinCountArray[i]];
                    for (int k=0; k<wArr.count; k++) {
                        
                        NSString*s=[NSString stringWithFormat:@"%d",[wArr[k] intValue]+[array[i][k] intValue]];
                        [wArr replaceObjectAtIndex:k withObject:s];
                    }
                    [monthSumWinCountArray replaceObjectAtIndex:i withObject:wArr];
                }
            }
        }];
        [dateDic setObject:monthSumWinCountArray forKey:key];
    }];
#warning - yxy0409 - edit
    NSArray*tepArray=[dataArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2)
                      {
                          NSDateFormatter*formatter=[[NSDateFormatter alloc]init];
                          [formatter setDateFormat:@"yyyy-MM"];
                          NSDate*date1=[formatter dateFromString:obj1];
                          NSDate*date2=[formatter dateFromString:obj2];
                          NSComparisonResult result=[date1 compare:date2];
                          return result;
                      }];
    dataArray=[[NSMutableArray alloc]initWithArray:tepArray];
#warning - yxy0409 - edit
    [_tableview reloadData];
    
    
    _resultCountLab.text=[NSString stringWithFormat:@"庄:%@  闲:%@  和:%@",houseSumWinCountArray[0],houseSumWinCountArray[1],houseSumWinCountArray[2]];
    NSString*reduceStr=[[Utils sharedInstance]removeFloatAllZero:houseSumWinCountArray[7]];
    reduceStr=[reduceStr stringByReplacingOccurrencesOfString:@"+" withString:@"-"];
    NSString*backmoneyStr=[[Utils sharedInstance]removeFloatAllZero:houseSumWinCountArray[8]];
    _winCountLab.text=[NSString stringWithFormat:@"赢:%@  输:%@  盈利:%@  抽水:%@  洗码:%@",houseSumWinCountArray[4],houseSumWinCountArray[3],[[Utils sharedInstance]removeFloatAllZero:houseSumWinCountArray[5]],reduceStr,backmoneyStr];
    
    
    
    // Do any additional setup after loading the view.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString*cellIndentier=@"cellIndentier";
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:cellIndentier];
    if (cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentier];
    }
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    NSArray*array=dateDic[dataArray[indexPath.row]];
    cell.textLabel.font=[UIFont systemFontOfSize:14.0f];
    NSString*reduceStr=[[Utils sharedInstance]removeFloatAllZero:array[7]];
    reduceStr=[reduceStr stringByReplacingOccurrencesOfString:@"+" withString:@"-"];
    NSString*backmoneyStr=[[Utils sharedInstance]removeFloatAllZero:array[8]];
    cell.textLabel.text=[NSString stringWithFormat:@"%@     庄:%@  闲:%@  和:%@  赢:%@  输:%@  盈利:%@  抽水:%@  洗码:%@",dataArray[indexPath.row],array[0],array[1],array[2],array[4],array[3],[[Utils sharedInstance]removeFloatAllZero:array[5]],reduceStr,backmoneyStr];
    
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self performSegueWithIdentifier:@"showNewRule_MonthVC" sender:@{@"selectedTitle":dataArray[indexPath.row],@"roomStr":_selectedTitle,@"winCountArray":dateDic[dataArray[indexPath.row]]}];
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0)
    {
        return 10;
    }
    return 0;
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
    if ([segue.identifier isEqualToString:@"showNewRule_MonthVC"])
    {
        UIViewController*vc=[segue destinationViewController];
        [vc setValuesForKeysWithDictionary:(NSDictionary*)sender];
    }
}

@end
