// -----------------------------------------------------------------------------
//  Crm0601View.j
//  RoACrm
//
// 	Created by Bruno Ronchetti on May 13, 2010.
// 	Copyright 2010, Ronchetti & Associati All rights reserved.
// -----------------------------------------------------------------------------


@import <Foundation/CPObject.j>
@import <RoAKit/RoAFormView.j>


@implementation Crm0601View : CPScrollView
{
	CPArray			id inputForm;

//new	
	CPDictionary	id	databaseValues;
	CPView			id	crm06DocView	@accessors;
	CPObject		id	theDataDelegate;
	
	float				id	theWidth;
	float				id	theHeight;	
}


-(void)initWithFrame:(CGRect)aFrame
{
	self = [super initWithFrame:aFrame];
	
	if (self)
	{
		[self setHasVerticalScroller:YES];
		[self setHasHorizontalScroller:NO];
		[self setAutohidesScrollers:YES];
		//[[self window] setAutorecalculatesKeyViewLoop:YES];
		return self; 
	}
}

-(void)initialize
{
//
// Geometry
//
	var theHeight 	= [self frame].size.height;
	var theWidth	= [self frame].size.width;
	
	var crm06DocView = [[RoAFormView alloc] initWithFrame:CGRectMake(0.0, 0.0, theWidth-20.0, theHeight)];
	[self setHasHorizontalScroller:NO];
	[self setDocumentView:crm06DocView];
}



-(void)prepareForm:(CPString)aFormIdentifier withTemplate:(CPArray)aFormTemplate
{	
	[crm06DocView prepareForm:aFormIdentifier withTemplate:aFormTemplate];
	
	// FIXME questo di aggiungere 140 all'altezza è un hack grossolano, si dovrebbe poter fare meglio
	//
	[crm06DocView setFrameSize:CGSizeMake(theWidth-20.0, [crm06DocView finalHeight]+140.0)];
}


-(void)display
{
	//alert("in 06view display "+[self subviews]);
	[contentView addSubview:self positioned:CPWindowBelow relativeTo:[crm07Controller crm0701View]];
	[[self window] makeFirstResponder:[crm06DocView firstResponderField]];
}


-(void)setDataDelegate:(CPObject)aDataDelegate
{
	theDataDelegate = aDataDelegate;
}

-(void)clearView
{
	//alert("in clearView");	
	[[crm06DocView subviews] makeObjectsPerformSelector:@"removeFromSuperview"];
}

-(void)resetView
{
	[crm06DocView clearForm];
	[crm06DocView setInitialValues];
}


-(JSObject)getFormDataForItem:(CPString)anItem
{
	var screenItem = anItem;
		
	var screenField = [[crm06DocView inputFieldsDictionary] objectForKey:screenItem];
	var screenValue = [screenField getScreenValue];
	return screenValue;
}



-(JSObject)getFormData
{
	KKRoATheScreenDoc = [CPDictionary dictionary];
	var screenItems = [[crm06DocView inputFieldsDictionary] allKeys];
	
	// FIXME salta i dati che sono output only che sono stati aggiunti in prepare
	//
	for (var i=0; i<[screenItems count]; i++)
	{
		//alert("dentro il loop di getformdata 06view");
		var screenItem = screenItems[i];
		var screenField = [[crm06DocView inputFieldsDictionary] objectForKey:screenItem];
		var screenValue = [screenField getScreenValue];		
		if (screenValue != "")
		{
			[KKRoATheScreenDoc setValue:screenValue forKey:screenItem];
		}
	}
	return KKRoATheScreenDoc;
}


-(void)setFormData:(CPDictionary)theDatabaseValues
{

	var databaseValues = [CPDictionary dictionaryWithDictionary:theDatabaseValues];
	
	var formItems = [[crm06DocView inputFieldsDictionary] allKeys];
	
	//alert("keys sono :"+[[crm06DocView inputFieldsDictionary] allKeys]);
	//alert("objects sono :"+[[crm06DocView inputFieldsDictionary] allValues]);
			
	for (var i=0; i<[formItems count]; i++)
	{
		var formItem = formItems[i];
		var formField = [[crm06DocView inputFieldsDictionary] objectForKey:formItem];
		var databaseValue = [databaseValues objectForKey:formItem];
		
		//alert("in crm0601view setformdata "+formItem+" "+databaseValue);
		[formField setScreenValue:databaseValue];
	}
}


@end