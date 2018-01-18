//
//  CHYSlider.m
//  CHYSliderDemo
//
//  Created by Chen Chris on 8/16/12.
//  Copyright (c) 2012 ciderstudios.com. All rights reserved.
//

#import "CHYSlider.h"
#import <QuartzCore/QuartzCore.h>

@interface CHYSlider ()
- (void)commonInit;
- (float)xForValue:(float)value;
- (float)valueForX:(float)x;
- (float)stepMarkerXCloseToX:(float)x;
- (void)updateTrackHighlight;                  // set up track images overlay according to currernt value
- (NSString *)valueStringFormat;                // form value string format with given decimal places
@end

@implementation CHYSlider
@synthesize value = _value;
@synthesize minimumValue = _minimumValue;
@synthesize maximumValue = _maximumValue;
@synthesize continuous = _continuous;
//@synthesize labelOnThumb = _labelOnThumb;
@synthesize labelAboveThumb = _labelAboveThumb;
@synthesize stepped = _stepped;
@synthesize decimalPlaces = _decimalPlaces;
-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    return self;
}
#pragma mark - UIView methods
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;    
}

// re-layout subviews in case of first initialization and screen orientation changes
// track_grey.png and track_orange.png original size: 384x64
// thumb.png original size: 91x98
- (void)layoutSubviews
{
    // the track background
    
    _trackImageViewNormal.frame = self.bounds;
    _trackImageViewHighlighted.frame = self.bounds;
    
    //滑块
    _thumbImageView.frame = CGRectMake(0, 0, 16, 16);
    _thumbImageView.center = CGPointMake([self xForValue:_value], CGRectGetMidY(_trackImageViewNormal.frame));
    _thumbImageView.layer.masksToBounds = YES;
    _thumbImageView.layer.cornerRadius = _thumbImageView.frame.size.width/2;
    
    
    _labelAboveThumb.frame = CGRectMake(_thumbImageView.frame.origin.x - 8, _thumbImageView.frame.origin.y - 62,40,40);//默认
    NSLog(@"_thumbImageView.frame.origin.y %f",_labelAboveThumb.frame.origin.y);
    _labelAboveThumb.textColor = [UIColor whiteColor];
    _labelAboveThumb.layer.cornerRadius = _labelAboveThumb.frame.size.width/2;
    _labelAboveThumb.layer.masksToBounds = YES;

    // the track
    [self updateTrackHighlight];
}

- (void)drawRect:(CGRect)rect
{
//    _labelOnThumb.center = _thumbImageView.center; _thumbImageView.center.y - _labelAboveThumb.frame.size.height * 0.6f
    _labelAboveThumb.center = CGPointMake(_thumbImageView.center.x + 2,_thumbImageView.frame.origin.y - 41);//移动
    
//    _thumbImageView.frame = CGRectMake(_thumbStr, _trackImageViewNormal.frame.origin.y-_thumbImageView.frame.size.height/2, 16, 16);
   
    [self updateTrackHighlight];
}

#pragma mark - Accessor Overriding

// use diffrent track background images accordingly
- (void)setStepped:(BOOL)stepped
{
    _stepped = stepped;
    NSString *trackImageNormal;
    NSString *trackImageHighlighted;
    if (_stepped) {
        trackImageNormal = @"stepped_track_grey.png";
        trackImageHighlighted = @"stepped_track_orange.png";
    }
    else {
        trackImageNormal = @"track_grey.png";
        trackImageHighlighted = @"track_orange.png";
    }
    _trackImageViewNormal.image = nil;
    _trackImageViewHighlighted.image = nil;
}

- (void)setValue:(float)value
{
    if (value < _minimumValue || value > _maximumValue) {
        return;
    }
    
    _value = value;

    @try {
        _thumbImageView.center = CGPointMake([self xForValue:value], _thumbImageView.center.y);

    }
    @catch (NSException *exception) {
        [MBProgressHUD showError:[[NSString alloc] initWithFormat:@"%@",exception]];
    }
    @finally {
        _thumbImageView.center = CGPointMake(0, CGRectGetMidY(_trackImageViewNormal.frame));

    }
    
    _labelAboveThumb.text = [NSString stringWithFormat:[self valueStringFormat], _value];
    
    [self setNeedsDisplay];
}

#pragma mark - Helpers
- (void)commonInit
{
    _value = 0.f;
    _minimumValue = 0.f;
    _maximumValue = 1.f;
    _continuous = YES;
    _thumbOn = NO;
    _stepped = NO;
    _decimalPlaces = 0;
    
//    self.backgroundColor = [UIColor clearColor];
    
    // the track background images
    _trackImageViewNormal = [[UIImageView alloc] initWithImage:nil];
    _trackImageViewNormal.backgroundColor = [UIColor whiteColor];
    [self addSubview:_trackImageViewNormal];
    _trackImageViewHighlighted = [[UIImageView alloc] initWithImage:nil];
    _trackImageViewHighlighted.backgroundColor = [UIColor whiteColor];
    [self addSubview:_trackImageViewHighlighted];
    
    // thumb knob
//    _thumbImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"thumb.png"]];
    //滑块
    _thumbImageView = [[UILabel alloc]init];
    _thumbImageView.backgroundColor = [UIColor colorWithRed:0.408 green:0.247 blue:0.973 alpha:1.000];
    [self addSubview:_thumbImageView];
    
//    // value labels
//    _labelOnThumb = [[UILabel alloc] init];
//    _labelOnThumb.backgroundColor = [UIColor clearColor];
//    _labelOnThumb.textAlignment = UITextAlignmentCenter;
////    _labelOnThumb.text = [NSString stringWithFormat:[self valueStringFormat], _value];
//    _labelOnThumb.textColor = [UIColor whiteColor];
////    [self addSubview:_labelOnThumb];
    //上方数字显示
    _labelAboveThumb = [[UILabel alloc] init];
    _labelAboveThumb.backgroundColor = [UIColor colorWithRed:0.565 green:0.451 blue:0.980 alpha:0.800];
    _labelAboveThumb.textAlignment = NSTextAlignmentCenter;
    _labelAboveThumb.text = [NSString stringWithFormat:[self valueStringFormat], _value];
    _labelAboveThumb.textColor = [UIColor whiteColor];
    [self addSubview:_labelAboveThumb];
}

