//
//  FacialView.h
//  iSport
//
//  Created by Steve Wang on 13-5-27.
//  Copyright (c) 2013年 cnfol. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EmojiEmoticons.h"
#import "Emoji.h"
#import "EmojiMapSymbols.h"
#import "EmojiPictographs.h"
#import "EmojiTransport.h"

@protocol facialViewDelegate

-(void)selectedFacialView:(NSString*)str;

@end


@interface FacialView : UIView

@property(nonatomic,assign) id<facialViewDelegate> delegate;
@property (strong, nonatomic) NSArray *faces;

-(void)loadFacialView:(int)page size:(CGSize)size;

@end
