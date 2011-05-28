// -----------------------------------------------------------------------------
//  Crm05Controller.j
//  RoACrm
//
// 	Created by Bruno Ronchetti on May 13, 2010.
// 	Copyright 2010, Ronchetti & Associati All rights reserved.
// -----------------------------------------------------------------------------


@import <Foundation/CPObject.j>
@import "Crm0501View.j"

@implementation Crm05Controller : CPObject
{
	//CPNotificationCenter 	id appNotificationCenter;
	Crm0501View				id crm0501View;
	RoATree					id crm05Tree	@accessors;
	CPArray					id rootNodes	@accessors;
	CPArray					id crm05Data	@accessors;
}


-(void)init
{	
	self = [super init];
	if (self)
	{
	
		crm05Controller = self;

		// ---------------------------------------------------------------------
		// Geometry 
		//
		var contentViewWidth = [contentView frame].size.width;
		var contentViewHeight = [contentView frame].size.height- KKRoAY3;
		
		var viewHeight = contentViewHeight-KKRoAY0-KKRoAY2+14;

		var viewFrame = CGRectMake(KKRoAX1+5, KKRoAY0+10 , KKRoAX2-10, viewHeight);
		
		var appNotificationCenter = [CPNotificationCenter defaultCenter];
		[appNotificationCenter addObserver:self selector:"navigation:" name:nil object:@"Crm01Navigation"];

		var crm0501View = [[Crm0501View alloc] initWithFrame:viewFrame];
		[crm0501View setAutoresizingMask:CPViewHeightSizable];
		//[crm0501View setBackgroundColor:KKRoABackgroundWhite];
		
		return self;
	}
}


-(void)navigation:(CPNotification)aNotification
{
	//alert("in crm05controller navigation "+[aNotification name]);

	if ([aNotification object] === @"Crm01Navigation"){
	
		switch ([aNotification name])
		{
			case "didMenuSelection":
						if (KKRoARequestPrint == false)
						{
							[crm0501View removeFromSuperview];
						}
						break;
						
			case "didSelectAList":
						//alert("Arrivato didSelectAList");
						[self initialDisplay];
						break;
						
			case "didActivatePrintMode":
						//alert("in 05controller Arrivato didActivatePrintMode");
						[self initialDisplay];
						break;
						
			case "didClosePrintMode":
			case "didLogout":
			case "didRequestHelp":
			case "didRequestGlobalSearch":	
			case "didRequest2PanesDisplay":
			case "didRequestPreferences":	
						[crm0501View removeFromSuperview];
						break;					
										
			default: 	break;
		}
	}
}


-(void)initialDisplay
{
	[crm0501View initialize];
	[crm0501View displaySpinner];
	
	[self loadData];
	[crm0501View display];
}


