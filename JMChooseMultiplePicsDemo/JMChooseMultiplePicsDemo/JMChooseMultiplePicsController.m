//
//  JMChooseMultiplePicsController.m
//  JMChooseMultiplePicsDemo
//
//  Created by JiangMing on 15/8/25.
//  Copyright (c) 2015年 JiangMing. All rights reserved.
//

#import "JMChooseMultiplePicsController.h"
#import "JMAssetLibraryController.h"
#import "UIView+JMExtended.h"
#import "JMTitleButton.h"
#import "JMDropDownMenu.h"
#import "JMPicCell.h"
#import "JMToolBar.h"
#define Screen_Height   ([UIScreen mainScreen].bounds.size.height)
#define Screen_Width    ([UIScreen mainScreen].bounds.size.width)
@class JMDropdownMenu,JMToolBar;

@interface JMChooseMultiplePicsController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,JMAssetGroupCellselectDelegate,JMDropdownMenuDelegate,JMToolBarDelegate,JMCollectionViewCellDelegate>

/** collectionView   */
@property(weak,nonatomic)UICollectionView *collectionView;

/** 相册资源库 */

@property (strong,nonatomic) ALAssetsLibrary *assetsLibrary;

/** 从相册资源库获取后存放ALAssetsGroup */

@property (strong,nonatomic) NSMutableArray *assetsGroups;

/** 某个相册 */
@property (strong,nonatomic) ALAssetsGroup *assetsGroup;

/** 存放某个相册内图片资源数组 */
@property(strong,nonatomic)NSMutableArray *assets;

/** 某个相册图片数量 */
@property(assign,nonatomic)NSInteger _numberOfPics;

/** 已选图片 */
@property(strong,nonatomic)NSMutableArray *selectPics;

/** 可选最大数量图片 */

@property(assign,nonatomic)int maxSelectPic;

/** 自定义的下拉栏 */

@property(strong,nonatomic)JMDropdownMenu *menu;

/** 自定义的底栏 */

@property(strong,nonatomic)JMToolBar *toolBar;

/**rightBarButtonItem */
@property(weak,nonatomic)UILabel *picLabel;

@end

@implementation JMChooseMultiplePicsController


#pragma mark -懒加载
- (ALAssetsGroup *)assetsGroup
{
    if (!_assetsGroup) {
        self.assetsGroup = [[ALAssetsGroup alloc]init];
    }
    return _assetsGroup;
}

- (ALAssetsLibrary *)assetsLibrary
{
    if (!_assetsLibrary) {
        self.assetsLibrary = [self.class defaultAssetsLibrary];
    }
    return _assetsLibrary;
}

- (NSMutableArray *)assetsGroups
{
    if (!_assetsGroups) {
        self.assetsGroups = [NSMutableArray array];
    }
    return _assetsGroups;
}

- (NSMutableArray *)assets
{
    if (!_assets) {
        self.assets = [NSMutableArray array];
    }
    return _assets;
}

- (NSMutableArray *)selectPics
{
    if (!_selectPics) {
        self.selectPics = [NSMutableArray array];
    }
    return _selectPics;
}

#pragma mark - ALAssetsLibrary单例

+ (ALAssetsLibrary *)defaultAssetsLibrary
{
    static dispatch_once_t once = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&once, ^{
        library = [[ALAssetsLibrary alloc] init];
    });
    return library;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //获取相册列表
    [self getAssetsGroups];
    //初始化界面
    [self setUpView];
    
}


