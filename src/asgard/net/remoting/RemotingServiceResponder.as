/*

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  
           http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is Vegas Framework.
  
  The Initial Developer of the Original Code is
  ALCARAZ Marc (aka eKameleon)  <vegas@ekameleon.net>.
  Portions created by the Initial Developer are Copyright (C) 2004-2007
  the Initial Developer. All Rights Reserved.
  
  Contributor(s) :
  
*/

import asgard.events.RemotingEvent;

import vegas.core.CoreObject;
import vegas.events.Delegate;

/**
 * The RemotingServiceResponder class provides an object that is used in the RemotingService instances to handle return values from the server.
 * @author eKameleon
 */
class asgard.net.remoting.RemotingServiceResponder extends CoreObject 
{
	
	/**
	 * Creates a new RemotingServiceResponder.
	 * @param scope the object who handle the values from the server.
	 * @param resultMethod The function invoked if the call to the server succeeds and returns a result.
	 * @param faultMethod The function invoked if the server returns an error.
	 */	
	public function RemotingServiceResponder( scope, resultMethod:Function, faultMethod:Function) 
	{
		
		super();
		
		if (!faultMethod) 
		{
			faultMethod = scope["onFault"] ;
		}
		
		if (!resultMethod) 
		{
			resultMethod = scope["onResult"] ;
		}
		
		_eFault  = new RemotingEvent( RemotingEvent.FAULT, null) ;
		_eResult = new RemotingEvent( RemotingEvent.RESULT, null) ;
		_fault   = new Delegate(scope, faultMethod) ;
		_result  = new Delegate(scope, resultMethod) ;
		
	}
	
	/**
	 * Returns the name of the method.
	 * @return the name of the method.
	 */
	public function getMethodName():String 
	{
		return _methodName ;
	}
	
	/**
	 * Returns the service reference of this responder.
	 * @return the service reference of this responder.
	 */
	public function getService() 
	{
		return _service ;	
	}
	
	/**
	 * Invoked if the call to the server succeeds and returns a result.
	 */
	public function onResult( oResult ):Void 
	{
		_eResult.setResult( oResult, _methodName ) ;
		_result.setArguments( _eResult ) ;
		_result.run() ;
	}

	/**
	 * Invoked if the server returns an error.
	 */
	public function onStatus( oFault:Object ):Void 
	{
		_eFault.setFault(oFault, _methodName) ;
		_fault.setArguments( _eFault );
		_fault.run();
	}
	
	/**
	 * Sets the name of the method.
	 */
	public function setMethodName(sName:String):Void 
	{
		_methodName = sName ;
	}

	/**
	 * Sets the service reference.
	 */
	public function setService( service ) 
	{
		_service = service ;
	}

	private var _eFault:RemotingEvent ;
	private var _eResult:RemotingEvent ;
	
	private var _fault:Delegate ;
	private var _methodName:String ;
	private var _result:Delegate ;
	
	private var _service ;
	
}