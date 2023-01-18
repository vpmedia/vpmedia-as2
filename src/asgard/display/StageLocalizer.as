/*

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  
           http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is ASGard Framework.
  
  The Initial Developer of the Original Code is
  ALCARAZ Marc (aka eKameleon)  <vegas@ekameleon.net>.
  Portions created by the Initial Developer are Copyright (C) 2004-2007
  the Initial Developer. All Rights Reserved.
  
  Contributor(s) :
  
*/

import asgard.display.StageAlign;

import pegas.geom.Point;

/**
 * This static tool class defined the position of a point in the stage or in a specific display. This value change with the current Stage.align property.
 * @author eKameleon
 */
class asgard.display.StageLocalizer 
{
	
	/**
	 * The default value of the Stage.width when the FlashPlayer is open.
	 */
	static public var WIDTH = Stage.width ;

	/**
	 * The default value of the Stage.height when the FlashPlayer is open.
	 */
	static public var HEIGHT = Stage.height ;

	/**
	 * Localize the position of a specified point on the Stage with the current Stage.align property.
	 * @return the string representation of the StageAlign defined for the point passed in argument.
	 */
	static public function localizePoint(p):String 
	{
		var middle:Point = getMiddle() ;
		var x1:Number = p.x ;
		var y1:Number = p.y ;
		var x2:Number = middle.x ;
		var y2:Number = middle.y ;
		if (x1 > x2 && y1 > y2) 
		{
			return StageAlign.BOTTOM_RIGHT ;
		}
		else if (x1 < x2 && y1 > y2 ) 
		{
			return StageAlign.BOTTOM_LEFT ;
		}
		else if (x1 > x2 && y1 < y2) 
		{
			return StageAlign.TOP_RIGHT ;
		}
		else if (x1 < x2 && y1 < y2 ) 
		{
			return StageAlign.TOP_LEFT ;
		}
		else if (x1 == x2 && y1 > y2) 
		{
			return StageAlign.BOTTOM ;
		}
		else if (x1 == x2 && y1 < y2 ) 
		{
			return StageAlign.TOP ;
		}
		else if (x1 < x2 && y1 == y2 ) 
		{
			return StageAlign.LEFT ;
		}
		else if (x1 > x2 && y1 == y2 ) 
		{
			return StageAlign.RIGHT ;
		}
		else 
		{
			return StageAlign.CENTER ;
		}
	}

	/**
	 * Returns the Point representation of the middle of the Stage. This property is defined with the current Stage.align value.
	 * @return the Point representation of the middle of the Stage. This property is defined with the current Stage.align value.
	 */
	static public function getMiddle():Point 
	{
		var middle:Point = new Point(0, 0) ;
		switch (Stage.align) 
		{
			case StageAlign.BOTTOM : // bottom
			{
				middle.x = WIDTH / 2 ;
				middle.y = -  ((Stage.height / 2) - HEIGHT)  ;
				break ;
			}
			case StageAlign.BOTTOM_LEFT : // bottom left
			{
				middle.x = Stage.width / 2 ;
				middle.y = -  ((Stage.height / 2) - HEIGHT)  ;
				break ;
			}
			case StageAlign.BOTTOM_RIGHT : // bottom right
			{
				middle.x =  - (Stage.width - WIDTH) + Stage.width  / 2   ;
				middle.y = -  ((Stage.height / 2) - HEIGHT)  ;
				break ;
			}
			case StageAlign.LEFT : // left
			{
				middle.x = Stage.width / 2 ;
				middle.y = HEIGHT / 2  ;
				break ;
			}
			case StageAlign.RIGHT : // right
			{
				middle.x =  - (Stage.width - WIDTH) + Stage.width  / 2   ;
				middle.y = HEIGHT / 2  ;
				break ;
			}
			case StageAlign.TOP : // top
			{
				middle.x = WIDTH / 2 ;
				middle.y = Stage.height / 2 ;
				break ;
			}
			case StageAlign.TOP_LEFT : // top left
			{
				middle.x = Stage.width / 2 ;
				middle.y = Stage.height / 2 ;
				break ;
			}
			case StageAlign.TOP_RIGHT : // top right
			{
				middle.x =  - (Stage.width - WIDTH) + Stage.width  / 2   ;
				middle.y = Stage.height / 2 ;
				break ;
			}
			default :
			{ 
				middle.x = WIDTH / 2 ;
				middle.y = HEIGHT / 2 ;
			}
		}
		
		return middle ;
	}
	
	/**
	 * Returns the mirror StageAlign string representation of the string passed in argument. 
	 * @return the mirror StageAlign string representation of the string passed in argument.
	 */
	static public function getMirror(align:String):String 
	{
		switch (align.toUpperCase()) 
		{
			case StageAlign.TOP : return StageAlign.BOTTOM ;
			case StageAlign.BOTTOM : return StageAlign.TOP ;
			case StageAlign.TOP_RIGHT : return StageAlign.BOTTOM_LEFT ;
			case StageAlign.TOP_LEFT : return StageAlign.BOTTOM_RIGHT ;
			case StageAlign.BOTTOM_RIGHT : return StageAlign.TOP_LEFT ;
			case StageAlign.BOTTOM_LEFT : return StageAlign.TOP_RIGHT ;
			case StageAlign.LEFT : return StageAlign.RIGHT ;
			case StageAlign.RIGHT : return StageAlign.LEFT ;
			default : return StageAlign.CENTER ;
		}
	}

	/**
	 * Returns a vertical mirror StageAlign string representation of the string passed in argument. 
	 * @return a vertical StageAlign string representation of the string passed in argument.
	 */
	static public function getVerticalMirror(point):String 
	{
		var align:String = localizePoint(point) ;
		switch (align.toUpperCase () ) 
		{
			case StageAlign.TOP_RIGHT : return StageAlign.BOTTOM_RIGHT ;
			case StageAlign.TOP_LEFT : return StageAlign.BOTTOM_LEFT ;
			case StageAlign.BOTTOM_RIGHT : return StageAlign.TOP_RIGHT ;
			case StageAlign.BOTTOM_LEFT : return StageAlign.TOP_LEFT ;
			case StageAlign.LEFT : return StageAlign.RIGHT ;
			case StageAlign.RIGHT : return StageAlign.LEFT ;
			default : return StageAlign.CENTER ;
		}
	}

}