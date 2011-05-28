// -----------------------------------------------------------------------------
//  Crm0103View.j
//  RoACrm01
//
// 	Created by Bruno Ronchetti on May 17, 2010.
// 	Copyright 2010, Ronchetti & Associati All rights reserved.
// -----------------------------------------------------------------------------


@import <Foundation/CPObject.j>

@implementation Crm0103View : CPView
{	
	CrmButton		id 	quitHelpButton;
	CPArray			id 	helpIndexArray;
	CPOutlineView	id	helpIndexOutline;
	RoTree			id	helpIndexTree;
	CPWebView		id	helpContent;
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
// GEOMETRY
	//
	var outlineWidth = KKRoAX1-10;
	var ribbonHeight = KKRoAY1;
	
	var textPanelWidth = [contentView frame].size.width-outlineWidth-20.0;
	
	var theHeight 	= [self frame].size.height;
	var theWidth	= [self frame].size.width;
	
	var buttonSize = CGSizeMake(34,34);
	
	var outlineRowHeight = 17.0;

	
	// SET-UP BACKGROUND
	
	// ------------------------------------------------------------------------
	// LEFT NAVIGATION BAR
	// ------------------------------------------------------------------------
	// LEFTVIEW
	//
		
	var leftRibbonView = [[RoARoundedCornerView alloc] initWithFrame:CGRectMake(0.0, 0.0, outlineWidth,KKRoAY1)];
	[leftRibbonView	setBackgroundColor:KKRoALightGray];
	[self addSubview:leftRibbonView];
	
	var indexTitle = [[CPTextField alloc] initWithFrame:CGRectMake(10.0 ,5.0 ,outlineWidth,30.0)];
	[indexTitle setStringValue:RoALocalized(@"Indice")];
	[indexTitle setFont:[CPFont boldSystemFontOfSize:16]];
	[indexTitle setTextColor:KKRoAHighlightBlue];
	[leftRibbonView addSubview:indexTitle];
	
	var rightRibbonView = [[RoARoundedCornerView alloc] initWithFrame:CGRectMake(outlineWidth+10.0, 0.0 , textPanelWidth, KKRoAY1)];
	[rightRibbonView setAutoresizingMask:CPViewWidthSizable];
	[rightRibbonView setBackgroundColor:KKRoALightGray];
	[self addSubview:rightRibbonView];

	var textPanelTitle = [[CPTextField alloc] initWithFrame:CGRectMake(10.0 ,5.0 ,outlineWidth,30.0)];
	[textPanelTitle setStringValue:RoALocalized(@"")];
	[textPanelTitle setFont:[CPFont boldSystemFontOfSize:16]];
	[textPanelTitle setTextColor:KKRoAHighlightBlue];
	[rightRibbonView addSubview:textPanelTitle];
	
	var helpIndexScroll = [[CPScrollView alloc] initWithFrame:CGRectMake(0.0, KKRoAY1, outlineWidth, theHeight-KKRoAY1-KKRoAY2)];
	[helpIndexScroll setAutoresizingMask:CPViewHeightSizable];
	[helpIndexScroll setHasHorizontalScroller:NO];
	[helpIndexScroll setHasVerticalScroller:YES];
	[helpIndexScroll setAutohidesScrollers:YES];
	[helpIndexScroll setBackgroundColor:KKRoABackgroundWhite];
	[self addSubview:helpIndexScroll];
				
	helpIndexOutline = [[CPOutlineView alloc] initWithFrame:CGRectMake(0.0, 0.0, 0.0, 0.0)];
	[helpIndexOutline setAutoresizingMask:CPViewHeightSizable];
	[helpIndexOutline setHeaderView:null];
	[helpIndexOutline setCornerView:null];
	[helpIndexOutline setSelectionHighlightStyle:CPTableViewSelectionHighlightStyleRegular];	
	[helpIndexOutline setBackgroundColor:[CPColor clearColor]];	
	[helpIndexOutline setRowHeight:outlineRowHeight];
	
	var column = [[CPTableColumn alloc] initWithIdentifier:"OutlineColumn"];
	[column setEditable:NO];
	[column setWidth:[helpIndexScroll bounds].size.width];
	
	var outlineItemView = [[CPTextField alloc] initWithFrame:CGRectMake(0.0, 0.0, outlineWidth, outlineRowHeight)]; 

	[column setDataView:outlineItemView];
	[helpIndexOutline setIndentationPerLevel:12];
	
	[helpIndexOutline addTableColumn:column];
	[helpIndexOutline setOutlineTableColumn:column];
	
	[helpIndexOutline setDelegate:self];
    [helpIndexOutline setDataSource:self];
	[helpIndexScroll setDocumentView:helpIndexOutline];
	
	// SET-UP LABELS
	//
	
	var textPanelScroll = [[CPScrollView alloc] initWithFrame:CGRectMake(outlineWidth+10.0, KKRoAY1, textPanelWidth, theHeight-KKRoAY1-KKRoAY2)];
	[textPanelScroll setAutoresizingMask:CPViewHeightSizable | CPViewWidthSizable];
	[textPanelScroll setAutohidesScrollers:YES];
	[textPanelScroll setBackgroundColor:KKRoABackgroundWhite];
	[self addSubview:textPanelScroll];
	
	var helpContent = [[CPWebView alloc] initWithFrame:[textPanelScroll frame]];
	[self addSubview:helpContent];
	
	var quitHelpButton = [[CrmButton alloc] initWithFrame:CGRectMakeZero()];
	[quitHelpButton setFrameOrigin:CGPointMake(textPanelWidth - 90.0, 3.0)];
	[quitHelpButton setTag:"quitHelpButton"];
	[quitHelpButton setAutoresizingMask:CPViewMinXMargin];
	[quitHelpButton setTitle:RoALocalized(@"OK fatto")];
	[quitHelpButton setEnabled:YES];
	[quitHelpButton setTarget:crm02Controller];
	[quitHelpButton setAction:"quitHelp:"];
 	[rightRibbonView addSubview:quitHelpButton];

}

