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

import asgard.display.Direction;

import lunas.core.IScrollbar;
import lunas.display.abstract.AbstractProgressbarDisplay;

import pegas.events.ButtonEvent;
import pegas.transitions.easing.Expo;
import pegas.transitions.Tween;

import vegas.events.Delegate;
import vegas.util.MathsUtil;

/**
 * This class provides a skeletal implementation of all the {@code IScrollbar} display components, to minimize the effort required to implement this interface.
 * @author eKameleon
 */
class lunas.display.abstract.AbstractScrollbarDisplay extends AbstractProgressbarDisplay implements IScrollbar 
{

	/**
	 * Creates a new AbstractScrollbar instance.
	 * @param sName:String the name of the display.
	 * @param target:MovieClip the DisplayObject instance control this target.
	 */
	private function AbstractScrollbarDisplay( sName:String, target:MovieClip ) 
	{ 
		
		super ( sName, target ) ;
		_eDrag      = new ButtonEvent( ButtonEvent.DRAG, this ) ;
		_eStartDrag = new ButtonEvent( ButtonEvent.START_DRAG, this ) ;
		_eStopDrag  = new ButtonEvent( ButtonEvent.STOP_DRAG, this ) ;
		_nDirection = Direction.VERTICAL ;
	}

	/**
	 * The name of the event when the user drag the scrollbar.
	 */
	static public var DRAG:String = ButtonEvent.DRAG ;

	/**
	 * The name of the event when the user start to drag the scrollbar.
	 */
	static public var START_DRAG:String = ButtonEvent.START_DRAG ;

	/**
	 * The name of the event when the user stop to drag the scrollbar.
	 */
	static public var STOP_DRAG:String = ButtonEvent.STOP_DRAG ;

	/**
	 * Indicates the duration of the easing effect if is active.
	 */
	public var duration:Number = 24  ;	

	/**
	 * Indicates the easing method if the easing effect is active.
	 */
	public var easing:Function = null ;

	/**
	 * A static object use to defines the inverse position property name of the bar.
	 */
	static public var invertPosField:Object = { _x : "_y" , _y : "_x" } ;

	/**
	 * A static object use to defines the inverse size properties name of the bar.
	 */
	static public var invertSizeField:Object = { _width : "_height" , _height : "_width" } ;

	/**
	 * (read-only) Returns {@code true} if the bar is dragging.
	 * @return {@code true} if the bar is dragging.
	 */
	public function get isDragging():Boolean 
	{
		return getIsDragging() ;	
	}

	/**
	 * Determinates if the bar use easing effects or not.
	 */
	public var noEasing:Boolean = true ;
	
	/**
	 * Invoqued when the bar is dragging.
	 */
	public function dragging():Void 
	{

		var sizeField:String = getSizeField() ;
		var mouseField:String = getMouseField() ;

		var b:MovieClip = getBar() ;
		var t:MovieClip = getThumb() ;
		
		var size:Number =  b[sizeField] - t[sizeField] ;
		var pos:Number = view[mouseField] - _mouseOffset ;

		pos = MathsUtil.getPercent( MathsUtil.clamp(pos, 0, size), size ) ;
		setPosition( pos , null, ( arguments[0] == true ? true : null ) ) ;

		notifyDrag(pos) ;
		
	}

	/**
	 * Returns the background bar reference. Overrides this method in the concrete implementations.
	 * @return the background bar reference.
	 */
	public function getBar():MovieClip 
	{
		return null ; // override this method !
	}

	/**
	 * Returns {@code true} if the component is dragging.
	 * @return {@code true} if the component is dragging.
	 */
	public function getIsDragging():Boolean 
	{
		return _isDragging ;
	}
	
	/**
	 * Returns the string representation of the current size field property of this component with the current direction value.
	 * @return the string representation of the current size field property of this component with the current direction value.
	 */
	public function getSizeField():String 
	{
		return (getDirection() == Direction.VERTICAL) ? "_height" : "_width" ;
	}

	/**
	 * Returns the string representation of the current mouse field property of this component with the current direction value.
	 * @return the string representation of the current mouse field property of this component with the current direction value.
	 */
	public function getMouseField():String 
	{
		return (getDirection() == Direction.VERTICAL) ? "_ymouse" : "_xmouse" ;
	}
	
	/**
	 * Returns the thumb reference. Overrides this method in the concrete implementations.
	 * @return the thumb reference.
	 */
	public function getThumb():MovieClip 
	{
		return null ; // override this method !
	}

	/**
	 * Dispatchs an event when the user drag the bar.
	 */
	public function notifyDrag( position:Number ):Void 
	{
		_eDrag.position = position ;
		dispatchEvent( _eDrag ) ;
	}

	/**
	 * Dispatchs an event when the user start to drag the bar.
	 */
	public function notifyStartDrag():Void
	{
		dispatchEvent( _eStartDrag ) ;	
	}

	/**
	 * Dispatchs an event when the user stop to drag the bar.
	 */
	public function notifyStopDrag():Void
	{
		dispatchEvent( _eStopDrag ) ;	
	}

	/**
	 * Invoqued when the user start to drag the bar.
	 */
	public function startDragging():Void 
	{
		notifyStartDrag() ;
		var mouseField:String = (_nDirection == Direction.VERTICAL) ? "_ymouse" : "_xmouse" ;
		_mouseOffset = (getThumb())[ mouseField ] ;
		dragging() ;
		_isDragging = true ;
		view.onMouseMove = Delegate.create(this, dragging) ;
	}

	/**
	 * Invoqued when the user stop to drag the bar.
	 */
	public function stopDragging():Void 
	{
		_isDragging = false ;
		delete view.onMouseMove ;
		notifyStopDrag() ;
	}
	
	/**
	 * Invoqued when the position value of the bar is changed.
	 */
	public function viewPositionChanged( flag:Boolean ):Void 
	{

		if (_tw.getRunning()) 
		{
			_tw.stop() ;
		}

		var posField:String = (_nDirection == Direction.VERTICAL) ? "_y" : "_x" ;
		
		var sizeField:String = (_nDirection == Direction.VERTICAL) ? "_height" : "_width" ;
		
		var b:MovieClip = getBar() ;
		var t:MovieClip = getThumb() ;

		var size:Number =  b[sizeField] - t[sizeField] ;
		var pos:Number = (getPosition() / 100) *  size  ;
		
		if ( !isDragging ) 
		{
			t[invertPosField[posField]] = b[invertPosField[posField]] + ( b[ invertSizeField[sizeField] ] - t[ invertSizeField[sizeField] ] ) / 2 ;
		} 

		if ( flag || _isDragging || noEasing ) 
		{
			t[posField] = pos ;
		} 
		else 
		{
			_tw = new Tween 
			( 
				t, 
				posField, 
				easing || Expo.easeOut ,
				t[posField] ,  
				pos , 
				isNaN(duration) ? 24 : duration
			) ;
			
			_tw.run() ;
			
		}
	}


	private var _eDrag:ButtonEvent ;
	private var _eStartDrag:ButtonEvent ;
	private var _eStopDrag:ButtonEvent ;
	private var _isDragging:Boolean ;
	private var _mouseOffset:Number = 0 ;
	private var _nDirection:Number ; 
	private var _tw:Tween ;
	
}