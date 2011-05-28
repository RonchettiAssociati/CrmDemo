/*
 * RoATree.j
 * WktTest63
 *
 * Created by Bruno Ronchetti on March 28, 2010
 * Copyright 2010, Ronchetti & Associati All rights reserved.
 */

@import <Foundation/CPObject.j>


// IMPLEMENTATION
//
@implementation RoATree : CPObject
{
	CPDictionary 	id 	treeNodes		@accessors;	
}


-(void)init
{	
	self = [super init];
	if (self)
	{
		treeNodes = [CPDictionary dictionary];
		defaultObject = {key:"", value:0}
		return self;
	}
}

-(void)addNode:(CPString)theNodeKey withParent:(CPString)theParentKey
{
	//alert(" in addNode "+theNodeKey+" "+ theParentKey+" " +[treeNodes containsKey:theNodeKey]);
/*
	Se la coppia nodo/parent esiste già 
		- non facciamo nulla
		
	Se il nodo non esiste
		- crea il nodo
		- aggiungilo al dict
		- aggiorna il nodo con l'oggetto
	
	Se il parent è diverso da zero
		Se il parent non esiste
		- crea il parent
		- aggiungilo al dict
		
		Aggiorna il nodo con:
		- aggiungi il parent all'array
		
		Aggiorna il parent con:
		- aggiungi il nodo all'array dei figli
		
	Se il nodo esiste
		- aggiorna object  					??????????? da uncomment se decidiamo che va bene
*/
		
	if ([treeNodes containsKey:theNodeKey])
	{
		var theNode = [treeNodes objectForKey:theNodeKey];
		if ( theParentKey && [theNode["parentNodes"] containsObject:theParentKey])
		{		
			return;
		}
	}


	if ([treeNodes containsKey:theNodeKey] === false)
	{
		var theNode = [[BRoTreeNode alloc] initWith:theNodeKey];
		[treeNodes addEntriesFromDictionary:[CPDictionary dictionaryWithObject:theNode forKey:theNodeKey]];
	
	}
	else
	{
		var theNode = [treeNodes objectForKey:theNodeKey];
	}
	
	//alert("controlliamo qui "+theNodeKey+" "+theParentKey+" "+[treeNodes containsKey:theParentKey]);
	if (theParentKey != null)
	{
		if ([treeNodes containsKey:theParentKey] === false)
		{
			var theParentNode = [[BRoTreeNode alloc] initWith:theParentKey];
			
			// non  si sa quale sia l'object
			// 
			defaultObject["key"] = theParentKey;
			[theParentNode addObject:defaultObject];
			
			[treeNodes addEntriesFromDictionary:[CPDictionary dictionaryWithObject:theParentNode forKey:theParentKey]];
			//alert("scritto parent "+[treeNodes objectForKey:theParentKey].representedObject.key);

		}
		else
		{
			var theParentNode = [treeNodes objectForKey:theParentKey];
		}
		
		[theNode addParent:theParentKey];
		[theParentNode addChild:theNodeKey];
	}

}


-(void)addObject:(CPObject)theObject toNode:(CPString)theNodeKey
{
	//alert("ora siamo in addobject "+theNodeKey+" "+theObject);
	var theNode = [treeNodes objectForKey:theNodeKey];
	[theNode addObject:theObject];
}


-(void)removeNode:(CPString)theNodeKey
{
	var theNode = 		[treeNodes objectForKey:theNodeKey];
	var parentArray = 	[self parentNodesForKey:theNodeKey];
	var childArray = 	[self childNodesForKey:theNodeKey];
	
	// remove from all parents' childNodes arrays
	for (var i=0; i<[parentArray count]; i++)
	{
		var theParentKey = parentArray[i];
		var theParentNode = [treeNodes objectForKey:theParentKey];
		[theParentNode.childNodes removeObject:theNodeKey];
	}
	
	// what to do with the children of the removed node ???
	// FIXME 
	for (var i=0; i<[childArray count]; i++)
	{
		var theChildKey = childArray[i];
		var theChildNode = [treeNodes objectForKey:theChildKey];
		[theChildNode.parentNodes removeObject:theNodeKey];
	}
	
			
	// remove the node iteself from the dict
	//alert(" prima di remove dal dict "+[treeNodes allKeys]);
	
	[treeNodes removeObjectForKey:theNodeKey];
	
	//alert(" dopo remove dal dict "+[treeNodes allKeys]);
}


