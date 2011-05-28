/*
 * RoAFormSection.j
 * RoACrm
 *
 * Created by You on April 14, 2010
 * Copyright 2010, Your Company All rights reserved.
 */

@import <Foundation/CPObject.j>


@implementation RoAFormSection : CPView
{
	CPObject	id	theDescriptor;
	CPTextField	id	theSection;
	CPPoint		id	theSectionOrigin;
	CPNumber	id	theSectionLength;
	
	CPView		id 	targetView;
	CPView		id 	anchorView;
	CPString	id	theSectionString;
	CPCheckBox	id	checkBox;
}


-(void)initWithDescriptor:(CPObject)aDescriptor atYPosition:(float)aYPosition
{
	self = [super init];
	
	if (self)
	{
		var appNotificationCenter = [CPNotificationCenter defaultCenter];
		
		var theDescriptor = aDescriptor;

		var theYPosition = aYPosition;
		var theXPosition = (theDescriptor["position"]) ? theDescriptor["position"] : 10.0;
		
		var theSectionOrigin = CGPointMake(theXPosition, theYPosition+ 10.0);
		var theSectionLength = (theDescriptor["length"]) ? theDescriptor["length"] : 200.0;
		
		[self setFrameOrigin:CGPointMake(theXPosition, theYPosition)];
		[self setFrameSize:CGSizeMake(theSectionLength, 28.0)];
		
		[self initialize];
		return self;
	}
}


-(void)initialize
{
	var theSectionString = (theDescriptor["label"]) ? theDescriptor["label"] : theDescriptor["item"];
	
	var theSection = [[CPTextField alloc] initWithFrame:CGRectMakeZero()];
	[theSection setFrameOrigin:theSectionOrigin];
	[theSection setFrameSize:CGSizeMake(theSectionLength, 26.0)];
	[theSection setStringValue:RoALocalized(theSectionString) +"     "];
	[theSection sizeToFit];
	[theSection setFont:KKRoASectionFont];
	[theSection setTextColor:KKRoASectionColor];
	[theSection setEditable:NO];
	[theSection setSelectable:NO];
	[theSection setBezeled:NO];
	
	if (theDescriptor["level"])
	{
		[self setLevel:theDescriptor["level"]];
	}
	
	if (theDescriptor["checkBox"])
	{
		var checkbox = theDescriptor["item"];
		var controlledFields = theDescriptor["controlsFields"];
		
		[self addCheckBox];
				
		if (theDescriptor["initial"])
		{
			self["initialValue"] = theDescriptor["initial"];
		}
	}
}


-(void)setOrigin:(CGPoint)anOrigin
{
	theSectionOrigin = anOrigin;
	[theSection setFrameOrigin:theSectionOrigin];
}


-(void)setLength:(CPNum)aLength
{
	theSectionLength = aLength;	
	[theSection setFrameSize:CGSizeMake(theSectionLength, 26.0)];
}


-(void)setLevel:(CPNumber)aLevel
{	
	if (aLevel == 2) {
		[theSection setFrame:CGRectOffset([theSection frame], 5.0, -3,0)];
		[theSection setFont:KKRoASectionLevelFont];
	}
}


-(void)setTargetView:(CPView)aTargetView withAnchor:(CPView)anAnchorView
{
	var targetView = aTargetView;
	var	anchorView = anAnchorView;
	[targetView addSubview:theSection positioned:CPWindowBelow relativeTo:anchorView];
	
	if ([self checkBox])
	{
		[targetView addSubview:checkBox positioned:CPWindowBelow relativeTo:anchorView];
		[checkBox setTarget:aTargetView];
		[checkBox setAction:"checkBoxPressed:"];
	}
}


-(void)addCheckBox
{
	var checkBox = [[CPCheckBox alloc] initWithFrame:CGRectMakeZero()];
	[checkBox setTag:theDescriptor["item"]];
	[checkBox setFrameOrigin:CGPointMake(CGRectGetMaxX([theSection frame])+10, CGRectGetMinY([theSection frame])- 3.0)];
	[checkBox setFrameSize:CGSizeMake(20.0,20,0)];
	[checkBox setState:CPOnState];
}

-(id)checkBox
{
	return checkBox;
}

-(void)setScreenValue:(CPString)aValue
{
	if (!checkBox)
		return;
		
	var checkBoxState = (aValue == "true") ? CPOnState : CPOffState;
	[checkBox setState:checkBoxState];
}

-(void)getScreenValue
{
	if (!checkBox)
		return;
		
	var state = [checkBox state];
	var stateString = (state == 1) ? "true" : "false";
	return	stateString;
}

@end





