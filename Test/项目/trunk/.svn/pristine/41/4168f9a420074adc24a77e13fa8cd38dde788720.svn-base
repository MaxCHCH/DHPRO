//
//  FaceToolBar.h
//  iSport
//
//  Created by xinglei on 13-5-27.
//  Copyright (c) 2013年 xinglei. All rights reserved.
//

#define Time  0.25 // 键盘动画的duration
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define  keyboardHeight 212
#define  toolBarHeight 49
#define  choiceBarHeight 35
#define  facialViewWidth 300
#define  facialViewHeight 170
#define  buttonWh 30
#define LeftWidth   33
#define ToolButtonRadius 2

#import <UIKit/UIKit.h>
#import "FacialView.h"
#import "UIExpandingTextView.h"

typedef enum {
    ChatToolBar, // 聊天页面的样式
    PostDynamicToolBar, // 发布动态的样式
    CommentDynamicToolBar,
    UserFeedBackToolBar,    // 用户反馈样式
    PublishDynamicToolBar//无格式
} FaceToolBarType;


@class FaceToolBar;

@protocol FaceToolBarDelegate <NSObject>

@optional
- (void)faceSendBtnClick;
-(void)sendDidClick;
- (void)sendTextAction:(NSString *)inputText inputState:(NSString*)state;
- (void)faceToolBarDidChangeFrame:(UIToolbar *)toolBar;

- (void)faceToolBarTakePhoto:(FaceToolBar*)faceToolBar;
- (void)faceToolBarLocalPhoto:(FaceToolBar*)faceToolBar;
- (void)faceToolBarWillShowKeyboard:(FaceToolBar *)faceToolBar;
- (void)faceToolBar:(FaceToolBar *)faceToolBar didSelectedFaceString:(NSString *)face;
- (void)faceToolBardeleteFaceString:(FaceToolBar *)faceToolBar;

-(void)faceToolBarDeleteFace;
-(void)faceToolBarDidSelectFace:(NSString*)faceString;
-(void)FaceToolBarBackTo;
@end


typedef void (^ HiddenBlock)();

@interface FaceToolBar : UIView<facialViewDelegate,UIExpandingTextViewDelegate,UIScrollViewDelegate>
{
    UIExpandingTextView * _myTextView;//文本输入框
    UIButton *faceButton;
    UIButton *voiceButton;
    UIPageControl *pageControl;
    UIButton *faceSendBtn;
}
@property(nonatomic,copy)HiddenBlock block;
@property(strong,nonatomic) UIButton* sendButton;
@property(nonatomic,strong)NSString* newsTitle;
@property(nonatomic,copy)NSString * newsId;
@property (strong, nonatomic) UIView *theSuperView;
@property (strong, nonatomic) UIButton *pictureButton;
@property (strong, nonatomic) UIToolbar *toolBar;//工具栏
@property (strong, nonatomic) UIScrollView *scrollView;//表情滚动视图
@property (strong, nonatomic) UIExpandingTextView *myTextView;//文本输入框

@property (nonatomic,assign) id<FaceToolBarDelegate> faceToolBardelegate;
@property (unsafe_unretained, nonatomic) BOOL keyboardIsShow;//键盘是否显示
@property (unsafe_unretained, nonatomic) BOOL faceboardIsShow;//表情键盘是否显示
@property (unsafe_unretained, nonatomic) BOOL padDidMovedUp;//是否已完成输入
@property (nonatomic, assign)            BOOL actionSheetShow;//是否显示自定义的actionSheet
@property (unsafe_unretained, nonatomic) BOOL foregroundKeyboardIsShow;//系统进入后台时键盘是否显示

@property (unsafe_unretained, nonatomic) CGRect keyboardBounds;
@property (unsafe_unretained, nonatomic) FaceToolBarType toolBarType;

@property(nonatomic,strong)NSString * stateString;
-(void)dismissKeyBoard;
-(void)disFaceKeyboard;

- (void)finishedInput;

-(id)initWithFrame:(CGRect)frame superView:(UIView *)superView withBarType:(FaceToolBarType)type;
@end
