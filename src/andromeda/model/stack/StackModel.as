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
import vegas.data.Stack;
import vegas.data.stack.SimpleStack;
import vegas.errors.IllegalArgumentError;

/**
 * This model use an internal {@code Stack} to register value objects.
 * @author eKameleon
 */
class andromeda.model.stack.StackModel extends AbstractModelObject 
{
	
	/**
	 * Creates a new StackModel instance.
	 * @param id the id of this model.
	 * @param bGlobal the flag to use a global event flow or a local event flow.
	 * @param sChannel the name of the global event flow if the {@code bGlobal} argument is {@code true}.
	 */
	function StackModel( id , bGlobal:Boolean , sChannel:String ) 
	{
		super(id, bGlobal, sChannel);
		_stack = initializeStack() ;
	}

	/**
	 * Default event type when the pop method is invoqued.
	 */
	static public var POP_VO:String = "onPopVO" ;
	
	/**
	 * Default event type when the push method is invoqued.
	 */
	static public var PUSH_VO:String = "onPushVO" ;

	/**
	 * Removes all value objects in the model.
	 */
	public function clear():Void
	{
		_stack.clear() ;
		super.clear() ;
	}

	/**
	 * Returns the event name use in the {@code pop} method.
	 * @return the event name use in the {@code pop} method.
	 */
	public function getEventTypePOP():String
	{
		return _ePop.getType() ;
	}
	
	/**
	 * Returns the event name use in the {@code push} method.
	 * @return the event name use in the {@code push} method.
	 */
	public function getEventTypePUSH():String
	{
		return _ePush.getType() ;
	}

	/**
	 * Returns the internal {@code Stack} reference of this model.
	 * @return the internal {@code Stack} reference of this model.
	 */
	public function getStack():Stack
	{
		return _stack ;	
	}

	/**
	 * This method is invoqued in the constructor of the class to initialize all events.
	 */
	/*override*/ public function initEvent():Void
	{
		super.initEvent() ;
		_ePop  = createNewModelObjectEvent( StackModel.POP_VO ) ;
		_ePush = createNewModelObjectEvent( StackModel.PUSH_VO ) ; 
	}

	/**
	 * Initialize the internal Stack instance in the constructor of the class.
	 * You can overrides this method if you want change the default {@code SimpleStack} use in this model.
	 */
	public function initializeStack():Stack
	{
		return new SimpleStack() ;	
	}

	/**
	 * Returns {@code true} if this model is empty.
	 * @return {@code true} if this model is empty.
	 */
	public function isEmpty():Boolean 
	{ 
		return _stack.isEmpty() ;
	}

	/**
	 * Returns the iterator of this model.
	 * @return the iterator of this model.
	 */
	public function iterator():Iterator
	{
		return _stack.iterator() ;	
	}
	
	/**
	 * Removes and returns the lastly pushed value object in the model.
	 * @return the lastly pushed value object in the model.
	 */
	public function pop():IValueObject
	{
		var vo:IValueObject = _stack.pop() ;
		_ePop.setVO( vo ) ;
		dispatchEvent( _ePop ) ;
		return vo ;
	}

	/**
	 * Pushes the passed-in value object to this stack.
	 * @param vo The IValueObject to push.
	 */
	public function push( vo:IValueObject ):Void
	{
		if (vo == null)
		{
			throw new IllegalArgumentError( this + " enqueue method failed, the IValueObject passed in argument not must be 'null' or 'undefined'.") ;	
		}
		validate(vo) ;
		_stack.push( vo ) ;
		_ePush.setVO( vo ) ;
		dispatchEvent( _ePush ) ;
	}

	/**
	 * Sets the event name use in the {@code pop} method.
	 */
	public function setEventTypePOP( type:String ):Void
	{
		_ePop.setType( type ) ;
	}
	
	/**
	 * Sets the event name use in the {@code push} method.
	 */
	public function setEventTypePUSH( type:String ):Void
	{
		_ePush.setType( type ) ;
	}

	/**
	 * Returns the number of IValueObject in this model.
	 * @return the number of IValueObject in this model.
	 */
	public function size():Number
	{
		return _stack.size() ;
	}

	/**
	 * Returns the {@code Array} representation of this object.
	 * @return the {@code Array} representation of this object.
	 */
	public function toArray():Array
	{
		return _stack.toArray() ;	
	}

	/**
	 * The internal ModelObjectEvent use in the {@code pop} method.
	 */
	private var _ePop:ModelObjectEvent ;

	/**
	 * The internal ModelObjectEvent use in the {@code push} method.
	 */
	private var _ePush:ModelObjectEvent ;

	/**
	 * The internal {@code Stack} reference.
	 */
	private var _stack:Stack ;

}