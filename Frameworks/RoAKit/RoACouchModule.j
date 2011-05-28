// -----------------------------------------------------------------------------
// RoACouchModule.j
// RoACrm
//
// Created by Bruno Ronchetti on October 11, 2010.
// Copyright 2010, Ronchetti & Associati All rights reserved.
// -----------------------------------------------------------------------------


@import <Foundation/CPObject.j>
@import <RoAKit/ThirdParty/base64.js>

//@import <RoAKit/ThirdParty/couch.js>

// CONSTANTS
//




// IMPLEMENTATION
//
@implementation RoACouchModule : CPObject
{
}

-(void)initWithRequest:(JSObject)aDataRequest executeSynchronously:(BOOL)shouldExecuteSynchronously
{
	self = [super init];
	//listProperties(aDataRequest, "Richiesta arrivata a Couchdb");
	if (self)
	{
		switch (aDataRequest["action"])
		{
			case("readDoc"): 		var response = [self readDocs:aDataRequest];	break;
			case("writeDoc"):		var response = [self writeDocs:aDataRequest];	break;
			case("writeAttachment"):var response = [self writeAttachments:aDataRequest];	break;
			case("readAttachment"):	var response = [self readAttachment:aDataRequest];	break;
			case("updateDoc"): 		var response = [self writeDocs:aDataRequest];	break;
			case("deleteDoc"): 		var response = [self deleteDocs:aDataRequest];	break;
			default: 				console.log("RoACouchModule - bad request "+aDataRequest["action"]);
		}
	}
	return response;
}


-(void)readDocs:(JSObject)aDataRequest
{
		var baseURL = 	KKRoABaseURL;
		var member = 	encodeURIComponent(KKRoAUser);
		var action = 	aDataRequest["action"];		
		var key = 		encodeURIComponent("/"+KKRoADatabaseName+aDataRequest["key"]);
		
		var URL = baseURL + "?member="+member + "&action="+action + "&key="+key;
		var request = [CPURLRequest requestWithURL:URL];
		
		[request setValue:"text/plain;charset=UTF-8" 	forHTTPHeaderField:@"Content-Type"];
		[request setHTTPMethod:"GET"];
		
		//listProperties(request);
				
		var responseData = [CPURLConnection sendSynchronousRequest:request returningResponse:nil];
		
		//listProperties(responseData);
				
		var responseObject = [responseData._rawString objectFromJSON];
		
				
		if ( responseObject._id || ( responseObject.rows && [responseObject.rows count] >0 ) )
		{
			if (responseObject.rows)
			{
				return responseObject.rows;
			}
			else
			{
				return responseObject;
			}
		}
		else
		{
			return [];
		}
}


-(void)writeDocs:(JSObject)aDataRequest
{
		var baseURL = 	KKRoABaseURL;
		var member = 	encodeURIComponent(KKRoAUser);
		var action = 	aDataRequest["action"];
		var key = 		encodeURIComponent("/"+KKRoADatabaseName+aDataRequest["key"]);
		
		//alert("in roacouchmodule prima di stringify");
		//listProperties(aDataRequest["body"]["meta"], "prima meta");
		//listProperties(aDataRequest["body"]["Storia_Professionale"], "prima storia");
		
		var body = 		encodeURIComponent(JSON.stringify(aDataRequest["body"]));
		//var body = 		encodeURIComponent(aDataRequest["body"]);
		
		var URL = baseURL + "?member="+member + "&action="+action + "&key="+key +"&doc="+body;
		var request = [CPURLRequest requestWithURL:URL];
		
		[request setValue:"text/plain;charset=UTF-8" 	forHTTPHeaderField:@"Content-Type"];
		[request setHTTPMethod:"PUT"];
		
		//alert("in couchmodule writedocs "+URL);
		
		var responseData = [CPURLConnection sendSynchronousRequest:request returningResponse:nil];
		
		var responseObject = [responseData._rawString objectFromJSON];
		//listProperties(responseObject, "responseObject");
		
		if (responseObject.ok)								// succesfull write
		{
			//alert("Documento registrato");
			return	responseObject;
		}
		else
		{
			//alert("Attenzione - il documento NON è stato registrato");
			return	responseObject;
		}
}


