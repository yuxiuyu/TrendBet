//
//  TBFristPageViewController.m
//  TrendBetting
//
//  Created by jiazhen-mac-01 on 16/12/28.
//  Copyright © 2016年 yxy. All rights reserved.
//

#import "TBFristPageViewController.h"
#import "Utils+encryption.h"
#import "chartImageView.h"
#import "Utils+rule.h"
#import "AppDelegate.h"
#import "TBFileRoomResult_entry.h"
#import "Utils+reencryption.h"

@interface TBFristPageViewController ()
{
    
    chartImageView *view1;
    chartImageView *view2;
    chartImageView *view3;
    chartImageView *view4;
    chartImageView *view5;
    
    NSMutableArray*listArray;//2
    
    NSString*listFristStr;//2
    NSString*listThirdStr;//2
    NSString*listForthStr;//2
    NSString*listFiveStr;//2
    
    
    NSMutableArray*fristPartArray;//1
    NSMutableArray*thirdPartArray;//3
    NSMutableArray*forthPartArray;//4
    NSMutableArray*fivePartArray;//6
    
    NSMutableArray*guessFristPartArray;
    NSMutableArray*guessThirdPartArray;
    NSMutableArray*guessForthPartArray;
    NSMutableArray*guessFivePartArray;
    NSMutableArray*allGuessArray;
    
    NSMutableArray*countGuessFristPartArray;
    NSMutableArray*countGuessThirdPartArray;
    NSMutableArray*countGuessForthPartArray;
    NSMutableArray*countGuessFivePartArray;
    NSMutableArray*countAllGuessArray;
    
    NSMutableArray*lengthAllGuessArray;


    
    NSMutableArray*sanRoadGuessArray;
    BOOL isfristCreate;
    NSTimer*checkTimer;

    

    
}
@end

@implementation TBFristPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString*string=[[Utils sharedInstance] base64String:@"TB"];
    if ([[[Utils sharedInstance] sha1:string] isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:SAVE_PASSWORD]])
    {
         isfristCreate=NO;
         [self initView];
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNotification:) name:@"changeArea" object:nil];
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
    listFristStr=@"";//2
    listThirdStr=@"";//2
    listForthStr=@"";//2
    listFiveStr=@"";//2
    //
    fristPartArray=[[NSMutableArray alloc]init];
    thirdPartArray=[[NSMutableArray alloc]init];
    forthPartArray=[[NSMutableArray alloc]init];
    fivePartArray=[[NSMutableArray alloc]init];
    
    //
    guessFristPartArray=[[NSMutableArray alloc]init];
    guessThirdPartArray=[[NSMutableArray alloc]init];
    guessForthPartArray=[[NSMutableArray alloc]init];
    guessFivePartArray=[[NSMutableArray alloc]init];
    allGuessArray=[[NSMutableArray alloc]init];
    
    countGuessFristPartArray=[[NSMutableArray alloc]init];
    countGuessThirdPartArray=[[NSMutableArray alloc]init];
    countGuessForthPartArray=[[NSMutableArray alloc]init];
    countGuessFivePartArray=[[NSMutableArray alloc]init];
    countAllGuessArray=[[NSMutableArray alloc]init];
    lengthAllGuessArray=[[NSMutableArray alloc]init];
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
    if (btn.tag==102)//和
    {
        [listArray addObject:@"T"];
        view2.itemArray=listArray;
    }
    else
    {
        NSString*str=@"";
        if (btn.tag==100)
        {
            str=@"R";//庄
        }
        else if (btn.tag==101)
        {
             str=@"B";//闲
        }
        [listArray addObject:str];
        view2.itemArray=listArray;
        [self setData:str];
        
        //下一把是庄 闲的结果
        sanRoadGuessArray=[[NSMutableArray alloc]init];
        [self guessSanRoad:@"R"];
        [self guessSanRoad:@"B"];
        [self setSanRoadImageView];
//         NSLog(@"yyyyyyyyyyyyyyyy++++++++%@",sanRoadGuessArray);

    }
}



