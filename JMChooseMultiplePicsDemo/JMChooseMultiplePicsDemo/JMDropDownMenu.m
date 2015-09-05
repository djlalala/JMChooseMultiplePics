//
//  JMDropDownMenu.m
//  JMSinaWeiBo
//
//  Created by JiangMing on 15/3/29.
//  Copyright (c) 2015年 JiangMing. All rights reserved.
//

#import "JMDropDownMenu.h"
#import "UIView+JMExtended.h"

@interface JMDropdownMenu()
/**
 *  将来用来显示具体内容的容器
 */
@property (nonatomic, weak) UIImageView *containerView;
@end

@implementation JMDropdownMenu

- (UIImageView *)containerView
{
    if (!_containerView) {
        // 添加一个灰色图片控件
        UIImageView *containerView = [[UIImageView alloc] init];
        containerView.image = [UIImage imageNamed:@"popover_background"];
        containerView.userInteractionEnabled = YES;
        [self addSubview:containerView];
        self.containerView = containerView;
    }
    return _containerView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


+ (instancetype)menu
{
    return [[self alloc] init];
}

- (void)setContent:(UIView *)content
{
    _content = content;
    
    content.x = 10;
    content.y = 15;
    
    self.containerView.height = CGRectGetMaxY(content.frame) +11;
    
    self.containerView.width = CGRectGetMaxX(content.frame) + 10;

    [self.containerView addSubview:content];
}

- (void)setContentController:(UIViewController *)contentController
{
    _contentController = contentController;
    
    self.content = contentController.view;
}

/**
 *  显示
 */
- (void)showFrom:(UIView *)from
{
   
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    [window addSubview:self];
    self.frame = window.bounds;
   
    CGRect newFrame = [from convertRect:from.bounds toView:window];
    //    CGRect newFrame = [from.superview convertRect:from.frame toView:window];
    self.containerView.centerX = CGRectGetMidX(newFrame);
    self.containerView.y = CGRectGetMaxY(newFrame);
    
    // 通知外界，自己显示了
    if ([self.delegate respondsToSelector:@selector(dropdownMenuDidShow:)]) {
        [self.delegate dropdownMenuDidShow:self];
    }
}

/**
 *  销毁
 */
- (void)dismiss
{
    [self removeFromSuperview];
    
    // 通知外界，自己被销毁了
    if ([self.delegate respondsToSelector:@selector(dropdownMenuDidDismiss:)]) {
        [self.delegate dropdownMenuDidDismiss:self];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self dismiss];
}
@end
