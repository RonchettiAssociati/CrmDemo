// -----------------------------------------------------------------------------
//  Crm01Controller.j
//  RoACrm
//
// 	Created by Bruno Ronchetti on May 13, 2010.
// 	Copyright 2010, Ronchetti & Associati All rights reserved.
// -----------------------------------------------------------------------------


@import <Foundation/CPObject.j>
@import <RoAKit/ThirdParty/sha1.j>

@import "Crm0101View.j"
@import "Crm0102View.j"
@import "Crm0103View.j"
@import "Crm0104View.j"


@implementation Crm01Controller : CPObject
{
	Crm0101View	id crm0101View;
	Crm0102View	id crm0102View;
	Crm0103View	id crm0103View	@accessors;
	Crm0104View	id crm0104View	@accessors;
	
	CPObject	id userData;
	CPDictionary	id	userDataDictionary;
}


-(void)init
{	
	self = [super init];
	if (self)
	{
		//crm01Controller = self;
		
		// ---------------------------------------------------------------------
		// Geometry 
		//
		var contentViewWidth = [contentView frame].size.width;
		var contentViewHeight = [contentView frame].size.height;
				
		var view01Frame = CGRectMake(5.0, KKRoAY0+10 , KKRoAX1-10, contentViewHeight-KKRoAY0-15);
		var crm0101View = [[Crm0101View alloc] initWithFrame:view01Frame];

		var view02Frame = CGRectMake(5.0, KKRoAY0+10 , KKRoAX1-10, contentViewHeight-KKRoAY0-15);
		var crm0102View = [[Crm0102View alloc] initWithFrame:view02Frame];
		[crm0102View setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];

		var view03Frame = CGRectMake(5.0, KKRoAY0+10 , contentViewWidth, contentViewHeight-KKRoAY0);
		var crm0103View = [[Crm0103View alloc] initWithFrame:view03Frame];
		[crm0103View setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];

		var view04Frame = CGRectMake(5.0, KKRoAY0+10 , contentViewWidth, contentViewHeight-KKRoAY0);
		var crm0104View = [[Crm0104View alloc] initWithFrame:view03Frame];
		[crm0104View setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
						
		var appNotificationCenter = [CPNotificationCenter defaultCenter];
		[appNotificationCenter addObserver:self selector:"navigation:" name:null object:@"Crm01Navigation"];
		
		[crm0101View initialize];
		
		return self;
	}
}


-(void)navigation:(CPNotification)aNotification
{
	if ([aNotification object] === @"Crm01Navigation")
	{	
		switch ([aNotification name])
		{
			case "appDidLaunch":	
				[self initialDisplay];
				break;
						
			case "didMenuSelection":
			case "didActivatePrintMode":	
				[crm0101View removeFromSuperview];
				[crm0102View removeFromSuperview];
				[crm0103View removeFromSuperview];
				[crm0104View removeFromSuperview];
				break;
										
			case "didLogout":
				[crm0102View initialize];
				[crm0102View display];
				break;
						
			case "didRequestCopyright":
				[crm0103View initialize];
				[crm0103View displayForDocumentIndex:"copyright_index"];
				break;
				
			case "didRequestHelp":
				[crm0103View initialize];
				[crm0103View displayForDocumentIndex:"help_index"];
				break;

			case "didRequestPreferences":
				[crm0104View initialize];
				[crm0104View display:userData];
				break;
										
			case "didRequestGlobalSearch":
				[crm0103View removeFromSuperview];
				break;
					
			case "didChangeFormData":
				[crm0104View enableSaveButton];
				break;
				
			default: 
				break;
		}
	}
}


-(void)initialDisplay
{	
	//alert("prima");
	[crm0101View display];
}


-(void)backToLogin:(CPSender)aSender
{
	[crm0102View removeFromSuperview];
	[crm0101View display];
}	


-(void)login:(CPSender)aSender
{
	//alert("dentro");
	var memberName = [[crm0101View memberName] stringValue];
	var password = [[crm0101View password] stringValue];
	
	if ( memberName == ""  || password == "")
	{
		[crm0101View incompleteLogin];	
	}
	else
	{
		var key = memberName;
		var JSONKey = JSON.stringify(encodeURIComponent(key));
				
		var dataRequest = new Object();
		dataRequest["member"] = memberName;
		dataRequest["action"] = "readDoc";
		dataRequest["key"] = "documents/_design/users/_view/users?key="+JSONKey;

		var dataResponse = [[RoACouchModule alloc] initWithRequest:dataRequest executeSynchronously:YES];
		
		//alert(memberName+" "+ [dataResponse count]);

		if ([dataResponse count] == 1)
		{
			var userDataDictionary = [CPDictionary dictionaryWithJSObject:dataResponse[0]["value"]];
			
			var userData = new Object();
			var userData = dataResponse[0]["value"];
			var salt = userData["_id"];
			var passwordSha = hex_sha1(password+salt);
			
			//alert(passwordSha + " "+userData["password_sha"] );
			
			if ( passwordSha == userData["password_sha"])
			{
				[self validLogin:userData];
				[crm0101View validLogin:userData["user_name"]];
			}
			else
			{
				[crm0101View invalidLogin];
			}
		}
		else
		{
			[crm0101View invalidLogin];
		}
	}
}

-(void)validLogin:(JSObject)aUser
{	
	KKRoAUser = aUser["user_name"];
	KKRoAUserDomain = aUser["domain"];
	KKRoAUserLanguage = aUser["language"];
	KKRoAUserExternalName = aUser["Nome"]+" "+aUser["Cognome"];
	KKRoAUserPrivileges = aUser["privileges"];
	KKRoAFormPrivileges = aUser["privileges"];

	
	[Crm00Globals tailorGlobalsForUser];

	var appNotificationCenter = [CPNotificationCenter defaultCenter];
	[appNotificationCenter postNotificationName:@"didLogin" object:@"Crm01Navigation" userInfo:null];
}


-(void)invalidLogin
{

}

-(void)quitHelp:aSender
{
	[crm0103View removeFromSuperview];
	[crm02Controller restoreSavedViews:aSender];
}


-(void)quitPreferences:(CPSender)aSender
{
	[crm0104View removeFromSuperview];
	[crm02Controller restoreSavedViews:aSender];
}


-(void)savePreferences:(CPSender)aSender
{
	var screenDataHasErrors = [crm0104View validateScreenData];
	
	if (screenDataHasErrors)
	{
		return;
	}
	
	[self mergeFormData];
	
	var crm01Model = [[Crm00Models alloc] init];
	[crm01Model writeDoc:userData];
	
	KKRoAUser = userData["user_name"];
	KKRoAUserDomain = userData["domain"];
	KKRoAUserLanguage = userData["language"];
	KKRoAUserExternalName = userData["Nome"]+" "+userData["Cognome"];
	KKRoAUserPrivileges = userData["privileges"];
	
	[crm0104View removeFromSuperview];
	[crm02Controller quitPreferences:aSender];
}


-(void)mergeFormData
{
	// first merge screen data with saved database data
	//
	
	var formData = new Object();
	formData = [crm0104View getFormData];
			
	//alert("prima del merge cosa c'è in KKRoATheScreenDoc "+KKRoATheScreenDoc);
	for (var i in formData)
	{
		userData[i] = formData[i];
	}
}

@end

