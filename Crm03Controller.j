//  -----------------------------------------------------------------------------
//  Crm03Controller.j
//  RoACrm
//
// 	Created by Bruno Ronchetti on May 13, 2010.
// 	Copyright 2010, Ronchetti & Associati All rights reserved.
// -----------------------------------------------------------------------------


@import <Foundation/CPObject.j>
@import <RoAKit/RoATree.j>
@import "Crm0301View.j"
@import "Crm0302View.j"
@import	"Crm00Models.j"

@implementation Crm03Controller : CPObject
{
	CPNotificationCenter 	id appNotificationCenter;
	Crm00Models	id crm00Models;
		
	Crm0301View	id crm0301View;
	Crm0302View	id crm0302View;
	
	CPString	id selectedAction;
	CPNumber	id selectedRow;
	CPString	id selectedItem;
	BOOL		id selectedItemIsExpanded;
	
	CPString	id newChildName;

	
	RoATree		id crm03Tree @accessors;
	
	CPArray id 	children;
	CPArray	id	rootNodes;
	RoACouchModule	id responseData;
}


-(void)init
{	
	self = [super init];
	if (self)
	{
		crm03Controller = self;

// ---------------------------------------------------------------------
// Geometry 
//
		var contentViewWidth = [contentView frame].size.width;
		var contentViewHeight = [contentView frame].size.height- KKRoAY3;
				
		//var viewFrame = CGRectMake(0.0, KKRoAY0 , KKRoAX1, contentViewHeight-KKRoAY0);
		var viewFrame = CGRectMake(5.0, KKRoAY0+10 , KKRoAX1-10, contentViewHeight-KKRoAY0-15);
		
		var appNotificationCenter = [CPNotificationCenter defaultCenter];
		[appNotificationCenter addObserver:self selector:"navigation:" name:nil object:@"Crm01Navigation"];
		
		var crm00Models = [[Crm00Models alloc] init];

		var crm0301View = [[Crm0301View alloc] initWithFrame:viewFrame];
		[crm0301View setAutoresizingMask:CPViewHeightSizable];
		[crm0301View setBackgroundColor:[CPColor clearColor]];

		var crm0302View = [[Crm0302View alloc] initWithFrame:CGRectMake(contentViewWidth-120.5, 35.0, 110.5, 280.5)];
		// FIXME non funziona il resizing sull'asse Y
		[crm0302View setAutoresizingMask:CPViewMinYMargin];
		[crm0302View initialize];
		
		return self;
	}
}




-(void)navigation:(CPNotification)aNotification
{
	//alert("in crm03controller navigation "+[aNotification name]);
	
	if ([aNotification object] === @"Crm01Navigation")
	{
		switch ([aNotification name])
		{
			case "didMenuSelection":
			case "didActivatePrintMode":
						[self initialDisplay];
						break;
																						
			case "didLogout":
			case "didRequestHelp":
			case "didRequestGlobalSearch":	
			case "didRequestPreferences":	
						[crm0301View removeFromSuperview];
						break;
										
			default: 	break;
		}
	}
}


-(void)initialDisplay
{
	[crm0301View initialize];
	[crm0301View tailorForUser];
	[self loadData];
	[crm0301View display];
}


