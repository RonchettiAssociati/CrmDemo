
// -----------------------------------------------------------------------------
//  Crm0905View.j
//  RoACrm01
//
// 	Created by Bruno Ronchetti on May 13, 2010.
// 	Copyright 2010, Ronchetti & Associati All rights reserved.
// -----------------------------------------------------------------------------


@import <Foundation/CPObject.j>
@import <RoAKit/RoADataTableView.j>
@import <RoAKit/RoADataOutlineView.j>


@implementation Crm0905View : CPView
{
	int	id	theHeight;
	int	id	theWidth;
	
	CPArray	id	skipHeaders;
	CPArray	id	includeHeaders;
	
	RoADataOutlineView id crm0905DataOutlineView;
	
	CPView			id	containingView;
}

-(void)initWithFrame:(CGRect)aFrame
{
	self = [super initWithFrame:aFrame];
	if (self)
	{
		crm0905View = self;
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

	var filterPeopleField = [[CPSearchField alloc] initWithFrame:CGRectMake(10, 10, 150, 30)];
    [filterPeopleField setAutoresizingMask:CPViewMaxXMargin];
	[filterPeopleField setSendsWholeSearchString:YES];
	[filterPeopleField setPlaceholderString:"filtra contatti"];
	[filterPeopleField setTarget:crm0905DataOutlineView];
	[filterPeopleField setAction:@selector(filterTable:)];
	[filterPeopleField setMaximumRecents:10];
	[filterPeopleField setRecentsAutosaveName:"filterContactList"];
    //[self addSubview:filterPeopleField];
	
	var redSquare = [[CPView alloc] initWithFrame:CGRectMake(5,5,100,100)];
	[redSquare setBackgroundColor:[CPColor redColor]];
	//[self addSubview:redSquare];
	

	//================ qui =====================
	//var skipHeaders = ["_id", "_rev", "type", "_attachments", "lists"];
	
	var includeHeaders = [];
	var includeHeaders = [["Progetto", "Ruolo", "Data Inizio", "Data Fine"], [150, 200, 100, 100]];
	//================ qui =====================

	var crm0905DataOutlineView 	= [[RoADataTableView alloc] initWithFrame:CGRectMake(0.0, 0.0, theWidth, 400.0)];
	[crm0905DataOutlineView layoutSkipping:skipHeaders including:includeHeaders];
	[self addSubview:crm0905DataOutlineView];
	
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
	[crm0905DataOutlineView loadData:completeURL];
}



-(void)display
{	
	[containingView addSubview:self];
}



@end