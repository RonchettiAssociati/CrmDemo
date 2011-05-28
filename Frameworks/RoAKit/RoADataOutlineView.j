/*
 * RoADataOutlineView.j
 * WktTest63
 *
 * Created by Bruno Ronchetti on December 2, 2009.
 * Copyright 2009, Ronchetti & Associati All rights reserved.
 */
 


@import <Foundation/CPObject.j>


colorBRoLabel = [CPColor colorWithCalibratedRed:103/255 green:111/255 blue:114/255 alpha:0.9];


@implementation RoADataOutlineView : CPView
{
	CPArray id	tableRows;
	CPArray id	readTableHeaders;
	
	CPArray id	existingTableObjects;
	CPArray id	existingTableHeaders;
	
	CPArray id	displayedTableObjects;
	CPArray id	displayedTableHeaders;

	CPOBject	id	selectionDelegate;
	CPTableView	id	outlineView01	@accessors;
	
	RoATree	id	nodeTree;
}


- (void)initWithFrame:(CPFrame)aFrame skip:(CPArray)skipHeaders include:(CPArray)includeHeaders
{
	self = [self initWithFrame:aFrame forData:null skip:skipHeaders include:includeHeaders];
	return self;
}

- (void)initWithFrame:(CPFrame)aFrame forData:(CPString)aKey skip:(CPArray)skipHeaders include:(CPArray)includeHeaders
{
	self = [super initWithFrame:aFrame];
	
	if (self)
	{
		
					
		// Lay out Outline
		//
		var scrollView01 = [[CPScrollView alloc] initWithFrame:CGRectInset([self bounds], 20.0, 20.0)];
    	[scrollView01 setAutohidesScrollers:YES];
		[scrollView01 setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];

		outlineView01 = [[CPOutlineView alloc] initWithFrame:CGRectMakeZero()];
		[outlineView01 setTag:"outlineView01"];
		[outlineView01 setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
		[outlineView01 setAllowsColumnResizing:YES];
		[outlineView01 setAllowsMultipleSelection:YES];

		[outlineView01 sizeLastColumnToFit];
    	[outlineView01 setUsesAlternatingRowBackgroundColors:YES];
		[outlineView01 setAlternatingRowBackgroundColors:[[CPColor whiteColor], KKRoABackgroundWhite]];
		[outlineView01 setRowHeight:18];
    	[outlineView01 setGridStyleMask:CPTableViewSolidVerticalGridLineMask];
		
				
		var outlineColumn = [[CPTableColumn alloc] initWithIdentifier:"outlineColumn"];
		[outlineColumn setEditable:NO];
		[outlineColumn setWidth:20];
		var outlineItemView = [[CPTextField alloc] initWithFrame:CGRectMake(0,0, 30, 30)];
		[outlineColumn setDataView:outlineItemView];
		
		[outlineView01 setIndentationPerLevel:12];
		[outlineView01 addTableColumn:outlineColumn];
		[outlineView01 setOutlineTableColumn:outlineColumn];
		

		

		//[self loadData:aKey];

		// Lay out rest of Table
		//		
		var textDataView01 = [CPTextField new];
		
		displayedTableHeaders = [];
		if ([includeHeaders count] > 0) {
			displayedTableHeaders = [includeHeaders copy];
		}
		else {
			[existingTableHeaders removeObjectsInArray:skipHeaders];
			displayedTableHeaders = [existingTableHeaders copy];
		}
							
		for (var i =1; i <= [displayedTableHeaders count]; i++)
		{
			var columnString 	= displayedTableHeaders[i-1];			
			var column = [[CPTableColumn alloc] initWithIdentifier:columnString];
			[[column headerView] setStringValue:columnString.split("_").join(" ")];
			//[[[column headerView] textField] setFont:KKRoALabelFont];
			[[[column headerView] textField] setTextColor:KKRoALabelColor];
			
			var sortDescriptor = [[CPSortDescriptor alloc] initWithKey:columnString ascending:NO];	
			[column setSortDescriptorPrototype:sortDescriptor];
			
			[column setWidth:100.0];
			
			[column setDataView:textDataView01];
						
			[outlineView01 addTableColumn:column];
		}

		[outlineView01 setDelegate:self];
    	[outlineView01 setDataSource:self];
		
		[scrollView01 setDocumentView:outlineView01];
		[self addSubview:scrollView01];
				
		[outlineView01 reloadData];

		return self;
	}
}


-(CPArray)selectedTableObjects
{
	return [existingTableObjects objectsAtIndexes:[outlineView01 selectedRowIndexes]];
}

- (int)columnHeaders
{
	// FIXME: Se si toglie l'alert displayedTableHeaders non è valorizzata
	alert ("nel controller a "+[displayedTableHeaders count]);
	return displayedTableHeaders;
}



//-------------------------------------------------------------------------------------------------
//

-(void)tableView:(CPTableView)aView sortDescriptorsDidChange:(CPArray)oldDescriptors
{	
	//alert("sortdescriptors did change");
	var oldIndexes = [outlineView01 selectedRowIndexes];
	var oldUniqueObjects = [existingTableObjects objectsAtIndexes:oldIndexes];

	[existingTableObjects sortUsingDescriptors:[aView sortDescriptors]];

	var newIndexes = [[CPIndexSet alloc] init];
	for (var j=0; j<[existingTableObjects count]; j++)
	{
		if ( [oldUniqueObjects containsObject:existingTableObjects[j]] ) {
			[newIndexes addIndex:j];
		}		
	}
	
	[outlineView01 selectRowIndexes:newIndexes byExtendingSelection:NO];
	[outlineView01 reloadData];
}


//-------------------------------------------------------------------------------------------------
//

-(id)loadData:(CPString)aKey
{
	// Read data from database
	//
	var dataRequest = new Object();
	dataRequest["action"] = "readDoc";
	dataRequest["key"] = aKey;
	
	//alert(" +++++++++ prima di leggere "+dataRequest["key"]);
	
	var tableRows = [[RoACouchModule alloc] initWithRequest:dataRequest executeSynchronously:1];

	//alert(" +++++++++ dopo aver letto "+[tableRows count]);
	//listProperties(tableRows[0], "tableRows");

	var existingTableObjects = [];
	var existingHeadersDict = [CPDictionary dictionary];
	
	for (var i=0; i<[tableRows count]; i++)
	{
		var customObject = [[CPObject alloc] init];
		//var customObject = [[RoAObject alloc] init];
		for (var property in tableRows[i]["doc"])
		{
			if ( ! [existingHeadersDict containsKey:property]) {
				[existingHeadersDict setValue:"present" forKey:property];
			}
			customObject[property] = tableRows[i]["doc"][property];
		}
		[existingTableObjects addObject:customObject];
	}
		
	existingTableHeaders = [existingHeadersDict allKeys];
	//alert(" +++++++++ alla fine della lettura della tabella "+existingTableHeaders+" Objects "+[existingTableObjects count]);

	//---------------------------------------------------------------------


	var dataRequest = new Object();
	dataRequest["action"] = "readDoc";
	dataRequest["key"] = "documents/_design/"+aKey;
	tableRows = [[RoACouchModule alloc] initWithRequest:dataRequest executeSynchronously:1];

	//alert(" +++++++++ dopo lettura per tree");
	var treeRows = tableRows;
	var nodeTree = [[RoATree alloc] init];
	
	//FIXME qui mettere dei nodi standard differenziati per tipo

	[nodeTree addNode:"root" withParent:null];
	[nodeTree addObject:null toNode:"root"];
	
	for (var j=0; j<[treeRows count]; j++) {
		if ( treeRows[j]["doc"]["Contatto Precedente"] ) {
			var childName = treeRows[j]["doc"]["_id"];
			var parentName = treeRows[j]["doc"]["Contatto Precedente"];
		}
		else {
			var childName = treeRows[j]["doc"]["_id"];
		}
		[nodeTree addNode:childName withParent:parentName];
		[nodeTree addObject:treeRows[j] toNode:childName];
	}

// Catch orphan children, i.e. children where there is no explicit parent in the received data
//
	[nodeTree adoptOrphans:"root"];
	
	[outlineView01 reloadData];
}




//---------------------------------------------------------------------
// SORT AND FILTER METHODS
// 
//


-(void)filterTable:(CPString)aSearchString
{
	//alert("in filterTable di RoADataOutlineView con searhcstribg "+aSearchString);
	if (aSearchString === "") {
		[outlineView01 deselectAll]
	}
	else {
		[outlineView01 deselectAll]
		
		var aModifiedString = aSearchString.replace(/[*]/, "[a-z,A-Z]");
		//alert ("dopo la sostutuzione "+aSearchString+" "+aModifiedString);

		var selectedRowIndexes = [[CPIndexSet alloc] init];
		for (var j=0; j<[existingTableObjects count]; j++)
		{
			var object = existingTableObjects[j];
			var objectDictionary = [object dictionaryWithValuesForKeys:displayedTableHeaders];
			
			var keys = [objectDictionary allKeys];
			var keyValue = "";
			var values = [];
	         
	     	for (var i=0; i<[keys count]; i++) {
				keyValue = [existingTableObjects[j] valueForKey:keys[i]];
				if ( Date.parse(keyValue))  {
					values.push(Date.parse(keyValue).toLocaleDateString());
				}
				else {
	         		values.push(keyValue);
				}
			}
			
			var objectStrings = values.join(" ");
			
			//alert(object["Cognome"] +" " +objectStrings + " : "+objectStrings.search(aSearchString));
			//listProperties(object, "object");
			if (objectStrings.search(aModifiedString) != -1) {
				[selectedRowIndexes addIndex:j];
			}		
		}
		[outlineView01 selectRowIndexes:selectedRowIndexes byExtendingSelection:NO];
		[outlineView01 reloadData];
	}
}


-(void)setSelectionDelegate:(CPobject)aSelectionDelegate
{
	selectionDelegate = aSelectionDelegate;
}

-(void)tableViewSelectionDidChange:(CPNotification)aNotification
{
	[selectionDelegate tableSelectionDidChange];
}
	 


-(void)tableViewSelectionIsChanging:(CPNotification)aNotification
{
	//alert("selectedRowIndexes BB");
}



//++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
// Delegate Methods to control outline behaviour
//
-(int)outlineView:(CPOutlineView)outlineView numberOfChildrenOfItem:(id)item
{
	if (item === null)
		return [[nodeTree childNodesForKey:"root"] count];
	else
		return [[nodeTree childNodesForKey:item] count];
}

-(BOOL)outlineView:(CPOutlineView)outlineView isItemExpandable:(id)item
{
	if (item === null)
		return false;
	else
		return [[nodeTree childNodesForKey:item] count] > 0;
}

-(id)outlineView:(CPOutlineView)outlineView child:(int)index ofItem:(id)item
{
	if (item === null)
		return [nodeTree childNodesForKey:"root"][index];
	else
		return [nodeTree childNodesForKey:item][index];
}

-(id)outlineView:(CPOutlineView)outlineView objectValueForTableColumn:(CPTableColumn)tableColumn byItem:(id)item
{
	if ([tableColumn identifier] == "outlineColumn") {
		return "";
	}
	else {
		var column = [tableColumn identifier];
		return [nodeTree objectForKey:item]["representedObject"]["doc"][column];
	}
	
}



// STANDARD METHODS TO POPULATE TABLE
// ------------------------------------------------------


-(void)tableView:(CPTableView)aView sortDescriptorsDidChange:(CPArray)oldDescriptors
{
	//alert(" in sortdescriptordidchange");	

	//listProperties([aView sortDescriptors][0], "sortdescriptors");
	
	var oldIndexes = [aView selectedRowIndexes];
	var oldUniqueObjects = [existingTableObjects objectsAtIndexes:oldIndexes];
	
	[existingTableObjects sortUsingDescriptors:[aView sortDescriptors]];

	var newIndexes = [[CPIndexSet alloc] init];
	for (var j=0; j<[existingTableObjects count]; j++)
	{
		if ( [oldUniqueObjects containsObject:existingTableObjects[j]] )
		{
			[newIndexes addIndex:j];
		}		
	}
	
	[aView selectRowIndexes:newIndexes byExtendingSelection:NO];
	[aView reloadData];
}


- (id)tableView:(CPTableView)aTableView objectValueForTableColumn:(CPTableColumn)aTableColumn row:(CPInteger)aRowIndex
{
	//alert ("nel controller b nudo");
	if (aRowIndex >= 0 && aRowIndex < [existingTableObjects count])
	{
		var key = [aTableColumn identifier];
		return [existingTableObjects[aRowIndex] objectForKey:key];
	}	
}


- (id)tableView:(CPTableView)aTableView setObjectValue:(CPString)theNewValue forTableColumn:(CPString)aTableColumnHeaderString row:(CPInteger)aRowIndex
{
	//alert ("nel controller c");
	if (aRowIndex >= 0 && aRowIndex < [existingTableObjects count])
	{
		var key = [aTableColumn identifier];
		[existingTableObjects[aRowIndex] setValue:theNewValue forKey:key];
	}
	//[aTableView reloadData];
}


- (int)numberOfRowsInTableView:(CPTableView)aTableView
{
	//alert ("nel controller d "+[existingTableObjects count] );
	return [existingTableObjects count];
}


- (id)tableView:(CPTableView)aTableView heightOfRow:(int)row
{
	//alert ("nel controller e "+row );
    return 20 + ROUND(row * 0.5);
}

@end

