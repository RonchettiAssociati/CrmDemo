// -----------------------------------------------------------------------------
//  Crm0401View.j
//  RoACrm
//
// 	Created by Bruno Ronchetti on May 13, 2010.
// 	Copyright 2010, Ronchetti & Associati All rights reserved.
// -----------------------------------------------------------------------------


@import <Foundation/CPObject.j>


@implementation Crm0401View : RoARoundedCornerView
{
	CPArray	id	buttons;
	float	id 	theWidth;
}

-(void)initWithFrame:(CGRect)aFrame
{
	self = [super initWithFrame:aFrame];
	if (self)
	{
		return self; 
	}
}

-(void)initialize
{

// GEOMETRY
//
	var theHeight 	= [self frame].size.height;
	var theWidth	= [self frame].size.width;
	var buttonSize = CGSizeMake(34,34);
	var ribbonHeight = KKRoAY1;

// SET-UP TOOLBAR
//
	
	var ribbonView = [[RoARoundedCornerView alloc] initWithFrame:CGRectMake(0,0,theWidth,KKRoAY1)];
	[ribbonView setBackgroundColor:KKRoALightGray];
	[ribbonView setAutoresizingMask:CPViewWidthSizable];
	[self addSubview:ribbonView];

/*	
	var directAccess = [[RoAFormField alloc] initWithLabelString:null];
	[directAccess setAutoresizingMask:CPViewMaxXMargin];
	[directAccess setOrigin:CGPointMake(5.0, 0.0)];
	[directAccess setType:KKRoAType];
	[directAccess setTargetView:self withAnchor:null];
	[directAccess setHelpDescriptor:["list", "database", KKRoAType, "single", 1]];
	[ribbonView addSubview:directAccess];
*/
	
	//[self enableButtons:[0]];
	[contentView addSubview:self];
}

-(void)tailorForUser
{
	var buttonIdentifiers = [KKRoARecordLevelActionButtons allKeys];
	var buttons = [];

	for (var i=0; i<[buttonIdentifiers count]; i++) {
		var buttonInfo = [KKRoARecordLevelActionButtons objectForKey:buttonIdentifiers[i]];
		
		var theCurrentButton = [[CrmButton alloc] initWithFrame:CGRectMake(0.0 ,0.0 ,80.0 ,24.0)];
		[theCurrentButton setBezelStyle:CPRegularSquareBezelStyle];
		if (buttonInfo[2] == "left") {
			[theCurrentButton setFrameOrigin:CGPointMake(buttonInfo[3], 3.0)];
			[theCurrentButton setAutoresizingMask:CPViewMaxXMargin];
		}
		else {
			[theCurrentButton setFrameOrigin:CGPointMake(theWidth+ buttonInfo[3], 3.0)];
			[theCurrentButton setAutoresizingMask:CPViewMinXMargin];
		}
		[theCurrentButton setTag:buttonInfo[0]];
		[theCurrentButton setTitle:buttonInfo[1]];
		
		if (buttonInfo[1] == "Nuovo")
		{
			[theCurrentButton setTitle:[KKRoAMenuButtons objectForKey:KKRoAType][5]];
			[theCurrentButton sizeToFit];
		}
			
		[theCurrentButton setTarget:self];
		[theCurrentButton setAction:@selector(buttonSelection:)];
		
		[buttons addObject:theCurrentButton];
		[self addSubview:theCurrentButton];
		
		if (KKRoAFormPrivileges != "pieni")
		{
			[self enableButtons:[]];
		}
	}
}


-(void)display
{
	[contentView addSubview:self];
}

-(void)enableButtons:(CPArray)buttonsToEnable
{
	for (var i=0; i<[buttons count]; i++)
	{
		[buttons[i] setEnabled:NO];
	}
	
	if (KKRoAFormPrivileges != "pieni")
	{
		return;
	}
	
	for (var j=0; j<[buttonsToEnable count]; j++)
	{
		[buttons[buttonsToEnable[j]] setEnabled:YES];
	}
}

-(CPArray)enabledButtons
{
	var enabledButtonsArray = [CPArray array];
	for (var i=0; i<[buttons count]; i++)
	{
		if ([buttons[i] isEnabled])
		{
			//alert("in enabledButtons "+i);
			[enabledButtonsArray addObject:i];
			//listProperties(enabledButtonsArray, "enabledButtonsArray");
		}
	}
	return enabledButtonsArray;
}


-(void)buttonSelection:(CPSender)aSender
{
	[crm04Controller buttonSelection:[aSender tag]];
}


-(void)animate:(CPSender)aSender
{
	//alert("animatebootone premuto");
}


@end