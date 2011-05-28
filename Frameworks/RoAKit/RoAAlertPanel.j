// -----------------------------------------------------------------------------
//  RoAAlertPanel.j
//  RoACrm01
//
// 	Created by Bruno Ronchetti on November 30, 2010.
// 	Copyright 2010, Ronchetti & Associati All rights reserved.
// -----------------------------------------------------------------------------


@import <Foundation/CPObject.j>
@import <RoAKit/RoARoundedCornerTipView.j>



@implementation RoAAlertPanel : CPView
{
	CGRect		id 	theShadowFrame;
	CGRect		id 	theAlertFrame;
	CGSize		id	theAlertButtonSize;
	CPScrollView id	theAlertPanelScrollView;
	
	CPNumber	id	theTopTipHeight;
	CPNumber	id	theBottomTipHeight;
	CPNumber	id	theHalfTipBasis;
	CPNumber	id	theTipPositionX;
	
	CPNumber	id	theInterControlSpace;
	CPNumber	id	theTopAndBottomMargin;
	
	CPNumber	id 	theFrameWidth;
	CPNumber	id 	theFrameHeight;
	CPNumber	id	theCurrentYPosition;
	
	CPArray		id	theAlertPanelButtons;
	CPArray		id	buttons;
	CPObject	id	theController;
	CPArray		id	theViewsArray;
	
	CPString	id	theConfirmButtonText;
	CPTextField	id	messageBox;
	
	CPTextField	id 	inputBox 	@accessors;
	
	RoARoundedCornerTipView	id	panelView;
	
	CPColor		id 	theBackgroundColor;
	CPView		id	anchorView;
	RoAShadowView		id	shadowView	@accessors;

	CrmAlertButton	id	printButton;
}


- (id)initWithFrame:(CGRect)aFrame topTipHeight:(CPNumber)aTopTipHeight bottomTipHeight:(CPNumber)aBottomTipHeight halfTipBasis:(CPNumber)aHalfTipBasis tipPositionX:(CPNumber)aTipPosition
{
	self = [super initWithFrame:aFrame];
	var theShadowFrame = CGRectInset(aFrame, 0.0, 0.0);
	var theAlertFrame = aFrame;

	if (self)
	{
		var theFrameWidth = theAlertFrame.size.width;
		var theFrameHeight = theAlertFrame.size.height;

		var theTopTipHeight = aTopTipHeight;
		var theBottomTipHeight = aBottomTipHeight;
		var theHalfTipBasis = aHalfTipBasis;
		var theTipPositionX = aTipPosition;

		var theTopAndBottomMargin = 5.0;
		var theInterControlSpace = 3.0;
		var theCurrentYPosition = 0 + theTopTipHeight +theTopAndBottomMargin;
		
		var	theConfirmButtonText = @"Conferma";
		var	theBackgroundColor = KKRoAHighlightBlue;
		
		var theViewsArray = [];
        [[self window] setAcceptsMouseMovedEvents:YES]; 
		
		return self; 
	}
}