-(void)writeAttachments:(JSObject)aDataRequest
{
		var baseURL = 	KKRoABaseURL;
		var member = 	encodeURIComponent(KKRoAUser);
		var action = 	aDataRequest["action"];
		var key = 		encodeURIComponent("/"+KKRoADatabaseName+aDataRequest["key"]);
		var body = 		JSON.stringify(aDataRequest["body"]);
		
		var URL = baseURL + "?member="+member + "&action="+action + "&key="+key +"&doc="+body;
		var request = [CPURLRequest requestWithURL:URL];
		
		[request setValue:"text/plain;charset=UTF-8" 	forHTTPHeaderField:@"Content-Type"];
		[request setHTTPMethod:"PUT"];
		
		var responseData = [CPURLConnection sendSynchronousRequest:request returningResponse:nil];
		
		var responseObject = [responseData._rawString objectFromJSON];
		//listProperties(responseObject, "responseObject");
				
		if (responseObject.ok)								// succesfull write
		{
			//alert("L'allegato è stato registrato");
			return	responseData;
		}
		else
		{
			//alert("Attenzione - L'allegato NON è stato registrato");
			return	responseData;
		}
}

-(void)readAttachment:(JSObject)aDataRequest
{
		var baseURL = 	KKRoABaseURL;
		var member = 	encodeURIComponent(KKRoAUser);
		var action = 	aDataRequest["action"];
		var key = 		encodeURIComponent("/"+KKRoADatabaseName+aDataRequest["key"]);
		//var body = 		JSON.stringify(aDataRequest["body"]);
		
		var URL = baseURL + "?member="+member + "&action="+action + "&key="+key;
		var request = [CPURLRequest requestWithURL:URL];
		
		[request setValue:"text/plain;charset=UTF-8" 	forHTTPHeaderField:@"Content-Type"];
		[request setHTTPMethod:"GET"];
		
		//listProperties(request, "request");
		var responseData = [CPURLConnection sendSynchronousRequest:request returningResponse:nil];

		// FIXME settare il tipo in base al contenuto del file 
		// è già memorizzato nella risposta ma non so come prenderlo
		// alternativemnete dedurlo dal nome del file con una tabellina rovesciata rispetto a quella in RoAServer
		
		var filetype = aDataRequest["key"].substring([aDataRequest["key"] length]-4);

		switch (filetype)
		{
			case ".pdf":
				return "data:application/pdf;base64,"+responseData._rawString;
				break;
				
			case ".jpg":
				return "data:image/jpg;base64,"+responseData._rawString;
				break;
			
			default: break;
		}

}



-(void)deleteDocs:(JSObject)aDataRequest
{
		var baseURL = 	KKRoABaseURL;
		var member = 	encodeURIComponent(KKRoAUser);
		var action = 	aDataRequest["action"];		
		var key = 		encodeURIComponent("/"+KKRoADatabaseName+aDataRequest["key"]);
		var body = 		JSON.stringify(aDataRequest["body"]);
		
		var URL = baseURL + "?member="+member + "&action="+action + "&key="+key;
		var request = [CPURLRequest requestWithURL:URL];
		[request setValue:"text/plain;charset=UTF-8" 	forHTTPHeaderField:@"Content-Type"];
		[request setHTTPBody:body];
		[request setHTTPMethod:"PUT"];

		var responseData = [CPURLConnection sendSynchronousRequest:request returningResponse:nil];
		var responseObject = [responseData._rawString objectFromJSON];
		
		if (responseObject.ok)								// succesfull update
		{
			//alert("tutto bene");
			return	responseObject;
		}
		else
		{
			//alert("update non eseguito");
			return	responseObject;
		}
}



-(void)reloadData
{
	alert("relaodData of BRoCouchModule called but method empty  ");
}


@end

