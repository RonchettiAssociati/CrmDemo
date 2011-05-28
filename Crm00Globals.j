/*
 * GdoGlobals.j
 * RoAGdo
 *
 * Created by Bruno Ronchetti on July 26, 2010.
 * Copyright 2010, Ronchetti & Associati All rights reserved.
 */

@import <Foundation/CPObject.j>
	
// -----------------------------------------------------------------------------
// Run-Time Globals
//
	KKRoABaseURL 	= "RoAServer.rb";
	//KKRoABaseURL 	= "http://bruno-ronchettis-macbook.local/~brunoronchetti/RoACrm/RoAServer.rb";
	KKRoADatabaseName 	= "crmdemo_";
	KKRoARoot = "crmdemo_";					//da togliere
	
	KKRoAUser = "";
	KKRoAUserExternalName = "";
	KKRoAUserOrgUnit = "";
	KKRoAUserLanguage = "italiano";
	KKRoAUserPrivileges = "";
	KKRoAFormPrivileges = "";
	KKRoAUserDomain = "";
	KKRoALogoFile = "";
	
	KKRoATables		= [];
	KKRoAInitializedForms = [CPDictionary dictionary];
	
	KKRoADatabase	= "";				//eg. persons
	KKRoAType 		= "";				//eg. person
	KKRoACaption 	= "";
	KKRoASortKey 	= "";
	KKRoAAction 	= "";
	KKRoAnItem	 	= "";
	KKRoAForeignKey	= "";
	KKRoAList		= "";
	KKRoARequestPrint = false;
	KKRoATables		= [];
	
	KKRoaRelevantHelpPage = "";
	
	KKRoASearchString = "";
	KKRoAFormDataHasChanged = false;
	KKRoATheScreenDoc = new Object();
	
	KKRoATheDatabaseDoc = [CPDictionary dictionary];
	KKRoATheExtendedDatabaseDoc = [CPDictionary dictionary];
	KKRoATheScreenDoc = [CPDictionary dictionary];
	KKRoATheDocsToBeWritten = [];

		
// -----------------------------------------------------------------------------
// Menu
//	
	
	KKRoAUnfilteredMenuButtons = [CPDictionary dictionaryWithObjectsAndKeys:
	["persons", "person", "Persone", "Cognome","personImage", "Nuova Persona"], @"person",
	["companies", "company", "Aziende", "Ragione_Sociale","companyImage2", "Nuova Azienda"], @"company",
	["non_profit_organizations", "non_profit_organization", "No Profit", "Organizzazione","nonProfitImage", "Nuova No Profit"], @"non_profit_organization",
	["members", "member", "Soci", "Cognome", "memberImage", "Nuovo Socio"], @"member",
	["employees", "employee", "Collaboratori", "Cognome", "employeeImage", "Nuovo Collaboratore"], @"employee",
	["projects", "project", "Progetti", "Denominazione", "projectImage2", "Nuovo Progetto"], @"project",
	["contacts", "contact", "Contatti", "Denominazione","contactImage", "Nuovo Contatto"], @"contact"
	//["gears", "", "Preferenze", "","gearImage"], @"gears"
	];
	KKRoAMenuButtons = [CPDictionary dictionaryWithDictionary:KKRoAUnfilteredMenuButtons];

	KKRoAUnfilteredUserButtons = [CPDictionary dictionaryWithObjectsAndKeys:
	["print", "", "Stampa", "",""], @"print",
	["help", "", "Aiuto", "",""], @"help",
	["preferences", "", "Preferenze", "",""], @"preferences",
	["logout", "", "Log Out", "","logout"], @"logout"
	];
	KKRoAUserButtons = [CPDictionary dictionaryWithDictionary:KKRoAUnfilteredUserButtons];
	
	KKRoAUnfilteredButtonBarButtons = [CPDictionary dictionaryWithObjectsAndKeys:
	["insertButton", "+", "updateLists", "24"], @"insertButton",
	["insertChildButton", "++", "updateLists", "18"], @"insertChildButton",
	["deleteButton", "-", "updateLists", "24"], @"deleteButton",
	["editButton", "edit", "updateLists", "12"], @"editButton"
	];
	KKRoAButtonBarButtons = [CPDictionary dictionaryWithDictionary:KKRoAUnfilteredButtonBarButtons];

	
	KKRoAUnfilteredRecordLevelActionButtons = [CPDictionary dictionaryWithObjectsAndKeys:
	["newRecord", "Nuovo", "left", 10], @"new",
	["reloadRecord", "Ripristina", "right", -270], @"reload",
	["deleteRecord", "Elimina", "right",-180], @"delete",
	["saveRecord", "Salva", "right", -90], @"save"
	];
	KKRoARecordLevelActionButtons = [CPDictionary dictionaryWithDictionary:KKRoAUnfilteredRecordLevelActionButtons];	
