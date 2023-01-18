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

import asgard.display.DisplayObject;

import pegas.events.UIEvent;
import pegas.events.UIEventType;
import pegas.geom.Point;
import pegas.geom.Rectangle;
import pegas.maths.Range;

import vegas.events.Delegate;

/**
 * This class create a ZoomDisplay container to manipulate the scale and the offset position of the display with a mask.
 * ALPHA version !!! 
 * @author eKameleon
 */
class asgard.display.ZoomDisplay extends DisplayObject 
{
	
	/**
	 * Creates a new ZoomDisplay instance.
	 */
	public function ZoomDisplay(sName : String, target:MovieClip ) 
	{
		
		super(sName, target);
		
		_rScale = new Range(1, 150) ;
		_recMask = new Rectangle(0, 0, 0, 0) ;
		_offset = new Point() ;
		
		onMouseMove = Delegate.create(this , _refreshOffset) ;
		
		if (view.container != null && view.container instanceof MovieClip)
		{
			_container = view.container ;
		}
		else
		{
			_container = createContainer() ;
		}
		
		initialize() ;
		
	}

	/**
	 * The content container.
	 */
	public function get container():MovieClip 
	{
		return _container ;
	}

	/**
	 * (read-only) The default offset x when the container is initialize.
	 * Overrides this method if you want change and return this value.
	 */
	public function get defaultOffsetX():Number 
	{
		return 0 ;
	}
	
	/**
	 * (read-only) The default offset y when the container is initialize.
	 * Overrides this method if you want change and return this value.
	 */
	public function get defaultOffsetY():Number 
	{
		return 0 ;
	}

	/**
	 * (read-write) Returns the virtual height value.
	 */
	public function get h():Number 
	{
		return _h  ;
	}

	/**
	 * (read-write) Sets the virtual height value.
	 */
	public function set h( value:Number ):Void 
	{
		_h = value ;
		update() ;	
	}

	/**
	 * (read-only) Returns the max scale value.
	 */
	public function get maxScale():Number 
	{ 
		return getMaxScale() ; 
	}


	/**
	 * (read-only) Returns the min scale value.
	 */
	public function get minScale():Number 
	{ 
		return getMinScale() ; 
	}

	/**
	 * (read-write) Returns the offset x value of this display.
	 */
	public function get offsetX():Number
	{
		return getOffsetX() ;
	}

	/**
	 * (read-write) Sets the offset x value of this display.
	 */
	public function set offsetX( value:Number ):Void
	{
		setOffsetX( value ) ;
	}

	/**
	 * (read-write) Returns the offset y value of this display.
	 */
	public function get offsetY():Number
	{
		return getOffsetY() ;
	}

	/**
	 * (read-write) Sets the offset y value of this display.
	 */
	public function set offsetY( value:Number ):Void
	{
		setOffsetY( value ) ;
	}

	/**
	 * (read-write) Returns the scale value.
	 */
	public function get scale():Number 
	{
		return getScale() ;	
	}

	/**
	 * (read-write) Sets the scale value.
	 */
	public function set scale( value:Number ):Void 
	{
		setScale(value) ;	
	}

	/**
	 * (read-write) Returns the virtual width value.
	 */
	public function get w():Number 
	{
		return _w  ;
	}

	/**
	 * (read-write) Sets the virtual width value.
	 */
	public function set w( value:Number ):Void 
	{
		_w = value ;
		update() ;	
	}

	/**
	 * Create the initial container if the view don't have a container by default.
	 * overrides this method if it's necessary.
	 */
	public function createContainer():MovieClip
	{
		return view.createEmptyMovieClip("container", 1) ;
	}

	/**
	 * Returns the center of the visible view.
	 * @return the Point representation of the center of the visible view.
	 */
	public function getCenter():Point
	{
		return _recMask.getCenter() ;	
	}

	/**
	 * Get the mask height value.
	 */
	public function getH():Number
	{
		return _recMask.height ;	
	}

	/**
	 * Returns the max scale value.
	 */
	public function getMaxScale():Number 
	{ 
		return _rScale.max ; 
	}

	/**
	 * Returns the min scale value.
	 */
	public function getMinScale():Number 
	{ 
		return _rScale.min ; 
	}
	
	/**
	 * Returns the offset x value of this display.
	 */
	public function getOffsetX():Number
	{
		return _offset.x ;
	}
	
	/**
	 * Returns the offset y value of this display.
	 */
	public function getOffsetY():Number
	{
		return _offset.y ;
	}	
	
