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
import wilberforce.geom.vector2D;

/**
* 2D Line class. Useful for collision detection in a variety of circumstances
*/
class wilberforce.geom.line2D
{
	var p1:vector2D;
	var p2:vector2D;
	
	function line2D(x1:Number,y1:Number,x2:Number,y2:Number)
	{
		p1=new vector2D(x1,y1);
		p2=new vector2D(x2,y2);		
	}
	
	//origin represents the first point of the second line
	// raygradeitn is the gradient of the second line
	// platform represents this line
	public function getLine2Dintersection(tline:line2D)
	{
		
		var gradient1=gradient;
		var gradient2=tline.gradient;
							
		// If lines are parallel, no intersection
		if (gradient1==gradient2) return false;
		
		var a1:Number=p1.y-gradient1*p1.x;       
		var a2:Number=tline.p1.y-gradient2*tline.p1.x;
		
		var xIntersection:Number =  (a1 - a2) / (gradient2 - gradient1) ;
		var yIntersection:Number = a1 + gradient1*xIntersection;
		
		// Is it within the bounds of each line
		if (xIntersection<Math.min(p1.x,p2.x) || xIntersection>Math.max(p1.x,p2.x)) return false;
		if (xIntersection<Math.min(tline.p1.x,tline.p2.x) || xIntersection>Math.max(tline.p1.x,tline.p2.x)) return false;		
		
		// Valid intersection
		return new vector2D(xIntersection,yIntersection);
	}
	
	public function get gradient():Number
	{
		var dx:Number=p2.x-p1.x;
		var dy:Number=p2.y-p1.y;

		// The gradient is infinite. Return insanely large instead of bad number
		if (dx==0) return 1000000000;
		
		return dy/dx;
	}
	
}