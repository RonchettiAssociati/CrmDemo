/*
 * RoADataTableView.j
 * WktTest63
 *
 * Created by Bruno Ronchetti on December 2, 2009.
 * Copyright 2009, Ronchetti & Associati All rights reserved.
 */
 
@import <Foundation/CPObject.j>


@implementation RoADataTableView : CPView
{
	CPArray id	readTableRows;
	CPArray id	readTableHeaders;
	
	CPArray id	existingTableObjects;
	CPArray id	existingTableHeaders;
	
	CPArray id	displayedTableObjects;
	CPArray id	displayedTableHeaders;

	CPOBject	id	selectionDelegate;
	CPTableView	id	myTableView01	@accessors;
}


-(void)initWithFrame:(CPFrame)aFrame
{
	self = [super initWithFrame:aFrame];
	
	if (self)
	{
		return self;
	}
}

//FIXME manca un metodo equivalente con forData:
//
-(void)layoutSkipping:(CPArray)skipHeaders including:(CPArray)includeHeaders
{
		
	var myScrollView01 = [[CPScrollView alloc] initWithFrame:CGRectInset([self bounds], 20.0, 20.0)];
	[myScrollView01 setAutohidesScrollers:NO];
	[myScrollView01 setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];

	myTableView01 = [[CPTableView alloc] initWithFrame:CGRectMakeZero()];
	[myTableView01 setTag:"myTableView01"];
	//[myTableView01 setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
	[myTableView01 setAllowsColumnResizing:YES];
	[myTableView01 setAllowsMultipleSelection:YES];
	
	[myTableView01 sizeLastColumnToFit];
	[myTableView01 setUsesAlternatingRowBackgroundColors:YES];
	[myTableView01 setAlternatingRowBackgroundColors:[[CPColor whiteColor], KKRoABackgroundWhite]];

	[myTableView01 setRowHeight:18];
	[myTableView01 setGridStyleMask:CPTableViewSolidVerticalGridLineMask];

	var textDataView01 = [CPTextField new];
	
	var displayedTableHeaders = [];
	var displayedColumnWidths = [];

	if ([includeHeaders[0] count] > 0) 
	{
		displayedTableHeaders = [CPArray arrayWithArray:includeHeaders[0]];
		displayedColumnWidths = [CPArray arrayWithArray:includeHeaders[1]];
	}
	else
	{
		[existingTableHeaders removeObjectsInArray:skipHeaders];
		displayedTableHeaders = [existingTableHeaders copy];
		displayedColumnWidths = [];
	}

	
	var tableWidth = 0;
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
		if (displayedColumnWidths[i-1])
		{
			[column setWidth:displayedColumnWidths[i-1]];
		}	
		[column setDataView:textDataView01];
					
		[myTableView01 addTableColumn:column];
		tableWidth = tableWidth + [column width];
	}

	//[myTableView01 setDelegate:self];
	[myTableView01 setDataSource:self];
	
	[myScrollView01 setDocumentView:myTableView01];
	
	var scrollSize = CGSizeMake(tableWidth+ 15.0, [myScrollView01 frame].size.height);
	[myScrollView01 setFrameSize:scrollSize];
	[myTableView01 sizeLastColumnToFit];
	
	[self addSubview:myScrollView01];
}



-(CPArray)selectedTableObjects
{
	return [existingTableObjects objectsAtIndexes:[myTableView01 selectedRowIndexes]];
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
	
	//alert(" +++++++++ prima di leggere in DatatableView "+dataRequest["key"]);
	
	var readTableRows = [[RoACouchModule alloc] initWithRequest:dataRequest executeSynchronously:1];

	//alert(aKey+"   "+[readTableRows count]);
	//listProperties(readTableRows[0]["value"], "readTableRows");

	var existingTableObjects = [];
	var existingHeadersDict = [CPDictionary dictionary];
	
	for (var i=0; i<[readTableRows count]; i++)
	{
		var customObject = [[RoAObject alloc] init];
		
		//listProperties(readTableRows[i],"questo è il record letto ");
		
		// le properties sono sia quelle del doc (passato con includeDocs nella query,
		// sia quelle di un eventualeoggetto passato nella value della query stessa
		
		for (var property in readTableRows[i]["doc"])
		{
			if ( ! [existingHeadersDict containsKey:property]) {
				[existingHeadersDict setValue:"present" forKey:property];
			}
			customObject[property] = readTableRows[i]["doc"][property];
		}
		
		for (var property in readTableRows[i]["value"])
		{
			if ( ! [existingHeadersDict containsKey:property]) {
				[existingHeadersDict setValue:"present" forKey:property];
			}
			customObject[property] = readTableRows[i]["value"][property];
		}
		
		[existingTableObjects addObject:[CPDictionary dictionaryWithJSObject:customObject recursively:NO]];
	}
	
	existingTableHeaders = [existingHeadersDict allKeys];
	//alert("alla fine di loaddata datatableview "+existingTableHeaders);
	//listProperties(existingTableObjects[0], "existingTableObjects");
	[myTableView01 reloadData];
	
}




//---------------------------------------------------------------------
// SORT AND FILTER METHODS
// 
//


-(void)filterTable:(CPString)aSearchString
{

	//alert("in filterTable di datatableview con searhcstribg "+aSearchString);
	if (aSearchString === "") {
		[myTableView01 deselectAll]
	}
	else {
		[myTableView01 deselectAll]
		
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
		[myTableView01 selectRowIndexes:selectedRowIndexes byExtendingSelection:NO];
		[myTableView01 reloadData];
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
	//[aView reloadData];
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



//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


@implementation XXXRoAObject : CPObject
{
}

-valueForKey:aKey
{	
	if ( self[aKey]) {
		if ( Date.parse(self[aKey]))  {
			//alert(self["Cognome"]+ " "+self[aKey]+" "+Date.parse(self[aKey]));
			return Date.parse(self[aKey]);
		}
		else {
			return self[aKey];
		}
	}
	else {
		return "";
	}
}
@end


