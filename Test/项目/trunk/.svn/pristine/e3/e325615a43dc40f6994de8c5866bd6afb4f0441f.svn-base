//
//  StoreCollectionViewController.m
//  zhidoushi
//
//  Created by xinglei on 15/1/16.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "StoreCollectionViewController.h"

#import "StoreCollectionViewCell.h"
#import "Define.h"
#import "UIViewExt.h"
//..priviate..//
#import "WWTolls.h"
#import "StoreModel.h"
//..netWork..//
#import "JSONKit.h"
//#import "XLConnectionStore.h"
#import "WWRequestOperationEngine.h"
//..gateGory..//
#import "UIView+ViewController.h"
#import "NSString+NARSafeString.h"
#import "StoreDetailViewController.h"
#import "UIView+ViewController.h"


#import "StoreViewController.h"

#import "UIImageView+WebCache.h"

@interface StoreCollectionViewController ()
{
    StoreCollectionViewCell *storeCell;
}

@property(weak,nonatomic) UILabel* lbl;
@end

@implementation StoreCollectionViewController

static NSString * const reuseIdentifier = @"Store_Cell";

-(instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout{

    if (self = [super initWithCollectionViewLayout:layout]) {
        [self.collectionView registerClass:[StoreCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
        self.collectionView.backgroundColor = [WWTolls colorWithHexString:@"fafafa"];
    }
    return self;
}

//跳转fame
-(void)adjustFrame{
    // 内容的高度
    CGFloat contentHeight = self.collectionView.contentSize.height;
    // 表格的高度
    CGFloat scrollHeight = self.collectionView.frame.size.height - self.collectionView.top - self.collectionView.bottom;
    CGFloat y = MAX(contentHeight, scrollHeight);
    // 设置边框
    self.lbl.center = CGPointMake(self.view.frame.size.width*0.5, y+6);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //刷新
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = self.collectionView; // 或者tableView
    self.header = header;
    
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.collectionView; // 或者tableView
    self.footer = footer;
    
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        [self.del doneLoadingTableViewData];
        [self.del uploadAdvertisementData:1 pageSizeFor:@"10"];
        [self.del getNum];
    };
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        [self.del loadMoreData];
    };
    [header beginRefreshing];
    UILabel *label = [[UILabel alloc] init];
    self.lbl = label;
    label.text = @"活动由北京健康有益科技有限公司提供，与设备生产商Apple Inc.无关";
    label.font = MyFont(8);
    label.textColor = [WWTolls colorWithHexString:@"#535353"];
    label.textAlignment = UITextAlignmentCenter;
    label.frame = CGRectMake(0, 0, self.view.size.width, 20);
//    self.collectionView.contentInset.bottom = 20;
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 14, 0);
    self.collectionView.scrollsToTop = YES;
    [self.collectionView addSubview:label];
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
    return _hotGameListArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    [self adjustFrame];
    UINib *nib = [UINib nibWithNibName:@"StoreCollectionViewCell" bundle:[NSBundle mainBundle]];
    [collectionView registerNib:nib forCellWithReuseIdentifier:reuseIdentifier];
    storeCell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
//    storeCell.leftImageView.backgroundColor = [UIColor clearColor];
//    storeCell.leftImageView.layer.backgroundColor = [[UIColor clearColor] CGColor];
    if (indexPath.row%4==3||indexPath.row%4==0) {
//        storeCell.leftImageView.opaque =YES;
//        storeCell.leftImageView.maskView.backgroundColor = [WWTolls colorWithHexString:@"#f0f0f0"];
        storeCell.contentView.backgroundColor = [WWTolls colorWithHexString:@"#f0f0f0"];
    }else{
//        storeCell.leftImageView.tintColor = [WWTolls colorWithHexString:@"#f7f7f7"];
        storeCell.contentView.backgroundColor = [WWTolls colorWithHexString:@"#f7f7f7"];
    }
//    [storeCell.leftImageView sd_setImageWithURL:[NSURL URLWithString:@"http://123.57.67.25:8080/zhidoushi/imgs/goods/1/320/0"]];
    if (_hotGameListArray.count>0) {
        storeCell.storeModel = [_hotGameListArray objectAtIndex:indexPath.item];
    }
    return storeCell;
}



#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //select Item
    NSLog(@"item= %li,section = %li,row = %li",(long)indexPath.item,(long)indexPath.section,(long)indexPath.row);
    //跳转到游戏详情页
    StoreModel * storeModel = [[StoreModel alloc]init];
    storeModel = [_hotGameListArray objectAtIndex:indexPath.item];
    if (storeModel.goodsidleft.length!=0 && [storeModel.goodsidleft isKindOfClass:[NSString class]]) {
        StoreDetailViewController *storeDetail = [[StoreDetailViewController alloc]initWithNibName:@"StoreDetailViewController" bundle:nil];
        NSLog(@"*************%@",storeModel.goodsidleft);
        storeDetail.isEnoughScore = [storeModel.scoreEnoughleft isEqualToString:@"1"]?YES:NO;
        storeDetail.goodsid = storeModel.goodsidleft;
        [self.view.viewController.navigationController pushViewController:storeDetail animated:YES];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeMake(0,0);
    size = CGSizeMake(SCREEN_WIDTH/2, SCREEN_WIDTH*195/320);
    //..返回cell的大小..//
    return size;
}

-(void)dealloc
{
    [_header free];
    [_footer free];
}
@end
