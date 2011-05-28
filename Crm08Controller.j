// -----------------------------------------------------------------------------
//  Crm08Controller.j
//  RoACrm01
//
// 	Created by Bruno Ronchetti on May 13, 2010.
// 	Copyright 2010, Ronchetti & Associati All rights reserved.
// -----------------------------------------------------------------------------


@import <Foundation/CPObject.j>
@import "Crm0801View.j"
@import "Crm0802Window.j"


@implementation Crm08Controller : CPObject
{
	Crm0801View id	crm0801View @accessors;
	crm0802Window id	crm0802Window;
}


-(void)init
{	
	self = [super init];
	
	if (self)
	{
		crm08Controller = self;
		// ---------------------------------------------------------------------
		// Geometry 
		//
		var contentViewWidth = [contentView frame].size.width;
		var contentViewHeight = [contentView frame].size.height- KKRoAY3;
				
		//var viewFrame = CGRectMake(KKRoAX1+KKRoAX2, KKRoAY0 , contentViewWidth-(KKRoAX1+KKRoAX2)-10, contentViewHeight-KKRoAY0);
		var rightOffset = KKRoAX1+KKRoAX2+ 5.0;
		var viewFrame = CGRectMake(rightOffset, KKRoAY0+10 , contentViewWidth-rightOffset-5.0, contentViewHeight-KKRoAY0-15);
						
		var appNotificationCenter = [CPNotificationCenter defaultCenter];
		[appNotificationCenter addObserver:self selector:"navigation:" name:nil object:@"Crm01Navigation"];

		var crm0801View = [[Crm0801View alloc] initWithFrame:viewFrame];
		[crm0801View setAutoresizingMask:CPViewHeightSizable | CPViewWidthSizable];
		[crm0801View setBackgroundColor:[CPColor clearColor]];
				
		return self;
	}
}


-(void)navigation:(CPNotification)aNotification
{	
	if ([aNotification object] === @"Crm01Navigation")
	{
		switch ([aNotification name])
		{
			case "didMenuSelection":
						[crm0801View removeFromSuperview];
						break;
						
			case "didSelectAList":
						//alert("crm08controller Arrivato didSelectAList");
						[crm0801View refresh];
						break;

			case "didActivatePrintMode":
						[crm0801View initialize];
						[crm0801View display];
						break;				

			case "didClosePrintMode":
						//alert("crm08controller Arrivato didClosePrintMode");
						[crm0801View removeFromSuperview];
						break;	
						
			case "didLogout":		
						[crm0801View removeFromSuperview];
						break;

			case "didRequestHelp":	
						[crm0801View removeFromSuperview];
						break;

			case "didRequestPrintForList":	
						[crm0801View refresh];
						[crm0801View display];
						break;
						
			default: 	break;
		}
	}
}


-(void)preparePrintLayout
{
	//alert("finestra "+theWindow);
	
	originalPlatformWindow = [[crm0801View window] platformWindow];
	anotherPlatformWindow = [[CPPlatformWindow alloc] initWithContentRect:CGRectMake(100.0, 50.0, 700.0, 1030.0)];
	
	crm0802Window = [[Crm0802Window alloc] initWithContentRect:CGRectMake(100.0, 50.0, 700.0, 1030.0) styleMask:CPTitledWindowMask];
	[crm0802Window setPlatformWindow:anotherPlatformWindow];
	//[crm0802Window setFullBridge:YES];
	[crm0802Window setFullPlatformWindow:YES];
	[crm0802Window makeKeyAndOrderFront:self];
	[crm0802Window setShowsResizeIndicator:NO];

	[[CPRunLoop currentRunLoop] limitDateForMode:CPDefaultRunLoopMode];
}


-(void)printConfirmation
{
	//alert("in 08controller printconfirmation");
	//[originalPlatformWindow orderOut:self
	//[theWindow orderOut:self];
	//[crm0802Window orderOut:self]
	//[crm0802Window setFrameSize:CGSizeMake(windowWidth, letterHeight*[crm0802Window numberOfPages])];
	//[[crm0802Window crm0802ScrollView] setFrameSize:CGSizeMake(windowWidth, letterHeight*[crm0802Window numberOfPages])];
		
	[crm0802Window printConfirmation];
	//anotherPlatformWindow._DOMWindow.print();
	anotherPlatformWindow._DOMWindow.print();
	[anotherPlatformWindow orderOut:self];
	[theWindow makeKeyAndOrderFront:self];
}



-(void)printAndStoreConfirmation
{
	//alert("adesso provvedo a memorizzare i contatti");
	
	var contactRecord = new Object();
	contactRecord["type"] = "contact";
	contactRecord["Stato"] = "effettuato";
	contactRecord["Data_del_Contatto"] = new Date().toLocaleDateString();
	contactRecord["Forma_del_Contatto"] = "lettera";
	contactRecord["Esito_Contatto"] = "Inviata "+[crm0802Window letterName]+", una di un gruppo di "+[crm0802Window numberOfPages];

	var selectedObjects = [crm0802Window selectedObjects];

	//alert("prima del loop "+[selectedObjects count]);
	for (var i=0; i<[selectedObjects count]; i++)
	{
		contactRecord["Persona_Contattata"] = selectedObjects[i]["Nome"]+" "+selectedObjects[i]["Cognome"];
		
		//contactRecord["Persona_Contattata"] = selectedObjects[i]["Persona"];
		contactRecord["domain"] = KKRoAUserDomain;

		var key = generateUid()
		
		var writeContact= new Object();
		writeContact["action"] = "writeDoc";
		writeContact["key"] = "documents/"+key;
		writeContact["body"] = contactRecord;
		var writeData = [[RoACouchModule alloc] initWithRequest:writeContact executeSynchronously:1];
	}
	
	[self printConfirmation];

}

- (void)cancel
{
	[anotherPlatformWindow orderOut:self];
	//[crm0802Window close];
}

@end