-(void)loadData
{
	var startkey = [KKRoAUserDomain, KKRoAType];
	var startJSONkey = JSON.stringify(startkey);
	
	var endkey = [KKRoAUserDomain, KKRoAType, {}];
	var endJSONkey = JSON.stringify(endkey);
	
	var dataRequest = new Object();
	dataRequest["action"] = "readDoc";
	dataRequest["key"] = "documents/_design/data/_view/docs_by_list_count?startkey="+startJSONkey+"&endkey="+endJSONkey+"&group=true";
	//alert(dataRequest["key"]);
	
	var responseData = [[RoACouchModule alloc] initWithRequest:dataRequest executeSynchronously:1];
	
	//alert("ne tornano "+[responseData count]);
	
	var crm03Data = [CPArray arrayWithArray:responseData];
	var crm03Tree = [[RoATree alloc] init];
	
	[crm03Tree addNode:"root" withParent:null];
	[crm03Tree addObject:null toNode:"root"];
	
	switch (KKRoAType)
	{
		case "contact":
				var standardLists = ["Tutti", "Effettuati - per data", "Effettuati - per collab.", "Pianificati - per data" , "Pianificati - per collab."];
				break;
		default:
				var standardLists = ["Tutti", "Modificati"];
				break;
	}

	
	for (var k=0; k<[standardLists count]; k++)
	{
		[crm03Tree addNode:standardLists[k] withParent:"root"];
		[crm03Tree addObject:standardLists[k] toNode:standardLists[k]];
	}

										
	[crm03Tree addNode:"Liste Utente" withParent:"root"];
	[crm03Tree addObject:@"Liste Utente" toNode:"Liste Utente"];

	
	//alert("QUANTI DATI HO "+[crm03Data count]);
	
	for (var j=0; j<[crm03Data count]; j++)
	{
		if ( [crm03Data[j]["key"][2] respondsToSelector:@selector(count)])
		{
				// ========== MODIFICATO QUI 

			var childName = crm03Data[j]["key"][2][1];
			var parentName = crm03Data[j]["key"][2][0];
		}
		else
		{
			var childName = crm03Data[j]["key"][2];
		}
		
		[crm03Tree addNode:childName withParent:parentName];
		
		if (crm03Data[j]["value"] > 0)
		{
			[crm03Tree addObject:crm03Data[j] toNode:childName];
		}
	}
	
	// Catch orphan children, i.e. children where there is no explicit parent in the received data
	//
	[crm03Tree adoptOrphans:"Liste Utente"];

	
	[crm03Outline reloadData];
	[crm03Outline expandItem:"Liste Utente"];
}


-(void)listSelection:(CPString)theSelectedList
{
	KKRoAList = theSelectedList;
	
	//alert ("in 03controller listselection "+KKRoARequestPrint);
	var appNotificationCenter = [CPNotificationCenter defaultCenter];
	if (KKRoARequestPrint == false)
	{
		[appNotificationCenter postNotificationName:@"didSelectAList" object:@"Crm01Navigation" userInfo:nil];
	}
	else 
	{
		[appNotificationCenter postNotificationName:@"didRequestPrintForList" object:@"Crm01Navigation" userInfo:nil];
	}
}



-(void)didCompleteSelection:(CPString)aForeignKey
{
	//alert("in crm03controller directAccessForeignKeyIs "+aForeignKey);
	// LOOK UP DB WITH EXTERNAL KEY TO DETERMINE _id
	
	var lookupKey = [KKRoAUserDomain, KKRoAType, escape(aForeignKey)];
	var JSONkey = JSON.stringify(lookupKey);
	
	var lookupObject = new Object();
	lookupObject["action"] = "readDoc";
	lookupObject["key"] = "documents/_design/data/_view/docs_by_foreign_key?key="+JSONkey;
	var lookupDoc = [[RoACouchModule alloc] initWithRequest:lookupObject executeSynchronously:1];

	//alert("lookup "+lookupDoc);
	//listProperties(lookupDoc[0], "lookupDoc[0]");
	//listProperties(lookupDoc[0]["value"], "lookupDoc[0][''value]");

	KKRoAnItem = lookupDoc[0]["value"]["_id"];
	KKRoAForeignKey = lookupDoc[0]["value"]["Foreign_Key"];
	KKRoAAction = "displayRecord";
	var appNotificationCenter = [CPNotificationCenter defaultCenter];
	[appNotificationCenter postNotificationName:@"didRequestDocDisplay" object:@"Crm01Navigation" userInfo:nil];
	
	[crm0301View clearDirectAccess];
	[crm0301View resignFirstResponder];
}


