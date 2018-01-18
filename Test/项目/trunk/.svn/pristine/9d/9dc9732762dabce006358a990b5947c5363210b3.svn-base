//
//  HKKTagWriteView.m
//  TagWriteViewTest
//
//  Created by kyokook on 2014. 1. 11..
//  Copyright (c) 2014 rhlab. All rights reserved.
//

#import "HKKTagWriteView.h"
#import "UITextView+LimitLength.h"
#import <QuartzCore/QuartzCore.h>
@import QuartzCore;

@interface HKKTagWriteView  ()
<
UITextViewDelegate
>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *tagViews;
@property (nonatomic, strong) UITextView *inputView;
@property (nonatomic, strong) UIButton *deleteButton;

@property (nonatomic, strong) NSMutableArray *tagsMade;
@property(nonatomic,strong)UIImageView *inputBg;//<#强引用#>
@property (nonatomic, assign) BOOL readyToDelete;

@end

@implementation HKKTagWriteView

#pragma mark - Life Cycle
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initProperties];
        [self initControls];
        
        [self reArrangeSubViews];
    }
    return self;
}

- (void)awakeFromNib
{
    [self initProperties];
    [self initControls];
    
    [self reArrangeSubViews];
}

#pragma mark - Property Get / Set
- (void)setFont:(UIFont *)font
{
    _font = font;
    for (UIButton *btn in _tagViews)
    {
        [btn.titleLabel setFont:_font];
    }
}

- (void)setTagBackgroundColor:(UIColor *)tagBackgroundColor
{
    _tagBackgroundColor = tagBackgroundColor;
    for (UIButton *btn in _tagViews)
    {
        [btn setBackgroundColor:_tagBackgroundColor];
    }
    
    _inputView.textColor = _tagBackgroundColor;
    _inputView.layer.borderColor = [WWTolls colorWithHexString:@"#4E777F"].CGColor;

}

- (void)setTagForegroundColor:(UIColor *)tagForegroundColor
{
    _tagForegroundColor = tagForegroundColor;
    for (UIButton *btn in _tagViews)
    {
        [btn setTitleColor:[WWTolls colorWithHexString:@"#4E777F"] forState:UIControlStateNormal];
        
    }
}

- (void)setMaxTagLength:(int)maxTagLength
{
    _maxTagLength = maxTagLength;
}

- (NSArray *)tags
{
    return _tagsMade;
}

- (void)setFocusOnAddTag:(BOOL)focusOnAddTag
{
    _focusOnAddTag = focusOnAddTag;
    if (_focusOnAddTag)
    {
        [_inputView becomeFirstResponder];
    }
    else
    {
        [_inputView resignFirstResponder];
    }
}

#pragma mark - Interfaces
- (void)clear
{
    _inputView.text = @"";
    [_tagsMade removeAllObjects];
    [self reArrangeSubViews];
}

- (void)setTextToInputSlot:(NSString *)text
{
    _inputView.text = text;
}

