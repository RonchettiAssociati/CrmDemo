// -----------------------------------------------------------------------------
//  Crm0701View.j
//  RoACrm01
//
// 	Created by Bruno Ronchetti on May 13, 2010.
// 	Copyright 2010, Ronchetti & Associati All rights reserved.
// -----------------------------------------------------------------------------


@import <Foundation/CPObject.j>
@import <RoAKit/RoASimpleViewAnimation.j>

@implementation Crm0701View : CPView
{
	BOOL	id	isViewOpen;
	CPView	id	border;
	
	CPArray	id 	buttons;	
}

-(void)initWithFrame:(CGRect)aFrame
{
	self = [super initWithFrame:aFrame];
	if (self)
	{
		crm0701View = self;
		[self setBackgroundColor:KKRoABackgroundWhite];
		return self; 
	}
}

-(void)initialize
{
// GEOMETRY
//
	var theHeight 	= [self frame].size.height;
	var theWidth	= [self frame].size.width;	
	
	var borderHeight = 2.0;
	
	var buttonBar =[[CPView alloc] initWithFrame:CGRectMake(0.0, borderHeight,	theWidth, KKRoAY2 )];
	[buttonBar setAutoresizingMask:CPViewWidthSizable | CPViewMinYMargin];
	[buttonBar setBackgroundColor:KKRoABottombarBackground];
	[self addSubview:buttonBar];
	
	var buttons = [];

	var closeButton = [[CPButton alloc] initWithFrame:CGRectMake(10.0, borderHeight, 50.0, 29.0)];
	[closeButton setTag:"close"];
	[closeButton setAutoresizingMask:CPViewMaxXMargin];
	[closeButton setTheme:nil];
	[closeButton setTitle:RoALocalized(@"chiudi")];
	[closeButton setImageDimsWhenDisabled:YES];
	[closeButton setTarget:self];
	[closeButton setAction:@selector(buttonSelection:)]
	[closeButton setFont:[CPFont boldSystemFontOfSize:12]];
	[closeButton setEnabled:NO];
	[closeButton setValue:KKRoAMediumLightGray forThemeAttribute:@"text-color" inState:CPThemeStateDisabled];
	[closeButton setValue:KKRoAMediumBlue forThemeAttribute:@"text-color" inState:CPThemeStateNormal];
	[closeButton setValue:KKRoAHighlightBlue forThemeAttribute:@"text-color" inState:CPThemeStateHighlighted];
	[buttons addObject:closeButton];
	[self addSubview:closeButton];

		
	var itemDetailButtons = [CPDictionary dictionaryWithObjectsAndKeys:
	["showContacts", "Contatti", "right", -90], @"contacts",
	["showPersons", "Persone", "right",-180], @"persons",
	["showProjects", "Progetti", "right",-270], @"projects",
	["showAttachments", "Allegati", "right",-360], @"attachments"
	];

	var buttonIdentifiers = [itemDetailButtons allKeys];

	for (var i=0; i<[buttonIdentifiers count]; i++) {
		var buttonInfo = [itemDetailButtons objectForKey:buttonIdentifiers[i]];
		
		var theCurrentButton = [[CrmButton alloc] initWithFrame:CGRectMake(0.0 ,0.0 ,80.0 ,24.0)];
		[theCurrentButton setBezelStyle:CPRegularSquareBezelStyle];
		if (buttonInfo[2] == "left") {
			[theCurrentButton setFrameOrigin:CGPointMake(buttonInfo[3], 3.0+ borderHeight)];
			[theCurrentButton setAutoresizingMask:CPViewMaxXMargin];
		}
		else {
			[theCurrentButton setFrameOrigin:CGPointMake(theWidth+ buttonInfo[3], 3.0+ borderHeight)];
			[theCurrentButton setAutoresizingMask:CPViewMinXMargin];
		}
		[theCurrentButton setTag:buttonInfo[0]];
		[theCurrentButton setTitle:buttonInfo[1]];
		[theCurrentButton setTarget:self];
		[theCurrentButton setAction:@selector(buttonSelection:)];
		
		[buttons addObject:theCurrentButton];
		[self addSubview:theCurrentButton];
		
		var border = [[CPView alloc] initWithFrame:CGRectMake(0.0, 0.0, theWidth, borderHeight)];
		//[border setBackgroundColor:[CPColor redColor]];
		[border setBackgroundColor:KKRoAContentViewBackground];
		[border setAutoresizingMask:CPViewWidthSizable];
		//[border setHidden:YES];
		[self addSubview:border];
	}
}


-(void)display
{
	[contentView addSubview:self positioned:CPWindowBelow relativeTo:[crm02Controller crm0203View]];
	isViewOpen = false;
}


-(void)buttonSelection:(CPSender)aSender
{
	//alert("mandato "+[aSender tag]);
	switch ([aSender tag])
	{
		case "showContacts":
		case "showProjects":
		case "showAttachments":
		case "showPersons":
			if (isViewOpen == false) 
			{
				//alert("mi accingo ad aprire");
				var openingAnimation = [[RoASimpleViewAnimation alloc] initWithView:self horizontalDisplacement:0 verticalDisplacement:-(KKRoAY4-KKRoAY2)];
				[self setBackgroundColor:KKRoABackgroundWhite];
				[openingAnimation startAnimation];
				isViewOpen = true;	
			}
			break;	

	
		case "close":
			if (isViewOpen == true)
			{
				//alert("mi accingo a chiudere");
				var closingAnimation = [[RoASimpleViewAnimation alloc] initWithView:self horizontalDisplacement:0 verticalDisplacement:+(KKRoAY4-KKRoAY2)];
				[closingAnimation setDelegate:self];
				[closingAnimation startAnimation];
				isViewOpen = false;
			}
			break;
	}
	
	[crm07Controller didSelectButton:aSender];
}

/*
-(void)enableButtons:(CPArray)buttonsToEnable
{
	for (var i=0; i<[buttons count]; i++)
	{
		[buttons[i] setEnabled:NO];
	}	
	
	for (var j=0; j<[buttonsToEnable count]; j++)
	{
		[buttons[buttonsToEnable[j]] setEnabled:YES];
	}
}
*/

-(void)disableButtonWithTag:(CPString)buttonToDisable
{
	for (var i=0; i<[buttons count]; i++)
	{
		if ([buttons[i] tag] ==  buttonToDisable)
		{
			[buttons[i] setEnabled:NO];
		}
	}
}

-(void)enableButtonWithTag:(CPString)buttonToEnable
{
	for (var i=0; i<[buttons count]; i++)
	{
		if ([buttons[i] tag] ==  buttonToEnable)
		{
			[buttons[i] setEnabled:YES];
		}
	}
}

-(void)enableButtonsWithTags:(CPArray)buttonsToEnable
{
	for (var i=0; i<[buttons count]; i++)
	{
		if ( [buttonsToEnable containsObject:[buttons[i] tag]] )
		{
			[buttons[i] setEnabled:YES];
		}
		else
		{
			[buttons[i] setEnabled:NO];
		}
	}	
}



-(void)animationDidEnd:(CPAnimation)anAnimation
{
	//alert("animationdidend");
	[self setBackgroundColor:[CPColor clearColor]];
	[crm07Controller animationDidEnd];
}
@end