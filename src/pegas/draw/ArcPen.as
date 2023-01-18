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

import pegas.draw.Align;
import pegas.draw.ArcType;
import pegas.draw.EasyPen;
import pegas.geom.Trigo;

/**
 * This pen draw a pie or chord arc shape in a MovieClip reference.
 * @author eKameleon
 */
class pegas.draw.ArcPen extends EasyPen 
{

	/**
	 * Creates a new ArcPen instance.
	 * @param target the movieclip reference.
	 * @param isNew if this flag is {@code true} the draw is localize in a new movieclip in the specified {@code target}.
	 */
	public function ArcPen(target:MovieClip, isNew:Boolean) 
	{
		initialize(target, isNew) ;
		setAlign(Align.TOP_LEFT) ;
	}

	/**
	 * (read-write) Returns the value of the angle used to draw an arc shape in the movieclip reference.
	 * @return the value of the angle used to draw an arc shape in the movieclip reference.
	 */
	public function get angle():Number 
	{
		return getAngle() ;	
	}
	
	/**
	 * (read-write) Sets the value of the angle used to draw an arc shape in the movieclip reference.
	 */
	public function set angle(n:Number):Void 
	{
		setAngle(n) ;	
	}

	/**
	 * Defines the radius value of the arc shape.
	 */
	public var radius:Number = 100;

	/**
	 * Defines the type of the arc, can be a chord or a pie arc.
	 */
	public var type:String = ArcType.CHORD ; // CHORD || PIE

	/**
	 * Defines the x origin position of the arc shape.
	 */
	public var x:Number = 0 ;

	/**
	 * Defines the y origin position of the arc shape.
	 */
	public var y:Number = 0 ;

	/**
	 * Defines the y origin position of the arc radius.
	 */
	public var yRadius:Number ;

	/**
	 * (read-write) Returns the value of the start angle to draw the arc in the movieclip reference.
	 * @return the value of the start angle to draw the arc in the movieclip reference.
	 */
	public function get startAngle():Number 
	{
		return getStartAngle() ;	
	}
	
	/**
	 * (read-write) Sets the value of the start angle to draw the arc in the movieclip reference.
	 */
	public function set startAngle(n:Number):Void 
	{
		setStartAngle(n) ;	
	}

	/**
	 * Returns a shallow copy of this object.
	 * @return a shallow copy of this object.
	 */
	public function clone() 
	{
		var arc:ArcPen = new ArcPen(_target) ;
		arc.radius = radius ;
		arc.x = x ;
		arc.y = y ;
		arc.yRadius = yRadius ;
		arc.type = ArcType.CHORD ;
		arc.setAlign(_align, true) ;
		arc.setAngle(_angle, true) ;
		arc.setStartAngle(_startAngle, true) ;
		return arc ;
	}

	/**
	 * Draws the shape in the movieclip reference of this pen.
	 */
	public function draw(p_angle:Number, p_startAngle:Number, p_x:Number, p_y:Number, p_align:Number):Void 
	{
		if (arguments.length > 0) 
		{
			setArc.apply(this, arguments) ;
		}
		init() ;
		moveTo(_nX, _nY);
		var ax:Number ;
		var ay:Number ;
		var bx:Number ;
		var by:Number ;
		var cx:Number ;
		var cy:Number ;
		var angleMid:Number ;
		var nR:Number = isNaN(yRadius) ? radius : yRadius ;
		var segs:Number = Math.ceil ( Math.abs(_angle) / 45 ) ;
		var segAngle:Number = _angle / segs ;
		var theta:Number = - Trigo.degreesToRadians(segAngle) ;
		var a:Number = - _startAngle  ;
		if (segs>0) 
		{
			ax = _nX + Math.cos (_startAngle) * radius ;
			ay = _nY + Math.sin (-_startAngle) * nR ;
			if (_angle < 360 && _angle > -360 && type == ArcType.PIE) lineTo (ax, ay) ;
			moveTo (ax, ay) ;
			for (var i:Number = 0 ; i<segs ; i++) 
			{
				a += theta ;
				angleMid = a - ( theta / 2 ) ;
				bx = _nX + Math.cos ( a ) * radius ;
				by = _nY + Math.sin ( a ) * nR ;
				cx = _nX + Math.cos( angleMid ) * ( radius / Math.cos ( theta / 2 ) ) ;
				cy = _nY + Math.sin( angleMid ) * ( nR / Math.cos( theta / 2 ) ) ;
				curveTo(cx, cy, bx, by) ;
			}
			if(type == ArcType.PIE) 
			{
				if (_angle < 360 && _angle > -360) lineTo(_nX, _nY);
			}
			else 
			{ 
				lineTo(ax, ay); // CHORD or other value
			}
		}
		if (isEndFill) endFill() ;	
	}

	/**
	 * Returns the value of the angle used to draw an arc shape in the movieclip reference.
	 * @return the value of the angle used to draw an arc shape in the movieclip reference.
	 */
	public function getAngle():Number 
	{ 
		return _angle ;
	}
	
	public function getStartAngle():Number 
	{ 
		return Trigo.radiansToDegrees(_startAngle)  ;
	}

	/**
	 * Initialize the pen.
	 */
	public function init():Void 
	{
		if (isNaN(x)) x = 0 ;
		if (isNaN(y)) y = 0 ;
		_nX = x ; 
		_nY = y ;
		var nR:Number = (isNaN(yRadius)) ? radius : yRadius ;
		switch (_align) {
			case Align.TOP : // Top
				_nY += nR ;
				break ;
			case Align.BOTTOM : // Bottom
				_nY -= nR ;
				break ;
			case Align.LEFT : // Left
				_nX += radius ;
				break ;
			case Align.RIGHT : // Right
				_nX -= radius ;
				break ;
			case Align.TOP_LEFT : // Top Left
				_nX += radius ;
				_nY = nR ;
				break ;
			case Align.TOP_RIGHT : // Top Right
				_nX -= radius ;
				_nY = nR ;
				break ;
			case Align.BOTTOM_LEFT : // Bottom Left
				_nX += radius ;
				_nY -=  nR ;
				break ;
			case Align.BOTTOM_RIGHT : // Bottom Right
				_nX -= radius ;
				_nY -= nR ;
				break ;
			default : // Center
				break ;
		}
	}

	/**
	 * Sets the value of the angle used to draw an arc shape in the movieclip reference.
	 */
	public function setAngle(n:Number):Void 
	{
		_angle = Trigo.fixAngle(n) ;
	}

	/**
	 * Sets the arc options to defined all values to draw the arc shape in the movieclip reference of this pen.
	 */
	public function setArc(p_angle:Number, p_startAngle:Number, p_x:Number, p_y:Number, p_align:Number):Void 
	{
		if (!isNaN(p_angle) ) setAngle(p_angle) ;
		if (!isNaN(p_startAngle) ) setStartAngle(p_startAngle) ;
		if (!isNaN(p_align)) setAlign(p_align) ;
		x = (isNaN(p_x)) ? 0 : p_x ;
		y = (isNaN(p_y)) ? 0 : p_y ;
	}

	/**
	 * Sets the value of the start angle to draw the arc in the movieclip reference.
	 */
	public function setStartAngle(n:Number):Void 
	{
		_startAngle = Trigo.degreesToRadians(n) ;
	}

	private var _angle:Number = 0 ;
	
	private var _angleMid:Number ;
	
	private var _nX:Number ;
	
	private var _nY:Number ;
	
	private var _startAngle:Number = 360 ;
	
}