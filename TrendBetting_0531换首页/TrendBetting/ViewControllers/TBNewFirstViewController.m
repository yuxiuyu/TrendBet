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
#import "TBNewRule_TimeViewController.h"
#import "TBWebService+Login&Register.h"
@interface TBNewFirstViewController ()
{
    chartImageView *view1;
    chartImageView *view2;
    chartImageView *view3;
    chartImageView *view4;
    chartImageView *view5;
    
    NSMutableArray*listArray;//2
    
    NSMutableArray*showSecondPartArray;//1
    NSMutableArray*secondPartArray;//1
    NSMutableArray*thirdPartArray;//3
    NSMutableArray*forthPartArray;//4
    NSMutableArray*fivePartArray;//6
    
    NSMutableArray*guessFirstPartArray;//文字
    NSMutableArray*guessSecondPartArray;
    NSMutableArray*guessThirdPartArray;
    NSMutableArray*guessForthPartArray;
    NSMutableArray*guessFivePartArray;
    
    
    NSMutableArray*arrGuessSecondPartArray;
    
    NSMutableArray*allGuessArray;
    
    
    
    
    NSMutableArray*sanRoadGuessArray;
    BOOL isfristCreate;
    NSTimer*checkTimer;
    NSInteger sumCount;
    tenRuleModel*tenM;
    
    
}

@end

@implementation TBNewFirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString*roomStr=@"1";
    NSString*endtimeStr=[NSString stringWithFormat:@"%ld",[[NSDate date] timeIntervalSince1970]];
    NSString*seekStr=[NSString stringWithFormat:@"%.8d",arc4random()%100000000];
    NSDictionary*dic=@{@"roomid":roomStr,
                       @"endtime":endtimeStr,
                       @"seek":seekStr,
                       @"md5str":[[Utils sharedInstance] stringFromMD5:[NSString stringWithFormat:@"%@%@%@",roomStr,endtimeStr,seekStr]]};
    [[TBWebService sharedInstance] getServerData:dic success:^(NSDictionary *responseObject) {
         NSLog(@"res is %@",responseObject);
    } failure:^(NSString *error) {
         NSLog(@"error is %@",error);
    }];
    
    NSString*string=[[Utils sharedInstance] base64String:@"TB"];
    if (![[[Utils sharedInstance] sha1:string] isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:SAVE_PASSWORD]])
    {
        isfristCreate=NO;
        [self initView];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNotification:) name:@"changeArea" object:nil];
        
        //        [self addTimer];
        
    }
    else
    {
        [self showKeyView];
    }
    
}
-(void)showKeyView
{
    _bgMemoView.frame=self.view.frame;
    NSDictionary*appInfoDic=[[NSBundle mainBundle] infoDictionary];
    _versionLab.text=[NSString stringWithFormat:@"当前版本:ver.%@",appInfoDic[@"CFBundleVersion"]];
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
    tenM=[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:SAVE_TenBlodRule]];
    [Utils sharedInstance].tenModel=tenM;
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
    showSecondPartArray=[[NSMutableArray alloc]init];
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
    allGuessArray=[[NSMutableArray alloc]init];
    
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
//-(void)addTimer
//{
//    checkTimer=[NSTimer scheduledTimerWithTimeInterval:1800 target:self selector:@selector(checkPassword) userInfo:nil repeats:YES];
//}
//-(void)checkPassword
//{
//    NSString*string=[[Utils sharedInstance] rebase64String:@"TB"];
//    if ([[[Utils sharedInstance] resha1:string] isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:SAVE_PASSWORD]])
//    {
//        [self showKeyView];
//    }
//
//}
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
        sumCount++;
        /////
        if(showSecondPartArray.count>0)
        {
            NSMutableArray*tepA=[[NSMutableArray alloc]initWithArray:[showSecondPartArray lastObject]];
            NSString*str=[tepA lastObject];
            if (str.length==1)
            {
                str=[NSString stringWithFormat:@"%@_1_",str];
            }
            else
            {
                NSArray*arr=[str componentsSeparatedByString:@"_"];
                str=[NSString stringWithFormat:@"%@_%d_",arr[0],[arr[1] intValue]+1];
            }
            [tepA replaceObjectAtIndex:tepA.count-1 withObject:str];
            [showSecondPartArray replaceObjectAtIndex:showSecondPartArray.count-1 withObject:tepA];
            //第一部分数据
            view1.itemArray=[[Utils sharedInstance] newPartData:showSecondPartArray specArray:[arrGuessSecondPartArray lastObject]];
            
        }
        /////
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
    [self setMoneyValue:YES];
}



