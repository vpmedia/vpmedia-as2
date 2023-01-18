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
import pegas.process.SimpleAction;

import vegas.core.ICloneable;

/**
 * This class simplify a full implementation of the {@code Action} interface.
 * @author eKameleon
 */
class pegas.process.AbstractAction extends SimpleAction implements ICloneable
{

	/**
	 * Creates a new AbstractAction instance.
	 * @param bGlobal the flag to use a global event flow or a local event flow.
	 * @param sChannel the name of the global event flow if the {@code bGlobal} argument is {@code true}.
	 */	
	private function AbstractAction( bGlobal:Boolean, sChannel:String ) 
	{
		
		super(bGlobal, sChannel);
		
		_eChange   = new ActionEvent( ActionEvent.CHANGE   , this ) ;
		_eClear    = new ActionEvent( ActionEvent.CLEAR    , this ) ;
		_eInfo     = new ActionEvent( ActionEvent.INFO     , this ) ;
		_eLoop     = new ActionEvent( ActionEvent.LOOP     , this ) ;
		_eProgress = new ActionEvent( ActionEvent.PROGRESS , this ) ;
		_eResume   = new ActionEvent( ActionEvent.RESUME   , this ) ;
		_eStop     = new ActionEvent( ActionEvent.STOP     , this ) ;
		_eTimeout  = new ActionEvent( ActionEvent.TIMEOUT  , this ) ;
		
	}
	
	/**
	 * The flag to determinate if the Action object is looped.
	 */
	public var looping:Boolean ;

	/**
	 * Returns a shallow copy of this object.
	 * @return a shallow copy of this object.
	 */
	public function clone() 
	{
		//
	}

	/**
	 * Notify an ActionEvent when the process is changed.
	 */
	public function notifyChanged():Void 
	{
		dispatchEvent(_eChange) ;
	}

	/**
	 * Notify an ActionEvent when the process is cleared.
	 */
	public function notifyCleared():Void 
	{
		dispatchEvent(_eClear) ;
	}	

	/**
	 * Notify an ActionEvent when an info is dispatched.
	 */
	public function notifyInfo( oInfo ):Void 
	{
		dispatchEvent(_eInfo) ;
	}
	
	/**
	 * Notify an ActionEvent when the process is looped.
	 */
	public function notifyLooped():Void 
	{
		dispatchEvent(_eLoop) ;
	}

	/**
	 * Notify an ActionEvent when the process is in progress.
	 */
	public function notifyProgress():Void 
	{
		dispatchEvent(_eProgress) ;
	}
	
	/**
	 * Notify an ActionEvent when the process is resumed.
	 */
	public function notifyResumed():Void 
	{
		dispatchEvent(_eResume) ;
	}

	/**
	 * Notify an ActionEvent when the process is stopped.
	 */
	public function notifyStopped():Void 
	{
		dispatchEvent(_eStop) ;
	}

	/**
	 * Notify an ActionEvent when the process is out of time.
	 */
	public function notifyTimeOut():Void
	{
		dispatchEvent( _eTimeout ) ;
	}

	/**
	 * Returns a eden representation of the object.
	 * @param indent:Number optional the starting of the indenting
	 * @param identor:String the string value used to do the indentation
	 * @return a string representing the source code of the object.
	 */
	public function toSource(indent:Number, indentor:String):String 
	{
		return null ;
	}

	private var _eChange:ActionEvent ;
	private var _eClear:ActionEvent ;
	private var _eInfo:ActionEvent ;
	private var _eLoop:ActionEvent ;
	private var _eProgress:ActionEvent ;
	private var _eResume:ActionEvent ;
	private var _eStop:ActionEvent ;
	private var _eTimeout:ActionEvent ;
	
}
