/*
 * RoAFormTable.j
 * RoACrm
 *
 * Created by Bruno Ronchetti on March 5, 2011
 */



@import <Foundation/CPObject.j>


@implementation RoAFormTable : CPView
{
	CPObject			id	theDescriptor;
	CPArray				id	itemsArray;				// an array of dictionaries
	CPArray				id	displayedTableHeaders;
	CPArray				id	theColumnTypeArray;
	
	CPScrollView		id	theScrollView;
	CPPoint				id	theLabelOrigin;
	CPTextField			id	theLabel;
	
	CPNotificationCenter 	id appNotificationCenter;
	
	CPView				id	targetView @accessors;
	CPTableView			id	theTable @accessors;
	
	CPObject			id	userInfo;
	
	CrmFormTableButton	id	addButton;
	CrmFormTableButton	id	clearButton;
	
	BOOL				id	cellValueHasBeenSetByHelp;
	
	CPDictionary		id	errorViewsDictionary;
}


-(void)initWithDescriptor:(CPObject)aDescriptor atYPosition:(float)aYPosition
{
	self = [super init];
	
	if (self)
	{
		var appNotificationCenter = [CPNotificationCenter defaultCenter];
		[appNotificationCenter addObserver:self selector:"navigation:" name:nil object:@"Crm01Navigation"];	
		
		var theDescriptor = aDescriptor;
		var displayedTableHeaders = [CPArray arrayWithArray:theDescriptor["columns"]];
		var theColumnTypeArray = [CPArray arrayWithArray:theDescriptor["columnTypes"]];

		var theYPosition = aYPosition;
		var theXPosition = (theDescriptor["position"]) ? theDescriptor["position"] : 130;
		var theTableWidth = theDescriptor["size"][0];
		var theTableHeight = theDescriptor["size"][1];
		[self setFrameOrigin:CGPointMake(theXPosition, theYPosition+ 6.0)];
		[self setFrameSize:CGSizeMake(theTableWidth, theTableHeight)];
		
		var theLabelOrigin = CGPointMake(theXPosition- 130.0, theYPosition+ 10.0);
		
		var cellValueHasBeenSetByHelp = false;
		var itemsArray = [];

		//[self setDefaultValues];
		[self initialize];
		return self;
	}
}

-(void)navigation:(CPNotification)aNotification
{
	if ([aNotification object] === @"Crm01Navigation" && [aNotification userInfo] && [aNotification userInfo]["tableView"] === self)
	{
		switch ([aNotification name])
		{			
			case "helpDidSelectValueForTable":
				var userInfo = [aNotification userInfo];
				var row = userInfo["editedRow"];
				var column = userInfo["editedColumn"];
				[itemsArray[row] setValue:userInfo["selectedHelpValue"] forKey:column];
				[theTable reloadDataForRowIndexes:row columnIndexes:[theTable columnWithIdentifier:column]];
				[targetView formDidChange];
				cellValueHasBeenSetByHelp = true;
				break;
				
			default:
				break;
		}
	}
}

/*
-(void)setDefaultValues
{	
	var itemsArray = [];
	var myObject1 = [[CPObject alloc] init];
	myObject1["Azienda"] =  "ciuppa 1";
	myObject1["Ruolo_Azienda"] =  "ruolo 1";
	myObject1["Data_Fine"] =  "gunga 1";
	[itemsArray addObject:myObject1];
	
	var myObject2 = [[CPObject alloc] init];	
	myObject2["Azienda"] =  "ciuppa 2";
	myObject2["Ruolo_Azienda"] =  "ruolo 2";
	myObject2["Data_Fine"] =  "gunga 12";
	[itemsArray addObject:myObject2];
	
    for (var i = 0; i < [itemsArray count]; i++)
	{
		var dictionary = [CPDictionary dictionaryWithJSObject:itemsArray[i] recursively:NO];
        [itemsArray replaceObjectAtIndex:i withObject:dictionary];
	}
}
*/	

