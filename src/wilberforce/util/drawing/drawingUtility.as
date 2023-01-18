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
import wilberforce.geom.circle;
import wilberforce.geom.line2D;
import wilberforce.geom.rect;
import wilberforce.util.drawing.styles.*;

/**
* 
*	TODO
*		- Big horrible mess. ugh. Lots of tidying
*		- Add a render routine for every time of geom listed (ie linestrip, rect, polygon, circle)
*		- Add different styles based upon rendering. Add a class to define gradients
*		- Ie, add a linestyle , a fillstyle (which could have a gradient style)
*		- Add a rectStyle (which has roundedness, a linestyle, a fillstyle
*		- Add a circleStyle
*		- Draw special spline with nice gradient
*/
class wilberforce.util.drawing.drawingUtility {
	
		
	
	function drawingUtility() {
		// Unused. Constructor never called
	}
	
	static function drawLine(tMovieClip:MovieClip,tLine:line2D,tLineStyle:lineStyleFormat):Void
	{
		if (!tLineStyle) tLineStyle=lineStyleFormat.defaultStyle;
		tLineStyle.apply(tMovieClip);
		
		tMovieClip.moveTo(tLine.p1.x,tLine.p1.y);
		tMovieClip.lineTo(tLine.p2.x,tLine.p2.y);
	}
	
	static function drawRect(tMovieClip:MovieClip,tRect:rect,tLineStyle:lineStyleFormat,tFillStyle:fillStyleFormat):Void
	{
		//if (!tLineStyle) tLineStyle=lineStyle.defaultStyle;
		if (tLineStyle) tLineStyle.apply(tMovieClip);
		else tMovieClip.lineStyle(undefined);
		
		if (!tFillStyle) tFillStyle=fillStyleFormat.defaultStyle;
		tFillStyle.apply(tMovieClip);
		
		if (tFillStyle.cornerRoundedSize)
		{
			
			drawSimpleRoundedRectangle(tMovieClip,tRect,tFillStyle.cornerRoundedSize)
		}
		else
		{			
			tMovieClip.moveTo(tRect.left,tRect.top);		
			tMovieClip.lineTo(tRect.right,tRect.top);
			tMovieClip.lineTo(tRect.right,tRect.bottom);
			tMovieClip.lineTo(tRect.left,tRect.bottom);
			tMovieClip.lineTo(tRect.left,tRect.top);
			
		}
		
		tMovieClip.endFill();
	}
	
	static function drawRectWithoutStyle(tMovieClip:MovieClip,tRect:rect)
	{
		tMovieClip.moveTo(tRect.left,tRect.top);		
		tMovieClip.lineTo(tRect.right,tRect.top);
		tMovieClip.lineTo(tRect.right,tRect.bottom);
		tMovieClip.lineTo(tRect.left,tRect.bottom);
		tMovieClip.lineTo(tRect.left,tRect.top);
	}
	
	static function drawCircle(movieClip:MovieClip,tCircle:circle,tLineStyle:lineStyleFormat,tFillStyle:fillStyleFormat):Void
	{
		if (tLineStyle) tLineStyle.apply(movieClip);
		else movieClip.lineStyle(undefined);
		
		if (!tFillStyle) tFillStyle=fillStyleFormat.defaultStyle;
		tFillStyle.apply(movieClip);
		
		//function drawCircle(r:Number,x:Number,y:Number){
		//var styleMaker:Number = 22.5;
		
		movieClip.moveTo(tCircle.pos.x+tCircle.radius,tCircle.pos.y);
		
		var tInterval=Math.PI/8;
		//var style:Number = Math.tan(styleMaker*Math.PI/180);
		var style=Math.tan(tInterval);
		for (var angle:Number=45;angle<=360;angle+=45){
			var endX:Number = tCircle.radius * Math.cos(angle*Math.PI/180);
			var endY:Number = tCircle.radius * Math.sin(angle*Math.PI/180);
			var cX:Number   = endX + tCircle.radius* style * Math.cos((angle-90)*Math.PI/180);
			var cY:Number   = endY + tCircle.radius* style * Math.sin((angle-90)*Math.PI/180);
			movieClip.curveTo(cX+tCircle.pos.x,cY+tCircle.pos.y,endX+tCircle.pos.x,endY+tCircle.pos.y);
		}	
	}
	
