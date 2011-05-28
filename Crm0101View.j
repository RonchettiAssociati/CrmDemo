// -----------------------------------------------------------------------------
//  Crm0101View.j
//  RoACrm01
//
// 	Created by Bruno Ronchetti on May 13, 2010.
// 	Copyright 2010, Ronchetti & Associati All rights reserved.
// -----------------------------------------------------------------------------


@import <Foundation/CPObject.j>


@implementation Crm0101View : CPView
{
	CPTextField		id 	memberName		@accessors;
	CPTextField		id 	password		@accessors;
	CPTextField		id 	loginOutcome;
	
	CPButton		id 	loginButton;
	CPImageView		id	spinnerView;
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

	
	var ribbonView = [[RoARoundedCornerView alloc] initWithFrame:CGRectMake(0.0, 0.0, outlineWidth,KKRoAY1)];
	[ribbonView	setBackgroundColor:KKRoALightGray];
	[self addSubview:ribbonView];

	var sectionTitle = [[CPTextField alloc] initWithFrame:CGRectMake(6.0 ,5.0 ,outlineWidth,30.0)];
	[sectionTitle setStringValue:"Credenziali"];
	[sectionTitle setEnabled:NO];
	[sectionTitle setFont:[CPFont boldSystemFontOfSize:16]];
	[sectionTitle setTextColor:KKRoAHighlightBlue];
	[ribbonView addSubview:sectionTitle];
	
	//var anchorView = [[CPView alloc] initWithFrame:CGRectMake(0.0, 0.0, 1.0, 1.0)];
	//[anchorView setBackgroundColor:[CPColor clearColor]];
	//[self addSubview:anchorView];

	
	// SET-UP LABELS
	//		
	var inputPanelHeight = 200.0;
	var inputPanel = [[CPView alloc] initWithFrame:CGRectMake(0,KKRoAY1,outlineWidth,inputPanelHeight)];
	[inputPanel setBackgroundColor:KKRoABackgroundWhite];
	[self addSubview:inputPanel];  // positioned:CPWindowBelow relativeTo:anchorView];
	
	var invitation = [[CPTextField alloc] initWithFrame:CGRectMake(8.0 ,2.0 ,outlineWidth-10.0, 15.0)];
    [invitation setStringValue:RoALocalized(@"Benvenuto!")];
    [invitation setFont:[CPFont boldSystemFontOfSize:14.0]];
	[invitation setTextColor:KKRoADarkGray];
    [invitation sizeToFit];
	[inputPanel addSubview:invitation];

		
	var memberLabel = [[CPTextField alloc] initWithFrame:CGRectMake(8.0 ,25.0 ,outlineWidth-10.0, 30.0)];
	[memberLabel setStringValue:RoALocalized("Prego fornisca i suoi identificativi\nNome Utente")];
	[memberLabel setEnabled:NO];
	[memberLabel setLineBreakMode:CPLineBreakByCharWrapping];
	[memberLabel setFont:KKRoALabelFont];
	[memberLabel setTextColor:KKRoALabelColor];
	[inputPanel addSubview:memberLabel]; // positioned:CPWindowBelow relativeTo:anchorView];
	
	// SET-UP FIELDS AND BUTTONS
	//

	var passwordLabel = [[CPTextField alloc] initWithFrame:CGRectMake(8.0 , 82.0, outlineWidth-10.0, 30.0)];
	[passwordLabel setStringValue:"Password"];
	[passwordLabel setEnabled:NO];
	[passwordLabel setLineBreakMode:CPLineBreakByCharWrapping];
	[passwordLabel setFont:KKRoALabelFont];
	[passwordLabel setTextColor:KKRoALabelColor];
	[inputPanel addSubview:passwordLabel]; // positioned:CPWindowBelow relativeTo:anchorView];
	
	var memberName = [[CPTextField alloc] initWithFrame:CGRectMake(6.5, 51.0, KKRoAX1-30.0, 30.0)];
	[memberName setTag:"memberName"];
	[memberName setAutoresizingMask:CPViewMinYMargin | CPViewMinXMargin];
	[memberName setPlaceholderString:RoALocalized(@"Nome Utente")];
	[memberName setBordered:YES];
	[memberName setBezeled:YES];
	[memberName setEditable:YES];
	[inputPanel addSubview:memberName];
		
	var password = [[CPSecureTextField alloc] initWithFrame:CGRectMake(6.5, 94.0, KKRoAX1-30.0, 30.0)];
	[password setTag:"password"];
	[password setAutoresizingMask:CPViewMinYMargin | CPViewMinXMargin];
	[password setPlaceholderString:RoALocalized(@"Password")];
	[password setBordered:YES];
	[password setBezeled:YES];
	[password setEditable:YES];
	[password setDelegate:self];
	[inputPanel addSubview:password];

	
	var loginButton = [[CrmButton alloc] initWithFrame:CGRectMake(8, 170.0, 80.0, 24.0)];
	[loginButton setTag:"loginButton"];
	[loginButton setAutoresizingMask:CPViewMinYMargin | CPViewMinXMargin];
	[loginButton setTitle:RoALocalized("Log In")];
	[loginButton setEnabled:NO];
	[loginButton setTarget:self];
	[loginButton setAction:"login:"];
 	[inputPanel addSubview:loginButton];
	
	var loginOutcome = [[CPTextField alloc] initWithFrame:CGRectMake(8, 124.0, outlineWidth-10.0, 48.0)];
	[loginOutcome setLineBreakMode:CPLineBreakByCharWrapping];
    [loginOutcome setAutoresizingMask:CPViewMinYMargin | CPViewMinXMargin];
    [loginOutcome setFont:[CPFont systemFontOfSize:10.0]];
	[loginOutcome setHidden:YES];
	[inputPanel addSubview:loginOutcome];

	
}