// FIXME: need to check if inserted/modified item is unique - maybe not necessary

-(void)updateLists:(CPButton)aSender
{
	var selectedRow = [[crm03Outline selectedRowIndexes] firstIndex];
	var selectedItem = [crm03Outline itemAtRow:selectedRow];
	var selectedItemIsExpanded = [crm03Outline isItemExpanded:selectedItem];

	if (! selectedItem)
	{
		[crm0302View tailorForCase:"selectItem"];
		return;
	}
	
	var selectedAction = [aSender tag];
	
	switch (selectedAction)
	{
		case "insertButton":
			[crm0302View tailorForCase:"insertItem"];
			break;
		case "insertChildButton":
			[crm0302View tailorForCase:"insertChildItem"];
			break;
		case "deleteButton":
			[crm0302View tailorForCase:"deleteItem"];
			break;
		case "editButton":
			[crm0302View tailorForCase:"editItem"];
			break;
		default:
			break;
	}
}


-(void)responseFromButton:(CPSender)aSender withInputString:(CPString)anInputString
{
	//alert("risposta ricevuta  "+anInputString);
	var newChildName = anInputString;
	
	if (newChildName == "")
	{
		return;
	}

	//alert("BOTTONE SCHIACCIATO "+selectedAction);
	if (selectedAction != "editButton")
	{
		[self updateDocsInList:selectedItem];
		[self updateListsDoc:aSender];
	}
	else
	{
		//alert("DOve dovrebbe essere");
		[self updateDocsInListWithNewListname:selectedItem withNewListname:newChildName];
		[self updateListsDoc:aSender withNewListname:newChildName];
	}

	[crm03Outline reloadData];
	[appNotificationCenter postNotificationName:@"didSelectAList" object:@"Crm01Navigation" userInfo:nil];

	[crm03Outline selectRowIndexes:[CPIndexSet indexSetWithIndex:[crm03Outline rowForItem:"Liste Utente"]] byExtendingSelection:NO];
	[crm03Outline expandItem:"Liste Utente"];
}


-(void)updateListsDoc:(CPButton)aSender
{
	// read database record to update
	//
	var key = [KKRoAUserDomain, KKRoAType];
	var JSONkey = JSON.stringify(key);
	
	//alert(KKRoAType);
	
	var readForUpdate = new Object();
	readForUpdate["action"] = "readDoc";
	readForUpdate["key"] = "documents/_design/data/_view/lists_by_type?key="+JSONkey;
	
	var record = [[RoACouchModule alloc] initWithRequest:readForUpdate executeSynchronously:1];
	//alert("ne tornano "+[record count]);

	switch (selectedAction)
	{
		case "insertButton":
				[self insertItemAtLevel:@"same"];
				break;
		case "insertChildButton":
				[self insertItemAtLevel:@"below"];
				break;
		case "deleteButton":
				[self deleteItem]; 
				break;
		case "editButton":
				[self editItem]; 
				break;
		default: break;
	}
	
	var theListArray = [];
	theListArray = [crm03Tree buildNodesArray];
	
	//alert([crm03Tree treeNodes]);
	
	var update = new Object();
	update["action"] = "writeDoc";
	update["key"] = "documents/"+record[0]["value"]["_id"];
	record[0]["value"]["lists"] = theListArray;
	update["body"] = record[0]["value"];
	var updateData = [[RoACouchModule alloc] initWithRequest:update executeSynchronously:1];
	
	[crm0302View hideView];
}

