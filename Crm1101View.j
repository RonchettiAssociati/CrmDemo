// -----------------------------------------------------------------------------
//  Crm0601View.j
//  RoACrm01
//
// 	Created by Bruno Ronchetti on May 13, 2010.
// 	Copyright 2010, Ronchetti & Associati All rights reserved.
// -----------------------------------------------------------------------------


@import <Foundation/CPObject.j>
@import <RoAKit/RoAAlertPanel.j>


@implementation Crm1101View : CPView
{
	CPNumber	id	theContentWidth;
	CPNumber	id	theContentHeight;
	CPNumber	id	theFrameWidth;
	CPNumber	id	theFrameHeight;
	
	RoAAlertPanel	id	alertPanel;
	
	CPArray		id	theArray;
	CPTextField	id	caption;
	CPCollectionView	id crm1101CollectionView;
	
	CPArray	id	warningPanelButtons;
	CPArray	id	buttons;
	
	CrmButton	id	confirmButton;
	
	CGRect		id	theFrame;
}



-(void)initWithFrame:(CGRect)aFrame
{
	//alert("inizio init di crm1101View");
	
	self = [super initWithFrame:aFrame];
	if (self)
	{		
		var theFrame = aFrame;
		var theContentWidth = [contentView frame].size.width;
		var theContentHeight = [contentView frame].size.height;
		var theFrameWidth = theFrame.size.width;
		var theframeHeight = theFrame.size.height;
		
		return self;  
	}
}



-(void)initialize
{

}



