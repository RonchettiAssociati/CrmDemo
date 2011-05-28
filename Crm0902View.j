// -----------------------------------------------------------------------------
//  Crm0902View.j
//  RoACrm01
//
// 	Created by Bruno Ronchetti on May 13, 2010.
// 	Copyright 2010, Ronchetti & Associati All rights reserved.
// -----------------------------------------------------------------------------


@import <Foundation/CPObject.j>
//@import <RoAKit/RoADataOutlineView.j>
@import <RoAKit/RoADataTableView.j>


@implementation Crm0902View : CPView
{
	int	id	theHeight;
	int	id	theWidth;
	
	CPArray	id	skipHeaders;
	CPArray	id	includeHeaders;
	
	//RoADataOutlineView id crm0902DataOutlineView;
	RoADataTableView id crm0902DataOutlineView;
	
	CPSearchField	id	filterContactsField;
	CPView			id	containingView;
}

-(void)initWithFrame:(CGRect)aFrame
{
	self = [super initWithFrame:aFrame];
	if (self)
	{
		crm0902View = self;
		return self; 
	}
}

-(void)setContainingView:(CPView)aView
{
	var containingView = aView;
}	


-(void)initialize
{
// GEOMETRY
//
	var theHeight 	= [self bounds].size.height;
	//var theWidth	= [self bounds].size.width;
	
	var theWidth	= [[crm07Controller crm0701View] bounds].size.width;


	var filterContactsField = [[CPSearchField alloc] initWithFrame:CGRectMake(10, 20, 150, 30)];
    [filterContactsField setAutoresizingMask:CPViewMaxXMargin];
	[filterContactsField setSendsWholeSearchString:YES];
	[filterContactsField setPlaceholderString:"filtra contatti"];
	[filterContactsField setTarget:crm0902DataOutlineView];
	[filterContactsField setAction:@selector(filterTable:)];
	[filterContactsField setMaximumRecents:10];
	[filterContactsField setRecentsAutosaveName:"filterContactList"];
    [self addSubview:filterContactsField];
	

	//================ qui =====================
	var skipHeaders = ["_id", "_rev", "type", "_attachments", "lists"];
	
	var includeHeaders = [];
	var includeHeaders = [
			["Stato", "Data_del_Contatto", "Forma_del_Contatto", "Persona_Contattata","Esito/Note"],
			[60, 120, 130, 150, 350]];

	//================ qui =====================

	var crm0902DataOutlineView = [[RoADataTableView alloc] initWithFrame:CGRectMake(0.0, 50.0, theWidth, 200.0)];
	[crm0902DataOutlineView layoutSkipping:skipHeaders including:includeHeaders];
	[self addSubview:crm0902DataOutlineView];
	
	return self; 
}

-(void)setHidden:(bool)shouldBeHidden
{
	if (shouldBeHidden == true)
	{
		[self removeFromSuperview];
	}
	else
	{
		[containingView addSubview:self];
	}
}



-(void)refresh:(CPString)completeURL
{	

	//alert("in refresh di 0902view "+KKRoAnItem +" _ "+KKRoAForeignKey);
	
	// spostato nel controller
	/*
	
	var startkey = [KKRoAUserDomain, KKRoAType, encodeURI(KKRoAForeignKey), ""];
	var startJSONkey = JSON.stringify(startkey);
	
	var endkey = [KKRoAUserDomain, KKRoAType, encodeURI(KKRoAForeignKey), {}];
	var endJSONkey = JSON.stringify(endkey);
	var completeURL= "documents/_design/data/_view/contacts_by_person?include_docs=true&startkey="+startJSONkey+"&endkey="+endJSONkey;
	*/
	
	[crm0902DataOutlineView loadData:completeURL];
	
}



-(void)display
{	
	[containingView addSubview:self];
}



@end