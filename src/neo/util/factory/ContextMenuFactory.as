/*

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  
           http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is Neo Library.
  
  The Initial Developer of the Original Code is
  ALCARAZ Marc (aka eKameleon)  <contact@ekameleon.net>.
  Portions created by the Initial Developer are Copyright (C) 2004-2005
  the Initial Developer. All Rights Reserved.
  
  Contributor(s) :
  
*/

/* -------- ContextMenuFactory

	AUTHOR
	
		Name : ContextMenuFactory
		Package : neo.util.factory
		Version : 1.0.0.0
		Date :  2005-10-15
		Author : ekameleon
		URL : http://www.ekameleon.net
		Mail : vegas@ekameleon.net

	METHOD SUMMARY

		- static createItemURL(label:String, url:String, target:String):ContextMenuItem
		
		- static createItemProxy(label:String, obj, func:Function, separator:Boolean, args:Array):ContextMenuItem

----------------*/

import com.bourre.commands.Delegate;

class neo.util.factory.ContextMenuFactory {
	
	// ----o Constructor
	
	private function ContextMenuFactory() {
		//
	}
	

	// ----o static public Methods
	
	static public function createItemURL(label:String, url:String, target:String, separator:Boolean):ContextMenuItem {
		var f:Function = Delegate.create(ContextMenuFactory, _getURL, url, target) ;
		var c:ContextMenuItem = new ContextMenuItem(label, f) ;
		c.separatorBefore = separator ;
		return c ;
	}
	
	static public function createItemProxy( label:String, o , f:Function, separator:Boolean , args:Array):ContextMenuItem {
		var c:ContextMenuItem = new ContextMenuItem(label, Delegate.create.apply(null, [o, f].concat(args)) ) ;
		c.separatorBefore = separator ;
		return c ;
	}
	
	// ----o static private Methods
	
	static private function _getURL(target, item, url:String, where:String) {
		getURL(url, where || "_blank") ;	
	}
	
}