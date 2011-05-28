// -----------------------------------------------------------------------------
//  Crm06Controller.j
//  RoACrm01
//
// 	Created by Bruno Ronchetti on May 13, 2010.
// 	Copyright 2010, Ronchetti & Associati All rights reserved.
// -----------------------------------------------------------------------------

@import <Foundation/CPObject.j>
@import "Crm00FormTemplates.j"

@import "Crm0601View.j"


@implementation Crm06Controller : CPObject
{
	//CPNotificationCenter 	id appNotificationCenter;
	Crm0601View				id crm0601View			@accessors;
	CGRect					id rightPositionFrame;
	CGRect					id leftPositionFrame;
	
	CPArray 				id children;
	CPArray					id rootNodes;
	RoACouchModule			id responseData;
	
	CPArray					id formTemplate;
	
	CPDictionary			id	theFirstDocDict;
	CPDictionary			id	theSecondDocDict;
		
	//BOOL					id formDataHasChanged	@accessors;
}


-(void)init
{	
	self = [super init];
	if (self)
	{
	
		crm06Controller = self;

		// ---------------------------------------------------------------------
		// Geometry 
		//

		var contentViewWidth = [contentView frame].size.width;
		var contentViewHeight = [contentView frame].size.height- KKRoAY3;
		
		var rightOffset = KKRoAX1+KKRoAX2+ 5.0;
		var leftOffset = KKRoAX1+ 5.0;
		
		var viewHeight = contentViewHeight-KKRoAY0-KKRoAY1-KKRoAY2 -15.0;
		
		rightPositionFrame = CGRectMake(rightOffset, KKRoAY0+KKRoAY1+10.0 , contentViewWidth-rightOffset-5.0, viewHeight);
		leftPositionFrame  = CGRectMake(leftOffset, KKRoAY0+KKRoAY1+10.0, contentViewWidth-leftOffset-5.0, viewHeight);
		
		var appNotificationCenter = [CPNotificationCenter defaultCenter];
		[appNotificationCenter addObserver:self selector:"navigation:" name:nil object:@"Crm01Navigation"];
		
		var crm0601View = [[Crm0601View alloc] initWithFrame:leftPositionFrame];
		[crm0601View setAutoresizingMask:CPViewHeightSizable | CPViewWidthSizable];
		[crm0601View setBackgroundColor:KKRoABackgroundWhite];
		[crm0601View initialize];
		[crm0601View setDataDelegate:self];
		
		var theFirstDocDict = [CPDictionary dictionary];
		var theSecondDocDict = [CPDictionary dictionary];
		
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
				//alert("in case didMenuSelection");
				[crm0601View setFrame:leftPositionFrame];
				KKRoAFormDataHasChanged = false;
				KKRoAnItem = "";
				[KKRoATheDatabaseDoc removeAllObjects];
				[KKRoATheScreenDoc removeAllObjects];
				[KKRoATheDocsToBeWritten removeAllObjects];	
				[crm0601View clearView];
				[self prepareFormView];
				break;
					
			case "didSelectAList":
				//alert("Arrivato didSelectAList con type "+KKRoAType);
				[crm0601View setFrame:rightPositionFrame];
				[crm0601View clearView];
				[self prepareFormView];
				break;
										
			case "didLogout":
			case "didRequestHelp":	
			case "didRequestGlobalSearch":	
				[crm0601View removeFromSuperview];
				break;
										
			case "didRequest2PanesDisplay":	
				[crm0601View setFrame:leftPositionFrame];
				break;

			case "didRequestDocDisplay":
				//alert("in 06 controller arrivato didRequestDocDisplay");
				var recordKey = KKRoAnItem;
				[self readRecordFromDatabase:recordKey];
				[crm0601View setFormData:KKRoATheExtendedDatabaseDoc];
				KKRoAFormDataHasChanged = false;
				[self setFormPrivileges];
				[crm0601View display];
				break;

			case "didRequestNewDoc":
				//alert("in 06 controller arrivato");	
				KKRoAFormDataHasChanged = false;
				KKRoAnItem = "";
				[KKRoATheDatabaseDoc removeAllObjects];
				[KKRoATheScreenDoc removeAllObjects];
				[KKRoATheDocsToBeWritten removeAllObjects];					
				[crm0601View resetView];			
				[crm0601View display];
				break;	

			case "didRequestReloadDoc":	
				[crm0601View setFormData:KKRoATheExtendedDatabaseDoc];
				KKRoAFormDataHasChanged = false;
				break;	
									
			case "didRequestDeleteDoc":
				[crm0601View getFormData];
				[self mergeFormData];
				[self computeComputedFields];
				[self prepareDocsToBeWritten];
				//[crm0601View clearView];
				break;
						
			case "didRequestSaveDoc":	
				[crm0601View getFormData];
				[self mergeFormData];
				[self computeComputedFields];
				[self prepareDocsToBeWritten];
				//listProperties(KKRoATheScreenDoc, "KKRoATheScreenDoc Salvato");
				break;
						
			case "didActivatePrintMode":
			case "didRequestPreferences":	
			case "didRequestPrintForList":	
				[crm0601View removeFromSuperview];
				break;
													
			default: 	break;
		}
	}
}


