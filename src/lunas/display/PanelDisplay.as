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

/** PanelDisplay

	AUTHOR

		Name : PanelDisplay
		Package : optisio.display
		Version : 1.0.0.0
		Date :  2006-05-10
		Author : eKameleon
		URL : http://www.ekameleon.net
		Mail : vegas@ekameleon.net

	PROPERTY SUMMARY
		
		- enabled:Boolean [R/W]
		
		- height:Number [R/W]

		- view

		-  width:Number [R/W]

	METHOD SUMMARY

		- createChild( c:Function, name:String , depth:Number , init )
		
		- getEnabled():Boolean
		
		- getLoader():ILoader
		
		- getName():String
		
		- getWidth():Number
		
		- getX():Number
		
		- getY():Number
		
		- hide():Void
		
		- isVisible():Boolean
		
		- move( x:Number, y:Number ) : Void
		
		- release() : Void
		
		- setEnabled(b:Boolean):Void
		
		- setHeight( n:Number ) : Void
		
		- setWidth( n:Number ) : Void
		
		- setX( n:Number ) : Void
		
		- setY( n:Number ) : Void
		
		- show():Void

	INHERIT
		
		CoreObject → AbstractCoreEventDispatcher → DisplayObject → PanelDisplay

**/

import asgard.display.DisplayObject;

import lunas.display.components.container.PanelContainer;
import lunas.events.PanelEvent;
import lunas.events.PanelEventType;

import pegas.geom.Point;

import vegas.events.Delegate;
import vegas.util.factory.DisplayFactory;

/**
 * @author eKameleon
 */
class lunas.display.PanelDisplay extends DisplayObject {
	
	// ----o Constructor
	
	private function PanelDisplay() {
		
		super( PanelDisplay.PANEL, DisplayFactory.createChild(PanelDisplay.PANEL_RENDERER, PANEL, PANEL_DEPTH, PANEL_ROOT ) ) ;
		
		if (view) {
		
			view.addEventListener(PanelEventType.HIDE, new Delegate(this, onHide) ) ;
			view.addEventListener(PanelEventType.SHOW, new Delegate(this, onShow)) ;
		
			Stage.addListener(this) ;
		
			dispatchEvent( new PanelEvent(PanelEventType.CREATE)) ;
			
		}
	}
	
	// ----o Constants
	
	static public var PANEL:String = "__PANEL__" ;
	
	static public var PANEL_DEPTH:Number = 9775 ;
	
	static public var PANEL_RENDERER:Function = PanelContainer ;
	
	static public var PANEL_ROOT:MovieClip = _root ;

	// ----o Public Methods

	public function addChild(o, oInit):MovieClip {
		return view.addChild(o, oInit) ;
	}
	
	public function getChildByKey(key:Number):MovieClip {
		return view.getChildByKey(key) ;
	}
	
	/**
	 * @return singleton instance of PanelDisplay
	 */
	static public function getInstance():PanelDisplay {
		if (_instance == null) _instance = new PanelDisplay();
		return _instance;
	}
	
	public function getPanel():MovieClip { 
		return view ;
	}
	
	public function hide():Void {
		view.hide() ;
		Mouse.removeListener(this) ;
	}
	
	public function onHide(ev:PanelEvent):Void {
		_currentItem = undefined ;
		dispatchEvent( new PanelEvent(PanelEventType.HIDE, ev.key, ev.item, this) ) ;
	}

	public function onShow(ev:PanelEvent):Void {
		Mouse.addListener(this) ;
		_currentItem = ev.item ;
		dispatchEvent( new PanelEvent(PanelEventType.SHOW, ev.key, ev.item, this) ) ;
	}
	
	public function removeChildByKey(key:Number):Void {
		view.removeChild(getChildByKey(key)) ;
	}
	
	public function show( oKey, x:Number, y:Number, reference:MovieClip):Void {
		var oP:Point = new Point(x , y) ;
		if (reference != undefined) {
			reference.localToGlobal(oP) ;
		}
		view.show( oKey, oP.x, oP.y) ;
	}
	
	// ----o Private Properties

	private var _currentItem:MovieClip ;
	static private var _instance:PanelDisplay ;
	
	// ----o Private Methods

	private function _isOut(mc:MovieClip):Boolean {
		var mX:Number = mc._xmouse ;
		var mY:Number = mc._ymouse ;
		var minX:Number = 0 ;
		var minY:Number = 0 ;
		var maxX:Number = (mc.w > minX) ? mc.w : mc._width ;
		var maxY:Number = (mc.h > minY) ? mc.h : mc._height ;
		return (mX < minX || mX > maxX || mY < minY || mY > maxY) ;
	}

	private function onMouseDown():Void {
		if (_isOut(_currentItem)) {
			hide() ;
		}
	}
	
	private function onResize():Void { 
		hide() ;
	}

}