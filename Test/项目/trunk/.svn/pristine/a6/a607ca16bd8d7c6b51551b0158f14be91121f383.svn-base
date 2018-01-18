/*
 *  UIExpandingTextView.m
 *  
 *  Created by Brandon Hamilton on 2011/05/03.
 *  Copyright 2011 Brandon Hamilton.
 *  
 *  Permission is hereby granted, free of charge, to any person obtaining a copy
 *  of this software and associated documentation files (the "Software"), to deal
 *  in the Software without restriction, including without limitation the rights
 *  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 *  copies of the Software, and to permit persons to whom the Software is
 *  furnished to do so, subject to the following conditions:
 *  
 *  The above copyright notice and this permission notice shall be included in
 *  all copies or substantial portions of the Software.
 *  
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 *  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 *  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 *  THE SOFTWARE.
 */

/* 
 *  This class is based on growingTextView by Hans Pickaers 
 *  http://www.hanspinckaers.com/multi-line-uitextview-similar-to-sms
 */

#import "UIExpandingTextView.h"
#import <QuartzCore/QuartzCore.h>
#import "UITextView+LimitLength.h"
#define kTextInsetX 4
#define kTextInsetBottom 0

@implementation UIExpandingTextView

@synthesize internalTextView;
@synthesize delegate;

@synthesize text;
@synthesize font;
@synthesize textColor;
@synthesize textAlignment; 
@synthesize selectedRange;
@synthesize editable;
@synthesize dataDetectorTypes; 
@synthesize animateHeightChange;
@synthesize returnKeyType;
@synthesize textViewBackgroundImage;
@synthesize placeholder;
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
- (void)setPlaceholder:(NSString *)placeholders
{
    placeholder = placeholders;
    placeholderLabel.text = placeholders;
}

- (int)minimumNumberOfLines
{
    return minimumNumberOfLines;
}

- (int)maximumNumberOfLines
{
    return maximumNumberOfLines;
}


- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) 
    {
        forceSizeUpdate = NO;
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		CGRect backgroundFrame = frame;
        backgroundFrame.origin.y = 0;
		backgroundFrame.origin.x = 0;
        
        CGRect textViewFrame = CGRectInset(backgroundFrame, kTextInsetX, kTextInsetX);

        /* Internal Text View component */
		internalTextView = [[UIExpandingTextViewInternal alloc] initWithFrame:textViewFrame];

		internalTextView.delegate        = self;
		internalTextView.font            = [UIFont systemFontOfSize:17.0];
		internalTextView.contentInset    = UIEdgeInsetsMake(-4,0,-4,0);	
        internalTextView.text            = @"-";
		internalTextView.scrollEnabled   = NO;
        internalTextView.opaque          = NO;
        internalTextView.backgroundColor = [UIColor clearColor];
        internalTextView.showsHorizontalScrollIndicator = NO;
        [internalTextView sizeToFit];
        internalTextView.layer.cornerRadius =5.0;
//        internalTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        if (0) {
//            [[NSNotificationCenter defaultCenter] addObserver:self
//                                                     selector:@selector(keyboardWasShown:)
//                                                         name:UIKeyboardDidShowNotification object:nil];
//            [[NSNotificationCenter defaultCenter] addObserver:self
//                                                     selector:@selector(keyboardWillBeHidden:)
//                                                         name:UIKeyboardWillHideNotification object:nil];
        }
        
        /* set placeholder */
        placeholderLabel = [[UILabel alloc]initWithFrame:CGRectMake(8,2,self.bounds.size.width - 16,self.bounds.size.height)];
       
        placeholderLabel.text = placeholder;
        placeholderLabel.font = internalTextView.font;
        
        placeholderLabel.backgroundColor = [UIColor clearColor];
        placeholderLabel.textColor = [UIColor colorWithRed:0.565 green:0.655 blue:0.686 alpha:1.000];
        [internalTextView addSubview:placeholderLabel];
        [internalTextView limitTextLength:1000];
        textViewBackgroundImage = [[UIImageView alloc] initWithFrame:backgroundFrame];
        //        textViewBackgroundImage.image          = [UIImage imageNamed:@"InputBack"];
//        textViewBackgroundImage.backgroundColor = [AppTools colorWithHexString:@"f5f5f5"];
#pragma mark - 修改自定义框的颜色
//        textViewBackgroundImage.backgroundColor = [UIColor whiteColor];
//        textViewBackgroundImage.layer.cornerRadius = 2;
//        textViewBackgroundImage.layer.borderWidth = 0.5;
////        textViewBackgroundImage.layer.borderColor = [AppTools colorWithHexString:@"d6d6d6"].CGColor;
//        textViewBackgroundImage.layer.borderColor = [UIColor grayColor].CGColor;
        textViewBackgroundImage.contentMode    = UIViewContentModeScaleToFill;
