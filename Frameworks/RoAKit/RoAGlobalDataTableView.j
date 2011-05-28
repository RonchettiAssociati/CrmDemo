/*
 * RoAGlobalDataTableView.j
 * WktTest63
 *
 * Created by Bruno Ronchetti on December 2, 2009.
 * Copyright 2009, Ronchetti & Associati All rights reserved.
 */
 


@import <Foundation/CPObject.j>

@implementation RoAGlobalDataTableView : CPTableView
{
	CPArray id	readTableRows;
	CPArray id	readTableHeaders;
	
	CPArray id	existingTableObjects;
	CPArray id	existingTableHeaders;
	
	CPArray id	displayedTableObjects;
	CPArray id	displayedTableHeaders;
	
	CPTableView id	myTableView01	@accessors;
	
}


- (void)initWithFrame:(CPFrame)aFrame forData:(CPString)aSearchString skip:(CPArray)skipHeaders include:(CPArray)includeHeaders
{	
	self = [super initWithFrame:aFrame];
	
	if (self)
	{
	
		var readTableRows = [];

		[self loadData:aSearchString];
		
		// Lay out Table
		//
		var myScrollView01 = [[CPScrollView alloc] initWithFrame:aFrame];
    	[myScrollView01 setAutohidesScrollers:YES];
		[myScrollView01 setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];

		myTableView01 = [[CPTableView alloc] initWithFrame:CGRectMakeZero()];
		[myTableView01 setTag:"myTableView01"];
		//[myTableView01 setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
		[myTableView01 setAllowsColumnResizing:YES];
		[myTableView01 setAllowsMultipleSelection:YES];

		//[myTableView01 sizeLastColumnToFit];
    	[myTableView01 setUsesAlternatingRowBackgroundColors:YES];
		[myTableView01 setAlternatingRowBackgroundColors:[[CPColor whiteColor], KKRoABackgroundWhite]];

		//[myTableView01 setRowHeight:18];
		[myTableView01 setRowHeight:20];
    	[myTableView01 setGridStyleMask:CPTableViewSolidVerticalGridLineMask];
	
		var textDataView01 = [CPTextField new];
		[textDataView01 setFont:[CPFont systemFontOfSize:12]];

		var displayedTableHeaders = [];
		var displayedColumnWidths = [];

		if ([includeHeaders[0] count] > 0) {
			displayedTableHeaders = [CPArray arrayWithArray:includeHeaders[0]];
			displayedColumnWidths = [CPArray arrayWithArray:includeHeaders[1]];
		}
		else {
			[existingTableHeaders removeObjectsInArray:skipHeaders];
			displayedTableHeaders = [existingTableHeaders copy];
			displayedColumnWidths = [];
		}
		
							
		for (var i =1; i <= [displayedTableHeaders count]; i++)
		{
			var columnString 	= displayedTableHeaders[i-1];			
			var column = [[CPTableColumn alloc] initWithIdentifier:columnString];
			[[column headerView] setStringValue:columnString.split("_").join(" ")];
			[[[column headerView] textField] setTextColor:KKRoALabelColor];
			[[[column headerView] textField] setFont:KKRoaTableHeaderFont];

			
			var sortDescriptor = [[CPSortDescriptor alloc] initWithKey:columnString ascending:NO];	
			[column setSortDescriptorPrototype:sortDescriptor];
			
			[column setWidth:100.0];
			if (displayedColumnWidths[i-1])
			{
				[column setWidth:displayedColumnWidths[i-1]];
			}
			[column setDataView:textDataView01];
						
			[myTableView01 addTableColumn:column];
		}


		[myTableView01 setDelegate:self];
		[myTableView01 setDataSource:self];
		//[myTableView01 setTarget:self];
		//[myTableView01 setDoubleAction:@"doubleClick"];
		
		[myScrollView01 setDocumentView:myTableView01];
		
		//[app1001View addSubview:myScrollView01];
		[self addSubview:myScrollView01];
		return self;
	}
}



-(CPArray)selectedTableObjects
{
	var index =[[myTableView01 selectedRowIndexes] firstIndex];
	return existingTableObjects[index];
}

- (int)columnHeaders
{
	// FIXME: Se si toglie l'alert displayedTableHeaders non è valorizzata
	//alert ("nel controller a "+[displayedTableHeaders count]);
	return displayedTableHeaders;
}



//-------------------------------------------------------------------------------------------------
//

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


//-------------------------------------------------------------------------------------------------
//

