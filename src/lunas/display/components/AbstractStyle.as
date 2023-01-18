/*

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  
           http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is LunAS Library.
  
  The Initial Developer of the Original Code is
  ALCARAZ Marc (aka eKameleon)  <vegas@ekameleon.net>.
  Portions created by the Initial Developer are Copyright (C) 2004-2007
  the Initial Developer. All Rights Reserved.
  
  Contributor(s) :
  
*/

import lunas.core.IStyle;
import lunas.events.StyleEvent;

import vegas.events.AbstractCoreEventDispatcher;
import vegas.string.HTMLStringFormatter;
import vegas.util.TypeUtil;

/**
 * This class provides a skeletal implementation of the {@code IStyle} interface, to minimize the effort required to implement this interface.
 * @author eKameleon
 */
class lunas.display.components.AbstractStyle extends AbstractCoreEventDispatcher implements IStyle 
{

	/**
	 * Creates a new AbstractStyle instance.
	 */
	private function AbstractStyle ( init:Object ) 
	{
		for (var prop:String in init) 
		{
			this[prop] = init[prop] ;
		}
		initialize() ;
		update() ;
	}
	
	/**
	 * Returns the name of the style of the principal label field of the display or component.
	 * @return the name of the style of the principal label field of the display or component.
	 */
	public function get labelStyleName():String 
	{
		return getLabelStyleName() ; 	
	}

	/**
	 * Sets the name of the style of the principal label field of the display or component.
	 */
	public function set labelStyleName(s:String):Void 
	{
		setLabelStyleName(s) ; 	
	}
	
	/**
	 * Returns the style sheet reference of this object.
	 * @return the style sheet reference of this object.
	 */
	public function get styleSheet():TextField.StyleSheet 
	{
		return getStyleSheet() ; 	
	}

	/**
	 * Sets the style sheet reference of this object.
	 */
	public function set styleSheet(ss:TextField.StyleSheet):Void 
	{
		setStyleSheet(ss) ; 	
	}
	
	/**
	 * Invoqued in the constructor of the {@code IStyle} instance.
	 * You must overrerides this method to customize your object.
	 */
	public function initialize():Void 
	{
		// overrides
	}
	
	/**
	 * Returns the formatting string representation of the specified label in argument.
	 * @param str The String to format.
	 * @param styleName The optional style name of the string (use span tag to format the string).
	 * @return the formatting string representation of the specified label in argument.
	 */
	public function getFieldText( str:String , styleName:String ):String 
	{
		if ( str.length > 0 ) 
		{
			return HTMLStringFormatter.span( str , (styleName || getLabelStyleName()) ) ;
		}
		else
		{
			return "" ;	
		}
	}

	/**
	 * Returns the name of the style of the principal label field of the display or component.
	 * @return the name of the style of the principal label field of the display or component.
	 */
	public function getLabelStyleName():String 
	{
		return _labelStyleName || "" ;	
	}
	
	/**
	 * Returns the value of the specified property if it's exist in the object, else returns null.
	 * @return the value of the specified property if it's exist in the object or {@code null}.
	 */
	public function getStyle(prop:String) 
	{ 
		return this[prop] || null ;
	}

	/**
	 * Returns the style sheet reference of this object.
	 * @return the style sheet reference of this object.
	 */
	public function getStyleSheet():TextField.StyleSheet 
	{ 
		return _oS ;
	}

	/**
	 * Sets the name of the style of the principal label field of the display or component.
	 */
	public function setLabelStyleName(s:String):Void 
	{
		_labelStyleName = s || null ;	
	}

	/**
	 * Sets the properties of this {@code IStyle} object.
	 */
	public function setStyle( /*...args*/ ):Void 
	{

		if (arguments.length == 0 || arguments[0] == null) 
		{
			return ;
		} 
		
		if (TypeUtil.typesMatch(arguments[0], String) && arguments.length > 1) 
		{
			this[arguments[0]] = arguments[1] ;
		}
		else if (arguments[0] instanceof Object) 
		{
			var prop = arguments[0] ;
			for (var i:String in prop) 
			{
				this[i] = prop[i] ;
			}
		}
		
		dispatchEvent( new StyleEvent(StyleEvent.STYLE_CHANGED, this)) ;
		
		
	}
	
	/**
	 * Sets the style sheet if this {@code IStyle} object.
	 */
	public function setStyleSheet( ss:TextField.StyleSheet ):Void 
	{
		_oS = ss ;
		styleSheetChanged() ;
		dispatchEvent(new StyleEvent(StyleEvent.STYLE_SHEET_CHANGED, this)) ;
	}

	/**
	 * Invoqued when a style property of this {@code IStyle} change.
	 */
	public function styleChanged():Void 
	{
		// override
	}
	
	/**
	 * Invoqued when the styleSheet value of this {@code IStyle} change.
	 */
	public function styleSheetChanged():Void 
	{
		// override
	}

	/**
	 * Update the {@code IStyle} object.
	 */
	public function update():Void 
	{
		// override with super !
		styleChanged() ;
	}

	private var _labelStyleName:String = null ;
	private var _oS:TextField.StyleSheet ;

}