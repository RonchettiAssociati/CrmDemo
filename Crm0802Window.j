// -----------------------------------------------------------------------------
//  Crm0802Window.j
//  RoACrm01
//
// 	Created by Bruno Ronchetti on June 02, 2010.
// 	Copyright 2010, Ronchetti & Associati All rights reserved.
// -----------------------------------------------------------------------------


@import <Foundation/CPObject.j>


@implementation Crm0802Window : CPWindow
{
	CPArray		id	selectedObjects @accessors;
	CPArray		id	selectedHTMLTexts;
	
	CPButton	id	printButton;
	CPButton	id	cancelButton;
	
	CPWebView	id	crm0802LetterView;
	CPCollectionView	id	crm0802CollectionView;
	CPScrollView id	crm0802ScrollView;
	
	CPString	id 	letterHTML;
	CGSize		id	letterSize;
	CPNumber	id	letterWidth;
	CPNumber	id	letterHeight;
	CPString	id	letterName	@accessors;
	
	CPNumber	id	windowWidth;
	CPNumber	id 	scrollWidth;
	CPNumber	id 	scrollOffset;
	CPNumber	id 	buttonBarHeight;
	
	CPNumber	id 	numberOfPages @accessors;
	
	CPView		id	buttonBar;
}



- (id)initWithContentRect:(CGRect)aFrame styleMask:aStyleMask
{	
	// GEOMETRY
	//
	
	var windowWidth = 720;
	var scrollWidth = 700;
	var scrollOffset = (windowWidth - scrollWidth)/2;
	var buttonBarHeight = KKRoAY1;
	
	// Read Letter Template
	//
	
	//alert("in 0802view initiwithframe l'elemento è "+KKRoAnItem);
	
	var readLetterPointer = new Object();
	readLetterPointer["action"] = "readDoc";
	readLetterPointer["key"] = "templates/"+KKRoAnItem;
	var record = [[RoACouchModule alloc] initWithRequest:readLetterPointer executeSynchronously:1];
	//listProperties(record, "record");

	var letterSize = CGSizeMake(record["size"][0], record["size"][1]);
	var	letterHeight = record["size"][1];
	var	letterWidth = record["size"][0];

	
	var letterHTML = record["data"];
	var letterName = record["name"];
	
	// Read Objects to Merge into the Letter
	//
	var selectedObjects = [[crm08Controller crm0801View] selectedTableObjects];
	var numberOfPages = [selectedObjects count] ;
	
	
	//+++++++++++++++++++++
	
	self = [super initWithContentRect:CGRectMake(100.0, 50.0, 700.0, 1030.0) styleMask:aStyleMask];
	
	if (self)
	{
		[self populateLetters];
		
		var crm0802ContentView = [self contentView];
		[crm0802ContentView setBackgroundColor:KKRoAContentViewBackground];

		var tableObjects = [[crm08Controller crm0801View] selectedTableObjects];

		[self setTitle:"Etichette da stampare"];
		[self setDelegate:self];
				
		var selectedObjects = [[crm08Controller crm0801View] selectedTableObjects];
		
		var buttonBar = [[CPView alloc] initWithFrame:CGRectMake(0, 0, windowWidth, buttonBarHeight)];
		[buttonBar 	setAutoresizingMask:CPViewWidthSizable];
		[buttonBar setBackgroundColor:KKRoALightGray];
		[crm0802ContentView addSubview:buttonBar];
	
		var cancelButton = [[CrmButton alloc] initWithFrame:CGRectMake(10.0 ,3.0, 100.0, 24.0)];
		[cancelButton setTitle:"Annulla"];
		[cancelButton setTarget:crm08Controller];
		[cancelButton setAction:"cancel"];
		[buttonBar addSubview:cancelButton];
		
		var printAndStoreButton = [[CrmButton alloc] initWithFrame:CGRectMake(windowWidth-330.0, 3.0, 180.0, 24.0)];
		[printAndStoreButton 	setAutoresizingMask:CPViewMinXMargin];
		[printAndStoreButton setTitle:"Stampa e memorizza contatto"];
		[printAndStoreButton setTarget:crm08Controller];
		[printAndStoreButton setAction:"printAndStoreConfirmation"];
		[buttonBar addSubview:printAndStoreButton];

		var printButton = [[CrmButton alloc] initWithFrame:CGRectMake(windowWidth-130.0, 3.0, 100.0 ,24.0)];
		[printButton 	setAutoresizingMask:CPViewMinXMargin];
		[printButton setTitle:"Stampa"];
		[printButton setTarget:crm08Controller];
		[printButton setAction:"printConfirmation"];
		[buttonBar addSubview:printButton];

		//listProperties(letterSize, "ettersize");
		
		// The prototype item
		var collectionPrototype = [[CPCollectionViewItem alloc] init];
		var prototypeView = [[PrototypeView alloc] initWithFrame:CGRectMakeZero(0.0, 0.0, 100.0, 100.0)];
		[prototypeView setFrameSize:letterSize];
		[collectionPrototype setView:prototypeView];
		
		var contentViewWidth = [crm0802ContentView frame].size.width;
		var contentViewHeight = [crm0802ContentView frame].size.height;
		
		//var webView = [[CPWebView alloc] initWithFrame:CGRectMake(0.0 ,buttonBarHeight ,contentViewWidth, contentViewHeight-buttonBarHeight)];
		//[crm0802ContentView addSubview:webView];

		var crm0802ScrollView =[[CPScrollView alloc] initWithFrame:CGRectMake(0.0 ,buttonBarHeight ,contentViewWidth, contentViewHeight-buttonBarHeight)];
		[crm0802ScrollView 	setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
		[crm0802ScrollView setHasHorizontalScroller:NO];
		[crm0802ScrollView setAutohidesScrollers:YES];
		[crm0802ContentView addSubview:crm0802ScrollView];

		// Set up the collection view
		var crm0802CollectionView = [[CPCollectionView alloc] initWithFrame:CGRectMake(0.0, 0.0, contentViewWidth- 20.0, 500)];
		[crm0802CollectionView setMinItemSize:letterSize];
		[crm0802CollectionView setMaxItemSize:letterSize];
		[crm0802CollectionView setVerticalMargin:3];
		[crm0802CollectionView setDelegate:self];
		[crm0802CollectionView setItemPrototype:collectionPrototype];
		
		//alert("prima di setcontent con "+ [selectedHTMLTexts count]);
						
		[crm0802CollectionView setContent:selectedHTMLTexts];
		[crm0802ScrollView setDocumentView:crm0802CollectionView];
		
		//[self orderFront:self];
		return self;

	}
}

-(void)printConfirmation
{
	[buttonBar removeFromSuperview];
	[crm0802ScrollView setFrameOrigin:CGPointMake(0.0, 0.0)];
}


-(void)populateLetters
{	
	var	selectedHTMLTexts = [];
	//alert("in populateletters " + [selectedObjects count] +" oggetti selzionati");
	
	for (var i=0; i<[selectedObjects count]; i++)
	{
	// FIXME Se lascio questa funzione non funzionano tutti i browser diversi da Safari
	//
	/*
		var modifiedHTML = letterHTML.replace( /(##)\S+/g,
			function f(match)
			{
				var directive = match.slice(2);
							
				switch (directive)
				{
					case "LOGO":
						return "<p> <img src=\""+KKRoALogoFile+"\" /> </p>";
						break;
						
					case "LOGOSMALL":
						return "<p> <img src=\""+KKRoALogoFile+"\" /> </p>";
						break;
					
					case "PAGEBREAK":
						return "<p style=\"page-break-before: auto\" >";
						break;
					
					default:
						if ( [selectedObjects[i] valueForKey:directive] != null)
						{
							return [selectedObjects[i] valueForKey:directive];
						}
						else 
						{
							return "";
						}
						break;
				}
			});
	*/
		[selectedHTMLTexts addObject:modifiedHTML];
						
		//alert("modifiedHTML "+modifiedHTML);
	}
}


- (CPData)collectionView:(CPCollectionView)aCollectionView dataForItemsAtIndexes:(CPIndexSet)indexSet forType:(CPString)aType
{
	return selectedHTMLTexts[[indexSet firstIndex]];
}



@end


@implementation PrototypeView : CPView
{
}

- (void)setRepresentedObject:(JSObject)anObject
{
	[self setBackgroundColor:[CPColor blueColor]];
	
	var crm0802LetterView = [[CPWebView alloc] initWithFrame:[self frame]];
	[crm0802LetterView loadHTMLString:anObject baseURL:"file://"];

	[self addSubview:crm0802LetterView];
}


- (void)setSelected:(BOOL)shouldBeSelected 
{ 
	[self setBackgroundColor: shouldBeSelected ? [CPColor blueColor] : nil]; 
} 


@end