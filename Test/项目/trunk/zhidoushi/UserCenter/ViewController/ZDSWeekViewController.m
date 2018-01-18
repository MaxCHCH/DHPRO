//
//  ZDSWeekViewController.m
//  zhidoushi
//
//  Created by System Administrator on 15/10/22.
//  Copyright © 2015年 game.zhidoushi.com. All rights reserved.
//
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]

#import "ZDSWeekViewController.h"
#import "ZDSWeekCollectionViewCell.h"
#import "WebViewController.h"
@interface ZDSWeekViewController ()
{
    BOOL isMore;
    NSMutableArray *mutableArr;
    NSMutableArray *m_DataArr;
    NSMutableDictionary*mutableDic;
    int timePageNum;//页数加载

}
@end

@implementation ZDSWeekViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIView *titleViews = [[UIView alloc] init];
    [titleViews addSubview:self.leftButton];
    [titleViews addSubview:self.rightButton];
    self.navigationItem.titleView = titleViews;
    //导航栏标题
    UILabel *title = [[UILabel alloc] init];
    title.text = @"周记";
    title.textColor = ZDS_DHL_TITLE_COLOR;
    //    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    title.font = MyFont(18);
    title.textAlignment = NSTextAlignmentCenter;
    title.frame = CGRectMake(0, 0, 320, 44);
    title.center = titleViews.center;
    [titleViews addSubview:title];
    //导航栏返回
    [self.leftButton setBackgroundImage:[UIImage imageNamed:@"BarBtn_goBack_32_32"] forState:UIControlStateNormal];
    self.leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.leftButton.bounds = CGRectMake(0, 0, 18, 18);
    self.leftButton.titleLabel.font = MyFont(13);
    [self.leftButton addTarget:self action:@selector(popButton) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.myConllectionView.contentSize.height < self.myConllectionView.frame.size.height) {
        self.myConllectionView.scrollEnabled = YES;
        self.myConllectionView.alwaysBounceVertical = YES;
    }

    self.view.backgroundColor =[UIColor whiteColor];
    self.myConllectionView.backgroundColor = [UIColor colorWithWhite:0.918 alpha:1.000];
    [self.myConllectionView registerClass:[ZDSWeekCollectionViewCell class] forCellWithReuseIdentifier:@"ZDSWeekCollectionViewCell"];

    //初始化刷新
    [self loadPhotoDataWithIsMore:NO];
    
    __weak typeof(self) weakSlef = self;
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    self.header = header;
    header.scrollView = self.myConllectionView;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        [self loadPhotoDataWithIsMore:NO];
    };
    
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    self.footer = footer;
    footer.scrollView = self.myConllectionView;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        [self loadPhotoDataWithIsMore:YES];
    };
    [NSUSER_Defaults setObject:@"NO" forKey:@"weekreddian"];
}