- (IBAction)reduceBtnAction:(id)sender
{
    if (listArray.count>0)
    {
        NSString *str=[listArray lastObject];
        [listArray removeLastObject];
        view2.itemArray=listArray;
        [guessFirstPartArray removeLastObject];
        [allGuessArray removeLastObject];
        if (![str isEqualToString:@"T"])
        {
            [self setData:@"reduce"];
            //
            sanRoadGuessArray=[[NSMutableArray alloc]init];
            [self guessSanRoad:@"R"];
            [self guessSanRoad:@"B"];
            [self setSanRoadImageView];
        }
        else
        {
            sumCount--;
            if(showSecondPartArray.count>0)
            {
                NSMutableArray*tepA=[[NSMutableArray alloc]initWithArray:[showSecondPartArray lastObject]];
                NSString*str=[tepA lastObject];
                if (str.length>1)
                {
                    NSArray*arr=[str componentsSeparatedByString:@"_"];
                    str=[NSString stringWithFormat:@"%@_%d_",arr[0],[arr[1] intValue]-1];
                    if([arr[1] intValue]-1==0)
                    {
                        str=arr[0];
                    }
                    [tepA replaceObjectAtIndex:tepA.count-1 withObject:str];
                    [showSecondPartArray replaceObjectAtIndex:showSecondPartArray.count-1 withObject:tepA];
                    //第一部分数据
                    view1.itemArray=[[Utils sharedInstance] newPartData:showSecondPartArray specArray:[arrGuessSecondPartArray lastObject]];
                }
            }
            
        }
        [self setMoneyValue:NO];
        
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
        showSecondPartArray=[self deleteArray:showSecondPartArray];
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
            NSMutableArray*tempArray1=[[NSMutableArray alloc]initWithArray:[showSecondPartArray lastObject]];
            if ([[tempArray lastObject] containsString:resultStr])
            {
                [tempArray addObject:resultStr];
                [tempArray1 addObject:resultStr];
                [secondPartArray replaceObjectAtIndex:secondPartArray.count-1 withObject:tempArray];/////接着追加
                [showSecondPartArray replaceObjectAtIndex:showSecondPartArray.count-1 withObject:tempArray1];/////接着追加
            }
            else
            {
                tempArray=[[NSMutableArray alloc]init];
                [tempArray addObject:resultStr];
                [secondPartArray addObject:tempArray];
                [showSecondPartArray addObject:tempArray];
            }
        }
        else
        {
            NSMutableArray*tempArray=[[NSMutableArray alloc]init];
            [tempArray addObject:resultStr];
            [secondPartArray addObject:tempArray];
            [showSecondPartArray addObject:tempArray];
        }
        thirdPartArray=[[Utils sharedInstance] setNewData:secondPartArray startCount:1 dataArray:thirdPartArray];
        forthPartArray=[[Utils sharedInstance] setNewData:secondPartArray startCount:2 dataArray:forthPartArray];
        fivePartArray=[[Utils sharedInstance]  setNewData:secondPartArray startCount:3 dataArray:fivePartArray];
        
        [arrGuessSecondPartArray addObject:[[Utils sharedInstance] seacherNewsRule:secondPartArray arrGuessPartArray:arrGuessSecondPartArray.count>0?[arrGuessSecondPartArray lastObject]:nil]];
        
        
        [guessThirdPartArray addObject:[[Utils sharedInstance] seacherSpecRule:thirdPartArray resultArray:[guessThirdPartArray lastObject] secondPartArray:secondPartArray myTag:1]];
        [guessForthPartArray addObject:[[Utils sharedInstance] seacherSpecRule:forthPartArray resultArray:[guessForthPartArray lastObject] secondPartArray:secondPartArray myTag:2]];
        [guessFivePartArray addObject:[[Utils sharedInstance] seacherSpecRule:fivePartArray resultArray:[guessFivePartArray lastObject]  secondPartArray:secondPartArray myTag:3]];
        
        [guessSecondPartArray addObject: [[Utils sharedInstance] getGuessValue:[arrGuessSecondPartArray lastObject] partArray:secondPartArray fristPartArray:secondPartArray myTag:0]];
    }
    
    
    //第一部分数据
    view1.itemArray=[[Utils sharedInstance] newPartData:showSecondPartArray specArray:[arrGuessSecondPartArray lastObject]];
    //第三部分数据
    view3.itemArray=[[Utils sharedInstance] newPartData:thirdPartArray specArray:nil];
    //第四部分数据
    view4.itemArray=[[Utils sharedInstance] newPartData:forthPartArray specArray:nil];
    //第五部分数据
    view5.itemArray=[[Utils sharedInstance] newPartData:fivePartArray specArray:nil];
    
    
    
    
    
}
-(void)guessArrayinitAdd
{
    NSMutableArray*tempSecondPartArray=[[NSMutableArray alloc]init];
    NSMutableArray*tepthirdPartArray=[[NSMutableArray alloc]init];
    NSMutableArray*tepforthPartArray=[[NSMutableArray alloc]init];
    NSMutableArray*tepfivePartArray=[[NSMutableArray alloc]init];
    
    [guessThirdPartArray removeAllObjects];
    [guessForthPartArray removeAllObjects];
    [guessFivePartArray removeAllObjects];
    
    for (int i=0; i<listArray.count; i++)
    {
        NSString*resultStr=listArray[i];
        if (![resultStr isEqualToString:@"T"])
        {
            
            if(tempSecondPartArray.count>0)
            {
                NSMutableArray*tempArray=[[NSMutableArray alloc]initWithArray:[tempSecondPartArray lastObject]];
                if ([[tempArray lastObject] isEqualToString:resultStr])
                {
                    [tempArray addObject:resultStr];
                    [tempSecondPartArray replaceObjectAtIndex:tempSecondPartArray.count-1 withObject:tempArray];/////接着追加
                }
                else
                {
                    tempArray=[[NSMutableArray alloc]init];
                    [tempArray addObject:resultStr];
                    [tempSecondPartArray addObject:tempArray];
                }
            }
            else
            {
                NSMutableArray*tempArray=[[NSMutableArray alloc]init];
                [tempArray addObject:resultStr];
                [tempSecondPartArray addObject:tempArray];
            }
            tepthirdPartArray=[[Utils sharedInstance] setNewData:tempSecondPartArray startCount:1 dataArray:tepthirdPartArray];
            tepforthPartArray=[[Utils sharedInstance] setNewData:tempSecondPartArray startCount:2 dataArray:tepforthPartArray];
            tepfivePartArray=[[Utils sharedInstance]  setNewData:tempSecondPartArray startCount:3 dataArray:tepfivePartArray];
            
            [guessThirdPartArray addObject:[[Utils sharedInstance] seacherSpecRule:tepthirdPartArray resultArray:[guessThirdPartArray lastObject] secondPartArray:tempSecondPartArray myTag:1]];
            [guessForthPartArray addObject:[[Utils sharedInstance] seacherSpecRule:tepforthPartArray resultArray:[guessForthPartArray lastObject] secondPartArray:tempSecondPartArray myTag:2]];
            [guessFivePartArray addObject:[[Utils sharedInstance] seacherSpecRule:tepfivePartArray resultArray:[guessFivePartArray lastObject]  secondPartArray:tempSecondPartArray myTag:3]];
            
        }
       
    }
     [self changeArea:0];
    [self setMoneyValue:NO];
    
}

