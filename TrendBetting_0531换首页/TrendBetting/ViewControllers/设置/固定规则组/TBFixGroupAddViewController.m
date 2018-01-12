//
//  TBFixGroupAddViewController.m
//  TrendBetting
//
//  Created by jiazhen-mac-01 on 2017/9/15.
//  Copyright © 2017年 yxy. All rights reserved.
//

#import "TBFixGroupAddViewController.h"
#import "TBSwitchTableViewCell.h"
@interface TBFixGroupAddViewController ()<switchOnOrOffProtocol>
{
    NSArray*dataArray;
    NSMutableArray*ansArr;
    NSMutableArray*allArr;
}
@end

@implementation TBFixGroupAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"添加组";
    UIBarButtonItem*leftItem=[[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backBtnAction)];
    self.navigationItem.leftBarButtonItem=leftItem;
    
    dataArray=@[@"长跳",@"长连",@"小二路",@"一带规则",@"正确的一带规则",@"一带不规则",@"正确的一带不规则",@"规则带一",@"不规则带一",@"平头规则",@"文字区域的规则",@"和暂停",@"反向"];
    allArr=[[NSMutableArray alloc] initWithArray: [[Utils sharedInstance] readTenData:[NSString stringWithFormat:@"%@/%@",SAVE_RULE_FILENAME,SAVE_TenGroup_TXT]]];
    

    if (_indexStr)
    {
        self.title=@"编辑组";
        NSDictionary*dic=allArr[[_indexStr intValue]];
        _nameTextField.text=dic[@"name"];
        ansArr=[[NSMutableArray alloc] initWithArray:dic[@"listTen"]];

    }
    else
    {
        ansArr=[[NSMutableArray alloc] initWithArray:@[@"YES",@"YES",@"YES",@"YES",@"NO",@"YES",@"NO",@"YES",@"YES",@"YES",@"YES",@"YES",@"NO"]];
    }
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rulePassBack:) name:@"selectedGroupRule" object:nil];
    _tableview.tableFooterView=[[UIView alloc]init];
    UIBarButtonItem*item=[[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveBtnAction)];
    self.navigationItem.rightBarButtonItem=item;
    
    // Do any additional setup after loading the view.
}
-(void)backBtnAction
{
    UIAlertController*alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"确定不保存退出吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction*cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction*sure=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alert addAction:cancel];
    [alert addAction:sure];
    [self presentViewController:alert animated:YES completion:nil];
}
-(void)saveBtnAction
{
    if (_nameTextField.text.length<=0)
    {
        [self.view makeToast:@"请填写组名称"];
        return;
    }
    
    NSDictionary*dic=@{ @"name":_nameTextField.text,
                        @"listTen":ansArr
                        };

    if (!_indexStr)
    {

        [allArr addObject:dic];

    }
    else
    {
        
            [allArr replaceObjectAtIndex:[_indexStr intValue] withObject:dic];
            
            NSUserDefaults* defaults=[NSUserDefaults standardUserDefaults];
            NSData*data=[defaults objectForKey:SAVE_TenListBlodRule];
            tenRuleModel*tenM=[NSKeyedUnarchiver unarchiveObjectWithData:data];
            if (tenM&&[tenM.nameStr isEqualToString:_nameTextField.text]) {
                 [tenM initWithDic:dic];
                NSData*data=[NSKeyedArchiver archivedDataWithRootObject:tenM];
                [defaults setObject:data forKey:SAVE_TenListBlodRule];
                if ([defaults objectForKey:SAVE_TenDeleteBlodRule]) {
                    [defaults setObject:data forKey:SAVE_TenDeleteBlodRule];
                }
                [defaults synchronize];
            }

    }
    BOOL issuccess= [[Utils sharedInstance] saveTenData:allArr name:SAVE_TenGroup_TXT];
    if (issuccess)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self.view makeToast:@"保存失败" duration:0.5f position:CSToastPositionCenter];
    }
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ansArr.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TBSwitchTableViewCell*cell=[TBSwitchTableViewCell loadSwitchTableViewCell:tableView];
    cell.delegate=self;
    cell.mySwitch.hidden=NO;
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.titleLab.text=dataArray[indexPath.row];
    cell.mySwitch.on=[ansArr[indexPath.row] isEqualToString:@"YES"];
    cell.indexStr=[NSString stringWithFormat:@"%ld",indexPath.row];
    
    return cell;
}

#pragma mark--switchOnOrOffProtocol
-(void)switchClick:(NSString*)indexStr{
    
    switch ([indexStr intValue]) {
        case 3:
            if ([ansArr[4] isEqualToString:@"YES"]&&[ansArr[3] isEqualToString:@"NO"]) {
                [ansArr replaceObjectAtIndex:4 withObject:@"NO"];
            }
            
            break;
        case 4:
            if ([ansArr[4] isEqualToString:@"NO"]&&[ansArr[3] isEqualToString:@"YES"]) {
                [ansArr replaceObjectAtIndex:3 withObject:@"NO"];
            }
            
            break;
        case 5:
            if ([ansArr[6] isEqualToString:@"YES"]&&[ansArr[5] isEqualToString:@"NO"]) {
                [ansArr replaceObjectAtIndex:6 withObject:@"NO"];
            }
            
            break;
        case 6:
            if ([ansArr[6] isEqualToString:@"NO"]&&[ansArr[5] isEqualToString:@"YES"]) {
                [ansArr replaceObjectAtIndex:5 withObject:@"NO"];
            }
            
            break;
            
        default:
            break;
    }

    [ansArr replaceObjectAtIndex:[indexStr intValue] withObject:[ansArr[[indexStr intValue]] isEqualToString:@"YES"]?@"NO":@"YES"];
    [_tableview reloadData];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
