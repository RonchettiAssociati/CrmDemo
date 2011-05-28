/*
 * App06Controller.j
 * WktTest63
 *
 * Created by Bruno Ronchetti on January 13, 2009.
 * Copyright 2009, Ronchetti & Associati All rights reserved.
 */

	
	

// =============================================================================
// PERSONE 
// =============================================================================

personFormTemplate = [

	{type:"section", item:"Dati Anagrafici"},
	
	{type:"field", item:"Nome", length:210, validation:["immediate", "required", "string"]},

	{type:"field", item:"Cognome", length:210, skip:YES, position:300, validation:["immediate", "required", "string"]},

	//{type:"date", item:"Data di nascita", label:"Nato il", length:120, placeholder:"gg mmm aaaa" , enhance:YES,  help:["calendar", "date", "today"], validation:["immediate", "optional", "date"]},
			
	{type:"combo", item:"Appellativo", length:210, toolTip:"Titolo da utilizzare in corrispondenza", help:["list", "inline", ["Egregio Signore", "Gentile Signora"], "single"], validation:["immediate", "optional", "string"]},
	
	{type:"combo", item:"Titolo", length:210,  help:["list", "inline", ["Dottore", "Ingegnere", "Avvocato", "Dottoressa", "Architetto"], "single"], skip:YES, position:300, validation:["immediate", "optional", "string"]},

//------------------------------------------------------------------------------
	{type:"section", item:"Recapiti"},
	
	{type:"section", level:2, item:"Lavoro"},
	
	{type:"field", item:"Indirizzo_Lavoro", label: "Indirizzo", length:210, skip:YES, validation:["immediate", "optional", "string"]},
	
	{type:"field", item:"Localita_Lavoro", label: "Località", length:210, skip:YES, position:300, placeholder:"I-20100 Milano", validation:["immediate", "optional", "address"]},
	
	{type:"section", level:2, item:"Casa"},
	
	{type:"field", item:"Indirizzo_Casa", label: "Indirizzo", skip:YES, length:210,validation:["immediate", "optional", "string"]},
	
	{type:"field", item:"Localita_Casa", label: "Località", length:210, skip:YES, position:300, validation:["immediate", "optional", "address"]},

	{type:"section", level:2, item:"Telefoni"},
	
	{type:"field", item:"Cellulare", length:210, skip:YES, validation:["immediate", "optional", "telephone"]},
	
	{type:"field", item:"Telefono_Lavoro", label:"Lavoro", length:210, skip:YES, position:300, validation:["immediate", "optional", "telephone"]},
	
	{type:"section", level:2, item:"E-mail"},
	
	{type:"field", item:"eMail_Lavoro", label:"Lavoro", length:210, skip:YES, validation:["immediate", "optional", "email"]},
	
	{type:"field", item:"eMail_Casa", label:"Casa", length:210, skip:YES, position:300, validation:["immediate", "optional", "email"]},
	
	//{addButton:"+", position:500, toCreate:"altro telefono:"},

	
//------------------------------------------------------------------------------
	{type:"section", item:"Attività Professionale"},
	
	{type:"table", item:"Storia_Professionale",
		label:"Storia Professionale",
		position:0,
		skip:NO, 
		size:[480.0,80.0],
		outputOnly:NO,
		allowInsert:YES,
		columns:["Azienda", "Ruolo_Azienda", "Data_Fine"],
		columnWidths:[200, 150, 120],
		columnTypes:["field", "field", "date"],
		columnEnhancement:[NO, NO, YES],
		columnHelp: [
						["list", "database", "company", "single", 2],
						["list", "table", "company_roles", "single", 0],
						[]
					]
	},
	
	//{type:"combo", item:"Azienda", help:["list", "database", "company", "single", 3], validation:["immediate", "optional", "string"]},
	
	//{type:"combo", item:"Ruolo_Azienda", label:"Ruolo Azienda", skip:YES, position:300, help:["list", "table", "company_roles", "single"], validation:["immediate", "optional", "string"]},

	
//------------------------------------------------------------------------------
	{type:"section", item:"Attivita No Profit", label:"Attività No Profit"},

	
	{type:"table", item:"Collaborazioni",
		label:"Collaborazioni",
		position:0,
		skip:NO, 
		size:[480.0,80.0],
		outputOnly:NO,
		allowInsert:YES,
		columns:["Organizzazione", "Ruolo_No_Profit", "Data_Fine"],
		columnWidths:[200, 150, 120],
		columnTypes:["field", "field", "date"],
		columnEnhancement:[NO, NO, YES],
		columnHelp: [
						["list", "database", "non_profit_organization", "single", 0],
						["list", "table", "project_roles", "single", 0],
						[]
					]
	},


//------------------------------------------------------------------------------
	{type:"section", item:"Esperienza e interessi"},
	
	{type:"combo", item:"Aree_di_Esperienza", label:"Professionale", length:400, help:["list", "inline", ["Architettura e Costruzioni ", "Psicologia", "Sistemi Informativi", "Amministrazione e Bilanci", "Legale e Tributario"], "multiple"], validation:["immediate", "optional", "string"]},
	
	
	{type:"combo", item:"Aree_di_Interesse", label:"Aree di interesse", length:400, help:["list", "inline", ["Assistenza infanzia", "Assistenza Anziani", "Organizzazione Eventi", "Gestione", "Lavoro di Ufficio"], "multiple"], validation:["immediate", "optional", "string"]},	
					
//------------------------------------------------------------------------------
	{type:"section", item:"Relazioni"},
	
	{type:"combo", item:"Collaboratore 1", length:150, help:["list", "database", "employee", "single", 1], validation:["immediate", "optional", "string"]},
	
	{type:"combo", item:"Relazione 1", length:150, skip:YES, position:300, help:["list", "inline", ["Amico", "Parente", "ex Collaboratore"], "single"], validation:["immediate", "optional", "string"]},
	
	{type:"combo", item:"Collaboratore 2", length:150, help:["list", "database", "employee", "single", 1], validation:["immediate", "optional", "string"]},
	
	{type:"combo", item:"Relazione 2", length:150, skip:YES, position:300, help:["list", "inline", ["Amico", "Parente", "ex Collaboratore"], "single"], validation:["immediate", "optional", "string"]},
		
//------------------------------------------------------------------------------
	{type:"section", item:"Classificazione"},
	
	{type:"field", item:"Categoria1", label:"Categoria 1", length:200 },
	
	{type:"field", item:"Categoria2", label:"Categoria 2", length:200, skip:YES, position:300},
	
	{type:"field", item:"Gruppo", label:"Gruppo", length:200},
	
	{type:"field", item:"Sottogruppo", label:"Sottogruppo", length:200, skip:YES, position:300},
		
//------------------------------------------------------------------------------
	{type:"section", item:"Note"},
	
	{type:"field", item:"Note", label:"Note", length:400},
	
//------------------------------------------------------------------------------
	{type:"section", item:"Censito nelle liste"},
	
	{type:"array", item:"lists", label:"Liste", length:400, help:["list", "database", "personlists", "multiple", 0], validation:["immediate", "optional", "string"]}
];