-(void)initialize
{
	var theScrollViewOrigin = CGPointMake(0.0, 0.0);

	var isOutputOnly = false;
	var isAllowingInsert = false;

	var theLabel = [[CPTextField alloc] initWithFrame:CGRectMakeZero()];
	[theLabel setFrameOrigin:theLabelOrigin];
	[theLabel setFrameSize:CGSizeMake(120.0, 26.0)];
	var labelString = (theDescriptor["label"]) ? theDescriptor["label"] : theDescriptor["item"];
	if (labelString == " ")
	{
		[theLabel setStringValue:""];
	}
	else
	{
		[theLabel setStringValue:labelString+ " :"];
	}
	[theLabel setFont:KKRoALabelFont];
	[theLabel setTextColor:KKRoALabelColor];
	[theLabel setValue:CPRightTextAlignment forThemeAttribute:@"alignment"];
	
	var theScrollView = [[CPScrollView alloc] initWithFrame:[self frame]];
	[theScrollView setHasVerticalScroller:YES];
	[theScrollView setHasHorizontalScroller:NO];
	[theScrollView setAutohidesScrollers:YES];
	[[theScrollView verticalScroller] setControlSize:5];
	
	// theTable
	//
	var theTable = [[CPTableView alloc] initWithFrame:CGRectMakeZero()];
	[theTable setTag:theDescriptor["item"]];
	[theTable setAutoresizingMask:CPViewHeightSizable];
	[theTable setUsesAlternatingRowBackgroundColors:YES];
	[theTable setAlternatingRowBackgroundColors:[[CPColor whiteColor], KKRoABackgroundWhite]];
	[theTable setSelectionHighlightStyle:CPTableViewSelectionHighlightStyleRegular];
	[theTable setSelectionHighlightColor:KKRoAPreSelectionBlue];
	[theTable setGridStyleMask:CPTableViewSolidVerticalGridLineMask];
	[theTable setCornerView:null];
	[theTable setRowHeight:20];
	if ([theDescriptor["columns"] containsObject:"icons"])
	{
		[theTable setRowHeight:60];
	}
	
	[theTable setAllowsColumnReordering:NO];

	// the data Views
	//
	var columnDataView01 = [RoATableInputField new];
	[columnDataView01 setFont:KKRoAFieldFont];
	[columnDataView01 setDelegate:self];
	var columnImageView01 = [[CPImageView alloc] initWithFrame:CGRectMake(0,0,40.0,60.0)];
	[columnImageView01 setImageScaling:CPScaleProportionally];
	
	
	// setup columns
	//
	for (var i =0; i < [displayedTableHeaders count]; i++)
	{
		var columnString 	= displayedTableHeaders[i];
		var column = [[CPTableColumn alloc] initWithIdentifier:columnString];
		[column setWidth:theDescriptor["columnWidths"][i]];
		[[column headerView] setFont:KKRoaTableHeaderFont];
		[[column headerView] setValue:KKRoALabelColor forThemeAttribute:@"text-color" inState:CPThemeStateNormal];

		if (columnString != "icons")
		{
			[[column headerView] setStringValue:RoALocalized(columnString.split("_").join(" "))];
			[column setDataView:columnDataView01];
		}
		else
		{
			[[column headerView] setStringValue:""];
			[column setDataView:columnImageView01];
		}
				
		var sortDescriptor = [[CPSortDescriptor alloc] initWithKey:columnString ascending:YES];	
		[column setSortDescriptorPrototype:sortDescriptor];
		[column setEditable:YES];
		[theTable addTableColumn:column];
	}
	
	// FIXME sizeLastColumnToFit does not work
	//
	[theTable sizeLastColumnToFit];
	
	
	[theTable setSortDescriptors:[[column sortDescriptorPrototype]]];		// initial sort
	var	arrayController = [[CPArrayController alloc] init];
	[theTable bind:@"sortDescriptors" toObject:arrayController withKeyPath:@"sortDescriptors" options:nil];
	[theTable setDelegate:self];

	[theTable setDataSource:self];
	[theScrollView setDocumentView:theTable];

	var addButton = [CPButton buttonWithTitle:"+"];
	[addButton setBezelStyle:CPSmallSquareBezelStyle];
	[addButton setTheme:null];
	[addButton setFrameOrigin:CGPointMake([theScrollView frame].size.width-19.0, -2.0)];
	[addButton setFont:[CPFont boldSystemFontOfSize:18]];
	[addButton setValue:KKRoAMediumLightGray forThemeAttribute:@"text-color" inState:CPThemeStateNormal];
	[addButton setValue:KKRoAMediumBlue forThemeAttribute:@"text-color" inState:CPThemeStateHovered];
	[addButton setValue:KKRoAHighlightBlue forThemeAttribute:@"text-color" inState:CPThemeStateHighlighted];
	[addButton setTarget:self];
	[addButton setAction:@"addRow"];
	[addButton setHidden:YES]; 
	[theScrollView addSubview:addButton];
		
	if (theDescriptor["allowInsert"])
	{
		[addButton setHidden:NO]; 
	}
	
	
	[theTable reloadData];
}

