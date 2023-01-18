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

/* ---------- ScrollContainer

	AUTHOR
		
		Name : ScrollContainer
		Package : neo.display.components.container
		Version : 1.0.0.0
		Date :  2006-02-07
		Author : ekameleon
		URL : http://www.ekameleon.net
		Mail : contact@ekameleon.net
	
	PROPERTY SUMMARY
	
		* bottomScroll [Number] [R]
		
			Renvoi la valeur de la position la plus basse affichée dans la liste
		
		- direction:Number [R/W]
		
		* fixscroll [Boolean]
		
			Si cette propriété vaut true alors à chaque rafraichissement du composant
			le scroll se réinitialise à 1.
		
		- itemCount:Number [R/W]
		
		- maskIsActive:Boolean [R/W]
		
		* maxscroll [Number] [R]
			
			Propriété en lecture seule, permet de renvoyer le nombre maximal que peut atteindre la 
			propriété scroll.
		
		* noScrollEasing [Boolean]
		
			Cette propriété permet de définir si le scroll utilise une Tween ou pas.
		
		* scroll [Number] [R/W]
			
			Permet de changer la valeur du scroll de la liste
		
		* scrollEasing [Function] :
		
			Fonction définissant l'équation de mouvement du scroll.
		
		* scrollDuration [Number]
			
			Durée du scroll en cas de mouvement de type Tween (default 12f/s)
		
		- space:Number [R/W]
		
		- thickness:Number
	
	METHOD SUMMARY
	
		- changeItemsPosition():Void
		
		* clearScroll()
		 
		- draw():Void
		
		- getBackground():MovieClip
		
		* getBottomScroll()
		
		- getBound():Object
		
		* getContainerPos()
		
		- getCoordinateProperty():String
		
		- getDirection():Number
		
		- getItemCount():Number
				
		- getItemPositionAt(n:Number):Number 
		
		- getMask():MovieClip
		
		- getMaskIsActive():Boolean
		
		* getMaxScroll()
		
		* getScroll()
		
		- getSizeProperty():String
		
		- getSpace():Number
		
		- resize():Void
		
		- setDirection(n:Number):Void
		
		- setItemCount(n:Number):Void
		
		- setMaskIsActive (bool:Boolean)
		
		* setScroll(n:Number, noEvent:Boolean

		- setSpace(n:Number)
		
		* speedScroll(n:Number)
		
		* updateScroll()
		
		- viewEnabled():Void
	
	EVENT SUMMARY

		- UIEvent
		
	EVENT TYPE SUMMARY
	
		- SCROLL:UIEventType

	
	INHERIT
	
		AbstractComponent 
			|
			AbstractContainer
				|
				SimpleContainer
					|
					ListContainer
						|
						ScrollContainer

	SEE ALSO
	
		TweenFPS

	
	TODO 2006-03-01 change prop = _getPosProperty position in the method !!

----------  */

import com.bourre.transitions.TweenFPS;

import neo.display.components.container.ListContainer;
import neo.display.Direction;
import neo.events.UIEvent;
import neo.events.UIEventType;
import neo.transitions.easing.Back;
import neo.util.factory.PropertyFactory;
import neo.util.MathsUtil;

class neo.display.components.container.ScrollContainer extends ListContainer {
	
	// ----o Constructor

	public function ScrollContainer () {
		super() ;
	}

	// ----o Constant
	
	static public var SCROLL:UIEventType = UIEventType.SCROLL ;
	
	// ----o Public Properties

	public var bottomScroll:Number ; // [Read Only]
	public var fixScroll:Boolean = true ;	
	public var maxscroll:Number ; // [Read Only]
	public var noScrollEasing:Boolean ;
	public var scroll:Number ; // [RW]
	public var scrollEasing:Function = undefined ;
	public var scrollDuration:Number = 12  ;

	// ----o Public Methods

	public function clearScroll(Void):Void { 
		speedScroll(1) ; 
		updateScroll() ;
	}

	public function getBottomScroll():Number { 
		return (getMaxscroll() > 1) ? (getScroll() + (_nItemCount -1)) : _nItemCount ;
	}
	
	public function getContainerPos():Number {
		var index:Number = getScroll() - 1 ;
		var prop:String = (_nDirection == Direction.HORIZONTAL) ? "_x" : "_y" ;
		return - _oModel.getChildAt(index)[prop] ;
	}

	public function getMaxscroll():Number {
		var m:Number = (_oModel.size() - _nItemCount) ;
		if (isNaN(m)) m = 1 ;
		return ( m >= 1 ) ? m+1 : 1 ;
	}
	
	public function getScroll():Number { 
		return MathsUtil.clamp(_scroll, 1, maxscroll) ;
	}

	public function viewDestroyed():Void {
		_removeTween() ;
	}

	public function setScroll(n:Number, noEvent:Boolean):Void  {
		if (n == _scroll) return ;
		if (getMaxscroll() > 0) {
			_scroll = n ;
			_changeScroll() ;
			if (!noEvent) updateScroll() ;
		} else {
			_scroll = 1 ;
		}
	}

	public function speedScroll(n:Number):Void {
		_removeTween() ;
		_scroll = (getMaxscroll() > 0) ? n : 1 ;
		_mcContainer[_getPosProperty()] = getContainerPos() ;
	}

	public function viewChanged():Void {
		super.viewChanged() ; 
		_removeTween() ;
		if (fixScroll) speedScroll(1) ;
	}
	
	public function viewEnabled():Void {
		super.viewEnabled() ; 
		_removeTween() ;
		if (fixScroll) speedScroll(1) ;
	}

	public function updateScroll():Void {
		_oEB.broadcastEvent(new UIEvent( UIEventType.SCROLL, this)) ;
	}

	// ----o Virtual Properties

	static private var __BOTTOM_SCROLL__:Boolean = PropertyFactory.create(ScrollContainer, "bottomScroll", true, true) ;
	static private var __MAX_SCROLL__:Boolean = PropertyFactory.create(ScrollContainer, "maxscroll", true, true) ;
	static private var __SCROLL__:Boolean = PropertyFactory.create(ScrollContainer, "scroll", true) ;

	// ----o Private Properties

	private var _scroll:Number = 0 ;
	private var _tw:TweenFPS ;
	
	// ----o Private Methods
	
	private function _getPosProperty(Void):String {
		return (_nDirection == Direction.HORIZONTAL) ? "_x" : "_y" ;
	}
		
	private function _removeTween() :Void {
		_tw.stop() ; 
		_tw = null ;
	}
	
	private function _changeScroll() : Void {
		_tw.stop() ;
		var pos:Number = getContainerPos () ;
		var prop:String = _getPosProperty() ;
		if (noScrollEasing) {
			_mcContainer[prop] = pos ; 
		} else {
			_tw = new TweenFPS ( 
				_mcContainer, 
				prop, 
				pos, 
				isNaN(scrollDuration) ? 24 : scrollDuration , 
				null,  
				scrollEasing || Back.easeOut 
			) ;
			_tw.execute() ;
		}
	}
	
}