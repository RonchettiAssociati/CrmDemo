/*
 * RoAFormField.j
 * RoACrm
 *
 * Created by You on April 14, 2010
 * Copyright 2010, Your Company All rights reserved.
 */


@import <Foundation/CPObject.j>
@import "RoAFormFieldHelp.j"
@import "RoAFormCalendar.j"
@import "RoAFormFieldValidator.j"


@implementation RoAFormField : CPView
{
	CPNotificationCenter 	id 	appNotificationCenter;

	CGPoint		id	theFieldOrigin;
	float		id	theFieldLength;
	CGSize		id	theFieldSize;
	CGPoint		id	theLabelOrigin;

	CPObject	id	theDescriptor;
			
	CPTextField id	theField	@accessors;
	CPTextField	id	theLabel;
	CPTextField	id	theError;
	
	CPObject	id	userInfo;
	
	CPView		id	targetView @accessors;
	BOOL		id	isDeletingBackwards	@accessors;
	
	CPObject 	id	theCompletionDelegate;
}

-(void)initWithDescriptor:(CPObject)aDescriptor atYPosition:(float)aYPosition
{
	self = [super init];
	
	if (self)
	{
		var appNotificationCenter = [CPNotificationCenter defaultCenter];
		[appNotificationCenter addObserver:self selector:"navigation:" name:nil object:@"Crm01Navigation"];	
		
		isDeletingBackwards = false;
		
		var theDescriptor = aDescriptor;
		[self setTag:theDescriptor["item"]];
		
		var theYPosition = aYPosition;
		var theXPosition = (theDescriptor["position"]) ? theDescriptor["position"]+ 130 : 130;
		var theFieldLength = (theDescriptor["length"]) ? theDescriptor["length"] : 120;
		
		var theFieldOrigin = CGPointMake(theXPosition, theYPosition);
		var theFieldSize = CGSizeMake(theFieldLength, 26.0);
		
		var theLabelOrigin = CGPointMake(theXPosition- 130.0, theYPosition+ 8.0);
		
		[self initialize];
		return self;
	}
}

// FIXME metodo introdotto per compatibilià - 
// usato in crm0101view e dove si vuole usare un campo solo con pulldown
// eliminare appena possibile
-(void)initWithLabelString:(CPString)aLabelString
{
	var theDummyDescriptor = new Object();
	theDummyDescriptor["type"] = "field";
	theDummyDescriptor["item"] = "dummy";
	
	self = [self initWithDescriptor:theDummyDescriptor atYPosition:0];
	return self;
}


-(void)navigation:(CPNotification)aNotification
{
	if ([aNotification object] === @"Crm01Navigation" && [aNotification userInfo] && [aNotification userInfo]["field"] === self)
	{
		//alert("in navigation del field "+[aNotification name]+" "+[aNotification userInfo]["field"]);
		switch ([aNotification name])
		{			
			case "helpDidSelectValueForField":
				var newFieldValue = [theField stringValue];
				if (theDescriptor["help"][3] != "multiple")
				{
					newFieldValue = "";
				}
				else
				{
					if (newFieldValue != "")
					{
						newFieldValue = [theField stringValue]+", ";
					}
				}
				newFieldValue = newFieldValue + userInfo["selectedHelpValue"];
				[theField setStringValue:newFieldValue];
				[theField selectAll:null];
				[self helpDidCompleteSelection];
				break;
				
			default:
				break;
		}
	}
}

-(void)initialize
{	
	var theLabelPosition = "before";

	var theField = [[RoAInputField alloc] initWithFrame:CGRectMakeZero()];
	[theField setFrameOrigin:theFieldOrigin];
	[theField setFrameSize:theFieldSize];
	[theField setTag:""];
	[theField setFont:KKRoAFieldFont];
	[theField setEditable:YES];
	[theField setSelectable:YES];
	[theField setBezeled:YES];
	[theField setDelegate:self];
			
	var theLabel = [[CPTextField alloc] initWithFrame:CGRectMakeZero()];
	[theLabel setFrameOrigin:theLabelOrigin];
	[theLabel setFrameSize:CGSizeMake(120.0, 26.0)];
	var labelString = (theDescriptor["label"]) ? theDescriptor["label"] : theDescriptor["item"];
	[theLabel setStringValue:labelString+ " :"];
	[theLabel setFont:KKRoALabelFont];
	[theLabel setTextColor:KKRoALabelColor];
	[theLabel setValue:CPRightTextAlignment forThemeAttribute:@"alignment"];
		
	var theError = [[CPTextField alloc] initWithFrame:CGRectMake(0.0, 0.0, 120.0, 16.0)];
	[theError setFrameOrigin:CGPointMake(theFieldOrigin.x+theFieldLength -50.0, theFieldOrigin.y -5.0)];
	[theError setEnabled:NO];
	[theError setFont:[CPFont boldSystemFontOfSize:10]];
	[theError setBackgroundColor:[CPColor redColor]];
	[theError setTextColor:[CPColor whiteColor]];
	[theError setStringValue:"Errore Errore Errore Errore"];
	[theError setHidden:YES];
	
	if (theDescriptor["hidden"] == YES)
		[self setHidden:YES];
	
	if (theDescriptor["initial"])
		[theField setStringValue:theDescriptor["initial"]];
	
	if (theDescriptor["outputOnly"] == YES)
		[self setOutputOnly:YES];
	
	if (theDescriptor["placeholder"])
		[self setPlaceholder:RoALocalized(theDescriptor["placeholder"])];
}


