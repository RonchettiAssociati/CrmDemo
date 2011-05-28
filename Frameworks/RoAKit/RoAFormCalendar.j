/*
 * RoAFormCalendar.j
 * WktTest42
 *
 * Created by Bruno Ronchetti on February 03, 2010
 * Copyright 2009, Ronchetti & Associati.
 *
 */
 

@import <Foundation/CPDate.j>
@import <AppKit/CPView.j>
@import <AppKit/CPColor.j>


// CONSTANTS
//	


// IMPLEMENTATION
//
@implementation RoAFormCalendar: CPView
{
	CPDate 	id 	today;
	CPDate 	id	pivotDate;
	CPDate 	id	firstOfPivotMonth;
	CPDate 	id	firstOfFollowingMonth;
	CPDate	id	firstOfPrecedingMonth;
	CPArray	id	savedViews;
	CPObject 	sender;
	
	CPTextField		id	displayedMonth;
	RoAFormField	id 	targetFormField;
	CPTextField		id	targetInputField;
	CPView			id	ribbonView;
	RoAShadowView	id	shadowView;
	
	CGSize	id	buttonSize;
	float	id	width;
	float	id	height;
	float	id	tileWidth;
	float	id	tileHeight;
	float	id	borderWidth;
	CGRect	id	rect;
	
	CPArray	id	datesArray;
	CPArray	id	dayOfMonthButtonsArray;
	CPButton	id	previouslySelectedDay;
	CPView	id	ownTargetView;
	
	CPColor	id	previouslySelectedTextColor;
	CPColor	id	previouslySelectedBackgroundColor;
}

-(id)init
{
	self = [super init];
	if (self)
	{
		var tileWidth = 22;
		var tileHeight = 18;
		var borderWidth = 1;
		
		var width = 7*tileWidth+ 8*borderWidth;	
		var height = 6*tileHeight+ tileHeight+15;
		
		var buttonSize = CGSizeMake(18,18);
	
		var shadowView = [[RoAShadowView alloc] init];
		[self setBackgroundColor:KKRoABackgroundWhite];
		[self setAlphaValue:1];

		var ribbonView = [[CPView alloc] initWithFrame:CGRectMake(0.0, 0.0, width, tileHeight+ 9)];
		[ribbonView setBackgroundColor:KKRoARibbonBackground];
		[self addSubview:ribbonView];

		// Display 2 Navigation Buttons
		//
		
		var backButton = [[CPButton alloc] initWithFrame:CGRectMakeZero()];
		[backButton setFrameSize:buttonSize];
		[backButton setFrameOrigin:CGPointMake(0.0, 0.0)];
		[backButton setTitle:"<"];
		[backButton setTag:"backButton"];
		//[backButton setTextColor:KKRoAHighlightBlue];
		[backButton setValue:KKRoALabelColor forThemeAttribute:@"text-color" inState:CPThemeStateNormal];
		[backButton setValue:KKRoAHighlightBlue forThemeAttribute:@"text-color" inState:CPThemeStateHovered];
		[backButton setFont:[CPFont boldSystemFontOfSize:14]];
		[backButton setBordered:NO];
		[backButton setTarget:self];
		[backButton setAction:@selector(newMonth:)];
		[ribbonView addSubview:backButton];

		
		var forwardButton = [[CPButton alloc] initWithFrame:CGRectMakeZero()];
		[forwardButton setFrameSize:buttonSize];
		[forwardButton setFrameOrigin:CGPointMake(width- buttonSize.width, 0.0)];
		[forwardButton setTitle:">"];
		[forwardButton setTag:"forwardButton"];
		//[forwardButton setTextColor:KKRoAHighlightBlue];
		[forwardButton setValue:KKRoALabelColor forThemeAttribute:@"text-color" inState:CPThemeStateNormal];
		[forwardButton setValue:KKRoAHighlightBlue forThemeAttribute:@"text-color" inState:CPThemeStateHovered];			[forwardButton setFont:[CPFont boldSystemFontOfSize:14]];
		[forwardButton setBordered:NO];
		[forwardButton setTarget:self];
		[forwardButton setAction:@selector(newMonth:)];
		[ribbonView addSubview:forwardButton];
		
		// Display Widget Title, Days of the Week and Separator
		//
		
		var displayedMonth = [[CPTextField alloc] initWithFrame:CGRectMakeZero()];
		[displayedMonth setFrameSize:CGSizeMake(tileWidth*6, tileHeight+2)];
		[displayedMonth setCenter:CGPointMake(width/2, (tileHeight+2)/2)];
		[displayedMonth setTextColor:KKRoALabelColor];
		[displayedMonth setFont:[CPFont boldSystemFontOfSize:11]];
		//[displayedMonth setBackgroundColor:[CPColor colorWithPatternImage:tileImage]];
		[displayedMonth setAlignment:CPCenterTextAlignment];
		[ribbonView addSubview:displayedMonth];


		for (var i=0; i<7; i++)
		{
			var dayOfWeek = [[CPTextField alloc] initWithFrame:CGRectMake(i*tileWidth+(i+1),15,tileWidth,13)];
			[dayOfWeek setStringValue:Date.CultureInfo.abbreviatedDayNames[i]];
			[dayOfWeek setTextColor:KKRoALabelColor];
			[dayOfWeek setFont:[CPFont systemFontOfSize:9]];
			[dayOfWeek setAlignment:CPCenterTextAlignment];
			[ribbonView addSubview:dayOfWeek];
		}

		dayOfMonthButtonsArray = [];
		for (var i=0; i<6; i++)
		{
			for (var j=0; j<7; j++) 
			{
				var dayOfMonthButton = [[CPButton alloc] initWithFrame:CGRectMake(1+ j*(tileWidth+1), 29.0+ i*tileHeight, tileWidth,tileHeight)];
				[dayOfMonthButton setFont:[CPFont boldSystemFontOfSize:12]];
				[dayOfMonthButton setAlignment:CPCenterTextAlignment];
				[dayOfMonthButton setBordered:NO];
				[dayOfMonthButton setTarget:self];
				[dayOfMonthButton setAction:@selector(daySelected:)];
				[dayOfMonthButton setTag:(i*7+ j).toString()];
				
				[dayOfMonthButtonsArray insertObject:dayOfMonthButton atIndex:(i*7 +j)];
				[self addSubview:dayOfMonthButton];
			}
		}
		
		return self;
	}
}

