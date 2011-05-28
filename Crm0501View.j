// -----------------------------------------------------------------------------
//  Crm0501View.j
//  RoACrm
//
// 	Created by Bruno Ronchetti on May 13, 2010.
// 	Copyright 2010, Ronchetti & Associati All rights reserved.
// -----------------------------------------------------------------------------


@import <Foundation/CPObject.j>


@implementation Crm0501View : CPView
{
	CPNumber	id	theStep;
	CPNumber	id	theTitleHeight;
	CPNumber	id	thelistHeight;
	CPNumber	id 	listWidth;
	CPNumber	id	theWidth;
	
	CPNumber	id	outlineRowHeight;
	CPNumber	id	outlineWidth;
	CPNumber	id	theHeight;

	CPSize		id	buttonSize;
	CPButton	id	collapseButton;
	CPTextField	id	sectionTitle;
	CPSearchField	id	filterField;
	
	CPString 	id	searchString;
	CPScrollView	id crm05Scroll;
	//CPOutlineView	id	crm05Outline;
	CPView	id spinner;
}

-(void)initWithFrame:(CGRect)aFrame
{
	self = [super initWithFrame:aFrame];
	if (self)
	{
		return self; 
	}
}

-(void)initialize
{
	searchString = "";


	theStep = 26.0;
	theTitleHeight = 18.0;
	theListHeight = 400.0;
	theWidth = 200.0;
	var buttonSize = CGSizeMake(34.0,34.0);
	var listWidth = 200.0;
	
	var outlineRowHeight = 16.0;

	var theHeight 	= [self frame].size.height;
	var theWidth	= [self frame].size.width;
	
		// GEOMETRY
	//
	var outlineWidth = KKRoAX2-10.0;
	var ribbonHeight = KKRoAY1-10.0;
	
	var theHeight 	= [self frame].size.height;
	var theWidth	= [self frame].size.width;
	
	var buttonSize = CGSizeMake(34,34);
	
	// HEADERS
	//
	
	ribbonView = [[RoARoundedCornerView alloc] initWithFrame:CGRectMake(0.0, 0.0, theWidth, KKRoAY1)];
	[ribbonView setBackgroundColor:KKRoALightGray];
	[ribbonView setAutoresizingMask:CPViewWidthSizable];
	[self addSubview:ribbonView];

	var sectionTitle = [[CPTextField alloc] initWithFrame:CGRectMake(10.0 ,5.0 ,outlineWidth,30.0)];
	[sectionTitle setStringValue:RoALocalized(@"Documenti")];
	[sectionTitle setFont:[CPFont boldSystemFontOfSize:16]];
	[sectionTitle setTextColor:KKRoAHighlightBlue];
	[ribbonView addSubview:sectionTitle];
	
	filterField = [[CPSearchField alloc] initWithFrame:CGRectMake(2.0, 0.0, 150.0, 28.0)];
    [filterField setAutoresizingMask:CPViewMaxXMargin];
	[filterField setSendsWholeSearchString:NO];
	[filterField setPlaceholderString:RoALocalized("Filtra ")+KKRoACaption];
	[filterField setTarget:self];
	[filterField setAction:@selector(filterData:)];
	[filterField setMaximumRecents:10];
	[filterField setRecentsAutosaveName:"filterList"];
    [ribbonView addSubview:filterField];
	
	var filterMenu = [filterField defaultSearchMenuTemplate];
	[filterMenu insertItemWithTitle:"select" action:"menuSelection" keyEquivalent:nil atIndex:0];
	[filterField setSearchMenuTemplate:filterMenu];
	
	var collapseButton = [[CPButton alloc] initWithFrame:CGRectMake(theWidth-24.0, 3.0, 24.0, 24.0)];
	[collapseButton setAutoresizingMask:CPViewMinYMargin];
	[collapseButton setTheme:nil];
	[collapseButton setTitle:"<"];
	[collapseButton setEnabled:YES];
	[collapseButton setValue:KKRoAMediumLightGray forThemeAttribute:@"text-color" inState:CPThemeStateDisabled];
	[collapseButton setValue:KKRoAHighlightBlue forThemeAttribute:@"text-color" inState:CPThemeStateNormal];
	[collapseButton setValue:KKRoAHighlightBlue forThemeAttribute:@"text-color" inState:CPThemeStateHighlighted];
	[collapseButton setFont:[CPFont boldSystemFontOfSize:20]];
	[collapseButton setTarget:crm05Controller];
	[collapseButton setAction:"collapseMiddlePanel:"];
 	[ribbonView addSubview:collapseButton];
	


	// SCROLL & OUTLINE
	
	var crm05Scroll = [[CPScrollView alloc] initWithFrame:CGRectMake(0.0 ,KKRoAY1,outlineWidth,theHeight-KKRoAY2)];
	[crm05Scroll setAutoresizingMask:CPViewHeightSizable];
	[crm05Scroll setAutohidesScrollers:YES];
	[crm05Scroll setHasHorizontalScroller:NO];
	[crm05Scroll setBackgroundColor:KKRoABackgroundWhite];
	[self addSubview:crm05Scroll];	
			
//------------------
	crm05Outline = [[CPOutlineView alloc] initWithFrame:CGRectMake(0.0, 0.0, 0.0, 0.0)];
	[crm05Outline setAutoresizingMask:CPViewHeightSizable];
	[crm05Outline setHeaderView:null];
	[crm05Outline setCornerView:null];
	[crm05Outline setSelectionHighlightStyle:CPTableViewSelectionHighlightStyleRegular];
	[crm05Outline setBackgroundColor:[CPColor clearColor]];
	[crm05Outline setRowHeight:outlineRowHeight];
	
	var column = [[CPTableColumn alloc] initWithIdentifier:"OutlineColumn"];
	[column setEditable:NO];
	[column setWidth:outlineWidth];
	
	var outlineItemView = [[Crm05OutlineItemView alloc] initWithFrame:CGRectMake(0,0,0, outlineRowHeight)];
	[column setDataView:outlineItemView];
	[crm05Outline setIndentationPerLevel:10];
	
	[crm05Outline addTableColumn:column];
	[crm05Outline setOutlineTableColumn:column];
	
	[crm05Outline setDelegate:self];
    [crm05Outline setDataSource:crm05Controller];	
	[crm05Scroll setDocumentView:crm05Outline];
//---------------------------
	

	// BORDER 
	//
	var border = [[CPView alloc] initWithFrame:CGRectMake(KKRoAX2-1,0,1,theHeight)];
	[border setBackgroundColor:KKRoAMediumGray];
	[border setAutoresizingMask:CPViewHeightSizable];
	[self addSubview:border];
}


