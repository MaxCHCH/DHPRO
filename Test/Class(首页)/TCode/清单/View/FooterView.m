//
//  FooterView.m
//  ContractDetailDemo
//
//  Created by 思 彭 on 2017/4/7.
//  Copyright © 2017年 思 彭. All rights reserved.
//

#import "FooterView.h"
#import "ResultModel.h"
#import "Macros_Font.h"
#import "UIView+AdjustFrame.h"
@implementation FooterView

+ (instancetype)ticketExamineResultViewWithExamineResultArray:(NSArray *)examineResultArray {
    if (!examineResultArray.count) {
        return [[self alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, FLT_EPSILON)];
    }
//    CGFloat topMargin = 20.f;
    CGFloat timeLineLeftMargin = 30.f;
    FooterView *view = [[self alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, 0)];
    
    NSUInteger count = examineResultArray.count;
    NSArray *reversedArray = [examineResultArray reverseObjectEnumerator].allObjects;
    UIView *lastCell = nil;
    
    // 审批意见
    UILabel *resultLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, DeviceWidth, 20)];
    resultLabel.font = FONT_14;
    resultLabel.textColor = [UIColor blackColor];
    resultLabel.text = @"审批意见";
    [view addSubview:resultLabel];
    
    for (NSUInteger i = 0; i < count; i++) {
        ResultModel *model = reversedArray[i];
        BOOL isLast = i == count - 1;
        UIView *cell = [self progressCellWithIndex:i isLast:isLast timeLineLeftMargin:timeLineLeftMargin width:view.width title:model.name time:model.time content:model.content flag:model.flag];
        if (i != 0) {
            cell.y = CGRectGetMaxY(lastCell.frame);
        } else {
            cell.y = 40;
        }
        lastCell = cell;
        [view addSubview:cell];
    }
    
    view.height = CGRectGetMaxY(lastCell.frame);
    
    return view;
}

+ (UIView *)progressCellWithIndex:(NSUInteger)index isLast:(BOOL)isLast timeLineLeftMargin:(CGFloat)timeLineLeftMargin width:(CGFloat)width title:(NSString *)title time:(NSString *)time content:(NSString *)content flag: (NSString *)flag {
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(timeLineLeftMargin, 0, 0.5, 0)]; // 高度不确定,最后赋值
    lineView.backgroundColor = [UIColor lightGrayColor];
    
    CGFloat eventIndexAndTriangleSpace = 5.f;
    CGFloat topAndTriangleSpace = 20.f;
    UILabel *eventIndexLabel = [[UILabel alloc] init];
    eventIndexLabel.text = [NSString stringWithFormat:@"%zd", index + 1];
    eventIndexLabel.size = CGSizeMake(20.f, 20.f);
    eventIndexLabel.center = CGPointMake(timeLineLeftMargin, topAndTriangleSpace);
    eventIndexLabel.textColor = [UIColor whiteColor];
    eventIndexLabel.font = FONT_14;
    eventIndexLabel.textAlignment = NSTextAlignmentCenter;
    eventIndexLabel.layer.cornerRadius = eventIndexLabel.width * 0.5;
    eventIndexLabel.layer.masksToBounds = YES;
    eventIndexLabel.backgroundColor = [UIColor greenColor];
    
    CGFloat timeLineAndContentSpace = eventIndexLabel.width + eventIndexAndTriangleSpace;
    CGFloat rightMargin = 20.f;
    UIView *subView = [[UIView alloc] init];
    subView.x = timeLineLeftMargin + timeLineAndContentSpace;
    subView.y = 0;
    subView.width = width - subView.x - rightMargin;
    
    CGFloat verticalSpace = 5.f;
    CGFloat contentOffSetX = 10.f; // space between triangle and content
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.x = contentOffSetX;
    titleLabel.y = verticalSpace;
    titleLabel.font = FONT_14;
    titleLabel.textColor = [UIColor lightGrayColor];
    titleLabel.text = title;
    [titleLabel sizeToFit];
    
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.font = FONT_14;
    timeLabel.textColor = [UIColor lightGrayColor];
    timeLabel.text = time;
    [timeLabel sizeToFit];
    timeLabel.x = subView.width - timeLabel.width - 5.f; // 5.f是距离有边框的距离
    timeLabel.y = titleLabel.y;
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.font = FONT_14;
    contentLabel.textColor = [UIColor lightGrayColor];
    contentLabel.text = content;
    contentLabel.x = titleLabel.x;
    contentLabel.y = CGRectGetMaxY(titleLabel.frame) + verticalSpace;
    contentLabel.width = subView.width - contentOffSetX - 5.f;
    contentLabel.numberOfLines = 0;
    [contentLabel sizeToFit];
    
    // 同意,不同意
    UILabel *flagLabel = [[UILabel alloc] init];
    flagLabel.font = FONT_14;
    flagLabel.textColor = [UIColor redColor];
    flagLabel.text = flag;
    flagLabel.x = titleLabel.x;
    flagLabel.y = CGRectGetMaxY(contentLabel.frame) + verticalSpace;
    flagLabel.width = subView.width - contentOffSetX - 5.f;
    flagLabel.numberOfLines = 0;
    [flagLabel sizeToFit];
    
    CGFloat height = CGRectGetMaxY(flagLabel.frame) + verticalSpace;
    subView.height = height;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:subView.bounds];
    UIImage *image = [UIImage imageNamed:@"drawer_flow-frame_image"];
    imageView.image =  [image resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height - 10, image.size.width * 0.5, 9, image.size.width * 0.5 - 1)];
    [subView addSubview:imageView];
    
    [subView addSubview:titleLabel];
    [subView addSubview:timeLabel];
    [subView addSubview:contentLabel];
    [subView addSubview:flagLabel];
    
    CGFloat bottomSpace = 10.f;
    if (index == 0) {
        lineView.y = CGRectGetMinY(eventIndexLabel.frame); // 第一个不显示线
    }
    if (isLast) {
        lineView.height = topAndTriangleSpace;
    } else {
        lineView.height = subView.height + bottomSpace;
    }
    // 最后计算高度
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, subView.height + bottomSpace)];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [view addSubview:lineView];
    [view addSubview:eventIndexLabel];
    [view addSubview:subView];
    return view;
}

@end
