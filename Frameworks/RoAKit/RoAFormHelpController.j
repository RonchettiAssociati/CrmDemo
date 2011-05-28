// -----------------------------------------------------------------------------
//  RoAFormHelpController.j
//  RoACrm01
//
// 	Created by Bruno Ronchetti on May 13, 2010.
// 	Copyright 2010, Ronchetti & Associati All rights reserved.
// -----------------------------------------------------------------------------

@import <Foundation/CPObject.j>
@import "RoAFormFieldHelp.j"
@import "RoAFormCalendar.j"


@implementation RoAFormHelpController : CPObject
{
	CPNotificationCenter 	id 	appNotificationCenter;
	CPObject				id	userInfo;
	CPView					id	theHelp;
	CPString				id 	helpTypeIs;
	
	CPArray					id	theHelpDataArray;
	CPString				id	theSelectedHelpValue;
}


-(void)init
{	
	self = [super init];
	if (self)
	{
		appHelpController = self;
					
		var appNotificationCenter = [CPNotificationCenter defaultCenter];
		[appNotificationCenter addObserver:self selector:@"navigation:" name:nil object:@"Crm01Navigation"];
		
		var helpTypeIs = "";
		var theSelectedHelpValue = "QWERTY";
		return self;
	}
}


-(void)navigation:(CPNotification)aNotification
{
	if ([aNotification object] === @"Crm01Navigation")
	{
		switch ([aNotification name])
		{
			case "didMenuSelection":
			case "didSelectAList":
			case "didRequestDocDisplay":
			case "didActivatePrintMode":
				[theHelp setHidden:YES];
				break;
				
			case "didBeginFieldEdit":
			case "didBeginTableCellEdit":
				var userInfo = [aNotification userInfo];
				//listProperties(userInfo, "userInfo");
				
				if (userInfo && userInfo["fieldStringValue"] == theSelectedHelpValue)
				{
					//var theSelectedHelpValue = "QWERTY";
					break;
				}

				[theHelp setHidden:YES];
				if (userInfo["helpNeeded"])	
				{
					[self setHelpFormat:userInfo["helpArray"][0]];
					if (userInfo["helpArray"][0] == "calendar")
					{
						[theHelp prepareData:"today"];
					}
					else
					{
						var theHelpDataArray = [];
						theHelpDataArray = [self prepareHelpData:userInfo["helpArray"]];
						//alert("Perpara dati per help "+[theHelpDataArray count]);
						[theHelp prepareTreeForData:theHelpDataArray];
					}
					// <====================
					[self displayHelp];
				}
				break;
												
			case "didChangeFieldEdit":
				var userInfo = [aNotification userInfo];
				var aFieldStringValue = userInfo["fieldStringValue"];
				
				if ([theHelpDataArray count] == 0)
				{
					var theHelpDataArray = [self prepareHelpData:userInfo["helpArray"]];
					[theHelp prepareTreeForData:theHelpDataArray];
				}
				
				if (userInfo["helpArray"][0] != "calendar")
				{
					[theHelp filterHelpData:userInfo["fieldStringValue"]];
					[self displayHelp];
				}
				break;
				
			default:
				break;
		}
	}
}


-(void)displayHelp
{
	[theHelp setHidden:NO];
	[theHelp display];
}



-(void)selectedHelpValue:(CPString)aSelectedHelpValue
{
	var theSelectedHelpValue = aSelectedHelpValue;
	var notificationName = (userInfo["tableView"]) ? @"helpDidSelectValueForTable" : @"helpDidSelectValueForField";
	userInfo["selectedHelpValue"] = theSelectedHelpValue;
	[appNotificationCenter postNotificationName:notificationName object:@"Crm01Navigation" userInfo:userInfo];
}


-(void)helpDidDeleteBackwards
{
	theHelpDataArray = [];
	[theHelp prepareTreeForData:theHelpDataArray];
	[theHelp setHidden:YES];
}


-(void)helpDidCompleteSelection
{
	[userInfo["field"] helpDidCompleteSelection];
	//[userInfo["targetView"] formDidChange];	
	[theHelp setHidden:YES];
}