-(void)displaySpinner
{
	//var spinner = [[CPImageView alloc] initWithFrame:CGRectMake(0.0, 0.0 ,24.0, 24.0)];
	//[spinner setCenter:CGPointMake(outlineWidth/2, theHeight/2)];
	//var spinnerImage = [[CPImage alloc] initWithContentsOfFile:"Resources/spinner.gif" size:CGSizeMake(24.0, 24.0)];
	//[spinner setImage:spinnerImage];
	//[spinner setBackgroundColor:[CPColor redColor]];
	//[crm05Scroll addSubview:spinner];
	
	//[contentView addSubview:self];
}


-(void)display
{
	//alert("all'inizio  di dispaly ");
	
	KKRoASearchString = "";
	
	//alert("in 0501view display KKRoaRequestPrint é "+KKRoARequestPrint);
	if (KKRoARequestPrint == true)
	{
		[filterField removeFromSuperview];
		[collapseButton removeFromSuperview];
	}
	else
	{
		[sectionTitle removeFromSuperview];
	}
	
	//[spinner removeFromSuperview];

/*	
//------------------
	var crm05Outline = [[CPOutlineView alloc] initWithFrame:CGRectMake(0.0, 0.0, 0.0, 0.0)];
	[crm05Outline setAutoresizingMask:CPViewHeightSizable];
	[crm05Outline setHeaderView:null];
	[crm05Outline setCornerView:null];
	[crm05Outline setSelectionHighlightStyle:CPTableViewSelectionHighlightStyleRegular];
	[crm05Outline setBackgroundColor:[CPColor clearColor]];
	[crm05Outline setRowHeight:outlineRowHeight];
	
	var column = [[CPTableColumn alloc] initWithIdentifier:"OutlineColumn"];
	[column setEditable:NO];
	[column setWidth:outlineWidth];
	
	var outlineItemView = [[Crm05OutlineItemView alloc] initWithFrame:CGRectMake(0,0,0, outlineRowHeight)];
	
	[column setDataView:outlineItemView];
	[crm05Outline setIndentationPerLevel:12];
	
	[crm05Outline addTableColumn:column];
	[crm05Outline setOutlineTableColumn:column];
	
	[crm05Outline setDelegate:self];
    [crm05Outline setDataSource:crm05Controller];	
	[crm05Scroll setDocumentView:crm05Outline];
//---------------------------
*/
	[crm05Outline reloadData];

	if ([[crm05Controller crm05Data] count] < 80)
	{
		for (var i=0; i<[[crm05Controller rootNodes] count]; i++)
		{
			[crm05Outline expandItem:[crm05Controller rootNodes][i] expandChildren:YES];
		}
	}

	[contentView addSubview:self];
}



