// -----------------------------------------------------------------------------
//  Crm0801View.j
//  RoACrm01
//
// 	Created by Bruno Ronchetti on June 02, 2010.
// 	Copyright 2010, Ronchetti & Associati All rights reserved.
// -----------------------------------------------------------------------------


@import <Foundation/CPObject.j>
@import <RoAKit/RoADataTableView.j>


@implementation Crm0801View : CPView
{
	CPArray	id	skipHeaders;
	CPArray	id	includeHeaders;
	RoADataTableView id crm0801DataTableView;
	CPButton id	printSelectedButton @accessors;
	CPView	id	contentArea;
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
	theHeight 	= [self bounds].size.height;
	theWidth	= [self bounds].size.width;
	
	var ribbonView = [[RoARoundedCornerView alloc] initWithFrame:CGRectMake(0.0, 0.0 ,theWidth,KKRoAY1)];
	[ribbonView setBackgroundColor:KKRoALightGray];
	[ribbonView setAutoresizingMask:CPViewWidthSizable];
	[self addSubview:ribbonView];
	
	var sectionTitle = [[CPTextField alloc] initWithFrame:CGRectMake(10.0 ,5.0 ,100.0, 30.0)];
	[sectionTitle setStringValue:RoALocalized(@"Destinatari")];
	[sectionTitle setFont:[CPFont boldSystemFontOfSize:16]];
	[sectionTitle setTextColor:KKRoAHighlightBlue];
	[ribbonView addSubview:sectionTitle];
		
	filterField = [[CPSearchField alloc] initWithFrame:CGRectMake(120.0, 1.0, 300.0, 30.0)];
	[filterField setAutoresizingMask:CPViewMaxXMargin];
	[filterField setSendsWholeSearchString:NO];
	[filterField setPlaceholderString:"Seleziona "+KKRoACaption+" per cui stampare"];
	[filterField setTarget:self];
	[filterField setAction:@selector(filterData:)];
	[filterField setMaximumRecents:10];
	[filterField setRecentsAutosaveName:"filterList"];
	[ribbonView addSubview:filterField];
	
	var filterMenu = [filterField defaultSearchMenuTemplate];
	[filterMenu insertItemWithTitle:"select" action:"menuSelection" keyEquivalent:nil atIndex:0];
	[filterField setSearchMenuTemplate:filterMenu];
	
	var printSelectedButton = [[CPButton alloc] initWithFrame:CGRectMake(0.0 ,0.0 ,150.0 ,24.0)];
	[printSelectedButton setBezelStyle:CPRegularSquareBezelStyle];
	[printSelectedButton setFrameOrigin:CGPointMake(theWidth-160, 3.0)];
	[printSelectedButton setAutoresizingMask:CPViewMinXMargin];
	[printSelectedButton setTag:"printSelectedButton"];
	[printSelectedButton setTitle:"Stampa selezionati"];
	[printSelectedButton setEnabled:NO];
	[printSelectedButton setTarget:crm08Controller];
	[printSelectedButton setAction:@selector(preparePrintLayout)];
	[printSelectedButton setValue:KKRoAMediumLightGray forThemeAttribute:@"text-color" inState:CPThemeStateDisabled];
	[printSelectedButton setValue:KKRoAMediumBlue forThemeAttribute:@"text-color" inState:CPThemeStateNormal];
	[printSelectedButton setValue:KKRoAHighlightBlue forThemeAttribute:@"text-color" inState:CPThemeStateHighlighted];
	[ribbonView addSubview:printSelectedButton];
	
	var contentArea = [[CPView alloc] initWithFrame:CGRectMake(0.0, KKRoAY1, theWidth, theHeight-KKRoAY1)];
	[contentArea setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
	[contentArea setBackgroundColor:KKRoABackgroundWhite];
	[self addSubview:contentArea];
	
			
	var skipHeaders = ["_id", "_rev", "_attachments", "type", "lists"];
	var includeHeaders = [];
	switch (KKRoAType) {
		case ("person") :
				var includeHeaders = [["Titolo", "Nome", "Cognome", "Indirizzo_Casa", "Localita_Casa"]];
				break;
		case ("company") :
				var includeHeaders = [["Ragione_Sociale", "Indirizzo", "Localita"]];
				break;
		case ("non_profit_organization") :
				var includeHeaders = [["Organizzazione", "Indirizzo", "Localita"]];
				break;
		case ("project") :
				var includeHeaders = [["Denominazione"]];
				break;
		case ("member") :
				var includeHeaders = [["Nome", "Cognome", "Indirizzo_Casa", "Localita_Casa"]];
				break;
		case ("employee") :
				var includeHeaders = [["Nome", "Cognome", "Indirizzo_Casa", "Localita_Casa"]];
				break;
		default :
				var includeHeaders = [[]];
				break;
	}
		
	//alert("fino a qui");

	var crm0801DataTableView 	= [[RoADataTableView alloc] initWithFrame:CGRectInset([contentArea bounds], 20, 20)];
	[crm0801DataTableView layoutSkipping:skipHeaders including:includeHeaders];
	[crm0801DataTableView setSelectionDelegate:self];
	[contentArea addSubview:crm0801DataTableView];
	[filterField setPlaceholderString:"Seleziona "+KKRoACaption];
	
	//alert("fino a qui 2");

}


-(void)refresh
{
	var selection = KKRoAList;
	
	//var startKey = 	encodeURI('["'+selection+'"]');
	//var endKey = 	encodeURI('["'+selection+'",{}]');
	
		
	var startkey = [KKRoAUserDomain, KKRoAType, KKRoAList];
	var startJSONkey = JSON.stringify(startkey);
	
	var endkey = [KKRoAUserDomain, KKRoAType, KKRoAList, {}];
	var endJSONkey = JSON.stringify(endkey);
	
	
	var key = "documents/_design/data/_view/docs_by_list?startkey="+startJSONkey+"&endkey="+endJSONkey+"&include_docs=true";
	[crm0801DataTableView loadData:key];
	
}


-(void)tableSelectionDidChange
{
	if ([[[crm0801DataTableView myTableView01] selectedRowIndexes] firstIndex] < 0)
	{
		[printSelectedButton setEnabled:NO];
	}
	else
	{
		if(	KKRoAnItem != "")
		{
			[printSelectedButton setEnabled:YES];
		}	
	} 
}	 


-(void)display
{
	[contentView addSubview:self];
}


-(void)filterData:(id)sender
{
	[crm0801DataTableView filterTable:[sender stringValue]];
}


-(CPArray)tableObjects
{
	return [crm0801DataTableView tableObjects];
}


-(CPArray)selectedTableObjects
{
	return [crm0801DataTableView selectedTableObjects];
}


- (void)awake
{
	// NO operation
}

@end