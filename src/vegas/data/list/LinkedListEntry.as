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

import vegas.core.CoreObject ;

/**
 * Internal class in the {@code LinkedList} class to defined all entries in the list and the links betweens alls.
 * @author eKameleon
 */
class vegas.data.list.LinkedListEntry extends CoreObject
{

	/**
	 * Creates a new LinkedListEntry instance.
	 * @param element the value of the entry in the LinkedList
	 * @param the next LinkedListEntry of this entry.
	 * @param the previous LinkedListEntry of this entry.
	 */
	function LinkedListEntry( element , next:LinkedListEntry , previous:LinkedListEntry)
	{
		this.element = element ;
		this.next = next ;
		this.previous = previous ;	
	}
	
	/**
	 * The element of this entry.
	 */
	public var element ;
	
	/**
	 * The next entry.
	 */
	public var next:LinkedListEntry ;
	
	/**
	 * The previous entry.
	 */
	public var previous:LinkedListEntry ;
	
}