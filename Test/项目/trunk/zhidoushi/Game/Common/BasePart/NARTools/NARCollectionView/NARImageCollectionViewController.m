//
//  NARImageCollectionViewController.m
//  zhidoushi
//
//  Created by xinglei on 14/12/1.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import "NARImageCollectionViewController.h"

#import "NARImageCollectionViewCell.h"
#import "GameDetail_ViewController.h"
#import "Define.h"
#import "UIViewExt.h"
//..priviate..//
#import "WWTolls.h"
//..netWork..//
#import "JSONKit.h"
#import "XLConnectionStore.h"
#import "WWRequestOperationEngine.h"
//..gateGory..//
#import "UIView+ViewController.h"
#import "NSString+NARSafeString.h"

@interface NARImageCollectionViewController ()
{
    NSArray * hotGameListArray;//存储热门游戏信息数组
    NARImageCollectionViewCell *imageCell;
}
@end

@implementation NARImageCollectionViewController

static NSString * const reuseIdentifier = @"ImageCell";

-(instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout{
    
    if (self = [super initWithCollectionViewLayout:layout]) {
        [self loadWillBeginGameData];

     [self.collectionView registerClass:[NARImageCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
        self.collectionView.backgroundColor = [WWTolls colorWithHexString:@"fafafa"];

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    hotGameListArray = [NSKeyedUnarchiver unarchiveObjectWithFile:GAME_HOTGAME_CACHE_PATH];
    if (hotGameListArray.count>0) {
        [self.collectionView reloadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return hotGameListArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    imageCell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    imageCell.imageView.frame = CGRectMake(0, 0, ZDS_FISTPAGE_BEGINMODLE_WIDTH, ZDS_FISTPAGE_BEGINMODLE_WIDTH);
    imageCell.bottomView.frame = CGRectMake(0, imageCell.imageView.bottom, ZDS_FISTPAGE_BEGINMODLE_WIDTH, ZDS_FISTPAGE_BEGINMODLE_LABEL_WIDTH);
    if (hotGameListArray.count>0) {
        imageCell.hotModel = [hotGameListArray objectAtIndex:indexPath.item];
    }
    return imageCell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //select Item
    NSLog(@"item= %li,section = %li,row = %li",(long)indexPath.item,(long)indexPath.section,(long)indexPath.row);
    //跳转到游戏详情页
    hotGameModel *hotModel = [[hotGameModel alloc]init];
    hotModel = [hotGameListArray objectAtIndex:indexPath.item];
    if (hotModel.gameid.length!=0 && [hotModel.gameid isKindOfClass:[NSString class]]) {
        GameDetail_ViewController *gameDetail = [[GameDetail_ViewController alloc]initWithNibName:@"GameDetail_ViewController" bundle:nil];
        NSLog(@"*************%@",hotModel.gameid);
        gameDetail.imageUrlString = hotModel.imageurl;
        gameDetail.gameid = hotModel.gameid;
        gameDetail.gameName = hotModel.gamename;
        [self.view.viewController.navigationController pushViewController:gameDetail animated:YES];
    }
 }

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat aFloat = 0;
    UIImage* image = self.imagesArr[indexPath.item];
    aFloat = self.imagewidth/image.size.width;
    CGSize size = CGSizeMake(0,0);
    //获取文本高度
    //    [self getTextViewHeight:indexPath];
    size = CGSizeMake(self.imagewidth, image.size.height*aFloat);
    //..返回cell的大小..//
    return size;
}

#pragma mark - 加载即将开始游戏数据
-(void)loadWillBeginGameData{
    __weak typeof(self)weakSelf = self;

    [[XLConnectionStore shareConnectionStore]getWillHotGamePacketListWithPage:1 andUserSelf:YES andUserID:nil andUserKey:nil andComplection:^(id data, NSString *error) {
        hotGameListArray = data;
        if (hotGameListArray.count == 0) {
            hotGameListArray = [NSKeyedUnarchiver unarchiveObjectWithFile:GAME_HOTGAME_CACHE_PATH];
        }else [NSKeyedArchiver archiveRootObject:data toFile:GAME_HOTGAME_CACHE_PATH];
        NSLog(@"getWillHotGame========%@",hotGameListArray);
            [weakSelf.collectionView reloadData];
    }];

}

@end
