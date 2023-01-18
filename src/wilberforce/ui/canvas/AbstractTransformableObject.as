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

// Classes from Wilberforce
import wilberforce.geom.rect;
import wilberforce.geom.IShape2D;
import wilberforce.geom.vector2D;
import wilberforce.util.drawing.styles.*;
import wilberforce.util.movieclip.MovieClipUtil;
import wilberforce.util.drawing.drawingUtility;
import wilberforce.ui.canvas.transformableObjectModifiedEvent;

// Classes From PixLib
import com.bourre.events.EventType;
import com.bourre.events.BasicEvent;
import com.bourre.commands.Delegate;
import com.bourre.events.EventBroadcaster;


/**
* Base class for all transformableObjects. Part of a collection of "canvas" classes that allow objects to be placed and manipulated.
*/
class wilberforce.ui.canvas.AbstractTransformableObject
{
	// Functions and Interface elements to manipulte the element
	var _manipulators:Array;
	var _manipulatorFunctions:Array;
	
	private var _movieClip:MovieClip;	 	
	private var _containerClip:MovieClip;
	private var _renderClip:MovieClip;
	private var _scaling:Boolean;
	private var _moving:Boolean;
	private var _currentScaleId:Number;
	
	private var _canMove:Boolean;
	private var _canScale:Boolean;
	private var _scaleUniform:Boolean;
	
	static var _scaleBoxRect:rect=new rect(-4,-4,4,4);
	static var _scaleBoxFillStyle:fillStyleFormat=new fillStyleFormat(0xFFFFFF,100,0);
	static var _scaleBoxLineStyle:lineStyleFormat=new lineStyleFormat(0,0x000000,100);
	
	private var _lastMouseX:Number;
	private var _lastMouseY:Number;
	
	private var _scaleRatio:Number;
	
	private var _fillStyleOver:fillStyleFormat;
	private var _fillStyleOff:fillStyleFormat
	private var _lineStyleOver:lineStyleFormat
	private var _lineStyleOff:lineStyleFormat
	
	public var selected:Boolean;
	
	private var _shape:IShape2D;
	
	private static var NEW_DIMENSIONS_EVENT : EventType =  new EventType( "onTransformableObjectNewDimensions" );
	private static var SELECT_EVENT : EventType =  new EventType( "onTransformableObjectSelected" );
	private static var DESELECT_EVENT : EventType =  new EventType( "onTransformableObjectDeselected" );
	private static var DELETE_OBJECT_EVENT : EventType =  new EventType( "onDeleteTransformableObject" );
	private static var DOUBLE_CLICK_EVENT : EventType =  new EventType( "onDoubleClick" );
		
	private var _oEB:EventBroadcaster;
	
	private var _lastClickedTime:Number;
	
	private static var DOUBLE_CLICK_TIME:Number=400;
	
	function AbstractTransformableObject(movieClip:MovieClip,canMove:Boolean,canScale:Boolean,scaleUniform:Boolean,fillStyleOver:fillStyleFormat,fillStyleOff:fillStyleFormat,lineStyleOver:lineStyleFormat,lineStyleOff:lineStyleFormat)
	{
				
		_oEB = new EventBroadcaster( this );
			
		_canMove=canMove;
		_canScale=canScale;
		_scaleUniform=scaleUniform;
		
		_containerClip=MovieClipUtil.createEmptyClip(movieClip);
		_renderClip=MovieClipUtil.createEmptyClip(_containerClip);
		_movieClip=movieClip;
		_manipulators=[];//new Array();
		_manipulatorFunctions=new Array();
		
		showManipulators(false);
		_scaling=false;
		_currentScaleId=null
		
		_containerClip.onMouseMove=Delegate.create(this,mouseMove);
		selected=false;
		
		_fillStyleOver=fillStyleOver;
		_fillStyleOff=fillStyleOff;
		_lineStyleOver=lineStyleOver;
		_lineStyleOff=lineStyleOff;		
		
		_renderClip.onRollOver=Delegate.create(this,rollOver);
		_renderClip.onRollOut=Delegate.create(this,rollOut);
		_renderClip.onPress=Delegate.create(this,press);
		_renderClip.onRelease=Delegate.create(this,release);
		_renderClip.onReleaseOutside=Delegate.create(this,releaseOutside);
		
		if (_canMove) _manipulatorFunctions.push(Delegate.create(this,moveManipulatorTest));
		
	}
	
	public function addListener(listeningObject)
	{
		_oEB.addListener(listeningObject);
	}
	public function removeListener(listeningObject)
	{
		_oEB.removeListener(listeningObject);
	}
	
	public function createScaleManipulators()
	{ 
		//return;
		for (var i=0;i<9;i++) {
			if (i!=4) createScaleManipulator(i);
		}
	}
	
	public function updateShape(shape:IShape2D)
	{
		
	}
	
	// To be defined by each object
	public function redraw(rolledOver:Boolean)
	{
	
	}
	
		public function rollOver():Void
	{
		redraw(true);		
	}
	
	public function rollOut():Void
	{
		if (!selected) 	redraw(false);
	}
	
	public function press()
	{		
		var tTimeDifference:Number=getTimer()-_lastClickedTime;
		if (tTimeDifference<DOUBLE_CLICK_TIME) {
			doubleClick();
		}
		if (_canMove) startMove();
		select();
		_lastClickedTime=getTimer();
	}
	