-(void)tailorForCase:(CPString)aCase
{
	//alert("in crm1101view tailorfrocase "+aCase);
	
	[alertPanel initialize];
	[alertPanel setHidden:NO];
	[alertPanel setController:crm11Controller];
	
	switch (aCase)
	{
		case "simpleSaveConfirmation":
			var alertPanel = [[RoAAlertPanel alloc] initWithFrame:theFrame topTipHeight:10.0 bottomTipHeight:0.0 halfTipBasis:10.0 tipPositionX:theFrameWidth*6/7];
 			[alertPanel setAutoresizingMask:CPViewMinXMargin];		
			[alertPanel setFrameOrigin:CGPointMake(theContentWidth-225, KKRoAY0+KKRoAY1+ 10.0- 3.0)];
			[alertPanel initialize];
			[alertPanel setHidden:NO];
			[alertPanel setController:crm11Controller];
			var alertButtons = [CPDictionary dictionaryWithObjectsAndKeys:
				["cancel", "", "Annulla", "right", -180], @"cancel",
				["confirm", "", "OK - ", "right", -90], @"confirm"
			];
			[alertPanel addMessageBoxWithHeight:32];
			[alertPanel setMessageText:"Confermi di voler salvare il documento?"];
			[alertPanel setConfirmButtonText:"OK - Salva"];
			[alertPanel addButtons:alertButtons orientation:"vertical"];
			[alertPanel setBackgroundColor:KKRoABackgroundWhite];
			[alertPanel addBackgroundView];
			[alertPanel alertDisplay];
			[self setFrameSize:[alertPanel finalFrame].size];
			break;

		case "simpleDeleteConfirmation":
			var alertPanel = [[RoAAlertPanel alloc] initWithFrame:theFrame topTipHeight:10.0 bottomTipHeight:0.0 halfTipBasis:10.0 tipPositionX:theFrameWidth*6/7];
 			[alertPanel setAutoresizingMask:CPViewMinXMargin];	
			[alertPanel setFrameOrigin:CGPointMake(theContentWidth-315, KKRoAY0+KKRoAY1+ 10.0- 3.0)];
			[alertPanel initialize];
			[alertPanel setHidden:NO];
			[alertPanel setController:crm11Controller];
			var alertButtons = [CPDictionary dictionaryWithObjectsAndKeys:
				["cancel", "", "Annulla", "right", -180], @"cancel",
				["confirm", "", "OK - ", "right", -90], @"confirm"
			];
			[alertPanel addMessageBoxWithHeight:32];
			[alertPanel setMessageText:"Confermi di voler eliminare il documento?"];
			[alertPanel setConfirmButtonText:"OK - Elimina"];
			[alertPanel addButtons:alertButtons orientation:"vertical"];
			[alertPanel setBackgroundColor:KKRoABackgroundWhite];
			[alertPanel addBackgroundView];
			[alertPanel alertDisplay];
			[self setFrameSize:[alertPanel finalFrame].size];
			break;
						
		case "complexSaveConfirmation":
			var alertPanel = [[RoAAlertPanel alloc] initWithFrame:theFrame topTipHeight:10.0 bottomTipHeight:0.0 halfTipBasis:10.0 tipPositionX:theFrameWidth*6/7];
 			[alertPanel setAutoresizingMask:CPViewMinXMargin];	
			[alertPanel setFrameOrigin:CGPointMake(theContentWidth-225, KKRoAY0+KKRoAY1+ 10.0- 3.0)];
			[alertPanel initialize];
			[alertPanel setHidden:NO];
			[alertPanel setController:crm11Controller];
			[alertPanel addMessageBoxWithHeight:32];
			[alertPanel setMessageText:"In archivio esistono altre persone con cognomi simili"];
	
			[alertPanel addCollectionViewWithHeight:130.0 forData:[crm11Controller similarNames]];
			
			var alertButtons = [CPDictionary dictionaryWithObjectsAndKeys:
				["cancel", "", "Annulla", "right", -180], @"cancel",
				["confirm", "", "OK - ", "right", -90], @"confirm"
			];
			[alertPanel setConfirmButtonText:"OK - Salva comunque"];
			[alertPanel addButtons:alertButtons orientation:"vertical"];
			[alertPanel setBackgroundColor:KKRoABackgroundWhite];
			[alertPanel addBackgroundView];
			[alertPanel alertDisplay];
			[self setFrameSize:[alertPanel finalFrame].size];
			break;

		case "successfullWrite":
			var alertPanel = [[RoAAlertPanel alloc] initWithFrame:theFrame topTipHeight:10.0 bottomTipHeight:0.0 halfTipBasis:10.0 tipPositionX:theFrameWidth*6/7];
			[alertPanel setFrameOrigin:CGPointMake(theContentWidth- 225.0, KKRoAY0+KKRoAY1+ 10.0- 3.0)];
			[alertPanel initialize];
			[alertPanel setHidden:NO];
			[alertPanel setController:crm11Controller];
 			[alertPanel setAutoresizingMask:CPViewMinXMargin];	
			[alertPanel addMessageBoxWithHeight:18];
			[alertPanel setMessageText:"OK - Documento salvato"];
			[alertPanel setMessageFont:[CPFont boldSystemFontOfSize:12]];
			[alertPanel setBackgroundColor:KKRoABackgroundWhite];
			[alertPanel addBackgroundView];
			[alertPanel alertDisplay];
			[self setFrameSize:[alertPanel finalFrame].size];
			break;

		case "successfullDelete":
			var alertPanel = [[RoAAlertPanel alloc] initWithFrame:theFrame topTipHeight:10.0 bottomTipHeight:0.0 halfTipBasis:10.0 tipPositionX:theFrameWidth*6/7];
			[alertPanel setFrameOrigin:CGPointMake(theContentWidth- 315.0, KKRoAY0+KKRoAY1+ 10.0- 3.0)];
			[alertPanel initialize];
			[alertPanel setHidden:NO];
			[alertPanel setController:crm11Controller];
 			[alertPanel setAutoresizingMask:CPViewMinXMargin];	
			[alertPanel addMessageBoxWithHeight:18];
			[alertPanel setMessageText:"OK - Documento eliminato"];
			[alertPanel setMessageFont:[CPFont boldSystemFontOfSize:12]];
			[alertPanel setBackgroundColor:KKRoABackgroundWhite];
			[alertPanel addBackgroundView];
			[alertPanel alertDisplay];
			[self setFrameSize:[alertPanel finalFrame].size];
			break;
						
		case "writeError":
			var confirmButtonTitle = "Elimina";
			[self setFrameOrigin:CGPointMake(theContentWidth-  315.0, KKRoAY0+KKRoAY1+ 10.0- 3.0)];
			break;
						
		default:
			alert("in crm1101view case errato");
			break;
	}
}

-(void)hideView
{
	[self setHidden:YES];
}

-(void)setHidden:(BOOL)shouldBeHidden
{
	[[alertPanel shadowView] setHidden:shouldBeHidden];
	[alertPanel setHidden:shouldBeHidden];
}


-(void)display
{
}

-(void)resetView
{
}

-(void)clearView
{
}

@end



