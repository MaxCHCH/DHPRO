//
//  NARUICollectionViewFlowLayout.h
//  自定义Layout
//
//  Created by xinglei on 14/11/27.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const WaterFallSectionHeader;
/// A supplementary view that identifies the footer for a given section.
extern NSString *const WaterFallSectionFooter;

#pragma mark WaterF
@protocol NARLayoutDelegate <UICollectionViewDelegate>

@optional

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;

//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForHeaderInSection:(NSInteger)section;
//
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForFooterInSection:(NSInteger)section;
@end

@interface NARUICollectionViewFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, assign) NSInteger columnCount;

@property (nonatomic, assign) CGFloat minimumColumnSpacing;

@property (nonatomic, assign) CGFloat minimum_InteritemSpacing;

@property (nonatomic, assign) CGFloat headerHeight;

@property (nonatomic, assign) CGFloat footerHeight;

@property (nonatomic, assign) UIEdgeInsets sectionInset;

@end
