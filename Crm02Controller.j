// -----------------------------------------------------------------------------
//  Crm02Controller.j
//  RoACrm
//
// 	Created by Bruno Ronchetti on May 13, 2010.
// 	Copyright 2010, Ronchetti & Associati All rights reserved.
// -----------------------------------------------------------------------------


@import <Foundation/CPObject.j>
@import "Crm0201View.j"
@import "Crm0202View.j"
@import "Crm0203View.j"


@implementation Crm02Controller : CPObject
{
	//CPNotificationCenter 	id appNotificationCenter 	@accessors;
	Crm0201View				id crm0201View;
	Crm0202View				id crm0202View;
	Crm0203View				id crm0203View 	@accessors;
	CPArray					id savedViews;
}


-(void)init
{	
	self = [super init];
	if (self)
	{
	
		crm02Controller = self;

		// ---------------------------------------------------------------------
		// Geometry 
		//
		var contentViewWidth = [contentView frame].size.width;
		var contentViewHeight = [contentView frame].size.height;
		var viewFrame = CGRectMake(0.0, 0.0 , contentViewWidth, KKRoAY0);
		
		var appNotificationCenter = [CPNotificationCenter defaultCenter];
		[appNotificationCenter addObserver:self selector:"navigation:" name:nil object:@"Crm01Navigation"];
				
		var crm0201View = [[Crm0201View alloc] initWithFrame:viewFrame];
		[crm0201View setAutoresizingMask:CPViewWidthSizable];
		[crm0201View setBackgroundColor:KKRoAToolbarBackground];
		[crm0201View initialize];
		
		var crm0202Frame = CGRectMake(contentViewWidth-180.0, KKRoAY0-15.0, 170.0, 140.5);
		var crm0202View = [[Crm0202View alloc] initWithFrame:crm0202Frame];
		[crm0202View setAutoresizingMask:CPViewMinXMargin];
		[crm0202View initialize];
			
		var crm0203View = [[Crm0203View alloc] initWithFrame:CGRectMake(0.0, contentViewHeight-15.0, contentViewWidth, KKRoAY3)];
		[crm0203View setAutoresizingMask:CPViewMinYMargin | CPViewWidthSizable];
		[crm0203View setBackgroundColor:KKRoAToolbarBackgroundBottom];
		[crm0203View initialize];
		
		return self;
	}
}


-(void)navigation:(CPNotification)aNotification
{
	if ([aNotification object] === @"Crm01Navigation")
	{	
		switch ([aNotification name])
		{
			case "appDidLaunch":	
				[self initialDisplay];
				break;
				
			case "didLogin":
				[self fullDisplay];
				break;
								
			case "didLogout":
				[crm0201View revertToInitialDisplay];
				[self initialDisplay];
				break;
								
			default: 
				break;
		}
	}
}


-(void)initialDisplay
{
	[crm0201View display];
	[crm0203View display];
}


-(void)fullDisplay
{
	[crm0201View tailorForUser];
	var defaultButton = [crm0201View buttons][0];
	[crm0201View display];
	[defaultButton performClick:defaultButton];
}


-(void)menuSelection:(CPString)aMenuSelection
{
	KKRoADatabase = [KKRoAMenuButtons objectForKey:aMenuSelection][0];				//eg. persons
	KKRoAType = 	[KKRoAMenuButtons objectForKey:aMenuSelection][1];				//eg. person
	KKRoACaption = 	[KKRoAMenuButtons objectForKey:aMenuSelection][2];
	KKRoASortKey = 	[KKRoAMenuButtons objectForKey:aMenuSelection][3];

	var appNotificationCenter = [CPNotificationCenter defaultCenter];
	[appNotificationCenter postNotificationName:@"didMenuSelection" object:@"Crm01Navigation" userInfo:nil];
}


-(void)userButtonSelection:(CPSender)aSender
{
	//alert("in 02controller userbuttonselection "+[aSender tag]);
	switch ([aSender tag])
	{
		case "print":
			[self print:aSender];
			[crm0202View setHidden:YES];
			break;
		case "help":
			[self help:aSender];
			[crm0202View setHidden:YES];
			break;
		case "preferences":
			[self preferences:aSender];
			[crm0202View setHidden:YES];
			break;
		case "logout":
			[self logout:aSender];
			[crm0202View setHidden:YES];
			break;
		default:
			alert("arrivata scelta di bottone errata");
			break;
	}
}


-(void)globalSearch:(CPSearchField)aSearchField
{
	//alert("dentro il metodo e aSender è: "+[[aSearchField class] className]);
	var appNotificationCenter = [CPNotificationCenter defaultCenter];
	[appNotificationCenter postNotificationName:@"didRequestGlobalSearch" object:@"Crm01Navigation" userInfo:aSearchField];
}

-(void)userButtonActions:(CPSender)aSender
{
	[crm0202View userButtondisplay];
}


-(void)print:(CPSender)aSender
{	
	[crm0202View togglePrintButton];
	
	var appNotificationCenter = [CPNotificationCenter defaultCenter];

	if (KKRoARequestPrint == false)
	{
		KKRoARequestPrint = true;
		[appNotificationCenter postNotificationName:@"didActivatePrintMode" object:@"Crm01Navigation" userInfo:nil];
	}
	else
	{
		KKRoARequestPrint = false;
		[appNotificationCenter postNotificationName:@"didClosePrintMode" object:@"Crm01Navigation" userInfo:nil];
	}
}


-(void)help:(CPSender)aSender
{
	var savedViews = [contentView subviews];
	var appNotificationCenter = [CPNotificationCenter defaultCenter];
	[appNotificationCenter postNotificationName:@"didRequestHelp" object:@"Crm01Navigation" userInfo:nil];
}


-(void)quitHelp:aSender
{
	[[crm01Controller crm0103View] removeFromSuperview];
	
	for (var i=0; i<[savedViews count]; i++) {
		[contentView addSubview:savedViews[i]];
	}
}


-(void)copyright:(CPsender)aSender
{
	var savedViews = [contentView subviews];
	var appNotificationCenter = [CPNotificationCenter defaultCenter];
	[appNotificationCenter postNotificationName:@"didRequestCopyright" object:@"Crm01Navigation" userInfo:nil];
}


-(void)quitCopyrightInfo:aSender
{
	[[crm01Controller crm0103View] removeFromSuperview];
	
	for (var i=0; i<[savedViews count]; i++) {
		[contentView addSubview:savedViews[i]];
	}
}

-(void)preferences:(CPSender)aSender
{
	//alert("controllo b");
	var savedViews = [contentView subviews];
	var appNotificationCenter = [CPNotificationCenter defaultCenter];
	[appNotificationCenter postNotificationName:@"didRequestPreferences" object:@"Crm01Navigation" userInfo:nil];
}


-(void)logout:(CPSender)aSender
{
	// qui tutta la logica di aggiornamneto del DB con i dati di chiusura
	var appNotificationCenter = [CPNotificationCenter defaultCenter];
	[appNotificationCenter postNotificationName:@"didLogout" object:@"Crm01Navigation" userInfo:nil];
}


-(void)quitPreferences:aSender
{
	[crm0201View updateUserData];
	[self restoreSavedViews:aSender];
}


-(void)restoreSavedViews:aSender
{	
	for (var i=0; i<[savedViews count]; i++)
	{
		[contentView addSubview:savedViews[i]];
	}
	
}

@end