-(void)addRow
{
	var theEmptyDictionary = [CPDictionary dictionary];
	
	for (var i=0; i<[displayedTableHeaders count]; i++)
	{
		[theEmptyDictionary setValue:"" forKey:displayedTableHeaders[i]];
	}
	
	[itemsArray insertObject:theEmptyDictionary atIndex:0];
	[theTable reloadData];
	[theTable selectRowIndexes:[CPIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
}

// ============================================

-(void)setOutputOnly:(BOOL)shouldBeOutputOnly
{
	theDescriptor["outputOnly"] = shouldBeOutputOnly;
	theDescriptor["allowInsert"] = !shouldBeOutputOnly;
	
	[addButton setHidden:shouldBeOutputOnly];	
}

// =============================================

-(void)enhanceIfNeededForString:(CPString)aStringValue
{
	if (aStringValue == "")
		return;
		
	var columnNumber = [theTable editedColumn];
	if (theDescriptor["columnEnhancement"][columnNumber] == NO)
		return;

	var rawValue = aStringValue;
	var enhancedValue = "";
	switch (theDescriptor["columnTypes"][columnNumber])
	{
		case "date":
			if (Date.parse(rawValue))
			{
				var noonOfTheDay = Date.parse(rawValue).addHours(12);
				//alert (noonOfTheDay);
				var enhancedValue = Date.parse(noonOfTheDay).toLocaleDateString();
			}
			break;
			
		case "amount":
			var enhancedValue = rawValue.toString().replace(/\B(?=(?:\d{3})+(?!\d))/g, " ");
			break;
			
		default:
			break;
	}
		
	if (enhancedValue != "")
	{
		var row = [theTable editedRow];
		var columnNumber = [theTable editedColumn];
		var columnIdentifier = theDescriptor["columns"][columnNumber];
		[itemsArray[row] setValue:enhancedValue forKey:columnIdentifier];
		[theTable reloadDataForRowIndexes:row columnIndexes:columnNumber];
		cellValueHasBeenSetByHelp = true;
	}
}


-(void)validateNowForString:(CPString)aStringValue
{
	if ( ! theDescriptor["columnValidation"])
		return;
		
	var columnNumber = [theTable editedColumn];
	var validationDescriptorForColumn = [CPArray arrayWithArray:theDescriptor["columnValidation"][columnNumber]];

	if ([validationDescriptorForColumn count] == 0)
		return;
		
	if (aStringValue == "" && [validationDescriptorForColumn containsObject:"required"] == false)
		return;
		
	if (aStringValue == self.savedScreenValue)
		return;
				
	var validationResult = [[RoAFormFieldValidator alloc] validate:aStringValue forDescriptor:validationDescriptorForColumn];

	if (validationResult === "no error")
	{
		var errorViewIdentifier = [theTable tag]+[theTable editedColumn]+[theTable editedRow];
		
		if (errorViewsDictionary)
		{
			//alert(errorViewsDictionary);
			var theError = 	[errorViewsDictionary objectForKey:errorViewIdentifier];
			//alert("legge errore "+theError);
			[theError setHidden:YES];
		}
	}
	else
	{
		var theError = [[CPTextField alloc] initWithFrame:CGRectMakeZero()];
		//alert("scrive errore "+theError);
		var editedCellFrame = [theTable frameOfDataViewAtColumn:[theTable editedColumn] row:[theTable editedRow]];
		var theErrorFrame = CGRectOffset(editedCellFrame, +50.0, -10.0);
		
		[theError setEnabled:NO];
		[theError setFont:[CPFont boldSystemFontOfSize:10]];
		[theError setBackgroundColor:[CPColor redColor]];
		[theError setTextColor:[CPColor whiteColor]];
		[theError setStringValue:validationResult];
		
		[theError setFrame:[contentView convertRect:theErrorFrame fromView:theTable]];
		[contentView addSubview:theError positioned:CPWindowAbove relativeTo:theTable];
		
		if (! errorViewsDictionary)
		{
			var errorViewsDictionary = [CPDictionary dictionary];
		}
		var errorViewIdentifier = [theTable tag]+[theTable editedColumn]+[theTable editedRow];
		[errorViewsDictionary setObject:theError forKey:errorViewIdentifier];
	}	
}



-(void)setScreenValue:(CPArray)anObjectArray
{	
	//alert("in setscreenvalue "+theDescriptor["item"]+" "+anObjectArray+" "+[displayedTableHeaders count]);
	//listProperties(displayedTableHeaders, theDescriptor["item"]);
	 
	var itemsArray = [];

	if (anObjectArray &&  [anObjectArray count] >0 )
	{
		for (var i = 0; i < [anObjectArray count]; i++)
        	itemsArray[i] = [CPDictionary dictionaryWithJSObject:anObjectArray[i] recursively:NO];
	}

	self["externalValue"] = [CPArray arrayWithArray:itemsArray];
	
	for (var i=0; i<[displayedTableHeaders count]; i++)
	{
		if (theColumnTypeArray[i] == "amount")
		{
			for (var j=0; j<[itemsArray count]; j++)
			{
				var databaseAmount = itemsArray[j][displayedTableHeaders[i]];
				itemsArray[j][displayedTableHeaders[i]] = amountDatabaseToScreen(databaseAmount);
			}
		}
	}
	
	//FIXME si riesce a fare qualche cosa di più chirurgico, invece di un reload totale?
	//
	self["savedScreenValue"] = [CPArray arrayWithArray:itemsArray];
	[theTable reloadData];	
}


-(void)getScreenValue
{	
	//alert("in roaformtable getscreenvalue "+itemsArray);
	
	var existingJSObjects = [];
	
	if ([itemsArray count] <= 0)
	{
		return "";
	}
	
	for (var j =0; j<[itemsArray count]; j++)
	{
		var existingJSObject = new Object();
		var propertyCount = 0;
		var keys = [itemsArray[j] allKeys];
		
		//alert("stiamo per getscreenvalue keys è: "+keys);

		for (var i=0; i<[keys count]; i++)
		{
			var key = keys[i];
			var value = [itemsArray[j] valueForKey:key];
			existingJSObject[key] = value;
			
			if (value != "")
				propertyCount = propertyCount +1;
		}
		
		if (propertyCount > 0)
		{
				[existingJSObjects addObject:existingJSObject];
		}
	}
	
	
	for (var k=0; k<[displayedTableHeaders count]; k++)
	{
		if (theColumnTypeArray[k] == "amount")
		{
			for (var l=0; l<[existingJSObjects count]; l++)
			{
				var screenAmount = existingJSObjects[l][displayedTableHeaders[k]];
				existingJSObjects[l][displayedTableHeaders[k]] = amountScreenToDatabase(screenAmount);
			}
		}
	}

	return existingJSObjects;
}


-(void)setTargetView:(CPView)aTargetView withAnchor:(CPView)anAnchorView
{
	var targetView = aTargetView;
	var anchorView = anAnchorView;
	[targetView addSubview:theScrollView positioned:CPWindowBelow relativeTo:anchorView];
	[targetView addSubview:theLabel positioned:CPWindowBelow relativeTo:anchorView];
}


// ------------------------------------------------------
// TABLE DELEGATE METHODS
// ------------------------------------------------------


- (id)tableView:(CPTableView)aTableView objectValueForTableColumn:(CPTableColumn)aColumn row:(CPInteger)aRow
{
	//alert("carica la cella "+itemsArray);
	//alert("carica la cella "+theDescriptor["item"]+" "+[aColumn identifier]+" "+aRow+" "+[itemsArray[aRow] valueForKey:[aColumn identifier]]);
	if ([aColumn identifier] != "buttonColumn")
	{
    	return [itemsArray[aRow] valueForKey:[aColumn identifier]];
	}
}


-(void)tableView:(CPTableView)aTableView sortDescriptorsDidChange:(CPArray)oldDescriptors
{
	// first we save the selected items
	//
	var oldIndexes = [aTableView selectedRowIndexes];
	var oldSelectedItems = [itemsArray objectsAtIndexes:oldIndexes];
	
	// next we figure out how we're suppose to sort, then sort the data array
	//
    var newDescriptors = [aTableView sortDescriptors];
    [itemsArray sortUsingDescriptors:newDescriptors];

	// then we restore the selection on the rows
	//
	var newIndexes = [[CPIndexSet alloc] init];
	for (var j=0; j<[itemsArray count]; j++)
	{
		if ( [oldSelectedItems containsObject:itemsArray[j]] )
		{
			[newIndexes addIndex:j];
		}		
	}
	[aTableView selectRowIndexes:newIndexes byExtendingSelection:NO];

    // finally we the reload the table data
	//
	[aTableView reloadData];
}


- (id)tableView:(CPTableView)aTableView setObjectValue:(CPString)theNewValue forTableColumn:(CPString)aColumn row:(CPInteger)aRow
{

	//alert (theDescriptor["item"]+" "+theNewValue+" "+[aColumn identifier]+" "+cellValueHasBeenSetByHelp);
	
	//alert(itemsArray);

	if (cellValueHasBeenSetByHelp == true)
	{
		cellValueHasBeenSetByHelp = false;
		return;
	}
	[itemsArray[aRow] setValue:theNewValue forKey:[aColumn identifier]];
}


- (int)numberOfRowsInTableView:(CPTableView)aTableView
{
	return [itemsArray count];
}


- (BOOL)tableView:(CPTableView)aTableView shouldEditTableColumn:(CPTableColumn)aColumn row:(CPInteger)aRow
{
	//alert("in shouldEditTableColumn ");
	//alert("in shouldEditTableColumn "+[aColumn identifier]+ " "+theDescriptor["editableColumns"]);
	
	var userInfo = [CPObject new];
	userInfo["helpNeeded"] = NO;
	cellValueHasBeenSetByHelp = false;
		
	if (theDescriptor["outputOnly"] && theDescriptor["outputOnly"] == YES)
		return NO;

	if (theDescriptor["editableColumns"] && [theDescriptor["editableColumns"] count] >0)
	{
		if ( [theDescriptor["editableColumns"] containsObject:[aColumn identifier]]	)
		{
			return YES;
		}
		else
		{
			return NO;
		}
	}
	
	if (! theDescriptor["columnHelp"])
		return YES;
		
	var columnNumber = [aTableView columnWithIdentifier:[aColumn identifier]];
	var helpDescriptorForColumn = [CPArray arrayWithArray:theDescriptor["columnHelp"][columnNumber]];
	if ( [helpDescriptorForColumn count] == 0)
		return YES;
	
	var theColumnHelpDescriptor = [CPArray arrayWithArray:theDescriptor["columnHelp"][columnNumber]];
	userInfo["helpNeeded"] = YES;
	userInfo["tableView"] = self;
	userInfo["superview"] = aTableView;
	userInfo["targetView"] = [self targetView];
	userInfo["cellFrame"] = [aTableView frameOfDataViewAtColumn:[aTableView columnWithIdentifier:[aColumn identifier]] row:aRow];
	userInfo["editedRow"] = aRow;
	userInfo["editedColumn"] = [aColumn identifier];
	userInfo["helpArray"] = [CPArray arrayWithArray:theColumnHelpDescriptor];
		
	return YES;		
}


// =============== METODI copiati da formfield

-(void)myTextDidFocus:(CPNotification)aNotification withStringValue:(CPString)aStringValue
{
	//if ([aNotification userInfo]["tableView"] !== self)
	//	return;
	
	//if (userInfo["helpNeeded"] == NO)
	//	return;
		
	userInfo["fieldStringValue"] = aStringValue;
	[appNotificationCenter postNotificationName:@"didBeginFieldEdit" object:@"Crm01Navigation" userInfo:userInfo];
}


-(void)myKeyDown:(CPEvent)anEvent withStringValue:(CPString)aStringValue
{
	//alert("in mykeydown "+userInfo["helpNeeded"]);
	
	[targetView formDidChange];
	
	if (userInfo["helpNeeded"] == NO)
		return;
	
	isDeletingBackwards = false;

	if ([anEvent keyCode] == 8)
	{
		isDeletingBackwards = true;
	}
		
	if ([anEvent keyCode] == 9)
	{
		[appHelpController helpDidCompleteSelection];
	}
	
	userInfo["fieldStringValue"] = aStringValue;
	userInfo["isDeletingBackwards"] = isDeletingBackwards;
	[appNotificationCenter postNotificationName:@"didChangeFieldEdit" object:@"Crm01Navigation" userInfo:userInfo];
}


-(void)myTextDidEndEditing:(CPNotification)aNotification withStringValue:(CPString)aStringValue
{
	//alert("in myTextDidEndEditing " +[theTable editedRow]+" "+[theTable editedColumn]);
	[self enhanceIfNeededForString:aStringValue];
	[self validateNowForString:aStringValue];
}

@end




//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//

@implementation RoATableInputField : CPTextField
{
}

-(void)textDidEndEditing:(CPNotification)aNotification
{
	//[super textDidEndEditing:aNotification];
	[[[self delegate] delegate] myTextDidEndEditing:aNotification withStringValue:[self stringValue]];
}

-(void)textDidFocus:(CPNotification)aNotification 
{
	[super textDidFocus:aNotification];
	[[[self delegate] delegate] myTextDidFocus:aNotification withStringValue:[self stringValue]];
}

-(void)keyDown:(CPEvent)anEvent
{
	[super keyDown:anEvent];
	[[[self delegate] delegate] myKeyDown:anEvent withStringValue:[self stringValue]+[anEvent characters]];
}

@end




