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

import lunas.display.components.container.ListContainer;

import pegas.events.ActionEvent;
import pegas.events.UIEvent;
import pegas.events.UIEventType;
import pegas.transitions.easing.Back;
import pegas.transitions.Tween;
import pegas.transitions.TweenEntry;

import vegas.events.Delegate;
import vegas.events.EventListener;
import vegas.util.MathsUtil;

/**
 * This container can be scrolled.
 * @author eKameleon
 */
class lunas.display.components.container.ScrollContainer extends ListContainer 
{
	
	/**
	 * Creates a new ScrollContainer instance.
	 */
	public function ScrollContainer () 
	{
		super() ;
	}

	/**
	 * The name of the event dispatched when the scroll change.
	 */
	static public var SCROLL:String = UIEventType.SCROLL ;

	/**
	 * Returns the bottom scroll value.
	 * @return the bottom scroll value.
	 */
	public function get bottomScroll():Number 
	{
		return getBottomScroll() ;	
	}

	/**
	 * Returns the maxscroll value.
	 * @return the maxscroll value.
	 */
	public function get maxscroll():Number 
	{
		return getMaxscroll() ;	
	}

	/**
	 * Returns the scroll value of this container.
	 * @return the scroll value of this container.
	 */
	public function get scroll():Number 
	{
		return getScroll() ;	
	}
	
	/**
	 * Sets the scroll value of this container.
	 */
	public function set scroll(n:Number):Void 
	{
		setScroll( n ) ;	
	}

	/**
	 * Indicates if the scroll is fixed.
	 */
	public var fixScroll:Boolean = true ;	

	/**
	 * Indicates if the scroll use an easing effect.
	 */
	public var noScrollEasing:Boolean ;

	public var scrollEasing:Function = undefined ;

	public var scrollDuration:Number = 12  ;

	public function addChildAt(o, index:Number, oInit) 
	{
		var c:MovieClip = super.addChildAt(o, index, oInit) ;
		_refreshChilds() ;
		return c ;
	}

	public function clearScroll():Void 
	{ 
		speedScroll(1) ; 
		updateScroll() ;
	}

	public function getBottomScroll():Number 
	{ 
		return (getMaxscroll() > 1) ? (getScroll() + (_nChildCount -1)) : _nChildCount ;
	}
	
	public function getContainerPos():Number 
	{
		var index:Number = getScroll() - 1 ;
		var prop:String = _getPosProperty() ;
		return - _oModel.getChildAt(index)[prop] ;
	}

	public function getMaxscroll():Number 
	{
		var m:Number = (_oModel.size() - _nChildCount) ;
		if (isNaN(m)) m = 1 ;
		return ( m >= 1 ) ? m+1 : 1 ;
	}
	
	public function getScroll():Number 
	{ 
		return MathsUtil.clamp(_scroll, 1, maxscroll) ;
	}

	public function viewDestroyed():Void 
	{
		_clearTween() ;
	}

	public function setScroll(n:Number, noEvent:Boolean):Void  
	{
		if (n == _scroll) return ;
		if (getMaxscroll() > 0) 
		{
			_scroll = n ;
			_changeScroll() ;
			if (!noEvent) updateScroll() ;
		}
		else 
		{
			_scroll = 1 ;
		}
	}

	public function speedScroll(n:Number):Void 
	{
		_clearTween() ;
		_scroll = (getMaxscroll() > 0) ? n : 1 ;
		_mcContainer[_getPosProperty()] = getContainerPos() ;
	}

	public function viewChanged():Void 
	{
		super.viewChanged() ; 
		_clearTween() ;
		if (fixScroll) speedScroll(1) ;
	}
	
	public function viewEnabled():Void 
	{
		super.viewEnabled() ; 
		_clearTween() ;
		if (fixScroll) speedScroll(1) ;
	}

	public function updateScroll():Void 
	{
		dispatchEvent(new UIEvent( UIEventType.SCROLL, this)) ;
	}
	
	private var _scroll:Number = 0 ;

	private var _changeListener:EventListener ;

	private var _tw:Tween ;

	private var _entry:TweenEntry ;

	private function _changeScroll():Void 
	{
		if (_tw.running)
		{
			_tw.stop() ;
		}

		var prop:String = _getPosProperty() ;
		var pos:Number  = getContainerPos () ;

		if (noScrollEasing) 
		{
			_mcContainer[prop] = pos ;
			_refreshChilds() ;
		} 
		else 
		{
		
			_tw.clear() ;
			
			_entry.prop   = prop ;
			_entry.easing = scrollEasing || Back.easeOut ;
			_entry.begin  = _mcContainer[prop] ;
			_entry.finish = pos ;
			
			_tw.insert( _entry ) ;
			_tw.duration = isNaN( scrollDuration ) ? 24 : scrollDuration ;
			_tw.run() ;
			
		}
	}
	
	private function _clearTween() :Void 
	{
		_tw.stop() ; 
	}

	/*override*/ private function _createContainer():Void 
	{

		super._createContainer() ;
		
		_changeListener = new Delegate(this, _refreshChilds ) ;
		
		_tw = new Tween( _mcContainer ) ;
		_tw.addEventListener( ActionEvent.CHANGE , _changeListener ) ;
		
		_entry = new TweenEntry() ;

	}
	
	/**
	 * Returns the position property with the current direction property.
	 * @return the position property with the current direction property.
	 */
	private function _getPosProperty():String 
	{
		return (_nDirection == Direction.HORIZONTAL) ? "_x" : "_y" ;
	}
	
	/**
	 * Invoqued to refreshChilds during the scroll of this container.
	 */
	/*protected*/ private function _refreshChilds() : Void 
	{
		// overrides this method.
	}

}