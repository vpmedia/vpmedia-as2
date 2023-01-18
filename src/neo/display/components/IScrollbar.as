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

/* ---------- IScrollbar [Interface]

	AUTHOR
	
		Name : IScrollbar
		Package : neo.display.components
		Version : 1.0.0.0
		Date :  2006-02-13
		Author : ekameleon
		URL : http://www.ekameleon.net
		Mail : contact@ekameleon.net
	
	METHOD SUMMARY
	
		- dragging():Void
		
		- getBar():MovieClip
		
		- getDirection():Number
		
		- getPosition():Number
		
		- getThumb():MovieClip
		
		- setDirection(n:Number):Void
		
		- setPosition(pos:Number, noEvent:Boolean):Void
		
		- startDragging():Void
		
		- stopDragging():Void

	INHERIT
	
		IBar
		  |
		  IProgressbar
				|
				IScrollbar

----------  */

import neo.display.components.IProgressbar;

interface neo.display.components.IScrollbar extends IProgressbar {
	
	function dragging():Void ;
	
	function getBar():MovieClip ;
	
	// function getDirection():Number ;
	
	// function getPosition():Number ;

	function getThumb():MovieClip ;
	
	// function setDirection(n:Number):Void ;
	
	// function setPosition(pos:Number, noEvent:Boolean):Void ;
	
	function startDragging():Void ;
	
	function stopDragging():Void ;
	
}