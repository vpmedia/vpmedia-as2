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

import lunas.display.components.container.SimpleContainer;

import pegas.draw.RectanglePen;

/**
 * @author eKameleon
 */
class lunas.display.components.container.ListContainer extends SimpleContainer 
{

	/**
	 * Creates a new ListContainer instance
	 */
	function ListContainer() 
	{ 
		_nDirection = Direction.VERTICAL ;
		_createMask() ;
		update() ;
	}

	public function get direction():Number 
	{
		return getDirection() ;
	}
	
	public function set direction(n:Number):Void 
	{
		setDirection( n ) ;
	}
	
	public function get childCount():Number 
	{
		return getChildCount() ;
	}
	
	public function set childCount(n:Number):Void 
	{
		setChildCount( n ) ;
	}

	public function get maskIsActive():Boolean 
	{
		return getMaskIsActive() ;
	}
	
	public function set maskIsActive( b:Boolean ):Void 
	{
		setMaskIsActive( b ) ;
	}

	public function get space():Number 
	{
		return getSpace() ;
	}
	
	public function set space(n:Number):Void 
	{
		setSpace( n ) ;
	}	

	public var thickness:Number = 1 ;
	
	public function changeChildsPosition():Void 
	{
		var oC ;
		var prop:String = getCoordinateProperty() ;
		var l:Number = _oModel.size() ;
		for (var i:Number = 0 ; i<l ; i++) 
		{
			oC = _oModel.getChildAt(i) ;
			oC._x = oC._y = 0 ;
			oC[prop] = getChildPositionAt(i) ;
		}
	}

	public function draw():Void 
	{
		if (_oModel.size() > 0) 
		{
			changeChildsPosition() ;
		}
		resize() ;
		_refreshMask() ;
	}
	
	public function getBackground():MovieClip 
	{
		return _mcBackground ;
	}
	
	public function getBound():Object 
	{ 
		return _bound ;
	}

	/**
	 * Returns the direction value of this component.
	 * @return the direction value of this component.
	 * @see Direction
	 */
	public function getDirection():Number 
	{ 
		return (_nDirection == Direction.VERTICAL) ? Direction.VERTICAL : Direction.HORIZONTAL ;
	}

	public function getChildCount():Number 
	{ 
		return (_nChildCount >_oModel.size()) ? _oModel.size() : _nChildCount ; 
	}
	
	public function getCoordinateProperty():String 
	{
		return (_nDirection == Direction.VERTICAL) ? "_y" : "_x" ;
	}

	public function getChildPositionAt(n:Number):Number 
	{
		var o = _oModel.getChildAt(n-1) ;
		var p:String = getCoordinateProperty() ;
		var s:String = getSizeProperty() ;
		return (o != undefined) ? (o[p] + o[s] + _nSpace) : 0 ;
	}
	
	public function getMask():MovieClip 
	{
		return _mcMask ;
	}

	public function getMaskIsActive():Boolean 
	{ 
		return _bMaskIsActive ;
	}

	public function getSizeProperty():String 
	{
		return (_nDirection == Direction.VERTICAL) ? "_height" : "_width" ;
	}
	
	public function getSpace():Number 
	{ 
		return _nSpace ;
	}
	
	/**
	 * Use the mask protection.
	 */
	public function lockMask():Void
	{
		_bLockMask = true;	
	}
	
	/**
	 * Invoqued when the container size change.
	 */
	public function resize():Void 
	{
		if (_nChildCount > 0) 
		{
			var isHorizontal:Boolean = (_nDirection == Direction.HORIZONTAL) ;
			var n:Number = getChildCount() ;
			var n1:Number = 0 ;
			var n2:Number = 0 ;
			var p:String = isHorizontal ? "_width" : "_height" ;
			var f:String = isHorizontal ? "_height" : "_width" ;
			for (var i:Number = 0 ; i<n ; i++) 
			{
				var c = _oModel.getChildAt(i) ;
				n1 += _nSpace + c[p];
				n2 = Math.max(c[f], n2) ;
			}
			n1 -= _nSpace || 0 ;
			var s1:Number = (_nDirection == 1) ? _nSpace : 0 ;
			var s2:Number = (_nDirection == 1) ? 0 : _nSpace ;
			_bound = 
			{
				w : (isHorizontal ? n1 : n2) + thickness , 
				h : (isHorizontal ? n2 : n1) + thickness 
			} ;
			break ;
		}
		else if (_bMaskIsActive) 
		{
			_bound = {
				w : _w  ,
				h : _h 
			};
		}
		else 
		{
			_bound = 
			{
				w : _mcContainer._width  ,
				h : _mcContainer._height 
			};
		}
		_w = _bound.w ; 
		_h = _bound.h ;
	}
	
	public function setDirection(n:Number):Void 
	{
		_nDirection = (n == Direction.HORIZONTAL) ? Direction.HORIZONTAL : Direction.VERTICAL ;
		_mcContainer._x = _mcContainer._y = 0 ;
		update() ;
	}
	
	public function setChildCount(n:Number):Void 
	{
		if (n == null) _nChildCount = null ;
		else _nChildCount = (n>1) ? n : 1 ;
		_bMaskIsActive = (_nChildCount>0) ;
		update() ;
	}

	public function setMaskIsActive (bool:Boolean):Void 
	{
		_bMaskIsActive = bool ;
		update() ;
	}
	
	public function setSpace(n:Number):Void 
	{
		_nSpace = isNaN(n) ? 0 : n ; 
		if (_oModel.size() > 0) update() ;
	}
	
	/**
	 * Unlock the mask protection.
	 */
	public function unlockMask():Void
	{
		_bLockMask = false;	
	}
	
	public function viewEnabled():Void 
	{
		var l = _oModel.size() ;
		while (--l > -1) 
		{
			_oModel.getChildAt(l).enabled = enabled ;
		}
	}
		

	private var _bMaskIsActive:Boolean ;
	
	private var _bLockMask:Boolean = false ;
	
	private var _bound:Object ;

	private var _maskPen:RectanglePen ;

	private var _nDirection:Number ; 

	private var _nChildCount:Number = null ;

	private var _nSpace:Number = 0 ;

	private var _mcBackground:MovieClip ;

	private var _mcMask:MovieClip ;

	private function _createMask():Void 
	{
		if (_mcMask == null) 
		{
			_mcMask = createEmptyMovieClip( "_mcMask", 100 ) ;
			_maskPen = new RectanglePen( _mcMask ) ;
		}
	}

	private function _removeMask():Void 
	{
		if (_mcMask != undefined) 
		{
			_mcMask.removeMovieClip () ;
			_maskPen = null ;
		}
	}

	private function _refreshMask():Void 
	{
		
		_maskPen.clear() ;
		_maskPen.beginFill( 0 , 0 ) ;
		_maskPen.draw( _bound.w , _bound.h ) ;
		_maskPen.endFill() ;
		
		if ( _bMaskIsActive && _bLockMask == false ) 
		{
			_mcContainer.setMask(_mcMask) ;
		}
		else 
		{
			_mcContainer.setMask(null) ;
		}
	}



}