- (float)xForValue:(float)value
{
    if (_maximumValue <= _minimumValue) {
        return 0;
    }
    return self.frame.size.width * (value - _minimumValue) / (_maximumValue - _minimumValue);
}

- (float)valueForX:(float)x
{
    return _minimumValue + x / self.frame.size.width * (_maximumValue - _minimumValue);
}

- (float)stepMarkerXCloseToX:(float)x
{
    float xPercent = MIN(MAX(x / self.frame.size.width, 0), 1);
    float stepPercent = 1.f / 5.f;
    float midStepPercent = stepPercent / 2.f;
    int stepIndex = 0;
    while (xPercent > midStepPercent) {
        stepIndex++;
        midStepPercent += stepPercent;
    }
    
    return stepPercent * (float)stepIndex * self.frame.size.width;
}

- (void)updateTrackHighlight
{
    // Create a mask layer and the frame to determine what will be visible in the view.
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    CGFloat thumbMidXInHighlightTrack = CGRectGetMidX([self convertRect:_thumbImageView.frame toView:_trackImageViewNormal]);
    CGRect maskRect = CGRectMake(0, 0, thumbMidXInHighlightTrack, _trackImageViewNormal.frame.size.height);
    
    // Create a path and add the rectangle in it.
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, nil, maskRect);
    
    // Set the path to the mask layer.
    [maskLayer setPath:path];
    
    // Release the path since it's not covered by ARC.
    CGPathRelease(path);
    
    // Set the mask of the view.
    _trackImageViewHighlighted.layer.mask = maskLayer;
}

- (NSString *)valueStringFormat
{
    return [NSString stringWithFormat:@"%%.%df", _decimalPlaces];
}
//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    NSLog(@"tpuch ---  %f--%s",_labelAboveThumb.frame.origin.x,__FUNCTION__);
//
//}
//-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    CGPoint ptCurr=[[touches anyObject] locationInView:self];
//    CGPoint ptpre=[[touches anyObject] previousLocationInView:self];
//    NSLog(@"tpuch ---  %f-- %s--%f,%f,%f,%f",_labelAboveThumb.frame.origin.x,__FUNCTION__,ptCurr.x,ptCurr.y,ptpre.x,ptpre.y);
//
//}
//-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//     NSLog(@"tpuch ---  %f-- %s",_labelAboveThumb.frame.origin.x,__FUNCTION__);
//}
#pragma mark - Touch events handling
-(BOOL) beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint touchPoint = [touch locationInView:self];
    _labelAboveThumb.text = [NSString stringWithFormat:[self valueStringFormat], [self valueForX:_thumbImageView.center.x]];
    if(CGRectContainsPoint(_thumbImageView.frame, touchPoint)){
        _thumbOn = YES;
    }else {
        _thumbOn = NO;
    }
    return YES;
}

-(void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    if (_thumbOn) {
        _value = [self valueForX:_thumbImageView.center.x];
        if (_stepped) {
            _value = (int)((_value+0.5)/1);
            _thumbImageView.center = CGPointMake( [self stepMarkerXCloseToX:[touch locationInView:self].x], _thumbImageView.center.y);
            NSLog(@"----- %f",_thumbImageView.center.x);
//            [self setNeedsDisplay];
            _thumbImageView.x = [self xForValue:_value] - 15;
        }
        NSDictionary *dic = @{@"aboveThumbfloat":[NSNumber numberWithFloat:_thumbImageView.center.x]};
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"aboveThumb" object:nil userInfo:dic];
        
//        _labelAboveThumb.text = [NSString stringWithFormat:[self valueStringFormat], _value];
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
    _thumbOn = NO;
}

-(BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    if(!_thumbOn) return YES;
    
    CGPoint touchPoint = [touch locationInView:self];
    _labelAboveThumb.text = [NSString stringWithFormat:[self valueStringFormat], [self valueForX:_labelAboveThumb.x]];
    
    _thumbImageView.center = CGPointMake( MIN( MAX( [self xForValue:_minimumValue], touchPoint.x), [self xForValue:_maximumValue]), _thumbImageView.center.y);
    if (_continuous && !_stepped) {
        _value = [self valueForX:_thumbImageView.center.x];
//        _labelOnThumb.text = [NSString stringWithFormat:[self valueStringFormat], _value];
        _labelAboveThumb.text = [NSString stringWithFormat:[self valueStringFormat], _value];
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
   


    [self setNeedsDisplay];
    return YES;
}

@end
