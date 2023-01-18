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

import lunas.display.components.AbstractComponent;
import lunas.display.components.container.ContainerModel;
import lunas.display.components.IContainer;

import vegas.core.HashCode;
import vegas.data.iterator.Iterable;
import vegas.data.iterator.Iterator;
import vegas.util.factory.DisplayFactory;
import vegas.util.mvc.IController;
import vegas.util.mvc.IView;

/**
 * The Skeletal implementation of the IContainer interface.
 * @author eKameleon
 */
class lunas.display.components.container.AbstractContainer extends AbstractComponent implements IContainer, Iterable 
{

	/**
	 * Creates a new AbstractContainer instance.
	 */
	private function AbstractContainer () 
	{ 
		_createContainer() ;
		_oModel = new ContainerModel() ;
	}

	public function addChild( o , oInit) 
	{
		return addChildAt( o, size(), oInit) ;
	}
	
	public function addChildAt(o, index:Number, oInit) 
	{
		var c:MovieClip = DisplayFactory.createChild( o , "child" + HashCode.nextName(), size(), _mcContainer, oInit) ;
		HashCode.identify(c) ;
		_oModel.addChildAt(c, index) ;
		_refreshDepths() ;
		notifyAdded(c, index) ;     
		return c ;
	}
	
	public function clear():Void 
	{
		_oModel.clear() ;
	}
	
	public  function contains( oChild ):Boolean 
	{
		return _oModel.contains(oChild) ;
	}
	
	public function getChildAt(index:Number) 
	{
		return _oModel.getChildAt(index) ;
	}
	
	public function getChildByKey(key:Number) 
	{
		return _oModel.getChildByKey(key) ;
	}
	
	public function getChildByName(name:String) 
	{
		return _oModel.getChildByName(name) ;
	}
	
	/**
	 * Returns the internal model reference of this container.
	 * @return the internal model reference of this container.
	 */
	public function getModel():ContainerModel
	{
		return _oModel ;	
	}
	
	/**
	 * Returns the {@code Iterator} of this container.
	 * @return the {@code Iterator} of this container.
	 */
	public function iterator():Iterator 
	{
		return _oModel.iterator() ;
	}

	public function indexOf( oChild ):Number 
	{
		return _oModel.indexOf(oChild) ;
	}

	public function removeChild( oChild ):Void 
	{
		_oModel.removeChild(oChild) ;
		_refreshDepths() ;
	}
	
	public function removeChildAt(index:Number):Void 
	{
		if (getChildAt(index)) 
		{
			removeChildsAt(index, 1) ;
		}
	}

	public function removeChildsAt(index:Number, len:Number):Void 
	{
		_oModel.removeChildsAt(index, len) ;
		_refreshDepths() ;
		notifyRemoved() ;
	}
	
	public function removeRange(from:Number, to:Number):Void 
	{
		_oModel.removeRange(from, to) ;
		_refreshDepths() ;
		notifyRemoved() ;
	}

	public function setChildIndex( oChild, index:Number):Void 
	{
		_oModel.setChildIndex(oChild, index) ;
	}
	
	public function size():Number 
	{
		return _oModel.size() ;
	}
	
	public function toArray():Array
	{
		return _oModel.toArray() ;	
	}
	
	private var _mcContainer:MovieClip ;

	private var _oController:IController ;

	private var _oModel:ContainerModel ;

	private var _oView:IView ;
	
	/**
	 * Creates the container reference of this component.
	 */
	private function _createContainer():Void 
	{
		if (_mcContainer == undefined) 
		{
			createEmptyMovieClip("_mcContainer", 50) ;
		}
	}	
	
	/**
	 * Refresh the depths of all childs in the container.
	 */
	private function _refreshDepths():Void
	{
		var ar:Array = _oModel.toArray() ;
		var l:Number = ar.length ;
		while(l--)
		{
			MovieClip.prototype.swapDephts(ar[l], l) ;	
		}
	}
	
	
}