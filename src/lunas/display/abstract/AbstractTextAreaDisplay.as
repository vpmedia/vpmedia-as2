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

import asgard.display.ScrollPolicy;

import lunas.display.abstract.AbstractLabelDisplay;

import pegas.events.UIEvent;

import vegas.events.Delegate;

/**
 * The AbstractTextAreaDisplay class.
 * @author eKameleon
 */
class lunas.display.abstract.AbstractTextAreaDisplay extends AbstractLabelDisplay
{

	/**
	 * Creates a new AbstractTextAreaDisplay instance.
	 * @param sName:String the name of the display.
	 * @param target:MovieClip the DisplayObject instance control this target.
	 */
	private function AbstractTextAreaDisplay( sName:String, target:MovieClip ) 
	{ 
		super ( sName , target ) ;
		registerField() ;
	}
	
	/**
	 * Determinates the value of the ScrollPolicy 'auto' mode.
	 */
	static public var AUTO:Number = ScrollPolicy.AUTO ;
	
	/**
	 * Determinates the value of the ScrollPolicy 'off' mode.
	 */
	static public var OFF:Number = ScrollPolicy.OFF ;
	
	/**
	 * Determinates the value of the ScrollPolicy 'on' mode.
	 */
	static public var ON:Number = ScrollPolicy.ON ;

	/**
	 * Indicates whether the component is editable {@code true} or not {@code false}. 
	 * The default value is true.
	 */
	public function get editable():Boolean 
	{
		return getEditable() ;	
	}

	/**
	 * Indicates whether the component is editable {@code true} or not {@code false}. 
	 * The default value is true.
	 */
	public function set editable(b:Boolean):Void 
	{
		setEditable(b) ;	
	}

	/**
	 * The TextField reference of this component.
	 */
	public var field:TextField ;

	/**
	 * Defines the horizontal position in pixels of the text in the field. The default value is 0.
	 */
	public function get hPosition():Number 
	{
		return getHPosition() ;	
	}
	
	/**
	 * Defines the horizontal position in pixels of the text in the field. The default value is 0.
	 */
	public function set hPosition(n:Number):Void 
	{
		setHPosition(n) ;	
	}
	
	/** 
	 * Determines whether the horizontal scroll bar :
	 * <ul>
	 * <li>Is always present : <b>ScrollPolicy.ON)</b>.</li> 
	 * <li>Is never present <b>ScrollPolicy.OFF</b>.<li>
	 * <li>Appears automatically according to the size of the field : <b>ScrollPolicy.AUTO</b>.</li>
	 * </ul> 
	 * The default value is ScrollPolicy.AUTO.
	 */
	public function get hScrollPolicy():Number 
	{
		return getHScrollPolicy() ;	
	}
	
	/** 
	 * Determines whether the horizontal scroll bar :
	 * <ul>
	 * <li>Is always present : <b>ScrollPolicy.ON</b>.</li> 
	 * <li>Is never present <b>ScrollPolicy.OFF</b>.<li>
	 * <li>Appears automatically according to the size of the field : <b>ScrollPolicy.AUTO</b>.</li>
	 * </ul> 
	 * The default value is ScrollPolicy.AUTO.
	 */
	public function set hScrollPolicy(n:Number):Void 
	{
		setHScrollPolicy(n) ;	
	}
	
	/**
	 *  Indicates the number of characters in a text area. 
	 *  This property returns the same value as the ActionScript text.length property, but is faster. 
	 *  A character such as tab ("\t") counts as one character. 
	 *  The default value is 0.
	 */
	public function get length():Number 
	{
		return getLength() ;	
	}
	
	/**
	 * Indicates the maximum value of TextArea.hPosition. 
	 * The default value is 0.
	 */
	public function get maxHPosition():Number 
	{
		return getMaxHPosition() ;	
	}
	
	/**
	 * Indicates the maximum value of TextArea.vPosition. 
	 * The default value is 0.
	 */
	public function get maxVPosition():Number 
	{
		return getMaxVPosition() ;	
	}

	/**
	 * Defines the vertical scroll position of text in a text area. 
	 * This property is useful for directing users to a specific paragraph in a long passage, or creating scrolling text areas. 
	 * You can get and set this property. The default value is 0.
	 */
	public function get vPosition():Number 
	{
		return getVPosition() ;	
	}

	/**
	 * Defines the vertical scroll position of text in a text area. 
	 * This property is useful for directing users to a specific paragraph in a long passage, or creating scrolling text areas. 
	 * You can get and set this property. The default value is 0.
	 */
	public function set vPosition(n:Number):Void 
	{
		setVPosition(n) ;	
	}

	/** 
	 * Determines whether the vertical scroll bar :
	 * <ul>
	 * <li>Is always present : <b>ScrollPolicy.ON</b>.</li> 
	 * <li>Is never present <b>ScrollPolicy.OFF</b>.<li>
	 * <li>Appears automatically according to the size of the field : <b>ScrollPolicy.AUTO</b>.</li>
	 * </ul> 
	 * The default value is ScrollPolicy.AUTO.
	 */
	public function get vScrollPolicy():Number 
	{
		return getVScrollPolicy() ;	
	}

	/** 
	 * Determines whether the vertical scroll bar :
	 * <ul>
	 * <li>Is always present : <b>ScrollPolicy.ON</b>.</li> 
	 * <li>Is never present <b>ScrollPolicy.OFF</b>.<li>
	 * <li>Appears automatically according to the size of the field : <b>ScrollPolicy.AUTO</b>.</li>
	 * </ul> 
	 * The default value is ScrollPolicy.AUTO.
	 */
	public function set vScrollPolicy(n:Number):Void 
	{
		setVScrollPolicy(n) ;	
	}

