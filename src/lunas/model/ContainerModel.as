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

import andromeda.model.AbstractModel;

import vegas.data.iterator.ArrayIterator;
import vegas.data.iterator.Iterable;
import vegas.data.iterator.Iterator;
import vegas.events.ModelChangedEvent;
import vegas.util.ArrayUtil;

/**
 * The model of the {@code IContainer} display components.
 */
class lunas.model.ContainerModel extends AbstractModel implements Iterable 
{

	/**
	 * Creates a new ContainerModel instance.
	 * @param id the id of the model.
	 * @param bGlobal the flag to use a global event flow or a local event flow.
	 * @param sChannel the name of the global event flow if the {@code bGlobal} argument is {@code true}.
	 * @param childs An Array of items to insert in the model.
	 */
	public function ContainerModel( id , bGlobal:Boolean , sChannel:String , childs:Array ) 
	{ 
		
		super( id, bGlobal, sChannel ) ;
		
		_model = (childs.length > 0) ? [].concat(childs) : [] ;
		
		_eAdd    = new ModelChangedEvent( ModelChangedEvent.ADD_ITEMS    , this ) ;
		_eClear  = new ModelChangedEvent( ModelChangedEvent.CLEAR_ITEMS  , this ) ;
		_eRemove = new ModelChangedEvent( ModelChangedEvent.REMOVE_ITEMS , this ) ;
		_eUpdate = new ModelChangedEvent( ModelChangedEvent.UPDATE_ITEMS , this ) ;
		
	}
	
	/**
	 * The child name attribute.
	 */
	public var childNameAttribute:String = "_name" ;
	
	/**
	 * Adds a child item in the model.
	 * @param oChild A child to insert in the model.
	 */
	public function addChild( oChild ) 
	{
		return addChildAt(oChild, size()) ; 
	}
	
	/**
	 * Adds a child item in the model at the passed-in index position.
	 * @param oChild the child to insert in the model.
	 * @param index the index value position of the child.
	 */
	public function addChildAt( oChild, index:Number ) 
	{
		
		var l:Number = size() ;
		
		if (index < 0) 
		{
			return null ;
		}
		else if ( index > l ) 
		{
			return null ;
		}
		
		_model.splice( index, 0, oChild ) ;
		
		dispatchEvent( _eAdd ) ;

		return oChild ;

	}
	
	/**
	 * Removes all elements in this model.
	 */
	public function clear():Void 
	{
		_eClear.removedItems = _model.splice(0) ;
		dispatchEvent(_eClear) ;
	}
	
	/**
	 * Returns a shallow copy of this model.
	 * @return a shallow copy of this model.
	 */
	public function clone() 
	{
		return new ContainerModel ( getID(), isGlobal, ( isGlobal ? getEventDispatcher().getName() : null ), toArray() ) ;
	}
	
	/**
	 * Returns {@code true} if the model contains the passed-in child reference.
	 * @return {@code true} if the model contains the passed-in child reference.
	 */
	public  function contains( oChild ):Boolean 
	{
		return ArrayUtil.contains(_model, oChild) ;
	}
	
	/**
	 * Returns the child reference of the model at the passed-in index number value.
	 * @return the child reference of the model at the passed-in index number value.
	 */
	public function getChildAt(index:Number) 
	{
		return _model[index] ;
	}
	
	/**
	 * Returns the child reference in the model with the specified hashcode key value passed in argument.
	 * @return the child reference in the model with the specified hashcode key value passed in argument.
	 */
	public function getChildByKey( key:Number ) 
	{
		var l:Number = size() ;
		while (--l > -1) 
		{
			if (_model[l].hashCode() == key) return _model[l] ;
		}
		return null ;
	}
	
	/**
	 * Returns the child reference in the model with the specified name value passed in argument.
	 * @return the child reference in the model with the specified name value passed in argument.
	 */
	public function getChildByName(name:String) 
	{
		var l:Number = size() ;
		while (--l > -1) 
		{
			if ( _model[l]._name == name )
			{
				return _model[l] ;
			}
		}
		return null ;
	}
	
	/**
	 * Returns the name of the child.
	 * @return the name of the child.
	 */
	public function getChildName( child ):String
	{
		return child[childNameAttribute] ;	
	}
	
	/**
	 * Returns the index value of the passed-in child item.
	 * @return the index value of the passed-in child item.
	 */
	public function indexOf( oChild ):Number 
	{
		return ArrayUtil.indexOf(_model, oChild) ;
	}

	/**
	 * Returns an iterator.
	 * @return an Iterator.
	 */
	public function iterator():Iterator 
	{
		return new ArrayIterator( _model ) ;
	}
	
	/**
	 * Removes the specified child in argument.
	 * @return the removed child.
	 */
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
	
	/**
	 * Removes the specified child defines with the index value in argument.
	 * @return the removed child.
	 */
	public function removeChildAt(index:Number) 
	{
		var ret = getChildAt(index) || null ; 
		removeChildsAt(index, 1);
		return ret;
	}
	
	/**
	 * Removes all childs in the model defined for the first item by the specified index value, 
	 * this method remove the first and the {@code size - 1} items.
	 */
	public function removeChildsAt(index:Number, size:Number):Array 
	{
		var oldItems = _model.splice(index, size) ;
		_eRemove.firstItem = index ;
		_eRemove.lastItem  = index + size - 1 ;
		_eRemove.removedItems = [].concat(oldItems) ;
		dispatchEvent ( _eRemove ) ;
		return oldItems ;
	}
	
	/**
	 * Removes a range of childs in the model.
	 * @return the array representation of all removed items.
	 */
	public function removeRange(from:Number, to:Number):Array 
	{
		if (from == undefined) 
		{
			return null ;
		}
		return removeChildsAt(from, to - from) ;
	}
	
	/**
	 * Sets the specified child index (move the child in the model).
	 */
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
			dispatchEvent(_eUpdate) ;
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
	
	private var _eAdd:ModelChangedEvent ;
	
	private var _eClear:ModelChangedEvent ;
	
	private var _eRemove:ModelChangedEvent ;
	
	private var _eUpdate:ModelChangedEvent ;
	
	private var _model:Array ;
}