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

/**
 * @author eKameleon
 */
class pegas.events.ActionEventType 
{

	static public var CHANGE:String = "onChanged" ;
	
	static public var CLEAR:String = "onCleared" ;
	
	static public var FINISH:String = "onFinished" ;
	
	static public var INFO:String = "onInfo" ;
	
	static public var LOOP:String = "onLooped" ;
	
	static public var PROGRESS:String = "onProgress" ;
	
	static public var RESUME:String = "onResumed" ;
	
	static public var START:String = "onStarted" ;
	
	static public var STOP:String = "onStopped" ;	

	static public var TIMEOUT:String = "onTimeOut" ;

	static private var __ASPF__ = _global.ASSetPropFlags(ActionEventType, null , 7, 7) ;
	
}
