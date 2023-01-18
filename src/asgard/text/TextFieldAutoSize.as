/*

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  
           http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is ASGard Framework.
  
  The Initial Developer of the Original Code is
  ALCARAZ Marc (aka eKameleon)  <vegas@ekameleon.net>.
  Portions created by the Initial Developer are Copyright (C) 2004-2007
  the Initial Developer. All Rights Reserved.
  
  Contributor(s) :
  
*/

/**
 * The TextFieldAutoSize class is an enumeration of constant values used in setting the autoSize property of the TextField class.
 * @author eKameleon
 */
class asgard.text.TextFieldAutoSize 
{
	
	/**
	 * Specifies that the text is to be treated as center-justified text.
	 */
	static public var CENTER:String = "center" ;
	
	/**
	 * Specifies that the text is to be treated as left-justified text, meaning that the left side of the text field remains fixed and any resizing of a single line is on the right side.
	 */
	static public var LEFT:String = "left" ;
	
	/**
	 * Specifies that no resizing is to occur.
	 */
	static public var NONE:String = "none" ;
	
	/**
	 * Specifies that the text is to be treated as right-justified text, meaning that the right side of the text field remains fixed and any resizing of a single line is on the left side.
	 */
	static public var RIGHT:String = "right" ;

	static private var __ASPF__ = _global.ASSetPropFlags(TextFieldAutoSize, null , 7, 7) ;

}