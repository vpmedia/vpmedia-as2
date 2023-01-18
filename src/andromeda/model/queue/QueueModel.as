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

import vegas.data.iterator.Iterator;
import vegas.data.Queue;
import vegas.data.queue.LinearQueue;
import vegas.errors.IllegalArgumentError;

/**
 * This model use an internal {@code Queue} to register value objects.
 * @author eKameleon
 */
class andromeda.model.queue.QueueModel extends AbstractModelObject 
{
	
	/**
	 * Creates a new QueueModel instance.
	 * @param id the id of this model.
	 * @param bGlobal the flag to use a global event flow or a local event flow.
	 * @param sChannel the name of the global event flow if the {@code bGlobal} argument is {@code true}.
	 */
	function QueueModel( id , bGlobal:Boolean , sChannel:String ) 
	{
		super(id, bGlobal, sChannel);
		_queue = initializeQueue() ;
	}

	/**
	 * Default event type when the dequeue method is invoqued.
	 */
	static public var DEQUEUE_VO:String = "onDequeueVO" ;
	
	/**
	 * Default event type when the enqueue method is invoqued.
	 */
	static public var ENQUEUE_VO:String = "onEnqueueVO" ;

	/**
	 * Removes all value objects in the model.
	 */
	public function clear():Void
	{
		_queue.clear() ;
		super.clear() ;
	}
	
	/**
	 * Dequeues the head value object in the model.
	 */
	public function dequeue():Void
	{
		var vo:IValueObject = _queue.poll() ;
		_eDequeue.setVO( vo ) ;
		dispatchEvent( _eDequeue ) ;
	}

	/**
	 * Enqueues a value object in the model.
	 */
	public function enqueue( vo:IValueObject ):Void
	{
		if (vo == null)
		{
			throw new IllegalArgumentError( this + " enqueue method failed, the IValueObject passed in argument not must be 'null' or 'undefined'.") ;	
		}
		validate(vo) ;
		_queue.enqueue( vo ) ;
		_eEnqueue.setVO( vo ) ;
		dispatchEvent( _eEnqueue ) ;
	}

	/**
	 * Returns the event name use in the {@code dequeue} method.
	 * @return the event name use in the {@code dequeue} method.
	 */
	public function getEventTypeDEQUEUE():String
	{
		return _eDequeue.getType() ;
	}
	
	/**
	 * Returns the event name use in the {@code enqueue} method.
	 * @return the event name use in the {@code enqueue} method.
	 */
	public function getEventTypeENQUEUE():String
	{
		return _eEnqueue.getType() ;
	}

	/**
	 * Returns the internal Queue reference of this model.
	 * @return the internal Queue reference of this model.
	 */
	public function getQueue():Queue
	{
		return _queue ;	
	}

	/**
	 * This method is invoqued in the constructor of the class to initialize all events.
	 */
	/*override*/ public function initEvent():Void
	{
		super.initEvent() ;
		_eDequeue = createNewModelObjectEvent( QueueModel.DEQUEUE_VO ) ;
		_eEnqueue = createNewModelObjectEvent( QueueModel.ENQUEUE_VO ) ; 
	}

	/**
	 * Initialize the internal Queue instance in the constructor of the class.
	 * You can overrides this method if you want change the default LinearQueue use in this model.
	 */
	public function initializeQueue():Queue
	{
		return new LinearQueue() ;	
	}

	/**
	 * Returns {@code true} if this model is empty.
	 * @return {@code true} if this model is empty.
	 */
	public function isEmpty():Boolean 
	{ 
		return _queue.isEmpty() ;
	}

	/**
	 * Returns the iterator of this model.
	 * @return the iterator of this model.
	 */
	public function iterator():Iterator
	{
		return _queue.iterator() ;	
	}

	/**
	 * Sets the event name use in the {@code enqueue} method.
	 */
	public function setEventTypeDEQUEUE( type:String ):Void
	{
		_eDequeue.setType( type ) ;
	}
	
	/**
	 * Sets the event name use in the {@code dequeue} method.
	 */
	public function setEventTypeENQUEUE( type:String ):Void
	{
		_eEnqueue.setType( type ) ;
	}

	/**
	 * Returns the number of IValueObject in this model.
	 * @return the number of IValueObject in this model.
	 */
	public function size():Number
	{
		return _queue.size() ;
	}

	/**
	 * Returns the {@code Array} representation of this object.
	 * @return the {@code Array} representation of this object.
	 */
	public function toArray():Array
	{
		return _queue.toArray() ;	
	}

	/**
	 * The internal ModelObjectEvent use in the {@code dequeue} method.
	 */
	private var _eDequeue:ModelObjectEvent ;

	/**
	 * The internal ModelObjectEvent use in the {@code enqueue} method.
	 */
	private var _eEnqueue:ModelObjectEvent ;

	/**
	 * The internal {@code Queue} reference.
	 */
	private var _queue:Queue ;

}