//
//  NARAdvertisementView.m
//  zhidoushi
//
//  Created by xinglei on 14/11/24.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import "NARAdvertisementView.h"

#import "Define.h"
#import "JSONKit.h"
#import "WWTolls.h"
#import "UIView+ViewController.h"
#import "NSString+NARSafeString.h"
#import "WWRequestOperationEngine.h"
#import "UIImageView+AFNetworking.h"
#import "UIViewController+ShowAlert.h"
#import "NSDictionary+NARSafeDictionary.h"
#import "NSURL+MyImageURL.h"

#import "ImageButton.h"
@interface NARAdvertisementView ()

@property(nonatomic,strong)NSMutableArray * imageurlArray;//图片数组
@property(nonatomic,strong)NSMutableArray * adidArray;//广告id数组
@property(nonatomic,strong)NSMutableArray * adurlArray;//广告链接数组

@end

@implementation NARAdvertisementView

-(instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {

        self.narScrollView = [[NARScrollView alloc]initWithFrame:self.bounds];
        self.narScrollView.pagingEnabled = YES;
        [self addSubview:self.narScrollView];
        [self receiveImageURL];
    }
    return self;
}

#pragma mark - 构建大厅请求数据Url字典
-(NSMutableDictionary*)createDictionary:(NSString*)loadType{
    NSString *userID =  [NSUSER_Defaults objectForKey:ZDS_USERID];
    NSString *userid = [NSString stringWithFormat:@"%@",userID];
    NSString *key = [NSString getMyKey:userID];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:7];
    [dic setObject:userid forKey:@"userid"];
    [dic setObject:key forKey:@"key"];
    [dic setObject:@"4" forKey:@"adcount"];
    [dic setObject:@"8" forKey:@"startcount"];
    [dic setObject:@"6" forKey:@"comingcount"];
    [dic setObject:@"6" forKey:@"hotcount"];
    [dic setObject:@"6" forKey:@"prizecount"];
    [dic setObject:loadType forKey:@"loadtype"];
    NSLog(@"userID____-%@",dic);
    return dic;
}

-(void)receiveImageURL
{
    _imageurlArray = [[NSMutableArray alloc]initWithCapacity:4];
    _adidArray = [[NSMutableArray alloc]initWithCapacity:4];
    _adurlArray = [[NSMutableArray alloc]initWithCapacity:4];

    __weak typeof(self)weakSelf = self;
    NSString *urlString = [NSString stringWithFormat:@"%@%@",ZDS_DEFAULT_HTTP_SERVER_HOST,ZDS_GAMELOBBY_LIST];
    //*****************当自己进入此页面时调用********************//
    [WWRequestOperationEngine operationManagerRequest_Post:urlString parameters:[self createDictionary:@"1"] requestOperationBlock:^(NSString *object) {

        __strong typeof(weakSelf)strongSelf = weakSelf;

        NSLog(@"%@",[NSString stringWithFormat:@"%@%@",ZDS_DEFAULT_HTTP_SERVER_HOST,ZDS_COMPLETE]);

//        NSDictionary *dic = nil;
        NSDictionary *dic = [object objectFromJSONString];

        if (![dic isKindOfClass:[NSDictionary class]] || dic==nil) {

            dic = [WWTolls getMyPostListFilePathString:@"LocalAdvertisementPlist.plist"];
             NSLog(@"****dic***********%@",dic);
            [self configureData:dic];
            [self configureCacheView];
            [strongSelf.viewController showAlertMsg:@"获取信息失败" andFrame:CGRectMake(70,100,200,60)];
            [strongSelf.viewController removeWaitView];

        }else{
            [self configureData:dic];
            NSLog(@"广告位图片错误信息\%@",[dic objectForKey:@"errinfo"]);
            NSLog(@"广告位图片的数据*********%@", dic);
            [strongSelf configureView];
            [strongSelf.viewController removeWaitView];
            //************保存用户数据**************//
            [WWTolls setMyLocalPlistInfo:dic andFilePath:@"LocalAdvertisementPlist.plist"];
        }
    }];


}

-(void)configureView{

    if (_imageurlArray.count>0) {

        UIImageView *aView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        NSURL *url1 = [NSURL URLWithImageString:[_imageurlArray objectAtIndex:0] Size:300];
        [aView setImageWithURL:url1];
//        [self getPictureCache:[_imageurlArray objectAtIndex:0] andImageView:aView];
        [self.narScrollView addSubview:aView];
//        [self writeImageToFile:aView.image andImageName:[NSString stringWithFormat:@"%@",[_imageurlArray objectAtIndex:0]]];

    if (_imageurlArray.count>1) {

        UIImageView *bView = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width, 0, self.bounds.size.width, self.bounds.size.height)];
        NSURL *url2 = [NSURL URLWithImageString: [_imageurlArray objectAtIndex:1] Size:300];
        [bView setImageWithURL:url2];
//        [self getPictureCache:[_imageurlArray objectAtIndex:1] andImageView:aView];
        [self.narScrollView addSubview:bView];
    }

    if (_imageurlArray.count>2) {

        UIImageView *cView = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width * 2, 0, self.bounds.size.width, self.bounds.size.height)];
        NSURL *url3 = [NSURL URLWithImageString: [_imageurlArray objectAtIndex:2] Size:320];
        [cView setImageWithURL:url3];
