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

import vegas.events.Delegate;

/**
 * This factory static class is an all-static class with methods to creates different {@code ContextMenuItem} objects.
 * @author eKameleon
 * @see ContextMenu
 * @see ContextMenuItem
 */
class vegas.util.factory.ContextMenuFactory 
{

	/**
	 * Creates a {@code ContextMenuItem} who launch an exteral url when the user select this item in a ContextMenu.
	 * @return a {@code ContextMenuItem} reference.
	 */
	static public function createItemURL(label:String, url:String, target:String, separator:Boolean):ContextMenuItem 
	{
		var f:Function = Delegate.create(ContextMenuFactory, _getURL, url, target) ;
		var c:ContextMenuItem = new ContextMenuItem(label, f) ;
		c.separatorBefore = separator ;
		return c ;
	}
	
	/**
	 * Creates a {@code ContextMenuItem} who use a proxy method when the user select this item in a ContextMenu.
	 * @return a {@code ContextMenuItem} reference.
	 */
	static public function createItemProxy( label:String, scope , method:Function, separator:Boolean , args:Array):ContextMenuItem 
	{
		var c:ContextMenuItem = new ContextMenuItem(label, Delegate.create.apply(null, [scope, method].concat(args)) ) ;
		c.separatorBefore = separator ;
		return c ;
	}
	
	/**
	 * Internal proxy method to launch {@code getURL} method.
	 */
	static private function _getURL(target, item, url:String, where:String) 
	{
		getURL(url, where || "_blank") ;	
	}
	
}