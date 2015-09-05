//
//  JMPicCell.h
//  JMChooseMultiplePicsDemo
//
//  Created by JiangMing on 15/8/26.
//  Copyright (c) 2015年 JiangMing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>


@protocol JMCollectionViewCellDelegate <NSObject>

@required

/**
 *  选中按钮的代理
 *
 *  @param indexPath 当前cell的indexPath
 */
-(void)selectIconButtonIsTouch:(NSIndexPath *)indexPath;

@end


@interface JMPicCell : UICollectionViewCell
/**
 *  图片选中标记
 */
@property (nonatomic , strong) UIButton *selectIconButton;

@property (nonatomic , weak) id<JMCollectionViewCellDelegate>delegate;

/**
 * 设置cell
 *
 *  @param asset 图片信息
 *  @param isSelect 是否为选中状态
 *  @param indexPath cell的indexPath
 */

-(void)setCollectionViewCellWithAsset:(ALAsset *)asset isSelect:(BOOL)isSelect indexPath:(NSIndexPath *)indexPath;


@end