	private function doubleClick()
	{
		trace("Double Click");
		_oEB.broadcastEvent( new BasicEvent( DOUBLE_CLICK_EVENT,this ) );
	}
	
	public function release()
	{		
		endMove();
	}
	
	function releaseOutside()
	{
		rollOut();
		release();
	}
	
	function select(noEvent:Boolean)
	{
		//dispatchEvent("select",this);
		if (!noEvent) _oEB.broadcastEvent( new BasicEvent( SELECT_EVENT,this ) );
		selected=true;		
		redraw(true);
		showManipulators(true);
		
	}
	
	function deselect(noEvent:Boolean)
	{
		//dispatchEvent("deselect",this);
		if (!noEvent) _oEB.broadcastEvent( new BasicEvent( DESELECT_EVENT,this ) );
		selected=false;		
		redraw(false);
		showManipulators(false);		
	}
	
	// To overwrite per object
	public function testRectIntersect(tRect:rect):Boolean
	{
		return false;
	}
	
	
	public function updateScaleManipulators(tRect:rect)
	{
		var midx:Number=tRect.left+tRect.width/2;
		var midy:Number=tRect.top+tRect.height/2;
		
		positionScaleManipulator(tRect.left,tRect.top,0);
		positionScaleManipulator(midx,tRect.top,1);
		positionScaleManipulator(tRect.right,tRect.top,2);
		
		positionScaleManipulator(tRect.left,midy,3);
		positionScaleManipulator(tRect.right,midy,5);
		
		positionScaleManipulator(tRect.left,tRect.bottom,6);
		positionScaleManipulator(midx,tRect.bottom,7);
		positionScaleManipulator(tRect.right,tRect.bottom,8);
		
	}
	
	public function showManipulators(visibility:Boolean):Void
	{		
		for (var i in _manipulators) _manipulators[i]._visible=visibility;	
	}
	
	public function positionScaleManipulator(x:Number,y:Number,id:Number):Void
	{
		//trace("Moving "+id+" - "+_scaleBoxes[id]+" to "+x+","+y);
		_manipulators[id]._x=x;
		_manipulators[id]._y=y;
	}
	
	public function createScaleManipulator(id:Number)
	{
		var tScaleBoxMovieClip:MovieClip=MovieClipUtil.createEmptyClip(_containerClip);
		drawingUtility.drawRect(tScaleBoxMovieClip,_scaleBoxRect,_scaleBoxLineStyle,_scaleBoxFillStyle);
		tScaleBoxMovieClip.id=id;
		tScaleBoxMovieClip.onPress=Delegate.create(this,startScale,tScaleBoxMovieClip.id);
		tScaleBoxMovieClip.onReleaseOutside=tScaleBoxMovieClip.onRelease=Delegate.create(this,endScale);
		//Delegate.create(this,endScale);
		
		
		_manipulators[id]=tScaleBoxMovieClip;
		
		//_scaleBoxes.push(tScaleBoxMovieClip);
	//	trace("Array size "+_scaleBoxes.length+" added "+id);
		//trace("Array size "+_scaleBoxes.length);
	}
	
	public function startScale(scaleId:Number):Void
	{
		_scaling=true;
		_currentScaleId=scaleId;
		//trace("Scaling "+scaleId);
	}
	public function endScale():Void
	{
		//trace("End scale");
		if (!_scaling) return;
		
		_scaling=false;
		dispatchNewDimensionsEvent(true);
	}
	
	
	public function deleteItem():Void
	{
		//Logger.LOG("Delelting item");
		_oEB.broadcastEvent( new BasicEvent( DELETE_OBJECT_EVENT,this ) );
	}
	
	
	function startMove()
	{
		_lastMouseX=_movieClip._xmouse;
		_lastMouseY=_movieClip._ymouse;
		_moving=true;
	}
	
	function endMove()
	{
		if (!_moving) return;
		_moving=false;
		dispatchNewDimensionsEvent(true);
	}
	
	function moveManipulatorTest(xDiff:Number,yDiff:Number,xAbs:Number,yAbs:Number)
	{
		if (_moving)
		{						
			updatePosition(xDiff,yDiff);
			dispatchNewDimensionsEvent(false);
		}
	}
	
	function mouseMove()
	{
		var dx=_movieClip._xmouse-_lastMouseX;
		var dy=_movieClip._ymouse-_lastMouseY;
						
		_lastMouseX=_movieClip._xmouse;
		_lastMouseY=_movieClip._ymouse;
			
		for (var i in _manipulatorFunctions)
		{
			_manipulatorFunctions[i](dx,dy,_lastMouseX,_lastMouseY);
		}
		/*
		if (_scaling) 
		{			
			updateScale(_currentScaleId,dx,dy,_lastMouseX,_lastMouseY);
		}
		*/
	}
	
	/** To overwrite */
	function updatePosition(xDiff:Number,yDiff:Number)
	{
		
	}
	
	
	
	
	
	function dispatchNewDimensionsEvent(finishedUpdating:Boolean)
	{
		
		
		_oEB.broadcastEvent( new transformableObjectModifiedEvent( NEW_DIMENSIONS_EVENT,this,_shape,finishedUpdating ) );
		
	
	}
}