-(void)renameNode:(CPString)theNodeKey withNewName:(CPString)aNewName
{
	var theNewName = aNewName;
	
	var theNode = 		[treeNodes objectForKey:theNodeKey];
	var parentArray = 	[self parentNodesForKey:theNodeKey];
	var childArray = 	[self childNodesForKey:theNodeKey];

	// update the dict by removing the object and re-inserting it with the new name
	[treeNodes removeObjectForKey:theNodeKey];
	[theNode renameWithNewName:theNewName];
	[treeNodes setObject:theNode forKey:theNewName];
		
	
	// cycle through the parentnodes and rename references
	for (var i=0; i<[parentArray count]; i++)
	{
		var theParentNode = [treeNodes objectForKey:parentArray[i]];
		[theParentNode["childNodes"] removeObject:theNodeKey];
		[theParentNode["childNodes"] addObject:theNewName];
	}
	
	// the childNodes remain unmodified
}


-(void)countNodes
{
	return [treeNodes count];
}	


- (CPArray)childNodesForKey:(CPString)aKey
{
    return [[treeNodes objectForKey:aKey]["childNodes"] copy];
}

- (CPArray)parentNodesForKey:(CPString)aKey
{
    return [[treeNodes objectForKey:aKey]["parentNodes"] copy];
}


-(void)adoptOrphans:(CPString)aParentKey
{
	//alert("entro in adozione "+aParentKey+" "+[treeNodes objectForKey:aParentKey]);
	
	var theParentNode = [treeNodes objectForKey:aParentKey];
	var allNodes = [treeNodes allKeys];
	
	for (var i=0; i< [allNodes count]; i++)
	{		
		var currentKey = allNodes[i];
		var currentNode = [treeNodes objectForKey:currentKey];
		
		if ([currentNode["parentNodes"] count] == 0 && currentKey != aParentKey && currentKey != "root")
		{
			//alert("adotto nodo "+currentKey+" "+currentNode+" "+theParentNode);
			
			[currentNode addParent:aParentKey];
			[theParentNode addChild:currentKey];
		}
	}
}

-(void)objectForKey:(CPString)aKey
{
	//alert("a "+[treeNodes valueForKey:aKey]);
	return	[treeNodes valueForKey:aKey];
}


-(void)buildNodesArray
{
	var listsArray = [];
	var allNodes = [treeNodes allKeys];
	
	for (var i=0; i< [allNodes count]; i++)
	{
		var childName  = allNodes[i];
		var parentsArray = [treeNodes objectForKey:childName].parentNodes;
		for	(var k=0; k< [parentsArray count]; k++)
		{
			var parentName = parentsArray[k];
			var newElement = [parentName, childName];
			if (parentName != "root")
			{
				[listsArray addObject:newElement];
			}
		} 	
	}
	//alert("QUANDO RITORNA L'ARRAY "+[listsArray count]);
	return listsArray;
}					

@end

// +++++++++++++++++++++++++++++++++++++++++++++++
// +++++++++++++++++++++++++++++++++++++++++++++++

@implementation BRoTreeNode : CPObject
{
	CPString 	id	description			@accessors;
	CPObject	id	representedObject	@accessors;
	CPArray		id	parentNodes			@accessors;
	CPArray		id	childNodes			@accessors;
}

-(void)initWith:(CPString)aDescription
{	
	self = [super init];
	if (self)
	{
		description 		= aDescription;
		representedObject 	= null;
		parentNodes 		= [];
		childNodes 			= [];
		return self;
	}
}

-(void)addObject:(CPObject)anObject
{
	[self setRepresentedObject:anObject];
}

-(void)addParent:(CPString)aParentKey
{
	parentNodes[[parentNodes count]] = aParentKey;
}

-(void)addChild:(CPString)aChildKey
{
	//alert("in addChild "+aChild+" al parent "+self);
	childNodes[[childNodes count]] = aChildKey;
}

-(void)renameWithNewName:(CPString)aNewName
{
	var description = aNewName;
}


@end


// +++++++++++++++++++++++++++++++++++++++++++++++
// +++++++++++++++++++++++++++++++++++++++++++++++


@implementation CPDictionary (withContains)
{
}
- (BOOL)containsKey:(id)aKey
{
    var value = [self objectForKey:aKey];
    return ((value !== null) && (value !== undefined));
}
@end


