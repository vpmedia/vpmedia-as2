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

import vegas.data.iterator.ArrayIterator;
import vegas.data.iterator.Iterable;
import vegas.data.iterator.Iterator;
import vegas.events.ModelChangedEvent;
import vegas.events.ModelChangedEventType;
import vegas.util.ArrayUtil;
import vegas.util.mvc.AbstractModel;

/**
 * The model of the containers.
 */
class lunas.display.components.container.ContainerModel extends AbstractModel implements Iterable 
{

	/**
	 * Creates a new ContainerModel instance.
	 * @param childs An Array of items.
	 */
	public function ContainerModel( childs:Array ) 
	{ 
		super() ;
		
		_model = (childs.length > 0) ? [].concat(childs) : [] ;
		
		_eAdd = new ModelChangedEvent(ModelChangedEventType.ADD_ITEMS, this) ;
		_eClear = new ModelChangedEvent(ModelChangedEventType.CLEAR_ITEMS, this);
		_eRemove = new ModelChangedEvent(ModelChangedEventType.REMOVE_ITEMS, this) ;
		_eUpdate = new ModelChangedEvent(ModelChangedEventType.UPDATE_ITEMS, this) ;
		
	}
	
	static public var ADD_ITEMS:String = ModelChangedEventType.ADD_ITEMS ; 

	static public var CLEAR_ITEMS:String = ModelChangedEventType.CLEAR_ITEMS ; 

	static public var REMOVE_ITEMS:String = ModelChangedEventType.REMOVE_ITEMS ; 

	static public var UPDATE_ITEMS:String = ModelChangedEventType.UPDATE_ITEMS ;

	public function addChild( oChild ) 
	{
		return addChildAt(oChild, size()) ; 
	}
	
	public function addChildAt( oChild, index:Number ) 
	{
		
		var l:Number = size() ;
		
		if (index < 0) 
		{
			return null ;
		}
		else if (index > l) 
		{
			return null ;
		}
		
		_model.splice( index, 0, oChild ) ;
		
		_eAdd.index = index ;
		_eAdd.firstItem = index ;
		_eAdd.lastItem = index ;

		notifyChanged( _eAdd ) ;

		return oChild ;

	}
	
	/**
	 * Removes all elements in this model.
	 */
	public function clear():Void 
	{
		_eClear.removedItems = _model.splice(0) ;
		notifyChanged(_eClear) ;
	}
	
	/**
	 * Returns a shallow copy of this model.
	 * @return a shallow copy of this model.
	 */
	public function clone() 
	{
		return new ContainerModel(toArray()) ;
	}
	
	public  function contains( oChild ):Boolean 
	{
		return ArrayUtil.contains(_model, oChild) ;
	}
	
	public function getChildAt(index:Number) 
	{
		return _model[index] ;
	}
	
	public function getChildByKey(key:Number) 
	{
		var l:Number = size() ;
		while (--l > -1) 
		{
			if (_model[l].hashCode() == key) return _model[l] ;
		}
		return null ;
	}
	
	public function getChildByName(name:String) 
	{
		var l:Number = size() ;
		while (--l > -1) 
		{
			if (_model[l]._name == name) return _model[l] ;
		}
		return null ;
	}
	
	public function indexOf( oChild ):Number 
	{
		return ArrayUtil.indexOf(_model, oChild) ;
	}
	
	public function iterator():Iterator 
	{
		return new ArrayIterator( _model ) ;
	}
	
	public function removeChild( oChild ) 
	{
		var index:Number = indexOf(oChild) ;
		if (index > -1) 
		{
			return removeChildAt(index) ;
		}
		else 
		{
			return null ;
		}
	}
	
	public function removeChildAt(index:Number) 
	{
		var ret = this[index] ; 
		removeChildsAt(index, 1);
		return ret;
	}
	
	public function removeChildsAt(index:Number, len:Number):Array 
	{
		var oldItems = _model.splice(index, len) ;
		_eRemove.firstItem = index ;
		_eRemove.lastItem = index + len - 1 ;
		_eRemove.removedItems = [].concat(oldItems) ;
		notifyChanged ( _eRemove ) ;
		return oldItems ;
	}
	
	public function removeRange(from:Number, to:Number):Array 
	{
		if (from == undefined) return null ;
		return removeChildsAt(from, to - from) ;
	}
	
	public function setChildIndex( oChild, index:Number):Void 
	{
		var id:Number = indexOf(oChild) ;
		if (id == -1 || id == index) 
		{
			return ;
		}
		else 
		{
			var tmp = oChild ;
			_model.splice(id, 1) ;
			_model.splice(index, 0, tmp) ;
			notifyChanged(_eUpdate) ;
		}
	}
	
	/**
	 * Returns the number of elements in this model.
	 * @return the number of elements in this model.
	 */
	public function size():Number 
	{
		return _model.length ;
	}
	
	/**
	 * Returns the {@code Array} representation of the object.
	 * @return the {@code Array} representation of the object.
	 */	
	public function toArray():Array 
	{
		return [].concat(_model) ;
	}
	
	private var _model:Array ;
	private var _eAdd:ModelChangedEvent ;
	private var _eClear:ModelChangedEvent ;
	private var _eRemove:ModelChangedEvent ;
	private var _eUpdate:ModelChangedEvent ;
}