	static function drawArc(tMovieClip:MovieClip,x:Number,y:Number, arc:Number, startAngle:Number, radius:Number,yRadius:Number)
	{
		tMovieClip.moveTo(x,y);
		trace("Drawing From:"+startAngle+" Arc:"+arc);
		// Bits of this borrowed from here - http://www.adobe.com/devnet/flash/articles/adv_draw_methods.html
		if (yRadius == undefined) yRadius = radius;
	
		var segAngle:Number, theta:Number, angle:Number, angleMid:Number, segs:Number, ax:Number, ay:Number, bx:Number, by:Number, cx:Number, cy:Number;		
		if (Math.abs(arc)>360) arc = 360;
			
		segs = Math.ceil(Math.abs(arc)/45);		
		segAngle = arc/segs;		
		theta = (segAngle/180)*Math.PI;		
		angle = (startAngle/180)*Math.PI;		
		ax = x-Math.cos(angle)*radius;
		ay = y-Math.sin(angle)*yRadius;
				
		if (segs>0) {			
			for (var i = 0; i<segs; i++) {				
				angle += theta;
				// find the angle halfway between the last angle and the new
				angleMid = angle-(theta/2);
				// calculate our end point
				bx = ax+Math.cos(angle)*radius;
				by = ay+Math.sin(angle)*yRadius;
				// calculate our control point
				cx = ax+Math.cos(angleMid)*(radius/Math.cos(theta/2));
				cy = ay+Math.sin(angleMid)*(yRadius/Math.cos(theta/2));
				// draw the arc segment
				tMovieClip.curveTo(cx, cy, bx, by);
			}
		}
	}
	
	/** Creates a rounded rectangle, with optional, outline and fill */
	public static function drawRoundedRectangle(tClip:MovieClip,tx,ty,tWidth,tHeight,tRoundedness,tLineColor,tColorAlpha,tFillColor,tFillAlpha,tLineThickness,cutoffLeft,cutoffRight,forceFill) {
		if (tLineThickness==null) tLineThickness=1;
		tClip.lineStyle(tLineThickness,tLineColor,tColorAlpha);
		if (tFillAlpha>0 || forceFill) tClip.beginFill(tFillColor,tFillAlpha);
		
		if (cutoffLeft) {
			tClip.moveTo(tx,ty);
		}
		else tClip.moveTo(tx+tRoundedness,ty);
		
		if (cutoffRight) {
			tClip.lineTo(tx+tWidth,ty);
			tClip.lineTo(tx+tWidth,ty+tHeight);
		}
		else {
			tClip.lineTo(tx+tWidth-tRoundedness,ty);
			tClip.curveTo(tx+tWidth,ty,tx+tWidth,ty+tRoundedness);
			tClip.lineTo(tx+tWidth,ty+tHeight-tRoundedness);
			tClip.curveTo(tx+tWidth,ty+tHeight,tx+tWidth-tRoundedness,ty+tHeight);
		}
		if (cutoffLeft) {
			tClip.lineTo(tx,ty+tHeight);
			tClip.lineTo(tx,ty);
		}
		else {	
			tClip.lineTo(tx+tRoundedness,ty+tHeight);
			tClip.curveTo(tx,ty+tHeight,tx,ty+tHeight-tRoundedness);
			tClip.lineTo(tx,ty+tRoundedness);
			tClip.curveTo(tx,ty,tx+tRoundedness,ty);
		}
		if (tFillAlpha>0) tClip.endFill();
	}
	
