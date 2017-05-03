//
//  TestChooseViewController.m
//  Test
//
//  Created by Rillakkuma on 2016/10/20.
//  Copyright © 2016年 Rillakkuma. All rights reserved.
//

#import "TestChooseViewController.h"
#import "TabTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "UIActivityIndicatorView+AFNetworking.h"
#import "UIProgressView+AFNetworking.h"
#import "CeModel.h"
@interface TestChooseViewController ()<UITextFieldDelegate>{
    UIImageView *u;
    UILabel *progressLabel;
}
@property (nonatomic,strong)UIButton *button;
//+(UIImage*)imageWithImage:(UIImage*)image grayLevelType:(UIImageGrayLevelType)type;
//
////色值 变暗多少 0.0 - 1.0
//+(UIImage*)imageWithImage:(UIImage*)image darkValue:(float)darkValue;

/**
 获取网络图片的Size, 先通过文件头来获取图片大小
 如果失败 会下载完整的图片Data 来计算大小 所以最好别放在主线程
 如果你有使用SDWebImage就会先看下 SDWebImage有缓存过改图片没有
 支持文件头大小的格式 png、gif、jpg   http://www.cocoachina.com/bbs/read.php?tid=165823
 */
+(CGSize)downloadImageSizeWithURL:(id)imageURL;
@end

@implementation TestChooseViewController

//讨厌警告
-(id)diskImageDataBySearchingAllPathsForKey:(id)key{return nil;}
+(CGSize)downloadImageSizeWithURL:(id)imageURL
{
	NSURL* URL = nil;
	if([imageURL isKindOfClass:[NSURL class]]){
		URL = imageURL;
	}
	if([imageURL isKindOfClass:[NSString class]]){
		URL = [NSURL URLWithString:imageURL];
	}
	if(URL == nil)
		return CGSizeZero;
	
	NSString* absoluteString = URL.absoluteString;
	
#ifdef dispatch_main_sync_safe
	if([[SDImageCache sharedImageCache] diskImageExistsWithKey:absoluteString])
	{
		UIImage* image = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:absoluteString];
		if(!image)
		{
			NSData* data = [[SDImageCache sharedImageCache] performSelector:@selector(diskImageDataBySearchingAllPathsForKey:) withObject:URL.absoluteString];
			image = [UIImage imageWithData:data];
		}
		if(image)
		{
			return image.size;
		}
	}
