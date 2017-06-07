//
//  TBGroup_TimeResultViewController.m
//  TrendBetting
//
//  Created by jiazhen-mac-01 on 17/4/25.
//  Copyright © 2017年 yxy. All rights reserved.
//

#import "TBGroup_TimeResultViewController.h"

@interface TBGroup_TimeResultViewController ()
{
    NSArray*showArray;
    NSInteger areacount;
    NSInteger rulecount;
    UIBarButtonItem*leftItem;
    UIBarButtonItem*rightItem;
}
@end

@implementation TBGroup_TimeResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"结果数据";
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.navigationController.navigationBarHidden=NO;
    NSDictionary*dic=[Utils sharedInstance].groupSelectedArr[0];

    leftItem=[[UIBarButtonItem alloc]initWithTitle:dic[@"name"] style:UIBarButtonItemStylePlain target:self action:@selector(ruleBtnAction)];

    rightItem=[[UIBarButtonItem alloc]initWithTitle:@"大路" style:UIBarButtonItemStylePlain target:self action:@selector(areaBtnAction)];
    if (_dateStr)
    {
        UIBarButtonItem*saveitem=[[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveBtnAction)];
        self.navigationItem.rightBarButtonItems=@[saveitem,leftItem,rightItem];

    }
    else
    {
       self.navigationItem.rightBarButtonItems=@[leftItem,rightItem];
    }
    
   
    
    _tableview.tableFooterView=[[UIView alloc]init];
    showArray=_dataArray[areacount][rulecount];
    
    [_tableview reloadData];
    
    
}
-(void)saveBtnAction
{
    NSMutableArray*rulearr=[[NSMutableArray alloc]init];
    for (int i=0; i<showArray.count; i++)
    {
        NSString*str=showArray[i];
        NSArray*array=[str componentsSeparatedByString:@"|"];
        int win=[array[0] intValue];
        int lose= abs([array[1] intValue]);
        if (win-lose<0)//赢差是负数
        {
            [rulearr addObject:@"0"];
        }
        else if (win-lose<=1)//赢差为0，1时
        {
             [rulearr addObject:@"1"];
        }
        else if(win-lose==2)//赢差为2时
        {
            if ((win-lose)*10<=win)
            {
                 [rulearr addObject:@"2"];
            }
            else
            {
                [rulearr addObject:@"3"];
            }
        }
        else//赢差大于2时
        {
            if ((win-lose)*10>0&&(win-lose)*10<=win*1/3)
            {
                [rulearr addObject:@"2"];
            }
            else if ((win-lose)*10>win*1/3&&(win-lose)*10<=win*2/3)
            {
                [rulearr addObject:@"3"];
            }
            else if ((win-lose)*10>win*2/3&&(win-lose)*10<=win)
            {
                 [rulearr addObject:@"4"];
            }
            else
            {
                [rulearr addObject:@"5"];
            }
        }
    }
     NSString*nateStr=[NSString stringWithFormat:@"%@ %@ %@",_dateStr,rightItem.title,leftItem.title];
     NSMutableDictionary*dic=[[NSMutableDictionary alloc]initWithDictionary:@{@"number":[NSString stringWithFormat:@"%ld",[Utils sharedInstance].moneyRuleArray.count+1],@"name":nateStr,@"moneyRule":rulearr,@"isselected":@"NO"}];
     NSMutableArray*tempArr=[[NSMutableArray alloc]initWithArray:[Utils sharedInstance].moneyRuleArray];
     [tempArr addObject:dic];
    BOOL issuccess= [[Utils sharedInstance] saveData:nil saveArray:tempArr filePathStr:SAVE_MONEY_TXT];
    if (issuccess)
    {
       
        [Utils sharedInstance].moneyRuleArray = tempArr;
        [[Utils sharedInstance] getSelectedMoneyArr];
        [self.view makeToast:@"保存成功" duration:0.5f position:CSToastPositionCenter];
    }
    else
    {
        [self.view makeToast:@"保存失败" duration:0.5f position:CSToastPositionCenter];
    }


}
-(void)ruleBtnAction
{
    UIAlertController*alert=[UIAlertController alertControllerWithTitle:@"选择" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    for(int i=0;i<[Utils sharedInstance].groupSelectedArr.count;i++)
    {
        NSDictionary*dic=[Utils sharedInstance].groupSelectedArr[i];
        UIAlertAction*alertaction=[UIAlertAction actionWithTitle:dic[@"name"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            leftItem.title=dic[@"name"];
            rulecount=i;
            showArray=_dataArray[areacount][rulecount];
            [_tableview reloadData];
        }];
        [alert addAction:alertaction];
    }
    UIAlertAction*alertaction=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:alertaction];
    [self presentViewController:alert animated:YES completion:nil];
    

   
}
-(void)areaBtnAction
{
     NSArray*nameArr=@[@"大路",@"大眼仔路",@"小路",@"小强路"];
    UIAlertController*alert=[UIAlertController alertControllerWithTitle:@"选择" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    for(int i=0;i<nameArr.count;i++)
    {
       
        UIAlertAction*alertaction=[UIAlertAction actionWithTitle:nameArr[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            rightItem.title=nameArr[i];
            areacount=i;
            showArray=_dataArray[areacount][rulecount];
            [_tableview reloadData];
        }];
        [alert addAction:alertaction];
    }
    UIAlertAction*alertaction=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:alertaction];
    [self presentViewController:alert animated:YES completion:nil];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return showArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString*cellIndentier=@"cellIndentier";
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:cellIndentier];
    if (cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentier];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.textLabel.font=[UIFont systemFontOfSize:14.0f];
    NSString*str=showArray[indexPath.row];
    NSArray*array=[str componentsSeparatedByString:@"|"];
    cell.textLabel.text=[NSString stringWithFormat:@"第%ld位：赢%@   输%@   盈利%0.2f",indexPath.row+1,array[0],array[1],[array[0] floatValue]+[array[1] floatValue]];
    
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
   
    return 0;
}

@end
