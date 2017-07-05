//
//  chartView.m
//  ExcelViewDemol
//
//  Created by jiazhen-mac-01 on 17/1/4.
//  Copyright © 2017年 chedaye. All rights reserved.
//

#import "chartImageView.h"
@interface chartImageView()
{
    UIScrollView*mainScrollview;
    UIImageView*mainImageView;
    float imageWidth;
    
}
@end
@implementation chartImageView
-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor=[UIColor whiteColor];
        [self initScrollview];
    }
    return self;
}
-(void)initScrollview
{
    mainScrollview=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    mainScrollview.contentSize=CGSizeMake(self.frame.size.width*2, self.frame.size.height);
    [mainScrollview setShowsHorizontalScrollIndicator:NO];
    imageWidth=self.frame.size.height/6.00;
    [self addSubview:mainScrollview];
}
-(void)setMyType:(NSInteger)myType
{
    _myType=myType;
    mainImageView=[[UIImageView alloc]initWithImage:[self scaleImage]];
    [mainScrollview addSubview:mainImageView];
}
-(UIImage*)scaleImage
{
    CGSize size=mainScrollview.contentSize;
    UIGraphicsBeginImageContext(size);
    /////画线
    CGContextRef context=UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);//画笔线的颜色
    CGContextSetLineWidth(context, 0.5f);//线的宽度
    //横线
    int add=_myType>2?2:1;
   
    
        for (int i=add; i<6+add; i=i+add)
        {
            CGPoint apoint[2];
            apoint[0]=CGPointMake(0, imageWidth*i);
            apoint[1]=CGPointMake(size.width, imageWidth*i);
            CGContextAddLines(context, apoint, 2);
            CGContextDrawPath(context, kCGPathStroke);
        }
        //竖线
        for (int i=add; i<100+add; i=i+add)
        {
            CGPoint apoint[2];
            apoint[0]=CGPointMake(imageWidth*(i), 0);
            apoint[1]=CGPointMake(imageWidth*(i), size.height);
            CGContextAddLines(context, apoint, 2);
            CGContextDrawPath(context, kCGPathStroke);
        }

   
    if (_myType==2)
    {
        for (int i=0; i<_itemArray.count; i++)
        {
            NSInteger row=i%6;
            NSInteger col=i/6;
            NSString*str=@"";
            if ([_itemArray[i] isEqualToString:@"R"])
            {
                str=@"blank";
            }
            else if ([_itemArray[i] isEqualToString:@"B"])
            {
                str=@"spare";
            }
            else if ([_itemArray[i] isEqualToString:@"T"])
            {
                str=@"sum";
            }
            
            UIImage*image=[UIImage imageNamed:str];
            [image drawInRect:CGRectMake(imageWidth*col+1, imageWidth*row+1, imageWidth-2, imageWidth-2)];
        }

    }
    else
    {
        for (int i=0; i<_itemArray.count; i++)
        {
             NSMutableArray*array=[[NSMutableArray alloc]initWithArray:_itemArray[i]];
             for (int j=0; j<array.count; j++)
            {
                NSString*str=array[j];
                if ([str containsString:@"B"])
                {
                    switch (_myType)
                    {
                        case 1:
                            
                             str=[NSString stringWithFormat:@"blueRound0%@",[str substringFromIndex:1]];
                            if ([str containsString:@"_"])
                            {
                                NSArray*arrT=[str componentsSeparatedByString:@"_"];
                                if ([arrT[1] intValue]>5)
                                {
                                    str=[NSString stringWithFormat:@"%@_5_%@",arrT[0],arrT[2]];
                                }
                            }
                            break;
                        case 3:
                        case 4:
                        case 5:
                            str=[NSString stringWithFormat:@"blueRound%ld%@",_myType-3,[str substringFromIndex:1]];
                            break;
                            
                        default:
                            break;
                    }
                   
                }
                else if ([str containsString:@"R"])
                {
                    switch (_myType)
                    {
                        case 1:
                             str=[NSString stringWithFormat:@"redRound0%@",[str substringFromIndex:1]];
                            if ([str containsString:@"_"])
                            {
                                NSArray*arrT=[str componentsSeparatedByString:@"_"];
                                if ([arrT[1] intValue]>5)
                                {
                                    str=[NSString stringWithFormat:@"%@_5_%@",arrT[0],arrT[2]];
                                }
                            }

                            break;
                        case 3:
                        case 4:
                        case 5:
                             str=[NSString stringWithFormat:@"redRound%ld%@",_myType-3,[str substringFromIndex:1]];
                            break;
                            
                        default:
                            break;
                    }

                   
                }
                if (str.length>0)
                {
                    UIImage*image=[UIImage imageNamed:str];
                    [image drawInRect:CGRectMake(imageWidth*i+1, imageWidth*j+1, imageWidth-2, imageWidth-2)];
                }
            }
        }
    }
   UIImage*scaleImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndPDFContext();
    return scaleImage;
    
}
-(void)setItemArray:(NSArray *)itemArray
{
    _itemArray=itemArray;
    mainImageView.image=[self scaleImage];
    
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
