// -----------------------------------------------------------------------------
//  Crm0903View.j
//  RoACrm01
//
// 	Created by Bruno Ronchetti on June 02, 2010.
// 	Copyright 2010, Ronchetti & Associati All rights reserved.
// -----------------------------------------------------------------------------


@import <Foundation/CPObject.j>


@implementation Crm0903View : CPWindow
{
	CPButton 	id printButton;
	CPButton 	id cancelButton;
	
	CPView		id crm0903ContentView @accessors;
	CPWebView	id crm0903AttachmentView @accessors;
	
	CPView			id	ownSuperview;
}



- (id)initWithContentRect:(CGRect)aFrame
{	
	var windowWidth = 700.0;
	var buttonBarHeight = 40.0;
	
	self = [super initWithContentRect:aFrame styleMask:CPTitledWindowMask];
	
	if (self)
	{		
		crm0903ContentView = [self contentView];
		[crm0903ContentView setBackgroundColor:[CPColor whiteColor]];
		
		var crm0903AttachmentView = [[CPWebView alloc] initWithFrame:CGRectMake(0, 40, 700.0, 1030.0)];	

		[self setTitle:"Allegato"];
		//[self setDelegate:self];
		
		var buttonBar = [[CPView alloc] initWithFrame:CGRectMake(0, 0, windowWidth, buttonBarHeight)];
		//[buttonBar setBackgroundColor:[CPColor redColor]];
		[buttonBar setBackgroundColor:KKRoALightGray];
		[crm0903ContentView addSubview:buttonBar];
	
		var cancelButton = [[CPButton alloc] initWithFrame:CGRectMake(10,5,100,24)];
		[cancelButton setBezelStyle:CPRegularSquareBezelStyle];
		[cancelButton setBordered:YES];
		[cancelButton setTitle:"Annulla"];
		[cancelButton setTarget:crm09Controller];
		[cancelButton setAction:"cancel"];
		[buttonBar addSubview:cancelButton];
		
		var saveButton = [[CPButton alloc] initWithFrame:CGRectMake(windowWidth-230,5,100,24)];
		[saveButton setBezelStyle:CPRegularSquareBezelStyle];
		[saveButton setBordered:YES];
		[saveButton setTitle:"Download"];
		[saveButton setTarget:crm09Controller];
		[saveButton setAction:"downloadConfirmation"];
		[buttonBar addSubview:saveButton];

		var printButton = [[CPButton alloc] initWithFrame:CGRectMake(windowWidth-110,5,100,24)];
		[printButton setBezelStyle:CPRegularSquareBezelStyle];
		[printButton setBordered:YES];
		[printButton setTitle:"Stampa"];
		[printButton setTarget:crm09Controller];
		[printButton setAction:"printConfirmation"];
		[buttonBar addSubview:printButton];

		return self;
	}
}

-(void)setHidden:(bool)shouldBeHidden
{
	if (shouldBeHidden == true)
	{
		var ownSuperview = [self superview];
		[self removeFromSuperview];
	}
	else
	{
		[ownSuperview addSubview:self];
	}
}

-(void)displayAttachment:(CPString)anAttachment forDocument:(CPString)aDocument
{
	//alert("in 0903view displayattachement "+KKRoAnItem+" "+anAttachment);
	[self setTitle:"Allegato a "+aDocument];
	[crm0903AttachmentView setMainFrameURL:@"http://localhost:5984/crm_documents/"+KKRoAnItem+"/"+anAttachment];
	[crm0903ContentView addSubview:crm0903AttachmentView];
	//[self orderFront:self];
}


@end