-(id)loadData:(CPString)aKey
{
	// Read data from database
	//
	var dataRequest = new Object();
	dataRequest["action"] = "readDoc";
	dataRequest["key"] = "documents/_fti/_design/lucene/by_type?q="+aKey;
	
	var readTableRows = [];
	var readTableRows = [[RoACouchModule alloc] initWithRequest:dataRequest executeSynchronously:1];

	//listProperties(readTableRows, "readTableRows dopo lettura");
	//listProperties(readTableRows[0], "readTableRows dopo lettura");
	//listProperties(readTableRows[0].doc, "readTableRows dopo lettura .doc");
	
	var existingTableObjects = [];
	var existingHeadersDict = [CPDictionary dictionary];
	
	for (var i=0; i<[readTableRows count]; i++)
	{
	
		var dataRequest = new Object();
		dataRequest["action"] = "readDoc";
		dataRequest["key"] = "documents/"+readTableRows[i]["id"];
		var readDoc = [[RoACouchModule alloc] initWithRequest:dataRequest executeSynchronously:1];
		
		//alert("dopo la lettura "+readDoc);
		//listProperties(readDoc, "dopo la lettura");

		readTableRows[i]["doc"] = readDoc;
		
		var customObject = [[RoAObject alloc] init];
		
		for (var property in readTableRows[i]["doc"])
		{
			if ( ! [existingHeadersDict containsKey:property]) {
				[existingHeadersDict setValue:"present" forKey:property];
			}
			customObject[property] = readTableRows[i]["doc"][property];
		}
		[existingTableObjects addObject:[CPDictionary dictionaryWithJSObject:customObject recursively:NO]];
	}
	
	//alert("in loaddata alla fine del loop "+[existingTableObjects count]+" "+[existingHeadersDict count]);

	//
	//	
	existingTableHeaders = [existingHeadersDict allKeys];
	
	//[myTableView01 reloadData];
}


-(void)numberOfHits
{
	return [existingTableObjects count];
}

//---------------------------------------------------------------------
// SORT AND FILTER METHODS
// 
//


-(void)filterTable:(CPString)aSearchString
{
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
			
			var objectStrings = values.join("");
			
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


-(void)tableViewSelectionDidChange:(CPNotification)aNotification
{
	//alert("selectedRowIndexes AA");
}

-(void)tableViewSelectionIsChanging:(CPNotification)aNotification
{
	//alert("selectedRowIndexes BB");
}




// STANDARD METHODS TO POPULATE TABLE
// ------------------------------------------------------

- (id)tableView:(CPTableView)aTableView objectValueForTableColumn:(CPTableColumn)aTableColumn row:(CPInteger)aRowIndex
{
	//alert ("nel controller b "+[aTableColumn identifier] + " - "+[[existingTableObjects[aRowIndex] objectForKey:[aTableColumn identifier]] respondsToSelector:@selector(count)]);
	
	var key = [aTableColumn identifier];

	if (aRowIndex >= 0 && aRowIndex < [existingTableObjects count])
	{
		theValue = [existingTableObjects[aRowIndex] objectForKey:key];
	}

	if ([[existingTableObjects[aRowIndex] objectForKey:[aTableColumn identifier]] respondsToSelector:@selector(count)])
	{
		//theValue = "CIUPPA";
		//listProperties([existingTableObjects[aRowIndex] objectForKey:[aTableColumn identifier]], "ciuppa");
		theValue = listArray([existingTableObjects[aRowIndex] objectForKey:[aTableColumn identifier]]);
	}
	
	
	if (aTableColumn === nil)
	{
		alert("row "+aRowIndex+ "is a group row");
	}
	
	return theValue;
}


- (id)tableView:(CPTableView)aTableView setObjectValue:(CPString)theNewValue forTableColumn:(CPTableColumn)aTableColum row:(CPInteger)aRowIndex
{
	//alert ("nel controller c");
	if (aRowIndex >= 0 && aRowIndex < [existingTableObjects count])
	{
		var key = [aTableColumn identifier];
		[existingTableObjects[aRowIndex] setValue:theNewValue forKey:key];
	}
}


- (int)numberOfRowsInTableView:(CPTableView)aTableView
{
	//alert ("nel controller d "+[existingTableObjects count] );
	return [existingTableObjects count];
}


- (id)tableView:(CPTableView)aTableView heightOfRow:(int)row
{
	//alert ("nel controller e "+row );
    return 30;
}



@end



//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

@implementation RoAObject : CPObject
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


@implementation CPTableView (myCorrections)
{
}


@end

