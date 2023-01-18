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

import asgard.net.URLRequestMethod;

import vegas.core.CoreObject;
import vegas.core.ICloneable;
import vegas.errors.ArgumentsError;

/**
 * The URLRequest class captures all of the information in a single HTTP request.
 * @author eKameleon
 * @version 1.0.0.0
 */
class asgard.net.URLRequest extends CoreObject implements ICloneable 
{
	
	/**
	 * Creates a new URLRequest instance.
	 * @param url the uri of the da
	 */
	public function URLRequest(url:String) {
		super() ;
		_sURL = url ;
	}

	/**
	 * The default content type value.
	 */
	static public var DEFAULT_CONTENT_TYPE:String = "application/x-www-form-urlencoded" ;
	
	static private var __ASPF__ = _global.ASSetPropFlags(URLRequest, null , 7, 7) ;

	/**
	 * Returns the MIME content type of any POST data.
	 * @return the MIME content type of any POST data.
	 */
	public function get contentType():String 
	{
		return getContentType() ;
	}
	
	/**
	 * Sets the MIME content type of any POST data.
	 */
	public function set contentType(s:String):Void 
	{
		setContentType(s) ;	
	}

	/**
	 * Returns an object containing data to be transmitted with the URL request.
	 * @return an object containing data to be transmitted with the URL request.
	 */
	public function get data() 
	{
		return getData() ;
	}
	
	/**
	 * Sets an object containing data to be transmitted with the URL request.
	 */
	public function set data(o):Void 
	{
		setData(o) ;	
	}

	/**
	 * Returns the HTTP form submission method, this method must be a GET or POST operation.
	 * @return the HTTP form submission method, this method must be a GET or POST operation.
	 * @see URLRequestMethod
	 */
	public function get method():String 
	{
		return getMethod() ;
	}
	
	/**
	 * Controls whether the HTTP form submission method is a GET or POST operation.
	 * @see URLRequestMethod
	 */
	public function set method(s:String):Void 
	{
		setMethod(s) ;	
	}

	/**
	 * Returns the array of HTTP request headers to be appended to the HTTP request.
	 * @return the array of HTTP request headers to be appended to the HTTP request.
	 */
	public function get requestHeaders():Array 
	{
		return getRequestHeaders() ;
	}
	
	/**
	 * Sets the array of HTTP request headers to be appended to the HTTP request.
	 */
	public function set requestHeaders(ar:Array):Void 
	{
		setRequestHeaders(ar) ;	
	}

	/**
	 * Returns the URL to be requested.
	 * @return the URL to be requested.
	 */
	public function get url():String 
	{
		return this.getUrl() ;
	}
	
	/**
	 * Sets the URL to be requested.
	 */
	public function set url(sURL:String):Void 
	{
		setUrl(sURL) ;	
	}

	/**
	 * Returns {@code true} if the request is encoded using the system code page, rather than Unicode.
	 * @return {@code true} if the request is encoded using the system code page, rather than Unicode.
	 */
	public function get useCodePage():Boolean 
	{
		return getUseCodePage() ;
	}
	
	/**
	 * Sets {@code true} if the request is encoded using the system code page, rather than Unicode.
	 */
	public function set useCodePage(b:Boolean):Void 
	{
		setUseCodePage(b) ;	
	}

	/**
	 * Returns a shallow copy of this instance.
	 * @return a shallow copy of this instance.
	 */
	public function clone() 
	{
		var request:URLRequest = new URLRequest(this.getUrl()) ;
		request.setData( getData() ) ;
		request.setContentType( getContentType() ) ;
		request.setMethod( getMethod() ) ;
		request.setRequestHeaders( getRequestHeaders() ) ;
		request.setUseCodePage( getUseCodePage() ) ;
		return request ;
	}
	
	/**
	 * Returns the MIME content type of any POST data.
	 * @return the MIME content type of any POST data.
	 */
	public function getContentType():String 
	{
		return _sContentType || DEFAULT_CONTENT_TYPE ;	
	}

	/**
	 * Returns An object containing data to be transmitted with the URL request.
	 * @return An object containing data to be transmitted with the URL request.
	 */
	public function getData() 
	{
		return _oData ;	
	}

	/**
	 * Controls whether the HTTP form submission method is a GET  or POST operation.
	 */
	public function getMethod():String 
	{
		return _sMethod || URLRequestMethod.POST ;
	}

	/**
	 * Retreive the array of HTTP request headers to be appended to the HTTP request.
	 * @return an array of HTTP request headers.
	 */
	public function getRequestHeaders():Array 
	{
		return _aRequestHeaders ;
	}

	/**
	 * Returns The URL to be requested.
	 * @return The URL to be requested.
	 */
	public function getUrl():String 
	{
		return _sURL ;	
	}

	/**
	 * Returns {@code true} if the request is encoded using the system code page, rather than Unicode.
	 * @return {@code true} if the request is encoded using the system code page, rather than Unicode.
	 */
	public function getUseCodePage():Boolean 
	{
		return _bUseCodePage ;
	}

	/**
	 * Sets the MIME content type of any POST data.
	 */
	public function setContentType(sType:String):Void 
	{
		_sContentType = sType ;
	}

	/**
	 * Sets an object containing data to be transmitted with the URL request.
	 */
	public function setData( oData ) 
	{
		_oData = oData ;	
	}

	/**
	 * Controls whether the HTTP form submission method is a GET or POST operation.
	 * @see URLRequestMethod
	 */
	public function setMethod(sMethod:String):Void 
	{
		if (URLRequestMethod.validate(sMethod)) 
		{
			_sMethod = sMethod ;
		}
		else 
		{
			throw new ArgumentsError(this + ".setMethod("+ sMethod + ") argument is not a URLRequestHeader value" ) ;	
		}
	}

	/**
	 * Sets the array of HTTP request headers to be appended to the HTTP request.
	 */
	public function setRequestHeaders(ar:Array):Void 
	{
		_aRequestHeaders = ar ;
	}

	/**
	 * Sets the URL to be requested.
	 */
	public function setUrl(sURL:String):Void 
	{
		_sURL = sURL ;	
	}

	/**
	 * Sets the code page value, if this value is {@code true} the request is encoded using the system code page, rather than Unicode.
	 */
	public function setUseCodePage(b:Boolean):Void 
	{
		_bUseCodePage = b ;
	}

	private var _aRequestHeaders:Array ;
	private var _bUseCodePage:Boolean ;	
	private var _oData ;
	private var _sContentType:String ;
	private var _sMethod:String ;
	private var _sURL:String ;
	
}