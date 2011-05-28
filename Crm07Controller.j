// -----------------------------------------------------------------------------
//  Crm07Controller.j
//  RoACrm01
//
// 	Created by Bruno Ronchetti on May 13, 2010.
// 	Copyright 2010, Ronchetti & Associati All rights reserved.
// -----------------------------------------------------------------------------


@import <Foundation/CPObject.j>
@import "Crm0701View.j"



@implementation Crm07Controller : CPObject
{
	//CPNotificationCenter 	id appNotificationCenter;
	Crm0701View				id 	crm0701View	@accessors;
	CGRect					id 	rightPositionFrame;
	CGRect					id 	leftPositionFrame;
	CPDictionary			id	buttonsToEnable;
	CPString				id	savedLastSender;
}


-(void)init
{	
	self = [super init];
	if (self)
	{
	
		crm07Controller = self;

		// ---------------------------------------------------------------------
		// Geometry 
		//
		var contentViewWidth = [contentView frame].size.width;
		var contentViewHeight = [contentView frame].size.height- KKRoAY3;
		
		var rightOffset = KKRoAX1+KKRoAX2+5;
		var leftOffset = KKRoAX1+5;
		var borderHeight = 2.0;

		var positionY = contentViewHeight- KKRoAY2- borderHeight- 5.0;
		
		
		var rightPositionFrame = CGRectMake(rightOffset, positionY , contentViewWidth-rightOffset-5, KKRoAY4+ borderHeight);
		var leftPositionFrame  = CGRectMake(leftOffset, positionY , contentViewWidth-leftOffset-5, KKRoAY4+ borderHeight);
		
		var appNotificationCenter = [CPNotificationCenter defaultCenter];
		[appNotificationCenter addObserver:self selector:"navigation:" name:nil object:@"Crm01Navigation"];

		var crm0701View = [[Crm0701View alloc] initWithFrame:leftPositionFrame];
		[crm0701View setAutoresizingMask:CPViewWidthSizable | CPViewMinYMargin];
		[crm0701View setBackgroundColor:[CPColor clearColor]];
		//[crm0701View setBackgroundColor:KKRoABottombarBackground];
	
		[crm0701View initialize];
		
		var buttonsToEnable = [CPDictionary	dictionary];
		[buttonsToEnable setValue:["showContacts", "showProjects", "showAttachments"] forKey:"all"];
		[buttonsToEnable setValue:["showContacts", "showProjects", "showAttachments"] forKey:"person"];
		[buttonsToEnable setValue:["showContacts", "showPersons", "showProjects", "showAttachments"] forKey:"company"];
		[buttonsToEnable setValue:["showContacts", "showPersons", "showProjects", "showAttachments"] forKey:"non_profit_organization"];
		[buttonsToEnable setValue:["showContacts", "showProjects", "showAttachments"] forKey:"member"];
		[buttonsToEnable setValue:["showContacts", "showProjects", "showAttachments"] forKey:"employee"];
		[buttonsToEnable setValue:["showPersons", "showAttachments"] forKey:"project"];
		[buttonsToEnable setValue:["showAttachments"] forKey:"contact"];
		
		return self;
	}
}


-(void)navigation:(CPNotification)aNotification
{
	//alert("in crm07controller navigation "+[aNotification name]);
		
	if ([aNotification object] === @"Crm01Navigation")
	{
		switch ([aNotification name])
		{		
			case "didMenuSelection":
					[crm0701View enableButtonsWithTags:[buttonsToEnable valueForKey:KKRoAType]];
					[crm0701View setFrame:leftPositionFrame];
					break;

			case "didRequest2PanesDisplay":	
					[crm0701View setFrame:leftPositionFrame];
					break;
						
			case "didSelectAList":
					[crm0701View setFrame:rightPositionFrame];
					break;
					
			case "didRequestNewDoc":			
			case "didRequestDocDisplay":
					//alert("in 0701 didRequestDocDisplay");
					[crm0701View enableButtonsWithTags:[buttonsToEnable valueForKey:KKRoAType]];
					[crm0701View display];
					break;
					
			case "didRequestRecordLevelAction":
					if (KKRoAnItem != "")
					{
						[crm0701View enableButtonsWithTags:[buttonsToEnable valueForKey:"all"]];
					}
					break;
																
			case "didLogout":
			case "didRequestHelp":	
			case "didRequestGlobalSearch":
			case "didActivatePrintMode":
			case "didRequestPrintForList":
			case "didRequestPreferences":	
					[crm0701View removeFromSuperview];
					break;
					
			default: 	break;
		}
	}
}

-(void)initialDisplay:(CGRect)aPositionFrame
{
	[crm0701View setFrame:aPositionFrame];
	[crm0701View display];
}


-(void)didSelectButton:(CPSender)aSender
{
	var appNotificationCenter = [CPNotificationCenter defaultCenter];
	
	[crm0701View enableButtonsWithTags:[buttonsToEnable valueForKey:KKRoAType]];
	[crm0701View disableButtonWithTag:[aSender tag]];
	[crm0701View enableButtonWithTag:"close"];
				
	switch ([aSender tag])
	{
		case "showContacts":
			[appNotificationCenter postNotificationName:@"didRequestContacts" object:@"Crm01Navigation" userInfo:nil];
			break;
				
		case "showPersons":
			[appNotificationCenter postNotificationName:@"didRequestPersons" object:@"Crm01Navigation" userInfo:nil];
			break;
				
		case "showProjects":
			[appNotificationCenter postNotificationName:@"didRequestProjects" object:@"Crm01Navigation" userInfo:nil];
			break;

		case "showAttachments":
			[appNotificationCenter postNotificationName:@"didRequestAttachments" object:@"Crm01Navigation" userInfo:nil];
			break;
				
		case "close":
			[crm0701View disableButtonWithTag:"close"];
			break;
			
		default:	break;
	}
	
	var savedLastSender = [aSender tag];
}


-(void)animationDidEnd
{
	var appNotificationCenter = [CPNotificationCenter defaultCenter];
	[appNotificationCenter postNotificationName:@"didCloseSlideUpPanel" object:@"Crm01Navigation" userInfo:nil];
}

@end