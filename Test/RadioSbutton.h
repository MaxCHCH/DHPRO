//
//  RadioSbutton.h
//  Test
//
//  Created by Rillakkuma on 2017/2/8.
//  Copyright © 2017年 Rillakkuma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RadioSbutton : UIButton
// Outlet collection of links to other buttons in the group.
@property (nonatomic, strong) IBOutletCollection(RadioSbutton) NSArray* groupButtons;

// Currently selected radio button in the group.
// If there are multiple buttons selected then it returns the first one.
@property (nonatomic, readonly) RadioSbutton* selectedButton;

// If selected==YES, then it selects the button and deselects other buttons in the group.
// If selected==NO, then it deselects the button and if there are only two buttons in the group, then it selects second.
-(void) setSelected:(BOOL)selected;

// Find first radio with given tag and makes it selected.
// All of other buttons in the group become deselected.
-(void) setSelectedWithTag:(NSInteger)tag;

-(void) deselectAllButtons;

@end