	/**
	 * Indicates whether the component is editable {@code true} or not {@code false}. 
	 * The default value is true.
	 */
	public function getEditable():Boolean 
	{
		return _editable ;
	}

	/**
	 * Returns the horizontal position in pixels of the text in the field. The default value is 0.
	 * @return the horizontal position in pixels of the text in the field. The default value is 0.
	 */
	public function getHPosition():Number 
	{
		return field.hscroll ;
	}

	/** 
	 * Determines whether the horizontal scroll bar :
	 * <ul>
	 * <li>Is always present : <b>ScrollPolicy.ON)</b>.</li> 
	 * <li>Is never present <b>ScrollPolicy.OFF</b>.<li>
	 * <li>Appears automatically according to the size of the field : <b>ScrollPolicy.AUTO</b>.</li>
	 * </ul> 
	 * The default value is ScrollPolicy.AUTO.
	 */
	public function getHScrollPolicy():Number 
	{
		return _hscrollPolicy ;
	}

	/**
	 *  Indicates the number of characters in a text area. 
	 *  This property returns the same value as the ActionScript text.length property, but is faster. 
	 *  A character such as tab ("\t") counts as one character. 
	 *  The default value is 0.
	 */
	public function getLength():Number 
	{
		return field.text.length ;
	}

	/**
	 * Indicates the maximum value of TextArea.hPosition. 
	 * The default value is 0.
	 */
	public function getMaxHPosition():Number 
	{
		return field.maxhscroll ;
	}

	/**
	 * Indicates the maximum value of TextArea.vPosition. 
	 * The default value is 0.
	 */
	public function getMaxVPosition():Number 
	{
		return field.maxscroll ;
	}

	/**
	 * Defines the vertical scroll position of text in a text area. 
	 * This property is useful for directing users to a specific paragraph in a long passage, or creating scrolling text areas.
	 * The default value is 0.
	 */
	public function getVPosition():Number 
	{
		return field.scroll ;
	}
	
	/** 
	 * Determines whether the vertical scroll bar :
	 * <ul>
	 * <li>Is always present : <b>ScrollPolicy.ON</b>.</li> 
	 * <li>Is never present <b>ScrollPolicy.OFF</b>.<li>
	 * <li>Appears automatically according to the size of the field : <b>ScrollPolicy.AUTO</b>.</li>
	 * </ul> 
	 * The default value is ScrollPolicy.AUTO.
	 */
	public function getVScrollPolicy():Number 
	{
		return _vscrollPolicy ;
	}
	
	/**
	 * Initialize the internal events of this components.
	 */
	/*override*/ public function initEvent():Void
	{
		super.initEvent() ;
		_eScroll = new UIEvent (UIEvent.SCROLL, this) ;	
	}
	
	/**
	 * Notify the scroll of this component.
	 */
	public function notifyScroll():Void 
	{
		dispatchEvent( _eScroll ) ;
	}

	/**
	 * Register the internal field reference of this component.
	 * @return {@code true} if the register process is success.
	 */
	public function registerField():Boolean
	{
		if (field != null)
		{
			field.onChanged  = Delegate.create(this, notifyChanged ) ;
			field.onScroller = Delegate.create(this, notifyScroll  ) ;
			return true ;
		}
		else
		{
			return false ;
		}	
	}

	/**
	 * Indicates whether the component is editable {@code true} or not {@code false}. 
	 * The default value is true.
	 */
	public function setEditable(b:Boolean):Void
	{
		_editable = b ;
		update() ;
	}

	/**
	 * Sets the horizontal position in pixels of the text in the field. The default value is 0.
	 */
	public function setHPosition(n:Number) 
	{
		field.hscroll = n ;
	}

	/** 
	 * Determines whether the horizontal scroll bar :
	 * <ul>
	 * <li>Is always present : <b>ScrollPolicy.ON)</b>.</li> 
	 * <li>Is never present <b>ScrollPolicy.OFF</b>.<li>
	 * <li>Appears automatically according to the size of the field : <b>ScrollPolicy.AUTO</b>.</li>
	 * </ul> 
	 * The default value is ScrollPolicy.AUTO.
	 */
	public function setHScrollPolicy(n:Number) 
	{
		_hscrollPolicy = ScrollPolicy.validate(n) ? n : ScrollPolicy.OFF ;
		update() ;
	}	

	/**
	 * Defines the vertical scroll position of text in a text area. 
	 * This property is useful for directing users to a specific paragraph in a long passage, or creating scrolling text areas.
	 * The default value is 0.
	 */
	public function setVPosition(n:Number) 
	{
		field.scroll = n ;
	}	

	/** 
	 * Determines whether the vertical scroll bar :
	 * <ul>
	 * <li>Is always present : <b>ScrollPolicy.ON</b>.</li> 
	 * <li>Is never present <b>ScrollPolicy.OFF</b>.<li>
	 * <li>Appears automatically according to the size of the field : <b>ScrollPolicy.AUTO</b>.</li>
	 * </ul> 
	 * The default value is ScrollPolicy.AUTO.
	 */
	public function setVScrollPolicy(n:Number) 
	{
		_vscrollPolicy = ScrollPolicy.validate(n) ? n : ScrollPolicy.OFF ;
		update() ;
	}	
	
	/**
	 * Unregister the internal field reference of this component.
	 * @return {@code true} if the unregister process is success.
	 */
	public function unregisterField():Boolean
	{
		if (field != null)
		{
			delete field.onChanged  ;
			delete field.onScroller ;
			return true ;
		}
		else
		{
			return false ;		
		}
	}

	private var _editable:Boolean ;
	private var _eScroll:UIEvent ;
	private var _hscrollPolicy:Number ;
	private var _vscrollPolicy:Number ;
	
}