-(void)setOutputOnly:(BOOL)shouldBeOutputOnly
{	
	if (shouldBeOutputOnly == true) {
		[theField setEnabled:NO];
		[theField setEditable:NO];
		[theField setValue:KKRoABackgroundWhite forThemeAttribute:@"bezel-color"];
	}
	else {
		[theField setEnabled:YES];
		[theField setEditable:YES];
		[theField setValue:nil forThemeAttribute:@"bezel-color"];
	}
}


-(void)setDimmed:(BOOL)shouldBeDimmed
{	
	//alert("in setDimmed "+[theField tag]+" "+shouldBeDimmed);
	if (shouldBeDimmed == true) {
		[theField setTextColor:KKRoADimmedLabelColor];
		[theField setValue:KKRoABackgroundWhite forThemeAttribute:"text-color" inState:CPTextFieldStatePlaceholder];
		[theLabel setTextColor:KKRoADimmedLabelColor];
		[theField setSelectable:NO];
		[theField setEnabled:NO];
		[theField setEditable:NO];
	}
	else {
		[theField setTextColor:nil];
		[theField setValue:nil forThemeAttribute:"text-color" inState:CPTextFieldStatePlaceholder];
		[theLabel setTextColor:KKRoALabelColor];
		[theField setSelectable:YES];
		[theField setEnabled:YES];
		[theField setEditable:YES];
	}
}


-(void)setPlaceholder:(CPString)aPlaceHolderString
{	
	[theField setPlaceholderString:aPlaceHolderString];
}


-(void)setHidden:(BOOL)shouldBeHidden
{		
	[theField setHidden:shouldBeHidden];
	[theLabel setHidden:shouldBeHidden];
}



-(void)setScreenValue:(CPString)aValue
{	
	theField["externalValue"] = aValue;
	var theDisplayedValue = aValue;
	
	if (theDisplayedValue && theDisplayedValue != "") {
		switch (theDescriptor["type"])
		{
			case "date":
				var theDisplayedValue = Date.parse(theField["externalValue"]).toLocaleDateString();
				break;
						
			case "amount":
				//[theField setValue:CPRightTextAlignment forThemeAttribute:@"alignment"];
				var theDisplayedValue = theField["externalValue"]/100;
				theDisplayedValue = theDisplayedValue.toString().replace(".", ",");
				theDisplayedValue = theDisplayedValue.toString().replace(/\B(?=(?:\d{3})+(?!\d))/g, " ");
				break;
						
			case "array":
				var theDisplayedValue = [theField["externalValue"] componentsJoinedByString:", "];
				break;
						
			default: break;
		}
	}
		
	theField["savedScreenValue"] = theDisplayedValue;
	[theField setStringValue:theDisplayedValue];	
}


-(void)getScreenValue
{	
	//alert("IN GETSCREENVALUE DENTRO DENTRO DENTRO "+theDescriptor["item"]+" "+theDescriptor["type"]);

	var theScreenValue = "";
	
	if (theDescriptor["outputOnly"] == YES)
	{
		//alert("è un campo outputonly ");
		return "";
	}
	
	if ([theField stringValue] != null)
	{	
		var theScreenValue = [theField stringValue];
	}

	
	if (theScreenValue && theScreenValue != "")
	{
		switch (theDescriptor["type"])
		{
			case "date":
						theScreenValue = Date.parse(theScreenValue).toLocaleDateString();
						return theScreenValue;
						break;
						
			case "amount":
						theScreenValue = theScreenValue.toString().replace(/[ ]/g, "");
						theScreenValue = theScreenValue.toString().replace(",", ".");
						theScreenValue = theScreenValue*100;
						return theScreenValue;
						break;
						
			case "array":
						var theScreenValuesArray = [];
						theScreenValuesArray = [theScreenValue componentsSeparatedByString:","];
						for (var i=0; i<[theScreenValuesArray count]; i++)
						{
							theScreenValuesArray[i] = [theScreenValuesArray[i] stringByTrimmingWhitespace];
						}
						//alert(["quando getscreenValue di un array "+[theScreenValuesArray class] className]);
						return theScreenValuesArray;
						break;
						
			default: 
						return theScreenValue;
						break;
		}
	}
	//return theScreenValue;
}