-(void)changeArea:(NSInteger)indexp
{
    
    for (NSInteger i=indexp; i<listArray.count; i++)
    {
        if (i==0)
        {
            [allGuessArray removeAllObjects];
            sumCount=0;
        }
        if ([listArray[i] isEqualToString:@"T"]&&indexp==0)
        {
            sumCount++;
        }
        NSString*str=@"";
        NSString*secGuessLastStr=guessSecondPartArray.count>0?guessSecondPartArray[i-sumCount]:@"";
        if([listArray[i] isEqualToString:@"T"]&&secGuessLastStr.length>0&&[tenM.tRule isEqualToString:@"YES"]){
            [guessSecondPartArray replaceObjectAtIndex:i-sumCount withObject:@"stop"];
        }
        else
        {
            secGuessLastStr=guessSecondPartArray.count>0?guessSecondPartArray[i-sumCount]:@"";
            if (secGuessLastStr.length>0)
            {
                NSString*firstStr=[guessFirstPartArray[i] lastObject];
                if ([tenM.wordRule isEqualToString:@"NO"]){
                    firstStr=@"";
                }
                NSMutableArray*guessArr=[[NSMutableArray alloc]initWithArray:@[firstStr,secGuessLastStr,[guessThirdPartArray[i-sumCount] lastObject],[guessForthPartArray[i-sumCount] lastObject],[guessFivePartArray[i-sumCount] lastObject]]];
                str=[[Utils sharedInstance] setGuessValue:guessArr isLength:NO];
            }
        }
        [allGuessArray addObject:str];
    }
    if (indexp==0)
    {
        [self setMoneyValue:NO];
    }
    
}
-(void)setMoneyValue:(BOOL)isadd
{
    if (isadd)
    {
        [self changeArea:listArray.count-1];
    }
    NSArray*array0=[guessFirstPartArray lastObject];
    if ([tenM.wordRule isEqualToString:@"NO"]) {
        array0=@[@"",@""];
    }
    
    NSArray*array2=[guessThirdPartArray lastObject];
    NSArray*array3=[guessForthPartArray lastObject];
    NSArray*array4=[guessFivePartArray lastObject];
    
    
    NSString*str0=[[Utils sharedInstance] changeChina:[array0 lastObject] isWu:YES];
    //    NSString*str1=[[Utils sharedInstance] changeChina:[[guessSecondPartArray lastObject] isEqualToString:@"stop"]?@"":[guessSecondPartArray lastObject] isWu:YES];
    NSString*str1=[[Utils sharedInstance] changeChina:[guessSecondPartArray lastObject] isWu:YES];
    NSString*str2=[[Utils sharedInstance] changeChina:[array2 lastObject] isWu:YES];
    NSString*str3=[[Utils sharedInstance] changeChina:[array3 lastObject] isWu:YES];
    NSString*str4=[[Utils sharedInstance] changeChina:[array4 lastObject] isWu:YES];
    
    NSString*nameStr2=[str2 isEqualToString:@"无"]?@"":[array2 firstObject];
    NSString*nameStr3=[str3 isEqualToString:@"无"]?@"":[array3 firstObject];
    NSString*nameStr4=[str4 isEqualToString:@"无"]?@"":[array4 firstObject];
    NSArray* resultArray;
    //yxy add 2017/07/17 新加把把下庄闲
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:SAVE_isOnlyRBSelect] intValue]==1) {
        NSMutableArray*yarr=[[NSMutableArray alloc]init];
        for (int i=0; i<allGuessArray.count; i++) {
            [yarr addObject:@"R"];
        }
        resultArray=[[Utils sharedInstance]xiasanluJudgeGuessRightandWrong:listArray allGuessArray:yarr];
        _memoLab.text =[[Utils sharedInstance] changeChina:[yarr lastObject] isWu:NO];
        
    }
    else if ([[[NSUserDefaults standardUserDefaults] objectForKey:SAVE_isOnlyRBSelect] intValue]==2) {
        NSMutableArray*yarr=[[NSMutableArray alloc]init];
        for (int i=0; i<allGuessArray.count; i++) {
            [yarr addObject:@"B"];
        }
        resultArray=[[Utils sharedInstance]xiasanluJudgeGuessRightandWrong:listArray allGuessArray:yarr];
        _memoLab.text =[[Utils sharedInstance] changeChina:[yarr lastObject] isWu:NO];
        
    }
    //yxy add 2017/07/17
    else
    {
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:SAVE_isbigRoad] intValue]==1)
        {
            NSMutableArray*tepguessSecondPartArray=[[NSMutableArray alloc]initWithArray:guessSecondPartArray];
            if ([tenM.tRule isEqualToString:@"YES"])
            {
                for (int i=0; i<tepguessSecondPartArray.count; i++) {
                    if ([tepguessSecondPartArray[i] isEqualToString:@"stop"])
                    {
                        [tepguessSecondPartArray replaceObjectAtIndex:i withObject:@""];
                    }
                }
                
            }
            resultArray=[[Utils sharedInstance] judgeGuessRightandWrong:listArray allGuessArray:tepguessSecondPartArray];
            _memoLab.text =[[Utils sharedInstance] changeChina:[guessSecondPartArray lastObject] isWu:NO];
        }
        else
        {
            resultArray=[[Utils sharedInstance]xiasanluJudgeGuessRightandWrong:listArray allGuessArray:allGuessArray];
            _memoLab.text =[[Utils sharedInstance] changeChina:[allGuessArray lastObject] isWu:NO];
        }
    }
    
    
    
    
    NSString*money=resultArray[5];
    if ([tenM.tRule isEqualToString:@"YES"]) {
        if([[listArray lastObject] isEqualToString:@"T"]&&[[guessSecondPartArray lastObject] length]>0){
            _memoLab.text =@"暂停";
            str1=@"暂停";
            money=@"";
        }

    }
    _areaTrendLab2.text=[NSString stringWithFormat:@"大路:%@          大眼仔路:%@%@",str1,nameStr2,str2];
    _areaTrendLab3.text=[NSString stringWithFormat:@"文字:%@%@          小路:%@%@",array0[0],str0,nameStr3,str3];
    _areaTrendLab1.text=[NSString stringWithFormat:@"                      小强路:%@%@",nameStr4,str4];
    
    
    _totalWinLab.text=[NSString stringWithFormat:@"总收益:%@",resultArray[2]];
    //    NSLog(@"++++++%@",[resultArray lastObject]);
    _winOrLoseLab.text=[NSString stringWithFormat:@"输:%@    赢:%@",resultArray[0],resultArray[1]];
    if (_memoLab.text.length>0)
    {
        NSString*goStr=resultArray[8];
        if ([goStr intValue]<=0) {
            goStr=@"";
        }
        else{
            goStr=[NSString stringWithFormat:@"连赢:%@",resultArray[8]];
        }
        
        _memoLab.text=[NSString stringWithFormat:@"%@  %@  %@",money,_memoLab.text,goStr];
    }
    
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
    [showSecondPartArray removeAllObjects];
    [thirdPartArray removeAllObjects];
    [forthPartArray removeAllObjects];
    [fivePartArray removeAllObjects];
    
    [guessFirstPartArray removeAllObjects];
    [guessSecondPartArray removeAllObjects];
    [guessThirdPartArray removeAllObjects];
    [guessForthPartArray removeAllObjects];
    [guessFivePartArray removeAllObjects];
    
    [arrGuessSecondPartArray removeAllObjects];
    [allGuessArray removeAllObjects];
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
    
    
    _areaTrendLab2.text=[NSString stringWithFormat:@"大路:无          大眼仔路:无"];
    _areaTrendLab3.text=[NSString stringWithFormat:@"文字:无          小路:无"];
    _areaTrendLab1.text=[NSString stringWithFormat:@"                      小强路:无"];
    _memoLab.text=[[Utils sharedInstance] changeChina:@"" isWu:NO];
    _totalWinLab.text=@"总收益:0.00";
    _winOrLoseLab.text=@"输:0    赢:0";
    
    
    
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