	public static function drawSimpleRoundedRectangle(tMovieClip:MovieClip,tRect:rect,tRoundedness:Number)
	{
		tMovieClip.moveTo(tRect.left+tRoundedness,tRect.top);
		tMovieClip.lineTo(tRect.right-tRoundedness,tRect.top);
		tMovieClip.curveTo(tRect.right,tRect.top,tRect.right,tRect.top+tRoundedness);
		tMovieClip.lineTo(tRect.right,tRect.bottom-tRoundedness);
		tMovieClip.curveTo(tRect.right,tRect.bottom,tRect.right-tRoundedness,tRect.bottom);
		tMovieClip.lineTo(tRect.left+tRoundedness,tRect.bottom);
		tMovieClip.curveTo(tRect.left,tRect.bottom,tRect.left,tRect.bottom-tRoundedness);
		tMovieClip.lineTo(tRect.left,tRect.top+tRoundedness);
		tMovieClip.curveTo(tRect.left,tRect.top,tRect.left+tRoundedness,tRect.top);
	}
	
	/** Creates a rounded rectangle with an indent at the top, with optional, outline and fill */
	public static function drawIndentedRoundedRectangle(tClip:MovieClip,tx,ty,tWidth,tHeight,tRoundedness,tLineColor,tColorAlpha,tFillColor,tFillAlpha,tLineThickness,tIndentWidth) {
		if (tLineThickness==null) tLineThickness=1;
		var leftIndentPosition=tWidth/2-tIndentWidth/2;
		var rightIndentPosition=tWidth/2+tIndentWidth/2;
		tClip.lineStyle(tLineThickness,tLineColor,tColorAlpha);
		if (tFillAlpha>0) tClip.beginFill(tFillColor,tFillAlpha);
		tClip.moveTo(tx+tRoundedness,ty);
		
		// Create indentation		
		tClip.lineTo(leftIndentPosition,ty);		
		tClip.curveTo(leftIndentPosition,ty+tRoundedness,leftIndentPosition+tRoundedness,ty+tRoundedness);		
		tClip.lineTo(rightIndentPosition-tRoundedness,ty+tRoundedness);
		tClip.curveTo(rightIndentPosition,ty+tRoundedness,rightIndentPosition,ty);	
		
		tClip.lineTo(tx+tWidth-tRoundedness,ty);
		tClip.curveTo(tx+tWidth,ty,tx+tWidth,ty+tRoundedness);
		tClip.lineTo(tx+tWidth,ty+tHeight-tRoundedness);
		tClip.curveTo(tx+tWidth,ty+tHeight,tx+tWidth-tRoundedness,ty+tHeight);
		tClip.lineTo(tx+tRoundedness,ty+tHeight);
		tClip.curveTo(tx,ty+tHeight,tx,ty+tHeight-tRoundedness);
		tClip.lineTo(tx,ty+tRoundedness);
		tClip.curveTo(tx,ty,tx+tRoundedness,ty);
		if (tFillAlpha>0) tClip.endFill();
	}
	
	/** Creates a rounded rectangle, with optional outline and gradient fill */
	public static function drawRoundedRectangleGradientFill(tClip:MovieClip,tx,ty,tWidth,tHeight,tRoundedness,tLineColor,tColorAlpha,tFillColor1,tFillAlpha1,tFillColor2,tFillAlpha2,tLineThickness,cutoffLeft,cutoffRight) {
		if (tLineThickness==null) tLineThickness=1;
		
		
		
		tClip.lineStyle(tLineThickness,tLineColor,tColorAlpha);
		//tClip.beginFill(tFillColor,tFillAlpha);
		
		var colors = [tFillColor1, tFillColor2];
		var alphas = [tFillAlpha1, tFillAlpha2];
		//var alphas = [30, 30];
		var ratios = [0, 0xFF];
		//var matrix = {a:200, b:0, c:0, d:0, e:200, f:0, g:200, h:200, i:1};
		var matrix = {matrixType:"box", x:tx, y:ty, w:tWidth, h:tHeight, r:(90/180)*Math.PI};
		
		tClip.beginGradientFill("linear", colors, alphas, ratios, matrix);
		
		if (cutoffLeft) {
			tClip.moveTo(tx,ty);
		}
		else {
			tClip.moveTo(tx+tRoundedness,ty);
		}
		
		if (cutoffRight) {
			tClip.lineTo(tx+tWidth,ty);
			tClip.lineTo(tx+tWidth,ty+tHeight);
		}
		else {
			tClip.lineTo(tx+tWidth-tRoundedness,ty);
			tClip.curveTo(tx+tWidth,ty,tx+tWidth,ty+tRoundedness);
		
			tClip.lineTo(tx+tWidth,ty+tHeight-tRoundedness);
			tClip.curveTo(tx+tWidth,ty+tHeight,tx+tWidth-tRoundedness,ty+tHeight);
		}
		if (cutoffLeft) {
			tClip.lineTo(tx,ty+tHeight);
			tClip.lineTo(tx,ty);
		}
		else {	
			tClip.lineTo(tx+tRoundedness,ty+tHeight);
			tClip.curveTo(tx,ty+tHeight,tx,ty+tHeight-tRoundedness);
			
			tClip.lineTo(tx,ty+tRoundedness);
			tClip.curveTo(tx,ty,tx+tRoundedness,ty);
		}
		tClip.endFill();
	}
	
