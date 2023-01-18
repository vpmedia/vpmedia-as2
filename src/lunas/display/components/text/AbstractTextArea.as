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

import lunas.display.components.text.AbstractLabel;

import pegas.events.UIEvent;
import pegas.events.UIEventType;

import vegas.events.Delegate;

/**
 * The AbstractTextArea class.
 * @author eKameleon
 */
class lunas.display.components.text.AbstractTextArea extends AbstractLabel 
{

	/**
	 * Creates a new AbstractTextArea instance.
	 */
	private function AbstractTextArea() 
	{ 
		field.onChanged = Delegate.create(this, notifyChanged) ;
		field.onScroller = Delegate.create(this, notifyScroll) ;
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

	public function get editable():Boolean 
	{
		return getEditable() ;	
	}
	
	public function set editable(b:Boolean):Void 
	{
		setEditable(b) ;	
	}

	/**
	 * The TextField reference of this component.
	 */
	public var field:TextField ;

	public function get hPosition():Number 
	{
		return getHPosition() ;	
	}
	
	public function set hPosition(n:Number):Void 
	{
		setHPosition(n) ;	
	}

	public function get hScrollPolicy():Number 
	{
		return getHScrollPolicy() ;	
	}
	
	public function set hScrollPolicy(n:Number):Void 
	{
		setHScrollPolicy(n) ;	
	}

	public function get length():Number 
	{
		return getLength() ;	
	}

	public function get maxHPosition():Number 
	{
		return getMaxHPosition() ;	
	}
	
	public function get maxVPosition():Number 
	{
		return getMaxVPosition() ;	
	}

	public function get vPosition():Number 
	{
		return getVPosition() ;	
	}
	
	public function set vPosition(n:Number):Void 
	{
		setVPosition(n) ;	
	}

	public function get vScrollPolicy():Number 
	{
		return getVScrollPolicy() ;	
	}
	
	public function set vScrollPolicy(n:Number):Void 
	{
		setVScrollPolicy(n) ;	
	}

	public function getEditable():Boolean 
	{
		return _editable ;
	}

	public function getHPosition():Number 
	{
		return field.hscroll ;
	}

	public function getHScrollPolicy():Number 
	{
		return _hscrollPolicy ;
	}
	
	public function getLength():Number 
	{
		return field.text.length ;
	}

	public function getMaxHPosition():Number 
	{
		return field.maxhscroll ;
	}

	public function getMaxVPosition():Number 
	{
		return field.maxscroll ;
	}

	public function getVPosition():Number 
	{
		return field.scroll ;
	}

	public function getVScrollPolicy():Number 
	{
		return _vscrollPolicy ;
	}

	public function notifyScroll():Void 
	{
		dispatchEvent( new UIEvent (UIEventType.SCROLL) ) ;
	}

	public function setEditable(b:Boolean):Void
	{
		_editable = b ;
		update() ;
	}

	public function setHPosition(n:Number) 
	{
		field.hscroll = n ;
	}

	public function setHScrollPolicy(n:Number) {
		_hscrollPolicy = ScrollPolicy.validate(n) ? n : ScrollPolicy.OFF ;
		update() ;
	}	

	public function setVPosition(n:Number) {
		field.scroll = n ;
	}	

	public function setVScrollPolicy(n:Number) 
	{
		_vscrollPolicy = ScrollPolicy.validate(n) ? n : ScrollPolicy.OFF ;
		update() ;
	}	

	private var _editable:Boolean ;
	private var _hscrollPolicy:Number ;
	private var _vscrollPolicy:Number ;
	
}