-(void)initialize
{
	[[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
	var theViewsArray = [];
	var theCurrentYPosition = 0 + theTopTipHeight +theTopAndBottomMargin;
	
	var shadowView = [[RoAShadowView alloc] init];
}

-(void)setHidden:(bool)shouldBeHidden
{
	[super setHidden:shouldBeHidden];
	
	[panelView setHidden:shouldBeHidden];
	[shadowView setHidden:shouldBeHidden];
}

-(void)setFrameSize:(CGSize)aSize
{
	[super setFrameSize:aSize];
	theAlertFrame.size.width = aSize.width;
	theAlertFrame.size.height = aSize.height;
	
	var theFrameWidth = theAlertFrame.size.width;
	var theFrameHeight = theAlertFrame.size.height;
}


-(void)setController:(CPObject)aController
{
	var theController = aController;
}


-(void)addMessageBoxWithHeight:(CPNumber)aMessageBoxHeight
{
	var messageBox = [[CPTextField alloc] initWithFrame:CGRectMake(6.0,theCurrentYPosition,theFrameWidth-12.0, aMessageBoxHeight)];
	[messageBox setStringValue:RoALocalized(@"Confermi di voler salvare il documento?")];
	[messageBox setLineBreakMode:CPLineBreakByCharWrapping];
	[messageBox setTextFieldBackgroundColor:KKRoABackgroundWhite];
	[messageBox setTextColor:KKRoAHighlightBlue];
	[messageBox setFont:[CPFont systemFontOfSize:12]];

	//[messageBox setValue:KKRoABackgroundWhite forThemeAttribute:@"bezel-color"];
	
	[theViewsArray addObject:messageBox];
	//[self addSubview:messageBox];
	
	theCurrentYPosition = theCurrentYPosition+aMessageBoxHeight+theInterControlSpace;
}


-(void)setMessageText:(CPString)aMessageText
{
	[messageBox setStringValue:RoALocalized(aMessageText)];
}

-(void)setMessageColor:(CPColor)aColor
{
	[messageBox setTextColor:aColor];
}


-(void)setMessageFont:(CPFont)aFont
{
	[messageBox setFont:aFont];
}


-(void)setConfirmButtonText:(CPString)aButtonText
{
	theConfirmButtonText = RoALocalized(aButtonText);
}


-(void)removeMessageBox
{
	[theViewsArray removeObject:messageBox];
}

-(void)addInputBox
{
	theCurrentYPosition = theCurrentYPosition- 4;

	var inputBox = [[CPTextField alloc] initWithFrame:CGRectMake(6.0,theCurrentYPosition,theFrameWidth-12.0, 28.0)];
	[inputBox setEditable:YES];
	[inputBox setSelectable:YES];
	[inputBox setBezeled:YES];
	[inputBox setTextFieldBackgroundColor:KKRoABackgroundWhite];
	[inputBox setFont:[CPFont systemFontOfSize:12]];
	//[inputBox setValue:KKRoABackgroundWhite forThemeAttribute:@"bezel-color"];
	
	[theViewsArray addObject:inputBox];
	
	theCurrentYPosition = theCurrentYPosition+28.0+theInterControlSpace;
}

-(void)setInputPlaceholderString:(CPString)aPlaceholderText
{
	[inputBox setPlaceholderString:RoALocalized(aPlaceholderText)];
}

-(void)removeInputBox
{
	[theViewsArray removeObject:messageBox];
}

-(CPString)inputString
{
	return [inputBox stringValue];
}

-(void)addButtons:(CPDictionary)aButtonDictionary orientation:(CPString)anOrientation
{
	var theAlertPanelButtons = [CPDictionary dictionaryWithDictionary:aButtonDictionary];
	[self addButtons:aButtonDictionary orientation:anOrientation ordering:[theAlertPanelButtons allKeys]];
}


-(void)addButtons:(CPDictionary)aButtonDictionary orientation:(CPString)anOrientation ordering:(CPArray)theOrderedButtons
{

	// FIXME the order in which the buttons appear on the panel is not the same as the order in
	// the originating button array
	// this is because the [theAlertPanelButtons allKeys] does not guarantee the ordering
		
	var theAlertPanelButtons = [CPDictionary dictionaryWithDictionary:aButtonDictionary];
		
	var buttonIdentifiers = theOrderedButtons;

	var numberOfButtons = [buttonIdentifiers count];
	var buttons = [];
	var buttonFrames = [];
	
	if (anOrientation == "horizontal")
	{
		var theAlertButtonSize = CGSizeMake(80.0, 24.0);
		for (var i=0; i<[buttonIdentifiers count]; i++)
		{
			var ik = [buttonIdentifiers count] - i;
			var buttonFrame = CGRectMake(0.0 ,0.0 ,80.0 ,24.0);
			buttonFrame.size = theAlertButtonSize;
			var theCurrentXPosition = [self frame].size.width - ik*(80.0+10.0);
			buttonFrame.origin = CGPointMake(theCurrentXPosition, theCurrentYPosition);
			[buttonFrames insertObject:buttonFrame atIndex:i];
		}
		theCurrentYPosition = theCurrentYPosition+buttonFrame.size.height+theInterControlSpace;
	}
	else 
	{
		var theAlertButtonSize = CGSizeMake(theFrameWidth- 14.0, 24.0);
		for (var i=0; i<[buttonIdentifiers count]; i++)
		{
			if (buttonIdentifiers[i] == "separator")
			{
				[buttonFrames insertObject:null atIndex:i];
				theCurrentYPosition = theCurrentYPosition+ 3.0+ theInterControlSpace;
				continue;
			}
			var buttonFrame = CGRectMake(0.0 ,0.0 ,80.0 ,24.0);
			buttonFrame.size = theAlertButtonSize;
			buttonFrame.origin = CGPointMake(7.0, theCurrentYPosition);
			[buttonFrames insertObject:buttonFrame atIndex:i];
			theCurrentYPosition = theCurrentYPosition+buttonFrame.size.height+theInterControlSpace;
		}
	}

	for (var j=0; j<[buttonIdentifiers count]; j++)
	{
		if (buttonIdentifiers[j] == "separator")
		{
			continue;
		}
			
		var buttonInfo = [theAlertPanelButtons objectForKey:buttonIdentifiers[j]];
		var alertPanelButton = [[CrmAlertButton alloc] initWithFrame:buttonFrames[j]];
		[alertPanelButton setTag:buttonInfo[0]];
		[alertPanelButton setTitle:buttonInfo[2]];
		[alertPanelButton setTarget:self];
		[alertPanelButton setAction:@selector(buttonSelection:)];
		
		[buttons addObject:alertPanelButton];
		[theViewsArray addObject:alertPanelButton];
		
		if ([alertPanelButton tag] == "print")
		{
			var printButton = alertPanelButton;
			[alertPanelButton setImageFile:"checkMark"];
			[alertPanelButton setImagePosition:CPImageLeft];
			[self printButtonShowImage:NO];
		}
		
		if ([alertPanelButton tag] == "confirm")
		{
			[alertPanelButton setTitle:buttonInfo[1]+" "+theConfirmButtonText];
		}	
	}
}

-(void)buttonSelection:(CPSender)aSender
{
	[shadowView removeFromSuperview];
	[theController buttonSelection:aSender];
}

-(void)removeButtons
{
	for (var i=0; i<[buttons count]; i++)
	{
		[theViewsArray removeObject:buttons[i]];
	}
	[buttons removeAllObjects];
}

-(void)printButtonShowImage:(BOOL)shouldShowImage
{
	[printButton showImage:shouldShowImage];
}

-(void)addCollectionViewWithHeight:(CPNumber)aHeight forData:(CPArray)aDataArray
{
	var theScrollHeight = aHeight;
	var theDataArray = aDataArray;
	
	//alert("in addCollectionViewWithHeight "+[theDataArray count]);
	
	var theScrollWidth = theFrameWidth-14.0;
	var theCollectionWidth = theScrollWidth - 12.0;
	var theCellSize = CGSizeMake(theCollectionWidth, 40.0);

	var theAlertPanelScrollView =[[CPScrollView alloc] initWithFrame:CGRectMake(7.0,theCurrentYPosition, theScrollWidth, theScrollHeight)];
	[theAlertPanelScrollView setHasHorizontalScroller:NO];
	[theAlertPanelScrollView setAutohidesScrollers:YES];
	[theAlertPanelScrollView setBackgroundColor:KKRoABackgroundWhite];
	
	[theViewsArray addObject:theAlertPanelScrollView];
	//[self addSubview:theAlertPanelScrollView];
	theCurrentYPosition = theCurrentYPosition+ theScrollHeight+ theInterControlSpace;

	
	// The prototype item
	var theAlertCollectionPrototype = [[CPCollectionViewItem alloc] init];
	var theAlertPrototypeView = [[RoAPrototypeView alloc] initWithFrame:CGRectMakeZero()];
	[theAlertCollectionPrototype setView:theAlertPrototypeView];
	
	// Set up the collection view
	var theAlertCollectionView = [[CPCollectionView alloc] initWithFrame:CGRectMake(0, 2, theCollectionWidth, 30)];
	[theAlertCollectionView setMinItemSize:theCellSize];
	[theAlertCollectionView setMaxItemSize:theCellSize];
	[theAlertCollectionView setVerticalMargin:1];
	[theAlertCollectionView setDelegate:self];
	[theAlertCollectionView setItemPrototype:theAlertCollectionPrototype];
	[theAlertCollectionView setContent:theDataArray];
	
	[theAlertPanelScrollView setDocumentView:theAlertCollectionView];
}


-(void)removeCollectionView
{
	//alert("in removeCollectionView "+ theAlertPanelScrollView);
	if (theAlertPanelScrollView != "undefined")
	{
		[theViewsArray removeObject:theAlertPanelScrollView];	
	}
}

-(void)setBackgroundColor:(CPColor)aColor
{
	theBackgroundColor = aColor;
}


-(void)addBackgroundView
{
	var	thePanelViewHeight = theCurrentYPosition- theInterControlSpace +theTopAndBottomMargin +theBottomTipHeight;
		
	theAlertFrame.size.height = thePanelViewHeight;
	theAlertFrame.origin.x = 0.0;
	theAlertFrame.origin.y = 0.0;
		
	var panelView = [[RoARoundedCornerTipView alloc] initWithFrame:theAlertFrame topTipHeight:theTopTipHeight bottomTipHeight:theBottomTipHeight halfTipBasis:theHalfTipBasis tipPositionX:theTipPositionX];
	[panelView setBackgroundColor:theBackgroundColor];
	[theViewsArray insertObject:panelView atIndex:0];
	
}

-(void)removeBackgroundView
{
	if (panelView != "undefined")
	{
		[theViewsArray removeObject:panelView];
	}
}

-(BOOL)acceptsFirstResponder
{
	return YES;
}

-(CGSize)alertDisplay
{
	for (var i=0; i<[theViewsArray count]; i++)
	{
		[self addSubview:theViewsArray[i]];
	}
	
	[self setFrameSize:theAlertFrame.size];
	[contentView addSubview:self];
	
	[shadowView drawShadowForView:self];
	[shadowView setShadowOriginForView:self];
	[[self superview] addSubview:shadowView positioned:CPWindowBelow relativeTo:self];

	[[self window] makeFirstResponder:self];
			
	[[CPRunLoop currentRunLoop] limitDateForMode:CPDefaultRunLoopMode];

	if (inputBox)
	{
		//FIXME inputBox ha focus ma non accetta input da tastiera perchè?
		//[[inputBox window] makeFirstResponder:inputBox];
	}

	[CPApp setTarget:self selector:@selector(hideIfClickedOutside:) forNextEventMatchingMask:CPLeftMouseDownMask untilDate:nil inMode:nil dequeue:NO];
}

-(bool)canBecomeKeyView
{
	return YES;
}

-(bool)acceptsFirstResponder
{
	return YES;
}

-(bool)acceptsFirstMouse
{
	return YES;
}

-(void)hideIfClickedOutside:(CPEvent)anEvent
{
	//alert("in clickedoutside "+[self isHidden]+" "+[self hitTest:[anEvent locationInWindow]]);
	if ([self isHidden] == true)
		return;
		
	if ([self hitTest:[anEvent locationInWindow]] == null)
	{
		//[self setHidden:YES];
		[self removeFromSuperview];
		[shadowView removeFromSuperview];
		[CPApp sendEvent:anEvent];	
	}
	else
	{
		[CPApp sendEvent:anEvent];	
	}
}

-(CGRect)finalFrame
{
	var theExpandedFrame = CGRectInset(theAlertFrame, -10.0, -10.0);
	return theExpandedFrame;
}



//------------------------------------------------------------------------------
// CPCollectionView standard delegate methods
//------------------------------------------------------------------------------

-(void)collectionViewDidChangeSelection:(CPCollectionView)collectionView
{
	//alert("collectionViewDidChangeSelection");
}

-(void)collectionView:(CPCollectionView)collectionView didDoubleClickOnItemAtIndex:(int)index
{
	//alert("didDoubleClickOnItemAtIndex");
}

-(CPData)collectionView:(CPCollectionView)collectionView dataForItemsAtIndexes:(CPIndexSet)indices forType:(CPString)aType
{
	//alert("dataForItemsAtIndexes");
}

-(CPArray)collectionView:(CPCollectionView)collectionView dragTypesForItemsAtIndexes:(CPIndexSet)indices
{
	//alert("dragTypesForItemsAtIndexes");
}


@end

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//

@implementation RoAPrototypeView : CPView
{
}

- (void)setRepresentedObject:(JSObject)anObject
{
	//listProperties(anObject.doc, "anObject");
	//alert("in setRepresentedObject");
	var crm1101CellView = [[CPView alloc] initWithFrame:[self frame]];
	var field1 = [CPTextField labelWithTitle:anObject["doc"]["Nome"]];
	var field2 = [CPTextField labelWithTitle:anObject["doc"]["Cognome"]];
	var field3 = [CPTextField labelWithTitle:anObject["doc"]["Indirizzo_Casa"]];
	var field4 = [CPTextField labelWithTitle:anObject["doc"]["Località_Casa"]];
	var field5 = [CPTextField labelWithTitle:anObject["score"]];

	[field1 setFont:[CPFont systemFontOfSize:11]];
	[field2 setFont:[CPFont systemFontOfSize:11]];
	[field3 setFont:[CPFont systemFontOfSize:10]];
	[field4 setFont:[CPFont systemFontOfSize:10]];
	[field5 setFont:[CPFont systemFontOfSize:7]];
	
	[field1 sizeToFit];
	[field2 sizeToFit];
	var field1MaxX = CGRectGetMaxX([field1 frame])+5.0;
	
	[field1 setFrameOrigin:CGPointMake(2.0, 0.0)];
	[field2 setFrameOrigin:CGPointMake(field1MaxX, 0.0)];
	[field3 setFrameOrigin:CGPointMake(20.0, 14.0)];
	[field4 setFrameOrigin:CGPointMake(20.0, 26.0)];
	[field5 setFrameOrigin:CGPointMake(80, 0.5)];

	[self addSubview:field1];
	[self addSubview:field2];
	[self addSubview:field3];
	[self addSubview:field4];
	//[self addSubview:field5];

	[self setBackgroundColor:KKRoAVeryVeryLightGray];
	[self addSubview:crm1101CellView];
}

/*
- (void)setSelected:(BOOL)shouldBeSelected 
{ 
	[self setBackgroundColor: shouldBeSelected ? [CPColor blueColor] : nil]; 
} 
*/

@end