-(void)xxxdisplayForField:(CPTextField)aFormField
{	
	var targetFormField = aFormField;
	var targetInputField = aFormField["theField"];
	var reqHelpType = aFormField["theHelpDescriptor"];
	
	[self prepareData:reqHelpType[2]];

	var aFrame = [targetInputField frame];
	
	var originX = aFrame.origin.x+2;
	var originY = aFrame.origin.y+aFrame.size.height;
	var rect = CGRectMake(originX, originY, width, 100);

	[self setFrame:rect];	
}


-(void)setHidden:(BOOL)shouldBeHidden
{
	[super setHidden:shouldBeHidden];
	var ownTargetView = [targetFormField targetView];

	if (shouldBeHidden == true)
	{
		[self removeFromSuperview];
		[shadowView removeFromSuperview];
	}
	else
	{
		//[shadowView drawShadowForView:self];
		[ownTargetView addSubview:self];
		[ownTargetView addSubview:shadowView positioned:CPWindowBelow relativeTo:self];
		
		//[[CPRunLoop currentRunLoop] limitDateForMode:CPDefaultRunLoopMode];
		//[CPApp setTarget:self selector:@selector(hideIfClickedOutside:) forNextEventMatchingMask:CPLeftMouseDownMask untilDate:nil inMode:nil dequeue:NO];
	}
}


/*
-(void)hideIfClickedOutside:(CPEvent)anEvent
{
	//alert("in clickedoutside "+[self isHidden]+" "+[self hitTest:[anEvent locationInWindow]]);
	if ([self isHidden] == true)
		return;
		
	var clickLocationInSuperviewCoord = [[self superview] convertPoint:[anEvent locationInWindow] fromView:[[self window] contentView]];
		
	if ([self hitTest:clickLocationInSuperviewCoord] == null)
	{
		[self setHidden:YES];
		[CPApp sendEvent:anEvent];	
	}
	else
	{
		[CPApp sendEvent:anEvent];	
	}
}
*/

-(void)prepareTreeForData:(CPArray)anArray
{
	
}

