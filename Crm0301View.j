// -----------------------------------------------------------------------------
//  Crm0301View.j
//  RoACrm01
//
// 	Created by Bruno Ronchetti on May 13, 2010.
// 	Copyright 2010, Ronchetti & Associati All rights reserved.
// -----------------------------------------------------------------------------


@import <Foundation/CPObject.j>
@import <RoAKit/RoARoundedCornerView.j>


@implementation Crm0301View : RoARoundedCornerView
{
	float			id	outlineRowHeight;

	CPArray			id	buttons;
	CPView			id	buttonBar;
	
	RoAFormField	id	directAccess;
}


-(void)initWithFrame:(CGRect)aFrame
{
	self = [super initWithFrame:aFrame];
	if (self)
	{	
		[self setBackgroundColor:KKRoABackgroundWhite];
		return self; 
	}
}

-(void)initialize
{
	// GEOMETRY
	//
	var outlineWidth = KKRoAX1-10;
	var ribbonHeight = KKRoAY1;
	
	var theHeight 	= [self frame].size.height;
	var theWidth	= [self frame].size.width;
	
	var buttonSize = CGSizeMake(34,34);
	
	var outlineRowHeight = 17.0;

	
	// SET-UP BACKGROUND
	
	// ------------------------------------------------------------------------
	// LEFT NAVIGATION BAR
	// ------------------------------------------------------------------------
	// LEFTVIEW
	//
		
	var ribbonView = [[RoARoundedCornerView alloc] initWithFrame:CGRectMake(0.0, 0.0, outlineWidth,KKRoAY1)];
	[ribbonView	setBackgroundColor:KKRoALightGray];
	[self addSubview:ribbonView];

	var sectionTitle = [[CPTextField alloc] initWithFrame:CGRectMake(10.0 ,5.0 ,outlineWidth,30.0)];
	[sectionTitle setStringValue:KKRoACaption];
	[sectionTitle setFont:[CPFont boldSystemFontOfSize:16]];
	[sectionTitle setTextColor:KKRoAHighlightBlue];
	[ribbonView addSubview:sectionTitle];
	
	var secondRibbonView = [[CPView alloc] initWithFrame:CGRectMake(0,KKRoAY1,outlineWidth,KKRoAY1)];
	[secondRibbonView setBackgroundColor:KKRoARibbonBackground];
	[self addSubview:secondRibbonView];
	
	var anchorView = [[CPView alloc] initWithFrame:CGRectMake(0.0, 0.0, 1.0, 1.0)];
	[anchorView setBackgroundColor:[CPColor clearColor]];
	[self addSubview:anchorView];
	
	var descriptor = {"type":KKRoAType, "label":"", "position":-120.0, "length":KKRoAX1-30.0, "placeholder":RoALocalized(@"Ricerca Alfabetica "+KKRoACaption), "help":["list", "database", KKRoAType, "single", 3]};
	var directAccess = [[RoAFormField alloc] initWithDescriptor:descriptor atYPosition:KKRoAY1+ 2.0];
	[directAccess setAutoresizingMask:CPViewMaxXMargin];
	[directAccess setCompletionDelegate:crm03Controller];
	[directAccess setTargetView:self withAnchor:anchorView];
	
	var crm03Scroll = [[CPScrollView alloc] initWithFrame:CGRectMake(0.0, KKRoAY1+KKRoAY1, outlineWidth, theHeight-KKRoAY1-KKRoAY2)];
	[crm03Scroll setAutoresizingMask:CPViewHeightSizable];
	[crm03Scroll setAutohidesScrollers:YES];
	[crm03Scroll setBackgroundColor:KKRoABackgroundWhite];
	[self addSubview:crm03Scroll positioned:CPWindowBelow relativeTo:anchorView];
	
	// buttonBar
	//
	var buttonBar =[[CPView alloc] initWithFrame:CGRectMake(0, theHeight-KKRoAY2,outlineWidth, KKRoAY2)];
	[buttonBar setAutoresizingMask:CPViewMinYMargin];
	[buttonBar setBackgroundColor:KKRoABottombarBackground];
	[self addSubview:buttonBar];
	
	
	// LEFTSCROLL & LEFTOUTLINE
				
	crm03Outline = [[CPOutlineViewNoKey alloc] initWithFrame:CGRectMake(0.0, 0.0, 0.0, 0.0)];
	[crm03Outline setAutoresizingMask:CPViewHeightSizable];
	[crm03Outline setHeaderView:null];
	[crm03Outline setCornerView:null];
	[crm03Outline setSelectionHighlightStyle:CPTableViewSelectionHighlightStyleRegular];	
	[crm03Outline setBackgroundColor:[CPColor clearColor]];	
	[crm03Outline setRowHeight:outlineRowHeight];
	
	var column = [[CPTableColumn alloc] initWithIdentifier:"OutlineColumn"];
	[column setEditable:NO];
	[column setWidth:[crm03Scroll bounds].size.width];
	
	var outlineItemView = [[Crm03OutlineItemView alloc] initWithFrame:CGRectMake(0,0, KKRoAX1, outlineRowHeight)]; 

	[column setDataView:outlineItemView];
	[crm03Outline setIndentationPerLevel:12];
	
	[crm03Outline addTableColumn:column];
	[crm03Outline setOutlineTableColumn:column];
	
	[crm03Outline setDelegate:self];
    [crm03Outline setDataSource:crm03Controller];
	[crm03Scroll setDocumentView:crm03Outline];
	
	var border = [[CPView alloc] initWithFrame:CGRectMake(KKRoAX1-1,0,1,theHeight)];
	[border setBackgroundColor:KKRoAMediumGray];
	[border setAutoresizingMask:CPViewHeightSizable];
	//[self addSubview:border];

}

