//
//  TBNewFirstViewController.m
//  TrendBetting
//
//  Created by 于秀玉 on 17/5/20.
//  Copyright © 2017年 yxy. All rights reserved.
//

#import "TBNewFirstViewController.h"
#import "Utils+encryption.h"
#import "chartImageView.h"
#import "Utils+newRules.h"
#import "AppDelegate.h"
#import "TBFileRoomResult_entry.h"
#import "Utils+reencryption.h"
#import "Utils+xiasanluRule.h"
@interface TBNewFirstViewController ()
{
    chartImageView *view1;
    chartImageView *view2;
    chartImageView *view3;
    chartImageView *view4;
    chartImageView *view5;
    
    NSMutableArray*listArray;//2

    
    
    NSMutableArray*secondPartArray;//1
    NSMutableArray*thirdPartArray;//3
    NSMutableArray*forthPartArray;//4
    NSMutableArray*fivePartArray;//6
    
    NSMutableArray*guessFirstPartArray;
    NSMutableArray*guessSecondPartArray;
    NSMutableArray*guessThirdPartArray;
    NSMutableArray*guessForthPartArray;
    NSMutableArray*guessFivePartArray;
    
    NSMutableArray*arrGuessSecondPartArray;


    
    
    
    NSMutableArray*sanRoadGuessArray;
    BOOL isfristCreate;
    NSTimer*checkTimer;

}

@end

@implementation TBNewFirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString*string=[[Utils sharedInstance] base64String:@"TB"];
    if (![[[Utils sharedInstance] sha1:string] isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:SAVE_PASSWORD]])
    {
        isfristCreate=NO;
        [self initView];
        [self addTimer];
        
    }
    else
    {
        [self showKeyView];
    }
    
}
-(void)showKeyView
{
    _bgMemoView.frame=self.view.frame;
    [_answerKeyTextView borderColor:[UIColor lightGrayColor]];
    [_answerKeyTextView circle:5.0f];
    isfristCreate=YES;
    _myKeyTextView.text=[[Utils sharedInstance] base64String:@"TB"];
    _bgMemoView.hidden=NO;
    AppDelegate*del=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    [del.window addSubview:_bgMemoView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=YES;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!isfristCreate)
    {
        [self initFiveView];
    }
}
-(void)initView
{
    listArray=[[NSMutableArray alloc]init];

    //
    secondPartArray=[[NSMutableArray alloc]init];
    thirdPartArray=[[NSMutableArray alloc]init];
    forthPartArray=[[NSMutableArray alloc]init];
    fivePartArray=[[NSMutableArray alloc]init];
    
    guessFirstPartArray=[[NSMutableArray alloc]init];
    guessSecondPartArray=[[NSMutableArray alloc]init];
    guessThirdPartArray=[[NSMutableArray alloc]init];
    guessForthPartArray=[[NSMutableArray alloc]init];
    guessFivePartArray=[[NSMutableArray alloc]init];
    
    arrGuessSecondPartArray=[[NSMutableArray alloc]init];

}
-(void)initFiveView
{
    view1=[[chartImageView alloc]initWithFrame:CGRectMake(0, 0, _fristCollection.frame.size.width, _fristCollection.frame.size.height-1)];
    view1.myType=1;
    [_fristCollection addSubview:view1];
    //
    view2=[[chartImageView alloc]initWithFrame:CGRectMake(0, 0, _secondView.frame.size.width-1, _secondView.frame.size.height)];
    view2.myType=2;
    [_secondView addSubview:view2];
    //
    view3=[[chartImageView alloc]initWithFrame:CGRectMake(0, 0, _thirdView.frame.size.width, _thirdView.frame.size.height-1)];
    view3.myType=3;
    [_thirdView addSubview:view3];
    
    //
    view4=[[chartImageView alloc]initWithFrame:CGRectMake(0, 0, _fourthView.frame.size.width, _fourthView.frame.size.height-1)];
    view4.myType=4;
    [_fourthView addSubview:view4];
    //
    view5=[[chartImageView alloc]initWithFrame:CGRectMake(0, 0, _fiveView.frame.size.width, _fiveView.frame.size.height-1)];
    view5.myType=5;
    [_fiveView addSubview:view5];
    isfristCreate=!isfristCreate;
}
-(void)addTimer
{
    checkTimer=[NSTimer scheduledTimerWithTimeInterval:1800 target:self selector:@selector(checkPassword) userInfo:nil repeats:YES];
}
-(void)checkPassword
{
    NSString*string=[[Utils sharedInstance] rebase64String:@"TB"];
    if (![[[Utils sharedInstance] resha1:string] isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:SAVE_PASSWORD]])
    {
        [self showKeyView];
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)BPTBtnAction:(id)sender
{
    UIButton*btn=(UIButton*)sender;
    NSString*str=@"";
    if (btn.tag==100)
    {
        str=@"R";//庄
    }
    else if (btn.tag==101)
    {
        str=@"B";//闲
    }
    else if(btn.tag==102)
    {
         str=@"T";//和
    }
    [listArray addObject:str];
    view2.itemArray=listArray;
    [guessFirstPartArray addObject:[[Utils sharedInstance] searchFirstRule:listArray]];

    if (btn.tag!=102)
    {
        [self setData:str];
        //下一把是庄 闲的结果
        sanRoadGuessArray=[[NSMutableArray alloc]init];
        [self guessSanRoad:@"R"];
        [self guessSanRoad:@"B"];
        [self setSanRoadImageView];
    }
    [self setMoneyValue];
}



