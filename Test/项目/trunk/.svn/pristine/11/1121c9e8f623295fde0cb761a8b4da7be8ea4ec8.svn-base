//
//  GameDetail_ViewController.m
//  zhidoushi
//
//  Created by xinglei on 14/12/15.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import "ImageCropper.h"
//#import "EGOImageView.h"

@implementation ImageCropper

@synthesize cropperScrollView, imageView;
@synthesize cropperImageDelegate;

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];

    [self.leftButton setBackgroundImage:[UIImage imageNamed:@"后退箭头-32-32"] forState:UIControlStateNormal];
    [self.leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.leftButton.titleLabel.font = MyFont(13);
    [self.leftButton addTarget:self action:@selector(popButton) forControlEvents:UIControlEventTouchUpInside];
    CGRect labelRect = self.leftButton.frame;
    labelRect.size.width = 16;
    labelRect.size.height = 16;
    self.leftButton.frame = labelRect;

    
}

- (id)initWithImage:(UIImage *)image imageString:(NSString*)imageString{
	self = [super init];
	
	if (self) {

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(popButton)];
        [self.view addGestureRecognizer:tap];

        self.view.backgroundColor = [UIColor blackColor];
        
//		[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];

		cropperScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(50.0, 10.0, 280.0, 300.0)];
		[cropperScrollView setBackgroundColor:[UIColor blackColor]];
		[cropperScrollView setDelegate:self];
        //		[scrollView setShowsHorizontalScrollIndicator:NO];
        //		[scrollView setShowsVerticalScrollIndicator:NO];
        
        
        //        [imageView removeFromSuperview];
        
        imageView = [[UIImageView alloc] initWithImage:image];
        
		CGRect rect;
		rect.size.width = image.size.width;
		rect.size.height = image.size.height;
		
		[imageView setFrame:rect];
        cropperScrollView.bouncesZoom = NO;//不允许弹跳
		[cropperScrollView setMaximumZoomScale:(1/imageView.frame.size.height)*560];
		[cropperScrollView setContentSize:[imageView frame].size];
		[cropperScrollView setMinimumZoomScale:[cropperScrollView frame].size.width/[imageView frame].size.width];
        if (imageView.frame.size.height!=0) {
            [cropperScrollView setZoomScale:[cropperScrollView minimumZoomScale]];//防止崩
        }
		[cropperScrollView addSubview:imageView];
        
		cropperScrollView.frame = CGRectMake(0, 44, kVIEW_BOUNDS_WIDTH, kVIEW_BOUNDS_HEIGHT-44);

        imageView.center = CGPointMake(kVIEW_BOUNDS_WIDTH/2, (kVIEW_BOUNDS_HEIGHT-44)/2);
		[[self view] addSubview:cropperScrollView];
		
//		UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 44.0)];
//		[navigationBar setBarStyle:UIBarStyleBlack];
//		[navigationBar setTranslucent:YES];
//		
//		UINavigationItem *aNavigationItem = [[UINavigationItem alloc] initWithTitle:@""];
//        
//        [aNavigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelCropping)]];
        //		[aNavigationItem setRightBarButtonItem:[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(finishCropping)] autorelease]];
        
//		[navigationBar setItems:[NSArray arrayWithObject:aNavigationItem]];

//		[aNavigationItem release];

//		[[self view] addSubview:navigationBar];

//		[navigationBar release];
	}
	
	return self;
}

-(void)popButton
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//- (void)cancelCropping {
//	[cropperImageDelegate imageCropperDidCancel:self];

//}

//- (void)finishCropping {
//		
//	[delegate imageCropper:self didFinishCroppingWithImage:cropped];
//}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
	return imageView;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;//隐藏为YES，显示为NO
}

- (void)dealloc {
//	[imageView release];
//	[cropperScrollView release];
//	
//    [super dealloc];
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?(scrollView.bounds.size.width - scrollView.contentSize.width)/2 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?(scrollView.bounds.size.height - scrollView.contentSize.height)/2 : 0.0;
    imageView.center = CGPointMake(scrollView.contentSize.width/2 + offsetX,scrollView.contentSize.height/2 + offsetY);

}

@end