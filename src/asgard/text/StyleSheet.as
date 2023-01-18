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

import vegas.core.HashCode;
import vegas.core.IFormattable;
import vegas.core.IHashable;
import vegas.util.ConstructorUtil;

/**
 * The StyleSheet class lets you create a StyleSheet object that contains text formatting rules for font size, color, and other styles.
 * You can then apply styles defined by a style sheet to a TextField object that contains HTML or XML-formatted text. The text in the TextField object is automatically formatted according to the tag styles defined by the StyleSheet object. You can use text styles to define new formatting tags, redefine built-in HTML tags, or create style classes that you can apply to certain HTML tags.
 * <p>To apply styles to a TextField object, assign the StyleSheet object to a TextField object's styleSheet property.</p>
 * This class is polymorph with the AS3 flash.text.StyleSheet class.
 * @author eKameleon
 * @see TextField.StyleSheet
 */
class asgard.text.StyleSheet extends TextField.StyleSheet implements IFormattable, IHashable
{
	
	/**
	 * Creates a new StyleSheet instance.
	 * @param str an optional css text to be parsed. You can use the class URLLoader to load the external CSS file.
	 * @see URLLoader
	 */
	function StyleSheet( str:String ) 
	{
		if (str != null)
		{
			parseCSS(str) ;
		}
	}

	/**
	 * [read-only] An array that contains the names (as strings) of all of the styles registered in this style sheet.
	 */
	public function get styleNames():Array
	{
		return getStyleNames() ;	
	}

	/**
	 * Returns a hashcode value for the object.
	 * @return a hashcode value for the object.
	 */
	public function hashCode():Number 
	{
		return null ;
	}

	/**
	 * Returns the string representation of this instance.
	 * @return the string representation of this instance.
	 */
	public function toString():String 
	{
		return "[" + ConstructorUtil.getName(this) + "]" ;
	}


	static private var _initHashCode:Boolean = HashCode.initialize( asgard.text.StyleSheet.prototype) ;

}