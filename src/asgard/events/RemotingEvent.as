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

import vegas.events.DynamicEvent;
import vegas.util.serialize.Serializer;

/**
 * The RemotingEvent class.
 * @author eKameleon
 */
class asgard.events.RemotingEvent extends DynamicEvent 
{

	/**
	 * Creates a new RemotingEvent instance.
	 */
	public function RemotingEvent(type:String, target, oResult, oFault, sMethodName:String, sCode:String, sLevel:String, context, bubbles:Boolean, eventPhase:Number, time:Number, stop:Number )
	{
		super(type, target, context, bubbles, eventPhase, time, stop) ;
		code = sCode || null ;
		level = sLevel || null ;
		setResult(oResult) ;
		setFault(oFault) ;
		if (sMethodName) setMethodName(sMethodName) ; 
	}

	static public var ERROR:String = "onError" ;	
	
	static public var FAULT:String = "onFault" ;
	
	static public var FINISH:String = "onFinished" ;
	
	static public var PROGRESS:String = "onProgress" ;
	
	static public var RESULT:String = "onResult" ;
	
	static public var START:String = "onStarted" ;
	
	static public var TIMEOUT:String = "onTimeOut" ;
	
	static private var __ASPF__ = _global.ASSetPropFlags(RemotingEvent, null , 7, 7) ;

	public var code:String ;

	public function get fault() 
	{
		return getFault() ;	
	}
	
	public function set fault(oFault):Void 
	{
		setFault(oFault) ;	
	}

	public var level:String ;

	public function get result() 
	{
		return getResult() ;	
	}
	
	public function set result(oResult):Void 
	{
		setResult(oResult) ;	
	}
	
	public function clone() 
	{
		var e:RemotingEvent = new RemotingEvent(getType(), getTarget()) ;
		e.code = code ;
		e.setFault(getFault()) ;
		e.level = level ;
		e.setResult( getResult() ) ;
		e.setMethodName(getMethodName()) ;
		return e ;
	}

	public function getCode():String 
	{
		return _sCode ;
	}

	public function getDescription():String 
	{
		return _sDescription ;
	}

	public function getDetail():String 
	{
		return _sDetail ;
	}

	public function getExceptionStack():String 
	{
		return _sExceptionStack ;
	}
	
	public function getFault() 
	{
		return _fault ;
	}

	public function getLevel():String 
	{
		return _sLevel ;
	}
	
	public function getLine():String 
	{
		return _sLine ;
	}
	
	public function getMethodName():String 
	{
		return _sMethodName ;
	}

	public function getResult() 
	{
		return _result ;	
	}
	
	public function getResults() 
	{
		return _result ;	
	}

	public function setFault( oFault , methodName:String):Void 
	{
		_fault = oFault || null ;	
		if (_fault != null) {
			_sCode = oFault.code || null ;
			_sDetail = oFault.details || null ;
			_sDescription = oFault.description || null ;
			_sExceptionStack = oFault.exceptionStack || null ;
			_sLevel = oFault.level || null ;
			_sLine = oFault.line || null ;
		}
		if (methodName) setMethodName( methodName ) ;
	}
	
	public function setMethodName( methodName:String ):Void 
	{
		_sMethodName = methodName || null  ;	
	}
	
	public function setResult( oResult , sMethodName:String ):Void 
	{
		_result = oResult || null ;
		if (sMethodName) setMethodName( sMethodName ) ;
	}		
	
	private var _fault ;
	private var _result ;	
	private var _sCode:String ;
	private var _sDescription:String ;
	private var _sDetail : String ;
	private var _sExceptionStack:String ;
	private var _sLevel:String ;
	private var _sLine:String ;
	private var _sMethodName:String ;

	/*protected*/ private function _getParams():Array {
		var ar:Array = super._getParams() ;
		ar.splice(2, null, Serializer.toSource(_result)) ;
		ar.splice(3, null, Serializer.toSource(_fault)) ;
		ar.splice(4, null, Serializer.toSource(_sMethodName)) ;
		ar.splice(5, null, Serializer.toSource(code)) ;
		ar.splice(6, null, Serializer.toSource(level)) ;
		return ar ;
	}

}
