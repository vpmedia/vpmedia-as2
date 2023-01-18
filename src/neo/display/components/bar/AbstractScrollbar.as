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

/* ------- 	AbstractScrollbar

	AUTHOR
	
		Name : AbstractScrollbar
		Package : neo.display.components.bar
		Version : 1.0.0.0
		Date :  2006-02-10
		Author : ekameleon
		URL : http://www.ekameleon.net
		Mail : contact@ekameleon.net

	PROPERTY SUMMARY
	
		- direction:Number [R/W]
		
		- duration:Number
		
		- easing:Function
				
		- isDragging:Boolean [Read Only]
		
		- noEasing:Boolean
		
			Cette propriété permet de définir si la barre utilise une Tween ou pas à chaque changement de la valeur position.
		
		- position:Number [R/W]
	
	METHOD SUMMARY
		
		- dragging():Void
		
		- getBar():MovieClip
		
		- getDirection():Number
		
		- getPosition():Number
		
		- getThumb():MovieClip
		
		- setDirection(n:Number):Void
		
		- setPosition(pos:Number, noEvent:Boolean):Void
		
		- startDragging():Void
		
		- stopDragging():Void
	
	EVENT TYPE SUMMARY
	
		- DRAG:EventType
		
		- CHANGE:EventType
	
----------  */

import com.bourre.events.EventType;
import com.bourre.transitions.TweenFPS;

import neo.display.components.bar.AbstractProgressbar;
import neo.display.components.IScrollbar;
import neo.display.Direction;
import neo.events.ButtonEvent;
import neo.events.ButtonEventType;
import neo.transitions.easing.Back;
import neo.util.factory.PropertyFactory;
import neo.util.MathsUtil;

class neo.display.components.bar.AbstractScrollbar extends AbstractProgressbar implements IScrollbar {

	// ----o Constructor
	
	private function AbstractScrollbar() {
		_eDrag = new ButtonEvent(ButtonEventType.DRAG, this) ;
	}

	// ----o Constant
	
	static public var DRAG:EventType = ButtonEventType.DRAG ;
	
	static private var __ASPF__ = _global.ASSetPropFlags(AbstractScrollbar, null, 7, 7) ;
	
	// ----o Public Properties

	public var duration:Number = 24  ;	
	public var easing:Function = null ;
	public var isDragging:Boolean ; // [Read Only]
	public var noEasing:Boolean = true ;
	
	// ----o Public Methods		

	public function dragging():Void {
		var sizeField:String = getSizeField() ;
		var mouseField:String = getMouseField() ;
		var b:MovieClip = getBar() ;
		var t:MovieClip = getThumb() ;
		var size:Number =  b[sizeField] - t[sizeField] ;
		var pos:Number = this[mouseField] - _mouseOffset ;
		pos = MathsUtil.getPercent( MathsUtil.clamp(pos, 0, size), size ) ;
		setPosition( pos ) ;
		notifyDrag() ;
	}

	public function getBar():MovieClip {
		return null ; // override this method !
	}

	public function getIsDragging():Boolean {
		return _isDragging ;
	}
	
	public function getSizeField():String {
		return (getDirection() == Direction.VERTICAL) ? "_height" : "_width" ;
	}
	
	public function getMouseField():String {
		return (getDirection() == Direction.VERTICAL) ? "_ymouse" : "_xmouse" ;
	}
	
	public function getThumb():MovieClip {
		return null ; // override this method !
	}

	public function notifyDrag():Void {
		broadcastEvent( _eDrag ) ;
	}

	public function startDragging():Void {
		var mouseField:String = (_nDirection == Direction.VERTICAL) ? "_ymouse" : "_xmouse" ;
		_mouseOffset = (getThumb())[mouseField] ;
		dragging() ;
		_isDragging = true ;
		onMouseMove = dragging ;
	}

	public function stopDragging():Void {
		_isDragging = false ;
		delete onMouseMove ;
	}
	
	public function viewPositionChanged():Void {
		if (_tw) _tw.stop() ;
		var posField:String = (_nDirection == Direction.VERTICAL) ? "_y" : "_x" ;
		var sizeField:String = (_nDirection == Direction.VERTICAL) ? "_height" : "_width" ;
		var b:MovieClip = getBar() ;
		var t:MovieClip = getThumb() ;
		var size:Number =  b[sizeField] - t[sizeField] ;
		var pos:Number = (getPosition() / 100) *  size  ;
		if ( _isDragging || noEasing ) {
			t[posField] = pos ;
		} else {
			_tw = new TweenFPS ( 
				t, 
				posField, 
				pos, 
				isNaN(duration) ? 24 : duration , 
				null,  
				easing || Back.easeOut 
			) ;
			_tw.execute() ;
		}
	}

	// ----o Virtual Properties

	static private var __IS_DRAGGING__:Boolean = PropertyFactory.create(AbstractScrollbar, "isDragging", true, true) ;

	// ----o Private Properties

	private var _eDrag:ButtonEvent ;
	private var _isDragging:Boolean ;
	private var _mouseOffset:Number = 0 ;
	private var _nDirection:Number = Direction.VERTICAL ; 
	private var _tw:TweenFPS ;
	
}