	/**
	 * Returns the current scale value.
	 */
	public function getScale():Number 
	{ 
		return _scale ; 
	}

	public function getVisibleArea():Rectangle
	{
		return _recMask.clone() ;	
	}

	/**
	 * Get the mask width value.
	 */
	public function getW():Number
	{
		return _recMask.width ;	
	}

	/**
	 * Initialize the tool with the current view.
	 */
	public function initialize():Void
	{
		
		_container._x = defaultOffsetX ;
		_container._y = defaultOffsetY ; 
		
		_refreshOffset() ;
		
		update() ;
		
	}
	
	/**
	 * Returns {@code true} if the display is draggable.
	 * @see registerDrag and unregisterDrag methods.
	 */
	public function idDraggable():Boolean
	{
		return _isDraggable ;	
	}

	/**
	 * Register the drags handler with mouse press and release events.
	 */
	public function registerDrag():Void
	{
		if( ! _isDraggable  )
		{
			_isDraggable = true ;
			view.onPress = Delegate.create(this, _startDrag) ;
			view.onRelease = view.onReleaseOutside = Delegate.create(this, _stopDrag) ;
		}
	}
	
	/**
	 * Scale in the container.
	 */
	public function scaleIn( p:Point ):Void
	{

		if ( _scale * _scaleStep > _rScale.max )  
		{
			return ;
		}

		if (p == null) 
		{
			p = getCenter() ;	
		}

		var p1:Point = new Point( p.x - _offset.x , p.y - _offset.y ) ;
		var p2:Point = new Point( p1.x * _scaleStep , p1.y * _scaleStep ) ;
		
		_offset.x -= p2.x - p1.x ;
		_offset.y -= p2.y - p1.y ;

		_container._x = _offset.x ;
		_container._y = _offset.y ;
		
		_container._xscale = _scaleReference * ( _scale *= _scaleStep ) ;
		_container._yscale = _container._xscale ;
		
		_boundPosition() ;
		
		dispatchEvent ( new UIEvent(UIEventType.CHANGE, this) ) ; // TODO : ScaleEvent
		
	}
	
	/**
	 * Scale out the container.
	 */
	public function scaleOut( p:Point ):Void
	{

		if ( ( _scale / _scaleStep ) < _rScale.min ) 
		{
			return ;
		}

		if (p == null) 
		{
			p = getCenter() ;	
		}

		var p1:Point = new Point( p.x - _offset.x , p.y - _offset.y  ) ;
		var p2:Point = new Point( p1.x / _scaleStep , p1.y / _scaleStep ) ;
		
		_offset.x -= p2.x - p1.x  ;
		_offset.y -= p2.y - p1.y ;
		
		_container._x = _offset.x ;
		_container._y = _offset.y ;
		
		_container._xscale = _scaleReference * ( _scale /= _scaleStep ) ;
		_container._yscale = _container._xscale ;
		
		_boundPosition() ;
		
		dispatchEvent ( new UIEvent(UIEventType.CHANGE, this) ) ; // TODO : ScaleEvent
	
	}


	/**
	 * Set the max scale value.
	 */
	public function setMaxScale(n:Number):Void 
	{ 
		_rScale.max = isNaN(n) ? 100 : n ;
		setScale(_scale) ;
	}

	/**
	 * Set the min scale value.
	 */
	public function setMinScale(n:Number):Void 
	{ 
		_rScale.min = isNaN(n) ? 100 : n ;
		setScale(_scale) ;
	}

	/**
	 * Sets the offset x value of this display.
	 */
	public function setOffsetX( value:Number ):Void
	{
		_container._x = value ;
		_boundPosition() ;
		_offset.x = _container._x ;
	}

	/**
	 * Sets the offset y value of this display.
	 */
	public function setOffsetY( value:Number ):Void
	{
		_container._y = value ;
		_boundPosition() ;
		_offset.y = _container._y ;
	}

	/**
	 * Sets the scale value.
	 */
	public function setScale( value:Number, p:Point ):Void 
	{

		value = _rScale.clamp(value) ;
	
		if (p == null) 
		{
			p = getCenter() ;	
		}
	
		var coef:Number = value / _scale ;
		
		var p1:Point = new Point( p.x - _offset.x , p.y - _offset.y ) ;
		var p2:Point = new Point( p1.x * coef , p1.y * coef ) ;
		
		_offset.x -= p2.x - p1.x;
		_offset.y -= p2.y - p1.y;
		_container._x = _offset.x ;
		_container._y = _offset.y ;
		_container._xscale = _scaleReference * ( _scale *= coef ); 
		_container._yscale = _container._xscale ;
		
		_boundPosition() ;
		
		dispatchEvent ( new UIEvent(UIEventType.CHANGE, this) ) ; // TODO : ScaleEvent
		
	}