- (IBAction)reduceBtnAction:(id)sender
{
    if (listArray.count>0)
    {
        NSString *str=[listArray lastObject];
        [listArray removeLastObject];
        view2.itemArray=listArray;
        [guessFirstPartArray removeLastObject];
        if (![str isEqualToString:@"T"])
        {
            [self setData:@"reduce"];
            //
            sanRoadGuessArray=[[NSMutableArray alloc]init];
            [self guessSanRoad:@"R"];
            [self guessSanRoad:@"B"];
            [self setSanRoadImageView];
        }
         [self setMoneyValue];
        
    }
}


-(NSMutableArray*)deleteArray:(NSMutableArray*)tempArray
{
    NSMutableArray*tempArray1=[[NSMutableArray alloc]initWithArray:[tempArray lastObject]];
    if (tempArray1.count<=1)
    {
        [tempArray removeLastObject];
    }
    else
    {
        [tempArray1 removeLastObject];
        [tempArray replaceObjectAtIndex:tempArray.count-1 withObject:tempArray1];
    }
    return tempArray;
}

-(void)setData:(NSString*)resultStr
{
    if ([resultStr isEqualToString:@"reduce"])
    {
        secondPartArray=[self deleteArray:secondPartArray];
        thirdPartArray=[self deleteArray:thirdPartArray];
        forthPartArray=[self deleteArray:forthPartArray];
        fivePartArray=[self deleteArray:fivePartArray];
        
        [guessSecondPartArray removeLastObject];
        [guessThirdPartArray removeLastObject];
        [guessForthPartArray removeLastObject];
        [guessFivePartArray removeLastObject];
        
        [arrGuessSecondPartArray removeLastObject];

    }
    else
    {
        if(secondPartArray.count>0)
        {
            
            NSMutableArray*tempArray=[[NSMutableArray alloc]initWithArray:[secondPartArray lastObject]];
            if ([[tempArray lastObject] isEqualToString:resultStr])
            {
                [tempArray addObject:resultStr];
                [secondPartArray replaceObjectAtIndex:secondPartArray.count-1 withObject:tempArray];/////接着追加
            }
            else
            {
                tempArray=[[NSMutableArray alloc]init];
                [tempArray addObject:resultStr];
                [secondPartArray addObject:tempArray];
            }
        }
        else
        {
            NSMutableArray*tempArray=[[NSMutableArray alloc]init];
            [tempArray addObject:resultStr];
            [secondPartArray addObject:tempArray];
        }
        thirdPartArray=[[Utils sharedInstance] setNewData:secondPartArray startCount:1 dataArray:thirdPartArray];
        forthPartArray=[[Utils sharedInstance] setNewData:secondPartArray startCount:2 dataArray:forthPartArray];
        fivePartArray=[[Utils sharedInstance]  setNewData:secondPartArray startCount:3 dataArray:fivePartArray];
        
    }


    
    if (![resultStr isEqualToString:@"reduce"])
    {
            [arrGuessSecondPartArray addObject:[[Utils sharedInstance] seacherNewsRule:secondPartArray arrGuessPartArray:arrGuessSecondPartArray.count>0?[arrGuessSecondPartArray lastObject]:nil]];
            [guessThirdPartArray addObject:[[Utils sharedInstance] seacherSpecRule:thirdPartArray resultArray:guessThirdPartArray.count>0?[guessThirdPartArray lastObject]:nil] ];
            [guessForthPartArray addObject:[[Utils sharedInstance] seacherSpecRule:forthPartArray resultArray:guessForthPartArray.count>0?[guessForthPartArray lastObject]:nil]];
            [guessFivePartArray addObject:[[Utils sharedInstance] seacherSpecRule:fivePartArray resultArray:guessFivePartArray.count>0?[guessFivePartArray lastObject]:nil]];
        
           [guessSecondPartArray addObject: [[Utils sharedInstance] getGuessValue:[arrGuessSecondPartArray lastObject] partArray:secondPartArray fristPartArray:secondPartArray myTag:0]];
    }
  
    
    //第一部分数据
    view1.itemArray=[[Utils sharedInstance] newPartData:secondPartArray specArray:[arrGuessSecondPartArray lastObject]];
    //第三部分数据
    view3.itemArray=[[Utils sharedInstance] newPartData:thirdPartArray specArray:nil];
    //第四部分数据
    view4.itemArray=[[Utils sharedInstance] newPartData:forthPartArray specArray:nil];
    //第五部分数据
    view5.itemArray=[[Utils sharedInstance] newPartData:fivePartArray specArray:nil];
    
   
    
    
    
}

