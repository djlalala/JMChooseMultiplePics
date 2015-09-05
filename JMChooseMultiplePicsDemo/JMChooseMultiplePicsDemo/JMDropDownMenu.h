//
//  JMDropDownMenu.h
//  JMSinaWeiBo
//
//  Created by JiangMing on 15/3/29.
//  Copyright (c) 2015年 JiangMing. All rights reserved.
//


#import <UIKit/UIKit.h>


@class JMDropdownMenu;

@protocol JMDropdownMenuDelegate <NSObject>
@optional
- (void)dropdownMenuDidDismiss:(JMDropdownMenu *)menu;
- (void)dropdownMenuDidShow:(JMDropdownMenu *)menu;
@end

@interface JMDropdownMenu : UIView
@property (nonatomic, weak) id<JMDropdownMenuDelegate> delegate;

+ (instancetype)menu;

/**
 *  显示
 */
- (void)showFrom:(UIView *)from;
/**
 *  销毁
 */
- (void)dismiss;

/**
 *  内容
 */
@property (nonatomic, strong) UIView *content;
/**
 *  内容控制器
 */
@property (nonatomic, strong) UIViewController *contentController;
@end
