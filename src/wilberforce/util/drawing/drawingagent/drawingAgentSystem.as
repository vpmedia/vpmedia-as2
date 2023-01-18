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
import wilberforce.util.movieclip.MovieClipUtil;
import wilberforce.event.frameEventBroadcaster;
import wilberforce.math.vector2D;
import wilberforce.util.drawing.styles.lineStyle;
import wilberforce.util.drawing.drawingUtility;

/**
* Class to animate the drawing of contours, either extracted using JSAPI or programatically
* 
* TODO - Remove dependency on wilberforce frameEventbroadcaster. Move to allow a simple XML format
*/
class wilberforce.util.drawing.drawingagent.drawingAgentSystem extends MovieClip {
	
	// Static defines. Can be used by other classes	
	public static var STRAIGHT:Number=1;
	public static var ARC:Number=2;
	public static var SHARP_TURN:Number=3;
	public static var COLOR_SET:Number=4;
	public static var SYMBOL:Number=5;
	public static var LOCK_CAMERA:Number=6;
	public static var MOVE:Number=7;
	public static var CURVE:Number=8;
	public static var LINE:Number=9;
	public static var LINESTYLE:Number=10;
	public static var WAIT:Number=11;
	public static var CREATE_SUBLINE:Number=12;
	public static var SET_SPEED:Number=13;
	
	private static var defaultStepDistance:Number=5;	
		
	private var stepDistance:Number=5;
		
	private var edgeData:Array;
	private var drawDashes:Boolean;	

	private var currentSin:Number;
	private var currentCos:Number;
	private	var currentEdgeIndex:Number;
	private	var currentEdgeObject:Object;

	private var currentStepData:Object;
	private	var currentEdgeStep:Number;
	private	var edgeStepsLeft:Number;	
	
	private	var currentCreationAngle:Number;	
	private	var previousEdgeEndAngle:Number;	
	
	private var currentPosition:vector2D;
	private var previousEdgeEndPosition:vector2D;
	
	private var drawingClip:MovieClip;
	
	// Used to hold the line segments before the single replacement is drawn
	private var temporaryDrawingClip:MovieClip;
	private var dashLineBool:Boolean;
	
	var complete:Boolean=false;
	var _followCamera:Boolean=false;
	
	var currentLineStyle:lineStyle;
	
	function drawingAgentSystem(movieClip:MovieClip,tEdgeData:Array,tInitialCreationAngle:Number,tLineStyle:lineStyle) {
		
		stepDistance=defaultStepDistance;
		edgeData=tEdgeData;		
		
		trace("--> contourDrawSystem created : "+edgeData.length+" steps")		
		if (edgeData.length<=0) return;
		
		drawingClip=MovieClipUtil.createEmptyClip(movieClip);
		temporaryDrawingClip=MovieClipUtil.createEmptyClip(drawingClip);
		
		drawDashes=false;
		
		if (!tInitialCreationAngle) tInitialCreationAngle=-90// Straight up
				
		previousEdgeEndAngle=currentCreationAngle=tInitialCreationAngle; // Straight up?
		
		 
		currentPosition=new vector2D(0,0);
		previousEdgeEndPosition=currentPosition.clone();
		
		currentEdgeIndex=0;
		currentEdgeStep=0;
		edgeStepsLeft=0;
		currentCos=Math.cos(2*Math.PI*currentCreationAngle/360);
		currentSin=Math.sin(2*Math.PI*currentCreationAngle/360);
		dashLineBool=true;
		
		drawingClip.moveTo(0,0);
		drawingClip.lineStyle(0,0xFFFFFF,100);
		
		if (tLineStyle) {
			trace("LineStyle applied");
			currentLineStyle=tLineStyle;
		}
		else currentLineStyle=lineStyle.defaultStyle;
		
		currentLineStyle.apply(drawingClip);
		currentLineStyle.apply(temporaryDrawingClip);
		
	}
	
	function start(followCamera:Boolean):Void
	{
		_followCamera=followCamera;
		
		processEdge(0);
		frameEventBroadcaster.addEventListener("frameStep",this,frameStep);
	}
	
	function frameStep():Void
	{		
		edgeStep();
		if (currentEdgeIndex<edgeData.length) edgeStep();
	}	
	
	function pause():Void
	{
	}
	
