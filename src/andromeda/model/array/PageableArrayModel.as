/*

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  
           http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is Andromeda Framework based on VEGAS.
  
  The Initial Developer of the Original Code is
  ALCARAZ Marc (aka eKameleon)  <vegas@ekameleon.net>.
  Portions created by the Initial Developer are Copyright (C) 2004-2007
  the Initial Developer. All Rights Reserved.
  
  Contributor(s) :
  
*/

import andromeda.events.ModelObjectEvent;
import andromeda.model.AbstractModelObject;
import andromeda.model.IValueObject;

import vegas.core.IRunnable;
import vegas.data.iterator.Iterator;
import vegas.data.iterator.PageByPageIterator;
import vegas.events.ArrayEvent;

// TODO change the ArrayEvent with a BasicEvent when the pageCount value is 1.

/**
 * Defines an array model with a 'page by page' iterator.
 * @author eKameleon
 */
class andromeda.model.array.PageableArrayModel extends AbstractModelObject implements IRunnable
{
	
	/**
	 * Creates a new PageableArrayModel instance.
	 * @param id the id of this model.
	 * @param bGlobal the flag to use a global event flow or a local event flow.
	 * @param sChannel the name of the global event flow if the {@code bGlobal} argument is {@code true}.
	 */
	function PageableArrayModel( id , bGlobal:Boolean , sChannel:String ) 
	{
		super( id , bGlobal, sChannel) ;
		_a = new Array() ;
	}

	/**
	 * Inserts all IValueObject in the array passed in argument.
	 * @param datas The array of all value objects to insert in the model.
	 * @param noClear (optional) If this argument is is {@code true} the clear method isn't called. 
	 */
	public function addAllVO( datas:Array , noClear:Boolean):Void
	{
		if ( !noClear )
		{
			clear() ;
		}
		var len:Number = datas.length ;
		for (var i:Number = 0 ; i<len ; i++)
		{
			var vo:IValueObject = IValueObject( datas[i] ) ;
			if ( supports( vo ) )
			{
				_a.push( vo ) ;
			}	
		}
		refresh() ;
	}

	/**
	 * Clear the model.
	 */	
	public function clear():Void
	{
		_a = []  ;
		super.clear() ;
	}

	/**
	 * Returns the count of the IValueObject in a page of this model.
	 * @return the count of the IValueObject in a page of this model.
	 */
	public function getCountVO():Number
	{
		return _voCount ;
	}

	/**
	 * Returns the event name use in the {@code addVO} method.
	 * @return the event name use in the {@code addVO} method.
	 */
	public function getEventTypeUPDATE():String
	{
		return _eUpdate.getType() ;
	}

	/**
	 * Returns the current page selected in the model.
	 * @return the current page selected in the model.
	 */
	public function getCurrentPage():Number
	{
		return _itPage.currentPage() ;	
	}

	/**
	 * Returns the numbers of page with the current model.
	 * @return the numbers of page with the current model.
	 */
	public function getPageCount():Number
	{
		return _itPage.pageCount() ;	
	}

	/**
	 * Returns {@code true} if the list has a next page.
	 * @return {@code true} if the list has a next page.
	 */
	public function hasNext():Boolean
	{
		return 	_itPage.hasNext() ;
	}
	
	/**
	 * Returns {@code true} if the list has a previous page.
	 * @return {@code true} if the list has a previous page.
	 */
	public function hasPrevious():Boolean
	{
		return 	_itPage.hasPrevious() ;
	}
	
	/**
	 * This method is invoqued in the constructor of the class to initialize all events.
	 */
	/*override*/ public function initEvent():Void
	{
		super.initEvent() ;
		_eUpdate = new ArrayEvent( ModelObjectEvent.UPDATE_VO ) ;
	}

	/**
	 * Returns a PageByPageIterator of this model.
	 * @return a PageByPageIterator of this model.
	 */
	public function iterator():Iterator
	{
		return new PageByPageIterator(_voCount, _a) ;	
	}

	/**
	 * Show in the previous page in the list or previous screen.
	 */
	public function previous()
	{
		if ( hasPrevious() )
		{
			_eUpdate.setArray( _itPage.previous() ) ;
			dispatchEvent( _eUpdate  ) ;
			return _eUpdate.getArray() ;	
		}
	}

	/**
	 * Show the next page of the model.
	 */
	public function next()
	{
		if ( hasNext() )
		{
			_eUpdate.setArray( _itPage.next() ) ;
			dispatchEvent( _eUpdate  ) ;
			return _eUpdate.getArray() ;	
		}
	}

	/**
	 * Refresh the model.
	 */
	public function refresh():Void
	{
		if (size() > 0)
		{
			_itPage = new PageByPageIterator ( _voCount , _a ) ;
		}
		else
		{
			_itPage = null ;	
		}
		run() ;
	}

	/**
	 * Run the model when is initialize.
	 */
	public function run():Void
	{
		next() ;
	}

	/**
	 * Set the count of the IValueObject in a page of this model.
	 */
	public function setCountVO( n:Number ):Void
	{
		_voCount = n > 0 ? n : 0 ;
		refresh() ;
	}

	/**
	 * Sets the event name use in the {@code addVO} method.
	 */
	public function setEventTypeUPDATE( type:String ):Void
	{
		_eUpdate.setType( type ) ;
	}

	/**
	 * Returns the number of elements in the model.
	 * @return the number of elements in the model.
	 */
	public function size():Number
	{
		return _a.length ;	
	}
	
	/**
	 * Returns the array representation of all vos in this model.
	 * @return the array representation of all vos in this model.
	 */
	public function toArray():Array
	{
		return [].contact(_a) ;	
	}

	/**
	 * The internal array of all elements.
	 */
	private var _a:Array ; 

	/**
	 * The internal ArrayEvent when the update event type is use.
	 */
	private var _eUpdate:ArrayEvent ;

	/**
	 * The current PageByPageIterator instance.
	 */
	private var _itPage:PageByPageIterator ;
	
	/**
	 * The numbers of items in the list (16 default icons in the list).
	 */
	private var _voCount:Number = 1 ;
	


}