	/** Creates a rectangle, with optional outline and fill */
	public static function drawRectangle(tClip:MovieClip,tx,ty,tWidth,tHeight,tLineColor,tColorAlpha,tFillColor,tLineThickness,tFillAlpha,forceFill) {
		if (tLineThickness==null) tLineThickness=1;
						
		tClip.lineStyle(tLineThickness,tLineColor,tColorAlpha);
		if (tFillAlpha>0 || forceFill) tClip.beginFill(tFillColor,tFillAlpha);
		
		tClip.moveTo(tx,ty);
		tClip.lineTo(tx+tWidth,ty);		
		tClip.lineTo(tx+tWidth,ty+tHeight);	
		tClip.lineTo(tx,ty+tHeight);	
		tClip.lineTo(tx,ty);	
		if (tFillAlpha>0 || forceFill) tClip.endFill();
	}
	
	/** Creates a rectangle, with gradient fill */
	public static function drawRectangleGradientFill(tClip:MovieClip,tx,ty,tWidth,tHeight,tLineColor,tColorAlpha,tFillColor1,tFillAlpha1,tFillColor2,tFillAlpha2,tLineThickness) {
		tClip.lineStyle(tLineThickness,tLineColor,tColorAlpha);
		//tClip.beginFill(tFillColor,tFillAlpha);
		
		var colors = [tFillColor1, tFillColor2];
		var alphas = [tFillAlpha1, tFillAlpha2];
		//var alphas = [30, 30];
		var ratios = [0, 0xFF];
		//var matrix = {a:200, b:0, c:0, d:0, e:200, f:0, g:200, h:200, i:1};
		var matrix = {matrixType:"box", x:tx, y:ty, w:tWidth, h:tHeight, r:(90/180)*Math.PI};
		
		tClip.beginGradientFill("linear", colors, alphas, ratios, matrix);
		tClip.moveTo(tx,ty);
		tClip.lineTo(tx+tWidth,ty);		
		tClip.lineTo(tx+tWidth,ty+tHeight);	
		tClip.lineTo(tx,ty+tHeight);	
		tClip.lineTo(tx,ty);	
		tClip.endFill();
	}
	
	/** Draws a line */
	/** OLD
	public static function drawLine(tClip:MovieClip,tx1,ty1,tx2,ty2,tLineColor,tLineAlpha,tLineThickness) {
		tClip.lineStyle(tLineThickness,tLineColor,tLineAlpha);
		tClip.moveTo(tx1,ty1);
		tClip.lineTo(tx2,ty2);
	}
	*/
	
	/** Draws an invisible movieclip (used for buttons) */
	public static function drawInvisibleMovieClip(tClip:MovieClip,tWidth,tHeight) {
		var tDepth=tClip.getNextHighestDepth()
		var tButtonClip=tClip.createEmptyMovieClip("button"+tDepth,tDepth);
		drawRectangle(tButtonClip,0,0,tWidth,tHeight,0x000000,0,0xFF0000,undefined,0,true) 
		return tButtonClip;
	}
	
}