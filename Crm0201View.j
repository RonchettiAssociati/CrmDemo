// -----------------------------------------------------------------------------
//  Crm0201View.j
//  RoACrm01
//
// 	Created by Bruno Ronchetti on May 13, 2010.
// 	Copyright 2010, Ronchetti & Associati All rights reserved.
// -----------------------------------------------------------------------------


@import <Foundation/CPObject.j>
//@import <RoAKit/RoAGlobalDataTableView.j>



@implementation Crm0201View : CPView
{
	CPArray id buttonIdentifiers;
	CPArray	id buttons				@accessors;
	CPBox	id printButtonBox;
	
	CPSize	id	menuButtonSize;
	CPSize	id	buttonFrameSize;
	
	CPTextField	id 	appName;
	CPImageView id 	logo;
	CPView		id	buttonBar;
	CPView		id	buttonFrame;
	CPSearchField id searchField;
	CPButton	id	printButton;
	CPButton	id	userButton;
	
	CPString	id	savedSearchValue;
}

-(void)initWithFrame:(CGRect)aFrame
{
	self = [super initWithFrame:aFrame];
	if (self)
	{
		[[CPNotificationCenter defaultCenter] addObserver:self  selector:@selector(didResizeView)  name:"CPViewFrameDidChangeNotification" object:null];
		return self; 
	}
}

-(void)initialize
{
// GEOMETRY
//
	var theHeight 	= [self frame].size.height;
	var theWidth	= [self frame].size.width;

	//var menuButtonSize 	= CGSizeMake(52.0, KKRoAY0-18.0);
	//var buttonFrameSize = CGSizeMake(57.5, KKRoAY0-6.5);

	var menuButtonSize 	= CGSizeMake(60.0, KKRoAY0);
	var buttonFrameSize = CGSizeMake(68.0, KKRoAY0);
	
	var verticalCenter = KKRoAY0/2;

		
	// SET-UP TOOLBAR
	//
	
	var savedSearchValue = "";

	// buttons will be tailored in tailorForUser
	//
	
   	var appName = [[CPTextField alloc] initWithFrame:CGRectMake(30.0, 6.0 , 500.0, 50.0)];
    [appName setAutoresizingMask:CPViewMinYMargin | CPViewMaxXMargin];
    [appName setStringValue:RoALocalized(@"Database dei Contatti")];
    [appName setFont:[CPFont boldSystemFontOfSize:32.0]];
	[appName setTextColor:KKRoAMainTitleColor];
    //[appName sizeToFit];
	[self addSubview:appName];
	
	var buttonBar = [[CPView alloc] initWithFrame:CGRectMakeZero()];
	[buttonBar setCenter:[self center]];
	[self addSubview:buttonBar];

	var searchField = [[CPSearchField alloc] initWithFrame:CGRectMake( 9.5, 10.0, 150.0, 30.0)];
	[searchField setCenter:CGPointMake([searchField center].x, verticalCenter)];
    [searchField setAutoresizingMask:CPViewMaxXMargin];
	[searchField setSendsWholeSearchString:YES];
	[searchField setPlaceholderString:RoALocalized(@"Ricerca Globale")];
	[searchField setTarget:self];
	[searchField setAction:@selector(globalSearch:)];
	[searchField setMaximumRecents:10];
	//[searchField setFont:[CPFont systemFontOfSize:11.0]];
	[searchField setRecentsAutosaveName:"globalSearchList"];
	//[searchField setTheme:null];
	//[searchField setTextColor:[CPColor whiteColor]];
	// NOTE: the searchField will be added in -tailorForUser
	//[self addSubview:searchField];    
	
	var searchMenu = [searchField defaultSearchMenuTemplate];
	[searchMenu insertItemWithTitle:"select" action:"menuSelection" keyEquivalent:nil atIndex:0];
	[searchField setSearchMenuTemplate:searchMenu];

	var userButton = [[CrmUserButton alloc] initWithFrame:CGRectMake(theWidth-180.0, 13.0, 170.0, 24.0)];
	//[userButton setFrameOrigin:CGPointMake(theWidth-120.5, 13.5)];
	//[userButton setFrameSize:CGSizeMake(110.0, 24.0)];
	[userButton setCenter:CGPointMake([userButton center].x, verticalCenter)];
	[userButton setTag:"userButton"];
	[userButton setAutoresizingMask:CPViewMinXMargin];
	[userButton setTextShadowColor:[CPColor clearColor]];
	[userButton setValue:KKRoAToolbarBackground forThemeAttribute:@"bezel-color" inState:CPThemeStateNormal];
	[userButton setTextColor:[CPColor whiteColor]];
	[userButton setFont:[CPFont systemFontOfSize:11.0]];
	//[userButton sizeToFit];
	[userButton setEnabled:YES];
	[userButton setTarget:crm02Controller];
	[userButton setAction:"userButtonActions:"];
	// NOTE: the userButton will be added in -tailorForUser
	//[self addSubview:userButton];
}

