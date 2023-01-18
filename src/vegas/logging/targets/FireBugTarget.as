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

import vegas.logging.LogEventLevel;
import vegas.logging.targets.LineFormattedTarget;

/**
 * Provides a logger target that uses the FireBug console extension in Firefox to output log messages. 
 * You can download the FireBug and test this target : https://addons.mozilla.org/fr/firefox/addon/1843
 * @author eKameleon
 */
class vegas.logging.targets.FireBugTarget extends LineFormattedTarget 
{
	
	/**
	 * Creates a new FireBugTarget instance.
	 */
	public function FireBugTarget() 
	{
		super();
	}
	
	/**
     * Descendants of this class should override this method to direct the specified message to the desired output.
     * @param message String containing preprocessed log message which may include time, date, category, etc. based on property settings, such as <code>includeDate</code>, <code>includeCategory</code>, etc.
     * @param level the LogEventLevel of the message.
	 */
	/*override*/ public function internalLog( message , level:Number ):Void
	{
		
		var methodName:String ;
		
		switch (level)
		{
			
			case LogEventLevel.ERROR :
			{
				methodName = "console.error" ;
				break ;	
			}
			case LogEventLevel.FATAL :
			{
				methodName = "console.error" ;
				break ;	
			}
			case LogEventLevel.INFO :
			{
				methodName = "console.info" ;
				break ;	
			}
			case LogEventLevel.WARN :
			{
				methodName = "console.warn" ;
				break ;	
			}
			default :
			{
				methodName = "console.debug" ;
				break ;	
			}		
			
		}
		if ( flash.external.ExternalInterface.available )
		{
    		flash.external.ExternalInterface.call( methodName, [message] ) ;
		}
		else
		{
			getURL("javascript:" + methodName + "('"+ message +"');");	
		}
	}

}