-(void)loadData
{

	//var domain = KKRoAUserDomain;
	//var type = KKRoAType;
	//var selection = KKRoAList;
	
	var startkey = [KKRoAUserDomain, KKRoAType, encodeURI(KKRoAList)];
	var startJSONkey = JSON.stringify(startkey);
	
	var endkey = [KKRoAUserDomain, KKRoAType, encodeURI(KKRoAList), {}];
	var endJSONkey = JSON.stringify(endkey);
	
	var dataRequest = new Object();
	dataRequest["action"] = "readDoc";
	
	if (KKRoARequestPrint == false)
	{
		dataRequest["key"] = "documents/_design/data/_view/docs_by_list?startkey="+startJSONkey+"&endkey="+endJSONkey;
	}
	else
	{
		dataRequest["key"] = "templates/_design/letters/_view/all";
	}

	//alert(KKRoAList);
	//alert(dataRequest["key"]);
	
	var crm05Data = [[RoACouchModule alloc] initWithRequest:dataRequest executeSynchronously:1];
	
	//alert("crm05controller loaddata ho letto record "+[crm05Data count]);

	crm05Tree = [[RoATree alloc] init];

	[crm05Tree addNode:"root" withParent:null];
	[crm05Tree addObject:null toNode:"root"];

	//alert("all'inizio del loop di loaddata");

			
	for (var j=0; j<[crm05Data count]; j++)
	{
		if ( [crm05Data[j]["value"] respondsToSelector:@selector(count)])
		{ 
			if ( [crm05Data[j]["value"][1] respondsToSelector:@selector(count)])
			{
				var childName = crm05Data[j]["value"][1][0];				// add first couple
				var parentName = crm05Data[j]["value"][0];
				[crm05Tree addNode:childName withParent:parentName];
				[crm05Tree addObject:crm05Data[j] toNode:childName];
				
				var childName = crm05Data[j]["value"][1][1];				// add second couple
				var parentName = crm05Data[j]["value"][1][0];		
			}
			else
			{
				var childName = crm05Data[j]["value"][1];
				var parentName = crm05Data[j]["value"][0];
			}
			isMultiLevel = true;
		}
		else
		{
			var childName = crm05Data[j]["value"];
			var parentName = "root";
		}
		
		[crm05Tree addNode:childName withParent:parentName];
		[crm05Tree addObject:crm05Data[j] toNode:childName];
	}

	// Catch orphan children, i.e. children where there is no explicit parent in the received data
	[crm05Tree adoptOrphans:"root"];
	
	var rootNodes = [crm05Tree childNodesForKey:"root"];
}


-(void)itemSelection:(CPString)theSelectedItem
{
	//alert("Crm05Controller itemSelection prima della selezione "+" "+theSelectedItem+ " e requestprint è "+KKRoARequestPrint);
	KKRoAnItem = theSelectedItem;
	KKRoAAction = "displayRecord";
	
	var appNotificationCenter = [CPNotificationCenter defaultCenter];
	if (KKRoARequestPrint == true)
	{
		[appNotificationCenter postNotificationName:@"didRequestPrintForList" object:@"Crm01Navigation" userInfo:nil];
	}
	else
	{
		var lookupObject = new Object();
		lookupObject["action"] = "readDoc";
		lookupObject["key"] = "documents/"+theSelectedItem;
		var lookupDoc = [[RoACouchModule alloc] initWithRequest:lookupObject executeSynchronously:1];
		
		KKRoAForeignKey = lookupDoc["Foreign_Key"];
		[appNotificationCenter postNotificationName:@"didRequestDocDisplay" object:@"Crm01Navigation" userInfo:nil];
	}
}



-(void)collapseMiddlePanel:(CPSender)aSender
{
	var appNotificationCenter = [CPNotificationCenter defaultCenter];
	[appNotificationCenter postNotificationName:@"didRequest2PanesDisplay" object:@"Crm01Navigation" userInfo:nil];
}


//++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
// Delegate Methods to control outline behaviour
//
-(int)outlineView:(CPOutlineView)outlineView numberOfChildrenOfItem:(id)item
{
	//("A "+item);
	if (item == null)
		return [[crm05Tree childNodesForKey:"root"] count];
	else
		return [[crm05Tree childNodesForKey:item] count];
}

-(BOOL)outlineView:(CPOutlineView)outlineView isItemExpandable:(id)item
{
	//alert("B "+item);
	if (item == null)
		return false;
	else
		return [[crm05Tree childNodesForKey:item] count] > 0;
}

-(id)outlineView:(CPOutlineView)outlineView child:(int)index ofItem:(id)item
{
	//alert("C "+item);
	if (item == null)
		return [crm05Tree childNodesForKey:"root"][index];
	else
		return [crm05Tree childNodesForKey:item][index];
}

-(id)outlineView:(CPOutlineView)outlineView objectValueForTableColumn:(CPTableColumn)tableColumn byItem:(id)anObject
{
	//alert("D "+item);
	return anObject;
}

/*
-(id)outlineView:(CPOutlineView)outlineView shouldSelectItem:(id)item
{
	//alert("E "+item);
	if (item === null)
		return NO;
	else
		return YES;
}
*/

//++++++++++++++++++++++++++++++++++++++++++++++++++++++


@end