-(void)display
{
	[memberName setStringValue:""];
	[password setStringValue:""];
	[loginOutcome setStringValue:""];
	
	// Configure the responder chain so that the user can tab 
	// between fields in the right order
	/*
    [[self window] setAutorecalculatesKeyViewLoop:NO];
	[self setNextKeyView:memberName];
	[memberName setNextKeyView:password];
	[password setNextKeyView:loginButton];
	[loginButton setNextKeyView:memberName];
	*/
	
	[contentView addSubview:self];	
	[[self window] makeKeyAndOrderFront:null]; 
	[[self window] makeFirstResponder:memberName];
}

-(void)login:(CPSender)aSender
{
	[[self window] setDefaultButton:null];
	[crm01Controller login:aSender];
}

- (BOOL)acceptsFirstResponder 
{ 
    return YES; 
} 

- (void)keyDown:(CPEvent)anEvent 
{ 
	if ([anEvent keyCode] == "13")
	{
		[loginButton performClick:anEvent];
	}
} 

-(void)controlTextDidEndEditing:(CPNotification)aNotification
{	
	if ([[aNotification object] tag] == "password")
	{
		[loginButton setEnabled:YES];
		[[self window] setDefaultButton:loginButton];
    	[[self window] makeFirstResponder:self]; 
	}
}

-(void)validLogin:(CPString)aUserName
{	
	// FIXME qui bisognerebbe lock i due campi di input
	[loginOutcome setStringValue:RoALocalized(@"Bentornato ")+ aUserName +RoALocalized(@". La stiamo collegando al database.")];
	[loginOutcome setTextColor:KKRoAMediumBlue];
	[loginOutcome sizeToFit];
	[loginOutcome setHidden:NO];
}


-(void)invalidLogin
{
	[loginOutcome setStringValue:RoALocalized(@"Gli identificativi forniti non \ncorrispondono a quelli in archivio. \nPrego riprovi.")];
	[loginOutcome setTextColor:[CPColor redColor]];
	[loginOutcome sizeToFit];
	[loginOutcome setHidden:NO];
}

-(void)incompleteLogin
{
	[loginOutcome setStringValue:RoALocalized(@"Prego fornisca i suoi identificativi di accesso completi.")];
	[loginOutcome setTextColor:[CPColor redColor]];
	[loginOutcome sizeToFit];
}

@end





