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

import lunas.display.components.bar.AbstractProgressbar;
import lunas.display.components.shape.RectangleComponent;

/**
 * The EasyProgressbar component.
 * @author eKameleon
 */
class lunas.display.components.bar.EasyProgressbar extends AbstractProgressbar 
{

	/**
	 * Creates a new EasyProgressbar instance.
	 */
	public function EasyProgressbar() 
	{
		super() ;
		createChild(BACKGROUND_RENDERER, "background", 0) ;
		createChild(BAR_RENDERER, "bar", 1) ;
		setSize(150, 6) ;
	}

	static public var BACKGROUND_RENDERER:Function = RectangleComponent ;

	static public var BAR_RENDERER:Function = RectangleComponent ;
	
	/**
	 * The background reference of this bar
	 */
	public var background:MovieClip ;

	/**
	 * The thumb reference of this bar.
	 */
	public var bar:MovieClip ;

	/**
	 * The border thickness of this bar.
	 */
	public var border:Number = 0 ;

	/**
	 * Resize the bar.
	 */
	public function resize():Void 
	{
		bar._x = border ;
		bar._y = border ;
		var nB:Number = 2 * border ;
		var nD:Number = getDirection() ;
		var max:Number = (nD == Direction.VERTICAL) ? getH() : getW() ;
		var size:Number =  Math.floor(getPosition() * (max - nB) / 100) ;
		var __w:Number = (nD == Direction.VERTICAL) ? (_w-nB) : size  ;
		var __h:Number = (nD == Direction.VERTICAL) ? size : (_h - nB) ;
		bar.setSize(__w, __h) ;
	}

	/**
	 * Invoqued when the component is changed.
	 */
	public function viewChanged():Void 
	{
		
		background.refresh( 
		{
			t : 1 , la : 100 , lc : 0xFFFFFF ,
			fc : 0xD0330D , fa : 100
		} ) ;
		background.setSize(_w, _h) ;
		
		bar.refresh( {
			t : null , la : null , lc : null ,
			fc : 0xF8E2B1 , fa : 100
		} ) ;
		resize() ;
		
	}
	
	/**
	 * Invoqued when the position of the bar is changed.
	 */
	public function viewPositionChanged():Void 
	{
		resize() ;
	}

}