// -----------------------------------------------------------------------------
//  Crm0302View.j
//  RoACrm01
//
// 	Created by Bruno Ronchetti on November 25, 2010.
// 	Copyright 2010, Ronchetti & Associati All rights reserved.
// -----------------------------------------------------------------------------


@import <Foundation/CPObject.j>
@import <RoAKit/RoAAlertPanel.j>



@implementation Crm0302View : CPView
{
	CPNumber	id 	theWidth;
	CPNumber	id 	theHeight;
	CPButton	id 	printButton;
	CPArray		id	buttons;
	RoAAlertPanel	id	alertPanel;
	
	CGRect		id 	theFrame;
}

-(void)initWithFrame:(CGRect)aFrame
{
	self = [super initWithFrame:aFrame];
	if (self)
	{
		var theFrame = aFrame;
		var theWidth = theFrame.size.width;
		var theHeight = theFrame.size.height;

		return self; 
	}
}


-(void)initialize
{
	
}



-(void)tailorForCase:(CPString)aCase
{
	switch (aCase)
	{
		case "selectItem":
			var alertPanel = [[RoAAlertPanel alloc] initWithFrame:theFrame topTipHeight:0.0 bottomTipHeight:10.0 halfTipBasis:5.0 tipPositionX:theWidth/8];
			[alertPanel setFrameOrigin:CGPointMake(0.0, 0.0)];
			[alertPanel setFrameSize:CGSizeMake(300.0, 300.0)];
			[alertPanel initialize];
			[alertPanel setHidden:NO];
			[alertPanel setController:self];
			var alertButtons = [CPDictionary dictionaryWithObjectsAndKeys:
				["cancel", "", "Annulla", "right", -180], @"cancel",
				["confirm", "", "OK - ", "right", -90], @"confirm"
			];
			[alertPanel addMessageBoxWithHeight:20];
			[alertPanel setMessageText:"Prego scegliere una lista"];
			[alertPanel setConfirmButtonText:"Crea Lista"];
			[alertPanel addButtons:alertButtons orientation:"horizontal"];
			[alertPanel setBackgroundColor:KKRoABackgroundWhite];
			[alertPanel addBackgroundView];
			[alertPanel setFrameOrigin:CGPointMake(5.0, [contentView frame].size.height-KKRoAY2-[alertPanel finalFrame].size.height+ 18.0)];
			[alertPanel alertDisplay]
			[self setFrameSize:[alertPanel finalFrame].size];
			break;
			
		case "insertItem":
			var alertPanel = [[RoAAlertPanel alloc] initWithFrame:theFrame topTipHeight:0.0 bottomTipHeight:14.0 halfTipBasis:5.0 tipPositionX:theWidth/10];
			[alertPanel setFrameOrigin:CGPointMake(0.0, 0.0)];
			[alertPanel setFrameSize:CGSizeMake(300.0, 300.0)];
			[alertPanel initialize];
			[alertPanel setHidden:NO];
			[alertPanel setController:self];
			var alertButtons = [CPDictionary dictionaryWithObjectsAndKeys:
				["cancel", "", "Annulla", "right", -180], @"cancel",
				["confirm", "", "OK - ", "right", -90], @"confirm"
			];
			[alertPanel addMessageBoxWithHeight:20];
			[alertPanel setMessageText:"Prego specificare il nome della lista da creare"];
			[alertPanel addInputBox];
			[alertPanel setInputPlaceholderString:"Nome Lista"];
			[alertPanel setConfirmButtonText:"Crea Lista"];
			[alertPanel addButtons:alertButtons orientation:"horizontal"];
			[alertPanel setBackgroundColor:KKRoABackgroundWhite];
			[alertPanel addBackgroundView];
			[alertPanel setFrameOrigin:CGPointMake(12.0, [contentView frame].size.height-KKRoAY2-[alertPanel finalFrame].size.height+ 14.0)];
			[alertPanel alertDisplay]
			[self setFrameSize:[alertPanel finalFrame].size];
			break;
						
		case "insertChildItem":
			var alertPanel = [[RoAAlertPanel alloc] initWithFrame:theFrame topTipHeight:0.0 bottomTipHeight:14.0 halfTipBasis:5.0 tipPositionX:theWidth/8];
			[alertPanel setFrameOrigin:CGPointMake(0.0, 0.0)];
			[alertPanel setFrameSize:CGSizeMake(300.0, 300.0)];
			[alertPanel initialize];
			[alertPanel setHidden:NO];
			[alertPanel setController:self];
			var alertButtons = [CPDictionary dictionaryWithObjectsAndKeys:
				["cancel", "", "Annulla", "right", -180], @"cancel",
				["confirm", "", "OK - ", "right", -90], @"confirm"
			];
			[alertPanel addMessageBoxWithHeight:20];
			[alertPanel setMessageText:"Prego specificare il nome della lista da creare"];
			[alertPanel addInputBox];
			[alertPanel setInputPlaceholderString:"Nome Lista"];
			[alertPanel setConfirmButtonText:"Crea Lista"];
			[alertPanel addButtons:alertButtons orientation:"horizontal"];
			[alertPanel setBackgroundColor:KKRoABackgroundWhite];
			[alertPanel addBackgroundView];
			[alertPanel setFrameOrigin:CGPointMake(42.0, [contentView frame].size.height-KKRoAY2-[alertPanel finalFrame].size.height+ 14.0)];
			[alertPanel alertDisplay]
			[self setFrameSize:[alertPanel finalFrame].size];
			break;
			
		case "deleteItem":
			var alertPanel = [[RoAAlertPanel alloc] initWithFrame:theFrame topTipHeight:0.0 bottomTipHeight:14.0 halfTipBasis:5.0 tipPositionX:theWidth/8];
			[alertPanel setFrameOrigin:CGPointMake(0.0, 0.0)];
			[alertPanel setFrameSize:CGSizeMake(320.0, 300.0)];
			[alertPanel initialize];
			[alertPanel setHidden:NO];
			[alertPanel setController:self];
			var alertButtons = [CPDictionary dictionaryWithObjectsAndKeys:
				["cancel", "", "Annulla", "right", -180], @"cancel",
				["confirm", "", "OK - ", "right", -90], @"confirm"
			];
			[alertPanel addMessageBoxWithHeight:20];
			[alertPanel setMessageText:"Prego confermare eliminazione della lista"];
			[alertPanel setConfirmButtonText:"Elimina"];
			[alertPanel addButtons:alertButtons orientation:"horizontal"];
			[alertPanel setBackgroundColor:KKRoABackgroundWhite];
			[alertPanel addBackgroundView];
			[alertPanel setFrameOrigin:CGPointMake(72.0, [contentView frame].size.height-KKRoAY2-[alertPanel finalFrame].size.height+ 14.0)];
			[alertPanel alertDisplay]
			[self setFrameSize:[alertPanel finalFrame].size];
			break;
			
		case "editItem":
			var alertPanel = [[RoAAlertPanel alloc] initWithFrame:theFrame topTipHeight:0.0 bottomTipHeight:14.0 halfTipBasis:5.0 tipPositionX:theWidth/8];
			[alertPanel setFrameOrigin:CGPointMake(0.0, 0.0)];
			[alertPanel setFrameSize:CGSizeMake(320.0, 300.0)];
			[alertPanel initialize];
			[alertPanel setHidden:NO];
			[alertPanel setController:self];
			var alertButtons = [CPDictionary dictionaryWithObjectsAndKeys:
				["cancel", "", "Annulla", "right", -180], @"cancel",
				["confirm", "", "OK - ", "right", -90], @"confirm"
			];
			[alertPanel addMessageBoxWithHeight:20];
			[alertPanel setMessageText:"Prego specificare il nuovo nome della lista"];
			[alertPanel addInputBox];
			[alertPanel setInputPlaceholderString:"Nuovo Nome Lista"];
			[alertPanel setConfirmButtonText:"Rinomina"];
			[alertPanel addButtons:alertButtons orientation:"horizontal"];
			[alertPanel setBackgroundColor:KKRoABackgroundWhite];
			[alertPanel addBackgroundView];
			[alertPanel setFrameOrigin:CGPointMake(102.0, [contentView frame].size.height-KKRoAY2-[alertPanel finalFrame].size.height+ 14.0)];
			[alertPanel alertDisplay]
			[self setFrameSize:[alertPanel finalFrame].size];
			break;
		
		
		default:
			break;
	}
}


-(void)display
{
}


-(void)buttonSelection:(CPSender)aSender
{
	//alert("in buttonselection di 0302view");
	var inputBoxString = [[alertPanel inputBox] stringValue];
	
	if ([aSender tag] != "confirm")
	{
		var inputBoxString = "";
	}
	
	[alertPanel setHidden:YES];
	[crm03Controller responseFromButton:aSender withInputString:inputBoxString];
}


-(void)hideView
{
	[alertPanel setHidden:YES];
}


-(void)setHidden:(BOOL)shouldBeHidden
{
	[alertPanel setHidden:shouldBeHidden];
}

@end