-(void)updateListsDoc:(CPButton)aSender withNewListname:(CPString)aNewListname
{
	var theNewListname = aNewListname;
	// read database record to update
	//
	var key = [KKRoAUserDomain, KKRoAType];
	var JSONkey = JSON.stringify(key);
	
	//alert(KKRoAType);
	
	var readForUpdate = new Object();
	readForUpdate["action"] = "readDoc";
	readForUpdate["key"] = "documents/_design/data/_view/lists_by_type?key="+JSONkey;
	
	var record = [[RoACouchModule alloc] initWithRequest:readForUpdate executeSynchronously:1];
	//alert("ne tornano "+[record count]);

	switch (selectedAction)
	{
		case "editButton":
				[self editItemWithNewListname:theNewListname]; 
				break;
		default: break;
	}
	
	var theListArray = [];
	theListArray = [crm03Tree buildNodesArray];
	
	//alert([crm03Tree treeNodes]);
	
	var update = new Object();
	update["action"] = "writeDoc";
	update["key"] = "documents/"+record[0]["value"]["_id"];
	record[0]["value"]["lists"] = theListArray;
	update["body"] = record[0]["value"];
	var updateData = [[RoACouchModule alloc] initWithRequest:update executeSynchronously:1];
	
	[crm0302View hideView];
}


-(void)updateDocsInList:(CPString)aSelectedList
{
	var theSelectedList = aSelectedList;
	
	var startkey = [KKRoAUserDomain, KKRoAType, encodeURI(theSelectedList)];
	var startJSONkey = JSON.stringify(startkey);
	
	var endkey = [KKRoAUserDomain, KKRoAType, encodeURI(theSelectedList), {}];
	var endJSONkey = JSON.stringify(endkey);
		
	var readForUpdate = new Object();
	readForUpdate["action"] = "readDoc";
	readForUpdate["key"] = "documents/_design/data/_view/docs_by_list?startkey="+startJSONkey+"&endkey="+endJSONkey;
	
	var docsInSelectedList = [[RoACouchModule alloc] initWithRequest:readForUpdate executeSynchronously:1];
	//listProperties(docsInSelectedList[0], "primo elemento");
	
	for (var i= 0; i< [docsInSelectedList count]; i++)
	{
		var theDocKey = docsInSelectedList[i]["id"];
		var readDoc = new Object();
		readDoc["action"] = "readDoc";
		readDoc["key"] = "documents/"+theDocKey;
		
		var theDoc = [[RoACouchModule alloc] initWithRequest:readDoc executeSynchronously:1];
		var theDocLists = [theDoc["lists"] componentsJoinedByString:","];
		
		//alert("prima dello switch "+selectedAction+ " " +theSelectedList);
		switch (selectedAction)
		{
			case "deleteButton":
					var newString = theDocLists.replace(theSelectedList+",",""); 
					var newString = theDocLists.replace(theSelectedList,""); 
					break;
			default:
					break;
		}
		
		//alert("before "+theDoc["lists"]+" after "+newString);
		
		if (newString != "")
		{
			theDoc["lists"] = [newString componentsSeparatedByString:","];
		}
		else
		{
			theDoc["lists"] = [];
		}
		
		[crm00Models writeDoc:theDoc];	
	}
}


-(void)updateDocsInListWithNewListname:(CPString)aSelectedList withNewListname:(CPString)aNewListname
{
	var theSelectedList = aSelectedList;
	var theNewListname = aNewListname;
	
	var startkey = [KKRoAUserDomain, KKRoAType, encodeURI(theSelectedList)];
	var startJSONkey = JSON.stringify(startkey);
	
	var endkey = [KKRoAUserDomain, KKRoAType, encodeURI(theSelectedList), {}];
	var endJSONkey = JSON.stringify(endkey);
		
	var readForUpdate = new Object();
	readForUpdate["action"] = "readDoc";
	readForUpdate["key"] = "documents/_design/data/_view/docs_by_list?startkey="+startJSONkey+"&endkey="+endJSONkey;
	
	var docsInSelectedList = [[RoACouchModule alloc] initWithRequest:readForUpdate executeSynchronously:1];
	//listProperties(docsInSelectedList[0], "primo elemento");
	
	for (var i= 0; i< [docsInSelectedList count]; i++)
	{
		var theDocKey = docsInSelectedList[i]["id"];
		var readDoc = new Object();
		readDoc["action"] = "readDoc";
		readDoc["key"] = "documents/"+theDocKey;
		
		var theDoc = [[RoACouchModule alloc] initWithRequest:readDoc executeSynchronously:1];
		var theDocLists = [theDoc["lists"] componentsJoinedByString:","];
		
		//alert("prima dello switch "+selectedAction+ " " +theSelectedList);
		switch (selectedAction)
		{
			case "editButton":
					var newString = theDocLists.replace(theSelectedList+",", theNewListname); 
					var newString = theDocLists.replace(theSelectedList, theNewListname); 
					break;
			default:
					break;
		}
		
		//alert("before "+theDoc["lists"]+" after "+newString);
		theDoc["lists"] = [newString componentsSeparatedByString:","];
		[crm00Models writeDoc:theDoc];	
	}
}


