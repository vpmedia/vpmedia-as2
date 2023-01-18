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
 * This tool class transform a {@code Canvas} object with static methods.
 * @author eKameleon
 * Thanks : Peter Hall <www.peterjoel.com> ASVDrawing Class v1.0
 */
class pegas.draw.CanvasTransform {

	
	/**
	 * Creates a free form effect over a {@code Canvas} object}.
	 * @return the method to be used to creates a free form effect over a {@code Canvas} object}.
	 */
	static public function createFreeform 
	(
		xMin:Number, yMin:Number, xMax:Number, yMax:Number,
		x0:Number, y0:Number, x1:Number, y1:Number, x2:Number, y2:Number, x3:Number, y3:Number ):Function  
	{
		var w:Number = xMax - xMin ;
		var h:Number = yMax - yMin;
		var w2_0:Number = x1 - x0 ;
		var w2_1:Number = x2 - x3 ;
		var h2_0:Number = y1 - y0 ;
		var h2_1:Number = y2 - y3 ;
		return function(x:Number, y:Number):Object{
			var gx:Number = ( x - xMin ) / w ;
			var gy:Number = ( y - yMin ) / h ;
			var bx:Number = x0 + gy * (x3-x0) ;
			var by:Number = y0 + gy * (y3-y0) ;
			return {x: bx + gx*((x1+gy*(x2-x1))-bx), y: by + gx*((y1+gy*(y2-y1))-by)};
		} ;
	}
	
	/**
	 * Creates a pinch effect over a {@code Canvas} object}.
	 * @return the method to be used to creates a pinch effect over a {@code Canvas} object}.
	 */
	static public function createPinch(xMin:Number, yMin:Number, xMax:Number, yMax:Number, xAmount:Number, yAmount:Number):Function 
	{
		var w:Number = xMax - xMin ;
		var h:Number = yMax - yMin ;
		var h2:Number = h / 2 ;
		var w2:Number = w / 2 ;
		var ax:Number = xAmount * w / 200 ;
		var ay:Number = yAmount * h / 200 ;
		return function(x:Number,y:Number):Object 
		{
			var newX:Number ;
			var newY:Number ;
			if(x<xMin || x>xMax || y<yMin || y>yMax) return {x:x,y:y};
			if(!isNaN(xAmount)) {
				var y2:Number = (y-yMin)/h2-1;
				var gx:Number = (1-y2*y2)*ax;
				newX = xMin+gx+(x-xMin)*(w-2*gx)/w;
			} else {
				newX = x;
			}
			if(!isNaN(yAmount)) {
				var x2:Number = (x-xMin)/w2-1;
				var gy:Number = (1-x2*x2)*ay;
				newY = yMin+gy+(y-yMin)*(h-2*gy)/h;
			} else {
				newY = y;
			}
			return { x : newX ,  y : newY } ;
		} ;
	}

	/**
	 * Creates a waves effect over a {@code Canvas} object}.
	 * @return the method to be used to creates a waves effect over a {@code Canvas} object}.
	 */
	static public function createWaves
	( 
		xMin:Number, yMin:Number, xMax:Number, yMax:Number,
		xAmount:Number, yAmount:Number, xCount:Number, yCount:Number, xOffset:Number, yOffset:Number):Function 
	{
		var w:Number = xMax-xMin;
		var h:Number = yMax-yMin;
		var jx:Number = Math.PI*xCount/h;
		var jy:Number = Math.PI*yCount/w;
		xOffset = xOffset*Math.PI/180;
		yOffset = yOffset*Math.PI/180;
		return function(x:Number,y:Number):Object 
		{
			if(x<xMin || x>xMax || y<yMin || y>yMax) return {x:x,y:y};
			var newX:Number = xAmount ? x+xAmount*Math.sin(jx*y+xOffset) : x;
			var newY:Number = yAmount ? y+yAmount*Math.sin(jy*x+yOffset) : y;
			return {x:newX, y:newY};
		} ;
	}

	/**
	 * Creates a Whirl effect over a {@code Canvas} object}.
	 * @return the method to be used to creates a Whirl effect over a {@code Canvas} object}.
	 */
	static public function createWhirl(centreX:Number, centreY:Number, radius:Number, amount:Number):Function 
	{
		var radius2:Number = radius * radius ;
		var rotate:Number = amount*Math.PI/180 ;
		return function (x:Number,y:Number):Object 
		{
			var x2:Number = x - centreX ;
			var y2:Number = y - centreY ;
			var r2:Number = x2*x2 + y2*y2 ;
			if(r2>radius2) return {x:x,y:y} ;
			var th:Number = Math.cos(Math.PI/2 + Math.PI*Math.sqrt(r2)/radius)*rotate ;
			var cosTh:Number = Math.cos(th);
			var sinTh:Number = Math.sin(th);
			return {x:x2*cosTh+y2*sinTh+centreX, y:y2*cosTh-x2*sinTh+centreY} ;
		} ;
	}
	
	/**
	 * Returns the string representation of this singleton.
	 * @return the string representation of this singleton.
	 */
	static public function toString():String 
	{
		return "[CanvasTransform]" ;
	}

}