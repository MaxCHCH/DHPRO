//
//  WViewController.m
//  Test
//
//  Created by Rillakkuma on 16/6/29.
//  Copyright © 2016年 Rillakkuma. All rights reserved.
//

#import "WViewController.h"
#import "JPCommentHeaderView.h"
static NSString * const JPHeaderId = @"header";

@interface WViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation WViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBar.translucent=YES;

    
    
    _tableViewMy = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    _tableViewMy.delegate = self;
    _tableViewMy.dataSource = self;
    [self.view addSubview:_tableViewMy];
    [_tableViewMy registerClass:[JPCommentHeaderView class] forHeaderFooterViewReuseIdentifier:JPHeaderId];
    
   UIImage *imahe = [self createRoundedRectImage:[UIImage imageNamed:@"11"] size:CGSizeMake(50, 50)];
    UIButton *Tesbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [Tesbutton setFrame:CGRectMake(100.0 ,100.0 ,50.0 ,50.0)];
    Tesbutton.layer.borderColor = [UIColor colorWithWhite:0.000 alpha:0.611].CGColor;
    Tesbutton.layer.cornerRadius = 25;
    Tesbutton.layer.borderWidth = 1;
//    [Tesbutton setTitle:@"太阳、" forState:(UIControlStateNormal)];
//    [Tesbutton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
//    Tesbutton.backgroundColor = [UIColor whiteColor];       //背景颜色
    [Tesbutton setImage:imahe forState:(UIControlStateNormal)];
    Tesbutton.layer.shadowColor = [UIColor colorWithWhite:0.000 alpha:0.399].CGColor;//shadowColor阴影颜色
    Tesbutton.layer.shadowOffset = CGSizeMake(0,0);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    Tesbutton.layer.shadowOpacity = 1;//阴影透明度，默认0
    Tesbutton.layer.shadowRadius = 6;//阴影半径，默认3
    [self.view addSubview:Tesbutton];
    
        // Do any additional setup after loading the view from its nib.
}

- (id) createRoundedRectImage:(UIImage*)image size:(CGSize)size
{
    // the size of CGContextRef
    int w = size.width;
    int h = size.height;
    
    UIImage *img = image;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    CGRect rect = CGRectMake(0, 0, w, h);
    
    CGContextBeginPath(context);
    addRoundedRectToPath(context, rect, size.width/2, size.height/2);
    CGContextClosePath(context);
    CGContextClip(context);
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return [UIImage imageWithCGImage:imageMasked];
}
static void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth,
                                 float ovalHeight)
{
    float fw, fh;
    if (ovalWidth == 0 || ovalHeight == 0) {
        CGContextAddRect(context, rect);
        return;
    }
    
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM(context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth(rect) / ovalWidth;
    fh = CGRectGetHeight(rect) / ovalHeight;
    
    CGContextMoveToPoint(context, fw, fh/2);  // Start at lower right corner
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);  // Top right corner
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1); // Top left corner
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1); // Lower left corner
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1); // Back to lower right
    
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        UIView *header = [[UIView alloc]init];
        header.backgroundColor = [UIColor redColor];
        // 覆盖文字
        //    header.text = @"最新评论";
        return header;
    }
    UILabel *label = [[UILabel alloc] init];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    label.textColor = [UIColor colorWithWhite:0.151 alpha:1.000];
    label.text = @"优惠期间";
    label.backgroundColor = [UIColor lightGrayColor];
    label.font = [UIFont systemFontOfSize:14];
    return label;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    else if (section == 3){
        return 2;
    }
    return 20;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID =@"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:ID];
        
    }
    cell.textLabel.text = @"1111111";
    if (indexPath.section == 3) {
        cell.textLabel.hidden = YES;
        if (indexPath.row == 0) {
            UILabel *l = [[UILabel alloc]init];
            l.frame = CGRectMake(0, 0, 100, 80);
            l.text = @"adfa";
            l.backgroundColor = [UIColor colorWithRed:1.000 green:0.002 blue:0.910 alpha:1.000];
            [cell.contentView addSubview:l];
        }
        else{
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:CGRectMake(0.0 ,0.0 ,50.0 ,30.0)];
            button.backgroundColor = [UIColor greenColor];       //背景颜色
            [button setTitle:@"同意" forState:(UIControlStateNormal)];
            [cell.contentView addSubview:button];
            
            UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
            [button1 setFrame:CGRectMake(110 ,0.0 ,50.0 ,30.0)];
            button1.backgroundColor = [UIColor greenColor];       //背景颜色
            [button1 setTitle:@"不同意" forState:(UIControlStateNormal)];
            [cell.contentView addSubview:button1];
        }
        
        
    }
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 3) {
        if (indexPath.row == 0){
            return 130;
        }
        else{
            return 90;
        }
    }
    return 70;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 100;
    }
    
    return 50;
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