-(void)insertItemAtLevel:(CPString)theLevel
{
	if (theLevel === @"below")
	{
		var newParentName = selectedItem;
	}
	else
	{
		var newParentName = [crm03Outline parentForItem:selectedItem];
	}
		
	var childName = newChildName;
	var parentName = newParentName;
	var childObject = newChildName;

	//alert("IN INSERT "+newChildName+" - "+newParentName);
	[crm03Tree addNode:childName withParent:parentName];
	[crm03Tree addObject:childObject toNode:childName];
}



-(id)deleteItem
{
	var selectedRow = [[crm03Outline selectedRowIndexes] firstIndex];
	var selectedItem = [crm03Outline itemAtRow:selectedRow];
	var selectedItemIsExpanded = [crm03Outline isItemExpanded:selectedItem];
	
	var itemWithChildrenWarning = "";
	if ([crm03Outline isExpandable:selectedItem])
		itemWithChildrenWarning = " con tutte le sub-liste";
	
	if (selectedItem)
		[crm0302View tailorForCase:"deleteItem"];
	else
		[crm0302View tailorForCase:"selectItem"];
	
	if (selectedItem)
	{
		//alert ("dentro remove del controller prima ");
		[crm03Tree removeNode:selectedItem];
	}
}



-(id)editItemWithNewListname:(CPString)aNewListname
{
	var theNewListname = aNewListname;
	
	var selectedRow = [[crm03Outline selectedRowIndexes] firstIndex];
	var selectedItem = [crm03Outline itemAtRow:selectedRow];
	var selectedItemIsExpanded = [crm03Outline isItemExpanded:selectedItem];
		
	if (selectedItem)
	{
		[crm0302View tailorForCase:"renameItem"];
		[crm03Tree renameNode:selectedItem withNewName:theNewListname];
		//alert("SUBITO DOPO IL RENAME " +[crm03Tree treeNodes]);
	}
}


//++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
// Delegate Methods to control outline behaviour
//
-(int)outlineView:(CPOutlineView)outlineView numberOfChildrenOfItem:(id)item
{
	if (item == null)
	{
		item = "root";
	}
	//alert("A "+item+" ,   "+[[crm03Tree childNodesForKey:item] count]);
	return [[crm03Tree childNodesForKey:item] count];
}

-(BOOL)outlineView:(CPOutlineView)outlineView isItemExpandable:(id)item
{
	//alert("B "+item);
	if (item == null)
		return false;
	else
		return [[crm03Tree childNodesForKey:item] count] > 0;
}

-(id)outlineView:(CPOutlineView)outlineView child:(int)index ofItem:(id)item
{
	if (item == null)
	{
		item = "root";
	}
	//alert("C "+item+" ,   "+[crm03Tree childNodesForKey:item][index]);
	return [crm03Tree childNodesForKey:item][index];
}

-(id)outlineView:(CPOutlineView)outlineView objectValueForTableColumn:(CPTableColumn)tableColumn byItem:(id)item
{
	//alert("D "+anObject);
	return item;
}


@end