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
import wilberforce.geom.circle;
import wilberforce.util.drawing.styles.*;
import wilberforce.util.drawing.drawingUtility;
import wilberforce.util.movieclip.MovieClipUtil;
import wilberforce.ui.canvas.AbstractTransformableObject;


// Classes From PixLib
import com.bourre.events.EventType;
import com.bourre.events.BasicEvent;
import com.bourre.commands.Delegate;
import com.bourre.events.EventBroadcaster;

/**
* Draggable circle class. Part of a collection of "canvas" classes that allow objects to be placed and manipulated.
* In this case, its set up to allow movement and manipulation of its radius
*/
class wilberforce.ui.canvas.transformableCircle extends AbstractTransformableObject
{
		
	private var _shape:circle;
	private var _boundingRect:rect;
	
	private var _modifyingRadius:Boolean;
	static  var _radiusManipulatorCircle:circle=new circle(0,0,6);
	
	function transformableCircle(movieClip:MovieClip,tCircle:circle,canMove:Boolean,canScale:Boolean,fillStyleOver:fillStyleFormat,fillStyleOff:fillStyleFormat,lineStyleOver:lineStyleFormat,lineStyleOff:lineStyleFormat)
	{
		// Circle can only scale uniformly
		super(movieClip,canMove,canScale,true,fillStyleOver,fillStyleOff,lineStyleOver,lineStyleOff);
		
		_shape=tCircle;
		
		redraw(false);
		
		_scaleRatio=1;
		
		_modifyingRadius=false;
		
		_boundingRect=new rect(_shape.x-_shape.radius,_shape.y-_shape.radius,_shape.x+_shape.radius,_shape.y+_shape.radius);
		//updateScaleBoxes(_boundingRect);
		
		//var tScaleBoxMovieClip:MovieClip=MovieClipUtil.createEmptyClip(_containerClip);
		//drawingUtility.drawRect(tScaleBoxMovieClip,_scaleBoxRect,_scaleBoxLineStyle,_scaleBoxFillStyle);
		//drawingUtility.drawCircle(tScaleBoxMovieClip,_radiusManipulatorCircle,_scaleBoxLineStyle,_scaleBoxFillStyle);
		
		createRadiusManipulator();
		
		if (_canScale) _manipulatorFunctions.push(Delegate.create(this,updateRadius));
		showManipulators(false);
	}
	
	public function createRadiusManipulator():Void
	{
		var tManipulatorMovieClip:MovieClip=MovieClipUtil.createEmptyClip(_containerClip);
		//drawingUtility.drawRect(tManipulatorMovieClip,_scaleBoxRect,_scaleBoxLineStyle,_scaleBoxFillStyle);
		drawingUtility.drawCircle(tManipulatorMovieClip,_radiusManipulatorCircle,_scaleBoxLineStyle,_scaleBoxFillStyle);
		
		tManipulatorMovieClip.onPress=Delegate.create(this,startModifyRadius);
		tManipulatorMovieClip.onReleaseOutside=tManipulatorMovieClip.onRelease=Delegate.create(this,endModifyRadius);
		//Delegate.create(this,endScale);
		
		tManipulatorMovieClip._x=_shape.x+_shape.radius;
		tManipulatorMovieClip._y=_shape.y;
				
		_manipulators.push(tManipulatorMovieClip);
	}
	
	public function testRectIntersect(tRect:rect)
	{
		return _shape.getRectIntersection(tRect);
		//return false;
	}
	
	public function startModifyRadius():Void
	{
		_modifyingRadius=true;
	}
	
	public function endModifyRadius():Void
	{
		_modifyingRadius=false;
		dispatchNewDimensionsEvent(true);
	}
	
	public function updateRadius(xDiff:Number,yDiff:Number,xAbs:Number,yAbs:Number)
	{
		
		if (_modifyingRadius) 
		{
			_manipulators[0]._x+=xDiff;
			_manipulators[0]._y+=yDiff;
		
			var dx=_manipulators[0]._x-_shape.x;
			var dy=_manipulators[0]._y-_shape.y;
			
			var tRadius=Math.sqrt(dx*dx+dy*dy);
			_shape.radius=tRadius;
			redraw(true);
		}
	}
	
	public function redraw(rolledOver:Boolean)
	{
		_renderClip.clear();
		if (rolledOver) drawingUtility.drawCircle(_renderClip,_shape,_lineStyleOver,_fillStyleOver);
		else drawingUtility.drawCircle(_renderClip,_shape,_lineStyleOff,_fillStyleOff);
		
		_boundingRect.x=_shape.x-_shape.radius;
		_boundingRect.y=_shape.y-_shape.radius;
		_boundingRect.width=_shape.radius*2;
		_boundingRect.height=_shape.radius*2;
		
	}
	
	function updatePosition(xDiff:Number,yDiff:Number)
	{
		_shape.x=_shape.x+xDiff;
		_shape.y=_shape.y+yDiff;
			
		redraw(true);
			
		//updateScaleBoxes(_boundingRect);
		_manipulators[0]._x+=xDiff;
		_manipulators[0]._y+=yDiff;
	}
	

	/*
	function dispatchNewDimensionsEvent(finishedUpdating:Boolean)
	{
		//trace("transmitting");
		//dispatchEvent("newDimensions",_shape);
		_oEB.broadcastEvent( new BasicEvent( NEW_DIMENSIONS_EVENT,_shape ) );
		
	}
	*/
	
}