	function unpause():Void
	{
	
	}
	
	function processEdge(tEdge) {
		currentEdgeStep=0;
		currentEdgeObject=edgeData[tEdge];
		trace(drawingClip._name+" : Type is "+currentEdgeObject.type)
		switch (currentEdgeObject.type) {
			case STRAIGHT:
				edgeStepsLeft=currentEdgeObject.length/stepDistance;				
				currentStepData={type:STRAIGHT,x:currentCos*stepDistance,y:currentSin*stepDistance}
				break;
			case SHARP_TURN:
				edgeStepsLeft=0
				currentCreationAngle+=currentEdgeObject.angle;
				currentSin=Math.sin(2*Math.PI*currentCreationAngle/360);
				currentCos=Math.cos(2*Math.PI*currentCreationAngle/360);
				break;
			case ARC:
				var tDiameter=2*Math.PI*currentEdgeObject.radius*(currentEdgeObject.angle/360);
				edgeStepsLeft=Math.abs(tDiameter/stepDistance);	
				var tAngleStep=currentEdgeObject.angle/edgeStepsLeft;
				var sinStep=Math.sin(2*Math.PI*currentEdgeObject.angle/360);
				var cosStep=Math.cos(2*Math.PI*currentEdgeObject.angle/360);
				currentStepData={type:ARC,sinStep:sinStep,cosStep:cosStep,angleStep:tAngleStep};
				//trace("STEPS "+edgeStepsLeft);
				break;
			/*
			case COLOR_SET:
				edgeStepsLeft=0
				//trace("COLOUR SET "+currentEdgeObject.value);
				drawingClip.lineStyle(3,currentEdgeObject.value,100);
				break;
			*/
			case SYMBOL:			
				edgeStepsLeft=0
				var tData={_x:currentPosition.x,_y:currentPosition.y};
				var tDepth=drawingClip.getNextHighestDepth();
				drawingClip.attachMovie(currentEdgeObject.name,"symbol"+tDepth,tDepth,tData);
				
				break;
			case MOVE:
				trace("Moving to "+currentEdgeObject.x+","+currentEdgeObject.y);
				edgeStepsLeft=0;
				previousEdgeEndPosition.x=currentPosition.x=currentEdgeObject.x;
				previousEdgeEndPosition.y=currentPosition.y=currentEdgeObject.y;
				drawingClip.moveTo(currentPosition.x,currentPosition.y);
				temporaryDrawingClip.moveTo(currentPosition.x,currentPosition.y);
				break;
			case LINE:			
				
				//simpleDrawStep(currentEdgeObject.x,currentEdgeObject.y);
				//break;
				
				var dx=currentEdgeObject.x-currentPosition.x;
				var dy=currentEdgeObject.y-currentPosition.y;
				var tLength=Math.sqrt(dx*dx+dy*dy);
				edgeStepsLeft=Math.round(tLength/stepDistance);
//				trace("processing line steps "+edgeStepsLeft);
				if (edgeStepsLeft<1) {
					simpleDrawStep(currentEdgeObject.x,currentEdgeObject.y);			
				}
				else {
					currentStepData={type:STRAIGHT,x:dx/edgeStepsLeft,y:dy/edgeStepsLeft}				
				}
				break;
				
			case CURVE:				
		
				var tLength=getSplineLength(currentPosition.x,currentPosition.y,currentEdgeObject.cx,currentEdgeObject.cy,currentEdgeObject.ax,currentEdgeObject.ay)
				edgeStepsLeft=Math.round(tLength/stepDistance);
				var curvePoints=getSplinePoints(currentPosition.x,currentPosition.y,currentEdgeObject.cx,currentEdgeObject.cy,currentEdgeObject.ax,currentEdgeObject.ay,edgeStepsLeft)
				drawingClip.moveTo(curvePoints[0].x,curvePoints[0].y);				
				temporaryDrawingClip.moveTo(curvePoints[0].x,curvePoints[0].y);				
				//trace("Processing curve, steps "+edgeStepsLeft+" position "+currentPosition.x+","+currentPosition.y)
				/*
				var dx=currentEdgeObject.ax-currentPosition.x;
				var dy=currentEdgeObject.ay-currentPosition.y;
				var tLength=Math.sqrt(dx*dx+dy*dy);
				edgeStepsLeft=tLength/stepDistance;				
				currentStepData={type:STRAIGHT,x:dx/edgeStepsLeft,y:dy/edgeStepsLeft}
				*/
				if (edgeStepsLeft<1) {
					simpleDrawStep(currentEdgeObject.ax,currentEdgeObject.ay);			
				}
				else {
					currentStepData={type:CURVE,curvePoints:curvePoints}
				}
				
		
				//drawingClip.curveTo(currentEdgeObject.cx,currentEdgeObject.cy,currentEdgeObject.ax,currentEdgeObject.ay);
				break;
			case LINESTYLE:
				edgeStepsLeft=0;
				currentLineStyle=currentEdgeObject.style;
				currentLineStyle.apply(drawingClip);
				currentLineStyle.apply(temporaryDrawingClip);
				//trace("** LINESTYLE "+currentEdgeObject.color);
				//drawingClip.lineStyle(currentEdgeObject.thickness,currentEdgeObject.color,100);
				break;
			case CREATE_SUBLINE:
				var tEdgeData=currentEdgeObject.edgeData;
				var tStopped=currentEdgeObject.stopped;
				var tGlobalName=currentEdgeObject.globalName;				
				createSubLine(tEdgeData,tStopped,tGlobalName);
				edgeStepsLeft=0;
				break;
			case SET_SPEED:
				stepDistance=currentEdgeObject.speed;
				edgeStepsLeft=0;
				
		}
		// If its a blank edge, dont worry about it
		if (edgeStepsLeft<=0) {
			
			nextEdge();
			
		}
		
	}
	
	
	
