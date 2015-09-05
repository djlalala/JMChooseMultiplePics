//
//  JMToolBar.m
//  JMChooseMultiplePicsDemo
//
//  Created by JiangMing on 15/8/26.
//  Copyright (c) 2015年 JiangMing. All rights reserved.
//

#import "JMToolBar.h"
#define Screen_Height   ([UIScreen mainScreen].bounds.size.height)
#define Screen_Width    ([UIScreen mainScreen].bounds.size.width)
@interface JMToolBar()
@property(weak,nonatomic)UIButton *cammerBtn;
@property(weak,nonatomic)UIButton *finishBtn;


@end

@implementation JMToolBar

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initJMToolbar];
    }
    return self;
}



- (void)initJMToolbar{
    
    
    UIButton *finishBtn=[[UIButton alloc]init];
    [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
    finishBtn.titleLabel.font=[UIFont systemFontOfSize:18];
    [finishBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    finishBtn.frame=CGRectMake(Screen_Width/2, 0, Screen_Width/2, 64);
    [finishBtn addTarget:self action:@selector(finishBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    finishBtn.enabled=NO;
    finishBtn.alpha = 0.3;
    [self addSubview:finishBtn];
    self.finishBtn=finishBtn;
    
    
    
    UIButton *camBtn=[[UIButton alloc]init];
    [camBtn setImage:[UIImage imageNamed:@"btn_cammer"] forState:UIControlStateNormal];
    camBtn.frame=CGRectMake(0, 0, Screen_Width/2, 64);
    camBtn.contentEdgeInsets=UIEdgeInsetsMake(21, (Screen_Width/2-30)/2, 21, (Screen_Width/2-30)/2);
    [camBtn addTarget:self action:@selector(camBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:camBtn];
    self.cammerBtn=camBtn;
    
}



- (void)finishBtnClick:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(toolbar:finishButtonIsTouch:)]) {
        [self.delegate toolbar:self finishButtonIsTouch:btn];
    }
}



- (void)camBtnClick:(UIButton *)btn{
    
    if ([self.delegate respondsToSelector:@selector(toolbar:cameraButtonIsTouch:)]) {
        [self.delegate toolbar:self cameraButtonIsTouch:btn];
    }
}



-(void)setButtonCanTouch:(BOOL)buttonCanTouch
{
    if (buttonCanTouch == YES)
    {
        
        [self.finishBtn setEnabled:YES];
        self.finishBtn.alpha=1;
        
    }
    else
    {
        [self.finishBtn setEnabled:NO];
        self.finishBtn.alpha=0.3;
        
    }
}




@end