- (IBAction)reduceBtnAction:(id)sender
{
    if (listArray.count>0)
    {
        NSString *str=[listArray lastObject];
        [listArray removeLastObject];
        view2.itemArray=listArray;
        if (![str isEqualToString:@"T"])
        {
            [self setData:@"reduce"];
            //
            sanRoadGuessArray=[[NSMutableArray alloc]init];
            [self guessSanRoad:@"R"];
            [self guessSanRoad:@"B"];
            [self setSanRoadImageView];
        }

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
        fristPartArray=[self deleteArray:fristPartArray];
        thirdPartArray=[self deleteArray:thirdPartArray];
        forthPartArray=[self deleteArray:forthPartArray];
        fivePartArray=[self deleteArray:fivePartArray];
        if (listFristStr.length>0)
        {
            listFristStr=[listFristStr substringToIndex:listFristStr.length-1];
        }
        if (listThirdStr.length>0)
        {
            listThirdStr=[listThirdStr substringToIndex:listThirdStr.length-1];
        }
        if (listForthStr.length>0)
        {
            listForthStr=[listForthStr substringToIndex:listForthStr.length-1];
        }
        if (listFiveStr.length>0)
        {
            listFiveStr=[listFiveStr substringToIndex:listFiveStr.length-1];
        }
        
       
        
        [guessFristPartArray removeLastObject];
        [guessThirdPartArray removeLastObject];
        [guessForthPartArray removeLastObject];
        [guessFivePartArray removeLastObject];
        [allGuessArray removeLastObject];
        
        [countGuessFristPartArray removeLastObject];
        [countGuessThirdPartArray removeLastObject];
        [countGuessForthPartArray removeLastObject];
        [countGuessFivePartArray removeLastObject];
        [countAllGuessArray removeLastObject];
        
        [lengthAllGuessArray removeLastObject];
    }
    else
    {
        if(fristPartArray.count>0)
        {
            
            NSMutableArray*tempArray=[[NSMutableArray alloc]initWithArray:[fristPartArray lastObject]];
            if ([[tempArray lastObject] isEqualToString:resultStr])
            {
                [tempArray addObject:resultStr];
                [fristPartArray replaceObjectAtIndex:fristPartArray.count-1 withObject:tempArray];/////接着追加
            }
            else
            {
                tempArray=[[NSMutableArray alloc]init];
                [tempArray addObject:resultStr];
                [fristPartArray addObject:tempArray];
            }
        }
        else
        {
            NSMutableArray*tempArray=[[NSMutableArray alloc]init];
            [tempArray addObject:resultStr];
            [fristPartArray addObject:tempArray];
        }
         thirdPartArray=[[Utils sharedInstance] setNewData:fristPartArray startCount:1 dataArray:thirdPartArray];
         forthPartArray=[[Utils sharedInstance] setNewData:fristPartArray startCount:2 dataArray:forthPartArray];
         fivePartArray=[[Utils sharedInstance]  setNewData:fristPartArray startCount:3 dataArray:fivePartArray];
         listFristStr=[NSString stringWithFormat:@"%@%@",listFristStr,resultStr];
         listThirdStr=[[Utils sharedInstance] addListPartData:fristPartArray startCount:1 listDataStr:listThirdStr];
         listForthStr=[[Utils sharedInstance] addListPartData:fristPartArray startCount:2 listDataStr:listForthStr];
         listFiveStr=[[Utils sharedInstance]  addListPartData:fristPartArray startCount:3 listDataStr:listFiveStr];
        
        [guessFristPartArray addObject:[[Utils sharedInstance] seacherRule:fristPartArray listStr:listFristStr myTag:0 ]];
        [guessThirdPartArray addObject:[[Utils sharedInstance] seacherRule:fristPartArray listStr:listThirdStr myTag:1 ]];
        [guessForthPartArray addObject:[[Utils sharedInstance] seacherRule:fristPartArray listStr:listForthStr myTag:2 ]];
        [guessFivePartArray addObject:[[Utils sharedInstance] seacherRule:fristPartArray listStr:listFiveStr myTag:3 ]];
        
        [countGuessFristPartArray addObject:[[Utils sharedInstance] seacherRule:fristPartArray listStr:listFristStr myTag:0]];
        [countGuessThirdPartArray addObject:[[Utils sharedInstance] seacherRule:fristPartArray listStr:listThirdStr myTag:1]];
        [countGuessForthPartArray addObject:[[Utils sharedInstance] seacherRule:fristPartArray listStr:listForthStr myTag:2]];
        [countGuessFivePartArray addObject:[[Utils sharedInstance] seacherRule:fristPartArray listStr:listFiveStr  myTag:3 ]];
        
        [self changeArea:guessFristPartArray.count-1];

        
    }
   
    //第一部分数据
    view1.itemArray=[[Utils sharedInstance] ThirdPartData:fristPartArray];
    //第三部分数据
    view3.itemArray=[[Utils sharedInstance] ThirdPartData:thirdPartArray];
    //第四部分数据
    view4.itemArray=[[Utils sharedInstance] ThirdPartData:forthPartArray];
    //第五部分数据
    view5.itemArray=[[Utils sharedInstance] ThirdPartData:fivePartArray];
    //
   
   
   
    [self setMoneyValue];
   

    
}