- (void)addTags:(NSArray *)tags
{
    for (NSString *tag in tags)
    {
        NSArray *result = [_tagsMade filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF == %@", tag]];
        if (result.count == 0)
        {
            [_tagsMade addObject:tag];
        }
    }
    
    [self reArrangeSubViews];
}

- (void)removeTags:(NSArray *)tags
{
    for (NSString *tag in tags)
    {
        NSArray *result = [_tagsMade filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF == %@", tag]];
        if (result)
        {
            [_tagsMade removeObjectsInArray:result];
        }
    }
    [self reArrangeSubViews];
}

- (void)addTagToLast:(NSString *)tag animated:(BOOL)animated
{
    for (NSString *t in _tagsMade)
    {
        if ([tag isEqualToString:t])
        {
            NSLog(@"DUPLICATED!");
            return;
        }
    }
    
    [_tagsMade addObject:tag];
    
    _inputView.text = @"";

    [self addTagViewToLast:tag animated:animated];
    [self layoutInputAndScroll];
    
    if ([_delegate respondsToSelector:@selector(tagWriteView:didMakeTag:)])
    {
        [_delegate tagWriteView:self didMakeTag:tag];
    }
}

- (void)removeTag:(NSString *)tag animated:(BOOL)animated
{
    NSInteger foundedIndex = -1;
    for (NSString *t in _tagsMade)
    {
        if ([tag isEqualToString:t])
        {
            foundedIndex = (NSInteger)[_tagsMade indexOfObject:t];
            break;
        }
    }
    
    if (foundedIndex == -1)
    {
        return;
    }
    
    [_tagsMade removeObjectAtIndex:foundedIndex];
    
    [self removeTagViewWithIndex:foundedIndex animated:animated completion:^(BOOL finished){
        [self layoutInputAndScroll];
    }];
    
    if ([_delegate respondsToSelector:@selector(tagWriteView:didRemoveTag:)])
    {
        [_delegate tagWriteView:self didRemoveTag:tag];
    }
}

#pragma mark - Internals
- (void)initControls
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapWriteView)];
    [self addGestureRecognizer:tap];
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.backgroundColor = [UIColor clearColor];

    _scrollView.scrollsToTop = NO;
    _scrollView.bounces = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:_scrollView];
    _inputView = [[UITextView alloc] initWithFrame:CGRectInset(self.bounds, 0, _tagGap)];
    _inputView.autocorrectionType = UITextAutocorrectionTypeNo;
    _inputView.font = MyFont(13);
    _inputView.textColor = ContentColor;
    _inputView.delegate = self;
    _inputView.backgroundColor = [UIColor clearColor];
    _inputView.returnKeyType = UIReturnKeyDone;
    _inputView.contentInset = UIEdgeInsetsMake(-3, 6, 0, 0);
    [_inputView limitTextLength:15];
    _inputView.scrollsToTop = NO;
    UIImageView *bg = [[UIImageView alloc] initWithImage:[self getBackImage:[UIImage imageNamed:@"tagEditorInputBg-80-50.png"]]];
    bg.frame = _inputView.frame;
    _inputBg = bg;
    bg.userInteractionEnabled = NO;
    [_scrollView addSubview:bg];
    _inputBg.hidden = YES;
    bg.hidden = YES;
    //    [_inputView.layer setBorderColor:[[UIColor colorWithPatternImage:[UIImage imageNamed:@"DotedImage.png"]] CGColor]];///just add image name and create image with dashed or doted drawing and add here
    //    _inputView.layer.style
    
    //    _inputView.layer.borderWidth = 0.5f;
    //    _inputView.layer.cornerRadius = _inputView.frame.size.height * 0.5f;
    _inputView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    [_scrollView addSubview:_inputView];
    
    _deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(30, 0, 17, 17)];
    [_deleteButton setBackgroundImage:[UIImage imageNamed:@"btn_tag_delete"] forState:UIControlStateNormal];
    [_deleteButton addTarget:self action:@selector(deleteTagDidPush:) forControlEvents:UIControlEventTouchUpInside];
    _deleteButton.hidden = YES;
}

- (void)initProperties
{
    _font = [UIFont systemFontOfSize:13.0f];
    _tagBackgroundColor = [UIColor whiteColor];
    _tagForegroundColor = [WWTolls colorWithHexString:@"#94ADB2"];
    
    _maxTagLength = 10;
    _tagGap = 15.0f;
    
    _tagsMade = [NSMutableArray array];
    _tagViews = [NSMutableArray array];
    
    self.readyToDelete = NO;
}

- (void)addTagViewToLast:(NSString *)newTag animated:(BOOL)animated
{
    CGPoint posX = [self posXForObjectNextToLastTagView:newTag];
    UIButton *tagBtn = [self tagButtonWithTag:newTag posX:posX];
    [_tagViews addObject:tagBtn];
    tagBtn.tag = [_tagViews indexOfObject:tagBtn];
    [_scrollView addSubview:tagBtn];
    
    if (animated)
    {
        tagBtn.alpha = 0.0f;
        [UIView animateWithDuration:0.25 animations:^{
            tagBtn.alpha = 1.0f;
        }];
    }
    
}