-(void)prepareFormView
{
	switch (KKRoAType)
	{
		case "person":		formTemplate = [CPArray arrayWithArray:personFormTemplate]; break;
		case "member":		formTemplate = [CPArray arrayWithArray:memberFormTemplate]; break;				
		case "company":		formTemplate = [CPArray arrayWithArray:companyFormTemplate]; break;
		case "employee":	formTemplate = [CPArray arrayWithArray:employeeFormTemplate]; break;
		case "project":		formTemplate = [CPArray arrayWithArray:projectFormTemplate]; break;
		case "contact":		formTemplate = [CPArray arrayWithArray:contactFormTemplate]; break;				
		case "non_profit_organization":formTemplate = [CPArray arrayWithArray:non_profit_organizationFormTemplate]; break;
		
		default: alert("KKRoAType non riconosciuto"); break;
	}
		
	[crm0601View prepareForm:KKRoAType withTemplate:formTemplate];
}

-(void)setFormPrivileges
{
	KKRoAFormPrivileges = KKRoAUserPrivileges;
	
	if (KKRoAType == "project" && KKRoAUserPrivileges == "capo progetto" && KKRoAUserExternalName == [KKRoATheExtendedDatabaseDoc valueForKey:"Capo_Progetto"])
	{
		KKRoAFormPrivileges = "pieni";
	}
	
	if (KKRoAFormPrivileges == "pieni")
	{
		[[crm0601View crm06DocView] setFormIsOutputOnly:NO];
	}
	else
	{
		[[crm0601View crm06DocView] setFormIsOutputOnly:YES];
	}
}

-(void)checkBoxPressed:(CPSender)aSender
{
	if ([aSender state] == 1) {
		[crm0601View dim:NO fieldsAssociatedTo:[aSender tag]];
	}
	else {
		[crm0601View dim:YES fieldsAssociatedTo:[aSender tag]];
	}
}



-(void)getScreenValueForItem:(CPString)anItem
{
	return [crm0601View getScreenValueForItem:anItem];
}




-(void)readRecordFromDatabase:(CPString)aKey
{
	[KKRoATheDatabaseDoc removeAllObjects];
	[KKRoATheScreenDoc removeAllObjects];
	[KKRoATheDocsToBeWritten removeAllObjects];
	
	var dataRequest = new Object();
	dataRequest["action"] = "readDoc";
	dataRequest["key"] = "documents/"+aKey;
	
	var aDoc = [[RoACouchModule alloc] initWithRequest:dataRequest executeSynchronously:1];
	//listProperties(aRecord, "aRecord");
	
	KKRoAForeignKey = aDoc["Foreign_Key"];
	KKRoATheDatabaseDoc = [CPDictionary dictionaryWithJSObject:aDoc];
	//alert("dopo lettura "+KKRoATheDatabaseDoc);
	
	KKRoATheExtendedDatabaseDoc = [CPDictionary dictionaryWithDictionary:KKRoATheDatabaseDoc];
	var outputOnlyFieldsDictionary =[CPDictionary dictionary];
	outputOnlyFieldsDictionary = [self prepareAdditionalFields];
	[KKRoATheExtendedDatabaseDoc addEntriesFromDictionary:outputOnlyFieldsDictionary];
}