// =============================================================================
// SOCIETA'  
// =============================================================================

companyFormTemplate = [

	{type:"section", item:"Dati Identificativi"},

	{type:"field", item:"Ragione_Sociale", label:"Ragione Sociale", length:250, validation:["immediate", "required", "string"]},
	{type:"field", item:"Indirizzo", length:300, validation:["immediate", "optional", "string"]},
	{type:"field", item:"Localita", length:150, placeholder:"I-20100 Milano", validation:["immediate", "optional", "string"]},
	
//------------------------------------------------------------------------------

	{type:"section", item:"Contatti Azienda"},
	
	{type:"field", item:"Telefono", validation:["immediate", "optional", "telephone"]},
	{type:"field", item:"Fax", skip:YES, position:300, validation:["immediate", "optional", "telephone"]},
	{type:"field", item:"eMail", length:230, validation:["immediate", "optional", "email"]},
	{type:"field", item:"Sito Web", length:200, skip:YES, position:300, validation:["immediate", "optional", "string"]},
		
//------------------------------------------------------------------------------
	{type:"section", item:"Referente Azienda"},
	
	
	{type:"combo", item:"Referente_Azienda", label:"Referente", length:230, help:["list", "database", "person", "single", 3], validation:["immediate", "optional", "string"]},

	{type:"section", level:2, item:"Telefoni"},
	
	{type:"field", item:"Cellulare", length:190, skip:YES, outputOnly:YES},
	
	{type:"field", item:"Telefono_Lavoro", label:"Lavoro", length:190, skip:YES, position:300, outputOnly:YES},
	
	{type:"section", level:2, item:"E-mail"},
	
	{type:"field", item:"eMail_Lavoro", label:"Lavoro", length:190, skip:YES, outputOnly:YES},
	
	{type:"field", item:"eMail_Casa", label:"Casa", length:190, skip:YES, position:300, outputOnly:YES},
//------------------------------------------------------------------------------
	{type:"section", item:"Classificazione"},
	
	{type:"field", item:"Categoria1", label:"Categoria 1", length:200 },
	
	{type:"field", item:"Categoria2", label:"Categoria 2", length:200, skip:YES, position:300},
	
	{type:"field", item:"Gruppo", label:"Gruppo", length:200},
	
	{type:"field", item:"Sottogruppo", label:"Sottogruppo", length:200, skip:YES, position:300},

//------------------------------------------------------------------------------
		
	{type:"section", item:"Censito nelle liste"},
	
	{type:"array", item:"lists", label:"Liste", length:400, help:["list", "database", "companylists", "single", 1], validation:["immediate", "optional", "string"]}

];