-(void)prepareData:(CPString)aDate
{	
	// Determine Key Dates
	//

	if (aDate == "today")
	{
		aDate = new Date();
	}
	
	var today 		= new Date();
	var pivotDate 	= new Date(aDate);
	var pivotMonth	= pivotDate.getMonth();
	
	var firstOfPivotMonth = new Date(pivotDate);
	firstOfPivotMonth.setDate(1);
	var weekdayOfFirstOfPivotMonth 	= firstOfPivotMonth.getDay();
	
	var firstOfFollowingMonth = new Date(firstOfPivotMonth);
	firstOfFollowingMonth.setMonth(pivotMonth+1);
	
	var firstOfPrecedingMonth = new Date(firstOfPivotMonth);
	firstOfPrecedingMonth.setMonth(pivotMonth-1);

	// Prepare 5 weeks of dates around the pivot date, starting with the monday 
	// preceding the first day of the month
	
	var datesArray = [];
	var anchorDate = new Date(firstOfPivotMonth.getTime());
	var calendarItem = new Date();
	var j= - weekdayOfFirstOfPivotMonth;
	var i = 42;
	
	for (var i=0; i<42; i++)
	{
		calendarItem.setTime(firstOfPivotMonth.getTime() + j*24*3600*1000);
		var calendarItemType = "normal";
		if (calendarItem.toDateString() == today.toDateString()) 	calendarItemType = "today";
		if (calendarItem.getMonth() != pivotMonth) 					calendarItemType = "other";
		var calendarItemObject = {	name:			"CalendarItem",
									calendarDate: 	calendarItem.toLocaleDateString(),
									type:			calendarItemType,
									month:			calendarItem.getMonth(),
									date:			calendarItem.getDate(),
									day:			calendarItem.getDay() };
		//alert("costruisco "+(i));
		[datesArray insertObject:calendarItemObject atIndex:(i)];
		j++;
	}
}

	
-(void)display
{	
	[displayedMonth setStringValue:pivotDate.toString("MMMM") + " " + pivotDate.getFullYear()];

	for (var k=0; k<42; k++) 
	{
		var dayOfMonthButton = dayOfMonthButtonsArray[k];
		[dayOfMonthButton setTitle:datesArray[k].date.toString()];
							
		switch (datesArray[k].type)
		{
			case "other":
				[dayOfMonthButton setTextColor:KKRoALightGray];
				[dayOfMonthButton setBackgroundColor:KKRoARibbonBackground];
				break;
				
			case "today":
				[dayOfMonthButton setTextColor:[CPColor whiteColor]];
				[dayOfMonthButton setBackgroundColor:[CPColor colorWithCalibratedRed:155/255 green:160/255 blue:165/255 alpha:1]];
				break;
				
			default:
				[dayOfMonthButton setTextColor:KKRoAMediumGray];
				[dayOfMonthButton setBackgroundColor:KKRoARibbonBackground];
				break;
		}
	}

	// special case: if first day of 6th week is already in following month 
	// no need to display week; therefore reduce height of frame
	//				
	if (datesArray[35].type == "other") 
	{
		[self setFrameSize:CGSizeMake(width, height-tileHeight-3)];
	}
	else
	{
		[self setFrameSize:CGSizeMake(width,height-3)];
	}
	
	[shadowView drawShadowForView:self];
	[shadowView setShadowOriginForView:self];
		
	[contentView addSubview:self positioned:CPWindowAbove relativeTo:targetFormField];
	[contentView addSubview:shadowView positioned:CPWindowBelow relativeTo:self];
}


-(void)newMonth:(CPObject)clickedButton
{
	//[[self subviews] makeObjectsPerformSelector:@"removeFromSuperview"];
	//[self addSubview:ribbonView];
		
	switch([clickedButton tag])
	{
		case "backButton": 	
			[self prepareData:firstOfPrecedingMonth]; 
			break;
		case "forwardButton": 
			[self prepareData:firstOfFollowingMonth];
			break;
		case "todayButton": 
			[self prepareData:today]; 
			break;
		default:
			break;
	}
	[self display]; 
}


-(void)daySelected:(CPSender)aButton
{
	var index = [aButton tag];
	if (previouslySelectedDay != "undefined")
	{
		[previouslySelectedDay setTextColor:previouslySelectedTextColor];
		[previouslySelectedDay setBackgroundColor:previouslySelectedBackgroundColor];
	}
		
	var previouslySelectedDay = aButton;
	var previouslySelectedTextColor = [aButton textColor]; 
	var previouslySelectedBackgroundColor = [aButton backgroundColor];
	
	[aButton setTextColor:[CPColor whiteColor]];
	[aButton setBackgroundColor:KKRoASelectedBlue];
	
	var selectedDate = datesArray[index].calendarDate;
	[appHelpController selectedHelpValue:selectedDate];
	
	//[targetFormField setElementValue:selectedDate];
	//[targetInputField selectText:nil];
	//[self setHidden:YES];
}

@end