-(void)prepareAdditionalFields
{
	var dictionary = [CPDictionary dictionary];

	switch (KKRoAType)
	{
		case "member":
		case "employee":
			var foreignKey = KKRoAForeignKey;
			var lookupKey = [KKRoAUserDomain, "person", encodeURI(foreignKey)];
			var JSONkey = JSON.stringify(lookupKey);
			var lookupObject = new Object();
			lookupObject["action"] = "readDoc";
			lookupObject["key"] = "documents/_design/data/_view/docs_by_foreign_key?key="+JSONkey;
			var lookupDoc = [[RoACouchModule alloc] initWithRequest:lookupObject executeSynchronously:1];

			[dictionary setValue:lookupDoc[0]["value"]["Indirizzo_Lavoro"] forKey:"Indirizzo_Lavoro"];
			[dictionary setValue:lookupDoc[0]["value"]["Localita_Lavoro"] forKey:"Localita_Lavoro"];
			[dictionary setValue:lookupDoc[0]["value"]["Indirizzo_Casa"] forKey:"Indirizzo_Casa"];
			[dictionary setValue:lookupDoc[0]["value"]["Localita_Casa"] forKey:"Localita_Casa"];
			[dictionary setValue:lookupDoc[0]["value"]["Cellulare"] forKey:"Cellulare"];
			[dictionary setValue:lookupDoc[0]["value"]["Telefono_Lavoro"] forKey:"Telefono_Lavoro"];
			[dictionary setValue:lookupDoc[0]["value"]["eMail_Lavoro"] forKey:"eMail_Lavoro"];
			[dictionary setValue:lookupDoc[0]["value"]["eMail_Casa"] forKey:"eMail_Casa"];
			break;	
	
		case "company":
		case "non_profit_organization":
			var foreignKey = "";
			if ( KKRoAType == "company" &&  [KKRoATheDatabaseDoc valueForKey:"Referente_Azienda"])
			{
				foreignKey = [KKRoATheDatabaseDoc valueForKey:"Referente_Azienda"];
			}
			
			if ( KKRoAType == "non_profit_organization" &&  [KKRoATheDatabaseDoc valueForKey:"Referente_Organizzazione"])
			{
				foreignKey = [KKRoATheDatabaseDoc valueForKey:"Referente_Organizzazione"];
			}
			
			if (foreignKey == "")
				break;
				
			var lookupKey = [KKRoAUserDomain, "person", encodeURI(foreignKey)];
			var JSONkey = JSON.stringify(lookupKey);
			var lookupObject = new Object();
			lookupObject["action"] = "readDoc";
			lookupObject["key"] = "documents/_design/data/_view/docs_by_foreign_key?key="+JSONkey;
			var lookupDoc = [[RoACouchModule alloc] initWithRequest:lookupObject executeSynchronously:1];

			[dictionary setValue:lookupDoc[0]["value"]["Cellulare"] forKey:"Cellulare"];
			[dictionary setValue:lookupDoc[0]["value"]["Telefono_Lavoro"] forKey:"Telefono_Lavoro"];
			[dictionary setValue:lookupDoc[0]["value"]["eMail_Lavoro"] forKey:"eMail_Lavoro"];
			[dictionary setValue:lookupDoc[0]["value"]["eMail_Casa"] forKey:"eMail_Casa"];
			break;
			
		default:
			break;
	}
	return dictionary;
}


-(void)mergeFormData
{
	// first merge screen data with saved database data
	//
	
	[KKRoATheDocsToBeWritten removeAllObjects];
	
	var theFirstDocDict = [CPDictionary dictionaryWithDictionary:KKRoATheDatabaseDoc];
	var screenItems = [KKRoATheScreenDoc allKeys];
	
	//alert("prima del merge cosa c'è in KKRoATheScreenDoc "+KKRoATheScreenDoc);
	for (var i=0; i<[screenItems count]; i++)
	{
		[theFirstDocDict setObject:[KKRoATheScreenDoc objectForKey:screenItems[i]] forKey:screenItems[i]];
	}
	
	[KKRoATheDocsToBeWritten addObject:theFirstDocDict];
	
		
	//alert("nell'array ci sono elementi "+[KKRoATheDocsToBeWritten count]);
	//alert("e il primo è "+KKRoATheDocsToBeWritten[0]);
	
	//alert("in mergeFormData KKRoATheDatabaseDoc "+KKRoATheDatabaseDoc);
	//alert("in mergeFormData KKRoATheScreenDoc "+KKRoATheScreenDoc);
	//alert("in mergeFormData theFirstDocDict "+theFirstDocDict);
}