-(void)tailorForUser
{
	var buttonIdentifiers = [KKRoAButtonBarButtons allKeys];
	var buttons = [];

	for (var i=0; i<[buttonIdentifiers count]; i++)
	{
		var buttonInfo = [KKRoAButtonBarButtons objectForKey:buttonIdentifiers[i]];
		
		var buttonBarButton = [[CPButton alloc] initWithFrame:CGRectMake(2+ i*34 ,0,28,29)];
		[buttonBarButton setTag:buttonInfo[0]];
		[buttonBarButton setTheme:nil];
		[buttonBarButton setTitle:buttonInfo[1]];
		[buttonBarButton setFont:[CPFont boldSystemFontOfSize:buttonInfo[3]]];
		[buttonBarButton setTarget:crm03Controller];
		[buttonBarButton setAction:@selector(updateLists:)];
		[buttonBarButton setEnabled:NO];
		[buttonBarButton setValue:KKRoAMediumLightGray forThemeAttribute:@"text-color" inState:CPThemeStateDisabled];
		[buttonBarButton setValue:KKRoAMediumBlue forThemeAttribute:@"text-color" inState:CPThemeStateNormal];
		[buttonBarButton setValue:KKRoAHighlightBlue forThemeAttribute:@"text-color" inState:CPThemeStateHighlighted];
		
		[buttons addObject:buttonBarButton];
		[buttonBar addSubview:buttonBarButton];
	}
}


-(void)display
{
	[contentView addSubview:self];
}



-(void)outlineViewSelectionDidChange:(CPNotification)aNotification
{
	//alert("in crm0301view oulineViewselectiondidicahnge");
	[self enableButtons:aNotification];
	var selection = [crm03Outline itemAtRow:[[crm03Outline selectedRowIndexes] firstIndex]];
		
	if (selection == "Liste Utente")
	{
		if (KKRoAUserPrivileges == "pieni")
		{
			[buttons[1] setEnabled:YES];
		}
	}
	else 
	{	
		[crm03Controller listSelection:selection];
	}
	
}


