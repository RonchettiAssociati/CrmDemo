/*
 * RoATabView.j
 * AppKit
 *
 * Created by Francisco Tolmasky.
 * Copyright 2008, 280 North, Inc.
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
 *
 *
 * pulled from RoATabView at version 0.8.1 of the framework
 *
 */

//@import "CPImageView.j"
@import "RoATabViewItem.j"
//@import "CPView.j"

//include "CoreGraphics/CGGeometry.h"


/*
    Places tabs on top with a bezeled border.
    @global
    @group RoATabViewType
*/
CPTopTabsBezelBorder     = 0;
//CPLeftTabsBezelBorder    = 1;
//CPBottomTabsBezelBorder  = 2;
//CPRightTabsBezelBorder   = 3;
/*
    Displays no tabs and has a bezeled border.
    @global
    @group RoATabViewType
*/
CPNoTabsBezelBorder      = 4;
/*
    Has no tabs and displays a line border.
    @global
    @group RoATabViewType
*/
CPNoTabsLineBorder       = 5;
/*
    Displays no tabs and no border.
    @global
    @group RoATabViewType
*/
CPNoTabsNoBorder         = 6;

var RoATabViewBezelBorderLeftImage       = nil,
    RoATabViewBackgroundCenterImage      = nil,
    RoATabViewBezelBorderRightImage      = nil,
    RoATabViewBezelBorderColor           = nil,
    RoATabViewBezelBorderBackgroundColor = nil;

var LEFT_INSET  = 7.0,
    RIGHT_INSET = 7.0;
    
var RoATabViewDidSelectTabViewItemSelector           = 1,
    RoATabViewShouldSelectTabViewItemSelector        = 2,
    RoATabViewWillSelectTabViewItemSelector          = 4,
    RoATabViewDidChangeNumberOfTabViewItemsSelector  = 8;

/*! 
    @ingroup appkit
    @class RoATabView

    This class represents a view that has multiple subviews (RoATabViewItem) presented as individual tabs.
    Only one RoATabViewItem is shown at a time, and other RoATabViewItems can be made visible
    (one at a time) by clicking on the RoATabViewItem's tab at the top of the tab view.
    
    THe currently selected RoATabViewItem is the view that is displayed.
*/
@implementation RoATabView : CPView
{
    CPView          _labelsView;
    CPView          _backgroundView;
    CPView          _separatorView;
    
    CPView          _auxiliaryView;
    CPView          _contentView;
    
    CPArray         _tabViewItems;
    RoATabViewItem   _selectedTabViewItem;

    RoATabViewType   _tabViewType;
    
    id              _delegate;
    unsigned        _delegateSelectors;
}

/*
    @ignore
*/
+ (void)initialize
{
    if (self != RoATabView)
        return;
    
    var bundle = [CPBundle bundleForClass:self],
        
        emptyImage = [[CPImage alloc] initByReferencingFile:@"" size:CGSizeMake(7.0, 0.0)],
        backgroundImage = [[CPImage alloc] initWithContentsOfFile:@"Resources/RoATabViewBezelBackgroundCenter.png" size:CGSizeMake(1.0, 1.0)],
        
        bezelBorderLeftImage = [[CPImage alloc] initWithContentsOfFile:@"Resources/RoATabViewBezelBorderLeft.png" size:CGSizeMake(7.0, 1.0)],
        bezerBorderImage = [[CPImage alloc] initWithContentsOfFile:@"Resources/RoATabViewBezelBorder.png" size:CGSizeMake(1.0, 1.0)],
        bezelBorderRightImage = [[CPImage alloc] initWithContentsOfFile:@"Resources/RoATabViewBezelBorderRight.png" size:CGSizeMake(7.0, 1.0)];
    
    RoATabViewBezelBorderBackgroundColor = [CPColor colorWithPatternImage:[[CPNinePartImage alloc] initWithImageSlices:
        [
            emptyImage, 
            emptyImage, 
            emptyImage,

            bezelBorderLeftImage,
            backgroundImage,
            bezelBorderRightImage,

            bezelBorderLeftImage,
            bezerBorderImage,
            bezelBorderRightImage
        ]]];
    
    RoATabViewBezelBorderColor = [CPColor colorWithPatternImage:bezerBorderImage];
}

/*
    @ignore
*/
+ (CPColor)bezelBorderColor
{
    return RoATabViewBezelBorderColor;
}

