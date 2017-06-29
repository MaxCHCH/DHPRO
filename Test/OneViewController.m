//
//  OneViewController.m
//  NavBar
//
//  Created by MissWan on 2016/10/19.
//  Copyright © 2016年  wangyu. All rights reserved.
//

#import "OneViewController.h"

@interface OneViewController ()
{
	UIImageView *imgView;

}
@end

@implementation OneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = IWColor(255,155,0);
    //设置导航条的背景色
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]}];
	[self setUPUI];
	[self registerTakeScreenShotNotice];

    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    // Do any additional setup after loading the view.
}
- (void)setUPUI{
	
}
- (void)registerTakeScreenShotNotice
{
	__weak typeof(self) weakSelf = self;
	//	NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
	[[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationUserDidTakeScreenshotNotification
													  object:nil
													   queue:nil
												  usingBlock:^(NSNotification *note) {
													  // executes after screenshot
													  NSLog(@"截屏咯");
													  [weakSelf userDidTakeScreenshot];
												  }];
}
//截屏响应
- (void)userDidTakeScreenshot
{
	NSLog(@"检测到截屏");
	
	//人为截屏, 模拟用户截屏行为, 获取所截图片
	UIImage *image = [OneViewController imageWithScreenshot];
	imgView.hidden = NO;
	[imgView setImage:image];
	NSLog(@"image %@",image);
}
/**
 *  返回截取到的图片
 *
 *  @return UIImage *
 */
+ (UIImage *)imageWithScreenshot
{
	NSData *imageData = [OneViewController dataWithScreenshotInPNGFormat];
	return [UIImage imageWithData:imageData];
}

/**
 *  截取当前屏幕
 *
 *  @return NSData *
 */
+ (NSData *)dataWithScreenshotInPNGFormat
{
	CGSize imageSize = CGSizeZero;
	UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
	if (UIInterfaceOrientationIsPortrait(orientation))
		imageSize = [UIScreen mainScreen].bounds.size;
	else
		imageSize = CGSizeMake([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
	
	UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
	CGContextRef context = UIGraphicsGetCurrentContext();
	for (UIWindow *window in [[UIApplication sharedApplication] windows])
	{
		CGContextSaveGState(context);
		CGContextTranslateCTM(context, window.center.x, window.center.y);
		CGContextConcatCTM(context, window.transform);
		CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x, -window.bounds.size.height * window.layer.anchorPoint.y);
		if (orientation == UIInterfaceOrientationLandscapeLeft)
		{
			CGContextRotateCTM(context, M_PI_2);
			CGContextTranslateCTM(context, 0, -imageSize.width);
		}
		else if (orientation == UIInterfaceOrientationLandscapeRight)
		{
			CGContextRotateCTM(context, -M_PI_2);
			CGContextTranslateCTM(context, -imageSize.height, 0);
		} else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
			CGContextRotateCTM(context, M_PI);
			CGContextTranslateCTM(context, -imageSize.width, -imageSize.height);
		}
		if ([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)])
		{
			[window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
		}
		else
		{
			[window.layer renderInContext:context];
		}
		CGContextRestoreGState(context);
	}
	
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return UIImagePNGRepresentation(image);
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