// =============================================================================
// ORGANIZZAZIONE NO PROFIT  
// =============================================================================

non_profit_organizationFormTemplate = [

	{type:"section", item:"Dati Identificativi"},

	{type:"field", item:"Organizzazione", length:250, validation:["immediate", "required", "string"]},
	{type:"field", item:"Indirizzo", length:300, validation:["immediate", "optional", "string"]},
	{type:"field", item:"Localita", length:150, placeholder:"I-20100 Milano", validation:["immediate", "optional", "string"]},
//------------------------------------------------------------------------------

	{type:"section", item:"Contatti"},
	
	{type:"field", item:"Telefono", validation:["immediate", "optional", "telephone"]},
	{type:"field", item:"Fax", skip:YES, position:300, validation:["immediate", "optional", "telephone"]},
	{type:"field", item:"eMail", length:150, validation:["immediate", "optional", "email"]},
	{type:"field", item:"Sito Web", length:200, skip:YES, position:300, validation:["immediate", "optional", "string"]},
		
//------------------------------------------------------------------------------
	{type:"section", item:"Referente Organizzazione"},
	
	
	{type:"combo", item:"Referente_Organizzazione", label:"Referente", length:200, help:["list", "database", "person", "single", 3], validation:["immediate", "optional", "string"]},

	{type:"section", level:2, item:"Telefoni"},
	
	{type:"field", item:"Cellulare", length:190, skip:YES, outputOnly:YES},
	
	{type:"field", item:"Telefono_Lavoro", label:"Lavoro", length:190, skip:YES, position:300, outputOnly:YES},
	
	{type:"section", level:2, item:"E-mail"},
	
	{type:"field", item:"eMail_Lavoro", label:"Lavoro", length:190, skip:YES, outputOnly:YES},
	
	{type:"field", item:"eMail_Casa", label:"Casa", length:190, skip:YES, position:300, outputOnly:YES},
	
//------------------------------------------------------------------------------
	{type:"section", item:"Classificazione"},
	
	{type:"field", item:"Categoria1", label:"Categoria 1", length:200 },
	
	{type:"field", item:"Categoria2", label:"Categoria 2", length:200, skip:YES, position:300},
	
	{type:"field", item:"Gruppo", label:"Gruppo", length:200},
	
	{type:"field", item:"Sottogruppo", label:"Sottogruppo", length:200, skip:YES, position:300},
//------------------------------------------------------------------------------

	{type:"section", item:"Censito nelle liste"},
	
	{type:"array", item:"lists", label:"Liste", length:400, help:["list", "database", "non_profit_organizationlists", "single", 1, "multiple"], validation:["immediate", "optional", "string"]}

];




// =============================================================================
// PROGETTI 
// =============================================================================