- (id)initWithFrame:(CGRect)aFrame
{
    self = [super initWithFrame:aFrame];
    
    if (self)
    {
        _tabViewType = CPTopTabsBezelBorder;
        _tabViewItems = [];
    }
    
    return self;
}

- (void)viewDidMoveToWindow
{
    if (_tabViewType != CPTopTabsBezelBorder || _labelsView)
        return;
        
    [self _createBezelBorder];
    [self layoutSubviews];
}

/* @ignore */
- (void)_createBezelBorder
{
    var bounds = [self bounds];
    
    _labelsView = [[_CPTabLabelsView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(bounds), 0.0)];

    [_labelsView setTabView:self];
    [_labelsView setAutoresizingMask:CPViewWidthSizable];

    [self addSubview:_labelsView];

    _backgroundView = [[CPView alloc] initWithFrame:CGRectMakeZero()];        
    
    [_backgroundView setBackgroundColor:RoATabViewBezelBorderBackgroundColor];

    [_backgroundView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
    
    [self addSubview:_backgroundView];
    
    _separatorView = [[CPView alloc] initWithFrame:CGRectMakeZero()];

    [_separatorView setBackgroundColor:[[self class] bezelBorderColor]];
	[_separatorView setAutoresizingMask:CPViewWidthSizable | CPViewMaxYMargin];
    
    [self addSubview:_separatorView];
}

/*
    Lays out the subviews
    @ignore
*/
- (void)layoutSubviews
{
    if (_tabViewType == CPTopTabsBezelBorder)
    {
        var backgroundRect = [self bounds],
            labelsViewHeight = [_CPTabLabelsView height];
        
        backgroundRect.origin.y += labelsViewHeight;
        backgroundRect.size.height -= labelsViewHeight;
        
        [_backgroundView setFrame:backgroundRect];
        
        var auxiliaryViewHeight = 0.0;
        
        if (_auxiliaryView)
        {
            auxiliaryViewHeight = CGRectGetHeight([_auxiliaryView frame]);
            
            [_auxiliaryView setFrame:CGRectMake(LEFT_INSET, labelsViewHeight, CGRectGetWidth(backgroundRect) - LEFT_INSET - RIGHT_INSET, auxiliaryViewHeight)];
        }
        
        [_separatorView setFrame:CGRectMake(LEFT_INSET, labelsViewHeight + auxiliaryViewHeight, CGRectGetWidth(backgroundRect) - LEFT_INSET - RIGHT_INSET, 5.0)];
		
		[_separatorView setBackgroundColor:KKRoASelectedBlue];
    }

    // CPNoTabsNoBorder
    [_contentView setFrame:[self contentRect]];
}

// Adding and Removing Tabs
/*!
    Adds a RoATabViewItem to the tab view.
    @param aTabViewItem the item to add
*/
- (void)addTabViewItem:(RoATabViewItem)aTabViewItem
{
    [self insertTabViewItem:aTabViewItem atIndex:[_tabViewItems count]];
}

/*!
    Inserts a RoATabViewItem into the tab view
    at the specified index.
    @param aTabViewItem the item to insert
    @param anIndex the index for the item
*/
- (void)insertTabViewItem:(RoATabViewItem)aTabViewItem atIndex:(unsigned)anIndex
{
    if (!_labelsView && _tabViewType == CPTopTabsBezelBorder)
        [self _createBezelBorder];
    
    [_tabViewItems insertObject:aTabViewItem atIndex:anIndex];
    
    [_labelsView tabView:self didAddTabViewItem:aTabViewItem];
    
    [aTabViewItem _setTabView:self];
    
    if ([_tabViewItems count] == 1)
        [self selectFirstTabViewItem:self];

    if (_delegateSelectors & RoATabViewDidChangeNumberOfTabViewItemsSelector)
        [_delegate tabViewDidChangeNumberOfTabViewItems:self];
}

/*!
    Removes the specified tab view item from the tab view.
    @param aTabViewItem the item to remove
*/
- (void)removeTabViewItem:(RoATabViewItem)aTabViewItem
{
    var index = [self indexOfTabViewItem:aTabViewItem];

    [_tabViewItems removeObjectIdenticalTo:aTabViewItem];
    
    [_labelsView tabView:self didRemoveTabViewItemAtIndex:index];
    
    [aTabViewItem _setTabView:nil];
    
    if (_delegateSelectors & RoATabViewDidChangeNumberOfTabViewItemsSelector)
        [_delegate tabViewDidChangeNumberOfTabViewItems:self];
}

// Accessing Tabs
/*!
    Returns the index of the specified item
    @param aTabViewItem the item to find the index for
*/
- (int)indexOfTabViewItem:(RoATabViewItem)aTabViewItem
{
    return [_tabViewItems indexOfObjectIdenticalTo:aTabViewItem];
}

/*!
    Returns the index of the RoATabViewItem with the specified identifier.
    @param anIdentifier the identifier of the item
*/
- (int)indexOfTabViewItemWithIdentifier:(CPString)anIdentifier
{
    var index = 0,
        count = [_tabViewItems count];
        
    for (; index < count; ++index)
        if ([[_tabViewItems[index] identifier] isEqual:anIdentifier])
            return index;

    return index;
}

/*!
    Returns the number of items in the tab view.
*/
- (unsigned)numberOfTabViewItems
{
    return [_tabViewItems count];
}

/*!
    Returns the RoATabViewItem at the specified index.
*/
- (RoATabViewItem)tabViewItemAtIndex:(unsigned)anIndex
{
    return _tabViewItems[anIndex];
}

/*!
    Returns the array of items that backs this tab view.
*/
- (CPArray)tabViewItems
{
    return _tabViewItems;
}

// Selecting a Tab
/*!
    Sets the first tab view item in the array to be displayed to the user.
    @param aSender the object making this request
*/
- (void)selectFirstTabViewItem:(id)aSender
{
    var count = [_tabViewItems count];
    
    if (count)
        [self selectTabViewItemAtIndex:0];
}

/*!
    Sets the last tab view item in the array to be displayed to the user.
    @param aSender the object making this request
*/
- (void)selectLastTabViewItem:(id)aSender
{
    var count = [_tabViewItems count];
    
    if (count)
        [self selectTabViewItemAtIndex:count - 1];
}

/*!
    Sets the next tab item in the array to be displayed.
    @param aSender the object making this request
*/
- (void)selectNextTabViewItem:(id)aSender
{
    if (!_selectedTabViewItem)
        return;
    
    var index = [self indexOfTabViewItem:_selectedTabViewItem],
        count = [_tabViewItems count];
    
    [self selectTabViewItemAtIndex:index + 1 % count];
}

/*!
    Selects the previous item in the array for display.
    @param aSender the object making this request
*/
- (void)selectPreviousTabViewItem:(id)aSender
{
    if (!_selectedTabViewItem)
        return;
    
    var index = [self indexOfTabViewItem:_selectedTabViewItem],
        count = [_tabViewItems count];
    
    [self selectTabViewItemAtIndex:index == 0 ? count : index - 1];
}



/*!
    Displays the specified item in the tab view.
    @param aTabViewItem the item to display
*/
- (void)selectTabViewItem:(RoATabViewItem)aTabViewItem
{
    if ((_delegateSelectors & RoATabViewShouldSelectTabViewItemSelector) && ![_delegate tabView:self shouldSelectTabViewItem:aTabViewItem])
        return;
        
    if (_delegateSelectors & RoATabViewWillSelectTabViewItemSelector)
        [_delegate tabView:self willSelectTabViewItem:aTabViewItem];

    if (_selectedTabViewItem)
    {
        _selectedTabViewItem._tabState = CPBackgroundTab;
        [_labelsView tabView:self didChangeStateOfTabViewItem:_selectedTabViewItem];
        
        [_contentView removeFromSuperview];
        [_auxiliaryView removeFromSuperview];
    }
    _selectedTabViewItem = aTabViewItem;
    
    _selectedTabViewItem._tabState = CPSelectedTab;
        
    _contentView = [_selectedTabViewItem view];
    [_contentView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
    
    _auxiliaryView = [_selectedTabViewItem auxiliaryView];
    [_auxiliaryView setAutoresizingMask:CPViewWidthSizable];
    
    [self addSubview:_contentView];

    if (_auxiliaryView)
        [self addSubview:_auxiliaryView];
    
    [_labelsView tabView:self didChangeStateOfTabViewItem:_selectedTabViewItem];
    
    [self layoutSubviews];
    
    if (_delegateSelectors & RoATabViewDidSelectTabViewItemSelector)
        [_delegate tabView:self didSelectTabViewItem:aTabViewItem];
}

/*!
    Selects the item at the specified index.
    @param anIndex the index of the item to display.
*/
- (void)selectTabViewItemAtIndex:(unsigned)anIndex
{
    [self selectTabViewItem:_tabViewItems[anIndex]];
}

/*!
    Returns the current item being displayed.
*/
- (RoATabViewItem)selectedTabViewItem
{
    return _selectedTabViewItem;
}

// 
/*!
    Sets the tab view type.
    @param aTabViewType the view type
*/
- (void)setTabViewType:(RoATabViewType)aTabViewType
{
    if (_tabViewType == aTabViewType)
        return;
    
    _tabViewType = aTabViewType;
    
    if (_tabViewType == CPNoTabsBezelBorder || _tabViewType == CPNoTabsLineBorder || _tabViewType == CPNoTabsNoBorder)
        [_labelsView removeFromSuperview];
    else if (![_labelsView superview])
        [self addSubview:_labelsView];
        
    if (_tabViewType == CPNoTabsLineBorder || _tabViewType == CPNoTabsNoBorder)
        [_backgroundView removeFromSuperview];
    else if (![_backgroundView superview])
        [self addSubview:_backgroundView];
    
    [self layoutSubviews];
}

/*!
    Returns the tab view type.
*/
- (RoATabViewType)tabViewType
{
    return _tabViewType;
}

// Determining the Size
/*!
    Returns the content rectangle.
*/
- (CGRect)contentRect
{
    var contentRect = CGRectMakeCopy([self bounds]);
    
    if (_tabViewType == CPTopTabsBezelBorder)
    {
        var labelsViewHeight = [_CPTabLabelsView height],
            auxiliaryViewHeight = _auxiliaryView ? CGRectGetHeight([_auxiliaryView frame]) : 5.0,
            separatorViewHeight = 1.0;

        contentRect.origin.y += labelsViewHeight + auxiliaryViewHeight + separatorViewHeight;
        contentRect.size.height -= labelsViewHeight + auxiliaryViewHeight + separatorViewHeight * 2.0; // 2 for the bottom border as well.
        
        contentRect.origin.x += LEFT_INSET;
        contentRect.size.width -= LEFT_INSET + RIGHT_INSET;
    }

    return contentRect;
}

/*!
    Returns the receiver's delegate.
*/
- (id)delegate
{
    return _delegate;
}

/*!
    Sets the delegate for this tab view.
    @param aDelegate the tab view's delegate
*/
- (void)setDelegate:(id)aDelegate
{
    if (_delegate == aDelegate)
        return;
    
    _delegate = aDelegate;
    
    _delegateSelectors = 0;

    if ([_delegate respondsToSelector:@selector(tabView:shouldSelectTabViewItem:)])
        _delegateSelectors |= RoATabViewShouldSelectTabViewItemSelector;

    if ([_delegate respondsToSelector:@selector(tabView:willSelectTabViewItem:)])
        _delegateSelectors |= RoATabViewWillSelectTabViewItemSelector;

    if ([_delegate respondsToSelector:@selector(tabView:didSelectTabViewItem:)])
        _delegateSelectors |= RoATabViewDidSelectTabViewItemSelector;

    if ([_delegate respondsToSelector:@selector(tabViewDidChangeNumberOfTabViewItems:)])
        _delegateSelectors |= RoATabViewDidChangeNumberOfTabViewItemsSelector;    
}

//

- (void)mouseDown:(CPEvent)anEvent
{
    var location = [_labelsView convertPoint:[anEvent locationInWindow] fromView:nil],
        tabViewItem = [_labelsView representedTabViewItemAtPoint:location];
        
    if (tabViewItem)
        [self selectTabViewItem:tabViewItem];
}

@end






var RoATabViewItemsKey               = "RoATabViewItemsKey",
    RoATabViewSelectedItemKey        = "RoATabViewSelectedItemKey",
    RoATabViewTypeKey                = "RoATabViewTypeKey",
    RoATabViewDelegateKey            = "RoATabViewDelegateKey";

@implementation RoATabView (CPCoding)

- (id)initWithCoder:(CPCoder)aCoder
{
    if (self = [super initWithCoder:aCoder])
    {
        _tabViewType    = [aCoder decodeIntForKey:RoATabViewTypeKey];
        _tabViewItems   = [];
        
        // FIXME: this is somewhat hacky
        [self _createBezelBorder];
        
        var items = [aCoder decodeObjectForKey:RoATabViewItemsKey];
        for (var i = 0; items && i < items.length; i++)
            [self insertTabViewItem:items[i] atIndex:i];
    
        var selected = [aCoder decodeObjectForKey:RoATabViewSelectedItemKey];
        if (selected)
            [self selectTabViewItem:selected];
        
        [self setDelegate:[aCoder decodeObjectForKey:RoATabViewDelegateKey]];
    }

    return self;
}

- (void)encodeWithCoder:(CPCoder)aCoder
{
    var actualSubviews = _subviews;
    _subviews = [];
    [super encodeWithCoder:aCoder];
    _subviews = actualSubviews;
    
    [aCoder encodeObject:_tabViewItems forKey:RoATabViewItemsKey];;
    [aCoder encodeObject:_selectedTabViewItem forKey:RoATabViewSelectedItemKey];
    
    [aCoder encodeInt:_tabViewType forKey:RoATabViewTypeKey];
    
    [aCoder encodeConditionalObject:_delegate forKey:RoATabViewDelegateKey];
}

@end






var _CPTabLabelsViewBackgroundColor = nil,
    _CPTabLabelsViewInsideMargin    = 10.0,
    _CPTabLabelsViewOutsideMargin   = 15.0;


@implementation _CPTabLabelsView : CPView
{
    RoATabView       _tabView;
    CPDictionary    _tabLabels;
}

+ (void)initialize
{
    if (self != [_CPTabLabelsView class])
        return;

    var bundle = [CPBundle bundleForClass:self];
		
	_CPTabLabelsViewBackgroundColor = [contentView backgroundColor];

	
/*
    _CPTabLabelsViewBackgroundColor = [CPColor colorWithPatternImage:[[CPThreePartImage alloc] initWithImageSlices:
        [
            [[CPImage alloc] initWithContentsOfFile:@"Resources/RoATabLabelsViewLeft.png" size:CGSizeMake(12.0, 40.0)],
            [[CPImage alloc] initWithContentsOfFile:@"Resources/RoATabLabelsViewCenter.png" size:CGSizeMake(1.0, 40.0)],
            [[CPImage alloc] initWithContentsOfFile:@"Resources/RoATabLabelsViewRight.png" size:CGSizeMake(12.0, 40.0)]
        ] isVertical:NO]];
*/
}

+ (float)height
{
    //return 26.0;
    return 40.0;
}

- (id)initWithFrame:(CGRect)aFrame
{
    self = [super initWithFrame:aFrame];
    
    if (self)
    {
        _tabLabels = [];
        
        [self setBackgroundColor:_CPTabLabelsViewBackgroundColor];

        //[self setFrameSize:CGSizeMake(CGRectGetWidth(aFrame), 26.0)];
        [self setFrameSize:CGSizeMake(CGRectGetWidth(aFrame), 40.0)];

    }
    
    return self;
}

- (void)setTabView:(RoATabView)aTabView
{
    _tabView = aTabView;
}

- (RoATabView)tabView
{
    return _tabView;
}

- (void)tabView:(RoATabView)aTabView didAddTabViewItem:(RoATabViewItem)aTabViewItem
{
    var label = [[_CPTabLabel alloc] initWithFrame:CGRectMakeZero()];
    
    [label setTabViewItem:aTabViewItem];
    
    _tabLabels.push(label);
    
    [self addSubview:label];
        
    [self layoutSubviews];
}

- (void)tabView:(RoATabView)aTabView didRemoveTabViewItemAtIndex:(unsigned)index
{
    var label = _tabLabels[index];
    
    [_tabLabels removeObjectAtIndex:index];

    [label removeFromSuperview];
    
    [self layoutSubviews];
}

 -(void)tabView:(RoATabView)aTabView didChangeStateOfTabViewItem:(RoATabViewItem)aTabViewItem
 {
    [_tabLabels[[aTabView indexOfTabViewItem:aTabViewItem]] setTabState:[aTabViewItem tabState]];
 }

- (RoATabViewItem)representedTabViewItemAtPoint:(CGPoint)aPoint
{
    var index = 0,
        count = _tabLabels.length;
        
    for (; index < count; ++index)
    {
        var label = _tabLabels[index];
    
        if (CGRectContainsPoint([label frame], aPoint))
            return [label tabViewItem];
    }

    return nil;
}

- (void)layoutSubviews
{
    var index = 0,
        count = _tabLabels.length,
        width = (CGRectGetWidth([self bounds]) - (count - 1) * _CPTabLabelsViewInsideMargin - 2 * _CPTabLabelsViewOutsideMargin) / count,
        x = _CPTabLabelsViewOutsideMargin;
    
    for (; index < count; ++index)
    {
        var label = _tabLabels[index],
            frame = CGRectMake(x, 8.0, width, 32.0);    //<++++++++++  18
        
        [label setFrame:frame];
        
        x = CGRectGetMaxX(frame) + _CPTabLabelsViewInsideMargin;
    }
}

- (void)setFrameSize:(CGSize)aSize
{
    if (CGSizeEqualToSize([self frame].size, aSize))
        return;
    
    [super setFrameSize:aSize];
    
    [self layoutSubviews];
}

@end




var _CPTabLabelBackgroundColor          = nil,
    _CPTabLabelSelectedBackgroundColor  = nil;


@implementation _CPTabLabel : RoARoundedCornerView
{
    RoATabViewItem   _tabViewItem;
    CPTextField     _labelField;
}

+ (void)initialize
{
    if (self != [_CPTabLabel class])
        return;

    var bundle = [CPBundle bundleForClass:self];
 
	_CPTabLabelBackgroundColor =  KKRoALightGray;
	_CPTabLabelSelectedBackgroundColor = KKRoASelectedBlue;
		
/*
    _CPTabLabelBackgroundColor = [CPColor colorWithPatternImage:[[CPThreePartImage alloc] initWithImageSlices:
        [
            [[CPImage alloc] initWithContentsOfFile:@"Resources/RoATabLabelBackgroundLeft.png" size:CGSizeMake(6.0, 38.0)],
            [[CPImage alloc] initWithContentsOfFile:@"Resources/RoATabLabelBackgroundCenter.png" size:CGSizeMake(1.0, 38.0)],
            [[CPImage alloc] initWithContentsOfFile:@"Resources/RoATabLabelBackgroundRight.png" size:CGSizeMake(6.0, 38.0)]
        ] isVertical:NO]];
    
    _CPTabLabelSelectedBackgroundColor = [CPColor colorWithPatternImage:[[CPThreePartImage alloc] initWithImageSlices:
        [
            [[CPImage alloc] initWithContentsOfFile:@"Resources/RoATabLabelSelectedLeft.png" size:CGSizeMake(3.0, 24.0)],
            [[CPImage alloc] initWithContentsOfFile:@"Resources/RoATabLabelSelectedCenter.png" size:CGSizeMake(1.0, 24.0)],
            [[CPImage alloc] initWithContentsOfFile:@"Resources/RoATabLabelSelectedRight.png" size:CGSizeMake(3.0, 24.0)]
        ] isVertical:NO]];
*/
}

- (id)initWithFrame:(CGRect)aFrame
{
    self = [super initWithFrame:aFrame];
    
    if (self)
    {   
        _labelField = [[CPTextField alloc] initWithFrame:CGRectMakeZero()];
        
        [_labelField setAlignment:CPCenterTextAlignment];
        [_labelField setFrame:CGRectMake(5.0, 8.0, CGRectGetWidth(aFrame) - 10.0, 28.0)];
        [_labelField setAutoresizingMask:CPViewWidthSizable];
        [_labelField setFont:[CPFont boldSystemFontOfSize:12]];
        [_labelField setTextColor:KKRoALabelColor];

        [self addSubview:_labelField];
        
        [self setTabState:CPBackgroundTab];
    }
    
    return self;
}

- (void)setTabState:(CPTabState)aTabState
{
    [self setBackgroundColor:aTabState == CPSelectedTab ? _CPTabLabelSelectedBackgroundColor : _CPTabLabelBackgroundColor];
	[_labelField setTextColor:aTabState == CPSelectedTab ? [CPColor whiteColor] : KKRoALabelColor];
	[self setNeedsDisplay:YES];
}

- (void)setTabViewItem:(RoATabViewItem)aTabViewItem
{
    _tabViewItem = aTabViewItem;
    
    [self update];
}

- (RoATabViewItem)tabViewItem
{
    return _tabViewItem;
}

- (void)update
{
    [_labelField setStringValue:[_tabViewItem label]];
}

@end