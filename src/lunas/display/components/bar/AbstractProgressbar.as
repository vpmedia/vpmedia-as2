/*

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  
           http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is LunAS Library.
  
  The Initial Developer of the Original Code is
  ALCARAZ Marc (aka eKameleon)  <vegas@ekameleon.net>.
  Portions created by the Initial Developer are Copyright (C) 2004-2007
  the Initial Developer. All Rights Reserved.
  
  Contributor(s) :
  
*/

import asgard.display.Direction;

import lunas.display.components.AbstractComponent;
import lunas.display.components.IProgressbar;

import pegas.events.UIEventType;
import pegas.maths.Range;

/**
 * This abstract class is used to create progress bar.
 * @author eKameleon
 */
class lunas.display.components.bar.AbstractProgressbar extends AbstractComponent implements IProgressbar 
{

	/**
	 * Creates a new AbstractProgressbar instance. 
	 */
	private function AbstractProgressbar() 
	{
		_rPercent = Range.PERCENT_RANGE ;
		_nDirection = Direction.HORIZONTAL ;
	}

	/**
	 * The name of the event dispatched when the component change.
	 */
	static public var CHANGE:String = UIEventType.CHANGE ;
	
	/**
	 * This flag indicates of the position is auto reset. 
	 */
	public var autoResetPosition:Boolean = false ;

	/**
	 * Returns the direction value of this component.
	 * @return the direction value of this component.
	 * @see Direction
	 */
	public function get direction():Number 
	{
		return getDirection() ;
	}

	/**
	 * Sets the direction value of this component.
	 */
	public function set direction(n:Number):Void 
	{
		setDirection(n) ;	
	}

	public function get position():Number 
	{
		return getPosition() ;
	}
	
	public function set position(n:Number):Void 
	{
		setPosition(n) ;	
	}

	/**
	 * Returns the direction value of this component.
	 * @return the direction value of this component.
	 * @see Direction
	 */
	public function getDirection():Number 
	{ 
		return (_nDirection == Direction.HORIZONTAL) ? Direction.HORIZONTAL : Direction.VERTICAL ;
	}

	/**
	 * Returns the position value of this component.
	 * @return the position value of this component.
	 */
	public function getPosition():Number 
	{
		return isNaN(_position) ? 0 : _position ;
	}

	/**
	 * Sets the direction value of this component.
	 */
	public function setDirection(n:Number):Void 
	{
		_nDirection = (n == Direction.HORIZONTAL) ? Direction.HORIZONTAL : Direction.VERTICAL ;
		update() ;
	}

	/**
	 * Sets the position value of this component.
	 */
	public function setPosition(pos:Number, noEvent:Boolean, flag:Boolean):Void 
	{

		pos = _rPercent.clamp(pos) ;
		
		if (pos != _position) 
		{
			_position = pos ;
			
			viewPositionChanged(flag) ;
			
			if ( noEvent != true ) 
			{
				notifyChanged() ;
			}
			
		}
	}
	
	/**
	 * Invoqued when the view of the bar changed.
	 */
	public function viewChanged():Void 
	{
		
		var memPos:Number = getPosition() ;
		
		setPosition(0, true, true) ;
		
		if ( autoResetPosition == false ) 
		{
			setPosition( memPos, true, true) ;
		}
		
	}

	public function viewPositionChanged(flag:Boolean):Void 
	{
		// override this method
	}

	private var _nDirection:Number ;

	private var _position:Number = 0 ;

	private var _rPercent:Range ;
	
}