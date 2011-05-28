// -----------------------------------------------------------------------------
//  RoAFormView.j
//  RoACrm01
//
// 	Created by Bruno Ronchetti on May 13, 2010.
// 	Copyright 2010, Ronchetti & Associati All rights reserved.
// -----------------------------------------------------------------------------


@import <Foundation/CPObject.j>
@import <RoAKit/RoAFormSection.j>
@import <RoAKit/RoAFormField.j>
@import <RoAKit/RoAFormTable.j>


@implementation RoAFormView : CPView
{
	CPNotificationCenter 	id	appNotificationCenter;
	CPArray					id 	theFormTemplate;
	CPDictionary			id	inputFieldsDictionary	@accessors;
	
	CPView					id	theAnchorView			@accessors;
	CPDictionary			id	sectionControlCheckBoxes;
	CPArray					id	fieldsToDim;
	
	int						id	finalHeight				@accessors;
	CPString				id	firstResponderField;
}


-(void)initWithFrame:(CGRect)aFrame
{	
	self = [super initWithFrame:aFrame];
	if (self)
	{
		var inputFieldsDictionary = [CPDictionary dictionary];
		var KKRoAInitializedForms = [CPDictionary dictionary];

		
		//alert("in init "+[inputFieldsDictionary count]);
		var sectionControlCheckBoxes = [CPDictionary dictionary];
		var	fieldsToDim = [];
		
		var appNotificationCenter = [CPNotificationCenter defaultCenter];
		
		return self;
	}
}



-(void)prepareForm:(CPString)aFormIdentifier withTemplate:(CPArray)aFormTemplate
{
	//alert("all'inizio di prepareform "+aFormTemplate);
	//listProperties(aFormTemplate, "aFormTemplate");


	[self setTag: "formView per "+aFormIdentifier];
	var theFormTemplate = [CPArray arrayWithObjects:aFormTemplate count:[aFormTemplate count]];
	
	// The anchorView enables correct placement: inputField Views "below" it, help Views "above" it
	//
	theAnchorView = [[CPView alloc] initWithFrame:CGRectMake(1.0, 1.0, 10.0, 10.0)];
	//[theAnchorView setBackgroundColor:[CPColor redColor]];
	[self addSubview:theAnchorView];
		
	[inputFieldsDictionary removeAllObjects];			
	[self paintFormStartingFrom:0 upTo:[theFormTemplate count]];
	[self postProcessFields];
		
	[KKRoAInitializedForms setObject:self forKey:aFormIdentifier];
	
	//alert("alla fine di prepareform");
}


-(void)paintFormStartingFrom:(CPNumber)fromNumber upTo:(CPNumber)toNumber
{		
	var currentY = 0.0;
	var step = 26.0;
	
	var firstResponderField = "";

	//alert("IN PAINTFORM "+KKRoAUserPrivileges+ " "+KKRoAFormPrivileges);

	for (var i=fromNumber; i<toNumber; i++)
	{
		if (theFormTemplate[i]["skip"])
			currentY = currentY- step;
		
		if (KKRoAFormPrivileges != "pieni")
		{
			theFormTemplate[i]["outputOnly"] = YES;
			theFormTemplate[i]["allowInsert"] = NO;
		}
					
		switch (theFormTemplate[i]["type"])
		{
			case ("section"):
				currentY = currentY+ 5.0;
				var sectionHeader = [[RoAFormSection alloc] initWithDescriptor:theFormTemplate[i] atYPosition:currentY];
				[sectionHeader setTargetView:self withAnchor:theAnchorView];
				[inputFieldsDictionary setObject:sectionHeader forKey:theFormTemplate[i]["item"]];
				
				if (theFormTemplate[i]["checkBox"])
				{
					[sectionControlCheckBoxes setObject:theFormTemplate[i]["controlsFields"] forKey:[[sectionHeader checkBox] tag]];
				}
				currentY = currentY+ 2.0;
				currentY = currentY+ step;
				break;
							
			case ("table"):
				var formTable = [[RoAFormTable alloc] initWithDescriptor:theFormTemplate[i] atYPosition:currentY];
				[formTable setTargetView:self withAnchor:theAnchorView];
				[inputFieldsDictionary setObject:formTable forKey:theFormTemplate[i]["item"]];
				var tableHeight = theFormTemplate[i]["size"][1];
				currentY = currentY+ tableHeight;
				currentY = currentY+ step;
				break;
				
			default:
				var formField = [[RoAFormField alloc] initWithDescriptor:theFormTemplate[i] atYPosition:currentY];
				[formField setTargetView:self withAnchor:theAnchorView];
				[formField setCompletionDelegate:self];
				[inputFieldsDictionary setObject:formField forKey:theFormTemplate[i]["item"]];
				
				if (firstResponderField == "")
				{
					firstResponderField = theFormTemplate[i]["item"];
				}
				currentY = currentY+step;
				break;
		}
	}
	
	var finalHeight = currentY;
}


