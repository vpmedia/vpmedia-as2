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

import asgard.events.LoaderEvent;
import asgard.events.URLLoaderEvent;
import asgard.net.AbstractLoader;
import asgard.net.DataFormat;
import asgard.net.URLRequest;
import asgard.net.URLRequestHeader;
import asgard.net.URLVariables;

import vegas.events.Delegate;

// FIXME : IMPORTANT ici tout vérifier et Tests !!!!

/**
 * The URLLoader class.
 * @author eKameleon
 */
class asgard.net.URLLoader extends AbstractLoader 
{
	
	/**
	 * Creates a new URLLoader instance.
	 */
	function URLLoader() 
	{
		super() ;
		setLogger() ;
		setDataFormat(DataFormat.TEXT) ;
		_setInitTimer(super.onLoadInit) ;
	}

	/**
	 * The default content type of this {@code ILoader} object.
	 */
	static public var DEFAULT_CONTENT_TYPE:String = "application/x-www-form-urlencoded" ;
	
	/**
	 * (read-write) Returns the data format of this loader.
	 */
	public function get dataFormat():String 
	{
		return getDataFormat() ;
	}
	
	/**
	 * (read-write) Sets the data format of this loader.
	 */
	public function set dataFormat(s:String):Void 
	{
		setDataFormat(s) ;	
	}
	
	/**
	 * Adds a request header in the loader.
	 */
	public function addRequestHeader( header, headerValue:String ):Void 
	{
		getContent().addRequestHeader(header, headerValue) ;
	}

	/**
	 * Check the external data.
	 */
	public function checkData():Void 
	{
		deserializeData() ;
		_startInitTimer() ;
	}
	
	/**
	 * This method can be overrided to deserialize the external source string or data.
	 */
	public function deserializeData():Void 
	{
		// override thid method
	}

	/**
	 * Returns the content loader object of this ILoader.
	 * @return the content loader object of this ILoader.
	 */
	/*override*/ public function getContent():LoadVars 
	{
		return LoadVars( super.getContent() );
	}
	
	/**
	 * Returns the content type of this ILoader.
	 */
	public function getContentType():String 
	{
		return getContent().contentType ;	
	}
	
	/**
	 * Returns the data format of this {@code ILoader}.
	 * @return the data format of this {@code ILoader}.
	 */
	public function getDataFormat():String 
	{
		return _sDataFormat ;
	}

	/**
	 * Initialize the internal {@code Event} of this {@code ILoader}.
	 */
	public function initEvent():Void 
	{
		_e = new URLLoaderEvent(null, this) ;
	}

	/**
	 * Returns {@code true} if the external file is loaded.
	 * @return {@code true} if the external file is loaded.
	 */	
	public function isLoaded():Boolean 
	{
		return getContent().loaded ;	
	}	

	/**
	 * Load the external content in the loader.
	 */
	/*override*/ public function load(request:URLRequest):Void 
	{

		_oData = null ;
		
		var datas:Object = {} ;
		
		if (request) 
		{
		
			System.useCodepage = (request.getUseCodePage() || false) ;
			
			if (request.getUrl() != undefined) 
			{
				setUrl( request.getUrl() ) ;
			}
			
			_sContentType = request.getContentType() || URLRequest.DEFAULT_CONTENT_TYPE ;
			
			_sMethod = request.getMethod() ;
			
			_aHeaders = request.getRequestHeaders() ;
			
		}
		
		var sender:LoadVars = new LoadVars() ;
		//sender.contentType = _sContentType ;
		
		for (var prop:String in request.data)
		{
			sender[prop] = request.data[prop] ;	
		}
		
		var len:Number = _aHeaders.length ;
		if (len > 0) 
		{
			while(--len > -1) 
			{
				var header:URLRequestHeader = _aHeaders[len] ;
				sender.addRequestHeader( header.name , header.value ) ;
			} 
		}
		
		var receive:LoadVars = new LoadVars() ;
		receive.onHTTPStatus = Delegate.create(this, _onHTTPStatus, receive) ;
		receive.onData = Delegate.create(this, _onData) ;

		setContent( receive ) ;
				
		sender.sendAndLoad(this.getUrl(), receive, _sMethod ) ;
		
  		super.load() ;
  		
  	}
    
  	/*override*/ public function onLoadInit(e:LoaderEvent):Void 
  	{
		// overwriting for delaying 'onLoadInit' broadcast
	}
  
  	/**
  	 * Release the loader.
  	 */
  	public function release():Void 
  	{
  		getContent().onData = null ;
  		getContent().onLoad = null ;
  		super.release() ;
  			
  	}
  
  	/**
  	 * Sets the content loader object.
  	 */
	public function setContent(o:LoadVars):Void 
	{
		super.setContent( o );
	}
	
	/**
	 * Sets the content type value of this ILoader.
	 */
	public function setContentType(sType:String):Void 
	{
		getContent().contentType = sType || DEFAULT_CONTENT_TYPE ;
	}
	
	/**
	 * Sets the data format of the specified ILoader.
	 * @param s the string value of the current DataFormat of this ILoader.
	 * @see DataFormat
	 */
	public function setDataFormat(s:String):Void 
	{
		s = DataFormat.validate(s) ? s : DataFormat.TEXT ;
		_sDataFormat = s ;
	}

	private var _aHeaders:Array ;

	private var _sContentType:String = URLRequest.DEFAULT_CONTENT_TYPE ;

	private var _sDataFormat:String ;

	private var _sMethod:String = "POST" ;

	private var _oData = null ;
	
	// FIXME : REFACTORING COMPLET DE CETTE CLASSE !!! 
	
	private function _onData( source:String )
	{

		if (source == undefined) 
		{
			
			_onLoad(false) ;
			
		}
		else 
		{
		
			switch (getDataFormat()) {
			
				case DataFormat.TEXT :
					_oData = new String(source) ;
					break ;
				
				case DataFormat.VARIABLES :
					_oData = new URLVariables(source) ;
					break ;

				case DataFormat.BINARY :
				default :
					_oData = source ;
					break ;

			}

			_onLoad(true) ;
					
		}
	}
	
	/**
	 * Invoqued when the source is loading or not.
	 */
	private function _onLoad(success:Boolean):Void 
	{
		
		if (success) 
		{
			checkData() ;
		}
		else 
		{
			notifyError(this + " : Unload to load/parse URL file : " + this.getUrl() , null ) ;
		}
	}
	
  	private function _onHTTPStatus( httpStatus:Number , loader)
  	{
  		var httpStatusType:String = "unknow httpstatus" ;
     	
     	if(httpStatus < 100) 
     	{
          	httpStatusType = "flashError";
     	}
     	else if(httpStatus < 200) 
     	{
         	httpStatusType = "informational";
     	}
     	else if(httpStatus < 300) 
     	{
        	httpStatusType = "successful";
     	}
     	else if(httpStatus < 400) 
     	{
          	httpStatusType = "redirection";
     	}
     	else if(httpStatus < 500) 
     	{
         	 httpStatusType = "clientError";
     	}
     	else if(httpStatus < 600) 
     	{
          	httpStatusType = "serverError";
     	}
     	
     	getLogger().warn( this + " HTTP status:" + httpStatus + ", type:" + httpStatusType ) ;
  		
  	}
}