- (void)removeTagViewWithIndex:(NSUInteger)index animated:(BOOL)animated completion:(void (^)(BOOL finished))completion
{
    NSAssert(index < _tagViews.count, @"incorrected index");
    if (index >= _tagViews.count)
    {
        return;
    }
    
    UIView *deletedView = [_tagViews objectAtIndex:index];
    [deletedView removeFromSuperview];
    [_tagViews removeObject:deletedView];
    
    void (^layoutBlock)(void) = ^{
        [self reArrangeSubViews];
//        _inputView.frame = CGRectMake(deletedView.frame.origin.x, deletedView.frame.origin.y, _inputView.bounds.size.width, _inputView.bounds.size.height);
//        _inputBg.frame = _inputView.frame;
        
    };
    animated = NO;
    if (animated)
    {
        [UIView animateWithDuration:0.25 animations:layoutBlock completion:completion];
    }
    else
    {
        layoutBlock();
    }
    
}

- (void)reArrangeSubViews
{
    CGPoint accumX = CGPointMake(10, 10);
    
    NSMutableArray *newTags = [[NSMutableArray alloc] initWithCapacity:_tagsMade.count];
    for (int i = 0 ;i<_tagsMade.count;i++)
    {
        NSString *tag = _tagsMade[i];
        UIButton *last = [self tagButtonWithTag:tag posX:accumX];
        [newTags addObject:last];
        last.tag = [newTags indexOfObject:last];
        if (last.frame.origin.x + last.frame.size.width + (i<_tagsMade.count-1?[self widthForInputViewWithText:_tagsMade[i+1]]:10) > self.bounds.size.width) {
            accumX = CGPointMake(10, last.frame.origin.y + 35);
        }else accumX = CGPointMake(last.frame.origin.x + last.frame.size.width + 10, last.frame.origin.y);
        [_scrollView addSubview:last];
    }
    
    for (UIView *oldTagView in _tagViews)
    {
        [oldTagView removeFromSuperview];
    }
    _tagViews = newTags;
    
    [self layoutInputAndScroll];
}
- (UIImage*)getBackImage:(UIImage*)normal{
    CGSize size;
    size = CGSizeMake(normal.size.width / 2.0f, normal.size.height / 2.0f);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    if (1.0 == [[UIScreen mainScreen] scale])
        [normal drawInRect:CGRectIntegral((CGRect){0.0f, 0.0f, size})];
    else
        [normal drawInRect:(CGRect){0.0f, 0.0f, size}];
    normal = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 13, 0, 15);
    // 指定为拉伸模式，伸缩后重新赋值
    normal = [normal resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeTile];
    //    normal = [normal stretchableImageWithLeftCapWidth:normal.size.width*0.4 topCapHeight:normal.size.height];
    return normal;
}
- (void)layoutInputAndScroll
{
    CGPoint accumX = [self posXForObjectNextToLastTagView:@"添加"];
    
    CGRect inputRect = _inputView.frame;
    inputRect.origin.x = accumX.x;
    inputRect.origin.y = accumX.y;
    inputRect.size.width = [self widthForInputViewWithText:_inputView.text];
    inputRect.size.height = 30;
    _inputView.frame = inputRect;
    _inputBg.frame = inputRect;
    _inputView.font = _font;
    //    _inputView.layer.borderColor = _tagBackgroundColor.CGColor;
    //    [yourView.layer setBorderWidth:5.0];
    //    [_inputView.layer setBorderColor:[[UIColor colorWithPatternImage:[UIImage imageNamed:@"tagEditorInputBg-80-50.png"]] CGColor]];///just add image name and create image with dashed or doted drawing and add here
    
    
    //    _inputView.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"tagEditorInputBg-80-50.png"]];
    //    _inputView.layer.borderWidth = 0.5f;
    //    _inputView.layer.cornerRadius = _inputView.frame.size.height * 0.5f;
    //    _inputView.backgroundColor = [UIColor whiteColor];
    _inputView.textColor = [UIColor blackColor];
    
    CGSize contentSize = _scrollView.contentSize;
    contentSize = CGSizeMake(self.bounds.size.width, _inputView.frame.origin.y + _inputView.frame.size.height + 10);
    _scrollView.contentSize = contentSize;
    
    [self setScrollOffsetToShowInputView];
}

