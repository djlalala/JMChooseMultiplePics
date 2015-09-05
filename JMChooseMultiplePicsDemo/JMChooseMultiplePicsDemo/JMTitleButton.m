//
//  JMTitleButton.m
//  JMSinaWeiBo
//
//  Created by JiangMing on 15/3/31.
//  Copyright (c) 2015年 JiangMing. All rights reserved.
//

#import "JMTitleButton.h"
#import "UIView+JMExtended.h"

#define JMMargin 5

@implementation JMTitleButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        [self setImage:[UIImage imageNamed:@"navigationbar_arrow_down"] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"navigationbar_arrow_up"] forState:UIControlStateSelected];
    }
    return self;
}

#pragma mark - 重写setFrame:方法的目的：拦截设置按钮尺寸的过程
- (void)setFrame:(CGRect)frame
{
    frame.size.width += JMMargin;
    [super setFrame:frame];
    
}


- (void)layoutSubviews
{
    [super layoutSubviews];
   
    self.titleLabel.x = self.imageView.x;
    
    self.imageView.x = CGRectGetMaxX(self.titleLabel.frame) + JMMargin;
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
    
    [self sizeToFit];
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state
{
    [super setImage:image forState:state];
    
    [self sizeToFit];
}


@end
