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

/* ------ StyleEvent

	AUTHOR
	
		Name : StyleEvent
		Package : neo.display.components
		Version : 1.0.0.0
		Date :  2006-01-04
		Author : ekameleon
		URL : http://www.ekameleon.net
		Mail : contact@ekameleon.net

	PROPERTY SUMMARY
	
		

	METHOD SUMMARY
	
		- getStyle():IStyle
	
----------------*/

import com.bourre.events.BasicEvent;

import neo.display.components.IStyle;
import neo.display.components.StyleEventType;

class neo.display.components.StyleEvent extends BasicEvent {

	// ----o Constructor 
	
	public function StyleEvent(e:StyleEventType, style:IStyle) {
		super(e) ;
		_style = style ;

	}
	

	// ----o Public Methods
	
	public function getStyle():IStyle {
		return _style ;

	}
	
	public function toString():String {
		return '[StyleEvent : ' + getType() + ', ' + getStyle() + ']';

	}
	
	// ----o Private Properties
	
	private var _style:IStyle ;
	
	
}