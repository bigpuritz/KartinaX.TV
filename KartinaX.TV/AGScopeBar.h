//
//  AGScopeBar.h
//  AGScopeBar
//
//  Created by Seth Willits on 6/25/12.
//  Copyright (c) 2012 Araelium Group. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@protocol AGScopeBarDelegate;
@class AGScopeBar;
@class AGScopeBarGroup;


typedef enum {
	AGScopeBarGroupSelectNone, // Momentary buttons
	AGScopeBarGroupSelectOne,  // Radio buttons
	AGScopeBarGroupSelectAny,  // Checkbox (0 or more)
	AGScopeBarGroupSelectAtLeastOne
} AGScopeBarGroupSelectionMode;





@interface AGScopeBarItem : NSObject
{
	NSString * mIdentifier;
	NSString * mTitle;
	NSString * mToolTip;
	NSImage * mImage;
	NSMenu * mMenu;
	BOOL mIsSelected;
	BOOL mIsEnabled;
	
	AGScopeBarGroup * __weak mGroup;
	NSButton * mButton;
	NSMenuItem * mMenuItem;
}

@property (weak, readonly) AGScopeBarGroup * group;
@property (readonly) NSString * identifier;
@property (readwrite, copy) NSString * title;
@property (readwrite, copy) NSImage * image;
@property (readwrite, strong) NSMenu * menu;
@property (readwrite, copy) NSString * toolTip;
@property (readonly) BOOL isSelected;
@property (readwrite, assign, getter=isEnabled) BOOL enabled;

+ (AGScopeBarItem *)itemWithIdentifier:(NSString *)identifier;
- (id)initWithIdentifier:(NSString *)identifier;

@end




@interface AGScopeBarGroup : NSObject
{
	NSString * mIdentifier;
	NSString * mLabel;
	BOOL mShowsSeparator;
	BOOL mCanBeCollapsed;
	AGScopeBarGroupSelectionMode mSelectionMode;
	NSArray * mItems;
	NSArray * mSelectedItems;
	
	AGScopeBar * __weak mScopeBar;
	NSView * mView;
	NSTextField * mLabelField;
	
	NSView * mCollapsedView;
	NSTextField * mCollapsedLabelField;
	NSPopUpButton * mPopupButton;
	BOOL mIsCollapsed;
}


@property (readonly) NSString * identifier;
@property (readwrite, strong) NSString * label;
@property (readwrite, assign) BOOL showsSeparator;
@property (readwrite, assign) BOOL canBeCollapsed;
@property (readwrite, assign) AGScopeBarGroupSelectionMode selectionMode;
@property (readwrite, copy) NSArray * items;
@property (weak, readonly) NSArray * selectedItems;

+ (AGScopeBarGroup *)groupWithIdentifier:(NSString *)identifier;
- (id)initWithIdentifier:(NSString *)identifier;

- (AGScopeBarItem *)addItemWithIdentifier:(NSString *)identifier title:(NSString *)title;
- (AGScopeBarItem *)insertItemWithIdentifier:(NSString *)identifier title:(NSString *)title atIndex:(NSUInteger)index;

- (void)addItem:(AGScopeBarItem *)item;
- (void)insertItem:(AGScopeBarItem *)item atIndex:(NSUInteger)index;
- (void)removeItemAtIndex:(NSUInteger)index;

- (AGScopeBarItem *)itemAtIndex:(NSUInteger)index;
- (AGScopeBarItem *)itemWithIdentifier:(NSString *)identifier;

- (void)setSelected:(BOOL)selected forItem:(AGScopeBarItem *)item;

@end




@interface AGScopeBar : NSView
{
	id<AGScopeBarDelegate> __unsafe_unretained mDelegate;
	BOOL mSmartResizeEnabled;
	NSView * mAccessoryView;
	NSArray * mGroups;
	NSColor * mBottomBorderColor;
	
	BOOL mNeedsTiling;
}


@property (readwrite, unsafe_unretained) IBOutlet id<AGScopeBarDelegate> delegate;
@property (readwrite, assign) BOOL smartResizeEnabled;
@property (readwrite, strong) NSView * accessoryView;
@property (readwrite, copy) NSArray * groups;

@property (readwrite, strong) NSColor * bottomBorderColor;
+ (CGFloat)scopeBarHeight;
- (void)smartResize;

- (AGScopeBarGroup *)addGroupWithIdentifier:(NSString *)identifier label:(NSString *)label items:(NSArray *)items;
- (AGScopeBarGroup *)insertGroupWithIdentifier:(NSString *)identifier label:(NSString *)label items:(NSArray *)items atIndex:(NSUInteger)index;

- (void)addGroup:(AGScopeBarGroup *)group;
- (void)insertGroup:(AGScopeBarGroup *)group atIndex:(NSUInteger)index;
- (void)removeGroupAtIndex:(NSUInteger)index;

- (AGScopeBarGroup *)groupContainingItem:(AGScopeBarItem *)item;
- (AGScopeBarGroup *)groupAtIndex:(NSUInteger)index;
- (AGScopeBarGroup *)groupWithIdentifier:(NSString *)identifier;

@end






@protocol AGScopeBarDelegate <NSObject>
@optional

- (void)scopeBar:(AGScopeBar *)theScopeBar item:(AGScopeBarItem *)item wasSelected:(BOOL)selected;

// If the following method is not implemented, all groups except the first will have a separator before them.
- (BOOL)scopeBar:(AGScopeBar *)theScopeBar showSeparatorBeforeGroup:(AGScopeBarGroup *)group;

@end

