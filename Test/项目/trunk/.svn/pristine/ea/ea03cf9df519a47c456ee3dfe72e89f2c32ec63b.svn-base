//
//  NARCollectionViewController.m
//  自定义Layout
//
//  Created by xinglei on 14/11/27.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import "NARCollectionViewController.h"
//..private..//
#import "WWTolls.h"
#import "UIView+ViewController.h"
#import "NARCollectionViewCell.h"
//..netWork..//
#import "XLConnectionStore.h"
#import "UIViewExt.h"
#import "Define.h"
#import "WillBeginCollectionModel.h"
#import "NSObject+MJCoding.h"


@interface NARCollectionViewController ()<UICollectionViewDataSource>
{
    NSMutableArray * hotGameListArray;//存储热门游戏信息数组
}
@property(nonatomic,strong)NARCollectionViewCell *cell;
@end

@implementation NARCollectionViewController

static NSString * const reuseIdentifier = @"Cell__";

-(instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout{

    if (self = [super initWithCollectionViewLayout:layout]) {
    hotGameListArray = [[NSMutableArray alloc]initWithCapacity:6];
    [self.collectionView registerClass:[NARCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.backgroundColor = [WWTolls colorWithHexString:@"fafafa"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    hotGameListArray = [NSKeyedUnarchiver unarchiveObjectWithFile:GAME_RIGHTNOW_CACHE_PATH];
    if (hotGameListArray.count>0) {
        [self.collectionView reloadData];
    }
    [self loadWillBeginGameData];

    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;

    // Register cell classes    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)sectio
{

    return hotGameListArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    UINib *nib = [UINib nibWithNibName:@"NARCollectionViewCell" bundle:[NSBundle mainBundle]];
//    [collectionView registerNib:nib forCellWithReuseIdentifier:reuseIdentifier];
    // Configure the cell
    NSLog(@"count===========%lu,%ld",(unsigned long)hotGameListArray.count,(long)indexPath.row);
    self.cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    //调节相片的大小（x，y不变）
    self.cell.imageView.frame = CGRectMake(0, 0, ZDS_FISTPAGE_BEGINMODLE_WIDTH, ZDS_FISTPAGE_BEGINMODLE_WIDTH);
    self.cell.bottomView.frame = CGRectMake(0, self.cell.imageView.bottom, ZDS_FISTPAGE_BEGINMODLE_WIDTH, ZDS_FISTPAGE_BEGINMODLE_LABEL_WIDTH);
     NSLog(@"self.cell.height************%f,%f",self.cell.height,self.cell.width);
//    self.cell.backgroundColor = [UIColor redColor];
    if (hotGameListArray.count>0) {
        self.cell.beginModel = [hotGameListArray objectAtIndex:indexPath.item];
    }
    return self.cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{

    
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark - UICollectionView Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //select Item
    NSLog(@"item= %li,section = %li,row = %li",(long)indexPath.item,(long)indexPath.section,(long)indexPath.row);
    //跳转到游戏详情页
    WillBeginCollectionModel *beginModel = [[WillBeginCollectionModel alloc]init];
    beginModel = [hotGameListArray objectAtIndex:indexPath.item];

    NSLog(@"*************%@",beginModel.gameid);
    if (beginModel.gameid.length!=0 && [beginModel.gameid isKindOfClass:[NSString class]]) {
        GameDetail_ViewController *gameDetail = [[GameDetail_ViewController alloc]initWithNibName:@"GameDetail_ViewController" bundle:nil];
        gameDetail.gameid = beginModel.gameid;
        gameDetail.gameName = beginModel.gamename;
         NSLog(@"gameDetail.gameName****%@,%@",gameDetail.gameName,beginModel.gamename);
        gameDetail.imageUrlString = beginModel.imageurl;
        [self.view.viewController.navigationController pushViewController:gameDetail animated:YES];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    CGFloat aFloat = 0;
//    UIImage* image = self.imagesArr[indexPath.item];
//    aFloat = self.imagewidth/image.size.width;
//    CGSize size = CGSizeMake(0,0);
//    //获取文本高度
//    size = CGSizeMake(self.imagewidth, (image.size.height*aFloat+80));
    //..返回cell的大小..//
//     NSLog(@"********image.size.height*aFloat+80%ld,%f",(long)self.imagewidth,image.size.height*aFloat+80);
    return CGSizeMake(84, 125.6);
}

#pragma mark - 加载即将开始游戏数据
-(void)loadWillBeginGameData{
    
    
    __weak typeof(self)weakSelf = self;
    [[XLConnectionStore shareConnectionStore]getWillBegainGamePacketListWithPage:1 andUserSelf:YES andUserID:nil andUserKey:nil andComplection:^(id data, NSString *error) {
        if (hotGameListArray.count !=0) {
            [hotGameListArray removeAllObjects];
        }
        if(data != nil)
            hotGameListArray = data;
        NSInteger numberArray = hotGameListArray.count;
        if (numberArray == 0) {
            hotGameListArray = [NSKeyedUnarchiver unarchiveObjectWithFile:GAME_RIGHTNOW_CACHE_PATH];
        }else {
            [NSKeyedArchiver archiveRootObject:data toFile:GAME_RIGHTNOW_CACHE_PATH];
        }
        numberArray = hotGameListArray.count;
        if (hotGameListArray.count<6) {
            WillBeginCollectionModel *model = [[WillBeginCollectionModel alloc]init];
            for (int i = 0; i<6-numberArray; i++) {
                [hotGameListArray addObject:model];
            }
        }
        [weakSelf.collectionView reloadData];
        NSLog(@"加载即将开始游戏数据========%@",hotGameListArray);
    }];
}

@end
