//
//  couchdbViews
//  
//
//  Created by Bruno Ronchetti on 11/02/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

// ============= docs_by_foreign_key =============
function(doc)
{
  if (doc.meta.isValid == false)
    return;
	
  if (doc.domain && doc.type && doc.Foreign_Key)
  {
    emit([doc.domain, doc.type, doc.Foreign_Key], doc);
  }
}


// ============= docs_by_list =============
function(doc) 
{
  if (doc.meta.isValid == false)
    return;

  var monthTranslator = {"gennaio":"jan", "febbraio":"feb", "marzo":"mar","aprile":"apr",
			"maggio":"may", "giugno":"jun", "luglio":"jul", "agosto":"aug",
			"settembre":"sep", "ottobre":"oct", "novembre":"nov", "dicembre":"dec"};

  var dateModifiedKey = doc.meta.modified_on;
  if (doc.meta.modified_on == "")
    var dateModifiedKey = doc.meta.created_on;
  if (doc.Data_del_Contatto)
    var dateModifiedKey = doc.Data_del_Contatto;

  var dateComponents = dateModifiedKey.split(" ");
  dateComponents[1] = monthTranslator[dateComponents[1]];
  var dateInNormalOrder = + Date.parse(dateComponents.join(" "));
  var dateInInverseOrder = - Date.parse(dateComponents.join(" "));
 
  if (doc.domain && doc.type && doc.Foreign_Key && doc.type != "contact")
  {
    var presentationKey = doc.Foreign_Key.substr(0, 1).toUpperCase();
    var orderKey = doc.Foreign_Key.substr(0, 20).toUpperCase();

    if (doc.Cognome)
    {
      var presentationKey = doc.Cognome.substr(0, 1).toUpperCase();
      var orderKey = doc.Cognome.substr(0, 20).toUpperCase();
    }

    emit([doc.domain, doc.type, "Tutti", orderKey], [presentationKey, doc.Foreign_Key]);
    emit([doc.domain, doc.type, "Modificati", dateInInverseOrder, orderKey], [dateModifiedKey, doc.Foreign_Key]);
    for (var i in doc.lists)
    {
      emit([doc.domain, doc.type, doc.lists[i], orderKey], [presentationKey, doc.Foreign_Key]);
    }
  }

  if (doc.domain && doc.type && doc.type == "contact")
  {
    var orderKey = doc.Data_del_Contatto;
    var presentationKey = doc.Cognome_Persona_Contattata.substr(0, 1).toUpperCase();

    var date = doc.Data_del_Contatto;
    var employee = "non specificato";
    var time = doc.meta.modified_at.substring(0,5);

    if (doc.Collaboratore)
    {
      var employee = doc.Collaboratore;
    }
    var person = doc.Persona_Contattata;

    emit([doc.domain, doc.type, "Tutti", orderKey], [presentationKey, doc.Persona_Contattata]);

    if (doc.Stato == "effettuato")
    {
   	 emit([doc.domain, doc.type, "Effettuati - per data", dateInInverseOrder], [date, [employee, person+" "+time]]);
   	 emit([doc.domain, doc.type, "Effettuati - per collab.", dateInInverseOrder], [employee, [date, person+" "+time]]);
    }

    if (doc.Stato == "pianificato")
    {
  	 emit([doc.domain, doc.type, "Pianificati - per data", dateInNormalOrder], [date, [employee, person+" "+time]]);
   	 emit([doc.domain, doc.type, "Pianificati - per collab.", dateInNormalOrder], [employee, [date, person+" "+time]])
    }

    for (var i in doc.lists)
    {
      emit([doc.domain, doc.type, doc.lists[i], orderKey], [presentationKey, person]);
    }
  }
}


// ============= docs_by_list_count =============
function(doc) 
{
  if (doc.meta.isValid == false)
    return;

  if (doc.domain && doc.type && doc.Foreign_Key && doc.type != "contact")
  {
    emit([doc.domain, doc.type, "Tutti"], 1);
    emit([doc.domain, doc.type, "Modificati"], 1);
    for (var i in doc.lists)
    {
      emit([doc.domain, doc.type, doc.lists[i]], 1);
    }
  }

  if (doc.domain && doc.type && doc.type == "contact")
  {
    emit([doc.domain, doc.type, "Tutti"], 1);

    if (doc.Stato == "effettuato")
    {
      emit([doc.domain, doc.type, "Effettuati - per data"], 1);
      emit([doc.domain, doc.type, "Effettuati - per collab."], 1);
    }

    if (doc.Stato == "pianificato")
    {
      emit([doc.domain, doc.type, "Pianificati - per data"], 1);
      emit([doc.domain, doc.type, "Pianificati - per collab."], 1);
    }
    
    for (var i in doc.lists)
    {
      emit([doc.domain, doc.type, doc.lists[i]], 1);
    }
  }

  if (doc.domain && doc.type && doc.type == "lists")
  {
    for (var i in doc.lists)
    {
      emit([doc.domain, doc.lists_for, doc.lists[i]], 0);
    }
  }
}

