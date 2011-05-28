/*
 * RoARoundedCornerView.j
 * RoaCrm
 *
 * Created by Bruno Ronchetti on July 21, 2010.
 * Copyright 2010, Ronchetti & Associati All rights reserved.
 */

@import <Foundation/CPObject.j>


@implementation RoARoundedCornerView : CPView
{
	CPColor		id 	theColor;
	CGRect		id	theRect;
}
 
- (id)initWithFrame:(CGRect)aFrame
{
    self = [super initWithFrame:aFrame];
	
	if (self)
	{		 
		return self;
	}
}


- (void)drawRect:(CGRect)aRect 
{ 
	// rounded rectangle
	//
	var theRect = aRect;
	var radius = 4.0;
	
	var context = [[CPGraphicsContext currentContext] graphicsPort];
 
	CGContextSetFillColor(context, theColor);
	CGContextFillRoundedRectangleInRect(context, [self bounds], radius, YES, NO, NO, YES);
} 


- (void)setBackgroundColor:(CPColor)aColor
{
	theColor = aColor;
}

@end