	function nextEdge() {
		currentEdgeIndex++;
		if (currentEdgeIndex>=edgeData.length) {
			//trace("--> Reached the end")
			//delete this.onEnterFrame;
			frameEventBroadcaster.removeEventListener("frameStep",this);
			complete=true;
		}
		else {
			processEdge(currentEdgeIndex);
		}
	}
	
	function updateCamera(x:Number,y:Number)
	{
		if (_followCamera)
		{
			drawingClip._x=-x;
			drawingClip._y=-y;
		}
		
	}
	function edgeStep() {
		switch (currentStepData.type) {
			case STRAIGHT:		
				
				currentPosition.x+=currentStepData.x;
				currentPosition.y+=currentStepData.y;

				if (drawDashes) dashLineBool=!dashLineBool;
				if (dashLineBool) temporaryDrawingClip.lineTo(currentPosition.x,currentPosition.y);
				else drawingClip.temporaryDrawingClip(currentPosition.x,currentPosition.y);
				
				updateCamera(currentPosition.x,currentPosition.y);
				
				break;
			case ARC:
				
				var multiplyFactor=1;
				if (edgeStepsLeft<1) multiplyFactor=edgeStepsLeft

				currentCreationAngle+=currentStepData.angleStep*multiplyFactor;
				currentSin=Math.sin(2*Math.PI*currentCreationAngle/360);
				currentCos=Math.cos(2*Math.PI*currentCreationAngle/360);
				var tx=stepDistance*currentCos*multiplyFactor;
				var ty=stepDistance*currentSin*multiplyFactor;
				currentPosition.x+=tx;
				currentPosition.y+=ty;				
				
				if (drawDashes) dashLineBool=!dashLineBool;				
				if (dashLineBool) temporaryDrawingClip.lineTo(currentPosition.x,currentPosition.y);
				else temporaryDrawingClip.moveTo(currentPosition.x,currentPosition.y);
				
				updateCamera(currentPosition.x,currentPosition.y);

				break;
			case CURVE:
				var curveStep=currentStepData.curvePoints.length-edgeStepsLeft
				var tPoint=currentStepData.curvePoints[curveStep];
				
				currentPosition.x=tPoint.x;
				currentPosition.y=tPoint.y;
				if (drawDashes) dashLineBool=!dashLineBool;
				if (dashLineBool) temporaryDrawingClip.lineTo(currentPosition.x,currentPosition.y);
				else temporaryDrawingClip.moveTo(currentPosition.x,currentPosition.y);
				break;
			
			
		}
		edgeStepsLeft--;
		//_rotation=-currentCreationAngle-90;
		if (edgeStepsLeft<=0) {
			postEdgeStep();
			nextEdge();
		}
	}
	