#pragma mark--------------设置猜下一个庄闲  下三路可能出现的情况
-(void)guessSanRoad:(NSString*)guessStr
{
    NSMutableArray*tempListArray=[[NSMutableArray alloc]initWithArray:listArray];
    [tempListArray addObject:guessStr];
    //
    NSMutableArray*tempFristPartArray=[[NSMutableArray alloc]initWithArray:fristPartArray];
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



#pragma mark--------------切换 个数 长度 区域
- (IBAction)qieRuleBtnAction:(id)sender
{
    NSString*str=@"";
    NSArray*resultArray;
    if ([Utils sharedInstance].selectedTrendCode==TBAreaTrend)
    {
        [Utils sharedInstance].selectedTrendCode=TBCoundTrend;
        str=@"个数";
        _memoLab.text=[[Utils sharedInstance] changeChina:[countAllGuessArray lastObject] isWu:NO];
        resultArray=[[Utils sharedInstance] judgeGuessRightandWrong:listArray allGuessArray:countAllGuessArray];

    }
    else if ([Utils sharedInstance].selectedTrendCode==TBCoundTrend)
    {
        [Utils sharedInstance].selectedTrendCode=TBLengthTrend;
        str=@"长度";
       _memoLab.text =[[Utils sharedInstance] changeChina:[lengthAllGuessArray lastObject] isWu:NO];
         resultArray=[[Utils sharedInstance] judgeGuessRightandWrong:listArray allGuessArray:lengthAllGuessArray];
    }
    else
    {
         [Utils sharedInstance].selectedTrendCode=TBAreaTrend;
         str=@"区域";
        _memoLab.text=[[Utils sharedInstance] changeChina:[allGuessArray lastObject] isWu:NO];
         resultArray=[[Utils sharedInstance] judgeGuessRightandWrong:listArray allGuessArray:allGuessArray];
    }
    [_qieRuleBtn setTitle:str forState:UIControlStateNormal];
    _totalWinLab.text=[NSString stringWithFormat:@"总收益:%@",resultArray[2]];
    _winOrLoseLab.text=[NSString stringWithFormat:@"输:%@    赢:%@",resultArray[0],resultArray[1]];
 
}

- (IBAction)clearBtnAction:(id)sender {

    listFristStr=@"";//2
    listThirdStr=@"";//2
    listForthStr=@"";//2
    listFiveStr=@"";//2

    [listArray removeAllObjects];
    [fristPartArray removeAllObjects];
    [thirdPartArray removeAllObjects];
    [forthPartArray removeAllObjects];
    [fivePartArray removeAllObjects];
    
    [guessFristPartArray removeAllObjects];
    [guessThirdPartArray removeAllObjects];
    [guessForthPartArray removeAllObjects];
    [guessFivePartArray removeAllObjects];
    [allGuessArray removeAllObjects];
    
    
    [countGuessFristPartArray removeAllObjects];
    [countGuessThirdPartArray removeAllObjects];
    [countGuessForthPartArray removeAllObjects];
    [countGuessFivePartArray removeAllObjects];
    [countAllGuessArray removeAllObjects];
    [lengthAllGuessArray removeAllObjects];
    
    //第一部分数据
    view1.itemArray=[[Utils sharedInstance] ThirdPartData:fristPartArray];
    view2.itemArray=listArray;
    //第三部分数据
    view3.itemArray=[[Utils sharedInstance] ThirdPartData:thirdPartArray];
    //第四部分数据
    view4.itemArray=[[Utils sharedInstance] ThirdPartData:forthPartArray];
    //第五部分数据
    view5.itemArray=[[Utils sharedInstance] ThirdPartData:fivePartArray];
    //
    
    
    _nextTrendLab.text=@"趋势: 无 : 无 : 无 : 无";
    _countTrendLab.text=@"个数: 0 : 0 : 0 : 0";
    _memoLab.text=[[Utils sharedInstance] changeChina:@"" isWu:NO];
    _totalWinLab.text=@"总收益:0.00";
    _winOrLoseLab.text=@"输:0    赢:0";
    
    for (int i=0;i<6;i++)
    {
        
        UIImageView*imageView=[self.view viewWithTag:100+i];
        imageView.image=[UIImage imageNamed:@""];
        
    }



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
//            NSMutableArray*newListArray=[[NSMutableArray alloc]init];
//            for (int i=0;i<listArray.count;i++)
//            {
//                NSString*str=listArray[i];
//                if ([str isEqualToString:@"T"])//和
//                {
//                    str=@"12";
//                }
//                else
//                {
//                    if ([str isEqualToString:@"R"])
//                    {//庄
//                        str=@"10";
//                    }
//                    else if ([str isEqualToString:@"B"])
//                    {//闲
//                        str=@"11";
//                    }
//                }
//                [newListArray addObject:str];
//                
//            }
            NSMutableDictionary*dic=[[NSMutableDictionary alloc]init];
            [dic setObject:@"" forKey:@"starttime"];
            [dic setObject:@"1" forKey:@"number"];
            [dic setObject:listArray forKey:@"result"];
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
#pragma mark--一三四五区域的选择
-(void)getNotification:(NSNotification*)userInfo
{
    NSDictionary*dic=userInfo.userInfo;
    if ([dic[@"title"] isEqualToString:SAVE_MONEY_TXT])
    {
        [self changeArea:0];
    }
    else if ([dic[@"title"] isEqualToString:SAVE_AREASELECT])
    {
         [self changeArea:0];
    }
    else if ([dic[@"title"] isEqualToString:SAVE_RBSELECT])
    {
         [self changeArea:0];
    }
    else if([dic[@"title"] isEqualToString:SAVE_RULE_TXT])
    {
        [self guessArrayinitAdd];
    }
    else if([dic[@"title"] isEqualToString:SAVE_REVERSESELECT])
    {
         [self changeArea:0];
    }
   
}
-(void)guessArrayinitAdd
{
    NSMutableArray*tempFristPartArray=[[NSMutableArray alloc]init];
    
    [guessFristPartArray removeAllObjects];
    [guessThirdPartArray removeAllObjects];
    [guessForthPartArray removeAllObjects];
    [guessFivePartArray removeAllObjects];
    
    [countGuessFristPartArray removeAllObjects];
    [countGuessThirdPartArray removeAllObjects];
    [countGuessForthPartArray removeAllObjects];
    [countGuessFivePartArray removeAllObjects];
    
    NSString*templistFristStr=@"";//2
    NSString*templistThirdStr=@"";//2
    NSString*templistForthStr=@"";//2
    NSString*templistFiveStr=@"";//2
  
    for (int i=0; i<listArray.count; i++)
    {
        NSString*resultStr=listArray[i];
        if (![resultStr isEqualToString:@"T"])
        {
            
            if(tempFristPartArray.count>0)
            {
                NSMutableArray*tempArray=[[NSMutableArray alloc]initWithArray:[tempFristPartArray lastObject]];
                if ([[tempArray lastObject] isEqualToString:resultStr])
                {
                    [tempArray addObject:resultStr];
                    [tempFristPartArray replaceObjectAtIndex:tempFristPartArray.count-1 withObject:tempArray];/////接着追加
                }
                else
                {
                    tempArray=[[NSMutableArray alloc]init];
                    [tempArray addObject:resultStr];
                    [tempFristPartArray addObject:tempArray];
                }
            }
            else
            {
                NSMutableArray*tempArray=[[NSMutableArray alloc]init];
                [tempArray addObject:resultStr];
                [tempFristPartArray addObject:tempArray];
            }

            
            
            
            templistFristStr=[NSString stringWithFormat:@"%@%@",templistFristStr,resultStr];
            templistThirdStr=[[Utils sharedInstance] addListPartData:tempFristPartArray startCount:1 listDataStr:templistThirdStr];
            templistForthStr=[[Utils sharedInstance] addListPartData:tempFristPartArray startCount:2 listDataStr:templistForthStr];
            templistFiveStr=[[Utils sharedInstance]  addListPartData:tempFristPartArray startCount:3 listDataStr:templistFiveStr];
            
            [guessFristPartArray addObject:[[Utils sharedInstance] seacherRule:tempFristPartArray listStr:templistFristStr myTag:0 ]];
            [guessThirdPartArray addObject:[[Utils sharedInstance] seacherRule:tempFristPartArray listStr:templistThirdStr myTag:1 ]];
            [guessForthPartArray addObject:[[Utils sharedInstance] seacherRule:tempFristPartArray listStr:templistForthStr myTag:2 ]];
            [guessFivePartArray addObject:[[Utils sharedInstance] seacherRule:tempFristPartArray listStr:templistFiveStr myTag:3 ]];
            
            [countGuessFristPartArray addObject:[[Utils sharedInstance] seacherRule:tempFristPartArray listStr:templistFristStr myTag:0 ]];
            [countGuessThirdPartArray addObject:[[Utils sharedInstance] seacherRule:tempFristPartArray listStr:templistThirdStr myTag:1 ]];
            [countGuessForthPartArray addObject:[[Utils sharedInstance] seacherRule:tempFristPartArray listStr:templistForthStr myTag:2 ]];
            [countGuessFivePartArray addObject:[[Utils sharedInstance] seacherRule:tempFristPartArray listStr:templistFiveStr  myTag:3 ]];

        }
       
    }
     [self changeArea:0];
    
    
   

}
-(void)changeArea:(NSInteger)indexp
{
    NSString*str=[[NSUserDefaults standardUserDefaults] objectForKey:SAVE_AREASELECT];
    NSArray*array=[NSArray arrayWithArray:[str componentsSeparatedByString:@"|"]];

    for (NSInteger i=indexp; i<guessFristPartArray.count; i++)
    {
        if (i==0)
        {
            [allGuessArray removeAllObjects];
            [countAllGuessArray removeAllObjects];
            [lengthAllGuessArray removeAllObjects];
        }
        NSMutableArray*guessArr=[[NSMutableArray alloc]initWithArray:@[guessFristPartArray[i],guessThirdPartArray[i],guessForthPartArray[i],guessFivePartArray[i]]];
        NSMutableArray*countArr=[[NSMutableArray alloc]initWithArray:@[countGuessFristPartArray[i],countGuessThirdPartArray[i],countGuessForthPartArray[i],countGuessFivePartArray[i]]];
        int removeCount=0;
        for (int j=0; j<array.count; j++)
        {
            if ([array[j] intValue]==0)
            {
                [guessArr removeObjectAtIndex:j-removeCount];
                [countArr removeObjectAtIndex:j-removeCount];
                removeCount++;
            }
        }
        [allGuessArray addObject:[[Utils sharedInstance] setGuessValue:guessArr isLength:YES]];
        [countAllGuessArray addObject:[[Utils sharedInstance] setGuessValue:countArr isLength:YES]];
        [lengthAllGuessArray addObject:[[Utils sharedInstance] seacherLengthRule:countArr]];
    }
    

    [self setMoneyValue];

}
-(void)setMoneyValue
{
    NSString*str1=[[Utils sharedInstance] changeChina:[guessFristPartArray lastObject] isWu:YES];
    NSString*str2=[[Utils sharedInstance] changeChina:[guessThirdPartArray lastObject] isWu:YES];
    NSString*str3=[[Utils sharedInstance] changeChina:[guessForthPartArray lastObject] isWu:YES];
    NSString*str4=[[Utils sharedInstance] changeChina:[guessFivePartArray lastObject] isWu:YES];
    _nextTrendLab.text=[NSString stringWithFormat:@"趋势: %@ : %@ : %@ : %@",str1,str2,str3,str4];
    _countTrendLab.text=[NSString stringWithFormat:@"个数: %ld : %ld : %ld : %ld",[[countGuessFristPartArray lastObject] length],[[countGuessThirdPartArray lastObject] length],[[countGuessForthPartArray lastObject] length],[[countGuessFivePartArray lastObject] length]];
    
    NSArray*resultArray;
    if ([Utils sharedInstance].selectedTrendCode==TBAreaTrend)
    {
        _memoLab.text=[[Utils sharedInstance] changeChina:[allGuessArray lastObject] isWu:NO];
        resultArray=[[Utils sharedInstance] judgeGuessRightandWrong:listArray allGuessArray:allGuessArray];
    }
    else if([Utils sharedInstance].selectedTrendCode==TBCoundTrend)
    {
        _memoLab.text=[[Utils sharedInstance] changeChina:[countAllGuessArray lastObject] isWu:NO];
        resultArray=[[Utils sharedInstance] judgeGuessRightandWrong:listArray allGuessArray:countAllGuessArray];
    }
    else
    {
        _memoLab.text =[[Utils sharedInstance] changeChina:[lengthAllGuessArray lastObject] isWu:NO];
        resultArray=[[Utils sharedInstance] judgeGuessRightandWrong:listArray allGuessArray:lengthAllGuessArray];
    }
    _totalWinLab.text=[NSString stringWithFormat:@"总收益:%@",resultArray[2]];
    NSLog(@"++++++%@",[resultArray lastObject]);
    _winOrLoseLab.text=[NSString stringWithFormat:@"输:%@    赢:%@",resultArray[0],resultArray[1]];
    if (_memoLab.text.length>0)
    {
        _memoLab.text=[NSString stringWithFormat:@"%@  %@",resultArray[5],_memoLab.text];
    }
}
@end
