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

/* ------- UIEventType

	AUTHOR

		Name : UIEventType
		Package : neo.events
		Version : 1.0.0.0
		Date :  2006-02-05
		Author : ekameleon
		URL : http://www.ekameleon.net
		Mail : contact@ekameleon.net
	
	CONSTRUCTOR
	
		private
	
	CONSTANT SUMMARY

		- ADDED:UIEventType

		
			The added event occurs when a DisplayObject has been added to the display list.

		
		- CANCEL:UIEventType
			
		- CHANGE:UIEventType
		
		- CLOSE:UIEventType
		
		- COMPLETE:UIEventType
		
		- CONNECT:UIEventType
		
		- CREATE:UIEventType
		
		- DESTROY:UIEventType
			
		- ENABLED_CHANGE:UIEventType
		
		- ENTER_FRAME:UIEventType
			
		- ICON_CHANGE:UIEventType ("onIconChanged")
		
		- INIT:UIEventType
			A Loader object generates the INIT event when the properties and methods of a loaded SWF file are accessible.
		
		- LABEL_CHANGE:UIEventType ("onLabelChanged")
		
		- REMOVED:UIEventType
			Flash Player dispatches the removed event when a DisplayObject is about to be removed from the display list.
		
		- RENDER:UIEventType
			Flash Player dispatches the render event when the display list is about to be updated and rendered.
		
		- RESIZE:UIEventType
			Flash Player dispatches the resize event when Stage.scaleMode is set to "noScale" and the SWF file has been resized.
		
		- SCROLL:UIEventType
			A TextField object generates the scroll event after the user scrolls.
		
		- SELECT:UIEventType
			A FileReference object generates the select event when an item has been selected.
		
		- STYLE_CHANGE:UIEventType

		- UNLOAD:UIEventType
			A Loader object generates the unload event whenever a loaded SWF file is removed using the Loader.unload() method.
		
		- UNSELECT:UIEventType

----------  */


import com.bourre.events.EventType;


class neo.events.UIEventType extends EventType {

	// ----o Constructor
	
	private function UIEventType(s:String) {
		super(s) ;
	}


	// ----o Static Properties
		

	static public var ADDED:UIEventType = new UIEventType("added") ;
	
	static public var CANCEL:UIEventType = new UIEventType("cancel") ;
	
	static public var CHANGE:UIEventType = new UIEventType("change") ;
	
	static public var CLOSE:UIEventType = new UIEventType("close") ;
	
	static public var COMPLETE:UIEventType = new UIEventType("complete") ;
	
	static public var CONNECT:UIEventType = new UIEventType("connect") ;
	
	static public var CREATE:UIEventType = new UIEventType("create") ;

	static public var DESTROY:UIEventType = new UIEventType("destroy") ;

	static public var ENABLED_CHANGE:UIEventType = new UIEventType("enabled_change") ;
	
	static public var ENTER_FRAME:UIEventType = new UIEventType("enterframe") ;
	
	static public var ICON_CHANGE:UIEventType = new UIEventType("onIconChanged") ;
	
	static public var INIT:UIEventType = new UIEventType("init") ;
	
	static public var LABEL_CHANGE:UIEventType = new UIEventType("onLabelChanged") ;
	
	static public var REMOVED:UIEventType = new UIEventType("removed") ;
	
	static public var RENDER:UIEventType = new UIEventType("render") ;
	
	static public var RESIZE:UIEventType = new UIEventType("resize") ;
	
	static public var SCROLL:UIEventType = new UIEventType("scroll") ;
	
	static public var SELECT:UIEventType = new UIEventType("select") ;

	static public var STYLE_CHANGE:UIEventType = new UIEventType("styleChange") ;

	static public var UNLOAD:UIEventType = new UIEventType("unload") ;

	static public var UNSELECT:UIEventType = new UIEventType("unselect") ;

	static private var __ASPF__ = _global.ASSetPropFlags(UIEventType, null , 7, 7) ;
	
}