projectFormTemplate = [

	{type:"section", item:"Progetto"},

	{type:"field", item:"Denominazione", length:250, validation:["immediate", "required", "string"]},
	
	{type:"combo", item:"Progetto_Quadro", label:"Progetto Quadro", length:250, help:["list", "database", "project", "single", 1], validation:["immediate", "optional", "string"]},
	
//------------------------------------------------------------------------------

	{type:"section", item:"Dati del Progetto"},
	
	{type:"combo", item:"Capo_Progetto", label:"Capo Progetto", length:150, help:["list", "database", "person", "single", 3], validation:["immediate", "optional", "string"]},
	
	{type:"date", item:"Data_Inizio", label:"Data Inizio", length:120, enhance:YES, validation:["immediate", "optional", "date"]},
	
	{type:"date", item:"Data_Fine_Presunta", label:"Data Fine", length:120, skip:YES, position:300, enhance:YES, validation:["immediate", "optional", "date"]},
		
	{type:"amount", item:"Importo Stanziato", length:200, validation:["immediate", "required", "amount"]},

//------------------------------------------------------------------------------


	{type:"section", item:"Partecipanti"},
	
	{type:"table", item:"Partecipanti",
		label:"",
		position:-0.0,
		skip:NO, 
		size:[780.0,120.0],
		outputOnly:NO,
		allowInsert:YES,
		columns:["Persona", "Azienda", "No_Profit", "Ruolo", "Data_Inizio", "Data_Fine"],
		columnWidths:[140, 140, 140, 140, 100, 100],
		columnTypes:["field", "field","field","field", "date", "date"],
		columnEnhancement:[NO, NO, NO, NO, YES, YES],
		columnHelp: [
						["list", "database", "person", "single", 3],
						["list", "database", "company", "single", 3],
						["list", "database", "non_profit_organization", "single", 1],
						["list", "table", "project_roles", "single"],
						["calendar", "date", "today"],
						["calendar", "date", "today"]
					]
	},
	
//------------------------------------------------------------------------------
	{type:"section", item:"Note"},
	
	{type:"field", item:"Note", label:"Note", length:400},	
	
//------------------------------------------------------------------------------
	{type:"section", item:"Censito nelle liste"},
	
	{type:"array", item:"lists", label:"Liste", length:400, help:["list", "database", "projectslists", "multiple", 1], validation:["immediate", "optional", "string"]}


	
];





// =============================================================================
// SOCI 
// =============================================================================

memberFormTemplate = [

	{type:"section", item:"Dati del Socio"},

	{type:"combo", item:"Foreign_Key", label:"Persona", length:200, help:["list", "database", "person", "single", 3], validation:["immediate", "optional", "string"]},
		
	{type:"field", item:"Nome", skip:YES, hidden:YES},
	{type:"field", item:"Cognome", skip:YES, hidden:YES},
	
	
	{type:"combo", item:"Tipo Socio", length:120,  help:["list", "inline", ["Annuale", "Sostenitore", "Vitalizio"], "single"], validation:["immediate", "optional", "string"]},
	
	{type:"date", item:"Iscritto_dal", label:"Iscritto dal", length:120, skip:YES, position:300, placeholder:"gg mmm aaaa" , enhance:YES,  help:["calendar", "date", "today"], validation:["immediate", "optional", "date"]},
	
	
//------------------------------------------------------------------------------
	{type:"section", item:"Recapiti"},
	
	{type:"section", level:2, item:"Lavoro"},
	
	{type:"field", item:"Indirizzo_Lavoro", label: "Indirizzo", length:170, skip:YES, outputOnly:YES},
	
	{type:"field", item:"Località_Lavoro", label: "Località", length:190, skip:YES, position:300, outputOnly:YES},
	
	{type:"section", level:2, item:"Casa"},
	
	{type:"field", item:"Indirizzo_Casa", label: "Indirizzo", skip:YES, length:170, outputOnly:YES},
	
	{type:"field", item:"Località_Casa", label: "Località", length:190, skip:YES, position:300, outputOnly:YES},

	{type:"section", level:2, item:"Telefoni"},
	
	{type:"field", item:"Cellulare", length:190, skip:YES, outputOnly:YES},
	
	{type:"field", item:"Telefono_Lavoro", label:"Lavoro", length:190, skip:YES, position:300, outputOnly:YES},
	
	{type:"section", level:2, item:"E-mail"},
	
	{type:"field", item:"eMail_Lavoro", label:"Lavoro", length:190, skip:YES, outputOnly:YES},
	
	{type:"field", item:"eMail_Casa", item:"Casa", length:190, skip:YES, position:300, outputOnly:YES},
		
//------------------------------------------------------------------------------
	{type:"section", item:"Note"},
	
	{type:"field", item:"Note", label:"Note", length:400},	
//------------------------------------------------------------------------------
	{type:"section", item:"Censito nelle liste"},
	
	{type:"array", item:"lists", label:"Liste", length:400, help:["list", "database", "memberlists", "multiple", 1], validation:["immediate", "optional", "string"]}

];





