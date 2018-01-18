//
//  ZDSPhotosViewController.m
//  LOGIN
//
//  Created by System Administrator on 15/10/22.
//  Copyright © 2015年 System Administrator. All rights reserved.
//

#import "ZDSPhotosViewController.h"


#import "HomeGroupModel.h"

#import "ZDSHealthDiaryViewController.h"
#import "UserAblumViewController.h"

#import "ZDSWeekViewController.h"
//初始化相册相关控件
#import "ZDSPhotosCollectionViewCell.h"
#import "ZDSPhotosCollectionReusableView.h"
#import "GroupTalkDetailViewController.h"
#import "DiscoverDetailViewController.h"
#import "CalendarDetailViewController.h"
#import "taskDetailViewController.h"
#import "MJPhoto.h"

@interface ZDSPhotosViewController ()
/**
 * 创建相册视图
 */
{
    NSArray *recipeImage;
    NSArray *timeArray;
    
    int timePageNum;
    bool isMore;
    NSMutableArray *m_DataArr;
    BOOL rightHidden;
    NSMutableDictionary*mutableDic;
    NSMutableArray *allKeys;
}
@property(nonatomic,assign)BOOL hasMore;//有没有更低
@end

@implementation ZDSPhotosViewController
static NSString *strCellIdentify =@"ZDSPhotosViewController";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSLog(@"%p,%p",self.tabBarController,self.navigationController.tabBarController);
}
-(void)viewWillDisappear:(BOOL)animated{

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.hasMore = YES;
    allKeys = [NSMutableArray array];
    UIView *titleViews = [[UIView alloc] init];
    [titleViews addSubview:self.leftButton];
    [titleViews addSubview:self.rightButton];
    self.navigationItem.titleView = titleViews;
    //导航栏标题
    UILabel *title = [[UILabel alloc] init];
    title.text = @"相册";
    title.textColor = ZDS_DHL_TITLE_COLOR;
    //    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    title.font = MyFont(18);
    title.textAlignment = NSTextAlignmentCenter;
    title.frame = CGRectMake(0, 0, 320, 44);
    title.center = titleViews.center;
    [titleViews addSubview:title];
    
    //导航栏返回
    [self.leftButton setBackgroundImage:[UIImage imageNamed:@"fh-36"] forState:UIControlStateNormal];
    self.leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.leftButton.bounds = CGRectMake(0, 0, 18, 18);
    self.leftButton.titleLabel.font = MyFont(13);
    [self.leftButton addTarget:self action:@selector(popButton) forControlEvents:UIControlEventTouchUpInside];
    
    [self.rightButton setTitle:@"健康日记" forState:UIControlStateNormal];
    [self.rightButton setTitleColor:OrangeColor forState:UIControlStateNormal];
    self.rightButton.titleLabel.font = MyFont(13);
    self.rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.rightButton.bounds = CGRectMake(0, 0, 90, 28);
    [self.rightButton addTarget:self action:@selector(rightSelectedMethod) forControlEvents:(UIControlEventTouchUpInside)];

    if (self.collectionView.contentSize.height < self.collectionView.frame.size.height) {
        self.collectionView.scrollEnabled = YES;
        self.collectionView.alwaysBounceVertical = YES;
    }
    
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView"];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
//    [flowLayout setSectionInset:UIEdgeInsetsMake(5, 8, 5, 0)];
    
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [self.collectionView setCollectionViewLayout:flowLayout];
    [self.collectionView registerNib:[UINib nibWithNibName:@"ZDSPhotosCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"ZDSPhotosCollectionViewCell"];
    
    [self.view addSubview:self.collectionView];
    
    
    //    初始化刷新
    [self loadPhotoDataWithIsMore:NO];
    
    __weak typeof(self) weakSlef = self;
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    self.header = header;
    header.scrollView = self.collectionView;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        [self loadPhotoDataWithIsMore:NO];
    };
    
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    self.footer = footer;
    footer.scrollView = self.collectionView;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        [self loadPhotoDataWithIsMore:YES];
    };
}

