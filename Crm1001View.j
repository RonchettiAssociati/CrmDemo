// -----------------------------------------------------------------------------
//  Crm1001View.j
//  RoACrm01
//
// 	Created by Bruno Ronchetti on May 13, 2010.
// 	Copyright 2010, Ronchetti & Associati All rights reserved.
// -----------------------------------------------------------------------------


@import <Foundation/CPObject.j>
@import <RoAKit/RoAGlobalDataTableView.j>
@import <RoAKit/RoATabView.j>


@implementation Crm1001View : CPView
{
	RoAGlobalDataTableView	id app1001DataTableView;
	RoAGlobalDataTableView	id app1002DataTableView;

	RoATabView		id	app10TabView;
	RoATabViewItem	id	app10TabItem01;
	RoATabViewItem	id	app10TabItem02;
	RoATabViewItem	id	app10TabItem03;
	RoATabViewItem	id	app10TabItem04;
	RoATabViewItem	id	app10TabItem05;
	RoATabViewItem	id	app10TabItem06;
	RoATabViewItem	id	app10TabItem07;

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
	var theHeight 	= [self frame].size.height;
	var theWidth	= [self frame].size.width;
	
	var app10TabView = [[RoATabView alloc] initWithFrame:CGRectInset([self bounds], 10.0, 10.0)];
	[app10TabView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
	[app10TabView setDelegate:self];
	[app10TabView setTabViewType:CPTopTabsBezelBorder];
		
	var app10TabItem01 = [[RoATabViewItem alloc] initWithIdentifier:@"person"];
	[app10TabItem01 setLabel:"Persone - "+"0 trovate"];
	var app10TabItem02 = [[RoATabViewItem alloc] initWithIdentifier:@"company"];
	[app10TabItem02 setLabel:"Aziende"];
	var app10TabItem03 = [[RoATabViewItem alloc] initWithIdentifier:@"non_profit_organization"];
	[app10TabItem03 setLabel:"No Profit"];
	var app10TabItem04 = [[RoATabViewItem alloc] initWithIdentifier:@"project"];
	[app10TabItem04 setLabel:"Soci"];
	var app10TabItem05 = [[RoATabViewItem alloc] initWithIdentifier:@"project"];
	[app10TabItem05 setLabel:"Collaboratori"];
	var app10TabItem06 = [[RoATabViewItem alloc] initWithIdentifier:@"project"];
	[app10TabItem06 setLabel:"Progetti"];
	var app10TabItem07 = [[RoATabViewItem alloc] initWithIdentifier:@"contact"];
	[app10TabItem07 setLabel:"Contatti"];
	
	
	//[contentView addSubview:self];
}


-(void)display
{
	[contentView addSubview:self];
	//alert("quante views abbiamo :"+[contentView subviews]);
}


-(void)filterData:(CPSearchField)aSearchField
{
	//alert([aSearchField stringValue]);
	
	var searchString = escape([aSearchField stringValue]);
	
	if ([[app10TabView tabViewItems] count] > 0) {
		[app10TabView removeTabViewItem:app10TabItem01];
		[app10TabView removeTabViewItem:app10TabItem02];
		[app10TabView removeTabViewItem:app10TabItem03];
		[app10TabView removeTabViewItem:app10TabItem04];
		[app10TabView removeTabViewItem:app10TabItem05];
		[app10TabView removeTabViewItem:app10TabItem06];
		[app10TabView removeTabViewItem:app10TabItem07];

	}

	//================ qui =====================
	var skipHeaders = ["_id", "_rev", "type", "_attachments", "lists", "domain", "meta"];
	var includeHeaders = ["type", "Titolo", "Nome", "Cognome", "Indirizzo casa", "Localita casa", "Data di nascita"];

	//================ qui =====================
	
	var includeHeaders01 = [
	["Appellativo", "Titolo", "Nome", "Cognome", "Indirizzo casa", "Localita casa", "Storia_Professionale", "Aree_di_Esperienza", "Cellulare", "Telefono_Lavoro" ,"eMail_Lavoro"],
	[90, 80, 100, 100, 130, 130, 200, 180, 80, 80, 120]
	];
	var includeHeaders02 = [
	["Ragione_Sociale", "Indirizzo", "Localita", "Telefono", "eMail", "Sito Web"],
	[150, 150, 150, 80, 120, 200]
	];
	var includeHeaders03 = [
	["Organizzazione", "Indirizzo", "Localita", "Telefono", "eMail", "Sito Web"],
	[150, 150, 200, 80, 120, 200]
	];
	var includeHeaders04 = [
	["Nome", "Cognome", "Tipo Socio", "Iscritto_dal"],
	[120, 120, 150, 100]
	];
	var includeHeaders05 = [
	["Nome", "Cognome", "Tipo Collaborazione", "Sede di lavoro", "Disponibilita", "Progetto"],
	[120, 120, 150, 150, 100, 150]
	];
	var includeHeaders06 = [
	["Denominazione", "Super Progetto", "Capo Progetto", "Data Fine Presunta", "Importo Stanziato", "Partecipanti"],
	[150, 150, 200, 120, 120, 200]
	];
	var includeHeaders07 = [
	["Stato", "Data_del_Contatto", "Persona_Contattata", "Azienda_Contattata", "Collaboratore", "Forma_del_Contatto", "Esito_Contatto"],
	[60, 120, 150, 150, 150, 100, 300]
	];
	
	
	if (searchString == "tutto")
	{
		var searchString01 = encodeURIComponent("(person)");
		var searchString02 = encodeURIComponent("company");
		var searchString03 = encodeURIComponent("non_profit_organization");
		var searchString04 = encodeURIComponent("member");
		var searchString05 = encodeURIComponent("employee");
		var searchString06 = encodeURIComponent("project");
		var searchString07 = encodeURIComponent("contact");
	}
	else
	{
		var searchString01 =encodeURIComponent("("+searchString+" AND person)");
		var searchString02 =encodeURIComponent("("+searchString+" AND company)");
		var searchString03 =encodeURIComponent("("+searchString+" AND non_profit_organization)");
		var searchString04 =encodeURIComponent("("+searchString+" AND member)");
		var searchString05 =encodeURIComponent("("+searchString+" AND employee)");
		var searchString06 =encodeURIComponent("("+searchString+" AND project)");
		var searchString07 =encodeURIComponent("("+searchString+" AND contact)");
	}

	var insetX = 0.0;
	var insetY = 0.0;
	var contentTableWidth = [app10TabView frame].size.width- 2*insetX ;
	var contentTableHeight = [app10TabView frame].size.height- 2*insetY;
	
	
	var tabViewItemContentFrame = CGRectMake(insetX, insetY, contentTableWidth, contentTableHeight);

	
	var app1001DataTableView 	= [[RoAGlobalDataTableView alloc] initWithFrame:tabViewItemContentFrame forData:searchString01 skip:skipHeaders include:includeHeaders01];
	var app1002DataTableView 	= [[RoAGlobalDataTableView alloc] initWithFrame:tabViewItemContentFrame forData:searchString02 skip:skipHeaders include:includeHeaders02];
	var app1003DataTableView 	= [[RoAGlobalDataTableView alloc] initWithFrame:tabViewItemContentFrame forData:searchString03 skip:skipHeaders include:includeHeaders03];
	var app1004DataTableView 	= [[RoAGlobalDataTableView alloc] initWithFrame:tabViewItemContentFrame forData:searchString04 skip:skipHeaders include:includeHeaders04];
	var app1005DataTableView 	= [[RoAGlobalDataTableView alloc] initWithFrame:tabViewItemContentFrame forData:searchString05 skip:skipHeaders include:includeHeaders05];
	var app1006DataTableView 	= [[RoAGlobalDataTableView alloc] initWithFrame:tabViewItemContentFrame forData:searchString06 skip:skipHeaders include:includeHeaders06];
	var app1007DataTableView 	= [[RoAGlobalDataTableView alloc] initWithFrame:tabViewItemContentFrame forData:searchString07 skip:skipHeaders include:includeHeaders07];
	
	[[app1001DataTableView myTableView01] setTarget:crm10Controller];
	[[app1001DataTableView myTableView01] setDoubleAction:"doubleClick:"];
	
	[[app1002DataTableView myTableView01] setTarget:crm10Controller];
	[[app1002DataTableView myTableView01] setDoubleAction:"doubleClick:"];
		
	[[app1003DataTableView myTableView01] setTarget:crm10Controller];
	[[app1003DataTableView myTableView01] setDoubleAction:"doubleClick:"];
		
	[[app1004DataTableView myTableView01] setTarget:crm10Controller];
	[[app1004DataTableView myTableView01] setDoubleAction:"doubleClick:"];
		
	[[app1005DataTableView myTableView01] setTarget:crm10Controller];
	[[app1005DataTableView myTableView01] setDoubleAction:"doubleClick:"];
		
	[[app1006DataTableView myTableView01] setTarget:crm10Controller];
	[[app1006DataTableView myTableView01] setDoubleAction:"doubleClick:"];	
	
	[[app1007DataTableView myTableView01] setTarget:crm10Controller];
	[[app1007DataTableView myTableView01] setDoubleAction:"doubleClick:"];

	[app10TabItem01 setLabel:"Persone - "+[app1001DataTableView numberOfHits]+" trovate"];	
	[app10TabItem02 setLabel:"Aziende - "+[app1002DataTableView numberOfHits]+" trovate"];
	[app10TabItem03 setLabel:"No Profit - "+[app1003DataTableView numberOfHits]+" trovate"];
	[app10TabItem04 setLabel:"Soci - "+[app1004DataTableView numberOfHits]+" trovati"];
	[app10TabItem05 setLabel:"Collaboratori - "+[app1005DataTableView numberOfHits]+" trovati"];
	[app10TabItem06 setLabel:"Progetti - "+[app1006DataTableView numberOfHits]+" trovati"];
	[app10TabItem07 setLabel:"Contatti - "+[app1007DataTableView numberOfHits]+" trovati"];
	
	//FIXME: come mettere una ellipsis quando il testo è troppo lungo?
	//[[app10TabItem05 label] setLineBreakMode:CPLineBreakByTruncatingTail];
	
	[app10TabItem01 setView:app1001DataTableView];
	[app10TabItem02 setView:app1002DataTableView];
	[app10TabItem03 setView:app1003DataTableView];
	[app10TabItem04 setView:app1004DataTableView];
	[app10TabItem05 setView:app1005DataTableView];
	[app10TabItem06 setView:app1006DataTableView];
	[app10TabItem07 setView:app1007DataTableView];
	
	[self addSubview:app10TabView];
	
	[app10TabView addTabViewItem:app10TabItem01];
	[app10TabView addTabViewItem:app10TabItem02];
	[app10TabView addTabViewItem:app10TabItem03];
	[app10TabView addTabViewItem:app10TabItem04];
	[app10TabView addTabViewItem:app10TabItem05];
	[app10TabView addTabViewItem:app10TabItem06];
	[app10TabView addTabViewItem:app10TabItem07];
}


-(CPArray)tableObjects
{
	return [app1001DataTableView tableObjects];
}


-(CPArray)selectedTableObjects
{
	return [app1001DataTableView selectedTableObjects];
}

@end
