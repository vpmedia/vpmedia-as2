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

/* -------- ContainerModel

	AUTHOR

		Name : ContainerModel
		Package : neo.display.components.container
		Version : 1.0.0.0
		Date :  2006-02-06
		Author : ekameleon
		URL : http://www.ekameleon.net
		Mail : contact@ekameleon.net

	METHOD SUMMARY
	
		- addChild( oChild )
		
		- addChildAt( oChild, index:Number )
		
		- addModelListener(oL):Void
		
		- clear():Void
		
		- contains(oChild):Boolean
		
		- getChildAt(index:Number)
		
		- getChildByKey(key:Number)
		
		- getChildByName(name:String)
		
		- indexOf(oChild):Number

		

		- isEmpty():Boolean

		
		- notifyChanged(e:IEvent):Void
		
		- removeChild(oChild)
		
		- removeChildAt(index:Number)
		
		- removeChildsAt(index:Number, len:Number):Array
		
		- removeModelListener(oL):Void
		
		- removeRange(from:Number, to:Number):Array
		
		- setChildIndex( oChild, index:Number):Void
		
		- size():Number
		
		- toArray():Array
		
		- toString():String
	
	EVENT SUMMARY
	
		- EventType
	
	EVENT TYPE SUMMARY

		- ADD_ITEMS:ModelChangedEventType
		
		- CLEAR_ITEMS:ModelChangedEventType
		
		- REMOVE_ITEMS:ModelChangedEventType
			
		- UPDATE_ITEMS:ModelChangedEventType

	IMPLEMENTS 
	
		IModel

	INHERIT 
	
		AbstractModel > ContainerModel

	TODO Create a PageableModel Abstract class.

----------------*/

import com.bourre.core.HashCodeFactory;
import com.bourre.data.iterator.ArrayIterator;
import com.bourre.data.iterator.Iterable;
import com.bourre.data.iterator.Iterator;
import com.bourre.mvc.AbstractModel;

import neo.events.ModelChangedEvent;
import neo.events.ModelChangedEventType;
import neo.util.ArrayUtil;


class neo.display.components.container.ContainerModel extends AbstractModel implements Iterable {

	// ----o Constructor

	public function ContainerModel () { 
		super() ;
		_model = [] ;
	}

	// ----o Constant
	
	static public var ADD_ITEMS:ModelChangedEventType = ModelChangedEventType.ADD_ITEMS ; 
	static public var CLEAR_ITEMS:ModelChangedEventType = ModelChangedEventType.CLEAR_ITEMS ; 
	static public var REMOVE_ITEMS:ModelChangedEventType = ModelChangedEventType.REMOVE_ITEMS ; 
	static public var UPDATE_ITEMS:ModelChangedEventType = ModelChangedEventType.UPDATE_ITEMS ;


	static private var __ASPF__ = _global.ASSetPropFlags(ContainerModel, null , 7, 7) ;


	// ----o Public Methods
	
	public function addChild( oChild ) {
		return addChildAt(oChild, size()) ; 
	}
	
	public function addChildAt(oChild, index:Number) {
		var l:Number = size() ;
		if (index < 0) return null ;
		else if (index > l) return null ;
		else {
			_model.splice(index, 0, oChild) ;
			var ev:ModelChangedEvent = new ModelChangedEvent(ModelChangedEventType.ADD_ITEMS, this) ;
			ev.index = index ;
			ev.firstItem = index ;
			ev.lastItem = index ;
			notifyChanged( ev ) ;
			return oChild ;

		}
	}
	
	public function clear():Void {
		var e:ModelChangedEvent = new ModelChangedEvent(ModelChangedEventType.CLEAR_ITEMS, this);

		e.removedItems = _model.splice(0) ;

		notifyChanged(e) ;
	}
	
	public  function contains( oChild ):Boolean {
		return ArrayUtil.contains(_model, oChild) ;
	}
	
	public function getChildAt(index:Number) {
		return _model[index] ;
	}
	
	public function getChildByKey(key:Number) {
		var l:Number = size() ;
		while (--l > -1) {
			if (_model[l].__KEY == key) return _model[l] ;

		}
		return null ;
	}
	
	public function getChildByName(name:String) {
		var l:Number = size() ;
		while (--l > -1) {
			if (_model[l]._name == name) return _model[l] ;

		}
		return null ;
	}
	
	public function indexOf( oChild ):Number {
		return ArrayUtil.indexOf(_model, oChild) ;

	}
	
	public function getIterator():Iterator {
		return new ArrayIterator(_model) ;

	}
	
	public function removeChild( oChild ) {
		var index:Number = indexOf(oChild) ;
		if (index > -1) {
			return removeChildAt(index) ;

		} else {
			return null ;

		}
	}
	
	public function removeChildAt(index:Number) {
		var ret = this[index] ; 
		removeChildsAt(index, 1);
		return ret;
	}
	
	public function removeChildsAt(index:Number, len:Number):Array {
		var oldItems = _model.splice(index, len) ;

		var ev:ModelChangedEvent = new ModelChangedEvent(ModelChangedEventType.REMOVE_ITEMS, this) ;
		ev.firstItem = index ;
		ev.lastItem = index + len - 1 ;

		ev.removedItems = [].concat(oldItems) ;

		notifyChanged ( ev ) ;
		return oldItems ;
	}
	
	public function removeRange(from:Number, to:Number):Array {
		if (from == undefined) return null ;
		return removeChildsAt(from, to - from) ;
	}
	
	public function setChildIndex( oChild, index:Number):Void {
		var id:Number = indexOf(oChild) ;
		if (id == -1 || id == index) return ;
		else {
			var tmp = oChild ;
			_model.splice(id, 1) ;
			_model.splice(index, 0, tmp) ;

			notifyChanged(new ModelChangedEvent(ModelChangedEventType.UPDATE_ITEMS, this)) ;
		}
	}
	
	public function size():Number {
		return _model.length ;

	}
	
	public function toArray():Array {
		return [].concat(_model) ;

	}
	
	public function toString() : String {
		return '[ContainerModel' + HashCodeFactory.getKey( this ) + ']' ;
	}
	
	// ----o Private Properties

	private var _model:Array ;

}