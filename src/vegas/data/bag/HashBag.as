/*

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  
           http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is Vegas Framework.
  
  The Initial Developer of the Original Code is
  ALCARAZ Marc (aka eKameleon)  <vegas@ekameleon.net>.
  Portions created by the Initial Developer are Copyright (C) 2004-2007
  the Initial Developer. All Rights Reserved.
  
  Contributor(s) :
  
*/

import vegas.data.bag.AbstractBag;
import vegas.data.Collection;
import vegas.data.map.HashMap;
import vegas.util.serialize.Serializer;

/**
 * Implements Bag, using a HashMap to provide the data storage. This is the standard implementation of a bag.
 * <p><b>Example : </b>
 * {@code
 *	import vegas.data.Bag ;
 *	import vegas.data.bag.HashBag ;
 *	import vegas.data.Collection ;
 *	import vegas.data.collections.SimpleCollection ;
 *	import vegas.data.Set ;
 *	
 *	var c1:Collection = new SimpleCollection( ["item1", "item1", "item3"] ) ;
 *	var c2:Collection = new SimpleCollection( ["item1", "item2", "item3", "item4", "item5"] ) ;
 *	
 *	trace ("c1 collection : " + c1) ;
 *	trace ("c2 collection : " + c2) ;
 *	
 *	trace ("---- create a new HashBag") ;
 *	var bag:Bag = new HashBag ;
 *		
 *	trace ("---- insert") ;
 *	trace (" + bag insertAll c1 : " + bag.insertAll(c1)) ;
 *	trace (" + bag insertAll c2 : " + bag.insertAll(c2)) ;
 *	trace (" > bag : " + bag) ;
 *	trace (" > bag.toSource : " + bag.toSource()) ;
 *	
 *	trace ("---- contains") ;
 *	trace (" > bag containsAll c2 : " + bag.containsAll(c2)) ;
 *	
 *	trace ("---- insert") ;
 *	trace (" + bag insert item2 : " + bag.insert("item2")) ;
 *	trace (" > bag : " + bag) ;
 *	trace (" + bag insertCopies 2xitem2 : " + bag.insertCopies("item2", 2)) ;
 *	trace (" > bag : " + bag) ;
 *	
 *	trace ("---- remove") ;
 *	trace (" > bag removeCopies 1 x item2 : " + bag.removeCopies("item2", 1)) ;
 *	
 *	trace ("---- size") ;
 *	trace (" - bag getCount item2 : " + bag.getCount("item2")) ;
 *	trace (" > bag size : " + bag.size()) ;
 *	
 *	trace ("---- retain") ;
 *	trace (" > bag : " + bag) ;
 *	trace (" > bag retainAll c1 : " + bag.retainAll(c1)) ;
 *	trace (" > bag : " + bag) ;
 *		
 *	trace ("----") ;
 *	var s:Set = bag.uniqueSet() ;
 *	trace("bag uniqueSet : " + s) ;
 *}
 *</p>
 *@author eKameleon
 */
class vegas.data.bag.HashBag extends AbstractBag 
{
	
	/**
	 * Creates a new HashBag instance.
	 * @param c a {@code Collection} to constructs a bag containing all the members of the given collection.
	 */
	public function HashBag( c:Collection ) 
	{
		super(new HashMap()) ;
		if (c) 
		{
			insertAll(c) ;
		}
	}
	
	/**
	 * Returns the shallow copy of this bag.
	 * @return the shallow copy of this bag.
	 */
	public function clone() 
	{
		return new HashBag(_map.clone()) ;
	}

	/**
	 * Returns the Eden representation of the object.
	 * @return a string representing the source code of the object.
	 */
	/*override*/ public function toSource(indent:Number, indentor:String):String 
	{
		return Serializer.getSourceOf(this, [Serializer.toSource(_extractList())]) ;
	}
	
}