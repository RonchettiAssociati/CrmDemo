// -----------------------------------------------------------------------------
//  Crm09Controller.j
//  RoACrm01
//
// 	Created by Bruno Ronchetti on May 13, 2010.
// 	Copyright 2010, Ronchetti & Associati All rights reserved.
// -----------------------------------------------------------------------------


@import <Foundation/CPObject.j>
@import "Crm0901View.j"
@import "Crm0902View.j"
@import "Crm0903View.j"
@import "Crm0904View.j"
@import "Crm0905View.j"



@implementation Crm09Controller : CPObject
{
	//CPNotificationCenter 	id appNotificationCenter;
	Crm0901View				id crm0901View	@accessors;
	
	CPString		id	aDocument;
	CPString		id	revisionNumber;
	CPString		id 	selectedAttachment;
	CPArray			id	existingAttachments;
	CPUploadButton	id	selectButton;
	CPButton		id	uploadButton;
}


-(void)init
{	
	self = [super init];
	if (self)
	{
	
		crm09Controller = self;
		var existingAttachments = [];

		// ---------------------------------------------------------------------
		// Geometry 
		//
		var contentViewWidth = [contentView frame].size.width;
		var contentViewHeight = [contentView frame].size.height- KKRoAY3;
		
		var viewFrame = CGRectMake(0, KKRoAY2+ 5.0, contentViewWidth, KKRoAY4-KKRoAY2);
		//var viewFrame = [[crm07Controller crm0701View] frame];
			
		var appNotificationCenter = [CPNotificationCenter defaultCenter];
		[appNotificationCenter addObserver:self selector:"navigation:" name:nil object:@"Crm01Navigation"];


		crm0901View = [[Crm0901View alloc] initWithFrame:viewFrame];
		[crm0901View setAutoresizingMask:CPViewHeightSizable];
		[crm0901View setBackgroundColor:[CPColor clearColor]];
		//[crm0901View setBackgroundColor:KKRoABackgroundWhite];
		[crm0901View setContainingView:[crm07Controller crm0701View]];
		[crm0901View initialize];
	
		var crm0902View = [[Crm0902View alloc] initWithFrame:viewFrame];
		[crm0902View setAutoresizingMask:CPViewHeightSizable];
		[crm0902View setBackgroundColor:[CPColor clearColor]];
		//[crm0902View setBackgroundColor:KKRoABackgroundWhite];
		[crm0902View setContainingView:[crm07Controller crm0701View]];
		[crm0902View initialize];

		var crm0904View = [[Crm0904View alloc] initWithFrame:viewFrame];
		[crm0904View setAutoresizingMask:CPViewHeightSizable];
		[crm0904View setBackgroundColor:[CPColor clearColor]];
		//[crm0904View setBackgroundColor:KKRoABackgroundWhite];
		[crm0904View setContainingView:[crm07Controller crm0701View]];
		[crm0904View initialize];
		
		var crm0905View = [[Crm0905View alloc] initWithFrame:viewFrame];
		[crm0905View setAutoresizingMask:CPViewHeightSizable];
		[crm0905View setBackgroundColor:[CPColor clearColor]];
		//[crm0905View setBackgroundColor:KKRoABackgroundWhite];
		[crm0905View setContainingView:[crm07Controller crm0701View]];
		[crm0905View initialize];
						
		[self initialDisplay];
		
		
		return self;
	}
}


-(void)navigation:(CPNotification)aNotification
{
	if ([aNotification object] === @"Crm01Navigation")
	{
		[crm0901View setHidden:YES];
		[crm0902View setHidden:YES];
		[crm0904View setHidden:YES];
		[crm0905View setHidden:YES];
							
		switch ([aNotification name])
		{
			case "didRequestDocDisplay":	
						//[self getAttachments];
						//[self getContacts];
						//[self getPersons];
						//[self getProjects];
						break;

			case "didRequestAttachments":
						[self getAttachments];
						[crm0901View setHidden:NO];
						break;

			case "didRequestContacts":
						[self getContacts];
						[crm0902View setHidden:NO];
						break;

			case "didRequestPersons":
						[self getPersons];
						[crm0904View setHidden:NO];
						break;

			case "didRequestProjects":
						[self getProjects];
						[crm0905View setHidden:NO];
						break;
						
			case "didCloseSlideUpPanel":
						[crm0901View setHidden:YES];
						[crm0902View setHidden:YES];
						[crm0904View setHidden:YES];
						[crm0905View setHidden:YES];
						break;
						
			case "didLogout":
			case "didRequestHelp":	
			case "didRequestGlobalSearch":
			case "didActivatePrintMode":
			case "didRequestPrintForList":
						[crm0901View removeFromSuperview];
						[crm0902View removeFromSuperview];
						[crm0904View removeFromSuperview];
						[crm0905View removeFromSuperview];
						break;
																											
			default: 	break;
		}
	}
}

-(void)initialDisplay
{
	[crm0901View display];
	[crm0902View display];
	[crm0904View display];
	[crm0905View display];
	
	[crm0901View setHidden:YES];
	[crm0902View setHidden:YES];
	[crm0904View setHidden:YES];
	[crm0905View setHidden:YES];
}