#pragma mark--一三四五区域的选择
-(void)getNotification:(NSNotification*)userInfo
{
    tenM=[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:SAVE_TenBlodRule]];
    [Utils sharedInstance].tenModel=tenM;

    NSDictionary*dic=userInfo.userInfo;
   
    if ([dic[@"title"] isEqualToString:SAVE_isOnlyRBSelect])// SAVE_isOnlyRBSelect、SAVE_isbigRoad
    {
        [self setMoneyValue:NO];
    }
    else if([dic[@"title"] isEqualToString:xiasanroad_notifation])//SAVE_oneNORule、SAVE_GoXiaoCount
    {
        [self guessArrayinitAdd];
    }
    if ([dic[@"title"] isEqualToString:word_notifation])//SAVE_wordRule、SAVE_REVERSESELECT
    {
        [self changeArea:0];
    }
    
    
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//    if ([segue.identifier isEqualToString:@"showResultVC"])
//    {
//        UIViewController*vc=[segue destinationViewController];
//        [vc setValuesForKeysWithDictionary:(NSDictionary*)sender];
//    }
//}

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
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else
    {
        [self.view makeToast:@"秘钥错误" duration:0.5f position:CSToastPositionCenter];
    }
}
//数据显示
//- (IBAction)dataShowBtnAction:(id)sender {
//    if (listArray.count>0)
//    {
//        NSArray*array=[[Utils sharedInstance] getNewFristArray:listArray];
//        TBNewRule_TimeViewController*vc=[[UIStoryboard storyboardWithName:@"newResultData" bundle:nil] instantiateViewControllerWithIdentifier:@"TBNewRule_TimeViewController"];
//        vc.selectedTitle=@"结果显示";
//        vc.dataArray=array;
//        [self.navigationController pushViewController:vc animated:YES];
//        
//    }
//    else
//    {
//        [self.view makeToast:@"请先录入数据" duration:3 position:CSToastPositionCenter];
//    }
//}


@end