// =============================================================================
// COLLABORATORI 
// =============================================================================

employeeFormTemplate = [

	{type:"section", item:"Dati del Collaboratore"},


	{type:"combo", item:"Foreign_Key", label:"Persona", length:200, help:["list", "database", "person", "single", 3], validation:["immediate", "optional", "string"]},
		
	{type:"field", item:"Nome", skip:YES, hidden:YES},
	
	{type:"field", item:"Cognome", skip:YES, hidden:YES},
		
	//{type:"field", item:"Nome", length:180, validation:["immediate", "required", "string"]},
	//{type:"field", item:"Cognome", length:250, skip:YES, position:300, validation:["immediate", "required", "string"]},
	
	
//------------------------------------------------------------------------------
	{type:"section", item:"Recapiti"},
	
	{type:"section", level:2, item:"Lavoro"},
	
	{type:"field", item:"Indirizzo_Lavoro", label: "Indirizzo", length:170, skip:YES, outputOnly:YES},
	
	{type:"field", item:"Località_Lavoro", label: "Località", length:190, skip:YES, position:300, outputOnly:YES},
	
	{type:"section", level:2, item:"Casa"},
	
	{type:"field", item:"Indirizzo_Casa", label: "Indirizzo", skip:YES, length:170, outputOnly:YES},
	
	{type:"field", item:"Località_Casa", label: "Località", length:190, skip:YES, position:300, outputOnly:YES},

	{type:"section", level:2, item:"Telefoni"},
	
	{type:"field", item:"Cellulare", length:190, skip:YES, outputOnly:YES},
	
	{type:"field", item:"Telefono_Lavoro", label:"Lavoro", length:190, skip:YES, position:300, outputOnly:YES},
	
	{type:"section", level:2, item:"E-mail"},
	
	{type:"field", item:"eMail_Lavoro", label:"Lavoro", length:190, skip:YES, outputOnly:YES},
	
	{type:"field", item:"eMail_Casa", item:"Casa", length:190, skip:YES, position:300, outputOnly:YES},
	
	
//------------------------------------------------------------------------------
	{type:"section", item:"Collaborazione"},

	{type:"combo", item:"Tipo Collaborazione", length:250, help:["list", "inline", ["Retribuita Fissa", "Retribuita a Progetto", "Volontario", "Professionista"], "single"], validation:["immediate", "required", "string"]},
	
	{type:"combo", item:"Ruolo_Progetto", label:"Ruolo", length:250, help:["list", "table", "project_roles", "single"],  validation:["immediate", "optional", "string"]},
		
	{type:"combo", item:"Sede di Lavoro", length:100, initial:"Milano", help:["list", "inline", ["Milano", "roma", "Napoli"]], validation:["immediate", "optional", "string"]},
	
	{type:"combo", item:"Disponibilità", length:100, skip:YES, position:300, initial:"tempo parziale", help:["list", "inline", ["tempo pieno", "tempo parziale", "solo la mattina", "solo il giovedì"]], validation:["immediate", "optional", "string"]},
	
	
	{type:"combo", item:"Progetto", help:["list", "database", "project", "single", 1], validation:["immediate", "optional", "string"]},
	
	{type:"combo", item:"Ruolo_Progetto", label:"Ruolo progetto", skip:YES, position:300, help:["list", "table", "project_roles", "single"],  validation:["immediate", "optional", "string"]},
	
		
//------------------------------------------------------------------------------
	{type:"section", item:"Note"},
	
	{type:"field", item:"Note", label:"Note", length:400},
	
//------------------------------------------------------------------------------
	{type:"section", item:"Censito nelle liste"},
	
	{type:"array", item:"lists", label:"Liste", length:400, help:["list", "database", "employeelists", "multiple", 1], validation:["immediate", "optional", "string"]}

];




