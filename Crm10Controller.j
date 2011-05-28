// -----------------------------------------------------------------------------
//  Crm10Controller.j
//  RoACrm01
//
// 	Created by Bruno Ronchetti on May 13, 2010.
// 	Copyright 2010, Ronchetti & Associati All rights reserved.
// -----------------------------------------------------------------------------


@import <Foundation/CPObject.j>

@import "Crm1001View.j"



@implementation Crm10Controller : CPObject
{
	//CPNotificationCenter 	id appNotificationCenter;
	Crm1001View				id crm1001View;
}


-(void)init
{	
	self = [super init];
	if (self)
	{
		crm10Controller = self;
		// ---------------------------------------------------------------------
		// Geometry 
		//
		var contentViewWidth = [contentView frame].size.width;
		var contentViewHeight = [contentView frame].size.height- KKRoAY3;
						
		var viewFrame = CGRectMake(0.0, KKRoAY0 , contentViewWidth, contentViewHeight-KKRoAY0);
		
		var appNotificationCenter = [CPNotificationCenter defaultCenter];
		[appNotificationCenter addObserver:self selector:"navigation:" name:nil object:@"Crm01Navigation"];

		var crm1001View = [[Crm1001View alloc] initWithFrame:viewFrame];
		[crm1001View setAutoresizingMask:CPViewHeightSizable | CPViewWidthSizable];
		[crm1001View setBackgroundColor:[contentView backgroundColor]];
		
		[crm1001View initialize];
		
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
						[crm1001View removeFromSuperview];
						break;
						
			case "didSelectAList":
						//alert("Arrivato didSelectAList");
						[crm1001View removeFromSuperview];
						break;
										
			case "didLogout":		
						[crm1001View removeFromSuperview];
						break;

			case "didRequestHelp":	
						[crm1001View removeFromSuperview];
						break;
						
			case "didRequestGlobalSearch":	
						[crm1001View filterData:[aNotification userInfo]];
						[crm1001View display];
						break;
						
			default: 	break;
		}
	}
}


-(void)initialDisplay
{
	[crm1001View initialize];
	[crm1001View display];
}


-(void)doubleClick:(CPSender)aSender
{
	//alert("doubeClick received and Sender is "+ [[aSender dataSource] existingTableObjects]);
	var objectTable = [aSender dataSource];
	var selectedItem = [objectTable selectedTableObjects];
	
	[self populateGlobals:[selectedItem valueForKey:"type"]];

	KKRoAnItem = [selectedItem valueForKey:"_id"];
	//alert(KKRoAnItem);
	KKRoAAction = "displayRecord";
	
	var appNotificationCenter = [CPNotificationCenter defaultCenter];
	[appNotificationCenter postNotificationName:@"didMenuSelection" object:@"Crm01Navigation" userInfo:nil];
	[appNotificationCenter postNotificationName:@"didRequestDocDisplay" object:@"Crm01Navigation" userInfo:nil];

}

-(void)populateGlobals:(CPString)aType
{
	//alert("in crm10controller populateglobals "+aType);
	//alert("in crm10controller populateglobals "+[KKRoAMenuButtons allKeys]);
	//alert("in crm10controller populateglobals "+[KKRoAMenuButtons objectForKey:aType]);

/*
	KKRoAMenuButtons = [CPDictionary dictionaryWithObjectsAndKeys:
	["persons", "person", "Persone", "Cognome","personImage"], @"person",
	["companies", "company", "Società", "Ragione_Sociale","companyImage"], @"company",
	["non_profit_organizations", "non_profit_organization", "Organizzazione", "Organizzazione","nonProfitImage"], @"non_profit_organization",
	["employees", "employee", "Collaboratori", "Cognome", "employeeImage"], @"employee",
	["projects", "project", "Progetti", "Denominazione", "projectImage"], @"project",
	["contacts", "contact", "Contatti", "Denominazione","contactImage"], @"contact",
	["prints", "print", "Stampa", "Titolo","printImage"], @"print"
	];
*/	
	KKRoADatabase = [KKRoAMenuButtons objectForKey:aType][0];				//eg. persons
	KKRoAType = 	[KKRoAMenuButtons objectForKey:aType][1];				//eg. person
	KKRoACaption = 	[KKRoAMenuButtons objectForKey:aType][2];
	KKRoASortKey = 	[KKRoAMenuButtons objectForKey:aType][3];
}

@end















