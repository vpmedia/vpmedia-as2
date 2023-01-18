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

import asgard.events.SharedDataEvent;
import asgard.events.SharedDataEventType;
import asgard.net.NetServerConnection;
import asgard.net.SharedDataStatus;

import vegas.events.AbstractCoreEventDispatcher;
import vegas.events.Delegate;

/**
 * The {@code SharedData} class is used to read and store limited amounts of data on a user's computer or on a server.
 * @author eKameleon
 * @version 1.0.0.0
 */
class asgard.net.SharedData extends AbstractCoreEventDispatcher 
{
	
	/**
	 * Creates a new SharedData instance.
	 */
	function SharedData( sName:String, nc:NetServerConnection, persistant:Boolean, autoConnect:Boolean) 
	{
		
		_isConnected = false ;
		_isFirst = true ;
	
		_eChange = new SharedDataEvent(SharedDataEventType.CHANGE, this) ;
		_eClear = new SharedDataEvent(SharedDataEventType.CLEAR, this) ;
		_eClose = new SharedDataEvent(SharedDataEventType.CLOSE, this) ;
		_eFire = new SharedDataEvent( SharedDataEventType.FIRE , this ) ;
		_eDelete = new SharedDataEvent(SharedDataEventType.DELETE, this) ;
		_eReject = new SharedDataEvent(SharedDataEventType.REJECT, this) ;
		_eSuccess = new SharedDataEvent(SharedDataEventType.SUCCESS, this) ;
		_eSync = new SharedDataEvent(SharedDataEventType.SYNCHRONISED, this) ;
		
		initialize(sName, nc, persistant, autoConnect) ;
		
	}


	public function get data() 
	{
		return getData() ; 
	}
	
	public function get isConnected():Boolean 
	{
		return getIsConnected() ;	
	}

	public function clear():Void 
	{
		_so.clear() ;
	}

 	public function close():Void 
 	{
		if (_isConnected) 
		{
			_so.close() ;
			_isConnected = false ;
			dispatchEvent(_eClose) ;
		}
	}
	
	public function connect(nc:NetServerConnection):Boolean 
	{
		close() ;
		_isConnected = _so.connect(nc) ;
		return _isConnected ;
	}

	public function fireEvent( eContext ):Void 
	{
  		_so.send(SharedDataEventType.FIRE, eContext );
  	}

	public function flush():Void 
	{
		_so.flush() ;
	}	
	
	public function getData() 
	{
		return _so.data ;	
	}
	
	public function getIsConnected():Boolean 
	{
		return _isConnected ;	
	}

	public function getProperty(sName:String) 
	{
  		return _so.data[sName];
  	}

	public function initialize(sName:String, nc:NetServerConnection, persistant:Boolean, autoConnect:Boolean):Void 
	{
		if (_so ) 
		{
			_so.close() ;
		}
		_so = SharedObject.getRemote(sName, nc.uri, persistant) ;
		_so.onSync = Delegate.create(this, _onSync) ;
		_so[SharedDataEventType.FIRE] = Delegate.create(this, _onFired) ;	
		if (autoConnect) 
		{
			connect(nc) ;
		}
	}

	public function lock():Void 
	{
		_so.setFps(0);
	}

	public function reset():Void 
	{
		var o:Object = getData() ;
		for (var each:String in o) 
		{
			delete o[each] ;
		}
	}	
	
	public function setFps(n:Number):Boolean 
	{
  		return _so.setFps(n);
  	}
  	
  	public function setProperty(sName:String, value ):Void 
  	{
  		_so.data[sName] = value ;
		_so.flush() ;
  	}

	public function size():Number 
	{
		return _so.getSize() ;	
	}

	/**
	 * Unlock Method like server side SSAS !! Test this method !!
	 */
 	public function unlock():Void 
 	{
		_so.setFps(0) ;
		_so.setFps(-1) ;
	}

	private var _eChange:SharedDataEvent ;
	private var _eClear:SharedDataEvent;
	private var _eClose:SharedDataEvent ;	
	private var _eDelete:SharedDataEvent ;	
	private var _eFire:SharedDataEvent ;
	private var _eReject:SharedDataEvent ;		
	private var _eSuccess:SharedDataEvent ;		
	private var _eSync:SharedDataEvent ;		

	private var _isConnected:Boolean ;
	private var _isFirst:Boolean ;
	
	private var _so:SharedObject ;
		
	private function _onSync( list ):Void 
	{
		
		if (_isFirst) 
		{
			_isFirst = false ;
			dispatchEvent(_eSync) ;
			for (var name:String in _so.data ) 
			{
				_eChange.setProperty(name, _so.data[name]) ;
				dispatchEvent( _eChange ) ;
			}
			return ;
		}
		
		for (var prop:String in list) 
		{
			
			var item:Object = list[prop] ;
			var code:SharedDataStatus = SharedDataStatus.format( item.code )  ;
			var name:String = item.name ;
			var value = _so.data[name] ;

			//**** DEBUG
			// var txt:String = "> " + this + "._onSync :: " + code ;
			// if(name) txt += " , name:" + name ;
			// if(value) txt += " , value:" + value ;
			// trace (txt) ;
			//***/
			
			switch (code) 
			{
				case SharedDataStatus.CLEAR :
				{
					dispatchEvent(_eClear);
					break ;
				}
				case SharedDataStatus.CHANGE :
				{
					_eChange.setProperty(name, value) ;
					dispatchEvent(_eChange);
					break ;
				}	
				case SharedDataStatus.DELETE :
				{
					_eDelete.setProperty(name) ;
					dispatchEvent(_eDelete );
					break ;
				}
				case SharedDataStatus.REJECT :
				{
					_eReject.setProperty(name, value) ;
					dispatchEvent(_eReject );
					break ;
				}
				case SharedDataStatus.SUCCESS :
				{
					_eSuccess.setProperty(name, value) ;
					dispatchEvent(_eSuccess );
					break ;
				}
			}
   		}
	}

	private function _onFired( eventContext ):Void 
	{
		_eFire.setContext ( eventContext ) ;
   		dispatchEvent( _eFire ) ;
	}
	
}