// -----------------------------------------------------------------------------
// Geometry
//
	KKRoAX1 = 190.0;
	KKRoAX2 = 300.0;
	KKRoAY0 = 53.0;
	KKRoAY1 = 30.0;
	KKRoAY2 = 30.0;
	KKRoAY3 = 15.0;
	KKRoAY4 = 430.0;
	
				
// -------------------------------------------------------------------------
// Fonts
//

	KKRoASectionFont = [CPFont boldSystemFontOfSize:12];
	KKRoASectionLevelFont = [CPFont systemFontOfSize:11];
	
	KKRoaTableHeaderFont = [CPFont boldSystemFontOfSize:11];
	KKRoALabelFont = [CPFont systemFontOfSize:11];
	KKRoAFieldFont = [CPFont systemFontOfSize:11];
	KKRoAOutlineTextFont = [CPFont systemFontOfSize:12];
	
// -----------------------------------------------------------------------------
// Palette
//
	//KKRoAContentViewBackground = [CPColor colorWithPatternImage:[[CPImage alloc] initWithContentsOfFile:"Resources/contentViewBackground.png"]];
	KKRoAContentViewBackground = [CPColor colorWithPatternImage:[[CPImage alloc] initWithContentsOfFile:"Resources/fibragreen.png"]];
	KKRoAToolbarBackground = [CPColor colorWithPatternImage:[[CPImage alloc] initWithContentsOfFile:"Resources/gradientToolbar.png"]];
	KKRoAToolbarBackgroundBottom = [CPColor colorWithPatternImage:[[CPImage alloc] initWithContentsOfFile:"Resources/gradientToolbarBottom.png"]];
	KKRoARibbonBackground = [CPColor colorWithPatternImage:[[CPImage alloc] initWithContentsOfFile:"Resources/gradientBottombar.png"]];
	KKRoABottombarBackground = [CPColor colorWithPatternImage:[[CPImage alloc] initWithContentsOfFile:"Resources/gradientBottombar.png"]];
	
	KKRoAMainTitleColor = [CPColor colorWithCalibratedRed:105/255 green:141/255 blue:195/255 alpha:1];
	KKRoAMainTitleColorHighlighted = [CPColor colorWithCalibratedRed:129/255 green:174/255 blue:242/255 alpha:1];
	KKRoALabelColor = [CPColor colorWithCalibratedRed:135/255 green:135/255 blue:135/255 alpha:0.9];
	KKRoAOutlineLabelColor = [CPColor colorWithCalibratedRed:115/255 green:115/255 blue:115/255 alpha:0.9];
	KKRoADimmedLabelColor = [CPColor colorWithCalibratedRed:225/255 green:225/255 blue:225/255 alpha:0.9];

	KKRoASectionColor = [CPColor colorWithCalibratedRed:135/255 green:135/255 blue:135/255 alpha:0.9];
	
	
  // TextColors
	KKRoADarkGray = [CPColor colorWithCalibratedRed:103/255 green:111/255 blue:114/255 alpha:1];
	
	
  // ButtonColors	
	KKRoAMediumLightGray = [CPColor colorWithCalibratedRed:193/255 green:195/255 blue:197/255 alpha:1];
	KKRoAMediumBlue = [CPColor colorWithCalibratedRed:105/255 green:141/255 blue:195/255 alpha:1];
	KKRoAHighlightBlue = [CPColor colorWithCalibratedRed:54/255 green:116/255 blue:208/255 alpha:1];
	KKRoASelectedBlue = [CPColor colorWithCalibratedRed:95/255 green:131/255 blue:185/255 alpha:1];
	KKRoAPreSelectionBlue = [CPColor colorWithCalibratedRed:95/255 green:131/255 blue:185/255 alpha:0.6];
	
	KKRoADarkGray = [CPColor colorWithCalibratedRed:103/255 green:111/255 blue:114/255 alpha:1];
	KKRoAMediumGray = [CPColor colorWithCalibratedRed:95/255 green:100/255 blue:105/255 alpha:1];
	KKRoALightGray = [CPColor colorWithCalibratedRed:223/255 green:225/255 blue:227/255 alpha:1];
	KKRoAVeryVeryLightGray = [CPColor colorWithCalibratedRed:235/255 green:235/255 blue:235/255 alpha:1];
	KKRoABackgroundWhite = [CPColor colorWithCalibratedRed:251/255 green:251/255 blue:251/255 alpha:1];


  // Shadows
			
					