	/**
	 * Set the virtual width and the height of the display.
	 * @param w:Number the virtual width.
	 * $param h:Number the virtual height. 
	 */
	public function setSize( w:Number , h:Number ):Void
	{
		_w = w ;
		_h = h ;
		update() ;	
	}

	/**
	 * Start to drag the view.
 	 */
	public function startDrag( /*arguments*/ ):Void
	{
		_container.startDrag.apply(container, [].concat(arguments));
		
		Mouse.addListener ( this ) ;
	}

	/**
 	 * Stop the drag.
 	 */
	public function stopDrag():Void
	{
		
		_container.stopDrag ();
		
		Mouse.removeListener (this) ;
		
	}

	/**
	 * Unregister the drags handler with mouse press and release events.
	 */
	public function unRegisterDrag():Void
	{
		if( _isDraggable )
		{
			_isDraggable = false ;
			delete view.onPress ;
			delete view.onRelease ;
			delete view.onReleaseOutside ;
		}
	}
	
	/**
	 * Update the display.
	 */
	public function update():Void
	{
		if ( isNaN(_container._width) || _container._width == 0)
		{
			_recMask.width = _w ;
		}
		else if (_w < _container._width)
		{
			_recMask.width = _w ;	
		}
		else
		{
			_recMask.width = _container._width ;	
		}

		if ( isNaN(_container._height) || _container._height == 0)
		{
			_recMask.height = _h ;
		}
		else if (_h < _container._height)
		{
			_recMask.height = _h ;	
		}
		else
		{
			_recMask.height = _container._height ;	
		}
		view.scrollRect = _recMask.toFlash() ;
		
		_boundPosition() ;
		
	}
		
	/**
	 * The container movieclip.
	 */
	private var _container:MovieClip ;

	/**
	 * Virtual width of the visible area.
	 */
	private var _h:Number = 300 ;

	/**
	 * Indicates if the display is draggable or not. 
	 */
	private var _isDraggable:Boolean = false ;

	/**
	 * The onMouse move handler.
	 */
	private var onMouseMove:Function ;

	/**
	 * The original position of the container.
	 */
	public var _offset:Point ; 

	/**
	 * The Mask Rectangle.
	 */
	private var _recMask:Rectangle ;

	/**
	 * The current range of the scale.
	 */
	private var _rScale:Range ;
	 
	/**
	 * The current scale value.
	 */
	private var _scale:Number = 1 ;
	
	/**
	 * The scale reference.
	 */
	private var _scaleReference:Number = 100 ;

	/**
	 * The scale step to change the scale of the view.
	 */
	private var _scaleStep:Number = 1.4 ;

	/**
	 * Virtual width of the visible area.
	 */
	private var _w:Number = 550 ;

	/**
	 * Bounds the container if the view is out of the bounds of the visible area.
	 */
	private function _boundPosition():Void
	{

		if (_container._x + _container._width < _recMask.width) 
		{
			_container._x = _recMask.width - _container._width ;
		}
		if ( _container._y + _container._height < _recMask.height ) 
		{
			_container._y = _recMask.height - _container._height ;
		}
		if ( _container._x > _recMask.x ) 
		{
			_container._x = _recMask.x ;
		}
		if ( _container._y > _recMask.y ) 
		{
			_container._y = _recMask.y ;
		}

	}
	
	/**
	 * Refresh the _offset when the container is drag.
	 */
	 private function _refreshOffset():Void
	 {
	 	_offset.x = _container._x ;
		_offset.y = _container._y ;
	 }
	
	/**
	 * Activate the drag handler if the use press the container.
	 * This method is avite only if the display is "isRegisterDrag".
	 * @see registerDrag
	 * @see unregisterDrag
	 */ 
	private function _startDrag():Void
	{
		var $w:Number = - (_container._width - _recMask.width) ;
		var $h:Number = - (_container._height - _recMask.height) ;
		this.startDrag(false, 0, 0, $w, $h) ; 
	}

	/**
	 * Deactivate the drag handler if the use release the container
	 */ 
	private function _stopDrag():Void
	{
		this.stopDrag() ;	
	}
	
}