// =============================================================================
// CONTATTI
// =============================================================================

contactFormTemplate = [

	{type:"section", item:"Contatto Precedente", controlsFields:["Contatto Precedente", "Storia", "Suggerimenti"]}, 
		
	{type:"field", item:"Storia", label:"Storia", length:700, outputOnly:YES},
	
	{type:"field", item:"Suggerimenti", label:"Suggerimenti", length:700, outputOnly:YES},
		
//------------------------------------------------------------------------------

	{type:"section", item:"Dettagli Contatto Attuale"},
	
	{type:"combo", item:"Stato", label:"Stato", length:100, help:["list", "inline", ["pianificato", "effettuato"], "single"], validation:["immediate", "required", "string"], initial:"effettuato"},

	{type:"combo", item:"Persona_Contattata", label:"Persona Contattata", length:180, help:["list", "database", "person", "single", 3], validation:["immediate", "required", "string"]},
	
	{type:"combo", item:"Azienda_Contattata", label:"Azienda Contattata", length:180, skip:YES, position: 320, help:["list", "database", "company", "single", 3], validation:["immediate", "optional", "string"]},

		
	{type:"combo", item:"Collaboratore", label:"Collaboratore", length:180, help:["list", "database", "employee", "single", 1], validation:["immediate", "optional", "string"]},
	
	{type:"combo", item:"Persona_Referente", label:"Persona che riferisce", length:180, skip:YES, position: 320, help:["list", "database", "person", "single", 3], validation:["immediate", "optional", "string"]},
	
	
	{type:"date", item:"Data_del_Contatto", label:"Data Contatto", length:100, placeholder:"gg mmm aaaa" , enhance:YES, validation:["immediate", "optional", "date"]},
	
	{type:"combo", item:"Forma_del_Contatto", label:"Forma Contatto",  length:100, skip:YES, position: 320, help:["list", "inline", ["incontro", "telefonata", "lettera", "eMail"]], validation:["immediate", "optional", "string"]},
		
	{type:"field", item:"Esito_Contatto", label:"Esito", length:500, validation:["immediate", "optional", "string"]},
	
			
	{type:"amount", item:"Importo_Donazione", label:"Importo Donazione", length:80, enhance:YES, validation:["immediate", "optional", "amount"]},
	
	{type:"array", item:"lists", label:"Censito nelle liste", length:500, help:["list", "database", "contactlists", "single", 1], validation:["immediate", "optional", "string"]},

//------------------------------------------------------------------------------
// QUI QUI QUI
// --------------
	
	{type:"section", item:"Next_Contact", label:"Memorizza contatto successivo", checkBox:YES, initial:"false", controlsFields:["Next_Data_del_Contatto", "Next_Forma_del_Contatto", "Next_Persona_Contattata", "Next_Collaboratore", "Next_Suggerimenti"]},
	
	
	
	//{type:"combo", item:"Memorizza contatto successivo SYNC", label:"Switch", length:100, skip:YES, position: 320, initial:"false", help:["list", "inline", ["true", "false"]], validation:["immediate", "optional", "string"]},

	{type:"date", item:"Next_Data_del_Contatto", label:"Data Prossima", length:100, placeholder:"gg mmm aaaa" , enhance:YES, validation:["immediate", "optional", "date"]},
	
	{type:"combo", item:"Next_Forma_del_Contatto", label:"Forma Contatto", length:100, skip:YES, position: 320, help:["list", "inline", ["incontro", "telefonata", "lettera", "eMail"]], validation:["immediate", "optional", "string"]},
	
	{type:"combo", item:"Next_Persona_Contattata", label:"Persona da Contattare", length:180, help:["list", "database", "person", "single", 3], validation:["immediate", "required", "string"]},
	
	{type:"combo", item:"Next_Collaboratore", label:"Collaboratore", length:250, help:["list", "database", "employee", "single", 1], validation:["immediate", "optional", "string"]},
			

		
	{type:"field", item:"Next_Suggerimenti", label:"Note", length:500, validation:["immediate", "optional", "string"]}


];
	
	

