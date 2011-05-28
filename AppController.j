// -----------------------------------------------------------------------------
// AppController.j
// RoACrm
//
// Created by Bruno Ronchetti on October 11, 2010.
// Copyright 2010, Ronchetti & Associati All rights reserved.
// -----------------------------------------------------------------------------

@import <Foundation/CPObject.j>
@import <RoAKit/RoACouchModule.j>
@import <RoAKit/RoAFormHelpController.j>


@import "Crm00Globals.j"
@import "Crm00Buttons.j"
@import "Crm00Views.j"

@import "Crm01Controller.j"
@import "Crm02Controller.j"
@import "Crm03Controller.j"
@import "Crm04Controller.j"
@import "Crm05Controller.j"
@import "Crm06Controller.j"
@import "Crm07Controller.j"
@import "Crm08Controller.j"
@import "Crm09Controller.j"
@import "Crm10Controller.j"
@import "Crm11Controller.j"


@implementation AppController : CPObject
{
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
    var theWindow = [[CPWindow alloc] initWithContentRect:CGRectMakeZero() styleMask:CPBorderlessBridgeWindowMask];
	
	// FIXME no way to constrain the browser window to a min size
	//
	[theWindow setAcceptsMouseMovedEvents:YES]
	[theWindow setAutorecalculatesKeyViewLoop:YES];

	contentView = [theWindow contentView];
	[contentView setBackgroundColor:KKRoAContentViewBackground];
	[contentView setPostsFrameChangedNotifications:YES];
	[contentView setAutoresizesSubviews:YES];
	
	var appNotificationCenter = [CPNotificationCenter defaultCenter];
	var appHelpController = [[RoAFormHelpController alloc] init];
		
	crm01Controller = [[Crm01Controller alloc] init];
	crm02Controller = [[Crm02Controller alloc] init];
	var crm03Controller = [[Crm03Controller alloc] init];
	var crm04Controller = [[Crm04Controller alloc] init];
	var crm05Controller = [[Crm05Controller alloc] init];
	var crm06Controller = [[Crm06Controller alloc] init];
	crm07Controller = [[Crm07Controller alloc] init];
	var crm08Controller = [[Crm08Controller alloc] init];
	var crm09Controller = [[Crm09Controller alloc] init];
	var crm10Controller = [[Crm10Controller alloc] init];
	var crm11Controller = [[Crm11Controller alloc] init];
	
	[appNotificationCenter postNotificationName:@"appDidLaunch" object:@"Crm01Navigation" userInfo:nil];
	
	while ([[[CPApplication sharedApplication] mainMenu] countOfItems]>0) 
	{ 
		[[[CPApplication sharedApplication] mainMenu] removeItemAtIndex:0]; 
	} 
	
	// FIXME messo qui allunga il delay di visualizzazione della prima videata
	[self setupTables];
	
    [theWindow orderFront:self];

}


-(void)setupTables
{
	var dataRequest = new Object();
	dataRequest["action"] = "readDoc";
	dataRequest["key"] = "templates/_design/tables/_view/all?descending=false";
	
	//listProperties(dataRequest);
	KKRoATables = [[RoACouchModule alloc] initWithRequest:dataRequest executeSynchronously:1];
	//listProperties(KKRoATables);
}

@end

// -------------------------------------------------------------------------


function listProperties(obj, objName) {
	var result = "";
	for (var i in obj) {
		result += objName + "." + i + "=" + obj[i] + "\n";
	}
	alert (result);
}

function listArray(array) {
	var result = "• ";
	for (var j =0; j<[array count]; j++)
	{
		var obj = array[j]; 
		for (var i in obj)
		{
			if (obj[i])
			{
				//var newString = [[CPString stringWithString:obj[i]] stringByPaddingToLength:20 withString:" " startingAtIndex:0];
				//result = result + i +": "+ newString+"  ";
				var newString = [CPString stringWithString:obj[i]];
				result = result +newString+", ";
			}
		}
		result = result +"\n• ";
	}
	return result.slice(0,-2);
}

function generateUid() {
	var uuid = "";
	for(var j = 0; j < 32; j++) {
		uuid += Math.floor(Math.random() * 0xF).toString(0xF);
	}
	var key = uuid.substring(0,8)+"-"+uuid.substring(8,12)+"-"+uuid.substring(12,16)+"-"+uuid.substring(16,20)+"-"+uuid.substring(20,32);
	return key;
}

function RoALocalized(stringObject) {
	if ( KKRoAStringDictionary[stringObject] && KKRoAStringDictionary[stringObject][KKRoAUserLanguage] ) {
		return KKRoAStringDictionary[stringObject][KKRoAUserLanguage];
	}
	else {
		return stringObject;
	}
}

function BRoLocalized(stringObject) {
	if ( KKRoAStringDictionary[stringObject] && KKRoAStringDictionary[stringObject][KKRoAUserLanguage] ) {
		return KKRoAStringDictionary[stringObject][KKRoAUserLanguage];
	}
	else {
		return stringObject;
	}
}
function amountDatabaseToScreen(databaseAmount) {
	var screenAmount = databaseAmount/100;
	screenAmount = screenAmount.toString().replace(".", ",");
	screenAmount = screenAmount.toString().replace(/\B(?=(?:\d{3})+(?!\d))/g, " ");
	return screenAmount;
}

function amountScreenToDatabase(screenAmount) {
	var databaseAmount  = screenAmount *100;
	return databaseAmount;
}