-(CPObject)fieldForField:(CPString)aFieldName
{
	return [[inputFieldsDictionary objectForKey:[aFieldName]] theField];
}

-(CPObject)formFieldForField:(CPString)aFieldName
{
	return [inputFieldsDictionary objectForKey:[aFieldName]];
}

-(CPObject)firstResponderField
{
	return [[inputFieldsDictionary objectForKey:firstResponderField] theField];
}

-(void)setFormIsOutputOnly:(BOOL)shouldBeOutputOnly
{
	var allFields = [inputFieldsDictionary allKeys];
	
	for (var i=0; i< [allFields count]; i++)
	{
		var formObject = [inputFieldsDictionary objectForKey:allFields[i]];
		if (formObject["isa"] != "RoAFormSection")
		{
			[formObject setOutputOnly:shouldBeOutputOnly];
		}
	}
}


-(void)setScreenValue:(CPString)aValue forField:(CPString)aFieldName
{
	var screenField = [inputFieldsDictionary objectForKey:[aFieldName]];
	[screenField setScreenValue:aValue];
}


-(CPString)getScreenValueForField:(CPString)aFieldName
{
	var screenField = [inputFieldsDictionary objectForKey:[aFieldName]];
	return [screenField getScreenValue];
}


-(void)postProcessFields
{
	var sectionsWithCheckBoxes = [sectionControlCheckBoxes allKeys];
	//alert ("in postProcessFields A "+sectionsWithCheckBoxes);

	for (var i=0; i<[sectionsWithCheckBoxes count]; i++)
	{		
		var section = [self formFieldForField:sectionsWithCheckBoxes[i]];
		var sectionName = [section tag];
		var sectionState = [[section checkBox] state];
		var itemsToDim = [CPArray arrayWithArray:[sectionControlCheckBoxes objectForKey:sectionName]];
			
		//alert ("in postProcessFields b "+[itemsToDim count]);

		for (var j=0; j<[itemsToDim count]; j++)
		{
			[[inputFieldsDictionary  objectForKey:itemsToDim[j]] setDimmed:(!sectionState)];
		}		

	}

}

-(void)checkBoxPressed:(CPSender)aSender
{
	//alert("arrivato "+sectionControlCheckBoxes);
	var checkBox = aSender;	
	var itemsToDim = [CPArray arrayWithArray:[sectionControlCheckBoxes objectForKey:[aSender tag]]];
	
	for (var i=0; i<[itemsToDim count]; i++)
	{
		[[inputFieldsDictionary  objectForKey:itemsToDim[i]] setDimmed: ! [aSender state]];
	}
}

-(void)formDidChange
{
	// FIXME we are in the kit here; so we cannot send messages with the application prefix
	//
	if (KKRoAFormDataHasChanged == false)
	{
		[appNotificationCenter postNotificationName:@"didChangeFormData" object:@"Crm01Navigation" userInfo:nil];
		KKRoAFormDataHasChanged = true;
	}
}


-(void)clearForm
{
	//alert("passa da clearform "+ [inputFieldsDictionary  allValues]);
	var inputFields = [inputFieldsDictionary  allValues];
	for (var i=0; i<[inputFields count]; i++) {
		[inputFields[i] setScreenValue:""];
	}
	//alert("alla fine di clearform");
}

-(void)setInitialValues
{
	//alert("passa da clearform "+ [inputFieldsDictionary  allValues]);
	var inputFields = [inputFieldsDictionary  allValues];
	for (var i=0; i<[inputFields count]; i++) {
		if (inputFields[i]["initialValue"])
		{
			[inputFields[i] setScreenValue:inputFields[i]["initialValue"]];
		}
	}
	[self postProcessFields];
	//alert("alla fine di clearform");
}


@end