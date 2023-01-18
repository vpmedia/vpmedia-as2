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

/* ------- 	AbstractProgressbar

	AUTHOR
	
		Name : AbstractProgressbar
		Package : neo.display.components.bar
		Version : 1.0.0.0
		Date :  2006-02-10
		Author : ekameleon
		URL : http://www.ekameleon.net
		Mail : contact@ekameleon.net

	PROPERTY SUMMARY
	
		- direction:Number [R/W]
		
		- position:Number [R/W]
	
	METHOD SUMMARY
		
		- getDirection():Number
		
		- getPosition():Number
		
		- setDirection(n:Number):Void
		
		- setPosition(pos:Number, noEvent:Boolean):Void
		
	EVENT TYPE SUMMARY
	
		- CHANGE:EventType
	
----------  */

import com.bourre.events.EventType;

import neo.display.components.AbstractComponent;
import neo.display.components.IProgressbar;
import neo.display.Direction;
import neo.events.UIEventType;
import neo.maths.Range;
import neo.util.factory.PropertyFactory;

class neo.display.components.bar.AbstractProgressbar extends AbstractComponent implements IProgressbar {

	// ----o Constructor
	
	private function AbstractProgressbar() {
		_rPercent = Range.PERCENT_RANGE ;
	}

	// ----o Constant
	
	static public var CHANGE:EventType = UIEventType.CHANGE ;
	
	static private var __ASPF__ = _global.ASSetPropFlags(AbstractProgressbar, null, 7, 7) ;
	
	// ----o Public Properties
	
	public var direction:Number ; // [R/W]
	public var position:Number ; // [R/W]
	
	// ----o Public Methods		

	public function getDirection():Number { 
		return (_nDirection == Direction.HORIZONTAL) ? Direction.HORIZONTAL : Direction.VERTICAL ;
	}
	
	public function getPosition():Number {
		return isNaN(_position) ? 0 : _position ;
	}

	public function setDirection(n:Number):Void {
		_nDirection = (n == Direction.HORIZONTAL) ? Direction.HORIZONTAL : Direction.VERTICAL ;
		update() ;
	}

	public function setPosition(pos:Number, noEvent:Boolean):Void {
		pos = _rPercent.clamp(pos) ;
		if (pos != _position) {
			_position = pos ;
			viewPositionChanged() ;
			if (!noEvent) notifyChanged() ;
		}
	}
	
	public function viewChanged():Void {
		setPosition(0, true) ;
	}

	public function viewPositionChanged():Void {
		// override this method
	}

	// ----o Virtual Properties

	static private var __DIRECTION__:Boolean = PropertyFactory.create(AbstractProgressbar, "direction", true) ;
	static private var __POSITION__:Boolean = PropertyFactory.create(AbstractProgressbar, "position", true) ;

	// ----o Private Properties

	private var _nDirection:Number = Direction.HORIZONTAL ; 
	private var _position:Number = 0 ;
	private var _rPercent:Range ;
	
}