	function postEdgeStep()
	{
		drawingClip.moveTo(previousEdgeEndPosition.x,previousEdgeEndPosition.y);
		switch (currentStepData.type)
		{			
			case STRAIGHT:
				drawingClip.lineTo(currentPosition.x,currentPosition.y);
				break;
			case ARC:
				trace("Drawing arc");
				//drawingClip.lineTo(currentPosition.x,currentPosition.y);
				var tx:Number=previousEdgeEndPosition.x;//+Math.cos(2*Math.PI*previousEdgeEndAngle/360);
				var ty:Number=previousEdgeEndPosition.y;//+Math.sin(2*Math.PI*previousEdgeEndAngle/360);
				
				// Hmm depending on the angle of direction, we need to change the "start angle" of the arc
				var tStartAngle:Number;
				if (currentEdgeObject.angle>0) tStartAngle=previousEdgeEndAngle-90;
				else tStartAngle=previousEdgeEndAngle+90;
				drawingUtility.drawArc(drawingClip,tx,ty, currentEdgeObject.angle, tStartAngle, currentEdgeObject.radius)
			case CURVE:
				drawingClip.curveTo(currentEdgeObject.cx,currentEdgeObject.cy,currentPosition.x,currentPosition.y);
				break;
		}
		
		previousEdgeEndPosition.x=currentPosition.x;
		previousEdgeEndPosition.y=currentPosition.y;
		previousEdgeEndAngle=currentCreationAngle;
		
		temporaryDrawingClip.clear();
		temporaryDrawingClip.moveTo(currentPosition.x,currentPosition.y);
		drawingClip.moveTo(currentPosition.x,currentPosition.y);
		currentLineStyle.apply(temporaryDrawingClip);
	}
	
	function createSubLine(tEdgeData:Array,tStopped:Boolean,tGlobalName:String)  {
		
		var tSublineClip:MovieClip=MovieClipUtil.createEmptyClip(drawingClip);
		
		tSublineClip._x=currentPosition.x;
		tSublineClip._y=currentPosition.y;
		
		var tSubDrawingAgentSystem:drawingAgentSystem=new drawingAgentSystem(tSublineClip,tEdgeData,currentCreationAngle,currentLineStyle);
		//tSubDrawingAgentSystem.currentCreationAngle=currentCreationAngle;
		
		if (!tStopped) tSubDrawingAgentSystem.start(false);
							
	}
		
	//---------------------------------------
	// Quadratic functions
	//---------------------------------------
	
	function B1 (t) {
		return (t*t);
	}
	function B2 (t) {
		return (2*t*(1-t));
	}
	function B3 (t) {
		return ((1-t)*(1-t));
	}
	
	function getSplineLength(startx,starty,cx,cy,ax,ay) {
		// Approximate length
		var tLength=0;
		var tPoints=getSplinePoints(startx,starty,cx,cy,ax,ay,20);
		for (var i=1;i<	tPoints.length;i++) {
			var dx=tPoints[i].x-tPoints[i-1].x;
			var dy=tPoints[i].y-tPoints[i-1].y;
			tLength+=Math.sqrt(dx*dx+dy*dy);
		}
		return tLength;
	}
	
	function getSplinePoints(startx,starty,cx,cy,ax,ay,splinePoints) {
		var count = 0;
		var detailBias = 1/splinePoints;		
		var tPointsArray=[];
		while (count<=1) {
			//var x = startx*B1(count)+cx*B2(count)+ax*B3(count);
			//var y = starty*B1(count)+cy*B2(count)+ay*B3(count);
			var x = ax*B1(count)+cx*B2(count)+startx*B3(count);
			var y = ay*B1(count)+cy*B2(count)+starty*B3(count);
			tPointsArray.push({x:x,y:y});		
			count += detailBias;
		} 
		return tPointsArray;
	}		
	function simpleDrawStep(tx,ty) {
		// For really small edges, just draw and wait a step
		currentPosition.x=tx;
		currentPosition.y=ty;
		if (drawDashes) dashLineBool=!dashLineBool;
		if (dashLineBool) drawingClip.lineTo(currentPosition.x,currentPosition.y);
		else drawingClip.moveTo(currentPosition.x,currentPosition.y);
		edgeStepsLeft=1;
		currentStepData={type:WAIT}	
	}
}