//        //        textViewBackgroundImage.contentStretch = CGRectMake(0.5, 0.5, 0, 0);
//        textViewBackgroundImage.layer.cornerRadius = 5;
//        textViewBackgroundImage.backgroundColor = RGBCOLOR(239, 239, 239);
//        textViewBackgroundImage.layer.borderWidth = 0.5;
//        textViewBackgroundImage.layer.borderColor = [WWTolls colorWithHexString:@"#cacaca"].CGColor;
        textViewBackgroundImage.image = [textViewBackgroundImage.image stretchableImageWithLeftCapWidth:15 topCapHeight:15];
        [self addSubview:textViewBackgroundImage];
        /* Custom Background image */
        
        [self addSubview:internalTextView];

        /* Calculate the text view height */
		UIView *internal = (UIView*)[[internalTextView subviews] objectAtIndex:0];
		minimumHeight = internal.frame.size.height;
        if (iOS7) {
            minimumHeight = 37;
        }
		[self setMinimumNumberOfLines:1];
		animateHeightChange = YES;
		internalTextView.text = @"";
		[self setMaximumNumberOfLines:13];
        
        [self sizeToFit];
    }
    return self;
}

-(void)sizeToFit
{
    CGRect r = self.frame;
    if ([self.text length] > 0) 
    {
        /* No need to resize is text is not empty */
        return;
    }
    r.size.height = minimumHeight + kTextInsetBottom;
    self.frame = r;
}

-(void)setFrame:(CGRect)aframe
{
    CGRect backgroundFrame   = aframe;
    backgroundFrame.origin.y = 0;
    backgroundFrame.origin.x = 0;
    CGRect textViewFrame = CGRectInset(backgroundFrame, kTextInsetX, kTextInsetX);
    if (iOS7) {//37 29
        textViewFrame.size.height = MAX(textViewFrame.size.height, 29);
        backgroundFrame.size.height = MAX(backgroundFrame.size.height, 37);
    }
    internalTextView.frame   = textViewFrame;
    //    backgroundFrame.size.height  -= 8;
    textViewBackgroundImage.frame = backgroundFrame;
        forceSizeUpdate = YES;
//    NSLog(@"%s   image %@ \n  == %@",__func__, textViewBackgroundImage, internalTextView);

	[super setFrame:aframe];
}

-(void)clearText
{
    self.text = @"";
//    [self textViewDidChange:self.internalTextView];
}
     
-(void)setMaximumNumberOfLines:(int)n
{
    BOOL didChange            = NO;
    NSString *saveText        = internalTextView.text;
    NSString *newText         = @"-";
    internalTextView.hidden   = YES;
    internalTextView.delegate = nil;
    for (int i = 2; i < n; ++i)
    {
        newText = [newText stringByAppendingString:@"\n|W|"];
    }
    internalTextView.text     = newText;
    didChange = (maximumHeight != internalTextView.contentSize.height);
    maximumHeight             = internalTextView.contentSize.height;
    if (iOS7) {
        switch (n) {
            case 3:
            {
                maximumHeight = 58;
            }
                break;
            case 4:
            {
                maximumHeight = 79;
            }
                break;
            case 5:
            {
                maximumHeight = 100;
            }
                break;
            case 13:
            {
                maximumHeight = 268;
            }
                break;
            default:
                break;
        }
    }
    maximumNumberOfLines      = n;
    internalTextView.text     = saveText;
    internalTextView.hidden   = NO;
    internalTextView.delegate = self;
    if (didChange) {
        forceSizeUpdate = YES;
        [self textViewDidChange:self.internalTextView];
    }
}

-(void)setMinimumNumberOfLines:(int)m
{
    NSString *saveText        = internalTextView.text;
    NSString *newText         = @"-";
    internalTextView.hidden   = YES;
    internalTextView.delegate = nil;
    for (int i = 2; i < m; ++i)
    {
        newText = [newText stringByAppendingString:@"\n|W|"];
    }
    internalTextView.text     = newText;
    minimumHeight             = internalTextView.contentSize.height;
    if (iOS7) {
        minimumHeight = 37;
    }
    internalTextView.text     = saveText;
    internalTextView.hidden   = NO;
    internalTextView.delegate = self;
    [self sizeToFit];
    minimumNumberOfLines = m;
}

