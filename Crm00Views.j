/*
 * Gdo00Views.j
 * RoACrm
 *
 * Created by Bruno Ronchetti on July 26, 2010.
 * Copyright 2010, Ronchetti & Associati All rights reserved.
 */

@import <Foundation/CPObject.j>


// =============================================================================
@implementation RoAShadowView : CPView
{
	int 	id	SHADOW_MARGIN_LEFT;	
	int 	id	SHADOW_MARGIN_RIGHT;
	int		id	SHADOW_MARGIN_TOP;
	int		id	SHADOW_MARGIN_BOTTOM;
	int		id	SHADOW_DISTANCE;	
}


-(void)init
{
	self = [super initWithFrame:CGRectMake(1.0, 1.0 ,1.0, 1.0)];

	if (self)
	{
		var shadowedView = [[CPView alloc] initWithFrame:[super frame]];
		var bounds = [shadowedView bounds];
		var size = [shadowedView frame].size;
				
		var SHADOW_MARGIN_LEFT      = 20.0;	
   		var SHADOW_MARGIN_RIGHT     = 19.0;
    	var SHADOW_MARGIN_TOP       = 10.0;
    	var SHADOW_MARGIN_BOTTOM    = 10.0;
    	var SHADOW_DISTANCE         = 0.0;
		
    	var bundle = [CPBundle bundleForClass:[CPWindow class]];
		
		var _CPWindowShadowColor = [CPColor colorWithPatternImage:[[CPNinePartImage alloc] initWithImageSlices:
                [
                    [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"CPWindow/CPWindowShadow0.png"] size:CGSizeMake(20.0, 19.0)],
                    [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"CPWindow/CPWindowShadow1.png"] size:CGSizeMake(1.0, 19.0)],
                    [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"CPWindow/CPWindowShadow2.png"] size:CGSizeMake(19.0, 19.0)],

                    [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"CPWindow/CPWindowShadow3.png"] size:CGSizeMake(20.0, 1.0)],
                    [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"CPWindow/CPWindowShadow4.png"] size:CGSizeMake(1.0, 1.0)],
                    [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"CPWindow/CPWindowShadow5.png"] size:CGSizeMake(19.0, 1.0)],

                    [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"CPWindow/CPWindowShadow6.png"] size:CGSizeMake(20.0, 18.0)],
                    [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"CPWindow/CPWindowShadow7.png"] size:CGSizeMake(1.0, 18.0)],
                    [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"CPWindow/CPWindowShadow8.png"] size:CGSizeMake(19.0, 18.0)]
                ]]];
		
		[self setFrame:CGRectMake(-SHADOW_MARGIN_LEFT, -SHADOW_MARGIN_TOP + SHADOW_DISTANCE, SHADOW_MARGIN_LEFT + CGRectGetWidth(bounds) + SHADOW_MARGIN_RIGHT, SHADOW_MARGIN_TOP + CGRectGetHeight(bounds) + SHADOW_MARGIN_BOTTOM)];
		
        //[self setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
		[self setBackgroundColor:_CPWindowShadowColor];

		return self; 
	}
}



-(void)drawShadowForView:(CPView)aView
{
	//alert("in drawShadowForView "+[aView frame].size.width);
	var bounds = [aView frame];
	var size = [aView frame].size;
	
	[self setFrame:CGRectMake(-SHADOW_MARGIN_LEFT, -SHADOW_MARGIN_TOP + SHADOW_DISTANCE, SHADOW_MARGIN_LEFT + CGRectGetWidth(bounds) + SHADOW_MARGIN_RIGHT, SHADOW_MARGIN_TOP + CGRectGetHeight(bounds) + SHADOW_MARGIN_BOTTOM)];
	[self setFrameOrigin:CGPointMake([aView frame].origin.x-SHADOW_MARGIN_LEFT, [aView frame].origin.y-SHADOW_DISTANCE)];
	[self setAutoresizingMask:[aView autoresizingMask]];
}

-(void)setShadowOriginForView:(CPView)aView
{
	[self setFrameOrigin:CGPointMake([aView frame].origin.x-SHADOW_MARGIN_LEFT, [aView frame].origin.y+SHADOW_DISTANCE)];
}

@end


// =============================================================================
