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
    self.imageView.contentMode=UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds=YES;
    [self.contentView addSubview:self.imageView];
    
    //selectIconImageView
    self.selectIconButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.selectIconButton.backgroundColor = [UIColor clearColor];
    self.selectIconButton.frame = CGRectMake(self.height * 0.65, 0, self.width * 0.35, self.height * 0.35);
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
-(void)setCollectionViewCellWithAsset:(ALAsset *)asset isSelect:(BOOL)isSelect indexPath:(NSIndexPath *)indexPath assets:(NSArray *)assets
{
    _indexPath = indexPath;
    self.imageView.image = [UIImage imageWithCGImage:asset.aspectRatioThumbnail];
    if (isSelect == YES)
        
    {
        __block NSUInteger m=0;
        [assets enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ALAsset *newAsset=(ALAsset *)obj;
        if (newAsset==asset) {
            m=idx;
            *stop=YES;
            }
             }];
        
        UIImage *img=[self image:@"sel" WithCount:[NSString stringWithFormat:@"%lu",(unsigned long)(m+1)]];
        [self.selectIconButton setImage:img forState:UIControlStateNormal];
        [self.selectIconButton setImage:img forState:UIControlStateHighlighted];
        

    }
    else
    {
        [self.selectIconButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [self.selectIconButton setImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
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

/**
 *  绘制图片
 *
 *  @param img   背景图
 *  @param count 选中的张数
 *
 *  @return
 */

- (UIImage *)image:(NSString *)img WithCount:(NSString * )count{
    
    UIImage *bigImg = [UIImage imageNamed:img];
    UIGraphicsBeginImageContextWithOptions(bigImg.size, NO, 0.0);
    [bigImg drawInRect:CGRectMake(0, 0, bigImg.size.width, bigImg.size.height)];
    
    
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    
    attrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:25];
    attrs[NSParagraphStyleAttributeName]=paragraph;
    
    [count drawInRect:CGRectMake(6, 6, 31, 31) withAttributes:attrs];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
    
}



@end
