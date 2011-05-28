// -----------------------------------------------------------------------------
//  Crm0203View.j
//  RoACrm01
//
// 	Created by Bruno Ronchetti on May 13, 2010.
// 	Copyright 2010, Ronchetti & Associati All rights reserved.
// -----------------------------------------------------------------------------


@import <Foundation/CPObject.j>



@implementation Crm0203View : CPView
{
	CPTextField	id 	label1;

}

-(void)initWithFrame:(CGRect)aFrame
{
	self = [super initWithFrame:aFrame];
	if (self)
	{
		return self; 
	}
}

-(void)initialize
{
	var label1 = [[CPTextField alloc] initWithFrame:CGRectMake(10.0 , 1.0 ,600.0, 25.0)];
	[label1 setStringValue:"copyright © 2011 RonchettiAssociati  - Tutti i diritti riservati - Condizioni di utilizzo - Proprietà intellettuale - Credits"];
	[label1 setEnabled:NO];
	[label1 setLineBreakMode:CPLineBreakByCharWrapping];
	[label1 setFont:[CPFont systemFontOfSize:9]];
	[label1 setTextColor:KKRoAMainTitleColor];
	[self addSubview:label1];
	
	var copyrightButton = [[CrmCopyrightButton alloc] initWithFrame:[label1 frame]];
	[copyrightButton setValue:[CPColor clearColor] forThemeAttribute:@"bezel-color"];
	[copyrightButton setTarget:crm02Controller];
	[copyrightButton setAction:@"copyright:"];
	[self addSubview:copyrightButton];
}

-(void)tailorForUser
{

}


-(void)display
{
	[contentView addSubview:self];
}


-(void)didSelectItem:(CPSender)aSender
{
}


-(void)highlightLabels:(BOOL)labelsShouldBeHighlighted
{
	if (labelsShouldBeHighlighted)
	{
		[label1 setTextColor:KKRoAMainTitleColorHighlighted];
	}
	else
	{
		[label1 setTextColor:KKRoAMainTitleColor];
	}
}

@end


//=======================


@implementation CrmCopyrightButton : CPButton
{
}


-(void)mouseEntered:(CPEvent)anEvent
{
	[[self superview] highlightLabels:YES];
}

-(void)mouseExited:(CPEvent)anEvent
{
	[[self superview] highlightLabels:NO];
}