-(void)setTargetView:(CPView)aTargetView withAnchor:(CPView)anAnchorView
{
	var targetView = aTargetView;
	var anchorView = anAnchorView;
	
	[targetView addSubview:theField positioned:CPWindowBelow relativeTo:anchorView];
	[targetView addSubview:theError positioned:CPWindowAbove relativeTo:anchorView];

	if ([theLabel stringValue] != "undefined :")
		[targetView addSubview:theLabel positioned:CPWindowBelow relativeTo:anchorView];
}


-(void)setCompletionDelegate:(CPObject)aDelegate
{
	var theCompletionDelegate = aDelegate;
}

//
// =============================================================================
//


-(void)helpDidCompleteSelection
{
	[targetView formDidChange];
	
	if (theCompletionDelegate && [theCompletionDelegate respondsToSelector:@selector(didCompleteSelection:)])
	{
		[theCompletionDelegate didCompleteSelection:[theField stringValue]]; 
	}
}


//
// =============================================================================
//


-(void)validateNow
{	
	if (!theDescriptor["validate"])
		return;
		
	if ([theField stringValue] == "" && [theDescriptor["validate"] containsObject:"required"] == false)
		return;
		
	if ([theField stringValue] == self.savedScreenValue)
		return;
		
	var validationResult = [[RoAFormFieldValidator alloc] validate:[theField stringValue] forDescriptor:theDescriptor["validate"]];
			
	if (validationResult === "no error")
	{
		[theField setTextColor:[CPColor blackColor]];
		[theLabel setTextColor:KKRoALabelColor];
		[theError setHidden:YES];
	}
	else
	{
		[self showError:validationResult];
	}	
}


-(void)showError:(CPString)aValidationResult
{
		[theError setStringValue:aValidationResult];
		[theError sizeToFit];
		[theField setTextColor:[CPColor redColor]];
		[theLabel setTextColor:[CPColor redColor]];
		[theError setHidden:NO];
}

//
// =============================================================================
//

-(void)enhanceIfNeeded
{
	if (theDescriptor["enhance"] && [theField stringValue] != "")
	{
		var rawValue = [theField stringValue];
		switch (theDescriptor["type"])
		{
			case "date":
				if (Date.parse(rawValue))
				{
					var noonOfTheDay = Date.parse(rawValue).addHours(12);
					//alert (noonOfTheDay);
					[theField setStringValue:Date.parse(noonOfTheDay).toLocaleDateString()];
				}
				break;
				
			case "amount":
				[theField setStringValue:rawValue.toString().replace(/\B(?=(?:\d{3})+(?!\d))/g, " ")];
				break;
				
			default:
				break;
		}
	}
}



-(void)textDidFocus:(CPNotification)aNotification
{
	if ([aNotification object] !== theField)
		return;	
		
	var userInfo = [CPObject new];
	if (theDescriptor["help"])
	{
		userInfo["helpNeeded"] = YES;
		userInfo["field"] = self;
		userInfo["superview"] = targetView;
		userInfo["targetView"] = targetView;
		userInfo["cellFrame"] = [theField frame];
		userInfo["helpArray"] = [CPArray arrayWithArray:theDescriptor["help"]];
		userInfo["fieldStringValue"] = [theField stringValue];
		userInfo["isDeletingBackwards"] = isDeletingBackwards;
	}
	[appNotificationCenter postNotificationName:@"didBeginFieldEdit" object:@"Crm01Navigation" userInfo:userInfo];
}


-(void)controlTextDidChange:(CPNotification)aNotification
{
	[targetView formDidChange];
			
	if ([aNotification object] === theField && theDescriptor["help"])
	{
		userInfo["fieldStringValue"] = [theField stringValue];
		userInfo["isDeletingBackwards"] = isDeletingBackwards;
		[appNotificationCenter postNotificationName:@"didChangeFieldEdit" object:@"Crm01Navigation" userInfo:userInfo];
	}
}

-(void)textDidEndEditing:(CPNotification)aNotification
{
	[self enhanceIfNeeded];
	[self validateNow];
}


-(void)keyDown:(CPEvent)anEvent
{
	isDeletingBackwards = false;

	if ([anEvent keyCode] == 8)
	{
		isDeletingBackwards = true;
		[appHelpController helpDidDeleteBackwards];
		
	if (theDescriptor["help"])
		{
			[theField setStringValue:""];
		}
	}
		
	if ([anEvent keyCode] == 9 || [anEvent keyCode] == 13)
	{
		[appHelpController helpDidCompleteSelection];
	}
}


@end




//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//

@implementation RoAInputField : CPTextField
{
}

-(void)textDidEndEditing:(CPNotification)aNotification
{		
	[[self delegate] textDidEndEditing:aNotification];
}

-(void)textDidFocus:(CPNotification)aNotification
{
	[[self delegate] textDidFocus:aNotification];
}

-(void)keyDown:(CPEvent)anEvent
{
	[[self delegate] keyDown:anEvent];
	[super keyDown:anEvent];
}

@end