-(void)setMoneyValue
{
    NSArray*array0=[guessFirstPartArray lastObject];
    NSArray*array2=[guessThirdPartArray lastObject];
    NSArray*array3=[guessForthPartArray lastObject];
    NSArray*array4=[guessFivePartArray lastObject];
    
    NSString*guessStr2=[[array2 lastObject] length]>0?[[Utils sharedInstance] backRuleSeacher:secondPartArray ruleStr:[array2 lastObject] myTag:1]:@"";
    NSString*guessStr3=[[array3 lastObject] length]>0?[[Utils sharedInstance] backRuleSeacher:secondPartArray ruleStr:[array3 lastObject] myTag:2]:@"";
    NSString*guessStr4=[[array4 lastObject] length]>0?[[Utils sharedInstance] backRuleSeacher:secondPartArray ruleStr:[array4 lastObject] myTag:3]:@"";
    
   
    NSString*str0=[[Utils sharedInstance] changeChina:[array0 lastObject] isWu:YES];
    NSString*str1=[[Utils sharedInstance] changeChina:[guessSecondPartArray lastObject] isWu:YES];
    NSString*str2=[[Utils sharedInstance] changeChina:guessStr2 isWu:YES];
    NSString*str3=[[Utils sharedInstance] changeChina:guessStr3 isWu:YES];
    NSString*str4=[[Utils sharedInstance] changeChina:guessStr4 isWu:YES];
    
    NSString*nameStr2=[str2 isEqualToString:@"无"]?@"":[array2 firstObject];
    NSString*nameStr3=[str3 isEqualToString:@"无"]?@"":[array3 firstObject];
    NSString*nameStr4=[str4 isEqualToString:@"无"]?@"":[array4 firstObject];
    _areaTrendLab1.text=[NSString stringWithFormat:@"        文字:%@%@",array0[0],str0];
    _areaTrendLab2.text=[NSString stringWithFormat:@"        大路:%@           小路:%@%@",str1,nameStr3,str3];
    _areaTrendLab3.text=[NSString stringWithFormat:@"大眼仔路:%@%@       小强路:%@%@",nameStr2,str2,nameStr4,str4];
}