-(void)didResizeView
{
	//alert("in didresizeview");
	[buttonBar setCenter:[self center]];
}

-(void)tailorForUser
{
	[appName removeFromSuperview];
	[self addSubview:buttonBar];
	[self addSubview:searchField];
	[self addSubview:userButton];
	
	[logo setImage:KKRoALogo];
	[logo setImageScaling:CPScaleToFit];
	
	[userButton setTitle:KKRoAUserDomain+ " - "+KKRoAUserExternalName];

	var buttonIdentifiers = [KKRoAMenuButtons allKeys];
	var numberOfButtons = [buttonIdentifiers count];
	[buttonBar setFrameSize:CGSizeMake(8.0 + numberOfButtons*(menuButtonSize.width+0.0) , KKRoAY0)];
	[buttonBar setCenter:[self center]];
	
	var buttonFrame = [[CPImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 57.5, KKRoAY0)];
	var buttonFrameImage = [[CPImage alloc] initWithContentsOfFile:"Resources/menuTab.png" size:CGRectMake(0.0, 0.0, 57.5, KKRoAY0)];
	[buttonFrame setImage:buttonFrameImage];
	[buttonFrame setImageScaling:CPScaleToFit];
	
	//CPScaleProportionally   = 0;
	//CPScaleToFit;            = 1;
	//CPScaleNone             = 2;

	//[buttonFrame setCenter:CGPointMake(100, KKRoAY0/2-10)];
	[buttonFrame setBackgroundColor:[CPColor clearColor]];
	//[buttonFrame setFillColor:[CPColor whiteColor]];
	//[buttonFrame setBorderType:CPLineBorder];
	//[buttonFrame setBorderWidth:3.0];
	//[buttonFrame setBorderColor:KKRoAVeryVeryLightGray];
	//[buttonFrame setBorderColor:[CPColor clearColor]];

	//[buttonFrame setCornerRadius:4.0];
	//[buttonBar addSubview:buttonFrame];
	

	var buttons = [];

	for (var i=0; i<[buttonIdentifiers count]; i++)
	{
		var buttonInfo = [KKRoAMenuButtons objectForKey:buttonIdentifiers[i]];
				
		var menuButton = [[CrmMenuButton alloc] initWithFrame:CGRectMakeZero()];
		[menuButton setFrameSize:menuButtonSize];
		[menuButton setFrameOrigin:CGPointMake(4.0 + i* (menuButtonSize.width+ 0.0) , 5.0)];
		[menuButton setTag:buttonInfo[1]]; 
		[menuButton setImageFile:buttonInfo[4]];
		[menuButton setTarget:self];
		[menuButton setAction: @selector(didSelectItem:)]; 
		[menuButton setTitle: buttonInfo[2]];
		[menuButton setEnabled:YES];
		[buttons addObject:menuButton];
		[buttonBar addSubview:menuButton];
	}	
}

-(void)revertToInitialDisplay
{
	[self addSubview:appName];
	[buttonBar removeFromSuperview];
	[searchField removeFromSuperview];
	[userButton removeFromSuperview];
}



-(void)display
{
	[contentView addSubview:self];
}


-(void)globalSearch:(CPSearchField)aSearchField
{
	if ([searchField stringValue] != savedSearchValue)
	{
		[crm02Controller globalSearch:aSearchField];
		var savedSearchValue = [searchField stringValue];
	}
}

-(void)didSelectItem:(CPSender)aSender
{
	[buttons makeObjectsPerformSelector:"unselectSelf"];
	[aSender setSelectedItem];
	//[buttonFrame setCenter:CGPointMake([aSender center].x, [aSender center].y-4.0)];
	[crm02Controller menuSelection:[aSender tag]];
}

-(void)updateUserData
{
	[userButton setTitle:KKRoAUserDomain+ " - "+KKRoAUserExternalName];
}

@end