#pragma mark - 返回上一级
-(void)popButton{
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)loadPhotoDataWithIsMore:(BOOL)more{
    if (more) {
        if (!self.hasMore) {
            [self showAlertMsg:@"没有更多了" andFrame:CGRectZero];
            [self.footer endRefreshing];
            return;
        }
        
    }else{
        self.hasMore = YES;
    }
    
    NSMutableDictionary *dictionary = [NSMutableDictionary new];
    if (isMore) {
        [dictionary setObject:[NSString stringWithFormat:@"%d",timePageNum+1] forKey:@"pageNum"];
    }else{
        [dictionary setObject:[NSString stringWithFormat:@"%d",1] forKey:@"pageNum"];
        
    }
    [dictionary setObject:[NSUSER_Defaults objectForKey:ZDS_USERID] forKey:@"seeuserid"];
    
    if(more) [dictionary setObject:self.lastId forKey:@"lastid"];
    
    [dictionary setObject:@"10" forKey:@"pageSize"];
    //    if(isMore && self.lastId!=nil)
    //        [dictionary setObject:self.lastId forKey:@"lastid"];
    __weak typeof(self)weakSelf = self;
    
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_GROUP_PHOTOS parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        //成功
        
        if (!more) {
            [[self mutableDic] removeAllObjects];
            [allKeys removeAllObjects];
        }else{
            timePageNum ++;
        }
        [weakSelf reloadDataArr:dic[@"photoslist"]];
        
//        self.lastId = [dic[@"photoslist"] lastObject][@"photosid"];
//        
//        if ([dic[@"haswegphotos"] isEqualToString:@"0"])
//            self.rightButton.hidden = NO;
//        
//        [self.collectionView reloadData];
//        [weakSelf.header endRefreshing];
//        [weakSelf.footer endRefreshing];
        
        if (!dic){
            _collectionView.hidden = YES;
            _emtyView.hidden = NO;
            _emtyView.backgroundColor = [UIColor redColor];
            
        }
        else {
            _emtyView.hidden = YES;
            _collectionView.hidden = NO;
            
            self.lastId = [dic[@"photoslist"] lastObject][@"photosid"];
            
            if ([dic[@"haswegphotos"] isEqualToString:@"0"])
                self.rightButton.hidden = NO;
            
            [self.collectionView reloadData];
            [weakSelf.header endRefreshing];
            [weakSelf.footer endRefreshing];
        }

        
        
    }];
}
-(void)reloadDataArr:(NSArray *)Arr{
    //
    
    if (Arr.count == 0) {
        self.hasMore = NO;
    }
    for (int i = 0 ;i<Arr.count;i++){
        NSMutableArray *array = [NSMutableArray array];
        
        NSDictionary * diction = Arr[i];
        NSString *timeStr =[diction[@"createtime"] substringToIndex:10];
        if (mutableDic[timeStr]!= nil) {
            [array addObjectsFromArray:mutableDic[timeStr]];
        }
        MePhotoModel *mode = [[MePhotoModel alloc] init];
        mode.photosid = diction[@"photosid"];
        mode.recorddate = diction[@"recorddate"];
        mode.linktype = diction[@"linktype"];
        mode.linkid = diction[@"linkid"];
        mode.createtime = diction[@"createtime"];
        mode.imageurl = diction[@"imageurl"];
        [array addObject:mode];
        [mutableDic setObject:array forKey:timeStr];
        BOOL isHave = false;
        for (NSString *s in allKeys) {
            if ([s isEqualToString:timeStr]) {
                isHave = true;
                break;
            }
        }
        if(!isHave) [allKeys addObject:timeStr];
    }
    
}
-(NSMutableDictionary *)mutableDic{
    if (mutableDic == nil) {
        mutableDic = [NSMutableDictionary dictionary];
    }
    return mutableDic;
}
-(NSMutableArray *)m_DataArr{
    if (m_DataArr == nil){
        m_DataArr = [NSMutableArray array];
        
    }
    return m_DataArr;
}


