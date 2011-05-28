/*
 * Crm00Buttons.j
 * RoACrm
 *
 * Created by Bruno Ronchetti on July 26, 2010.
 * Copyright 2010, Ronchetti & Associati All rights reserved.
 */

@import <Foundation/CPObject.j>


// =============================================================================
@implementation CrmButton : CPButton
{
	CPSize	id	buttonImageSize;
	CPImage	id	buttonImage;
}

-(void)initWithFrame:(CGRect)aFrame
{	
	if (aFrame.size.width == 0)
	{
		aFrame = CGRectMake(0.0, 0.0, 80.0, 24.0)
	}
	
	self = [super initWithFrame:aFrame];

	if (self)
	{
		var buttonImageSize = CGSizeMake(16.0, 16.0);

		[self setBezelStyle:CPRegularSquareBezelStyle];
		[self setBordered:YES];
		
		[self setValue:KKRoAMediumLightGray forThemeAttribute:@"text-color" inState:CPThemeStateDisabled];
		[self setValue:KKRoAMediumBlue forThemeAttribute:@"text-color" inState:CPThemeStateNormal];
		[self setValue:KKRoAHighlightBlue forThemeAttribute:@"text-color" inState:CPThemeStateHighlighted];
		[self setValue:KKRoAHighlightBlue forThemeAttribute:@"text-color" inState:CPThemeStateHovered];
		[self setImageDimsWhenDisabled:YES];
		return self; 
	}
}

-(void)setImageFile:(CPString)anImageFile
{
	var buttonImage = [[CPImage alloc] initWithContentsOfFile:"Resources/"+anImageFile+".png" size:buttonImageSize];
	[super setImage:buttonImage];
	[self setImagePosition:CPImageRight];
}

-(void)showImage:(BOOL)shouldDisplayImage
{
	if (shouldDisplayImage == YES)
	{
		[super setImage:buttonImage];
	}
	else
	{
		[super setImage:null];
	}
}

@end


// =============================================================================
@implementation CrmAlertButton : CPButton
{
	CPSize	id	buttonImageSize;
	CPImage	id	buttonImage;
	CPColor	id	normalBezelColor;
}

-(void)initWithFrame:(CGRect)aFrame
{	
	if (aFrame.size.width == 0)
	{
		aFrame = CGRectMake(0.0, 0.0, 80.0, 24.0);
		var normalBezelColor = [CPButton valueForThemeAttribute:@"bezel-color"];
	}
	
	self = [super initWithFrame:aFrame];

	if (self)
	{
		var buttonImageSize = CGSizeMake(16.0, 16.0);

		[self setBezelStyle:CPRegularSquareBezelStyle];
		[self setBordered:YES];
		[self setEnabled:YES];
		[self setHighlighted:NO];
		
		[self setValue:KKRoAMediumLightGray forThemeAttribute:@"text-color" inState:CPThemeStateDisabled];
		[self setValue:KKRoAMediumBlue forThemeAttribute:@"text-color" inState:CPThemeStateNormal];
		[self setValue:KKRoAHighlightBlue forThemeAttribute:@"text-color" inState:CPThemeStateHighlighted];
		[self setValue:KKRoAHighlightBlue forThemeAttribute:@"text-color" inState:CPThemeStateHovered];
		
		// FIXME the bezel colors need to be a nine-part image
		//
		//[self setValue:KKRoAVeryLightGray forThemeAttribute:@"bezel-color" inState:CPThemeStateNormal];
		//[self setValue:normalBezelColor forThemeAttribute:@"bezel-color" inState:CPThemeStateHovered];
		return self; 
	}
}


-(void)setImageFile:(CPString)anImageFile
{
	var buttonImage = [[CPImage alloc] initWithContentsOfFile:"Resources/"+anImageFile+".png" size:buttonImageSize];
	[super setImage:buttonImage];
	[self setImagePosition:CPImageRight];
}