#endif
	
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL];
	NSString* pathExtendsion = [URL.pathExtension lowercaseString];
	
	CGSize size = CGSizeZero;
	if([pathExtendsion isEqualToString:@"png"]){
		size =  [self downloadPNGImageSizeWithRequest:request];
	}
	else if([pathExtendsion isEqual:@"gif"])
	{
		size =  [self downloadGIFImageSizeWithRequest:request];
	}
	else{
		size = [self downloadJPGImageSizeWithRequest:request];
	}
	if(CGSizeEqualToSize(CGSizeZero, size))
	{
		NSData* data = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:URL] returningResponse:nil error:nil];
		UIImage* image = [UIImage imageWithData:data];
		if(image)
		{
#ifdef dispatch_main_sync_safe
			[[SDImageCache sharedImageCache] storeImage:image recalculateFromImage:YES imageData:data forKey:URL.absoluteString toDisk:YES];
#endif
			size = image.size;
		}
	}
	return size;
}
+(CGSize)downloadPNGImageSizeWithRequest:(NSMutableURLRequest*)request
{
	[request setValue:@"bytes=16-23" forHTTPHeaderField:@"Range"];
	NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	if(data.length == 8)
	{
		int w1 = 0, w2 = 0, w3 = 0, w4 = 0;
		[data getBytes:&w1 range:NSMakeRange(0, 1)];
		[data getBytes:&w2 range:NSMakeRange(1, 1)];
		[data getBytes:&w3 range:NSMakeRange(2, 1)];
		[data getBytes:&w4 range:NSMakeRange(3, 1)];
		int w = (w1 << 24) + (w2 << 16) + (w3 << 8) + w4;
		int h1 = 0, h2 = 0, h3 = 0, h4 = 0;
		[data getBytes:&h1 range:NSMakeRange(4, 1)];
		[data getBytes:&h2 range:NSMakeRange(5, 1)];
		[data getBytes:&h3 range:NSMakeRange(6, 1)];
		[data getBytes:&h4 range:NSMakeRange(7, 1)];
		int h = (h1 << 24) + (h2 << 16) + (h3 << 8) + h4;
		return CGSizeMake(w, h);
	}
	return CGSizeZero;
}
+(CGSize)downloadGIFImageSizeWithRequest:(NSMutableURLRequest*)request
{
	[request setValue:@"bytes=6-9" forHTTPHeaderField:@"Range"];
	NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	if(data.length == 4)
	{
		short w1 = 0, w2 = 0;
		[data getBytes:&w1 range:NSMakeRange(0, 1)];
		[data getBytes:&w2 range:NSMakeRange(1, 1)];
		short w = w1 + (w2 << 8);
		short h1 = 0, h2 = 0;
		[data getBytes:&h1 range:NSMakeRange(2, 1)];
		[data getBytes:&h2 range:NSMakeRange(3, 1)];
		short h = h1 + (h2 << 8);
		return CGSizeMake(w, h);
	}
	return CGSizeZero;
}
+(CGSize)downloadJPGImageSizeWithRequest:(NSMutableURLRequest*)request
{
	[request setValue:@"bytes=0-209" forHTTPHeaderField:@"Range"];
	NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	
	if ([data length] <= 0x58) {
		return CGSizeZero;
	}
	
	if ([data length] < 210) {// 肯定只有一个DQT字段
		short w1 = 0, w2 = 0;
		[data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
		[data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
		short w = (w1 << 8) + w2;
		short h1 = 0, h2 = 0;
		[data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
		[data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
		short h = (h1 << 8) + h2;
		return CGSizeMake(w, h);
	} else {
		short word = 0x0;
		[data getBytes:&word range:NSMakeRange(0x15, 0x1)];
		if (word == 0xdb) {
			[data getBytes:&word range:NSMakeRange(0x5a, 0x1)];
			if (word == 0xdb) {// 两个DQT字段
				short w1 = 0, w2 = 0;
				[data getBytes:&w1 range:NSMakeRange(0xa5, 0x1)];
				[data getBytes:&w2 range:NSMakeRange(0xa6, 0x1)];
				short w = (w1 << 8) + w2;
				short h1 = 0, h2 = 0;
				[data getBytes:&h1 range:NSMakeRange(0xa3, 0x1)];
				[data getBytes:&h2 range:NSMakeRange(0xa4, 0x1)];
				short h = (h1 << 8) + h2;
				return CGSizeMake(w, h);
			} else {// 一个DQT字段
				short w1 = 0, w2 = 0;
				[data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
				[data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
				short w = (w1 << 8) + w2;
				short h1 = 0, h2 = 0;
				[data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
				[data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
				short h = (h1 << 8) + h2;
				return CGSizeMake(w, h);
			}
		} else {
			return CGSizeZero;
		}
	}
}
+(CGSize)getImageSizeWithURL:(id)imageURL
{
	NSURL* URL = nil;
	if([imageURL isKindOfClass:[NSURL class]]){
		URL = imageURL;
	}
	if([imageURL isKindOfClass:[NSString class]]){
		URL = [NSURL URLWithString:imageURL];
	}
	if(URL == nil)
		return CGSizeZero;                  // url不正确返回CGSizeZero
	
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL];
	NSString* pathExtendsion = [URL.pathExtension lowercaseString];
	
	CGSize size = CGSizeZero;
	if([pathExtendsion isEqualToString:@"png"]){
		size =  [self getPNGImageSizeWithRequest:request];
	}
	else if([pathExtendsion isEqual:@"gif"])
	{
		size =  [self getGIFImageSizeWithRequest:request];
	}
	else{
		size = [self getJPGImageSizeWithRequest:request];
	}
	if(CGSizeEqualToSize(CGSizeZero, size))                    // 如果获取文件头信息失败,发送异步请求请求原图
	{
		NSData* data = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:URL] returningResponse:nil error:nil];
		UIImage* image = [UIImage imageWithData:data];
		if(image)
		{
			size = image.size;
		}
	}
	return size;
}
//  获取PNG图片的大小
+(CGSize)getPNGImageSizeWithRequest:(NSMutableURLRequest*)request
{
	[request setValue:@"bytes=16-23" forHTTPHeaderField:@"Range"];
	NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	if(data.length == 8)
	{
		int w1 = 0, w2 = 0, w3 = 0, w4 = 0;
		[data getBytes:&w1 range:NSMakeRange(0, 1)];
		[data getBytes:&w2 range:NSMakeRange(1, 1)];
		[data getBytes:&w3 range:NSMakeRange(2, 1)];
		[data getBytes:&w4 range:NSMakeRange(3, 1)];
		int w = (w1 << 24) + (w2 << 16) + (w3 << 8) + w4;
		int h1 = 0, h2 = 0, h3 = 0, h4 = 0;
		[data getBytes:&h1 range:NSMakeRange(4, 1)];
		[data getBytes:&h2 range:NSMakeRange(5, 1)];
		[data getBytes:&h3 range:NSMakeRange(6, 1)];
		[data getBytes:&h4 range:NSMakeRange(7, 1)];
		int h = (h1 << 24) + (h2 << 16) + (h3 << 8) + h4;
		return CGSizeMake(w, h);
	}
	return CGSizeZero;
}
//  获取gif图片的大小
+(CGSize)getGIFImageSizeWithRequest:(NSMutableURLRequest*)request
{
	[request setValue:@"bytes=6-9" forHTTPHeaderField:@"Range"];
	NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	if(data.length == 4)
	{
		short w1 = 0, w2 = 0;
		[data getBytes:&w1 range:NSMakeRange(0, 1)];
		[data getBytes:&w2 range:NSMakeRange(1, 1)];
		short w = w1 + (w2 << 8);
		short h1 = 0, h2 = 0;
		[data getBytes:&h1 range:NSMakeRange(2, 1)];
		[data getBytes:&h2 range:NSMakeRange(3, 1)];
		short h = h1 + (h2 << 8);
		return CGSizeMake(w, h);
	}
	return CGSizeZero;
}
//  获取jpg图片的大小
+(CGSize)getJPGImageSizeWithRequest:(NSMutableURLRequest*)request
{
	[request setValue:@"bytes=0-209" forHTTPHeaderField:@"Range"];
	NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	
	if ([data length] <= 0x58) {
		return CGSizeZero;
	}
	
	if ([data length] < 210) {// 肯定只有一个DQT字段
		short w1 = 0, w2 = 0;
		[data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
		[data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
		short w = (w1 << 8) + w2;
		short h1 = 0, h2 = 0;
		[data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
		[data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
		short h = (h1 << 8) + h2;
		return CGSizeMake(w, h);
	} else {
		short word = 0x0;
		[data getBytes:&word range:NSMakeRange(0x15, 0x1)];
		if (word == 0xdb) {
			[data getBytes:&word range:NSMakeRange(0x5a, 0x1)];
			if (word == 0xdb) {// 两个DQT字段
				short w1 = 0, w2 = 0;
				[data getBytes:&w1 range:NSMakeRange(0xa5, 0x1)];
				[data getBytes:&w2 range:NSMakeRange(0xa6, 0x1)];
				short w = (w1 << 8) + w2;
				short h1 = 0, h2 = 0;
				[data getBytes:&h1 range:NSMakeRange(0xa3, 0x1)];
				[data getBytes:&h2 range:NSMakeRange(0xa4, 0x1)];
				short h = (h1 << 8) + h2;
				return CGSizeMake(w, h);
			} else {// 一个DQT字段
				short w1 = 0, w2 = 0;
				[data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
				[data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
				short w = (w1 << 8) + w2;
				short h1 = 0, h2 = 0;
				[data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
				[data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
				short h = (h1 << 8) + h2;
				return CGSizeMake(w, h);
			}
		} else {
			return CGSizeZero;
		}
	}
}

- (UIButton *)button{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    button.backgroundColor = [UIColor grayColor];;       //背景颜色
    [self.view addSubview:button];
    return button;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
	
	
    progressLabel = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height-50, 30, 30)];
    progressLabel.backgroundColor = [UIColor lightGrayColor];       //背景颜色
    progressLabel.textColor = [UIColor redColor];             //字体颜色 默认为RGB 0,0,0
    progressLabel.numberOfLines = 0;                            //行数 0为无限 默认为1
    progressLabel.textAlignment = NSTextAlignmentLeft;        //对齐方式 默认为左对齐
    progressLabel.font = [UIFont systemFontOfSize:12];          //设置字体及字体大小
    progressLabel.text = @"测";                            //设置显示内容
    [self.view addSubview:progressLabel];
    
	
	
	[self getDict];
	
    
    _button = [self button];
    [_button setTitle:@"设置" forState:(UIControlStateNormal)];
    _button.frame = CGRectMake(10, 64+23, 60, 30);
    [_button addTarget:self action:@selector(settingMethod:) forControlEvents:(UIControlEventTouchUpInside)];
    
    _button = [self button];
    [_button setTitle:@"请求" forState:(UIControlStateNormal)];
    _button.frame = CGRectMake(10+70, 64+23, 60, 30);
    [_button addTarget:self action:@selector(postURLMethod) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    u = [[UIImageView alloc]init];
    u.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2, 150, 100, 100);
    [self.view addSubview:u];
	
	
	
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 120, DeviceWidth, 30)];
	label.text = @"两块钱,你买不了吃亏,两块钱,你买不了上当,真正的物有所值,拿啥啥便宜,买啥啥不贵,都两块,买啥都两块,全场卖两块,随便挑,随便选,都两块！";
//	label.backgroundColor = [UIColor redColor];
	label.layer.borderColor = [UIColor redColor].CGColor;
	label.layer.borderWidth = 0.3;
	label.textColor = [UIColor blackColor];
	
	[label sizeToFit];
	CGRect frame = label.frame;
	frame.origin.x = 320;
	label.frame = frame;
	
	[UIView beginAnimations:@"testAnimation" context:NULL];
	[UIView setAnimationDuration:12.0f];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationRepeatAutoreverses:NO];
	[UIView setAnimationRepeatCount:999999];
	
	frame = label.frame;
	frame.origin.x = -frame.size.width;
	label.frame = frame;
	[UIView commitAnimations];
	[self.view addSubview:label];

    // Do any additional setup after loading the view.
}
//https://www.homesoft.cn/WebInterface/HBInterface.ashx
//http://192.168.0.108/estateweb910/webservice/jsonInterface.ashx?json=UserLogin&UserName=admin&Pwd=pwd

#define API @"https://www.homesoft.cn/WebInterface/HBInterface.ashx"

#define Main @"http://kaifa.homesoft.cn"

#define HTTPSETT     AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];


static float progressValue = 0.0f;
- (void)increateProgress
{
	progressValue += 0.1;
	[SVProgressHUD showProgress:progressValue status:@"加载中"];
	if (progressValue < 1) {
		[self performSelector:@selector(increateProgress) withObject:nil afterDelay:0.3];
	}else{
		[self performSelector:@selector(dismiss:) withObject:nil afterDelay:0.4];
	}
	
}


- (void)dismiss:(id)sender{
	 [SVProgressHUD dismiss];
}
- (void)postURLMethod{
//	[SVProgressHUD showSuccessWithStatus:@"success"];
//	[self performSelector:@selector(dismiss:) withObject:nil afterDelay:3];
	
	
	
	[SVProgressHUD show];
//	[SVProgressHUD showWithStatus:@"加载中，请稍后。。。"];
	[SVProgressHUD showProgress:0 status:@"加载中"];

	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		// time-consuming task
		dispatch_async(dispatch_get_main_queue(), ^{
			
			[self performSelector:@selector(increateProgress) withObject:nil afterDelay:3];
//			[self performSelector:@selector(dismiss:) withObject:nil afterDelay:10];

		});
	});
	
	
	NSString *url = @"BillTypeId=2&EstateID=6&RepairName=admin&RepairAddress=123&ContractTelephone=123&repairtime=2016-12-28 02:39:30&CategorySN=保修&UrgentDegreeId=特急&RepairContent=花生豆腐";
	
//	NSString *value = [NSString stringWithFormat:@"RepairCommit&url=%@",url];

    NSDictionary *parameters = @{@"Url":[NSString stringWithFormat:@"%@/webservice/jsonInterface.ashx",Main],
                                 @"MethodType":@"POST",
								 @"ConnectMethod":@"RepairCommit",
								 @"UrlValue":url
								 };
	
	/*
	 
	 ConnectMethod = RepairCommit;
	 MethodType = POST;
	 Url = "http://kaifa.homesoft.cn/webservice/jsonInterface.ashx";
	 UrlValue = "BillTypeId=2&EstateID=6&RepairName=admin&RepairAddress=123&ContractTelephone=123&repairtime=2016-12-28 02:39:30&CategorySN=\U4fdd\U4fee&UrgentDegreeId=\U7279\U6025&RepairContent=\U82b1\U751f\U8c46\U8150";
	 */
	
	/*
	
	 ConnectMethod = RepairCommit;
	 MethodType = POST;
	 Url = "http:///webservice/jsonInterface.ashx";
	 UrlValue = "BillTypeId=2&EstateID=6&RepairName=admin&RepairAddress=123&ContractTelephone=123&repairtime=2016-12-28 02:39:30&CategorySN=\U4fdd\U4fee&UrgentDegreeId=\U7279\U6025&RepairContent=\U82b1\U751f\U8c46\U8150";
	 */
	UIImage *image = [UIImage imageNamed:@"purchase"];
	UIImage *image2 = [UIImage imageNamed:@"purchase"];

	NSArray *imageArray = @[image,image2];
	int 打仗 = 1;
	打仗 += 2;
	
	printf(" %i",打仗);
	NSDictionary*YUDICT = @{@"ext1":@"",@"ext2":@"",@"mernum":@"898110289993770",@"orderId":@"228",@"reqTime":@"20161011153236",@"sign":@"c4fe1149bafec7052cdeacf1b73eaea6",@"termid":@"77000598"}
							;
	
	NSString *URLS  = @"http://kaifa.homesoft.cn/WebService/Handler1.ashx?json=SearchOrder";
	[self POSTHttpWithURL:URLS params:YUDICT completionBlock:^(NSMutableDictionary *dict, BOOL isOK, NSString *errInfo) {
		NSLog(@"dict %@",dict);
		NSLog(@"errInfo %@",errInfo);
	}];
	
	[self POSTHttpWithURL:API imagesArray:imageArray params:parameters compressionRatio:0.5 completionBlock:^(NSMutableDictionary *dict, BOOL isOK, NSString *errInfo) {
		NSLog(@"%@---dict",dict);
	} uploadProgressBlock:^(long uploadProgress) {
		NSLog(@"uploadProgress -- %.2ld",uploadProgress);;
	}];
	
	
	[self POSTImageWithParamsUrl:url valueStr:@"RepairCommit" compressionRatio:0.5 tableNameStr:nil PkidStr:nil imageArray:imageArray completionBlock:^(NSMutableDictionary *dict, NSString *errInfo, BOOL isOK) {
				NSLog(@"%@---dict",dict);

	} uploadProgressBlock:^(long uploadProgress) {
				NSLog(@"uploadProgress -- %.2ld",uploadProgress);;

	}];
	NSString *urls = @"EmpID=2";
	NSDictionary *parame = @{@"Url":[NSString stringWithFormat:@"%@/webservice/jsonInterface.ashx",Main],
								 @"MethodType":@"POST",
								 @"ConnectMethod":@"EmpPictureUp",
								 @"UrlValue":urls
								 };
	[self POSTHttpWithURL:API imagesArray:imageArray params:parame compressionRatio:0.5 completionBlock:^(NSMutableDictionary *dict, BOOL isOK, NSString *errInfo) {
		NSLog(@"%@---dict",dict);
	} uploadProgressBlock:^(long uploadProgress) {
		NSLog(@"uploadProgress -- %.2ld",uploadProgress);;
	}];
	
	
	[self GetHttpWithURL:@"http://kaifa.homesoft.cn/WebService/jsonInterface.ashx?json=GetEquipRunByRecordID" params:@{@"RecordID":@"4305"} completionBlock:^(NSMutableDictionary *dict, BOOL isOK) {
		NSLog(@"%@---dict",dict);

	}];
	
	
	
}
- (void)getDict{
//	NSString *urlll =[NSString stringWithFormat:@"%@&DTypeID=PJM004",API_BASE_URL(@"GetDictionaryByID")];
//	
//	urlll = [urlll stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
	
	NSString * urlll = @"http://www.haoyebao.com/api/index.php?act=store_original&op=goods_class&store_id=3";
	AFJSONResponseSerializer * response = [AFJSONResponseSerializer serializer];
	response.removesKeysWithNullValues = YES;

	AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
	[manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

	manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
	[manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"text/plain",@"application/json",@"text/json",@"text/javascript",@"text/html", nil]];

	[manager GET:urlll parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
		
	} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
		NSLog(@"GetDictionaryByID %@",responseObject[@"data"]);
		NSArray *dataArray = [CeModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
		NSLog(@"%@",dataArray);
		[dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
			CeModel *m = dataArray[idx];
			NSArray *arr = m.child_list;
			NSLog(@"arr %@",arr);
//			[arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//				CrModel *r = arr[idx];
//				
//				NSLog(@"%@",r.gc_dyname);
//			}];
		}];
		
		/*
		 {
		 EquipmentSe =     (
		 {
		 EquipCode = 010201;
		 EquipName = "\U5ba4\U5916\U7167\U660e\U914d\U7535\U7bb1";
		 PeriodNum = 4;
		 PeriodUnit = "\U6708";
		 Programme = "\U66f4\U6362\U7834\U635f\U5143\U4ef6\Uff0c\U4fdd\U8bc1\U6b63\U5e38\U7167\U660e";
		 }
		 );
		 count = 1;
		 result = True;
		 }
		 */
		//		arrayID = [GetDictionaryByID mj_objectArrayWithKeyValuesArray:responseObject[@"Dictionary"]];
		
	} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
		NSLog(@"error %@",error);
	}];
}




//上传带有图片的POST请求

- (void)POSTImageWithParamsUrl:(NSString *)url valueStr:(NSString *)value compressionRatio:(float)ratio tableNameStr:(NSString *)tableName PkidStr:(NSString *)pkid imageArray:(NSArray *)images completionBlock:(void(^)(NSMutableDictionary *dict,NSString *errInfo,BOOL isOK))block uploadProgressBlock:(void (^)(long uploadProgress))uploadProgressBlock{
	
	NSDictionary *parameters;
	if (tableName) {
		parameters = @{@"Url":[NSString stringWithFormat:@"%@/webservice/jsonInterface.ashx",Main],
									 @"MethodType":@"POST",
									 @"TableName":tableName,
									 @"ConnectMethod":value,
									 @"UrlValue":url
									 };
	}
	if (pkid) {
		parameters = @{@"Url":[NSString stringWithFormat:@"%@/webservice/jsonInterface.ashx",Main],
									 @"MethodType":@"POST",
									 @"TableName":tableName,
									 @"ConnectMethod":value,
									 @"UrlValue":url,
									 @"Pkid":pkid
									 };
	}
	else{
		parameters = @{@"Url":[NSString stringWithFormat:@"%@/webservice/jsonInterface.ashx",Main],
									 @"MethodType":@"POST",
									 @"ConnectMethod":value,
									 @"UrlValue":url
									 };
	}
	NSLog(@"parameters %@",parameters);
	if (images.count == 0) {
		NSLog(@"上传内容没有包含图片");
		return;
	}
	NSLog(@"images--%@",images);
	for (int i = 0; i < images.count; i++) {
		if (![images[i] isKindOfClass:[UIImage class]]) {
			NSLog(@"images中第%d个元素不是UIImage对象",i+1);
			CGSize size = [UIImage imageNamed:images[i]].size;
			NSLog(@"si--%f",size.width);
			
			return;
		}
		
	}
	for (int i = 0; i<images.count; i++) {
		NSLog(@"---%@",[images objectAtIndex:i]);
		
	}
	
	
	HTTPSETT
	[manager POST:API parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
		
		int i = 0;
		//根据当前系统时间生成图片名称
		NSDate *date = [NSDate date];
		NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
		[formatter setDateFormat:@"yyyy年MM月dd日"];
		NSString *dateString = [formatter stringFromDate:date];
		
		for (UIImage *image in images) {
			NSString *fileName = [NSString stringWithFormat:@"%@%d.png",dateString,i];
			NSData *imageData;
			if (ratio > 0.0f && ratio < 1.0f) {
				imageData = UIImageJPEGRepresentation(image, ratio);
			}else{
				imageData = UIImageJPEGRepresentation(image, 1.0f);
			}
			
			[formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/jpg/png/jpeg"];
		}
		
		
	} progress:^(NSProgress * _Nonnull uploadProgress) {
		NSLog(@"update %.2f",uploadProgress.fractionCompleted);
		
		uploadProgressBlock(uploadProgress.fractionCompleted);
		
	} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
		NSLog(@"successful,JSON: %@",responseObject);
		block(responseObject,nil,YES);

	} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
		NSLog(@"failure,JSON: %@",error);
		NSLog(@"网址 %@",task.response.URL);
		
		block(nil,error.localizedDescription,NO);
		
	}];
	
	
}

- (void)POSTHttpWithURL:(NSString *)url imagesArray:(NSArray *)images params:(NSDictionary *)params compressionRatio:(float)ratio completionBlock:(void(^)(NSMutableDictionary *dict,BOOL isOK,NSString *errInfo))block uploadProgressBlock:(void (^)(long uploadProgress))uploadProgressBlock
{
	
//	if (images.count == 0) {
//		NSLog(@"上传内容没有包含图片");
//		return;
//	}
//	NSLog(@"images--%@",images);
//	for (int i = 0; i < images.count; i++) {
//		if (![images[i] isKindOfClass:[UIImage class]]) {
//			NSLog(@"images中第%d个元素不是UIImage对象",i+1);
//			CGSize size = [UIImage imageNamed:images[i]].size;
//			NSLog(@"si--%f",size.width);
//			
//			return;
//		}
//		
//	}
//	for (int i = 0; i<images.count; i++) {
//		NSLog(@"---%@",[images objectAtIndex:i]);
//		
//	}
//	
	
	HTTPSETT
	[manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
		if (images!=nil) {

			int i = 0;
			//根据当前系统时间生成图片名称
			NSDate *date = [NSDate date];
			NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
			[formatter setDateFormat:@"yyyy年MM月dd日"];
			NSString *dateString = [formatter stringFromDate:date];
			
			for (UIImage *image in images) {
				NSString *fileName = [NSString stringWithFormat:@"%@%d.png",dateString,i];
				NSData *imageData;
				if (ratio > 0.0f && ratio < 1.0f) {
					imageData = UIImageJPEGRepresentation(image, ratio);
				}else{
					imageData = UIImageJPEGRepresentation(image, 1.0f);
				}
				
				[formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/jpg/png/jpeg"];
			}
		
		}
	} progress:^(NSProgress * _Nonnull uploadProgress) {
		NSLog(@"update %.2f",uploadProgress.fractionCompleted);
		
		uploadProgressBlock(uploadProgress.fractionCompleted);
		
	} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
		NSLog(@"successful,JSON: %@",responseObject);
		//		NSString *html = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
		block(responseObject,NO,task.response.URL);
		
		//        NSMutableDictionary *dict = responseObject;
		//        block(dict,NO);
	} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
		NSLog(@"failure,JSON: %@",error);
		NSLog(@"网址 %@",task.response.URL);
		
		block(nil,YES,task.response.URL);
		
	}];
}