-(void)displayForDocumentIndex:(CPString)aDocumentIndex
{
	var theDocumentIndex = aDocumentIndex;
	var helpIndexArray = [];
	
	for (var j=0; j<[KKRoATables count]; j++)
	{
		if (KKRoATables[j]["key"] == aDocumentIndex)
		{
			helpIndexArray = KKRoATables[j]["value"];
			break;
		}
	}
	[self buildTree:helpIndexArray];
		
	var relevantHelpRow = 0;
	if (KKRoaRelevantHelpPage != "")
	{
		var relevantHelpRow = [helpIndexOutline rowForItem:KKRoaRelevantHelpPage];
	}
	
	[contentView addSubview:self];
	[helpIndexOutline selectRowIndexes:[CPIndexSet indexSetWithIndex:relevantHelpRow] byExtendingSelection:YES];
}

-(void)outlineViewSelectionDidChange:(CPNotification)aNotification
{
	var theSelectedHelpSection = [[aNotification object]  itemAtRow:[[aNotification object] selectedRow]];
	var key = theSelectedHelpSection;
	var JSONkey = encodeURIComponent(key);
				
	var lookupHelpContent = new Object();
	lookupHelpContent["action"] = "readDoc";
	lookupHelpContent["key"] = "templates/_design/helppages/_view/all?key=\""+JSONkey+"\"";

	var dataResponse = [[RoACouchModule alloc] initWithRequest:lookupHelpContent executeSynchronously:YES];
	
	if (dataResponse[0])
	{
		var helpHTML = dataResponse[0]["value"];
	}
	else
	{
		var helpHTML = "<h1>"+RoALocalized(@"Pagina non trovata")+"</h1>"; 
	}
			
    [helpContent loadHTMLString:helpHTML];
}

- (BOOL)acceptsFirstResponder 
{ 
    return YES; 
} 

- (void)keyDown:(CPEvent)anEvent 
{
	if ([anEvent keyCode] == "13") {
		[quitHelpButton performClick:anEvent];
	}
} 


//++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
// methods to build and control the outline
//

-(void)buildTree:(CPArray)aHelpIndexArray
{
	var theHelpIndexArray = [CPArray arrayWithArray:aHelpIndexArray];
	var	isMultiLevel = false;
	
	var helpIndexTree = [[RoATree alloc] init];
	[helpIndexTree addNode:"root" withParent:null];
	[helpIndexTree addObject:null toNode:"root"];
	
	for (var i =0; i<[theHelpIndexArray count]; i++)
	{		
		var parentName = "root";
		if ([theHelpIndexArray[i] respondsToSelector:@selector(count)])
		{
			var childName = theHelpIndexArray[i][0];
			var parentName = theHelpIndexArray[i][1];
			isMultiLevel = true;
		}
		else
		{
			var childName = theHelpIndexArray[i];
		}
		[helpIndexTree addNode:childName withParent:parentName];
		[helpIndexTree addObject:helpIndexArray[i] toNode:childName];
	}
	
	//listProperties(helpTree, "helpTree");
	//alert(isMultiLevel);
	
	[helpIndexTree adoptOrphans:"root"];
	[helpIndexOutline reloadData];
	
	if (isMultiLevel === true)
	{
		[helpIndexOutline setIndentationPerLevel:12];
		[helpIndexOutline expandItem:nil expandChildren:YES]
	}
	else
	{
		[helpIndexOutline setIndentationPerLevel:2];
	}
	
}


-(int)outlineView:(CPOutlineView)outlineView numberOfChildrenOfItem:(id)item
{
	("A "+item);
	if (item === null)
		return [[helpIndexTree childNodesForKey:"root"] count];
	else
		return [[helpIndexTree childNodesForKey:item] count];
}

-(BOOL)outlineView:(CPOutlineView)outlineView isItemExpandable:(id)item
{
	//alert("B "+item);
	if (item === null)
		return false;
	else
		return [[helpIndexTree childNodesForKey:item] count] > 0;
}

-(id)outlineView:(CPOutlineView)outlineView child:(int)index ofItem:(id)item
{
	//alert("C "+item);
	if (item === null)
		return [helpIndexTree childNodesForKey:"root"][index];
	else
		return [helpIndexTree childNodesForKey:item][index];
}

-(id)outlineView:(CPOutlineView)outlineView objectValueForTableColumn:(CPTableColumn)tableColumn byItem:(id)item
{
	//alert("D "+anObject);
	return item;
}

@end