#pragma mark UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView
{
    
    //NSLog(@"走textViewDidChange%@",textView);
    [textView textFieldTextLengthLimit:nil];
    if(textView.text.length == 0)
        placeholderLabel.alpha = 1;
    else
        placeholderLabel.alpha = 0;
    
	float newHeight = internalTextView.contentSize.height;
//    NSLog(@"content  text %@   height   %f",internalTextView.text ,newHeight);
    if (iOS7) {
        CGFloat fixedWidth = textView.frame.size.width;
        CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
        CGRect newFrame = textView.frame;
        newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
        
        newFrame.size.height = MIN(newFrame.size.height, maximumHeight);//不能超过最大高度
        newFrame.size.height = MAX(newFrame.size.height, 37);
        textView.frame = newFrame;
        
        switch (maximumNumberOfLines) {
            case 3:
            {
                maximumHeight = 58;
            }
                break;
            case 4:
            {
                maximumHeight = 79;
            }
                break;
            case 5:
            {
                maximumHeight = 100;
            }
                break;
            case 13:
            {
                maximumHeight = 268;
            }
                break;
            default:
                break;
        }

        newHeight = newFrame.size.height;
        
    }
	if(newHeight < minimumHeight || !internalTextView.hasText)
    {
        newHeight = minimumHeight;
    }
    
	if (internalTextView.frame.size.height != newHeight || forceSizeUpdate)
	{
        forceSizeUpdate = NO;
        if (newHeight > maximumHeight && internalTextView.frame.size.height <= maximumHeight)
        {
            newHeight = maximumHeight;
        }
		if (newHeight <= maximumHeight)
		{
			if(animateHeightChange)
            {
				[UIView beginAnimations:@"" context:nil];
				[UIView setAnimationDelegate:self];
				[UIView setAnimationDidStopSelector:@selector(growDidStop)];
				[UIView setAnimationBeginsFromCurrentState:YES];
			}
			
			if ([delegate respondsToSelector:@selector(expandingTextView:willChangeHeight:)]) 
            {
//                NSLog(@" newheight %f",newHeight);

				[delegate expandingTextView:self willChangeHeight:(newHeight+ kTextInsetBottom)];
			}
			
			/* Resize the frame */
			CGRect r = self.frame;
//            NSLog(@"self   %@",self);
          
			r.size.height = newHeight + kTextInsetBottom;
            if (iOS7) {//37 29
                r.size.height = MAX(r.size.height, 37);
            }
			self.frame = r;
			r.origin.y = 0;
			r.origin.x = 0;
           
            internalTextView.frame = CGRectInset(r, kTextInsetX, kTextInsetX);

//            r.size.height -= 8;
            textViewBackgroundImage.frame = r;
            
            
//            NSLog(@"%s  image  %@ === %@",__func__, textViewBackgroundImage, internalTextView);
			if(animateHeightChange)
            {
				[UIView commitAnimations];
			}
            else if ([delegate respondsToSelector:@selector(expandingTextView:didChangeHeight:)]) 
            {
                [delegate expandingTextView:self didChangeHeight:(newHeight+ kTextInsetBottom)];
            }
		}
		
		if (newHeight >= maximumHeight)
		{
            /* Enable vertical scrolling */
			if(!internalTextView.scrollEnabled)
            {
				internalTextView.scrollEnabled = YES;
				[internalTextView flashScrollIndicators];
			}
		} 
        else 
        {
            /* Disable vertical scrolling */
			internalTextView.scrollEnabled = YES;
		}
	}
	
	if ([delegate respondsToSelector:@selector(expandingTextViewDidChange:)]) 
    {
		[delegate expandingTextViewDidChange:self];
	}
}

-(void)growDidStop
{
	if ([delegate respondsToSelector:@selector(expandingTextView:didChangeHeight:)]) 
    {
		[delegate expandingTextView:self didChangeHeight:self.frame.size.height];
	}
}
-(BOOL)becomeFirstResponder{
    [super becomeFirstResponder];
    return [internalTextView becomeFirstResponder];
}
-(BOOL)resignFirstResponder
{
	[super resignFirstResponder];
	return [internalTextView resignFirstResponder];
}

- (void)dealloc 
{
	[internalTextView release];
    [textViewBackgroundImage release];
    [placeholderLabel release];
    [super dealloc];
}

#pragma mark UITextView properties

-(void)setText:(NSString *)atext
{
	internalTextView.text = atext;
    [self performSelector:@selector(textViewDidChange:) withObject:internalTextView];
}