- (void)setScrollOffsetToShowInputView
{
    CGRect inputRect = _inputView.frame;
    _scrollView.contentOffset = CGPointMake(0, (inputRect.origin.y + inputRect.size.height + 10 - self.bounds.size.height < 0)?0:inputRect.origin.y + inputRect.size.height + 10 - self.bounds.size.height );
    //    CGFloat scrollingDelta = (inputRect.origin.x + inputRect.size.width) - (_scrollView.contentOffset.x + _scrollView.frame.size.width);
    //    if (scrollingDelta > 0)
    //    {
    //        CGPoint scrollOffset = _scrollView.contentOffset;
    //        scrollOffset.x += scrollingDelta + 40.0f;
    //        _scrollView.contentOffset = scrollOffset;
    //    }
}

- (CGFloat)widthForInputViewWithText:(NSString *)text
{
    return MAX(50.0, [text sizeWithAttributes:@{NSFontAttributeName:_font}].width + 30.0f);
}

- (CGPoint)posXForObjectNextToLastTagView:(NSString*)newTag
{
    CGPoint accumX = CGPointMake(0, 15);
    if (_tagViews.count)
    {
        UIView *last = _tagViews.lastObject;
        if (last.frame.origin.x + last.frame.size.width + [self widthForInputViewWithText:newTag] + 20 > self.bounds.size.width) {
            accumX = CGPointMake(0, last.frame.origin.y + 37);
        }else accumX = CGPointMake(last.frame.origin.x + last.frame.size.width + 8, last.frame.origin.y);
    }
    return accumX;
}

- (UIButton *)tagButtonWithTag:(NSString *)tag posX:(CGPoint)posX
{
    UIButton *tagBtn = [[UIButton alloc] init];
    [tagBtn.titleLabel setFont:_font];
    [tagBtn setBackgroundColor:_tagBackgroundColor];
    [tagBtn setTitleColor:_tagForegroundColor forState:UIControlStateNormal];
    [tagBtn addTarget:self action:@selector(tagButtonDidPushed:) forControlEvents:UIControlEventTouchUpInside];
    [tagBtn setTitle:tag forState:UIControlStateNormal];
    
    CGRect btnFrame = tagBtn.frame;
    btnFrame.origin.x = posX.x;
    btnFrame.origin.y = posX.y;
    btnFrame.size.width = [tagBtn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:_font}].width + (tagBtn.layer.cornerRadius * 2.0f) + 30.0f;
    btnFrame.size.height = 30;
    tagBtn.layer.cornerRadius = btnFrame.size.height * 0.5f;
    tagBtn.layer.borderWidth = 0.5;
    tagBtn.layer.borderColor = [[WWTolls colorWithHexString:@"#94ADB2"] colorWithAlphaComponent:0.9].CGColor;
    
    tagBtn.frame = CGRectIntegral(btnFrame);
    
    NSLog(@"btn frame [%@] = %@", tag, NSStringFromCGRect(tagBtn.frame));
    
    return tagBtn;
}

- (void)detectBackspace
{
    if (_inputView.text.length == 0)
    {
        if (_readyToDelete)
        {
            // remove lastest tag
            if (_tagsMade.count > 0)
            {
                NSString *deletedTag = _tagsMade.lastObject;
                [self removeTag:deletedTag animated:YES];
                self.readyToDelete = NO;
            }
        }
        else
        {
            self.readyToDelete = YES;
        }
    }
}

