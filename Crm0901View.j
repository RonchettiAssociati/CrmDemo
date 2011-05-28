// -----------------------------------------------------------------------------
//  Crm0901View.j
//  RoACrm01
//
// 	Created by Bruno Ronchetti on May 13, 2010.
// 	Copyright 2010, Ronchetti & Associati All rights reserved.
// -----------------------------------------------------------------------------


@import <Foundation/CPObject.j>
@import <RoAKit/RoAUploadButton.j>


@implementation Crm0901View : CPView
{
	CPString		id	aDocument;
	CPString		id	revisionNumber;
	RoAUploadButton	id	selectButton;
	CPButton		id	uploadButton;
	CPTextField		id	fileToUpload;
	CPString		id	fileNameToUpload;
	
	CPTableView		id	existingAttachmentsTableView01;
	
	CPView			id	containingView;
}

-(void)initWithFrame:(CGRect)aFrame
{
	self = [super initWithFrame:aFrame];
	if (self)
	{
		crm0901View = self;
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
	var theWidth	= [self bounds].size.width;	

	var filenamesArray = [CPArray new];
	
	var existingAttachmentsScrollView = [[CPScrollView alloc] initWithFrame:CGRectMake(100,20,400,200)];
	[existingAttachmentsScrollView setHasHorizontalScroller:NO];
	[existingAttachmentsScrollView setAutohidesScrollers:YES];
	[existingAttachmentsScrollView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
	[self addSubview:existingAttachmentsScrollView];
	
	existingAttachmentsTableView01 = [[CPTableView alloc] initWithFrame:CGRectMakeZero()];
	[existingAttachmentsTableView01 setTag:"existingAttachmentsTableView01"];
	[existingAttachmentsTableView01 setAutoresizingMask:CPViewWidthSizable];
	[existingAttachmentsTableView01 setAllowsColumnResizing:NO];
	[existingAttachmentsTableView01 setAllowsMultipleSelection:NO];
	[existingAttachmentsTableView01 setUsesAlternatingRowBackgroundColors:YES];
	[existingAttachmentsTableView01 setAlternatingRowBackgroundColors:[[CPColor whiteColor], KKRoABackgroundWhite]];
	[existingAttachmentsTableView01 setRowHeight:18];
	[existingAttachmentsTableView01 setDelegate:crm09Controller];
	[existingAttachmentsTableView01 setTarget:crm09Controller];
	[existingAttachmentsTableView01 setDoubleAction:@"displayAttachment:"];
	[existingAttachmentsTableView01 setDataSource:crm09Controller];
	[existingAttachmentsScrollView setDocumentView:existingAttachmentsTableView01];
	[self addSubview:existingAttachmentsScrollView];
	
	var textDataView01 = [CPTextField new];
	[textDataView01 setFont:KKRoaTableHeaderFont];
	var columnString 	= "Attachments";			
	var column = [[CPTableColumn alloc] initWithIdentifier:columnString];
	[[column headerView] setStringValue:columnString];		
	[column setWidth:[existingAttachmentsScrollView frame].size.width];
	[column setDataView:textDataView01];
	[existingAttachmentsTableView01 addTableColumn:column];
		
	var fileToUpload = [[CPTextField alloc] initWithFrame:CGRectMake(100,250,400,28)];
	[fileToUpload setBackgroundColor:[CPColor whiteColor]];
	[fileToUpload setBezeled:YES];
	[fileToUpload setAutoresizingMask:CPViewMinYMargin | CPViewWidthSizable];
	[fileToUpload setStringValue:filenamesArray]; 
	[self addSubview:fileToUpload];
	
	var selectButton = [[RoAUploadButton alloc] initWithFrame: CGRectMake(10, 254,  60.0, 20.0)] ; 
	[selectButton setTitle:"Select File"] ; 
	[selectButton setBordered:YES];
	[selectButton setDelegate: self]; 
	[selectButton sizeToFit];
	[selectButton setValue:KKRoAMediumLightGray forThemeAttribute:@"text-color" inState:CPThemeStateDisabled];
	[selectButton setValue:KKRoAMediumBlue forThemeAttribute:@"text-color" inState:CPThemeStateNormal];
	[selectButton setValue:KKRoAHighlightBlue forThemeAttribute:@"text-color" inState:CPThemeStateHighlighted];
	[selectButton setAutoresizingMask:CPViewMinYMargin | CPViewMaxXMargin] ; 

	var uploadButton = [[CPButton alloc] initWithFrame: CGRectMake(520, 254,  60.0, 20.0)] ; 
	[uploadButton setTitle:"Upload File"] ; 
	[uploadButton setBordered:YES];
	[uploadButton setEnabled:NO];
	[uploadButton setAction:"uploadFile:"] 
	[uploadButton setTarget: self]; 
	[uploadButton sizeToFit];
	[uploadButton setValue:KKRoAMediumLightGray forThemeAttribute:@"text-color" inState:CPThemeStateDisabled];
	[uploadButton setValue:KKRoAMediumBlue forThemeAttribute:@"text-color" inState:CPThemeStateNormal];
	[uploadButton setValue:KKRoAHighlightBlue forThemeAttribute:@"text-color" inState:CPThemeStateHighlighted];
	[uploadButton setAutoresizingMask:CPViewMinYMargin];
	[uploadButton setHidden:NO];
		
	[self addSubview:selectButton]; 
	[self addSubview:uploadButton];
	
	return self; 	
}

-(void)display
{
	[containingView addSubview:self];
}

-(void)refresh
{
	[existingAttachmentsTableView01	reloadData];
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

- (void)awakeForDocument:(CPString)theDocument
{
	//alert("in awake ++++++++++++++");
	aDocument = theDocument;
	[existingAttachmentsTableView01 reloadData];
}


-(void)uploadFile:(CPButton)aButton
{

	//alert("dentro");
	var globalURL = "RoAServer.rb?action=uploadAttachment&key=";
	
	var readForUpdate = new Object();
	readForUpdate["action"] = "readDoc";
	readForUpdate["key"] = "documents/"+KKRoAnItem;
	var record = [[RoACouchModule alloc] initWithRequest:readForUpdate executeSynchronously:1];
	
	//alert("record letto "+readForUpdate["key"]+" "+ record);
	var revisionNumber = record["_rev"];
	var fileSpecificURL = globalURL+"/crm_documents/"+KKRoAnItem+"/"+fileNameToUpload+"?rev="+revisionNumber
	
	[selectButton setURL:fileSpecificURL];
	[selectButton submit];
}

// ------------------------------------------------------
// DELEGATE METHODS OF UPLOAD BUTTON
// ------------------------------------------------------

-(void)uploadButton:(CPButton)aButton didChangeSelection:aSelection
{
	//alert("didchangeselection :"+aSelection);
	[fileToUpload setStringValue:aSelection];
	var fileNameToUpload = aSelection;
	[uploadButton setHidden:NO];
	[uploadButton setEnabled:YES];
}


-(void)uploadButtonDidBeginUpload:(CPUploadButton)anUploadButton
{
	var fileNameToUpload = [fileToUpload stringValue];
	[fileToUpload setStringValue:fileNameToUpload+"...       uploading"];
	[selectButton setHidden:YES];
}

-(void)uploadButton:(CPButton)aButton  didFinishUploadWithData:(CPString)aResponse
{
	//alert("uploadDidFinishWithResponse: "+aResponse);
	[selectButton setHidden:NO];
	[uploadButton setHidden:YES];
	[fileToUpload setStringValue:""];
	[crm09Controller getAttachments];
	[existingAttachmentsTableView01 reloadData];

}

-(void)uploadButton:(CPButton)aButton  didFailWithError:(CPString)anError
{
	//alert("uploadDidFailWithError: "+anError);
	[selectButton setHidden:NO];
	[uploadButton setHidden:YES];
	[fileToUpload setStringValue:""];
	[crm09Controller getAttachments];
	[existingAttachmentsTableView01 reloadData];
}


@end