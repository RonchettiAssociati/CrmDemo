/*
 * RoARoundedCornerTipView.j
 * RoaCrm
 *
 * Created by Bruno Ronchetti on November 25, 2010.
 * Copyright 2010, Ronchetti & Associati All rights reserved.
 */

@import <Foundation/CPObject.j>


@implementation RoARoundedCornerTipView : CPView
{
	CPNumber	id	topTipHeight;
	CPNumber	id	bottomTipHeight;
	CPNumber	id	halfTipBasis;
	CPNumber	id	tipPositionX;
	CPNumber	id	boxMinY;
	CPNumber	id	boxMaxY;
	CPNumber	id	boxMinX;
	CPNumber	id	boxMaxX;
	
	CPNumber	id 	theWidth;
	CPNumber	id 	theHeight;
	
	CPColor		id 	theColor;
	CPColor		id 	theStrokeColor;
}
 
- (id)initWithFrame:(CGRect)aFrame topTipHeight:(CPNumber)aTopTipHeight bottomTipHeight:(CPNumber)aBottomTipHeight halfTipBasis:(CPNumber)aHalfTipBasis tipPositionX:(CPNumber)aTipPosition
{
    self = [super initWithFrame:aFrame];
	
	if (self)
	{ 
		var topTipHeight = aTopTipHeight;
		var bottomTipHeight = aBottomTipHeight;
		var halfTipBasis = aHalfTipBasis;
		var tipPositionX = aTipPosition;
		
		var theWidth = aFrame.size.width;
		var theHeight = aFrame.size.height;
			
		var boxMinX	= 0.0;
		var boxMaxX = theWidth;
		var boxMinY = topTipHeight;
		var boxMaxY = theHeight-bottomTipHeight;
		
		var theStrokeColor = [CPColor colorWithCalibratedRed:105/255 green:105/255 blue:105/255 alpha:0.35];
;
		
		return self;
	}
}

- (void)drawRect:(CGRect)rect 
{ 
	var context = [[CPGraphicsContext currentContext] graphicsPort]; 

	// rounded rectangle
	//
	var radius = 5;
	var fieldArea = CGRectMake(boxMinX, boxMinY, theWidth, theHeight-topTipHeight-bottomTipHeight);
	
	/*
	CGContextBeginPath(context);
	CGContextMoveToPoint(context,boxMinX+radius,boxMinY);						// punto inizio in alto a destra
	CGContextAddLineToPoint(context, tipPositionX-halfTipBasis, boxMinY);		// segmento superiore fino inizio punta
	CGContextAddLineToPoint(context, tipPositionX, boxMinY-topTipHeight);		// tratto di sinistra della punta superiore
	CGContextAddLineToPoint(context, tipPositionX+halfTipBasis, boxMinY);		// tratto di destra della punta superiore
	CGContextAddArcToPoint(context, boxMaxX, boxMinY, boxMaxX, boxMaxY, radius);// segmento superiore fino all'angolo
	CGContextAddArcToPoint(context, boxMaxX, boxMaxY, boxMinX, boxMaxY, radius);// segmento di destra
	CGContextAddLineToPoint(context, tipPositionX+halfTipBasis, boxMaxY);		// segmento inferiore fino inizio punta
	CGContextAddLineToPoint(context, tipPositionX, boxMaxY+bottomTipHeight);	// tratto di destra punta inferiore
	CGContextAddLineToPoint(context, tipPositionX-halfTipBasis, boxMaxY);		// tratto di sinistra punta inferiore
	CGContextAddArcToPoint(context, boxMinX, boxMaxY, boxMinX, boxMinY, radius);// segmento inferiore fino all'angolo
	CGContextAddArcToPoint(context, boxMinX, boxMinY, boxMaxX, boxMinY, radius);// segmento di sinistra
	CGContextClosePath(context);
	
	
	CGContextSetFillColor(context, theColor);
	CGContextFillPath(context);
	*/
	
	CGContextSetFillColor(context, theColor);
	CGContextFillRoundedRectangleInRect(context, fieldArea, radius, YES, YES, YES, YES);
	
	CGContextSetLineWidth (context, 2.0);
	CGContextSetStrokeColor(context, theStrokeColor);
	CGContextStrokePath(context);
	
	if (topTipHeight > 0)
	{
		CGContextSetFillColor(context, theColor);
		CGContextMoveToPoint(context,boxMinX+tipPositionX-halfTipBasis,boxMinY);
		CGContextAddLineToPoint(context, boxMinX+tipPositionX, boxMinY-topTipHeight);
		CGContextAddLineToPoint(context, boxMinX+tipPositionX+halfTipBasis, boxMinY);
		CGContextFillPath(context);
	}
	else
	{
		CGContextSetFillColor(context, theColor);
		CGContextMoveToPoint(context,boxMinX+tipPositionX-halfTipBasis,boxMaxY);
		CGContextAddLineToPoint(context, boxMinX+tipPositionX, boxMaxY+bottomTipHeight);
		CGContextAddLineToPoint(context, boxMinX+tipPositionX+halfTipBasis, boxMaxY);
		CGContextFillPath(context);
	}

} 


- (void)setBackgroundColor:(CPColor)aColor
{
	theColor = aColor;
}

- (void)setStrokeColor:(CPColor)aColor
{
	theStrokeColor = aColor;
}

@end