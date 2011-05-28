// -----------------------------------------------------------------------------
//  Crm11Controller.j
//  RoACrm
//
// 	Created by Bruno Ronchetti on May 13, 2010.
// 	Copyright 2010, Ronchetti & Associati All rights reserved.
// -----------------------------------------------------------------------------


@import <Foundation/CPObject.j>
@import "Crm1101View.j"
@import "Crm00Models.j"


@implementation Crm11Controller : CPObject
{
	CPArray			id similarNames 				@accessors;
	BOOL			id shouldDisplaySimilarNames;
	//CPNotificationCenter id	appNotificationCenter;
	CPString		id previousFuzzyKey;
	
	Crm11Model		id 	crm11Model;
	Crm1101View		id 	crm1101View;
	CPString		id	theNotification;
}


-(void)init
{	
	self = [super init];
	if (self)
	{
		crm11Controller = self;
		
		// ---------------------------------------------------------------------
		// Geometry 
		//
		var contentViewWidth = [contentView frame].size.width;
		var contentViewHeight = [contentView frame].size.height;
				
		var viewFrame = CGRectMake(0, 0 , 200.0, 200.0);
		
		// ---------------------------------------------------------------------
		// Constants 
		//
		var previousFuzzyKey = "";
		var similarNames = [];
		
		var appNotificationCenter = [CPNotificationCenter defaultCenter];
		[appNotificationCenter addObserver:self selector:"navigation:" name:nil object:@"Crm01Navigation"];
		
		var crm11Model = [[Crm00Models alloc] init];
		
		var crm1101View = [[Crm1101View alloc] initWithFrame:viewFrame];
		[crm1101View setAutoresizingMask:CPViewHeightSizable];
		[crm1101View initialize];
		
		return self;
	}
}


	
-(void)navigation:(CPNotification)aNotification
{	
	if ([aNotification object] === @"Crm01Navigation")
	{
		var theNotification = [aNotification name];
		switch ([aNotification name])
		{
			case "didRequestDeleteDoc":
				[crm04Controller saveButtonsState];
				[crm1101View tailorForCase:"simpleDeleteConfirmation"];
				break;
						
			case "didRequestSaveDoc":
				//alert(" in didRequestSaveDoc");
				[crm04Controller saveButtonsState];
				[self readFuzzySimilarData];
				if ([similarNames count] > 0 && similarNames[0]["score"] > 0.9)		//if similarnames function is required
				{
					[crm1101View tailorForCase:"complexSaveConfirmation"];
				}
				else
				{
					[crm1101View tailorForCase:"simpleSaveConfirmation"];
				}
				break;
											
			default: 
				[crm1101View clearView];
				break;
		}
	}
}


-(void)buttonSelection:(CPSender)aSender
{
	switch([aSender tag])
	{
		case "confirm":
		
			var databaseReturnObject = new Object();

			if (theNotification == "didRequestDeleteDoc")
			{
				databaseReturnObject = [crm11Model deleteDocFromGlobalSavedDictionary];
				databaseReturnObject["performedAction"] = "deleted";
			}
	
			if (theNotification == "didRequestSaveDoc")
			{
				databaseReturnObject = [crm11Model writeDocFromGlobalSavedDictionary];
				databaseReturnObject["performedAction"] = "saved";
			}
								
			[self notifyUser:databaseReturnObject];
			break;
			
		case "cancel":
			[crm04Controller restoreButtonsState];
			[crm1101View setHidden:YES];
			break;
			
		default:
			//alert("in crm11controller arrivato [aSender tag] sconosciuto");
			break;
	}
}


-(void)notifyUser:(JSObject)aDataBaseReturnObject
{
	var theDatabaseReturnObject = aDataBaseReturnObject;
	
	if (theDatabaseReturnObject["ok"] == true)								// succesfull write
	{
		if (theDatabaseReturnObject["performedAction"] == "deleted")
		{
			[crm1101View tailorForCase:"successfullDelete"];
		}
		if (theDatabaseReturnObject["performedAction"] == "saved")
		{
			[crm1101View tailorForCase:"successfullWrite"];
		}
		var tickler = [CPTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(endNotification) userInfo:nil repeats:NO]; 
	}
	else
	{
		[crm1101View tailorForCase:"writeError"];
	}
}


- (void)endNotification 
{
	[crm1101View setHidden:YES];
	 
	var appNotificationCenter = [CPNotificationCenter defaultCenter];
	[appNotificationCenter postNotificationName:@"didMenuSelection" object:@"Crm01Navigation" userInfo:nil];
	[appNotificationCenter postNotificationName:@"didRequestNewDoc" object:@"Crm01Navigation" userInfo:nil];

	if (KKRoAList != "")
	{
		[appNotificationCenter postNotificationName:@"didSelectAList" object:@"Crm01Navigation" userInfo:nil];
	}				
}



-(void)readFuzzySimilarData
{
	//alert("in readFuzzySimilarData ", KKRoATheScreenDoc);
/*	
	var fuzzyKey = [[crm06Controller crm0601View] getFormDataForItem:@"Cognome"]+"~";

	if (fuzzyKey != previousFuzzyKey)
	{	
		var similarNames = [];
			
		var dataRequest = new Object();
		dataRequest["action"] = "readDoc";
		dataRequest["key"] = "documents/_fti/_design/lucene/by_name_fuzzy?q="+fuzzyKey+"&include_docs=true";
		var dataResponse = [[RoACouchModule alloc] initWithRequest:dataRequest executeSynchronously:1];
		
		if (dataResponse)
		{
			[similarNames addObjectsFromArray:dataResponse];
		}
	}
	previousFuzzyKey = fuzzyKey;
	//alert("alla fine di readFuzzySimilarData "+[similarNames count]);
*/
}




@end