-(void)rightSelectedMethod{
    UserAblumViewController *userAblum = [[UserAblumViewController alloc]init];
    [self.navigationController pushViewController:userAblum animated:YES];
}

#pragma mark -- UICollectionViewDataSource
//定义展示的Section的个数
-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    if (mutableDic != nil) {
        return  mutableDic.allValues.count;// [[mutableDic objectForKey:mutableDic.allKeys] count];
    }
    return 0;
    
    
    
}
//定义展示的UICollectionViewCell的个数
-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (mutableDic != nil){
        return   [[mutableDic objectForKey:allKeys[section]] count];
    }
    return 0;
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([mutableDic[allKeys[indexPath.section]][indexPath.row] isMemberOfClass:[MePhotoModel class]]) {
        NSLog(@"MePhotoModel");
    }
    
    MePhotoModel *model = [mutableDic objectForKey:allKeys[indexPath.section]][indexPath.row];
    
    static NSString *ID =@"ZDSPhotosCollectionViewCell";
    ZDSPhotosCollectionViewCell *cell = (ZDSPhotosCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ZDSPhotosCollectionViewCell" owner:nil options:nil] lastObject];
    };

    cell.photosImageView.backgroundColor = [WWTolls colorWithHexString:@"#efefef"];
    //    NSArray *arr = [mutableDic objectForKey:mutableDic.allKeys[indexPath.section]];
    //    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    //    for (NSNumber *number in arr) {
    //        [dict setObject:number forKey:number];
    //    }
    //    NSLog(@"[dict allValues] %@",[dict allValues]);
    [cell.photosImageView sd_setImageWithURL:[NSURL URLWithString:model.imageurl]];
    
    //    cell.backgroundView.layer.borderColor = [UIColor whiteColor].CGColor;
    //    cell.backgroundView.layer.borderWidth = 8;
    //    cell.backgroundView = cell.photosImageView;
    
    //    UIImageView *recipeImageView = (UIImageView *)[cell viewWithTag:100];
    //    recipeImageView.image = [UIImage imageNamed:[recipeImage[indexPath.section]objectAtIndex:indexPath.row]];
    //    cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tag_days_28"]];
    
    //    cell.backgroundColor = [UIColor colorWithRed:((10 * indexPath.row) / 255.0) green:((20 * indexPath.row)/255.0) blue:((30 * indexPath.row)/255.0) alpha:1.0f];
    
    return cell;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5,8,5,5);//针对于单个collectionview的边距控制
}

//header
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(self.view.frame.size.width, 30);
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    NSString *str = allKeys[indexPath.section];
    
    
    UICollectionReusableView *reusableView = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView" forIndexPath:indexPath];
        UILabel *topLabel = [[UILabel alloc]init];
        topLabel.frame = CGRectMake(0, 0, self.view.frame.size.width, 30);
        topLabel.backgroundColor = [UIColor whiteColor];// [UIColor colorWithWhite:0.922 alpha:1.000];
        [reusableView addSubview:topLabel];
        //headView创建
