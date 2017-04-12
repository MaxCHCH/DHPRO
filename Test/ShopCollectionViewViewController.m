//
//  ShopCollectionViewViewController.m
//  Test
//
//  Created by Rillakkuma on 2017/1/20.
//  Copyright © 2017年 Rillakkuma. All rights reserved.
//

#import "ShopCollectionViewViewController.h"
#import "ShopCustomCollectionViewCell.h"
#import "FSCalendar.h"
#define KeyIdentifier @"ShopCustomCollectionViewCell"
@interface ShopCollectionViewViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,FSCalendarDelegate,FSCalendarDataSource>
{
	UICollectionView *collectionViewS;
	FSCalendar *calendar;
	NSCalendar *gregorian;

}
@end

@implementation ShopCollectionViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	[self setUpUI];
    // Do any additional setup after loading the view.
}
- (void)setUpUI{

	gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];

	UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
	[flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
	
	collectionViewS=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight/2+50) collectionViewLayout:flowLayout];
		collectionViewS.dataSource=self;
	collectionViewS.delegate=self;
	collectionViewS.backgroundColor = [UIColor whiteColor];
	[collectionViewS registerClass:[ShopCustomCollectionViewCell class] forCellWithReuseIdentifier:KeyIdentifier];
	[self.view addSubview:collectionViewS];

	UIView *calendarView = [[UIView alloc]init];
	calendarView.frame = CGRectMake(0, collectionViewS.height, DeviceWidth, DeviceHeight-collectionViewS.height);
	calendarView.backgroundColor = [UIColor groupTableViewBackgroundColor];
	[self.view addSubview:calendarView];
	
	calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(0, 0, calendarView.width, calendarView.height)];
	calendar.dataSource = self;
	calendar.delegate = self;
	calendar.appearance.headerMinimumDissolvedAlpha = 0;
	calendar.appearance.weekdayTextColor = [UIColor grayColor];
	calendar.appearance.todayColor = [UIColor redColor];
	calendar.appearance.selectionColor = [UIColor purpleColor];
	calendar.appearance.caseOptions = FSCalendarCaseOptionsHeaderUsesUpperCase;
	[calendarView addSubview:calendar];

	UIButton *buttonName = [UIButton buttonWithType:UIButtonTypeCustom];
	[buttonName setFrame:CGRectMake(0, 0, 55, 50)];
	buttonName.layer.borderColor = [UIColor redColor].CGColor;
	buttonName.layer.borderWidth = 0.3;
	[buttonName setTitle:@"<" forState:(UIControlStateNormal)];
	[buttonName setTitleEdgeInsets:UIEdgeInsetsMake(4,17,5,19)];
	[buttonName addTarget:self action:@selector(previousClicked:) forControlEvents:(UIControlEventTouchUpInside)];
	[calendarView addSubview:buttonName];
	
	UIButton *buttonRight = [UIButton buttonWithType:UIButtonTypeCustom];
	[buttonRight setFrame:CGRectMake(calendarView.width-55, 0, 55, 50)];
	buttonRight.layer.borderColor = [UIColor redColor].CGColor;
	buttonRight.layer.borderWidth = 0.3;
	[buttonRight setTitle:@">" forState:(UIControlStateNormal)];
	[buttonRight setTitleEdgeInsets:UIEdgeInsetsMake(4,17,5,19)];
	[buttonRight addTarget:self action:@selector(nextClicked:) forControlEvents:(UIControlEventTouchUpInside)];
	[calendarView addSubview:buttonRight];
	
}
- (void)previousClicked:(UIButton *)sender
{
	NSDate *currentMonth = calendar.currentPage;
	NSDate *previousMonth = [gregorian dateByAddingUnit:NSCalendarUnitMonth value:-1 toDate:currentMonth options:0];
	[calendar setCurrentPage:previousMonth animated:YES];
}
- (void)nextClicked:(id)sender
{
	NSDate *currentMonth = calendar.currentPage;
	NSDate *nextMonth = [gregorian dateByAddingUnit:NSCalendarUnitMonth value:1 toDate:currentMonth options:0];
	[calendar setCurrentPage:nextMonth animated:YES];
}
- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition{
	NSLog(@"date %@",date);
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm"];
		NSString *dateString = [dateFormatter stringFromDate:date];
		NSLog(@"dateString:%@",dateString);
}
#pragma mark -- UICollectionViewDataSource

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return 9;
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
	return 1;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString * CellIdentifier = @"ShopCustomCollectionViewCell";
	ShopCustomCollectionViewCell *_cell = [collectionViewS dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
	_cell.iconImageView.image = [UIImage imageNamed:@"message"];
	_cell.nameLabel.text = [NSString stringWithFormat:@"商品为%ld",(long)indexPath.row];
	return _cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
	CGSize size;

	size=CGSizeMake(CGRectGetWidth(collectionViewS.bounds)/3.0-10, CGRectGetWidth(collectionViewS.bounds)/3.0-10);

	return size;
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
	return UIEdgeInsetsMake(5, 5, 5, 5);
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