#pragma mark - 获取相册列表
-(void)getAssetsGroups
{
    if (self.assetsGroups.count) {
      [self.assetsGroups removeAllObjects];
    }

    ALAssetsLibraryGroupsEnumerationResultsBlock resultsBlock = ^(ALAssetsGroup *assetsGroup, BOOL *stop)
    {
        if (assetsGroup)
        {
            [assetsGroup setAssetsFilter:[ALAssetsFilter allAssets]];
             //筛选图片数不为0的相册
            if (assetsGroup.numberOfAssets > 0)
            {
                [self.assetsGroups addObject:assetsGroup];
            }
        }
            //结束遍历做的事
        else
        {
            self.assetsGroup=self.assetsGroups[0];
            [self getImages];
         }
        
    };
    
    ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error) {
                NSLog(@"错误信息提示");
    };
      [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
                                      usingBlock:resultsBlock
                                    failureBlock:failureBlock];
    NSUInteger type =
    ALAssetsGroupLibrary | ALAssetsGroupAlbum | ALAssetsGroupEvent |
    ALAssetsGroupFaces | ALAssetsGroupPhotoStream;
    
    [self.assetsLibrary enumerateGroupsWithTypes:type
                                      usingBlock:resultsBlock
                                    failureBlock:failureBlock];
}


-(void)setUpView{
    self.view.backgroundColor=[UIColor whiteColor];
    //设置最大可选数量
    self.maxSelectPic = 6;
    
    JMTitleButton *titleButton = [[JMTitleButton alloc] init];
    [titleButton setTitle:@"相册选择" forState:UIControlStateNormal];
    [titleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [titleButton addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = titleButton;
  
    UILabel *picLabel=[[UILabel alloc]init];
    self.picLabel=picLabel;
    picLabel.text=@"未选";
    picLabel.textAlignment=NSTextAlignmentRight;
    picLabel.font=[UIFont systemFontOfSize:15];
    picLabel.textColor=[UIColor blackColor];
    picLabel.frame=CGRectMake(0, 0, 100, 30);
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:picLabel];
     if ([[UIDevice currentDevice] systemVersion].floatValue>=7.0)
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 128) collectionViewLayout:[UICollectionViewFlowLayout new]];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.showsVerticalScrollIndicator = YES;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView registerClass:[JMPicCell class] forCellWithReuseIdentifier:@"JMPicCell"];
    [self.view addSubview:collectionView];
    self.collectionView=collectionView;
    
    JMToolBar *toolBar=[[JMToolBar alloc]initWithFrame:CGRectMake(0, Screen_Height-64, Screen_Width, 64)];
     toolBar.delegate=self;
    [self.view addSubview:toolBar];
    self.toolBar=toolBar;
    
    
}

-(void)getImages

{
    if(self.assets.count){
        [self.assets removeAllObjects];
    }
        //获取assetsGroup里的图片
       ALAssetsGroupEnumerationResultsBlock resultsBlock = ^(ALAsset *asset, NSUInteger index, BOOL *stop) {
        if (asset)
        {
//            //图片按照拍摄时间从早到晚排列，对应下面collectionView自动滚动到底部
//            [self.assets addObject:asset];
            //图片按照从拍摄时间从晚到早排列
            [self.assets insertObject:asset atIndex:0];
            NSString *type = [asset valueForProperty:ALAssetPropertyType];
            
            if ([type isEqual:ALAssetTypePhoto])
                __numberOfPics++;
            if ([type isEqual:ALAssetTypeVideo]){
           
            }
        }
        //结束遍历做的事
        else if (_assets.count > 0)
        {
            [_collectionView reloadData];
//            //滚到底部
//            NSIndexPath *tpIndexPath = [NSIndexPath indexPathForRow:(_assets.count - 1) inSection:0];
//            [_collectionView scrollToItemAtIndexPath:tpIndexPath atScrollPosition:UICollectionViewScrollPositionBottom animated:YES];
        }
    };
    [self.assetsGroup enumerateAssetsUsingBlock:resultsBlock];
    
}
    
    
 #pragma mark - collectionView data source
    
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _assets.count;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identifier = @"JMPicCell";
    
    JMPicCell *cell = (JMPicCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.delegate=self;
    //判断图片是否已选
    ALAsset *tpAsset = [_assets objectAtIndex:indexPath.row];
    BOOL isSelect = [self.selectPics containsObject:tpAsset];
    //设置cell内容
    [cell setCollectionViewCellWithAsset:[self.assets objectAtIndex:indexPath.row] isSelect:isSelect indexPath:indexPath];
    return cell;
}


#pragma mark - collectionView delegate

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    //一排几列
    int a = 3;
    CGFloat imageWidth = (width - (a + 1)*3.0)/a;
    return CGSizeMake(imageWidth, imageWidth);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(3, 3, 3, 3);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 3;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"select");
}