//        UIView *backgroundView = [UIView new];
//        backgroundView.frame = CGRectMake(0, 10, self.view.frame.size.width, 30);
//        backgroundView.backgroundColor = [UIColor redColor];
//        [reusableView addSubview:backgroundView];
        
        //头标体界面
        UILabel *headLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 320, 12)];
        headLabel.textColor = [WWTolls colorWithHexString:@"#4d787e"];
        
        //时间转换
        //        NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:];
        //        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        //        [formatter setDateStyle:NSDateFormatterMediumStyle];
        //        [formatter setTimeStyle:NSDateFormatterShortStyle];
        //        [formatter setDateFormat:@"MM-dd"];
        //        NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
        NSString *strUrl = [str stringByReplacingOccurrencesOfString:@"-" withString:@"."];
        headLabel.text = strUrl;//[str substringFromIndex:5];
        
        //时间显示适配
        [headLabel setNumberOfLines:1];
        headLabel.font = [UIFont fontWithName:@"HelveticaNeue-bold" size:12];
        //        UIFont *font = MyFont(14);
        //        CGSize size = CGSizeMake(self.view.frame.size.width,10);
        //        CGFloat labelsize = [WWTolls WidthForString:confromTimespStr fontSize:14]+20;
        [headLabel sizeToFit];
        [reusableView addSubview:headLabel];
        //线
//        UILabel *lineLabel = [UILabel new];
//        lineLabel.frame = CGRectMake(headLabel.frame.size.width+16, 14, self.view.frame.size.width-10-headLabel.frame.size.width-10, 0.5f);
//        lineLabel.backgroundColor = [WWTolls colorWithHexString:@"#dcdcdc"];
//        
//        [backgroundView addSubview:lineLabel];
//        [backgroundView addSubview:headLabel];
        
        //        CustomCollectionReusableView *headview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CustomCollectionReusableView" forIndexPath:indexPath];
        //        NSString *title = [[NSString alloc]initWithFormat:@"10-1%i",indexPath.section+1];
        //        headview.headLabel.text = title;
    }
    return reusableView;
}


#pragma mark --UICollectionViewDelegateFlowLayout

////定义每个UICollectionView 的 margin
//-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//
//    return UIEdgeInsetsMake(0, 0, 0, 0);
//}

//定义每个UICollectionViewCell 的大小

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size = CGSizeMake(0,0);
    CGFloat widthatMargin  = kVIEW_BOUNDS_WIDTH/3 - 5;
    size = CGSizeMake(widthatMargin,widthatMargin);
    //..返回cell的大小..//
    return size;
}
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MePhotoModel *model = mutableDic[allKeys[indexPath.section]][indexPath.row];
    if (model.linkid.length < 1) {
        return;
    }
    //1 撒欢 2 乐活吧 3 精华帖 4 打卡 5 任务
    switch (model.linktype.intValue) {
        case 1:
        {
            DiscoverDetailViewController *cc = [[DiscoverDetailViewController alloc] init];
            cc.discoverId = model.linkid;
            [self.navigationController pushViewController:cc animated:YES];
        }
            break;
        case 2:
        {
            GroupTalkDetailViewController *cc = [[GroupTalkDetailViewController alloc] init];
            cc.clickevent = 6;
            cc.talktype = GroupSimpleTalkType;
            cc.talkid = model.linkid;
            [self.navigationController pushViewController:cc animated:YES];
        }
            break;
        case 3:
        {
            GroupTalkDetailViewController *cc = [[GroupTalkDetailViewController alloc] init];
            cc.talkid = model.linkid;
            cc.clickevent = 6;
            cc.talktype = GroupTitleTalkType;
            [self.navigationController pushViewController:cc animated:YES];
        }
            break;
        case 4:
        {
            CalendarDetailViewController *cc = [[CalendarDetailViewController alloc] init];
            MJPhoto *photo = [[MJPhoto alloc] init];
            photo.url = [NSURL URLWithString:model.imageurl];
            UIImageView *ii = [[UIImageView alloc] init];
            [ii sd_setImageWithURL:[NSURL URLWithString:model.imageurl]];
            photo.srcImageView = ii;
            cc.photos = @[photo];
            cc.dakaId = model.linkid;
            [self.navigationController pushViewController:cc animated:YES];
        }
            break;
        case 5:
        {
            taskDetailViewController *cc = [[taskDetailViewController alloc] init];
            cc.taskId = model.linkid;
            [self.navigationController pushViewController:cc animated:YES];
        }
            break;
        default:
            break;
    }
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
