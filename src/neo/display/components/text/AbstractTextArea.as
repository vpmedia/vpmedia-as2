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

/* -------- AbstractTextArea


	AUTHOR

		Name : AbstractTextArea
		Package : neo.display.components.text
		Version : 1.0.0.0
		Date :  2006-02-22
		Author : ekameleon
		URL : http://www.ekameleon.net
		Mail : contact@ekameleon.net

	PROPERTY SUMMARY

		- autoSize:Boolean

		- editable:Boolean [R/W]

		- field:TextField

		- hPosition:Number

		- label:String [R/W]

		- length:Number [Read Only]

		- maxHPosition:Number [Read Only]

		- maxVPosition:Number [Read Only]

		- vPosition:Number

	METHOD SUMMARY
		
		- getAutoSize():Boolean

		- getEditable():Boolean

		- getHTML():Boolean

		- getHPosition():Number

		- getHScrollPolicy():Number

		- getLabel():String

		- getLength():Number

		- getMaxHPosition():Number

		- getMaxVPosition():Number 

		- getText():String

		- getVPosition():Number

		- getVScrollPolicy():Number

 		- registerField():Void
		
		- setHTML(b:Boolean):Void

		- setAutoSize(b:Boolean):Void

		- setEditable(b:Boolean):Void

		- setHPosition(n:Number)

		- setHScrollPolicy(n:Number)

		- setLabel(str:String):Void

		- setText(str:String):Void

		- setVPosition(n:Number)

		- setVScrollPolicy(n:Number)

 		- unRegisterField():Void
 
		- viewLabelChanged():Void (override this method)

	IMPLEMENTS 
	
		ILabel, IEventTarget

	EVENT SUMMARY

		UIEvent

	EVENT TYPE SUMMARY

		- UIEventType.CHANGE
		- UIEventType.LABEL_CHANGE
		- UIEventType.SCROLL
	
	INHERIT 
	
		MovieClip
			|
			AbstractComponent
				|
				AbstractLabel

	SEE ALSO
	
		IBuilder, IStyle
	

----------------*/


import com.bourre.commands.Delegate;

import neo.display.components.text.AbstractLabel;
import neo.display.ScrollPolicy;
import neo.events.UIEvent;
import neo.events.UIEventType;
import neo.util.factory.PropertyFactory;

class neo.display.components.text.AbstractTextArea extends AbstractLabel {

	// ----o Constructor

	private function AbstractTextArea() { 
		_eScroll = new UIEvent (UIEventType.SCROLL) ;
		// registerField() ;
	}

	// ----o Constants

	static public var AUTO:Number = ScrollPolicy.AUTO ;

	static public var OFF:Number = ScrollPolicy.OFF ;

	static public var ON:Number = ScrollPolicy.ON ;

	static private var __ASPF__ = _global.ASSetPropFlags(AbstractTextArea, null, 7, 7) ;

	// ----o Public Properties
	
	public var editable:Boolean ; // [R/W]

	public var field:TextField ;

	public var hPosition:Number ; // [R/W]

	public var hScrollPolicy:Number ; // [R/W]

	public var length:Number ; // [Read Only]

	public var maxHPosition:Number ; // [Read Only]

	public var maxVPosition:Number ; // [Read Only]

	public var vPosition:Number ; // [R/W]

	public var vScrollPolicy:Number ; // [R/W]

	// ----o Public Methods
	
	public function getEditable():Boolean {
		return _editable ;
	}

	public function getHPosition():Number {
		return field.hscroll ;
	}

	public function getHScrollPolicy():Number {
		return _hscrollPolicy ;
	}
	
	public function getLength():Number {
		return field.text.length ;
	}

	public function getMaxHPosition():Number {
		return field.maxhscroll ;
	}

	public function getMaxVPosition():Number {
		return field.maxscroll ;
	}

	public function getVPosition():Number {
		return field.scroll ;
	}

	public function getVScrollPolicy():Number {
		return _vscrollPolicy ;
	}

	public function notifyScroll():Void {
		broadcastEvent( _eScroll ) ;
	}

	public function registerField():Void {
		field.onChanged = Delegate.create(this, notifyChanged) ;
		field.onScroller = Delegate.create(this, notifyScroll) ;
	}

	public function setEditable(b:Boolean):Void {
		_editable = b ;
		update() ;
	}

	public function setHPosition(n:Number) {
		field.hscroll = n ;
	}

	public function setHScrollPolicy(n:Number) {
		_hscrollPolicy = ScrollPolicy.validate(n) ? n : ScrollPolicy.OFF ;
		update() ;
	}	

	public function setVPosition(n:Number) {
		field.scroll = n ;
	}	

	public function setVScrollPolicy(n:Number) {
		_vscrollPolicy = ScrollPolicy.validate(n) ? n : ScrollPolicy.OFF ;
		update() ;
	}	


	public function unRegisterField():Void {
		delete field.onChanged ;
		delete field.onScroller ;
	}
	
	/* AbstractLabel Method (override!!)

	

	public function viewLabelChanged():Void {

		// override this method when label property change

	}
	

	*/
	
	// ----o Virtual Properties
	
	static private var __EDITABLE__:Boolean = PropertyFactory.create(AbstractTextArea, "editable", true) ;
	static private var __HPOSITION__:Boolean = PropertyFactory.create(AbstractTextArea, "hPosition", true) ;
	static private var __HSCROLL_POLICY__:Boolean = PropertyFactory.create(AbstractTextArea, "hScrollPolicy", true) ;
	static private var __LENGTH__:Boolean = PropertyFactory.create(AbstractTextArea, "length", true, true) ;
	static private var __MAX_HPOSITION__:Boolean = PropertyFactory.create(AbstractTextArea, "maxHPosition", true, true) ;
	static private var __MAX_VPOSITION__:Boolean = PropertyFactory.create(AbstractTextArea, "maxVPosition", true, true) ;
	static private var __VPOSITION__:Boolean = PropertyFactory.create(AbstractTextArea, "vPosition", true) ;
	static private var __VSCROLL_POLICY__:Boolean = PropertyFactory.create(AbstractTextArea, "vScrollPolicy", true) ;
	
	// ----o Private Properties
	
	private var _editable:Boolean ;
	private var _eScroll : UIEvent;;
	private var _hPosition:Number ;
	private var _hscrollPolicy:Number ;
	private var _vPosition:Number ;
	private var _vscrollPolicy:Number ;
	
}

