/*
 * RoAFormFieldHelp.j
 * WktTest60
 *
 * Created by You on January 27, 2010
 * Copyright 2010, Your Company All rights reserved.
 */

@import <Foundation/CPObject.j>
@import "RoATree.j"


@implementation RoAFormFieldHelp : CPView
{
	BOOL			id 	isMultiLevel;
	BOOL			id  allowsMultiple;
	
	CPScrollView	id	helpScrollView;
	HelpOutlineView	id	helpOutlineView;
	RoAShadowView	id	shadowView;
	
	RoAFormField	id	targetFormField;
	
	RoATree			id	helpTree;
	CPString		id 	selectedHelpValue	@accessors;
	
	float			id	theWidth;
	float			id	theRowHeight @accessors;
	
	CPTableColumn	id column;
	
	CPArray			id	helpArray;
	CPArray			id	filteredArray;

}


- (CPView) initWithFrame:aFrame
{
	self = [super initWithFrame:aFrame];
	if (self)
	{
		var theWidth = [self frameSize].width;
		var theRowHeight = 18.0;

		[self setAutoresizesSubviews:YES];

		var shadowView = [[RoAShadowView alloc] init];

		var helpScrollView = [[CPScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, theWidth, 10 * theRowHeight)];
		[helpScrollView setAutoresizingMask:CPViewWidthSizable];
		[helpScrollView setHasHorizontalScroller:NO];
		[helpScrollView setHasVerticalScroller:YES];
		[helpScrollView setAutohidesScrollers:YES];
		[helpScrollView setAlphaValue:1.0];
		[helpScrollView setAutoresizesSubviews:YES];
		
		// FIXME CPSmallControlSize does not work for the scroller
		//
		[[helpScrollView verticalScroller] setControlSize:CPSmallControlSize];
				
		var helpOutlineView = [[HelpOutlineView alloc] initWithFrame:CGRectMake(0,0,0,0)];
		[helpOutlineView setAutoresizingMask:CPViewHeightSizable];
		[helpOutlineView setHeaderView:null];
		[helpOutlineView setCornerView:null];
		[helpOutlineView setSelectionHighlightStyle:CPTableViewSelectionHighlightStyleRegular];
		[helpOutlineView setAlphaValue:1.0];
		[helpOutlineView setRowHeight:theRowHeight];
		[helpOutlineView setAllowsEmptySelection:NO];
		[helpOutlineView setDelegate:self];
		[helpOutlineView setDataSource:self];
		[helpOutlineView setDoubleAction:@"outlineViewSelectionDidChange:"];

		var textDataView = [[CPTextField new] initWithFrame:CGRectMake(0.0,0.0,0.0,0.0)];
		//[textDataView setAutoresizingMask:CPViewWidthSizable];
		[textDataView setFont:[CPFont systemFontOfSize:12]];
					
		var column = [[CPTableColumn alloc] initWithIdentifier:"OutlineColumn"];
		//[column setWidth:theWidth];
		[column setDataView:textDataView];

		[helpOutlineView addTableColumn:column];
		[helpOutlineView setOutlineTableColumn:column];

		[helpScrollView setDocumentView:helpOutlineView];		
		
		[self addSubview:helpScrollView];
		
		return self;
	}
}

-(void)display
{
	//alert("in display "+[filteredArray count]);
	var numberOfRows = [filteredArray count];
	
	if (numberOfRows == 0)
	{
		//[self prepareTreeForData:[CPArray arrayWithObject:RoALocalized(@"...")]];
		return;
	}
	var numberOfHelpRows = isMultiLevel ? (numberOfRows+ 1.0) : numberOfRows;
	[helpScrollView setFrameSize:CGSizeMake([self frame].size.width, numberOfHelpRows* (theRowHeight+ 2.0))];
	[column setWidth:[helpScrollView frame].size.width];
	
	[shadowView drawShadowForView:helpScrollView];
	[shadowView setShadowOriginForView:self];	

	[contentView addSubview:self];
	[contentView addSubview:shadowView positioned:CPWindowBelow relativeTo:self];
}



-(void)setHidden:(BOOL)shouldBeHidden
{
	[super setHidden:shouldBeHidden];

	if (shouldBeHidden == true)
	{
		[helpScrollView removeFromSuperview];
		[shadowView removeFromSuperview];
	}
	else
	{
		[shadowView setShadowOriginForView:self];
		[[self superview] addSubview:shadowView positioned:CPWindowBelow relativeTo:self];
		[self addSubview:helpScrollView];
	}
}


