//
//  JMAssetLibraryController.h
//  JMChooseMultiplePicsDemo
//
//  Created by JiangMing on 15/8/25.
//  Copyright (c) 2015年 JiangMing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>




@protocol JMAssetGroupCellselectDelegate <NSObject>

/** 
 选中相册时调用的代理方法 */
- (void)assetGroupCellselect:(ALAssetsGroup *)assetsGroup;

@end

@interface JMAssetLibraryController : UITableViewController

@property(weak,nonatomic)id <JMAssetGroupCellselectDelegate>delegate;

/**  assets 存放相册的数组  */
@property(strong,nonatomic)NSMutableArray *assetsGroups;

@end
