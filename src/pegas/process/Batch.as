/*

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  
           http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is PEGAS Framework.
  
  The Initial Developer of the Original Code is
  ALCARAZ Marc (aka eKameleon)  <vegas@ekameleon.net>.
  Portions created by the Initial Developer are Copyright (C) 2004-2007
  the Initial Developer. All Rights Reserved.
  
  Contributor(s) :
  
*/

import vegas.core.IRunnable;
import vegas.data.collections.SimpleCollection;
import vegas.data.collections.TypedCollection;
import vegas.data.iterator.Iterator;

/**
 * A batch is a collection of {@code Action} objects. All {@code Action} objects are processed as a single unit.
 * This class use an internal typed {@code SimpleCollection} to register all {@code Action} objects.  
 * @author eKameleon
 */
class pegas.process.Batch extends TypedCollection implements IRunnable 
{

	/**
	 * Creates a new Batch instance.
	 */
 	public function Batch() 
 	{
		super(IRunnable, new SimpleCollection()) ;
  	}

	/**
	 * Returns a shallow copy of the object.
	 * @return a shallow copy of the object.
	 */
	public function clone() 
	{
		var b:Batch = new Batch() ;
		var it:Iterator = iterator() ;
		while (it.hasNext()) b.insert(it.next()) ;
		return b ;
	}
	
	/**
	 * Runs the process.
	 */
 	public function run():Void 
 	{
		var ar:Array = toArray() ;
		var i:Number = -1 ;
		var l:Number = ar.length ;
		if (l>0) while (++i < l) 
		{ 
			ar[i].run() ; 
		}
  	}
	
}