//        [self getPictureCache:[_imageurlArray objectAtIndex:2] andImageView:aView];
        [self.narScrollView addSubview:cView];

    }

    if (_imageurlArray.count>3) {

        UIImageView *dView = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width * 3, 0, self.bounds.size.width, self.bounds.size.height)];
        NSURL *url4 = [NSURL URLWithImageString: [_imageurlArray objectAtIndex:3] Size:300];
        [dView setImageWithURL:url4 placeholderImage:[UIImage imageNamed:@"jiatu_4.png"]];
//        [self getPictureCache:[_imageurlArray objectAtIndex:3] andImageView:aView];
        [self.narScrollView addSubview:dView];
    }

    if (_imageurlArray.count>4) {

        UIImageView *eView = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width * 4, 0, self.bounds.size.width, self.bounds.size.height)];
        NSURL *url5 = [NSURL URLWithImageString: [_imageurlArray objectAtIndex:4] Size:300];
        [eView setImageWithURL:url5];
//        [self getPictureCache:[_imageurlArray objectAtIndex:4] andImageView:aView];
        [self.narScrollView addSubview:eView];

    }

    if (_imageurlArray.count>5) {

        UIImageView *fView = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width * 5, 0, self.bounds.size.width, self.bounds.size.height)];
        NSURL *url6 = [NSURL URLWithImageString: [_imageurlArray objectAtIndex:5] Size:300];
        [fView setImageWithURL:url6];
    //    [self getPictureCache:[_imageurlArray objectAtIndex:5] andImageView:aView];
        [self.narScrollView addSubview:fView];
    }

        }

    NSInteger pages = _imageurlArray.count;
    NARControl *annexationPageControl = [[NARControl alloc]init];
    annexationPageControl.currentPage = 1;
    [annexationPageControl setNumberOfPages:pages];
    annexationPageControl.frame = CGRectMake(40, 30, 100, 50);
    [annexationPageControl setDataSource:self];
    [annexationPageControl setHidensForSinglePage:YES];
    self.narPageControl = annexationPageControl;
    //..创建分页..//
    [self createPages:pages];
    [self.narPageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
//    [self.narScrollView addSubview:self.narPageControl];
    [self addSubview:self.narPageControl];
}

