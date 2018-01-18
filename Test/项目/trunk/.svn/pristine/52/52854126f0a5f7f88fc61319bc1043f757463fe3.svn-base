//
//  HorizontalScrollCell.m
//  MoviePicker
//
//  Created by nick on 28.01.2015.
//  Copyright (c) 2015 nick. All rights reserved.
//

#import "HorizontalScrollCell.h"
#import "DiscoverTypeViewController.h"

@implementation HorizontalScrollCell

- (void)awakeFromNib {
    // Initialization code
 
}

-(void)setUpCellWithArray:(NSArray *)array andTitle:(NSString*)title andTypeId:(NSString *)typeId
{
    CGFloat xbase = 7;
    CGFloat width = 110;
    [self.scroll setScrollEnabled:YES];
    [self.scroll setShowsHorizontalScrollIndicator:NO];
    
    for (UIView *view in self.scroll.subviews) {
        [view removeFromSuperview];
    }
    
    //添加首张按钮
    self.clipsToBounds = NO;
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    view.frame = CGRectMake(-1, -8, SCREEN_WIDTH+2, 35);
    view.layer.borderColor = [WWTolls colorWithHexString:@"#dcdcdc"].CGColor;
    view.layer.borderWidth = 0.5;
    [self addSubview:view];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToType:)];
    [view addGestureRecognizer:tap];
    
    UIImageView *more = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_more_26_26"]];
    more.frame = CGRectMake(view.width-27, 11, 13, 13);
    [view addSubview:more];
    
    UILabel *lbl = [[UILabel alloc] init];
    lbl.font = MyFont(14);
    lbl.textColor = [WWTolls colorWithHexString:@"#6b6b6b"];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:title];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18] range:NSMakeRange(0,2)];
    lbl.attributedText = str;
    lbl.frame = CGRectMake(8, 0, 180, 35);
    [view addSubview:lbl];
//
//    customMyImageButton* beginButton = [[customMyImageButton alloc]initWithFrame:CGRectMake(-15, -8, 350, 35)];
//    self.clipsToBounds = NO;
//    beginButton.titleLabel.textColor = [WWTolls colorWithHexString:@"#6b6b6b"];
//    [beginButton setTitleColor:[WWTolls colorWithHexString:@"#6b6b6b"] forState:UIControlStateNormal];
//    beginButton.titleLabel.font = MyFont(14);
    self.typeId = typeId;
    
    
    
//    beginButton.titleLabel.text = [NSString stringWithFormat:@"%@",title];
//    
//    [beginButton configureButton:title image1:[UIImage imageNamed:@""] image2:[UIImage imageNamed:@"home_more_26_26"]];
//    [beginButton addTarget:self action:@selector(goToType:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:beginButton];
//    UILabel *lbl = [[UILabel alloc] init];
//    lbl.font = MyFont(14);
//    lbl.textColor = [WWTolls colorWithHexString:@"#6b6b6b"];
//    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:title];
//    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18] range:NSMakeRange(0,1)];
//    lbl.attributedText = str;
//    lbl.backgroundColor = [UIColor blueColor];
//    lbl.bounds = beginButton.bounds;
//    [beginButton addSubview:lbl];
//    lbl.left+=7;
    
    xbase += 5;
    for(int i = 0; i < [array count]; i++)
    {
        UIView *custom = [self createCustomViewWithImage:array[i]];
        [self.scroll addSubview:custom];
        [custom setFrame:CGRectMake(xbase, 0, width, 110)];
        xbase += 8 + width;
    }
    
    UIButton *moreBtn = [[UIButton alloc] init];
    moreBtn.frame = CGRectMake(xbase, 0, 25, 110);
    [moreBtn setBackgroundImage:[UIImage imageNamed:@"Discover_more"] forState:UIControlStateNormal];
    moreBtn.titleLabel.text = title;
    
    [moreBtn addTarget:self action:@selector(goToType:) forControlEvents:UIControlEventTouchUpInside];
    [self.scroll addSubview:moreBtn];
    xbase += 16;
    xbase += 14;
    
    [self.scroll setContentSize:CGSizeMake(xbase, self.scroll.frame.size.height)];
    self.scroll.delegate = self;
}