#pragma mark--------------设置猜下一个庄闲  下三路可能出现的情况
-(void)guessSanRoad:(NSString*)guessStr
{
    NSMutableArray*tempListArray=[[NSMutableArray alloc]initWithArray:listArray];
    [tempListArray addObject:guessStr];
    //
    NSMutableArray*tempFristPartArray=[[NSMutableArray alloc]initWithArray:secondPartArray];
    if(tempFristPartArray.count>0)
    {
        
        NSMutableArray*tempArray=[[NSMutableArray alloc]initWithArray:[tempFristPartArray lastObject]];
        if ([[tempArray lastObject] isEqualToString:guessStr])
        {
            [tempArray addObject:guessStr];
            [tempFristPartArray replaceObjectAtIndex:tempFristPartArray.count-1 withObject:tempArray];/////接着追加
        }
        else
        {
            tempArray=[[NSMutableArray alloc]init];
            [tempArray addObject:guessStr];
            [tempFristPartArray addObject:tempArray];
        }
    }
    else
    {
        NSMutableArray*tempArray=[[NSMutableArray alloc]init];
        [tempArray addObject:guessStr];
        [tempFristPartArray addObject:tempArray];
    }
    
    
    for (int startCount=1; startCount<4; startCount++)
    {
        NSString*addStr=@"";
        NSInteger i=tempFristPartArray.count-1;
        if (i>=startCount)
        {
            NSArray*tempArray=[NSArray arrayWithArray:[tempFristPartArray lastObject]];
            NSInteger j=tempArray.count-1;
            if (i!=startCount||j!=0)
            {
                addStr=@"R";
                if (j==0)
                {
                    if ([tempFristPartArray[i-startCount-1] count]!=[tempFristPartArray[i-1]  count])
                    {
                        addStr=@"B";
                    }
                }
                if ([tempFristPartArray[i-startCount] count]==j)
                {
                    addStr=@"B";
                }
            }
        }
        [sanRoadGuessArray addObject:addStr];
        
    }
    
}

#pragma mark--------------设置猜下一个庄闲  下三路可能出现的情况给小6个imageview显示
-(void)setSanRoadImageView
{
    for (int i=0;i<sanRoadGuessArray.count;i++)
    {
        NSString*str = sanRoadGuessArray[i];
        UIImageView*imageView=[self.view viewWithTag:100+i];
        if (str.length<=0)
        {
            imageView.image=[UIImage imageNamed:@""];
        }
        else if([str isEqualToString:@"B"])
        {
            imageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"blueRound%d",i%3]];
        }
        else
        {
            imageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"redRound%d",i%3]];
        }
    }
}





- (IBAction)clearBtnAction:(id)sender {

    
    [listArray removeAllObjects];
    [secondPartArray removeAllObjects];
    [thirdPartArray removeAllObjects];
    [forthPartArray removeAllObjects];
    [fivePartArray removeAllObjects];
    
    [guessSecondPartArray removeAllObjects];
    [guessThirdPartArray removeAllObjects];
    [guessForthPartArray removeAllObjects];
    [guessFivePartArray removeAllObjects];
    
    [arrGuessSecondPartArray removeAllObjects];
//    [arrGuessThirdPartArray removeAllObjects];
//    [arrGuessForthPartArray removeAllObjects];
//    [arrGuessFivePartArray removeAllObjects];

    

    
    //第一部分数据
    view1.itemArray=[[Utils sharedInstance] ThirdPartData:secondPartArray];
    view2.itemArray=listArray;
    //第三部分数据
    view3.itemArray=[[Utils sharedInstance] ThirdPartData:thirdPartArray];
    //第四部分数据
    view4.itemArray=[[Utils sharedInstance] ThirdPartData:forthPartArray];
    //第五部分数据
    view5.itemArray=[[Utils sharedInstance] ThirdPartData:fivePartArray];
    //

    for (int i=0;i<6;i++)
    {
        UIImageView*imageView=[self.view viewWithTag:100+i];
        imageView.image=[UIImage imageNamed:@""];
    }
    
    ///
    _areaTrendLab1.text=@"文字:无";
    _areaTrendLab2.text=@"大路:无             小路:无";
    _areaTrendLab3.text=@"大眼仔路:无          小强路:无";
//    _memoLab.text=[[Utils sharedInstance] changeChina:@"" isWu:NO];
//    _totalWinLab.text=@"总收益:0.00";
//    _winOrLoseLab.text=@"输:0    赢:0";


    
}

- (IBAction)closeProjectBtnAction:(id)sender {
    AppDelegate*del=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    UIWindow*window=del.window;
    [UIView animateWithDuration:0.5f animations:^{
        window.alpha=0;
        window.frame=CGRectMake(0, window.bounds.size.width, 0, 0);
    } completion:^(BOOL finished) {
        exit(0);
    }];
}

