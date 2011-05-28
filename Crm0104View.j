// -----------------------------------------------------------------------------
//  Crm0104View.j
//  RoACrm01
//
// 	Created by Bruno Ronchetti on May 17, 2010.
// 	Copyright 2010, Ronchetti & Associati All rights reserved.
// -----------------------------------------------------------------------------


@import <Foundation/CPObject.j>

@implementation Crm0104View : CPView
{
	RoAFormView	id	preferencesPanel;
	CPButton	id	savePreferencesButton;
	CPButton	id	quitPreferencesButton;
	CPString	id	savedSalt;
	CPString	id	savedSha;
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
// GEOMETRY
	//
	var panelWidth = KKRoAX1+ KKRoAX2 +160;
	//var panelHeight = theHeight-KKRoAY1-KKRoAY2;
	var panelHeight = 350;
	var ribbonHeight = KKRoAY1;
		
	var theHeight 	= [self frame].size.height;
	var theWidth	= [self frame].size.width;
	
	var buttonSize = CGSizeMake(34,34);
	
	var thePreferencesTemplate = [
		{type:"section", item:"Dati Personali"},
		{type:"field", item:"Nome", length:150, position:0, validation:["immediate", "required", "string"]},
		{type:"field", item:"Cognome", length:150, skip:YES, position:220, validation:["immediate", "required", "string"]},
		{type:"field", item:"domain", label:"Organizzazione", length:150, position:0, outputOnly:YES},
		{type:"field", item:"user_name", label:"Nome Utente", length:150, position:0, validation:["immediate", "required", "string"]},

		{type:"section", item:"Altre Preferenze"},
		{type:"field", item:"language", label:"Lingua", length:120, position:0, help:["list", "inline", ["italiano"], "single"], validation:["immediate", "optional", "string"]},
		{type:"field", item:"privileges", label:"Privilegi", length:120, position:0, outputOnly:YES},
		{type:"field", item:"similar_names", label:"Conferma Nomi Simili", position:0, length:120, outputOnly:YES},
						
		{type:"section", item:"Cambio Password"},
		{type:"field", item:"old_password", label:"Vecchia Password", length:120, position:0},
		{type:"field", item:"new_password", label:"Nuova Password", length:120, position:0},
		{type:"field", item:"confirm_password", label:"Conferma Nuova", skip:YES, position:220, length:120}

	];

	
	
	// SET-UP BACKGROUND
		
	var ribbonView = [[RoARoundedCornerView alloc] initWithFrame:CGRectMake(0.0, 0.0, panelWidth, KKRoAY1)];
	[ribbonView	setBackgroundColor:KKRoALightGray];
	[self addSubview:ribbonView];
	
	var panelTitle = [[CPTextField alloc] initWithFrame:CGRectMake(10.0 ,5.0 ,panelWidth,30.0)];
	[panelTitle setStringValue:RoALocalized(@"Preferenze di ")+KKRoAUserExternalName];
	[panelTitle setFont:[CPFont boldSystemFontOfSize:16]];
	[panelTitle setTextColor:KKRoAHighlightBlue];
	[ribbonView addSubview:panelTitle];
	
	var panelView = [[CPView alloc] initWithFrame:CGRectMake(0.0, KKRoAY1, panelWidth, panelHeight)];
	[panelView setAutoresizingMask:CPViewHeightSizable];
	[panelView setBackgroundColor:KKRoABackgroundWhite];
	[self addSubview:panelView];

	var savePreferencesButton = [[CrmButton alloc] initWithFrame:CGRectMakeZero()];
	[savePreferencesButton setFrameOrigin:CGPointMake(panelWidth - 190.0, 3.0)];
	[savePreferencesButton setTag:"savePreferencesButton"];
	[savePreferencesButton setAutoresizingMask:CPViewMinXMargin];
	[savePreferencesButton setTitle:RoALocalized(@"Salva")];
	[savePreferencesButton setEnabled:NO];
	[savePreferencesButton setTarget:crm01Controller];
	[savePreferencesButton setAction:"savePreferences:"];
 	[ribbonView addSubview:savePreferencesButton];
		
	var quitPreferencesButton = [[CrmButton alloc] initWithFrame:CGRectMakeZero()];
	[quitPreferencesButton setFrameOrigin:CGPointMake(panelWidth - 90.0, 3.0)];
	[quitPreferencesButton setTag:"quitPreferencesButton"];
	[quitPreferencesButton setAutoresizingMask:CPViewMinXMargin];
	[quitPreferencesButton setTitle:RoALocalized(@"Chiudi")];
	[quitPreferencesButton setEnabled:YES];
	[quitPreferencesButton setTarget:crm01Controller];
	[quitPreferencesButton setAction:"quitPreferences:"];
 	[ribbonView addSubview:quitPreferencesButton];
	
	var preferencesPanel = [[RoAFormView alloc] initWithFrame:CGRectMake(10.0, 15.0, theWidth-20.0, theHeight)];
	[preferencesPanel prepareForm:null withTemplate:thePreferencesTemplate];
	[panelView addSubview:preferencesPanel];
}