#pragma mark - JMCollectionViewCellDelegate
-(void)selectIconButtonIsTouch:(NSIndexPath *)indexPath
{
    BOOL needChangeState;
    
    //判断是添加还是取消 -- 获取当前的ALAsset对象，
    ALAsset *tpAsset = [_assets objectAtIndex:indexPath.item];
    BOOL containsObject = [self.selectPics containsObject:tpAsset];
    if (containsObject == YES)
    {
        //已经存在，则需要进行一个更改
        [self.selectPics removeObject:tpAsset];
        needChangeState = YES;
    }
    else
    {
        if (self.selectPics.count < self.maxSelectPic)
        {
            [self.selectPics addObject:tpAsset];
            needChangeState = YES;
        }
        else
        {
            needChangeState = NO;
            UIAlertView *myAlertView = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"你最多只能选择%d张照片",self.maxSelectPic] delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
            [myAlertView show];
        }
    }
    
    if (needChangeState == YES)
    {
        //需要对单个的collectionViewCell进行更新
        NSArray *indePathArray = [NSArray arrayWithObjects:indexPath, nil];
        [self.collectionView reloadItemsAtIndexPaths:indePathArray];

        //更改toolbar的状态
        if (self.selectPics.count >0)
            
        {
            self.toolBar.buttonCanTouch = YES;
            self.picLabel.text = [NSString stringWithFormat:@"已选%d张照片",(int)self.selectPics.count];
            
        }
        else
        {
            self.picLabel.text = @" 未选";
            self.toolBar.buttonCanTouch = NO;
        }
    }
}







#pragma mark － JMAssetGroupCellselectDelegate
- (void)assetGroupCellselect:(ALAssetsGroup *)assetsGroup{
    [self.menu dismiss];
    self.assetsGroup=assetsGroup;
    [self.selectPics removeAllObjects];
    [self getImages];
    self.picLabel.text=@"未选";
    self.toolBar.buttonCanTouch=NO;
    
    
}

#pragma mark － 点击导航栏titleView
- (void)titleClick:(UIButton *)titleButton
{

    JMDropdownMenu *menu = [JMDropdownMenu menu];
    menu.delegate = self;
    
    JMAssetLibraryController *vc=[[JMAssetLibraryController alloc]init];
     vc.delegate=self;
    vc.view.width = self.view.width;
    if (self.assetsGroups.count<6&&self.assetsGroups.count>0) {
        vc.view.height = self.assetsGroups.count*60;
    }else {
        vc.view.height = 300;
        
    }
    vc.assetsGroups=self.assetsGroups;
    menu.contentController = vc;

    [menu showFrom:titleButton];
    self.menu=menu;
    
    
    
}

#pragma mark － JMDropdownMenuDelegate
- (void)dropdownMenuDidDismiss:(JMDropdownMenu *)menu
{
    UIButton *titleButton = (UIButton *)self.navigationItem.titleView;
    titleButton.selected = NO;
}

- (void)dropdownMenuDidShow:(JMDropdownMenu *)menu
{
    UIButton *titleButton = (UIButton *)self.navigationItem.titleView;
    titleButton.selected = YES;
}



#pragma - 点击相机按钮

- (void)toolbar:(JMToolBar *)toolbar cameraButtonIsTouch:(UIButton *)btn{
    
    NSLog(@"拍照");
    
}


#pragma  - 点击完成按钮

- (void)toolbar:(JMToolBar *)toolbar finishButtonIsTouch:(UIButton *)btn{
    
    NSLog(@"sdcs");
   
    //保存已选图片
    NSMutableArray *tpImageArray = [NSMutableArray array];
    for (int i = 0; i<self.selectPics.count; i++)
    {
        ALAsset *tpAsset = [self.selectPics objectAtIndex:i];
        UIImage *tpImage = [UIImage imageWithCGImage:tpAsset.defaultRepresentation.fullScreenImage];
        [tpImageArray addObject:tpImage];
    }
     
}








@end
