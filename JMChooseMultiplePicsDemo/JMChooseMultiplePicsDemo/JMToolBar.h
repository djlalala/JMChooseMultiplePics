//
//  JMToolBar.h
//  JMChooseMultiplePicsDemo
//
//  Created by JiangMing on 15/8/26.
//  Copyright (c) 2015年 JiangMing. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JMToolBar;

@protocol  JMToolBarDelegate <NSObject>

/**
 *  照相按钮被点击
 */
-(void)toolbar:(JMToolBar *)toolbar cameraButtonIsTouch:(UIButton *)btn;

/**
 *  完成按钮被点击
 */
-(void)toolbar:(JMToolBar *)toolbar finishButtonIsTouch:(UIButton *)btn;

@end

@interface JMToolBar : UIView

@property (nonatomic , weak) id<JMToolBarDelegate>delegate;

/**
 *  按钮可点击
 */
@property (nonatomic , assign) BOOL buttonCanTouch;


@end
