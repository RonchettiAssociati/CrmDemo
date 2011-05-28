// -----------------------------------------------------------------------------
//  Crm04Controller.j
//  RoACrm01
//
// 	Created by Bruno Ronchetti on May 13, 2010.
// 	Copyright 2010, Ronchetti & Associati All rights reserved.
// -----------------------------------------------------------------------------


@import <Foundation/CPObject.j>
@import "Crm0401View.j"




@implementation Crm04Controller : CPObject
{
	//CPNotificationCenter 	id appNotificationCenter;
	Crm0401View				id crm0401View;
	CGRect					id rightPositionFrame;
	CGRect					id leftPositionFrame;
	
	CPArray	id	savedButtonsState;
}


-(void)init
{	
	self = [super init];
	if (self)
	{
	
		crm04Controller = self;

		// ---------------------------------------------------------------------
		// Geometry 
		//
		var contentViewWidth = [contentView bounds].size.width;
		var contentViewHeight = [contentView bounds].size.height;
		
		var rightOffset = KKRoAX1+KKRoAX2+5;
		var leftOffset = KKRoAX1+5;
		
		var rightPositionFrame = CGRectMake(rightOffset, KKRoAY0+10 , contentViewWidth-rightOffset-5, KKRoAY1);
		var leftPositionFrame  = CGRectMake(leftOffset, KKRoAY0+10 , contentViewWidth-leftOffset-5, KKRoAY1);
		
		// ---------------------------------------------------------------------
		// Flags and Switches
		//
		
		var appNotificationCenter = [CPNotificationCenter defaultCenter];
		[appNotificationCenter addObserver:self selector:"navigation:" name:nil object:@"Crm01Navigation"];

		var crm0401View = [[Crm0401View alloc] initWithFrame:leftPositionFrame];
		[crm0401View setAutoresizingMask:CPViewWidthSizable];
		
		[crm0401View setBackgroundColor:KKRoARibbonBackground];
		//[crm0401View setBackgroundColor:[CPColor blueColor]];
			
		return self;
	}
}


-(void)navigation:(CPNotification)aNotification
{
	//alert("in crm04controller navigation "+[aNotification name]);
	if ([aNotification object] === @"Crm01Navigation")
	{
		switch ([aNotification name])
		{
			case "didMenuSelection":
						[self initialDisplay:leftPositionFrame];
						break;
						
			case "didSelectAList":
						//alert("Arrivato didSelectAList");
						[self initialDisplay:rightPositionFrame];
						break;
										
			case "didActivatePrintMode":
			case "didRequestPreferences":
			case "didRequestHelp":	
			case "didRequestGlobalSearch":	
			case "didLogout":		
						[crm0401View removeFromSuperview];
						break;
										
			case "didRequest2PanesDisplay":	
						[crm0401View setFrame:leftPositionFrame];
						break;

			case "didRequestDocDisplay":
						[crm0401View enableButtons:[0,2]];
						break;
															
			case "didChangeFormData":
						//alert("Arrivato didChangeFormData in crm04controller");
						
						if (KKRoAFormPrivileges == "pieni" && KKRoAFormPrivileges != KKRoAUserPrivileges)
						{
							[crm0401View enableButtons:[3]];
							break;
						}
						
						if (KKRoAnItem == "")
						{
							[crm0401View enableButtons:[0,1,3]];
						}
						else
						{
							[crm0401View enableButtons:[0,1,2,3]];
						}
						break;
						
			default: 	break;
		}
	}
}


-(void)initialDisplay:(CGRect)aPositionFrame
{
	if (KKRoARequestPrint == false)
	{
		[crm0401View setFrame:aPositionFrame];
		[crm0401View initialize];
		[crm0401View tailorForUser];
		[crm0401View enableButtons:[0]];
		[crm0401View display];
	}
}


-(void)buttonSelection:(CPString)aButtonIdentifier
{
	var appNotificationCenter = [CPNotificationCenter defaultCenter];
	switch (aButtonIdentifier)
	{
		case "newRecord":
			[appNotificationCenter postNotificationName:@"didRequestNewDoc" object:@"Crm01Navigation" userInfo:nil];
			[crm0401View enableButtons:[0]];
			break;
		case "reloadRecord":
			[appNotificationCenter postNotificationName:@"didRequestReloadDoc" object:@"Crm01Navigation" userInfo:nil];
			[crm0401View enableButtons:[0]];
			break;
		case "deleteRecord":
			[appNotificationCenter postNotificationName:@"didRequestDeleteDoc" object:@"Crm01Navigation" userInfo:nil];
			[crm0401View enableButtons:[2]];
			break;
		case "saveRecord":
			[appNotificationCenter postNotificationName:@"didRequestSaveDoc" object:@"Crm01Navigation" userInfo:nil];
			[crm0401View enableButtons:[3]];
			break;
		default:
			alert("ERRORE");
			break;
	}
	KKRoAAction = aButtonIdentifier;
}

-(void)saveButtonsState
{
	var savedButtonsState = [crm0401View enabledButtons];
}

-(void)restoreButtonsState
{
	//alert("in restoreButtonsState "+savedButtonsState);
	//listProperties(savedButtonsState, "savedButtonsState");
	[crm0401View enableButtons:savedButtonsState];
}

@end