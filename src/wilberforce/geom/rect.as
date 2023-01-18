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
import wilberforce.math.mathUtil;

// Classes from pixlib
import com.bourre.transitions.TweenFPS;

/**
* Rectangle class. Provides a representation of a rectangle, allowing for collision with various geometry primitives, and to
* provide useful helper functions such as a random point within, intersection, etc
*/
class wilberforce.geom.rect implements wilberforce.geom.IShape2D
{
	
		
	public var left:Number;
	public var right:Number;
	public var top:Number;
	public var bottom:Number
	
	var _leftTween:TweenFPS
	var _topTween:TweenFPS
	var _rightTween:TweenFPS
	var _bottomTween:TweenFPS
	
	function rect(x1:Number,y1:Number,x2:Number,y2:Number)
	{
		// Flip if necessary
		left=Math.min(x1,x2);
		right=Math.max(x1,x2);
		top=Math.min(y1,y2);
		bottom=Math.max(y1,y2);
				
	}
	
	function clone():rect{
		return new rect(left,top,right,bottom);
	}
	/**
	* Allows creation of a rect from dimensions (width and height) rather than two points
	* @param	x		X position (top left)
	* @param	y		Y position (top left)
	* @param	tWidth	Width of rect
	* @param	tHeight	Height of rect
	* @return
	*/
	static function fromDimensions(x:Number,y:Number,tWidth:Number,tHeight:Number):rect
	{
		return new rect(x,y,x+tWidth,y+tHeight);
	}
	
	static function fromStage():rect
	{
		return new rect(0,0,Stage.width,Stage.height);
	}
	
	public function getMarginRect(marginWidth:Number,marginHeight:Number):rect
	{
		return new rect(left+marginWidth,top+marginHeight,right-left-marginWidth*3,bottom-top-marginHeight*3);
	}
	
	/**
	* Determines if a rect is entirely contained within this rect
	* @param	tRect
	* @return
	*/
	public function containsRect(tRect:rect):Boolean
	{
		if (left>tRect.left) return false
		if (right<tRect.right) return false
		if (top>tRect.top) return false
		if (bottom<tRect.bottom) return false
		
		return true;
	}
	
	public function containsPoint(x:Number,y:Number):Boolean
	{
		if (!mathUtil.between(left,right,x)) return false;
		if (!mathUtil.between(top,bottom,y)) return false;
		return true;
	}
	
	// Animate to a specific rect, with animation properties
	/*
		 * @param oT 	Object which the Tween targets.
	 * @param sP 	Setter (method or property).
	 * @param nE 	Ending value of property.
	 * @param nFps 	Length of time of the motion in frames.
	 * @param nS 	(optional) Starting value of property.
	 * @param fE 	(optional) Easing function.
	 * */
	public function animateToFPS(tRect:rect, nFrames:Number, easingFunction:Function,targetObject:Object,stepFunction:Function,endFunction:Function):Void
	{
		_leftTween.stop();delete _leftTween;
		_topTween.stop();delete _topTween;
		_rightTween.stop();delete _rightTween;
		_bottomTween.stop();delete _bottomTween;
		
		// Create a new tween. Only the last tween has a completion function
		_leftTween=new TweenFPS(this,"left",tRect.left,nFrames,left,easingFunction);
		_topTween=new TweenFPS(this,"top",tRect.top,nFrames,top,easingFunction);
		_rightTween=new TweenFPS(this,"right",tRect.right,nFrames,right,easingFunction);
		_bottomTween=new TweenFPS(this,"bottom",tRect.bottom,nFrames,bottom,easingFunction);
		// Add listeners to the final tween
		_bottomTween.addEventListener(TweenFPS.onMotionChangedEVENT,targetObject,stepFunction);
		_bottomTween.addEventListener(TweenFPS.onMotionFinishedEVENT,targetObject,endFunction);
		
		_leftTween.execute();
		_topTween.execute();
		_rightTween.execute();
		_bottomTween.execute();
	}
	
	public function getRectIntersection(tRect:rect)
	{
		
		var tLeft:Number = Math.max(left, tRect.left);
		var tTop:Number = Math.max(top, tRect.top);
		var tRight:Number = Math.min(right, tRect.right );
		var tBottom:Number = Math.min(bottom, tRect.bottom);
				
		if (tRight>tLeft && tBottom>tTop)
		{		
			return new rect(tLeft,tTop,tRight,tBottom);
		}
		else {
			return false;
		}
	}
	
	public function testCircleIntersection()
	{
		
	}
	
	public function get width():Number
	{
		return right-left;
	}
	public function set width(tWidth:Number):Void
	{
		if (tWidth<0) return;			
		right=left+tWidth;
	}
	
	public function get height():Number
	{
		return bottom-top;
	}
	public function set height(tHeight:Number):Void
	{
		if (tHeight<0) return;			
		bottom=top+tHeight;
	}
	
	public function get x():Number
	{
		return left;
	}
	function set x(tx:Number):Void
	{
		var tWidth=width;
		left=tx;
		right=left+tWidth;		
	}
	
	public function get y():Number
	{
		return top;
	}
	public function set y(ty:Number):Void
	{
		var tHeight=height;
		top=ty;
		bottom=top+tHeight;		
	}
	
	public function randomPointWithin():vector2D
	{
		return new vector2D(mathUtil.randNum(left,right),mathUtil.randNum(top,bottom));
	}
	
	public function pointIsWithin(point:vector2D):Boolean
	{		
		return false;
	}
	
}