- (void)POSTHttpWithURL:(NSString *)url params:(NSDictionary *)params completionBlock:(void(^)(NSMutableDictionary *dict,BOOL isOK,NSString *errInfo))block{
	HTTPSETT
	AFJSONResponseSerializer*response = [AFJSONResponseSerializer serializer];
	response.removesKeysWithNullValues=YES;
	manager.responseSerializer= response;
	manager.requestSerializer= [AFJSONRequestSerializer serializer];
	[manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
		
		NSInteger imgCount = 0;
		for (int i = 0; i<2; i++) {

			NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
			formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss:SSS";
			NSString *fileName = [NSString stringWithFormat:@"%@%@.png",[formatter stringFromDate:[NSDate date]],@(imgCount)];
			NSLog(@"我的图片：%@",fileName);
			[formData appendPartWithFileData:UIImagePNGRepresentation([UIImage imageNamed:@"purchase"]) name:@"file" fileName:fileName mimeType:@"image/png"];
			imgCount++;
		}

	} progress:^(NSProgress * _Nonnull uploadProgress) {
		NSLog(@"update %.2f",uploadProgress.fractionCompleted);
	} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
		NSLog(@"successful,JSON: %@",responseObject);
		//		NSString *html = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
		block(responseObject,NO,nil);
		
		//        NSMutableDictionary *dict = responseObject;
		//        block(dict,NO);
	} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
		NSLog(@"failure,JSON: %@",error);
		NSLog(@"网址 %@",task.response.URL);

		block(nil,YES,task.response.URL);
		
	}];
}