// -----------------------------------------------------------------------------
// Dictionary
//
	KKRoAStringDictionary = {
	// Gdo0101View
	
	@"Database dei Contatti": {english:@"Contacts Database"},
	@"Prego fornisca le sue credenziali di accesso": {english:@"Please Provide Your Sign-on Credentials"},
	@"Nome Utente": {english:@"User Name"},
	@"Bentornato ": {english:@"Welcome back "},	
	@". La stiamo collegando al database.": {english:@"Connecting you to the database"},
	@"Le credenziali fornite non corrispondono a quelle in archivio. Prego riprovi.": {english:@"The credentials you provided do not match our records. Please try again."},
	@"Prego fornisca le sue credenziali di accesso complete.": {english:@"Please provide your full credentials"},
			
	@"Nome": {italiano:@"Nome", english:@"Given Name", francais:@"Nom", deutsch:@"Name"},
	@"length": {italiano:@"lunghezza", english:@"length", francais:@"longeur", deutsch:@"Breite"},
	@"Apply": {italiano:@"Applica", english:@"Apply", francais:@"applie", deutsch:@"che ne so"},
	
	@"requiredErrorMessage": {italiano:@"Questo dato è obbligatorio", english:@"This is a required field"},
	@"stringErrorMessage": {italiano:@"Questo dato deve essere alfanumerico", english:@"This must be a string"},
	@"numericErrorMessage": {italiano: @"Questo dato deve essere numerico", english:@"This must be a number"},
	@"amountErrorMessage": {italiano:@"Questo dato richiede un importo con due decimali al più", english:@"This must be an amount and have max 2 decimals"},
	@"addressErrorMessage": {italiano:@"Questo dato deve essere un indirizzo valido", english:@"This must be a valid address"},
	@"emailErrorMessage": {italiano:@"Indirizzo email non corretto", english:@"This must be a correct email"},
	@"dateErrorMessage": {italiano:@"Data non corretta", english:@"This must be a correct date"},
	@"telephoneErrorMessage": {italiano:@"Numero di telefono non corretto", english:@"This must be a valid telephone number"},
	@"New": {italiano:@"Nuovo", english:@"New"},
	@"Delete": {italiano:@"Elimina", english:@"Delete"},
	@"Reload": {italiano:@"Ripristina", english:@"Reload"},
	@"Cancel": {italiano:@"Annulla", english:@"Cancel"},
	@"Save": {italiano:@"Salva", english:@"Save"},
	@"true": {italiano:@"sì", english:@"Save"},
	@"false": {italiano:@"no", english:@"Save"},
	@"Are you sure?": {italiano:@"Sei sicuro", english:@"Sure you want it?"} 
	};
	
	
	
@implementation Crm00Globals : CPObject
{
}

+(void)tailorGlobalsForUser
{
	KKRoAInitializedForms = [CPDictionary dictionary];
	
	switch (KKRoAUserDomain)
	{
		case("Panda"):
			KKRoALogoFile = "Resources/logoPandaSmall.png";
			KKRoALogo = [[CPImage alloc] initWithContentsOfFile:"Resources/logoPanda.png" size:CGSizeMake(100,KKRoAY0)]; 			break;
		case("Volo"):
			KKRoALogoFile = "Resources/logoVoloSmall.png";
			KKRoALogo = [[CPImage alloc] initWithContentsOfFile:"Resources/logoVolo.png" size:CGSizeMake(100,KKRoAY0)]; 			break;
		case("Joy"):
			KKRoALogoFile = "Resources/logoJoySmall.png";
			KKRoALogo = [[CPImage alloc] initWithContentsOfFile:"Resources/logoJoy.png" size:CGSizeMake(100,KKRoAY0)]; 				break;
		default:
			KKRoALogoFile = "Resources/logoPanda.png";
			KKRoALogo = [[CPImage alloc] initWithContentsOfFile:"Resources/logoPanda.png" size:CGSizeMake(100,KKRoAY0)]; 			break;
	}
		
	if (KKRoAUserPrivileges == "limited")
	{
		[KKRoAMenuButtons removeObjectsForKeys:["gears"]];
		[KKRoAButtonBarButtons removeObjectsForKeys:["insertButton", "insertChildButton", "deleteButton", "editButton"]];
		[KKRoARecordLevelActionButtons removeObjectsForKeys:["new", "reload", "cancel", "save"]];
	}
}

@end