-(void)display:(CPObject)userData
{
	var savedSalt = userData["_id"];
	var	savedSha = userData["password_sha"];
	
	//alert([[preferencesPanel inputFieldsDictionary] allKeys]);
	
	[preferencesPanel setScreenValue:userData["Nome"]	forField:"Nome"];
	[preferencesPanel setScreenValue:userData["Cognome"]	forField:"Cognome"];
	[preferencesPanel setScreenValue:userData["domain"]	forField:"domain"];
	[preferencesPanel setScreenValue:userData["user_name"]	forField:"user_name"];
	[preferencesPanel setScreenValue:userData["language"]	forField:"language"];
	[preferencesPanel setScreenValue:userData["privileges"]	forField:"privileges"];
	[preferencesPanel setScreenValue:RoALocalized(userData["similar_names"])	forField:"similar_names"];
	
	[[preferencesPanel fieldForField:"new_password"] setSecure:YES];
	[[preferencesPanel fieldForField:"confirm_password"] setSecure:YES];
	
	[contentView addSubview:self];
	[[self window] makeFirstResponder:self];
}


-(JSObject)getFormData
{
	var screenData = new Object();
	
	screenData["Nome"] = [preferencesPanel getScreenValueForField:"Nome"];
	screenData["Cognome"] = [preferencesPanel getScreenValueForField:"Cognome"];
	screenData["domain"] = [preferencesPanel getScreenValueForField:"domain"];
	screenData["user_name"] = [preferencesPanel getScreenValueForField:"user_name"];
	screenData["language"] = [preferencesPanel getScreenValueForField:"language"];
	screenData["privileges"] = RoALocalized([preferencesPanel getScreenValueForField:"privileges"]);
	screenData["similar_names"] = RoALocalized([preferencesPanel getScreenValueForField:"similar_names"]);
	
	var newPassword = [preferencesPanel getScreenValueForField:"new_password"];
	if (newPassword)
	{
		screenData["password_sha"] = hex_sha1(newPassword+savedSalt);
	}
	return screenData;
}


-(void)enableSaveButton
{
	[savePreferencesButton setEnabled:YES];
	[quitPreferencesButton setTitle:RoALocalized(@"Annulla")];
}

-(BOOL)validateScreenData
{
	var screenDataHasErrors = false;
		
	var oldPassword = [preferencesPanel getScreenValueForField:"old_password"];
	var newPassword = [preferencesPanel getScreenValueForField:"new_password"];
	var confirmPassword = [preferencesPanel getScreenValueForField:"confirm_password"];
	var oldPasswordSha = hex_sha1(oldPassword+savedSalt);
	
	var	passwordChangeIntention = false;
	if (oldPassword+newPassword+confirmPassword != "")
	{
		var passwordChangeIntention = true;
	}
	
	if (passwordChangeIntention && oldPasswordSha != savedSha)
	{
		[[preferencesPanel formFieldForField:"old_password"] showError:RoALocalized(@"Password errata")];
		var screenDataHasErrors = true;
	}
	
	if (passwordChangeIntention && newPassword != confirmPassword)
	{
		[[preferencesPanel formFieldForField:"confirm_password"] showError:RoALocalized(@"Diversa da Nuova")];
		var screenDataHasErrors = true;
	}
	
	return (screenDataHasErrors);
}

-(BOOL)acceptsFirstResponder 
{ 
    return YES; 
} 

-(void)keyDown:(CPEvent)anEvent 
{
	if ([anEvent keyCode] == "13") {
		[quitPreferencesButton performClick:anEvent];
	}
} 



@end



