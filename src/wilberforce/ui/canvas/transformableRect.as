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
import wilberforce.util.drawing.styles.*;
import wilberforce.util.drawing.drawingUtility;
import wilberforce.util.movieclip.MovieClipUtil;
import wilberforce.ui.canvas.AbstractTransformableObject;
import wilberforce.geom.IShape2D;

// Classes From PixLib
import com.bourre.events.EventType;
import com.bourre.events.BasicEvent;
import com.bourre.commands.Delegate;
import com.bourre.events.EventBroadcaster;

/**
* Draggable circle class. Part of a collection of "canvas" classes that allow objects to be placed and manipulated.
* In this case, its set up to allow movement and change in size/scale
*/
class wilberforce.ui.canvas.transformableRect extends AbstractTransformableObject
{
	
	private var _shape:rect;
		
	function transformableRect(movieClip:MovieClip,tRect:rect,canMove:Boolean,canScale:Boolean,scaleUniform:Boolean,fillStyleOver:fillStyleFormat,fillStyleOff:fillStyleFormat,lineStyleOver:lineStyleFormat,lineStyleOff:lineStyleFormat)
	{
		super(movieClip,canMove,canScale,scaleUniform,fillStyleOver,fillStyleOff,lineStyleOver,lineStyleOff);
		
		_shape=tRect;
		
		createScaleManipulators();
		redraw(false);
		
		if (_scaleUniform) {
			_scaleRatio=_shape.height/_shape.width;			
		}		
		updateScaleManipulators(_shape);
		
		if (_canScale) _manipulatorFunctions.push(Delegate.create(this,updateScale));
		showManipulators(false);
	}
	
	public function redraw(rolledOver:Boolean)
	{
		_renderClip.clear();
		if (rolledOver) drawingUtility.drawRect(_renderClip,_shape,_lineStyleOver,_fillStyleOver);
		else drawingUtility.drawRect(_renderClip,_shape,_lineStyleOff,_fillStyleOff);
	}
	
	function updatePosition(xDiff:Number,yDiff:Number)
	{
		_shape.x=_shape.x+xDiff;
		_shape.y=_shape.y+yDiff;
			
		
		redraw(true);
			
		updateScaleManipulators(_shape);
	}
	
	public function setSize(width:Number,height:Number)
	{
		_shape.width=width;
		_shape.height=height;
		//trace("Width now "+_shape.width);
		updateScaleManipulators(_shape);
		redraw(true);
	}
	
	public function testRectIntersect(tRect:rect):Boolean
	{
		return tRect.getRectIntersection(_shape);
		//return false;
	}
	
	public function updateShape(shape:rect)
	{
		_shape=shape;
		redraw(false);
		//trace("Redraw");
		updateScaleManipulators(_shape);
	}
	
	function updateScale(xDiff:Number,yDiff:Number)
	{
		if (!_scaling) return;
		//trace("Scale called");
		var id=_currentScaleId;
		// X Value updates
		if (id%3==0) {_shape.x=_shape.x+xDiff;_shape.width=_shape.width-xDiff};
		if (id%3==2) {_shape.width=_shape.width+xDiff};
		// Y Value updates
		if (id<3) {_shape.y=_shape.y+yDiff;_shape.height=_shape.height-yDiff};
		if (id>=6) {_shape.height=_shape.height+yDiff};
		
		// Now make sure that its proportional
		if (_scaleUniform)
		{
			var tCurrentRatio=_shape.height/_shape.width;
						
			if (tCurrentRatio<_scaleRatio) {
				// If the ratio is too low, the width needs to be decreased
				//_shape.height=_shape.width*_scaleRatio;
				
			}
			else if (tCurrentRatio>_scaleRatio) {
				// If the ratio is too high, the height needs to be decreased
				//_shape.width=_shape.height/_scaleRatio;
			}
		}
		_renderClip.clear();
		drawingUtility.drawRect(_renderClip,_shape,_lineStyleOver,_fillStyleOver);
		updateScaleManipulators(_shape);
		dispatchNewDimensionsEvent(false);
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