-(void)loadPhotoDataWithIsMore:(BOOL)more{
    if (more) {
        if ([self mutableArr].count == 0 ||[self mutableArr].count%10!=0||[self mutableArr].count<timePageNum*10) {
            [self showAlertMsg:@"没有更多了" andFrame:CGRectZero];
            [self.footer endRefreshing];
            return;
        }
        
    }
    //构造请求参数
    NSMutableDictionary *dictionary = [NSMutableDictionary new];
    if (more) {
        [dictionary setObject:[NSString stringWithFormat:@"%d",timePageNum+1] forKey:@"pageNum"];
    }else{
        [dictionary setObject:[NSString stringWithFormat:@"%d",1] forKey:@"pageNum"];
        
    }
    [dictionary setObject:[NSUSER_Defaults objectForKey:ZDS_USERID] forKey:@"seeuserid"];
    if(more && self.lastId) [dictionary setObject:self.lastId forKey:@"lastid"];
    
    [dictionary setObject:@"10" forKey:@"pageSize"];
    //    if(isMore && self.lastId!=nil)
    //        [dictionary setObject:self.lastId forKey:@"lastid"];
    __weak typeof(self)weakSelf = self;
    
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_WEEKLYLIST parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        //成功
        
        if (!more) {
            [[self mutableArr] removeAllObjects];
            timePageNum = 1;
        }else{
            timePageNum ++;
        }
        [weakSelf reloadDataArr:dic[@"weeklylist"]];
        self.lastId = [dic[@"weeklylist"] lastObject][@"reportid"];
        
//        if ([dic[@"haswegphotos"] isEqualToString:@"1"])
        
        [self.myConllectionView reloadData];
        [weakSelf.header endRefreshing];
        [weakSelf.footer endRefreshing];
        
        
    }];
}
-(void)reloadDataArr:(NSArray *)Arr{
    for (int i = 0 ;i<Arr.count;i++){
        [[self mutableArr] addObject:Arr[i]];
    }
    
}
-(NSMutableArray *)mutableArr{
    if (mutableArr == nil) {
        mutableArr = [NSMutableArray array];
    }
    return mutableArr;
}
-(NSMutableArray *)m_DataArr{
    if (m_DataArr == nil){
        m_DataArr = [NSMutableArray array];
        
    }
    return m_DataArr;
}
-(void)popButton{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)loadData{

    //构造请求参数
    NSMutableDictionary *dictionary  = nil;
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_GROUP_WEEKLYLIST parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        //成功

        
    }];

}
#pragma mark -- UICollectionViewDataSource
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
        return UIEdgeInsetsMake(15, 15, 15, 15);
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID =@"ZDSWeekCollectionViewCell";
    ZDSWeekCollectionViewCell *cell = (ZDSWeekCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    NSDictionary *model = mutableArr[indexPath.row];
    [cell.backgroundImageVIew sd_setImageWithURL:[NSURL URLWithString:model[@"imageurl"]]];
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    
    [inputFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate* inputDate = [inputFormatter dateFromString:model[@"date"]];
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    
    [outputFormatter setDateFormat:@"MM月dd日 yyyy"];
    
    NSString *str = [outputFormatter stringFromDate:inputDate];
    cell.DateLabel.text = str;
    //图片名称
//    NSString *imageToLoad = [NSString stringWithFormat:@"%ld.png", indexPath.row];
//    //加载图片
//    cell.backgroundImageVIew.image = [UIImage imageNamed:imageToLoad];
    
    
//    UIImageView *imageVView = [UIImageView new];
//    imageVView.frame = cell.frame;
//    [imageVView setImage:[UIImage imageNamed:@"yuyu"]];
//    [cell.contentView addSubview:imageVView];
//    cell.backgroundColor = [UIColor colorWithRed:((10 * indexPath.row) / 255.0) green:((20 * indexPath.row)/255.0) blue:((30 * indexPath.row)/255.0) alpha:1.0f];
    return cell;
}
//定义展示的Section的个数
-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
//定义展示的UICollectionViewCell的个数
-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return mutableArr.count;
}


#pragma mark --UICollectionViewDelegateFlowLayout   
//定义每个UICollectionView 的大小

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size = CGSizeMake(0,0);
    size = CGSizeMake(self.view.frame.size.width/2-20,self.view.frame.size.width/2-20);
    NSLog(@"----0%f",self.view.frame.size.width);
    //size = CGSizeMake(self.view.frame.size.width/2, self.view.frame.size.width/2);
    //..返回cell的大小..//
    return size;
}
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    UICollectionViewCell * cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    cell.backgroundColor = [UIColor whiteColor];
    WebViewController *web = [[WebViewController alloc] init];
    web.URL = [NSString stringWithFormat:@"%@h5/lb/index.html?reportid=%@&appflg=0",ZDS_DEFAULT_HTTP_SERVER_HOST,mutableArr[indexPath.row][@"reportid"]];
    [self.navigationController pushViewController:web animated:YES];
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