-(void)getAttachments
{	
	if(KKRoAnItem == "")
	{
		return;
	}
	
	var readAttachments = new Object();
	readAttachments["action"] = "readDoc";
	readAttachments["key"] = "documents/"+KKRoAnItem;
	var record = [[RoACouchModule alloc] initWithRequest:readAttachments executeSynchronously:1];
	
	//listProperties(record, "record in get attachments");
	//alert("controllo a");
	
	var attachments = [CPDictionary dictionaryWithJSObject:record["_attachments"] recursively:NO];
	var existingAttachments = [attachments allKeys];
	
	//listProperties(existingAttachments, "existingAttachments");
	[crm0901View refresh];
}


-(void)getContacts
{
	if(KKRoAnItem == "")
	{
		return;
	}
	
	var startkey = [KKRoAUserDomain, KKRoAType, encodeURI(KKRoAForeignKey)];
	var startJSONkey = JSON.stringify(startkey);
	
	var endkey = [KKRoAUserDomain, KKRoAType, encodeURI(KKRoAForeignKey), {}];
	var endJSONkey = JSON.stringify(endkey);
	var completeURL= "documents/_design/data/_view/contacts_by_entity?include_docs=true&startkey="+startJSONkey+"&endkey="+endJSONkey;
	
	[crm0902View refresh:completeURL];
}

-(void)getPersons
{
	if(KKRoAnItem == "")
	{
		return;
	}
		
	var startkey = [KKRoAUserDomain, KKRoAType, encodeURI(KKRoAForeignKey)];
	var startJSONkey = JSON.stringify(startkey);
	
	var endkey = [KKRoAUserDomain, KKRoAType, encodeURI(KKRoAForeignKey), {}];
	var endJSONkey = JSON.stringify(endkey);
	var completeURL= "documents/_design/data/_view/persons_by_entity?startkey="+startJSONkey+"&endkey="+endJSONkey;
	
	[crm0904View refresh:completeURL];
}


-(void)getProjects
{
	if(KKRoAnItem == "")
	{
		return;
	}
		
	var startkey = [KKRoAUserDomain, KKRoAType, encodeURI(KKRoAForeignKey)];
	var startJSONkey = JSON.stringify(startkey);
	
	var endkey = [KKRoAUserDomain, KKRoAType, encodeURI(KKRoAForeignKey), {}];
	var endJSONkey = JSON.stringify(endkey);
	var completeURL= "documents/_design/data/_view/projects_by_entity?startkey="+startJSONkey+"&endkey="+endJSONkey;
	
	//alert("leggo "+completeURL);
	[crm0905View refresh:completeURL];
}


-(void)displayAttachment:aSender
{
	originalPlatformWindow = [[crm0901View window] platformWindow];
	anotherPlatformWindow = [[CPPlatformWindow alloc] initWithContentRect:CGRectMake(100.0, 50.0, 700.0, 1030.0)];
	
	var selectedAttachment = [existingAttachments objectsAtIndexes:[aSender selectedRowIndexes]];
	
	var appNotificationCenter = [CPNotificationCenter defaultCenter];
	//[appNotificationCenter postNotificationName:@"didRequestAttachmentDetail" object:@"Crm01Navigation" userInfo:nil];
		
	crm0903View = [[Crm0903View alloc] initWithContentRect:CGRectMake(0.0, 0.0, 700.0, 1030.0)];
	[crm0903View setPlatformWindow:anotherPlatformWindow];
	
	[crm0903View  displayAttachment:selectedAttachment forDocument:aDocument];


	[anotherPlatformWindow orderFront:self];
	[crm0903View orderFront:self];
}	


-(void)printConfirmation
{
		
	[[crm0903View crm0903AttachmentView] setFrameOrigin:CGPointMake(0,0)];
	anotherPlatformWindow._DOMWindow.print(); 
	[anotherPlatformWindow orderOut:self];
	[theWindow orderFront:self];
}


-(void)downloadConfirmation
{
	anotherPlatformWindow._DOMWindow.open([crm0903AttachmentView mainFrameURL]);
	[self orderOut:self];
}


-(void)cancel
{
	[anotherPlatformWindow orderOut:self];
	//[theWindow orderFront:self];
}



-(void)tableViewSelectionDidChange:aNotification
{
	//selectedAttachment = aSelection;
}


// ------------------------------------------------------
// Delegate Methods to populate table
// ------------------------------------------------------

- (id)tableView:(CPTableView)aTableView objectValueForTableColumn:(CPTableColumn)aTableColumn row:(CPInteger)aRowIndex
{
	//alert ("nel controller b nudo ");
	if (aRowIndex >= 0 && aRowIndex < [existingAttachments count])
	{
		theValue = existingAttachments[aRowIndex];
	}	
	return theValue;
}


- (id)tableView:(CPTableView)aTableView setObjectValue:(CPString)theNewValue forTableColumn:(CPString)aTableColumnHeaderString row:(CPInteger)aRowIndex
{
	//alert ("nel controller c");
	if (aRowIndex >= 0 && aRowIndex < [existingAttachments count])
	{
		existingAttachments[aRowIndex] = theNewValue;
	}
}


- (int)numberOfRowsInTableView:(CPTableView)aTableView
{
	//alert ("nel controller d "+[existingAttachments count]);
	return [existingAttachments count];
}


- (id)tableView:(CPTableView)aTableView heightOfRow:(int)row
{
	//alert ("nel controller e "+row );
    return 20 + ROUND(row * 0.5);
}

*/
@end