- (void)createPages:(NSInteger)pages {
//    for (int i = 0; i < pages; i++) {
//        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.narScrollView.bounds) * i, 0, CGRectGetWidth(self.narScrollView.bounds), CGRectGetHeight(self.narScrollView.bounds))];
//        UILabel *label = [[UILabel alloc] init];
//        [label setText:[NSString stringWithFormat:@"%i", i+1]];
//        [label setFont:[UIFont boldSystemFontOfSize:90]];
//        
//        [label sizeToFit];
//        [label setCenter:CGPointMake(CGRectGetMidX(view.bounds), CGRectGetMidY(view.bounds))];
//        
//        if (i % 2 == 0) {
//            [view setBackgroundColor:[UIColor darkGrayColor]];
//            [label setTextColor:[UIColor whiteColor]];
//        } else {
//            [view setBackgroundColor:[UIColor whiteColor]];
//            [label setTextColor:[UIColor darkGrayColor]];
//        }
//        
//        [view addSubview:label];
//        [self.narScrollView addSubview:view];
//    }
    
    [self.narScrollView setContentSize:CGSizeMake(CGRectGetWidth(self.narScrollView.bounds) * pages, CGRectGetHeight(self.narScrollView.bounds))];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.narPageControl maskEventWithOffset:scrollView.contentOffset.x frame:scrollView.frame];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = self.narScrollView.frame.size.width;
    NSInteger page =  floor((self.narScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    [self.narPageControl setCurrentPage:page];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    CGFloat pageWidth = self.narScrollView.frame.size.width;
    NSInteger page =  floor((self.narScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    [self.narPageControl setCurrentPage:page];
}

#pragma mark - IBActions
- (void)changePage:(NARControl *)sender {
    self.narPageControl.currentPage = sender.currentPage;
    CGRect frame = self.narScrollView.frame;
    frame.origin.x = frame.size.width * self.narPageControl.currentPage;
    frame.origin.y = 0;
    [self.narScrollView scrollRectToVisible:frame animated:YES];
}

#pragma mark - KVNMaskedPageControlDataSource
- (UIColor *)pageControl:(NARControl *)control pageIndicatorTintColorForIndex:(NSInteger)index {
    if (index % 2 == 0) {
        return [UIColor colorWithWhite:1.0 alpha:.6];
    } else {
        return [UIColor colorWithWhite:0 alpha:.5];
    }
}

- (UIColor *)pageControl:(NARControl *)control currentPageIndicatorTintColorForIndex:(NSInteger)index {
    if (index % 2 == 0) {
        return nil; // nil just sets the default UIPageControl color or respects UIAppearance setting.
    } else {
        return [UIColor colorWithWhite:0 alpha:.8];
        
    }
}

#pragma mark- 把图片保存到本地
- (void)writeImageToFile:(UIImage *)image andImageName:(NSString*)imageTitle
{
    NSData *imagedata;
    NSString *imagesName;

    if (UIImagePNGRepresentation(image) == nil)

    {
        imagedata = UIImageJPEGRepresentation(image, 1.0);
        imagesName = [NSString stringWithFormat:@"/%@image.jpg",imageTitle];
        NSLog(@"imagedata-------%@",imagedata);


    }
    else
    {
        imagedata = UIImagePNGRepresentation(image);
        imagesName = [NSString stringWithFormat:@"/%@image.png",imageTitle];
        NSLog(@"imagedata-------%@",imagedata);

    }

    //图片保存的路径

    //这里将图片放在沙盒的documents文件夹中

    NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSLog(@"DocumentsPath------->>>>>>>>%@",DocumentsPath);
    //文件管理器

    NSFileManager *fileManager = [NSFileManager defaultManager];

    //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png

    [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];

    NSLog(@"imagesName-------%@",imagesName);

    //..获取图片路径..//
    NSString *image_path = [DocumentsPath stringByAppendingString:imagesName];

    NSLog(@"image_path-------%@",image_path);

    [fileManager createFileAtPath:image_path contents:imagedata attributes:nil];

}

-(void)configureCacheView{


    if (_imageurlArray.count>0) {

        UIImageView *aView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        aView.image = [self getMyImageWithImageName:[_imageurlArray objectAtIndex:0]];
         NSLog(@"[_imageurlArray objectAtIndex:0]________%@",[_imageurlArray objectAtIndex:0]);
        [self.narScrollView addSubview:aView];

        if (_imageurlArray.count>1) {

            UIImageView *bView = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width, 0, self.bounds.size.width, self.bounds.size.height)];
            bView.image = [self getMyImageWithImageName:[_imageurlArray objectAtIndex:1]];
            [self.narScrollView addSubview:bView];
        }

        if (_imageurlArray.count>2) {

            UIImageView *cView = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width * 2, 0, self.bounds.size.width, self.bounds.size.height)];
            cView.image = [self getMyImageWithImageName:[_imageurlArray objectAtIndex:2]];
            [self.narScrollView addSubview:cView];

        }

        if (_imageurlArray.count>3) {

            UIImageView *dView = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width * 3, 0, self.bounds.size.width, self.bounds.size.height)];
            dView.image = [self getMyImageWithImageName:[_imageurlArray objectAtIndex:3]];
            [self.narScrollView addSubview:dView];
        }

        if (_imageurlArray.count>4) {

            UIImageView *eView = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width * 4, 0, self.bounds.size.width, self.bounds.size.height)];
            eView.image = [self getMyImageWithImageName:[_imageurlArray objectAtIndex:4]];
            [self.narScrollView addSubview:eView];

        }

        if (_imageurlArray.count>5) {

            UIImageView *fView = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width * 5, 0, self.bounds.size.width, self.bounds.size.height)];
            fView.image = [self getMyImageWithImageName:[_imageurlArray objectAtIndex:5]];
            [self.narScrollView addSubview:fView];
        }
    }
}

-(UIImage*)getMyImageWithImageName:(NSString*)imageName{

    NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *image_path = [DocumentsPath stringByAppendingString:imageName];
    NSData *imageData = [NSData dataWithContentsOfFile:image_path];
    UIImage *myimage = [UIImage imageWithData:imageData];
    return myimage;
}

-(void)configureData:(NSDictionary*)dic
{
    NSArray * adinfoListArray = [dic objectForKey:@"adinfoList"];

    for (int i =0; i<adinfoListArray.count; i++) {

        NSDictionary *imageDictionary = [adinfoListArray objectAtIndex:i];

        if ([imageDictionary objectForKeySafe:@"imageurl"]!=nil) {
            NSString *imageurl = [imageDictionary objectForKeySafe:@"imageurl"];
            NSString *adid = [imageDictionary objectForKeySafe:@"adid"];
            NSString *adurl = [imageDictionary objectForKeySafe:@"adurl"];
            [_adidArray addObject:adid];
            [_imageurlArray addObject:imageurl];
            if (adurl!=nil) {
                [_adurlArray addObject:adurl];
            }
        }
    }

}
@end
