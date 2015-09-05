//
//  JMPicCell.m
//  JMChooseMultiplePicsDemo
//
//  Created by JiangMing on 15/8/26.
//  Copyright (c) 2015年 JiangMing. All rights reserved.
//

#import "JMPicCell.h"
#import "UIView+JMExtended.h"
@interface JMPicCell ()

{  NSIndexPath *_indexPath; }

/**
 *  用于显示单个图片的imageView
 */
@property (nonatomic , strong) UIImageView *imageView;


@end

@implementation JMPicCell

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initCell];
    }
    return self;
}

-(void)initCell
{
    //imageView
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.imageView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.imageView];
    
    //selectIconImageView
    self.selectIconButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.selectIconButton.backgroundColor = [UIColor clearColor];
    self.selectIconButton.frame = CGRectMake(self.height * 0.5, 0, self.width * 0.5, self.height * 0.5);
    [self.selectIconButton setImageEdgeInsets:UIEdgeInsetsMake(0, self.height * 0.1, self.height * 0.1, 0)];
    [self.selectIconButton addTarget:self action:@selector(selectIconButtonIsTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.selectIconButton];
}

/**
 *  对外方法，获取图片信息
 *
 *  @param asset 图片信息
 *  @param isSelect 是否为选中状态
 */
-(void)setCollectionViewCellWithAsset:(ALAsset *)asset isSelect:(BOOL)isSelect indexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
    self.imageView.image = [UIImage imageWithCGImage:asset.thumbnail];
    if (isSelect == YES)
    {
        [self.selectIconButton setImage:[UIImage imageNamed:@"selectImage"] forState:UIControlStateNormal];
        [self.selectIconButton setImage:[UIImage imageNamed:@"selectImage"] forState:UIControlStateHighlighted];
    }
    else
    {
        [self.selectIconButton setImage:[UIImage imageNamed:@"unselectImage"] forState:UIControlStateNormal];
        [self.selectIconButton setImage:[UIImage imageNamed:@"unselectImage"] forState:UIControlStateHighlighted];
    }
}

/**
 *  选中按钮的点击事件
 *
 *  @param paramSender 选中按钮
 */
-(void)selectIconButtonIsTouchUpInside:(UIButton *)paramSender
{
    if ([self.delegate respondsToSelector:@selector(selectIconButtonIsTouch:)])
    {
        [self.delegate selectIconButtonIsTouch:_indexPath];
    }
}





@end