-(void)computeComputedFields
{
	// then compute fields that are not on screen
	//
	//alert(" KKRoaType "+KKRoAType);
	switch (KKRoAType)
	{
		case ("person"):
			var foreignKey = [theFirstDocDict valueForKey:"Nome"]+ " " +[theFirstDocDict valueForKey:"Cognome"];
			[theFirstDocDict setValue:foreignKey forKey:"Foreign_Key"];
			break;
			
		case ("member"):
		case ("employee"):
			var foreignKey = [theFirstDocDict valueForKey:"Foreign_Key"];
			var lookupKey = [KKRoAUserDomain, "person", encodeURI(foreignKey)];
			var JSONkey = JSON.stringify(lookupKey);
			var lookupObject = new Object();
			lookupObject["action"] = "readDoc";
			lookupObject["key"] = "documents/_design/data/_view/docs_by_foreign_key?key="+JSONkey;
			
			//alert("quando leggo la foreign key "+lookupObject["key"]);
			var lookupDoc = [[RoACouchModule alloc] initWithRequest:lookupObject executeSynchronously:1];

			[theFirstDocDict setValue:lookupDoc[0]["value"]["Nome"] forKey:"Nome"];
			[theFirstDocDict setValue:lookupDoc[0]["value"]["Cognome"] forKey:"Cognome"];
			break;
		
		case ("company"):
			var ragioneSociale = [theFirstDocDict valueForKey:"Ragione_Sociale"]
			[theFirstDocDict setValue:ragioneSociale forKey:"Foreign_Key"];
			break;
			
		case ("non_profit_organization"):
			var organizzazione = [theFirstDocDict valueForKey:"Organizzazione"]
			[theFirstDocDict setValue:organizzazione forKey:"Foreign_Key"];
			break;
		
		case ("project"):
			var denominazione = [theFirstDocDict valueForKey:"Denominazione"]
			[theFirstDocDict setValue:denominazione forKey:"Foreign_Key"];
			break;
						
		case ("contact"):			
			var foreignKey = [theFirstDocDict valueForKey:"Persona_Contattata"];
			var lookupKey = [KKRoAUserDomain, "person", encodeURI(foreignKey)];
			var JSONkey = JSON.stringify(lookupKey);
			var lookupObject = new Object();
			lookupObject["action"] = "readDoc";
			lookupObject["key"] = "documents/_design/data/_view/docs_by_foreign_key?key="+JSONkey;
			var lookupDoc = [[RoACouchModule alloc] initWithRequest:lookupObject executeSynchronously:1];

			[theFirstDocDict setValue:lookupDoc[0]["value"]["Cognome"] forKey:"Cognome_Persona_Contattata"];
			break;
			
		default:
			alert("unrecognized KKRoAtype");
			break;
	}
}



-(CPArray)prepareDocsToBeWritten
{
	if ([theFirstDocDict containsKey:"Foreign_Key"] && [theFirstDocDict valueForKey:"Foreign_Key"] != [KKRoATheDatabaseDoc valueForKey:"Foreign_Key"])
	{
		[theFirstDocDict setValue:null forKey:"_id"];
		[theFirstDocDict setValue:null forKey:"_rev"];
	}


	if (KKRoAType == "contact")
	{
		if ( !	[theFirstDocDict containsKey:"Next_Collaboratore"] ||
				[theFirstDocDict containsKey:"Next_Data_del_Contatto"] ||
				[theFirstDocDict containsKey:"Persona_Contattata"]	)
		{
			return;
		}

		var theSecondDocDict = [CPDictionary dictionary];

		var firstKey = generateUid();
		[theFirstDocDict setValue:firstKey forKey:"_id"];
		var secondKey = generateUid();
		[theSecondDocDict setValue:secondKey forKey:"_id"];
						
		[theSecondDocDict setValue:"pianificato" forKey:"Stato"];
		[theSecondDocDict setValue:firstKey forKey:"Contatto_Precedente"];
		[theSecondDocDict setValue:[theFirstDocDict valueForKey:"Next_Collaboratore"] forKey:"Collaboratore"];
		[theSecondDocDict setValue:[theFirstDocDict valueForKey:"Next_Data_del_Contatto"] forKey:"Data_del_Contatto"];
		[theSecondDocDict setValue:[theFirstDocDict valueForKey:"Next_Persona_Contattata"] forKey:"Persona_Contattata"];
		[theSecondDocDict setValue:[theFirstDocDict valueForKey:"Next_Suggerimenti"] forKey:"Suggerimenti"];
		var contactHistory = [];
		contactHistory[0] = RoALocalized(@"Il giorno");
		contactHistory[1] = [theFirstDocDict valueForKey:"Data_del_Contatto"]
		contactHistory[2] = [theFirstDocDict valueForKey:"Cognome_Collaboratore"]
		contactHistory[3] = RoALocalized(@" ha contattato ");
		contactHistory[4] = [theFirstDocDict valueForKey:"Persona_Contattata"]
		contactHistory[5] = RoALocalized(@" con una ");
		contactHistory[6] = [theFirstDocDict valueForKey:"Forma_del_Contatto"]
		[theSecondDocDict setValue:contactHistory.join(" ") forKey:"Storia"];
		

		[KKRoATheDocsToBeWritten addObject:theSecondDocDict];
	}

}

@end