/*
 * Copyright the original author or authors.
 * 
 * Licensed under the MOZILLA PUBLIC LICENSE, Version 1.1 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *      http://www.mozilla.org/MPL/MPL-1.1.html
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
 
  
/**
 * @author Simon Oliver
 * @version 1.0
 */
 
// Classes from wilberforce
import wilberforce.geom.rect;
import wilberforce.geom.line2D;
import wilberforce.geom.vector2D;

/**
* Circle class. Provides a representation of a circle, allowing for collision with various geometry primitives, and to
* provide useful helper functions such as a random point within. 
* TODO - Tidy up and better documentation
*/
class wilberforce.geom.circle implements wilberforce.geom.IShape2D
{
	var pos:vector2D;
	var radius:Number;
	
	function circle(tx:Number,ty:Number,tradius:Number)
	{
		pos=new vector2D(tx,ty);
		radius=tradius;
	}
	
	function testCircleIntersection(tcircle:circle)
	{
		var dx:Number=tcircle.pos.x-pos.x;
		var dy:Number=tcircle.pos.y-pos.y;
		
		var distance=Math.sqrt(dx*dx+dy*dy);
		
		var totalRadius=radius+tcircle.radius;
		if (distance<totalRadius) return true;
		return false;
	}
	
	function testLine2DIntersection(tline:line2D)
	{
		
	}
	
	/**
	* Finds the solutions for a given value of Y
	* 
	* @param	tCircle The Circle
	* @param	yValue
	* @return
	*/
	function solveForY(yValue:Number):Array
	{
		
		if (yValue<pos.y-radius) return [];
		if (yValue>pos.y+radius) return [];
				
		//(x-a)squared+(y-b)squared=r squared
		//(ix-tCircle.pos.x)squared+(yValue-tCircle.pos.y)squared=tCircle.radius*tCircle.radius;		
		//(ix-tCircle.pos.x)squared=tCircle.radius*tCircle.radius-(yValue-tCircle.pos.y)*(yValue-tCircle.pos.y);
		
		var tSolution=Math.sqrt(radius*radius-(yValue-pos.y)*(yValue-pos.y));
		//trace("SOlution is "+tSolution);
		return [pos.x-tSolution,pos.x+tSolution];	
	}
	
	function get x():Number
	{
		return pos.x;
	}
	function set x(tx:Number):Void
	{
		pos.x=tx;	
	}
	
	function get y():Number
	{
		return pos.y;
	}
	function set y(ty:Number):Void
	{
		pos.y=ty;		
	}
		
	public function randomPointWithin():vector2D
	{
		var tDistanceFromCenter:Number=radius*Math.random();
		var tAngle=Math.PI*2*Math.random();
		return new vector2D(tDistanceFromCenter*Math.cos(tAngle),tDistanceFromCenter*Math.sin(tAngle));
	}
	public function pointIsWithin(point:vector2D):Boolean
	{
		// Distance to centre
		var distance=point.distanceTo(pos);
		return (distance<radius);
	}
	
	function getRectIntersection(tRect:rect):rect
	{
		// If it encompasses the whole circle return the value of the circle
		if (tRect.left<(x-radius) && tRect.right>(x+radius) && tRect.top<(y-radius) && tRect.bottom>(y+radius))
		{
			return new rect(x-radius,y-radius,x+radius,y+radius);
		}
		
		// Actually relatively simple
		var tIntersection1:Array=solveForY(tRect.top);
		var tIntersection2:Array=solveForY(tRect.bottom);
		
		
		
		
		if (tIntersection1.length==0 && tIntersection2.length==0) return null;
		
		var tIntersectionToUse=tIntersection1;
		
//		var dy1:Number=pos.y-tRect.top;
//		var dy2:Number=pos.y-tRect.bottom;
		
		// If bottom half of the circle
		if (tRect.bottom<pos.y) tIntersectionToUse=tIntersection2;
		
		if (tIntersection1.length==0) tIntersectionToUse=tIntersection2;
		
		
		
		
		//if (tIntersection2.length==0) return null;
		
		if (tIntersectionToUse[0]>tRect.right) return null;
		if (tIntersectionToUse[1]<tRect.left) return null;
		
		// Only concentrating on single intersection for now
		var left:Number=Math.max(tRect.left,tIntersectionToUse[0]);
		var right:Number=Math.min(tRect.right,tIntersectionToUse[1]);
		
		//trace("Intersection test "+left+" "+right+" from "+tRect.left+","+tRect.right);
		
		return new rect(left,tRect.top,right,tRect.bottom);
	}
	
	function testBoundsIntersection(tRect:rect):Boolean
	{
		return false;
	}
	
	
}