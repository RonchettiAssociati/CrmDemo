// -----------------------------------------------------------------------------
//  Crm0102View.j
//  RoACrm
//
// 	Created by Bruno Ronchetti on May 17, 2010.
// 	Copyright 2010, Ronchetti & Associati All rights reserved.
// -----------------------------------------------------------------------------


@import <Foundation/CPObject.j>

@implementation Crm0102View : CPView
{
	CPTextField		id 	memberName		@accessors;
	CrmButton		id 	loginButton;
}

-(void)initWithFrame:(CGRect)aFrame
{
	self = [super initWithFrame:aFrame];
	if (self)
	{
		return self; 
	}
}


-(void)initialize
{
	var outlineWidth = KKRoAX1-10;
	var ribbonHeight = KKRoAY1;
	
	var theHeight 	= [self frame].size.height;
	var theWidth	= [self frame].size.width;
	theHeight = theHeight / 2;
	
	
	// SET-UP LABELS
	//
	var ribbonView = [[RoARoundedCornerView alloc] initWithFrame:CGRectMake(0.0, 0.0, outlineWidth,KKRoAY1)];
	[ribbonView	setBackgroundColor:KKRoALightGray];
	[self addSubview:ribbonView];

	
	// SET-UP LABELS
	//		
	var inputPanelHeight = 200.0;
	var inputPanel = [[CPView alloc] initWithFrame:CGRectMake(0,KKRoAY1,outlineWidth,inputPanelHeight)];
	[inputPanel setBackgroundColor:KKRoABackgroundWhite];
	[self addSubview:inputPanel];
	
	var firstLabel = [[CPTextField alloc] initWithFrame:CGRectMake(8.0 ,2.0 ,outlineWidth-10.0, 15.0)];
    [firstLabel setStringValue:RoALocalized(@"Grazie!")];
    [firstLabel setFont:[CPFont boldSystemFontOfSize:14.0]];
	[firstLabel setTextColor:KKRoADarkGray];
    [firstLabel sizeToFit];
	[inputPanel addSubview:firstLabel];
	
		
	var secondLabel = [[CPTextField alloc] initWithFrame:CGRectMake(8.0 ,25.0 ,outlineWidth-10.0, 90.0)];
	[secondLabel setStringValue:RoALocalized("Siete usciti correttamente dal sistema.\n\nPotete chiudere la finestra del browser o fare click qui sotto per rientrare.")];
	[secondLabel setEnabled:NO];
	[secondLabel setLineBreakMode:CPLineBreakByCharWrapping];
	[secondLabel setFont:KKRoALabelFont];
	[secondLabel setTextColor:KKRoALabelColor];
	[inputPanel addSubview:secondLabel];
	
	// SET-UP FIELDS AND BUTTONS
	//
	
	var backToLoginButton = [[CrmButton alloc] initWithFrame:CGRectMake(8, 170.0, 80.0, 24.0)];
	[backToLoginButton setTag:"backToLoginButton"];
	[backToLoginButton setAutoresizingMask:CPViewMinYMargin | CPViewMinXMargin];
	[backToLoginButton setTitle:RoALocalized(@"al Log In")];
	[backToLoginButton setEnabled:YES];
	[backToLoginButton setTarget:crm01Controller];
	[backToLoginButton setAction:"backToLogin:"];
	
 	[inputPanel addSubview:backToLoginButton];
	
}

-(void)display
{
	[contentView addSubview:self];
	[[self window] makeFirstResponder:memberName];
}


@end