-(void)enableButtons:(CPNotification)aNotification
{
	//alert(KKRoAUserPrivileges);
	if (KKRoAUserPrivileges != "pieni")
	{
		return;
	}
		
	var selection = [crm03Outline itemAtRow:[[crm03Outline selectedRowIndexes] firstIndex]];
	var parent = [crm03Outline parentForItem:selection];

	var shouldBeEnabled = (selection && parent != null) ?  true : false;
	for (var i=0; i<[buttons count]; i++)
	{
		[buttons[i] setEnabled:shouldBeEnabled];
	}
}

-(void)formDidChange
{
}

-(void)clearDirectAccess
{
	[directAccess setScreenValue:""];
}

@end



// +++++++++++++++++++++++++++++++++++++++++++++++
// +++++++++++++++++++++++++++++++++++++++++++++++



@implementation CPOutlineViewNoKey : CPOutlineView
{	
}

-(bool)canBecomeKeyView
{
	return NO;
}

@end


@implementation Crm03OutlineItemView : CPView
{	
	CPTextField 	id textField;
}

- (void)setObjectValue:(id)anObject
{
	[[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
	
	var outlineRowHeight = [self frame].size.height;

	var textField = [[CPTextField alloc] initWithFrame:CGRectMake(0,0,KKRoAX1-40,outlineRowHeight)];
	[textField setStringValue:anObject];
	[textField setEditable:NO];	
	[textField setTextColor:KKRoAOutlineLabelColor];
	[textField setFont:KKRoAOutlineTextFont];
	[self addSubview:textField];
	
	var aValue = null;
	if ([[crm03Controller crm03Tree] objectForKey:anObject].representedObject)
	{
		aValue = 	[[crm03Controller crm03Tree] objectForKey:anObject].representedObject["value"];
	}
	
	if(aValue && aValue > 0)
	{
		var width = [self frame].size.width;
		var badge =	[[BRoBadge alloc] initWithFrame:CGRectMake(width-42.0, 2.0, 40.0, outlineRowHeight)];
		var badgeField = [[CPTextField alloc] initWithFrame:CGRectMake(width-47.0, 1.0, 40.0, outlineRowHeight)];

		[badgeField setStringValue:aValue];
		[badgeField setEditable:NO];
		[badgeField setValue:CPRightTextAlignment forThemeAttribute:@"alignment"];
		[badgeField setFont:[CPFont systemFontOfSize:11]];
		[badgeField setTextColor:KKRoAMediumGray];
	
		[self addSubview:badge];
		[self addSubview:badgeField];
	}
}
 
-(void)mouseEntered:(CPEvent)anEvent
{
	[self setBackgroundColor:KKRoAPreSelectionBlue];
	[textField setTextColor:[CPColor whiteColor]];
}

-(void)mouseExited:(CPEvent)anEvent
{
	//if ([textField stringValue] != [[self superview] itemAtRow:[[crm03Outline selectedRowIndexes] firstIndex]])
	//{
		[self setBackgroundColor:[CPColor clearColor]];
		[textField setTextColor:KKRoAOutlineLabelColor];
	//}
}


@end

// +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// 

@implementation BRoBadge : CPTextField
{
}
 
- (id)initWithFrame:(CGRect)aFrame
{
    self = [super initWithFrame:aFrame];
	
    if (self) {
        [self setBordered:NO];
 	}
    return self;
}
 
 
- (void)drawRect:(CGRect)aRect
{
	var context = [[CPGraphicsContext currentContext] graphicsPort];
	var radius = 7;
	var color = KKRoAVeryVeryLightGray; 
							
	CGContextBeginPath(context);
	
	CGContextAddArc(context, 30, radius, radius, Math.PI / 2 , 3 * Math.PI / 2, 0);
	CGContextAddArc(context, 10, radius, radius, 3 * Math.PI / 2, Math.PI / 2, 0);
	
	CGContextClosePath(context);
	CGContextSetFillColor(context, color);
	CGContextFillPath(context);
	CGContextRestoreGState(context);
}


@end