-(void)setReadyToDelete:(BOOL)readyToDelete{
    if (self.tagViews.count > 0) {
        UIButton *view = (UIButton*)[self.tagViews lastObject];
        if (readyToDelete) {
            view.layer.borderColor = [UIColor redColor].CGColor;
            [view setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }else{
            view.layer.borderColor = [WWTolls colorWithHexString:@"#94ADB2"].CGColor;
            [view setTitleColor:[WWTolls colorWithHexString:@"#94ADB2"] forState:UIControlStateNormal];
        }
    }
    
    _readyToDelete = readyToDelete;
}

#pragma mark - UI Actions
- (void)tagButtonDidPushed:(id)sender
{
    //    UIButton *btn = sender;
    //    NSLog(@"tagButton pushed: %@, idx = %ld", btn.titleLabel.text, (long)btn.tag);
    //
    //    if (_deleteButton.hidden == NO && btn.tag == _deleteButton.tag)
    //    {
    //        // hide delete button
    //        _deleteButton.hidden = YES;
    //        [_deleteButton removeFromSuperview];
    //    }
    //    else
    //    {
    //        // show delete button
    //        CGRect newRect = _deleteButton.frame;
    //        newRect.origin.x = btn.frame.origin.x + btn.frame.size.width - (newRect.size.width * 0.7f);
    //        newRect.origin.y = _inputView.frame.origin.y - 8.0f;
    //        _deleteButton.frame = newRect;
    //        _deleteButton.tag = btn.tag;
    //
    //        if (_deleteButton.superview == nil)
    //        {
    //            [_scrollView addSubview:_deleteButton];
    //        }
    //        _deleteButton.hidden = NO;
    //    }
}

- (void)deleteTagDidPush:(id)sender
{
    NSLog(@"tag count = %d,  button tag = %d", _tagsMade.count, _deleteButton.tag);
    NSAssert(_tagsMade.count > _deleteButton.tag, @"out of range");
    if (_tagsMade.count <= _deleteButton.tag)
    {
        return;
    }
    
    _deleteButton.hidden = YES;
    [_deleteButton removeFromSuperview];
    
    NSString *tag = [_tagsMade objectAtIndex:_deleteButton.tag];
    [self removeTag:tag animated:YES];
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        if (textView.text.length > 0 && self.tags.count < 10)
        {
            
            if([WWTolls getCharLength:textView.text] > 15){
                [MBProgressHUD showError:@"标签最多5个汉字"];

            }else if ([textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0) {
                
                [MBProgressHUD showError:@"标签不能全为空格"];
                
            } else if (![WWTolls isTagValidate:textView.text]) {
                
                [MBProgressHUD showError:@"标签中只能包含汉字字母数字"];
                
            }else{
                
                [self addTagToLast:[textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]animated:YES];
                textView.text = @"";
            }
            
        }else if(self.tags.count == 10){
            [MBProgressHUD showError:@"只能添加十个标签"];
        }
        
//        if ([text isEqualToString:@"\n"])
//        {
//            [textView resignFirstResponder];
//        }
        
        return NO;
    }
    
    CGFloat currentWidth = [self widthForInputViewWithText:textView.text];
    CGFloat newWidth = 0;
    NSString *newText = nil;
    
    if (text.length == 0)
    {
        // delete
        if (textView.text.length)
        {
            newText = [textView.text substringWithRange:NSMakeRange(0, textView.text.length - range.length)];
        }
        else
        {
            [self detectBackspace];
            return NO;
        }
    }
    else
    {
        self.readyToDelete = NO;
//        if (textView.text.length + text.length > 5)
//        {
//            return NO;
//        }
        newText = [NSString stringWithFormat:@"%@%@", textView.text, text];
    }
    newWidth = [self widthForInputViewWithText:newText];
    
    CGRect inputRect = _inputView.frame;
    inputRect.size.width = newWidth;
    if (newWidth + inputRect.origin.x + 10 > self.bounds.size.width) {
        inputRect.origin.y += 38;
        inputRect.origin.x = 10;
    }
    _inputView.frame = inputRect;
    _inputBg.frame = inputRect;
    CGSize contentSize = _scrollView.contentSize;
    contentSize.width = self.bounds.size.width;
    
    _scrollView.contentSize = contentSize;
    
    [self setScrollOffsetToShowInputView];
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    [textView textFieldTextLengthLimit:nil];
    if ([_delegate respondsToSelector:@selector(tagWriteView:didChangeText:)])
    {
        [_delegate tagWriteView:self didChangeText:textView.text];
    }
    
    if (_deleteButton.hidden == NO)
    {
        _deleteButton.hidden = YES;
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([_delegate respondsToSelector:@selector(tagWriteViewDidBeginEditing:)])
    {
        [_delegate tagWriteViewDidBeginEditing:self];
    }
    textView.frame = self.inputBg.frame;
    textView.hidden = NO;
    self.inputBg.hidden = NO;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    textView.frame = _inputBg.frame;
    textView.hidden = YES;
    self.inputBg.hidden = YES;
    if ([_delegate respondsToSelector:@selector(tagWriteViewDidEndEditing:)])
    {
        [_delegate tagWriteViewDidEndEditing:self];
    }
}

- (void)tapWriteView{
    if ([self.inputView isFirstResponder]) {
        [self.inputView resignFirstResponder];
    }else [self.inputView becomeFirstResponder];
}

@end


