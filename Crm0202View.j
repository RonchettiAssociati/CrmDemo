// -----------------------------------------------------------------------------
//  Crm0202View.j
//  RoACrm01
//
// 	Created by Bruno Ronchetti on November 25, 2010.
// 	Copyright 2010, Ronchetti & Associati All rights reserved.
// -----------------------------------------------------------------------------


@import <Foundation/CPObject.j>
@import <RoAKit/RoAAlertPanel.j>



@implementation Crm0202View : CPView
{
	CPNumber	id 	theWidth;
	CPButton	id 	printButton;
	CPArray		id	buttons;
	RoAAlertPanel	id	alertPanel;
	CPShadowView	id shadowView;
}

-(void)initWithFrame:(CGRect)aFrame
{
	self = [super initWithFrame:aFrame];
	if (self)
	{
		var theFrame = aFrame;
		var theWidth = theFrame.size.width;
		var theHeight = theFrame.size.height;
		var theOriginX = theFrame.origin.x;
		var theOriginY = theFrame.origin.y;
						
		var alertPanel = [[RoAAlertPanel alloc] initWithFrame:theFrame topTipHeight:10.0 bottomTipHeight:0.0 halfTipBasis:10.0 tipPositionX:theWidth/2];
 		[alertPanel setAutoresizingMask:CPViewMinXMargin];

		return self; 
	}
}


-(void)initialize
{
	
}



-(void)tailorForUser
{

}


-(void)userButtondisplay
{
	[alertPanel initialize];
	[alertPanel setHidden:NO];
	[alertPanel setController:self];
	[alertPanel setBackgroundColor:KKRoABackgroundWhite];
	var alertButtons = [CPDictionary dictionaryWithDictionary:KKRoAUserButtons];
	[alertPanel addButtons:alertButtons orientation:"vertical" ordering:["print", "preferences", "separator" , "help", "logout"]];
	[alertPanel addBackgroundView];
	[alertPanel alertDisplay];
	[self setFrameSize:[alertPanel finalFrame].size];
	
	if (KKRoARequestPrint == true)
	{
		[alertPanel printButtonShowImage:YES];
	}
	else
	{
		[alertPanel printButtonShowImage:NO];
	}
}


-(void)display
{
}

-(void)buttonSelection:(CPSender)aSender
{
	//alert("in didselectItem "+[aSender tag]);
	[alertPanel setHidden:YES];
	[crm02Controller userButtonSelection:aSender];
}


-(void)togglePrintButton
{	
	if (KKRoARequestPrint == false)
	{
		//[contentView setBackgroundColor:[CPColor redColor]];
	}
	else
	{
		//[contentView setBackgroundColor:KKRoAContentViewBackground];
	}
}


-(void)setHidden:(BOOL)shouldBeHidden
{
	[alertPanel setHidden:shouldBeHidden];
}



@end
