/*

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  
           http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is PEGAS Framework.
  
  The Initial Developer of the Original Code is
  ALCARAZ Marc (aka eKameleon)  <vegas@ekameleon.net>.
  Portions created by the Initial Developer are Copyright (C) 2004-2007
  the Initial Developer. All Rights Reserved.
  
  Contributor(s) :
  
*/

import pegas.events.ActionEvent;
import pegas.events.TransitionEvent;
import pegas.transitions.ITransition;

import vegas.core.Identifiable;
import vegas.errors.UnsupportedOperation;
import vegas.events.AbstractCoreEventDispatcher;

/**
 * This abstract class defines the skeletal implementation of the ITransition interface.
 * @author eKameleon
 */
class pegas.transitions.AbstractTransition extends AbstractCoreEventDispatcher implements Identifiable, ITransition 
{

	/**
	 * Creates a new AbstractTransition instance.
	 * @param id the 'id' value of the ITransition object.
	 * @param bGlobal the flag to use a global event flow or a local event flow.
	 * @param sChannel the name of the global event flow if the {@code bGlobal} argument is {@code true}.
	 */	
	function AbstractTransition( id, bGlobal:Boolean, sChannel:String ) 
	{
		super(bGlobal, sChannel);
		setID( id ) ;
		_eFinish = new TransitionEvent( ActionEvent.FINISH , this ) ;
		_eStart  = new TransitionEvent( ActionEvent.START  , this ) ;
	}

	/**
	 * The id value of this ITransition object.
	 */
	public var id ;

	/**
	 * (read-only) Returns {@code true} if the manager is in progress.
	 * @return {@code true} if the manager is in progress.
	 */
	public function get running():Boolean 
	{
		return getRunning() ;	
	}

	/**
	 * Returns the shallow copy of this object.
	 * @return the shallow copy of this object.
	 */
	public function clone() 
	{
		throw new UnsupportedOperation( this + " clone method is unsupported.") ;
	}

	/**
	 * Returns the id of this ITransition object. This method is use to register this object in a TransitionController.
	 * You can overrides this method to change the nature of the natural id property of this object but this hack don't modify the value of the id property. 
	 * @return the id of this ITransition object.
	 */
	public function getID() 
	{
		return this.id ;
	}

	/**
	 * Returns {@code true} if the transition is in progress.
	 * @return {@code true} if the transition is in progress.
	 */
	public function getRunning():Boolean 
	{
		return _isRunning ;	
	}

	/**
	 * Notify a TransitionEvent if the process is finished.
	 */
	public function notifyFinished():Void 
	{
		_setRunning(false) ;
		dispatchEvent(_eFinish) ;
	}

	/**
	 * Notify a TransitionEvent if the process is started.
	 */
	public function notifyStarted():Void 
	{
		_setRunning(true) ;
		dispatchEvent(_eStart) ;
	}

	/**
	 * Run the process.
	 * Overrides this method to implement your layout.
	 */
	public function run() : Void 
	{
		// overrides this method.
	}

	/**
	 * Sets the id of this ITransition object.
	 */
	public function setID( id ):Void 
	{
		this.id = id ;
	}
	
	/**
	 * Invoqued when the transition finish this process.
	 */
	private var _eFinish:TransitionEvent ;
	
	/**
	 * Invoqued when the transition start this process.
	 */
	private var _eStart:TransitionEvent ;

	/**
	 * Determinates if the transition is in progress or not.
	 */
	private var _isRunning:Boolean ;

	/**
	 * Protected method used to change the value of the running property.
	 */
	/*protected*/ private function _setRunning(b:Boolean):Void 
	{
		_isRunning = b ;	
	}


}