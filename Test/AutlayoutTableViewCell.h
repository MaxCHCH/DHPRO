//
//  AutlayoutTableViewCell.h
//  Test
//
//  Created by Rillakkuma on 2016/10/27.
//  Copyright © 2016年 Rillakkuma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LxGridViewFlowLayout.h"
#import "TZImagePickerController.h"
#import "TZTestCell.h"
#import "UIView+Layout.h"
@interface AutlayoutTableViewCell : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegate>
{
	UIImageView *_view0;
	UILabel *_view1;
	UIButton *_view2;
	
	NSMutableArray *_selectedPhotos;
	NSMutableArray *_selectedAssets;
	CGFloat _itemWH;
	CGFloat _margin;
	LxGridViewFlowLayout *_layout;
	
}
@property (nonatomic, strong)UIButton *buttonAddImage;
@property (nonatomic, strong) UICollectionView *collectionView;

@end