-(NSString*)text
{
	return internalTextView.text;
}

-(void)setFont:(UIFont *)afont
{
	internalTextView.font= afont;
	[self setMaximumNumberOfLines:maximumNumberOfLines];
	[self setMinimumNumberOfLines:minimumNumberOfLines];
}

-(UIFont *)font
{
	return internalTextView.font;
}	

-(void)setTextColor:(UIColor *)color
{
	internalTextView.textColor = color;
}

-(UIColor*)textColor
{
	return internalTextView.textColor;
}

-(void)setTextAlignment:(UITextAlignment)aligment
{
	internalTextView.textAlignment = aligment;
}

-(UITextAlignment)textAlignment
{
	return internalTextView.textAlignment;
}

-(void)setSelectedRange:(NSRange)range
{
	internalTextView.selectedRange = range;
}

-(NSRange)selectedRange
{
	return internalTextView.selectedRange;
}

-(void)setEditable:(BOOL)beditable
{
	internalTextView.editable = beditable;
}

-(BOOL)isEditable
{
	return internalTextView.editable;
}

-(void)setReturnKeyType:(UIReturnKeyType)keyType
{
	internalTextView.returnKeyType = keyType;
}

-(UIReturnKeyType)returnKeyType
{
	return internalTextView.returnKeyType;
}

-(void)setDataDetectorTypes:(UIDataDetectorTypes)datadetector
{
	internalTextView.dataDetectorTypes = datadetector;
}

-(UIDataDetectorTypes)dataDetectorTypes
{
	return internalTextView.dataDetectorTypes;
}

- (BOOL)hasText
{
	return [internalTextView hasText];
}

- (void)scrollRangeToVisible:(NSRange)range
{
	[internalTextView scrollRangeToVisible:range];
}

#pragma mark -
#pragma mark UIExpandingTextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView 
{
	if ([delegate respondsToSelector:@selector(expandingTextViewShouldBeginEditing:)]) 
    {
		return [delegate expandingTextViewShouldBeginEditing:self];
	} 
    else 
    {
		return YES;
	}
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView 
{
	if ([delegate respondsToSelector:@selector(expandingTextViewShouldEndEditing:)]) 
    {
		return [delegate expandingTextViewShouldEndEditing:self];
	} 
    else 
    {
		return YES;
	}
}

- (void)textViewDidBeginEditing:(UITextView *)textView 
{
	if ([delegate respondsToSelector:@selector(expandingTextViewDidBeginEditing:)]) 
    {
		[delegate expandingTextViewDidBeginEditing:self];
	}
}

- (void)textViewDidEndEditing:(UITextView *)textView 
{		
	if ([delegate respondsToSelector:@selector(expandingTextViewDidEndEditing:)]) 
    {
		[delegate expandingTextViewDidEndEditing:self];
	}
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)atext 
{
	if(![textView hasText] && [atext isEqualToString:@""]) 
    {
        return NO;
	}
    
    if ([atext isEqualToString:@""] && textView.text.length > 0) {
        if ([@"]" isEqualToString:[textView.text substringFromIndex:textView.text.length-1]]) {
            if ([textView.text rangeOfString:@"[/"].location != NSNotFound) {
                textView.text = [textView.text substringToIndex:[textView.text rangeOfString:@"[/" options:NSBackwardsSearch].location + 1];
            }
        }
    }
    
	if ([atext isEqualToString:@"\n"])
    {
		if ([delegate respondsToSelector:@selector(expandingTextViewShouldReturn:)]) 
        {
			if (![delegate performSelector:@selector(expandingTextViewShouldReturn:) withObject:self]) 
            {
				return YES;
			} 
            else 
            {
//				[textView resignFirstResponder];
				return NO;
			}
		}
	}
    
    NSString * toBeString = [textView.text stringByReplacingCharactersInRange:range withString:atext]; //得到输入框的内容
//    NSLog(@"****************想要测算输入框内容找我");
    #pragma mark -****************想要测算输入框内容找我
    if ([toBeString length] > 1000) { //如果输入框内容大于1000则弹出警告
            return NO;
        }
    if ([toBeString isEqualToString:@" "]) {
            return NO;
        }
	return YES;
}

- (void)textViewDidChangeSelection:(UITextView *)textView 
{
	if ([delegate respondsToSelector:@selector(expandingTextViewDidChangeSelection:)]) 
    {
		[delegate expandingTextViewDidChangeSelection:self];
	}
}

@end