-(void)setUpCellWithArray:(NSArray *)array
{
    CGFloat xbase = 10;
    CGFloat width = 100;
    
    [self.scroll setScrollEnabled:YES];
    [self.scroll setShowsHorizontalScrollIndicator:NO];
    
    xbase += 10;
    for(int i = 0; i < [array count]; i++){
        NSDictionary *dic = [array objectAtIndex:i];
        UIView *custom = [self createCustomViewWithImage:dic];
        [self.scroll addSubview:custom];
        [custom setFrame:CGRectMake(xbase, 7, width, 100)];
        xbase += 10 + width;
    }
    
    [self.scroll setContentSize:CGSizeMake(xbase, self.scroll.frame.size.height)];
    self.scroll.delegate = self;
}

#pragma mark - 进入分类页面
-(void)goToType:(UIButton*)btn{
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            DiscoverTypeViewController *dtc = [[DiscoverTypeViewController alloc] init];
            dtc.typeId = self.typeId;
//            dtc.titleName = btn.titleLabel.text;
            [((UIViewController*)nextResponder).navigationController pushViewController:dtc animated:YES];
            return;
        }
    }
}


-(UIView *)createCustomViewWithImage:(NSDictionary *)dic{
    UIView *custom = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 110, 110)];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 110, 110)];
    imageView.backgroundColor = [UIColor whiteColor];
    [imageView sd_setImageWithURL:[NSURL URLWithString:dic[@"imageurl"]]];
    
    [custom addSubview:imageView];
    custom.restorationIdentifier = dic[@"showid"];//记录讨论id
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    [custom addGestureRecognizer:singleFingerTap];
    
    return custom;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate

{
    [self containingScrollViewDidEndDragging:scrollView];
    
}

- (void)containingScrollViewDidEndDragging:(UIScrollView *)containingScrollView
{
    CGFloat minOffsetToTriggerRefresh = 25.0f;
    
    NSLog(@"%.2f",containingScrollView.contentOffset.x);
    
    NSLog(@"%.2f",self.scroll.contentSize.width);
    
    if (containingScrollView.contentOffset.x <= -50)
    {
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(-50 , 7, 100, 150)];
        
        UIActivityIndicatorView *acc = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        acc.hidesWhenStopped = YES;
        [view addSubview:acc];
        
        [acc setFrame:CGRectMake(view.center.x - 25, view.center.y - 25, 50, 50)];
        
        [view setBackgroundColor:[UIColor clearColor]];
        
        [self.scroll addSubview:view];
        
        [acc startAnimating];
        
        [UIView animateWithDuration: 0.3
         
                              delay: 0.0
         
                            options: UIViewAnimationOptionCurveEaseOut
         
                         animations:^{
                             
                             [containingScrollView setContentInset:UIEdgeInsetsMake(0, 100, 0, 0)];
                             
                         }
                         completion:nil];
        //[containingScrollView setContentInset:UIEdgeInsetsMake(0, 100, 0, 0)];
        
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSLog(@"Started");
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                //Do whatever you want.
                
                NSLog(@"Refreshing");
                
               [NSThread sleepForTimeInterval:3.0];
                
                NSLog(@"refresh end");
                
                [UIView animateWithDuration: 0.3
                
                                      delay: 0.0
                
                                    options: UIViewAnimationOptionCurveEaseIn
                
                                 animations:^{
                
                                     [containingScrollView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
                
                                 }
                                                completion:nil];
            });
            
        });
        
    }
}

//The event handling method
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    NSLog(@"clicked");
    
    UIView *selectedView = (UIView *)recognizer.view;
    
    if([_cellDelegate respondsToSelector:@selector(cellSelected:)])
        [_cellDelegate cellSelected:selectedView.restorationIdentifier];
}

@end