function(keys, values) {
   return sum(values);
}



// ============= lists_by_type =============
function(doc) 
{
  if (doc.meta.isValid == false)
    return;
	
  if (doc.domain && doc.type && doc.type == "lists" )
  {
    emit([doc.domain, doc.lists_for], doc);
  }
}


// ============= docs_by_initials =============
function(doc)
{
  if (doc.meta.isValid == false)
    return;


  if (doc.domain && doc.type && doc.Foreign_Key && doc.type != "lists")
  {
    var words = doc.Foreign_Key.split(" ");
    for (var i=0; i<words.length; i++)
    {
      emit([doc.domain, doc.type, words[i].toLowerCase()], doc.Foreign_Key);
    }
    
    if (doc.Cognome)
    {
      //emit([doc.domain, doc.type, doc.Cognome.toLowerCase()], doc.Foreign_Key);
    }
  }

  if (doc.domain && doc.type && doc.type == "lists")
  {
    for (var i=0; i<doc.lists.length; i++)
    {
      var listName = doc.lists[i][0];
      emit([doc.domain, doc.lists_for+"lists", listName], doc.lists[i].reverse());
    }
  }
}


// ============= persons_by_entity =============
function(doc) 
{
  if (doc.meta.isValid == false)
    return;
	
if (doc.type && doc.Storia_Professionale && doc.type == "person" )
  {
    for (var i=0; i<doc.Storia_Professionale.length; i++)
    {
      var employment = doc.Storia_Professionale[i];
      var company = employment["Azienda"];
      var role = employment["Ruolo_Azienda"];
      emit([doc.domain, "company", company], {"Ruolo":role, "Persona":doc.Foreign_Key, "_id":doc._id});
    }
  }

if (doc.type && doc.Collaborazioni && doc.type == "person" )
  {
   for (var i=0; i<doc.Collaborazioni.length; i++)
    {
      var employment = doc.Collaborazioni[i];
      var organization = employment["Organizzazione"];
      var role = employment["Ruolo_No_Profit"];
      emit([doc.domain, "non_profit_organization", organization], {"Ruolo":role, "Persona":doc.Foreign_Key, "_id":doc._id});
    }  
  }
}


// ============= contacts_by_entity =============
function(doc) 
{
  if (doc.meta.isValid == false)
    return;
	
if (doc.type && doc.type == "contact" )
  {
      if (doc.Stato == "effettuato")
      {
        var memo = doc.Esito_Contatto;
      }
      else
      {
        var memo = doc.Storia;
      }

      var valueObject = {
	"Stato":doc.Stato,
	"Data_del_Contatto": doc.Data_del_Contatto,
	"Forma_del_Contatto":doc.Forma_del_Contatto,
	"Persona_Contattata":doc.Persona_Contattata,
	"Azienda_Contattata":doc.Azienda_Contattata,
	"Esito/Note":memo
      }

      if (doc.Persona_Contattata)
        emit([doc.domain, "person", doc.Persona_Contattata], valueObject);

      if (doc.Azienda_Contattata)
        emit([doc.domain, "company", doc.Azienda_Contattata], valueObject);

      if (doc.Azienda_Contattata)
        emit([doc.domain, "employee", doc.Collaboratore], valueObject);

  }

}

// ============= projects_by_entity =============
function(doc) 
{
  if (doc.meta.isValid == false)
    return;
	
if (doc.type && doc.Partecipanti && doc.type == "project" )
  {
    for (var i=0; i<doc.Partecipanti.length; i++)
    {
      var collaboration = doc.Partecipanti[i];
      var person = collaboration["Persona"];
      var company = collaboration["Azienda"];
      var non_profit_organization = collaboration["No_Profit"];

      var role = collaboration["Ruolo"];
      var inizio = collaboration["Data_Inizio"];
      var fine = collaboration["Data_Fine"];

      if (person)
        emit([doc.domain, "person", person], {"Progetto": doc.Denominazione, "Ruolo":role, "Data Inizio":inizio, "Data Fine":fine});
      if (company)
        emit([doc.domain, "company", company], {"Progetto": doc.Denominazione, "Ruolo":role, "Data Inizio":inizio, "Data Fine":fine});
      if (non_profit_organization)
        emit([doc.domain, "non_profit_organization", non_profit_organization], {"Progetto": doc.Denominazione, "Ruolo":role, "Data_Inizio":inizio, "Data Fine":fine});
    }
  }

}