-(void)prepareTreeForData:(CPArray)aHelpArray
{
	if ([aHelpArray count] == 0)
	{
		var	filteredArray = [];
		return;
	}
		
	var helpArray = [CPArray arrayWithArray:aHelpArray];
	var	isMultiLevel = false;
	
	var helpTree = [[RoATree alloc] init];
	[helpTree addNode:"root" withParent:null];
	[helpTree addObject:null toNode:"root"];
	
	for (var i =0; i<[helpArray count]; i++)
	{		
		var parentName = "root";
		if ([helpArray[i] respondsToSelector:@selector(count)])
		{
			var childName = helpArray[i][0];
			var parentName = helpArray[i][1];
			isMultiLevel = true;
		}
		else
		{
			var childName = helpArray[i];
		}
		[helpTree addNode:childName withParent:parentName];
		[helpTree addObject:helpArray[i] toNode:childName];
	}
	
	//listProperties(helpTree, "helpTree");
	//alert(isMultiLevel);

	[helpTree adoptOrphans:"root"];	
	[helpOutlineView reloadData];
	
	if (isMultiLevel === true)
	{
		[helpOutlineView setIndentationPerLevel:12];
		[helpOutlineView expandItem:nil expandChildren:YES]
	}
	else
	{
		[helpOutlineView setIndentationPerLevel:2];
	}
	
	var filteredArray = [CPArray arrayWithArray:helpArray];
}


-(void)filterHelpData:(CPString)aFieldStringValue
{
	var filteredArray = [];
	var numberOfCharacters = [aFieldStringValue length];
		
	for (var j=0; j<[helpArray count]; j++)
	{
		var stringFoundRange = CPMakeRange(0,0);
		stringFoundRange = [helpArray[j] rangeOfString:aFieldStringValue options:CPCaseInsensitiveSearch];
		if (stringFoundRange.length != 0)
		{
			[filteredArray addObject:helpArray[j]];
		}
	}
	
	// FIXME tolgo questa ottimizzazione perchè da fastidio quando si legge un db (ad esempio in 0301View)
	//
	//if ([filteredArray count] == 1)
	//{
		//[appHelpController selectedHelpValue:filteredArray[0]];
	//}
	
	[self prepareTreeForData:filteredArray];
	[helpOutlineView reloadData];
}


-(void)setAllowedSelections:(CPString)allowedSelections
{
	//alert("allowedSelections "+allowedSelections);
	
	[helpOutlineView setAllowsMultipleSelection:NO];
	if (allowedSelections == "multiple")
	{
		[helpOutlineView setAllowsMultipleSelection:YES];
	}
}


-(void)outlineViewSelectionDidChange:(CPNotification)aNotification
{
	var indexSet = [[helpOutlineView selectedRowIndexes] copy];
	var selectedHelpValue = "";
	
	while ([indexSet count] >0)
	{
		var i = [indexSet firstIndex];
		selectedHelpValue = selectedHelpValue +","+ [helpOutlineView itemAtRow:i];
		[indexSet removeIndex:i];
	}
	selectedHelpValue = selectedHelpValue.substr(1);
	[appHelpController selectedHelpValue:selectedHelpValue];
}



-(void)XXXsetTargetFormField:(RoAFormField)aFormField
{
	var targetFormField = aFormField;
	[helpOutlineView setTargetFormField:targetFormField];
}	


//++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
// Delegate Methods to control outline behaviour
//
-(int)outlineView:(CPOutlineView)outlineView numberOfChildrenOfItem:(id)item
{
	//("A "+item);
	if (item === null)
		return [[helpTree childNodesForKey:"root"] count];
	else
		return [[helpTree childNodesForKey:item] count];
}

-(BOOL)outlineView:(CPOutlineView)outlineView isItemExpandable:(id)item
{
	//alert("B "+item);
	if (item === null)
		return false;
	else
		if ([[helpTree childNodesForKey:item] count] > 0) {
			return true;
		}
		else {
			return false;
		}
}

-(id)outlineView:(CPOutlineView)outlineView child:(int)index ofItem:(id)item
{
	//alert("C "+item);
	if (item === null)
		return [helpTree childNodesForKey:"root"][index];
	else
		return [helpTree childNodesForKey:item][index];
}

-(id)outlineView:(CPOutlineView)outlineView objectValueForTableColumn:(CPTableColumn)tableColumn byItem:(id)anObject
{
	//alert("D");
	return anObject;
}



@end


//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//

@implementation HelpOutlineView: CPOutlineView
{
}
	

-(void)keyDown:(CPEvent)anEvent
{
	alert("key schiacciato "+[anEvent keyCode]);
	
	// FIXME perchè non funziona il tab keycode9 - non arriva il controllo
	
	if ([anEvent keyCode] == 9 || [anEvent keyCode] == 13)
	{
		[appHelpController helpDidCompleteSelection];
	}
	
	[super keyDown:anEvent];
}


@end

