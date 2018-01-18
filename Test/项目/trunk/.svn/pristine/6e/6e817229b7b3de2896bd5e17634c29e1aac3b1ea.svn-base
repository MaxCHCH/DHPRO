//
//  ZDSPhotosViewController.h
//  LOGIN
//
//  Created by System Administrator on 15/10/22.
//  Copyright © 2015年 System Administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyAttentionModel.h"
@interface ZDSPhotosViewController : BaseViewController<UICollectionViewDataSource,
UICollectionViewDelegate,UIScrollViewDelegate,
UICollectionViewDelegateFlowLayout>
{
    BOOL                     _isLoading;
    NSMutableArray           *_dataArray;
    NSMutableDictionary      *_coursePackDic;
}
@property(nonatomic,weak) IBOutlet UICollectionView   *collectionView;
@property(nonatomic,strong)MJRefreshHeaderView *header;//头部刷新
@property(nonatomic,strong)MJRefreshFooterView *footer;//底部刷新
@property(nonatomic,copy)NSString *seeUserID;//被查看人userid
@property (weak, nonatomic) IBOutlet UIView *emtyView;

@end
