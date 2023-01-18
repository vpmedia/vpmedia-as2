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

/**
 * This static enumeration defined all UI elements in a FlashPaper document.
 */
class asgard.display.FlashPaperUIElement 
{

	/**
	 * The Find display.
	 */
	static public var FIND:String = "Find" ;
	
	/**
	 * The Overflow menu on the toolbar is hidden or shown.
	 */
	static public var OVERFLOW:String = "OverFlow" ;
	
	/**
	 * The Current Page and Number of Pages fields in the toolbar are hidden or shown.
	 */
	static public var PAGE:String = "Page" ;
	
	/**
	 * The Open Document in New Browser Window toolbar button is hidden or shown.
	 */
	static public var POP:String = "Pop" ;
	
	/**
	 * The Previous Page and Next Page toolbar buttons are hidden or shown.
	 */
	static public var PREV_NEXT:String = "PrevNext" ;
	
	/**
	 * The Print toolbar button is hidden or shown.
	 */
	static public var PRINT:String = "Print" ;
	
	/**
	 * The sidebar (displaying the document outline) is hidden or shown.
	 */
	static public var SIDEBAR:String = "Sidebar" ;
	
	/**
	 * All tool selection buttons on the toolbar are hidden or shown.
	 */
	static public var TOOL:String = "Tool" ;
	
	/**
	 * All zoom-related controls on the toolbar are hidden or shown.
	 */
	static public var ZOOM:String = "Zoom" ;
	
	/**
	 * This value doesn't affect the user interface; it is used to enable or disable various keys used to zoom in or out of the document (for example, +, -, p, w).
	 */
	static public var ZOOM_KEYS:String = "ZoomKeys" ;
	
	static private var __ASPF__ = _global.ASSetPropFlags(FlashPaperUIElement, null , 7, 7) ;

}
