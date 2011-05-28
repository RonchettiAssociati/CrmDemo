//
//  RoASimpleViewAnimation.j
//  
//
//  Created by Bruno Ronchetti on 11/11/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

@import <AppKit/CPAnimation.j>

@implementation RoASimpleViewAnimation : CPAnimation
{
	CPView			id	theView;
	int				id	horDisplacement;
	int				id	verDisplacement;
	
	int				id	viewOriginX;
	int				id	viewOriginY;
	CGPoint			id	currentOrigin;

}


-(void)initWithView:(CPView)aView horizontalDisplacement:(CPInt)aHorizontalDisplacement	verticalDisplacement:(CPInt)aVerticalDisplacement
{
	self = [super initWithDuration:0.3 animationCurve:CPAnimationEaseOut];

    if (self)
    {   
		// GEOMETRY
		//
		
		theView = aView;
		horDisplacement = aHorizontalDisplacement;
		verDisplacement = aVerticalDisplacement;
														
		viewOriginX = [aView frame].origin.x;
		viewOriginY = [aView frame].origin.y;
		
		currentOrigin = [theView frame].origin;

		return self;
	}
}
	
- (void)setCurrentProgress:(float)progress
{	
	[super setCurrentProgress:progress];
	var currentValue = [super currentValue];
	
	currentOrigin = CGPointMake(viewOriginX	+(horDisplacement*currentValue), viewOriginY+(verDisplacement*currentValue));
	[theView setFrameOrigin:currentOrigin];

}

/*
- (void)startAnimation
{
	[super startAnimation];
}
*/

@end
