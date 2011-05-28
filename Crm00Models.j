// -----------------------------------------------------------------------------
//  Crm00Models.j
//  RoACrm01
//
// 	Created by Bruno Ronchetti on May 13, 2010.
// 	Copyright 2010, Ronchetti & Associati All rights reserved.
// -----------------------------------------------------------------------------

@import <Foundation/CPObject.j>


@implementation Crm00Models : CPObject
{
	CPString		id	nowDate;
	CPString		id	nowTime;
	JSObject		id 	aDoc;
	CPString		id	savedForeignKey;	
}


-(void)init
{	
	self = [super init];
	if (self)
	{
		var nowDate = new Date().toLocaleDateString();
		var nowTime = new Date().toLocaleTimeString().substring(0,8).replace(/\./g,":");
		
		//alert(nowTime);
		var aDoc = new Object();
		var savedForeignKey = "";
		return self;
	}
}

-(id)writeDocFromGlobalSavedDictionary
{
	//alert("in writeDocFromGlobalSavedDictionary");
	//alert("in writeDocFromGlobalSavedDictionary "+[KKRoATheDocsToBeWritten count] );
	for (var i=0; i<[KKRoATheDocsToBeWritten count]; i++)
	{
		var theDictionary = [CPDictionary dictionaryWithDictionary:KKRoATheDocsToBeWritten[i]];
		//alert("in writeDocFromGlobalSavedDictionary il dizionario e "+theDictionary);
		var writeData = [self writeDocFromDictionary:theDictionary];
		//listProperties (writeData, "writedata iterazione "+i)
		if (writeData["error"])
			break;
	}
	return writeData;
}


-(JSObject)writeDocFromDictionary:(CPDictionary)aDictionary
{
	var theDictionary = [CPDictionary dictionaryWithDictionary:aDictionary];

	var JSDoc = new Object();
	var allKeys = [theDictionary allKeys];
	
	for (var i=0; i<[allKeys count]; i++)
	{
		var property = allKeys[i];
		var objectValue = [theDictionary objectForKey:property];
		//alert(property+" "+objectValue);
		
		if (objectValue)
		{
			JSDoc[property] = objectValue;
		}
	}
	var writeData = [self writeDoc:JSDoc];
	return writeData;
}


-(JSObject)writeDoc:(JSObject)aJSDoc
{
	var aDoc = aJSDoc;
	//listProperties(aDoc, "aDoc dentro a writeDoc");	
	
	if ( aDoc["_rev"] == undefined)
	{
		//alert("nuovo record");
		aDoc["domain"] = KKRoAUserDomain;
		aDoc["type"] = KKRoAType;		
		aDoc["meta"] = new Object();
		aDoc["meta"]["isValid"] = true;
		aDoc["meta"]["created_on"] = nowDate;
		aDoc["meta"]["created_at"] = nowTime;
		aDoc["meta"]["created_by"] = KKRoAUserExternalName;
		aDoc["meta"]["modified_on"] = nowDate;
		aDoc["meta"]["modified_at"] = nowTime;
		aDoc["meta"]["modified_by"] = KKRoAUserExternalName;
		
		
		if ( aDoc["_id"] == undefined)
		{		
			var key = generateUid();
			aDoc["_id"] = key;
		}
	}
	else
	{
		//alert("record da aggiornare "+aDoc["_rev"]);		
		//aDoc["meta"]["isValid"] = true;
		aDoc["meta"]["modified_on"] = nowDate;
		aDoc["meta"]["modified_at"] = nowTime;
		aDoc["meta"]["modified_by"] = KKRoAUserExternalName;
	}
	
		
	var writeStandardRecord = new Object();
	writeStandardRecord["action"] = "writeDoc";
	writeStandardRecord["key"] = "documents/"+aDoc["_id"];
	writeStandardRecord["body"] = aDoc;
	
	//alert("CONTROLLO CONTROLLO  A "+aDoc["_id"]+ "   "+writeStandardRecord["key"]);
	//listProperties(aDoc, "CONTROLLO CONTROLLO  A");
	//listProperties(aDoc["meta"], "CONTROLLO CONTROLLO  A META");
	var writeData = [[RoACouchModule alloc] initWithRequest:writeStandardRecord executeSynchronously:1];
	return writeData;
}



-(id)deleteDocFromGlobalSavedDictionary
{
	//FIXME only deletes the first record in the array for the time being
	//
	var theDictionary = [CPDictionary dictionaryWithDictionary:KKRoATheDocsToBeWritten[0]];
	var JSDoc = new Object();
	var allKeys = [theDictionary allKeys];
	
	for (var i=0; i<[allKeys count]; i++)
	{
		var property = allKeys[i];
		var objectValue = [theDictionary objectForKey:property];		
		if (objectValue)
		{
			JSDoc[property] = objectValue;
		}
	}
	
	JSDoc["meta"]["isValid"] = false;
	JSDoc["meta"]["modified_on"] = nowDate;
	JSDoc["meta"]["modified_by"] = KKRoAUserExternalName;
	
	var deleteDoc = new Object();
	deleteDoc["action"] = "writeDoc";
	deleteDoc["key"] = "documents/"+JSDoc["_id"];
	deleteDoc["body"] = JSDoc;
	
	var writeData = [[RoACouchModule alloc] initWithRequest:deleteDoc executeSynchronously:1];
	return writeData;
}

@end