- (IBAction)saveBtnAction:(id)sender
{
    if (listArray.count>0)
    {
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSMutableArray*newListArray=[[NSMutableArray alloc]init];
            for (int i=0;i<listArray.count;i++)
            {
                NSString*str=listArray[i];
                if ([str isEqualToString:@"T"])//和
                {
                    str=@"12";
                }
                else
                {
                    if ([str isEqualToString:@"R"])
                    {//庄
                        str=@"10";
                    }
                    else if ([str isEqualToString:@"B"])
                    {//闲
                        str=@"11";
                    }
                }
                [newListArray addObject:str];
                
            }
            NSMutableDictionary*dic=[[NSMutableDictionary alloc]init];
            [dic setObject:@"" forKey:@"starttime"];
            [dic setObject:@"1" forKey:@"number"];
            [dic setObject:newListArray forKey:@"result"];
            [dic setObject:@[] forKey:@"banker"];
            [dic setObject:@[] forKey:@"play"];
            [dic setObject:@"" forKey:@"endtime"];
            
            NSMutableArray*arr=[[NSMutableArray alloc]init];
            NSMutableDictionary*allDic=[[NSMutableDictionary alloc]initWithDictionary:[[Utils sharedInstance] readData:nil]];
            if (allDic.count)
            {
                NSArray*roomArr=allDic[@"roomArr"];
                NSMutableDictionary*roomDic=[[NSMutableDictionary alloc]initWithDictionary:roomArr[0]];
                NSArray*timeArr=roomDic[@"timeArr"];
                NSMutableDictionary*timeDic=[[NSMutableDictionary alloc] initWithDictionary:timeArr[0]];
                
                //            TBFileRoomResult_roomArr*room=entry.roomArr[0];
                //            TBFileRoomResult_timeArr*time=room.timeArr[0];
                [arr addObjectsFromArray:timeDic[@"dataArr"]];
                [dic setObject:[NSString stringWithFormat:@"%ld",arr.count+1] forKey:@"number"];
                [arr addObject:dic];
                [timeDic setObject:arr forKey:@"dataArr"];
                [roomDic setObject:@[timeDic] forKey:@"timeArr"];
                [allDic setObject:@[roomDic] forKey:@"roomArr"];
                
                
                
                
                
            }
            else
            {
                [arr addObject:dic];
                NSMutableArray*roomArr=[[NSMutableArray alloc]init];
                NSMutableDictionary*roomDic=[[NSMutableDictionary alloc]init];
                NSMutableArray*timeArr=[[NSMutableArray alloc]init];
                NSMutableDictionary*timeDic=[[NSMutableDictionary alloc]init];
                [timeDic setObject:@"" forKey:@"time"];
                [timeDic setObject:arr forKey:@"dataArr"];
                
                [timeArr addObject:timeDic];
                [roomDic setObject:@"00" forKey:@"roomid"];
                [roomDic setObject:timeArr forKey:@"timeArr"];
                [roomArr addObject:roomDic];
                [allDic setObject:roomArr forKey:@"roomArr"];
            }
            
            
            
            
            
            
            BOOL issuccess =[[Utils sharedInstance] saveData:allDic saveArray:nil filePathStr:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (issuccess)
                {
                    [self clearBtnAction:nil];
                    [self.view makeToast:@"保存成功" duration:0.5f position:CSToastPositionCenter];
                }
                else
                {
                    [self.view makeToast:@"保存失败" duration:0.5f position:CSToastPositionCenter];
                }
                
            });
            
        });
        
        
    }
    else
    {
        [self.view makeToast:@"记录数据为空，请先记录数据" duration:0.5f position:CSToastPositionCenter];
    }
    
}

- (IBAction)resultLookBtnAction:(id)sender
{
    [self performSegueWithIdentifier:@"showResultVC" sender:nil];
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"showResultVC"])
    {
        UIViewController*vc=[segue destinationViewController];
        [vc setValuesForKeysWithDictionary:(NSDictionary*)sender];
    }
}

- (IBAction)checkBtnAction:(id)sender
{
    NSString*string=[[Utils sharedInstance] base64String:@"TB"];
    if ([[[Utils sharedInstance] sha1:string] isEqualToString:_answerKeyTextView.text])
    {
        self.bgMemoView.hidden=YES;
        isfristCreate=NO;
        [self initView];
        [self initFiveView];
        [[NSUserDefaults standardUserDefaults] setObject:_answerKeyTextView.text forKey:SAVE_PASSWORD];
    }
    else
    {
        [self.view makeToast:@"秘钥错误" duration:0.5f position:CSToastPositionCenter];
    }
}

@end
