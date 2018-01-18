//
//  chatView.m
//  test
//
//  Created by Z on 14-5-26.
//  Copyright (c) 2014年 carlsworld. All rights reserved.
//
#define YmaxPoint 120
#import "chatView.h"
#import "MyAttentionModel.h"
@interface chatView (){
    NSMutableArray *arr;
}


@property(nonatomic, strong)CAShapeLayer* shaperLayer;
@property(nonatomic, strong)CAShapeLayer* lineLayer;
@end

@implementation chatView
- (NSMutableArray *)arr{
    if (!arr) {
        arr = [NSMutableArray array];
    }
    return arr;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.lines = [[NSMutableArray alloc]init];
        self.afColor = [UIColor colorWithRed:123.0/255.0 green:207.0/255.0 blue:35.0/255.0 alpha:1.0];
        self.bfColor = [UIColor colorWithRed:0.914 green:1.000 blue:0.435 alpha:1.000];
        self.points = [[NSMutableArray alloc]init];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (CAShapeLayer *)shaperLayer
{
    if(!_shaperLayer){
        _shaperLayer = [CAShapeLayer layer];
        [self.layer addSublayer:_shaperLayer];
        _shaperLayer.lineCap = kCALineCapRound;
        _shaperLayer.lineWidth = 4;
        _shaperLayer.fillColor = [UIColor clearColor].CGColor;
        _shaperLayer.strokeColor = [UIColor yellowColor].CGColor;
    }
    return _shaperLayer;
}

- (CAShapeLayer *)lineLayer
{
    if(!_lineLayer){
        _lineLayer = [CAShapeLayer layer];
        [self.layer addSublayer:_lineLayer];
        _lineLayer.lineCap = kCALineCapRound;
        _lineLayer.lineDashPattern = @[@(4), @(4)];
        _lineLayer.lineWidth = 1;
        _lineLayer.fillColor = [UIColor clearColor].CGColor;
        _lineLayer.strokeColor = [UIColor whiteColor].CGColor;
        
    }
    return _lineLayer;
}

- (void)drawRect:(CGRect)rect
{
    if([self.points count]){
        //a
        //画线
        
        UIBezierPath* path = [UIBezierPath bezierPath];
        [path setLineWidth:2];
        for(int i=0; i<[[self.points objectAtIndex:0] count]-1; i++){
            CGPoint firstPoint = [[[self.points objectAtIndex:0] objectAtIndex:i] CGPointValue];
            CGPoint secondPoint = [[[self.points objectAtIndex:0] objectAtIndex:i+1] CGPointValue];
            [path moveToPoint:firstPoint];
            [path addCurveToPoint:secondPoint controlPoint1:CGPointMake((secondPoint.x-firstPoint.x)/2+firstPoint.x, firstPoint.y) controlPoint2:CGPointMake((secondPoint.x-firstPoint.x)/2+firstPoint.x, secondPoint.y)];
            
            [self.bfColor set];
            
            
        }
        
//        for (int i = 0; i<[self.points count]; i++) {
//            MeWeightModel *model =arr[i];
//            CGPoint firstPoint =  CGPointMake([model.weight floatValue], [model.weight floatValue]);
//            CGPoint secondPoint = CGPointMake([model.weight floatValue], [model.weight floatValue]);
//            [path moveToPoint:firstPoint];
//            [path addCurveToPoint:secondPoint controlPoint1:CGPointMake((secondPoint.x-firstPoint.x)/2+firstPoint.x, firstPoint.y) controlPoint2:CGPointMake((secondPoint.x-firstPoint.x)/2+firstPoint.x, secondPoint.y)];
//
//            [self.bfColor set];
//        }
        path.lineCapStyle = kCGLineCapButt;
        self.shaperLayer.path = path.CGPath;
        
        //画点
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColorWithColor(ctx, [UIColor whiteColor].CGColor);
        CGContextSetFillColorWithColor(ctx, [UIColor whiteColor].CGColor);
        CGMutablePathRef mp = CGPathCreateMutable();
        if(!self.isDrawPoint){
            for(int i=0; i<[[self.points objectAtIndex:0] count]; i++){
                CGPoint point = [[[self.points objectAtIndex:0] objectAtIndex:i] CGPointValue];
                CGContextMoveToPoint(ctx, point.x-4, point.y-4);
                CGContextAddArc(ctx, point.x, point.y, 5, -M_PI_2, M_PI_2*3, NO);
                CGContextSetShadowWithColor(ctx, CGSizeMake(0,0), 10.0, [UIColor whiteColor].CGColor);
                CGContextFillPath(ctx);
                
                CGPathMoveToPoint(mp, nil, point.x, YmaxPoint);
                CGPathAddLineToPoint(mp, nil, point.x, point.y+5);
                
                //                CGContextSetLineWidth(ctx, 1);
                //                CGFloat alilengths[2] = {5, 3};
                //                CGContextSetLineDash(ctx, 0, alilengths, 2);
                //                CGContextMoveToPoint(ctx, point.x, point.y+5);
                //                CGContextAddLineToPoint(ctx, point.x, YmaxPoint);
                //                CGContextStrokePath(ctx);
            }
        }
        self.lineLayer.path = mp;
    }
    
}

- (void)update
{
    [self setNeedsDisplay];
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 3;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnimation.fromValue = @(0);
    pathAnimation.toValue = @(1.0);
    pathAnimation.autoreverses = NO;
    [self.shaperLayer addAnimation:pathAnimation forKey:nil];
    [self.lineLayer addAnimation:pathAnimation forKey:nil];
}

@end

@implementation Line

- (id)init
{
    if(self=[super init]){
        
    }
    return self;
}

@end