-(void)setHelpFormat:(CPString)aHelpFormat
{
	if (theHelp)
	{
		[theHelp removeFromSuperview];
	}
		
	// receive parameter
	var theHelpFormat = aHelpFormat;
	
	// type
	switch (theHelpFormat)
	{
		case "calendar":
			if (helpTypeIs != "calendar")
			{
				var theHelp = [[RoAFormCalendar alloc] init];
				var helpTypeIs = "calendar";
			}
			break;
				
		default:
			if (helpTypeIs != "list")
			{
				var theHelp = [[RoAFormFieldHelp alloc] initWithFrame:CGRectMakeZero()];
				var helpTypeIs = "list";
			}
			break;
	}
		
	// position
	var theFrameCorner = CGPointMake(CGRectGetMinX(userInfo["cellFrame"])+ 4.0, CGRectGetMaxY(userInfo["cellFrame"]));
	var theHelpOrigin = [contentView convertPoint:theFrameCorner fromView:userInfo["superview"]];
	[theHelp setFrameOrigin:theHelpOrigin];
	
	// size
	[theHelp setFrameSize:CGSizeMake(CGRectGetWidth(userInfo["cellFrame"])+ 10.0, 500)];
}	
			

-(CPArray)prepareHelpData:(CPArray)aHelpDescriptor							
{
	//alert("in preparehelpdata "+aHelpDescriptor);
	var theHelpDataSource = aHelpDescriptor[1];
	var theHelpData = aHelpDescriptor[2];
	
	if (theHelpDataArray && [theHelpDataArray count] > 0)
	{
		return theHelpDataArray;
	}
		
	switch(theHelpDataSource) {
		case "calendar":
			[theHelp prepareData:"today"];
			break;
			
		case "inline":
			var theHelpDataArray = [CPArray arrayWithArray:theHelpData];
			break;
				
		case "table":
			var tableData = [];
			for (var j=0; j<[KKRoATables count]; j++)
			{
				if (KKRoATables[j]["key"] == theHelpData)
				{
					tableData = KKRoATables[j]["value"];
					break;
				}
			}
			var theHelpDataArray = [CPArray arrayWithArray:tableData];
			break;
				
		case "database":
			var aFieldStringValue = userInfo["fieldStringValue"];
			var	numberOfCharacters = [aFieldStringValue length];
			var theNumberOfCharactersTrigger = aHelpDescriptor[4];
			
			//alert("quando leggo il db per help il trigger è "+theNumberOfCharactersTrigger);
			if (numberOfCharacters == theNumberOfCharactersTrigger || theNumberOfCharactersTrigger == 0)
			{
				//alert("dentro");
				
				var startkey = [KKRoAUserDomain, theHelpData, aFieldStringValue.toLowerCase()];
				var startJSONkey = JSON.stringify(startkey);
				var endkey = [KKRoAUserDomain, theHelpData, aFieldStringValue.toLowerCase()+"ZZZZ"];
				var endJSONkey = JSON.stringify(endkey);
				
				if (theNumberOfCharactersTrigger == 0)
				{
					var startkey = [KKRoAUserDomain, theHelpData, "a"];
					var startJSONkey = JSON.stringify(startkey);
					var endkey = [KKRoAUserDomain, theHelpData, "Z"];
					var endJSONkey = JSON.stringify(endkey);
				}
				
				var dataRequest = new Object();
				dataRequest["action"] = "readDoc";
				dataRequest["key"] = "documents/_design/data/_view/docs_by_initials?startkey="+startJSONkey+"&endkey="+endJSONkey;
				//alert("quando leggo il db per help "+dataRequest["key"]);
				var theDocs = [[RoACouchModule alloc] initWithRequest:dataRequest executeSynchronously:1];
				
				for (var i=0; i<[theDocs count]; i++)
				{
					[theHelpDataArray addObject:theDocs[i]["value"]];
				}
				//alert("dopo aver letto  il db per help il trigger è "+[theHelpDataArray count]);
				break;
			}
				
		default:
			break;
	}
	
	return theHelpDataArray;
}

@end