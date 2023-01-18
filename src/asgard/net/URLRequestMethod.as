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

/**
 * The URLRequestMethod class provides values that specify whether the URLRequest object should use the {@code POST} method or the {@code GET} method when sending data to a server.
 * @author eKameleon
 */
class asgard.net.URLRequestMethod 
{
	
	/**
	 * Specifies that the URLRequest object is a GET.
	 */
	static public var GET:String = "GET" ;
	
	/**
	 * Specifies that the URLRequest object is a POST.
	 */
	static public var POST:String = "POST" ;
	
	static private var __ASPF__ = _global.ASSetPropFlags(URLRequestMethod, null , 7, 7) ;
	
	/**
	 * Returns {@code true} if the String value passed-in argument is a valid method.
	 * @return {@code true} if the String value passed-in argument is a valid method.
	 */
	static public function validate(sMethod:String):Boolean 
	{
		return (sMethod == URLRequestMethod.GET) || (sMethod == URLRequestMethod.POST) ;
	}
	
}