-(void)filterData:(id)sender
{
	KKRoASearchString = [filterField stringValue];
	[crm05Outline reloadData];
}



-(void)outlineViewSelectionDidChange:(CPNotification)aNotification
{
	if ([crm05Outline levelForRow:[crm05Outline selectedRow]] == 0)
	{
		return;
	}
	
	var selectedItem = [crm05Outline itemAtRow:[[crm05Outline selectedRowIndexes] firstIndex]];
	var selectedKey = [[crm05Controller crm05Tree] objectForKey:selectedItem].representedObject.id;
	
	//var selectedView = 
	
	[collapseButton	setEnabled:YES];
	[crm05Controller itemSelection:selectedKey];
}


@end



//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//

@implementation Crm05OutlineItemView : CPView
{
	CPTextField 	id textField;
	CPTextField 	id headerField;
}

-(void)setObjectValue:(id)anObject
{	
	[[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];

	var textField = [[CPTextField alloc] initWithFrame:CGRectMake(4.0, 0.0, KKRoAX2-10.0, 30.0)];
	var headerField = [[CPTextField alloc] initWithFrame:CGRectMake(0.0, 0.0, KKRoAX2-10.0, 30.0)];

	[textField setFont:KKRoAOutlineTextFont];
	[headerField setFont:[CPFont boldSystemFontOfSize:12]];

	[textField setStringValue:anObject];
	[headerField setStringValue:anObject];
	
	[self addSubview:textField];
	[self addSubview:headerField];
	
	if ( [[crm05Controller rootNodes] containsObject:anObject] )
	{
		[headerField setTextColor:KKRoAOutlineLabelColor];
		[headerField setDrawsBackground:YES];
		[headerField setBackgroundColor:KKRoABottombarBackground];
		[textField setHidden:YES];
	}
	else
	{
		[textField setTextColor:KKRoAOutlineLabelColor];
		[headerField setHidden:YES];		
		if (KKRoASearchString != "" && [textField stringValue].search(KKRoASearchString) == -1)
		{
			[textField setAlphaValue:0.2];
		}
	}
}



-(void)mouseEntered:(CPEvent)anEvent
{
	[self setBackgroundColor:KKRoAPreSelectionBlue];
	[textField setTextColor:[CPColor whiteColor]];
}

-(void)mouseExited:(CPEvent)anEvent
{
	[self setBackgroundColor:[CPColor clearColor]];
	//if ([textField stringValue] != [[self superview] itemAtRow:[[crm05Outline selectedRowIndexes] firstIndex]])
	//{
		[textField setTextColor:KKRoAOutlineLabelColor];
		[headerField setTextColor:KKRoAOutlineLabelColor];
	//}
}


-(void)clearView
{
	[[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
}


@end