- (void)GetHttpWithURL:(NSString *)url params:(NSDictionary *)params completionBlock:(void(^)(NSMutableDictionary *dict,BOOL isOK))block{
	HTTPSETT
	[manager GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
		NSLog(@"down %.2f",downloadProgress.fractionCompleted);
	} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
		//        NSMutableDictionary *dict = responseObject;
		block(responseObject,NO);
	} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
		NSLog(@"failure,JSON: %@",error);
		block(nil,YES);
	}];
}

-(void)startMultiPartUploadTaskWithURL:(NSString *)url
						   imagesArray:(NSArray *)images
					 parameterOfimages:(NSString *)parameter
						parametersDict:(NSDictionary *)parameters
					  compressionRatio:(float)ratio
						  succeedBlock:(void (^)(id, id))succeedBlock
						   failedBlock:(void (^)(id, NSString *r))failedBlock
				   uploadProgressBlock:(void (^)(float, long long, long long))uploadProgressBlock{
	
	if (images.count == 0) {
		NSLog(@"上传内容没有包含图片");
		return;
	}
	for (int i = 0; i < images.count; i++) {
		if (![images isKindOfClass:[UIImage class]]) {
			NSLog(@"images中第%d个元素不是UIImage对象",i+1);
			return;
		}
	}

	
	AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
	[manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
		
		int i = 0;
		//根据当前系统时间生成图片名称
		NSDate *date = [NSDate date];
		NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
		[formatter setDateFormat:@"yyyy年MM月dd日"];
		NSString *dateString = [formatter stringFromDate:date];
		
		for (UIImage *image in images) {
			NSString *fileName = [NSString stringWithFormat:@"%@%d.png",dateString,i];
			NSData *imageData;
			if (ratio > 0.0f && ratio < 1.0f) {
				imageData = UIImageJPEGRepresentation(image, ratio);
			}else{
				imageData = UIImageJPEGRepresentation(image, 1.0f);
			}
			
			[formData appendPartWithFileData:imageData name:parameter fileName:fileName mimeType:@"image/jpg/png/jpeg"];
		}
		
	} progress:^(NSProgress * _Nonnull uploadProgress) {
		
//		[uploadProgressBlock uploadProgressBlockv:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
//			CGFloat percent = totalBytesWritten * 1.0 / totalBytesExpectedToWrite;
//			uploadProgressBlock(percent,totalBytesWritten,totalBytesExpectedToWrite);
//		}];
		
		
	} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
		succeedBlock(task,responseObject);
		NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
		NSLog(@"完成 %@", result);
	} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
		failedBlock(task,error.localizedDescription);
	}];
	
	//
	//    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
	//        CGFloat percent = totalBytesWritten * 1.0 / totalBytesExpectedToWrite;
	//        uploadProgressBlock(percent,totalBytesWritten,totalBytesExpectedToWrite);
	//    }];
}








- (void)textFieldDidEndEditing:(UITextField *)textField{
    [[NSUserDefaults standardUserDefaults] setObject:textField.text forKey:@"url"];
}
- (void)settingMethod:(UIButton *)sender {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    NSString *title = NSLocalizedString(@"设置域名", nil);
    NSString *cancelButtonTitle = NSLocalizedString(@"Cancel", nil);
    NSString *otherButtonTitle = NSLocalizedString(@"OK", nil);
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        // 可以在这里对textfield进行定制，例如改变背景色
        textField.delegate = self;
        textField.text =@"http://";

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTextFieldTextDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:textField];
        
    }];
    
    // Create the actions.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:alertController.textFields.firstObject];
        NSLog(@"The \"Okay/Cancel\" alert's cancel action occured.");
    }];
    
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:alertController.textFields.firstObject];
        NSLog(@"The \"Okay/Cancel\" alert's other action occured.");
    }];
    
    
    // Add the actions.
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}
- (void)handleTextFieldTextDidChangeNotification:(NSNotification *)notification {
    UITextField *textField = notification.object;
    NSLog(@"我输入的文字-%@",textField.text);

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
