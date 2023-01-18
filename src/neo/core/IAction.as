/*

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  
           http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is Neo Library.
  
  The Initial Developer of the Original Code is
  ALCARAZ Marc (aka eKameleon)  <contact@ekameleon.net>.
  Portions created by the Initial Developer are Copyright (C) 2004-2005
  the Initial Developer. All Rights Reserved.
  
  Contributor(s) :
  
*/

/* ---------- IAction [interface]

	AUTHOR
	
		Name : IAction
		Package : neo.core
		Version : 1.0.0.0
		Date :  2006-02-08
		Author : ekameleon
		URL : http://www.ekameleon.net
		Mail : contact@ekameleon.net
	
	METHOD SUMMARY
	
		- addEventListener(e:EventType, oL, f:Function):Void
		
		- addListener (oL, f:Function):Void ;
		
		- clone()
		
		- execute(e:IEvent)
		
		- notifyFinished():Void 
		
		- notifyStarted():Void
		
		- removeEventListener(e:EventType, oL):Void ;
	
		- removeListener(oL):Void ;

	INHERIT
	
		Command

----------  */

import com.bourre.commands.Command;

interface neo.core.IAction extends Command {
	
	function notifyFinished():Void ;
	
	function notifyStarted():Void ;
	
}