-(void)showImage:(BOOL)shouldDisplayImage
{
	if (shouldDisplayImage == YES)
	{
		[super setImage:buttonImage];
	}
	else
	{
		[super setImage:null];
	}
}

@end


// =============================================================================
@implementation CrmMenuButton : CPButton
{
	CPSize	id	buttonImageSize;
	CPFont	id	buttonFont;
	CPImage	id	highlightedImage;
	CPImage	id	darkenedImage;
	BOOL	id 	buttonIsSelected;
}

-(void)initWithFrame:(CGRect)aFrame
{		
	var buttonFont = [CPFont systemFontOfSize:11.0];
	var buttonImageSize = CGSizeMake(28.0, 28.0);
	var buttonIsSelected = false;

	if (aFrame.size.width == 0)
	{
		aFrame = CGRectMake(0.0, 0.0, 80.0, 24.0)
	}
	
	self = [super initWithFrame:aFrame];
	if (self)
	{
		[self setBezelStyle:CPRegularSquareBezelStyle];
		[self setBordered:YES];
		[self setTheme:nil];
		//[self setImagePosition:CPImageOnly];
		[self setImagePosition:CPImageAbove];
		[self setTextColor:KKRoADarkGray];
		[self setFont:[CPFont systemFontOfSize:10]];
		[self setVerticalAlignment:CPTopVerticalTextAlignment];
		return self; 
	}
}

-(void)mouseEntered:(CPEvent)anEvent
{
	[super setImage:highlightedImage];
	//[self setImagePosition:CPImageOverlaps];
	[self setTextColor:[CPColor whiteColor]];
}

-(void)mouseExited:(CPEvent)anEvent
{
	if(buttonIsSelected == false	)
	{
		[super setImage:darkenedImage];
		//[self setImagePosition:CPImageOnly];
		[self setTextColor:KKRoADarkGray];
	}
}

-(void)setSelectedItem
{
	[super setImage:highlightedImage];
	[self setTextColor:[CPColor whiteColor]];
	buttonIsSelected = true;
}

-(void)unselectSelf
{
	buttonIsSelected = false;
	[super setImage:darkenedImage];
	//[self setImagePosition:CPImageOnly];
	[self setTextColor:KKRoADarkGray];
}

-(void)setImageFile:(CPString)anImageFile
{
	var highlightedImage = [[CPImage alloc] initWithContentsOfFile:"Resources/"+anImageFile+".png" size:buttonImageSize];
	var darkenedImage = [[CPImage alloc] initWithContentsOfFile:"Resources/"+anImageFile+"Dark.png" size:buttonImageSize];
	[super setImage:darkenedImage];
}

@end


// =============================================================================
@implementation CrmUserButton : CPButton
{
	CPImage	id	disclosureTriangle;
}

-(void)initWithFrame:(CGRect)aFrame
{	
	var buttonImageSize = CGSizeMake(12.0, 12.0);
	var buttonIsSelected = false;
	var buttonFont = [CPFont systemFontOfSize:11.0];
	var disclosureTriangle = [[CPImage alloc] initWithContentsOfFile:"Resources/disclosureTriangle.png" size:buttonImageSize];


	if (aFrame.size.width == 0)
	{
		aFrame = CGRectMake(0.0, 0.0, 80.0, 24.0)
	}
	
	self = [super initWithFrame:aFrame];
	if (self)
	{
		[self setAutoresizingMask:CPViewMinXMargin];
		[self setTextShadowColor:[CPColor clearColor]];
		[self setImage:disclosureTriangle];
		[self setImagePosition:CPImageRight];
		[self setValue:KKRoAToolbarBackground forThemeAttribute:@"bezel-color" inState:CPThemeStateNormal];
		[self setValue: [CPColor redColor] forThemeAttribute:@"text-color" inState:CPThemeStateHovered];

		[self setTextColor:[CPColor whiteColor]];
		[self setFont:buttonFont];
		return self; 
	}
}


@end