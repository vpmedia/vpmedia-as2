/**
 * A class to draw graphs. Use like so:
 * 

function gaussian(x:Number)
{
return Math.exp(-x*x);
}

var graph:Graph = new Graph();
graph.setFunction(gaussian);
graph.setRange(-3, 3, 0, 1);
graph.setResolutionRange(7, 500);
var curves:Array = graph.getCurves();
graph.renderCurves(curves, _root, 550, 400);
trace('Rendered with ' + (curves.length - 1)/2 + ' curves');
 * 
 * You are free to use this function for any use you wish as long as you 
 * don't attribute it to yourself. Links are appreciated, not mandatory
 * @author Patrick Mineault
 */
import flash.geom.Point;
class Graph {
	private var start:Number = -10;
	private var end:Number = 10;
	private var startY:Number = -10;
	private var endY:Number = -10;
	private var minCurves:Number = 10;
	private var maxCurves:Number = 1000;
	private var func:Function;
	private var extraArgs:Array;
	private var epsilon:Number = 0.00001;
	private var resDivisor:Number = 4;
	private var resMultiplier:Number = 2;
	function Graph () {
	}
	/**
	 * Sets the range of the resulting graph
	 */
	public function setRange (start:Number, end:Number, startY:Number, endY:Number):Void {
		this.start = start;
		this.end = end;
		this.startY = startY;
		this.endY = endY;
	}
	/**
	 * Sets the resolution range in the resulting graph
	 */
	public function setResolutionRange (minCurves:Number, maxCurves:Number):Void {
		this.minCurves = minCurves;
		this.maxCurves = maxCurves;
	}
	/**
	 * Sets the function to use for rendering
	 */
	public function setFunction (func:Function, extraArgs:Array):Void {
		this.func = func;
		this.extraArgs = extraArgs;
	}
	/**
	 * Sets the epsilon for the numeric derivative function
	 */
	public function setEpsilon (epsilon:Number):Void {
		this.epsilon = epsilon;
	}
	/**
	 * Gets the curves for an arbitrary function in range startX..endX, with numCurves curves
	 */
	public function getCurves ():Array {
		var minRes:Number = (end - start) / minCurves;
		var maxRes:Number = (end - start) / maxCurves;
		var oldX:Number = start;
		var oldY:Number = func (start, extraArgs);
		var currX:Number;
		var currY:Number;
		var currRes:Number = minRes;
		var intersect:Point;
		var points:Array = new Array ();
		points.push (new Point (oldX, oldY));
		var oldD:Number = 0.5 / epsilon * (func (oldX + epsilon, extraArgs) - func (oldX - epsilon, extraArgs));
		var currD:Number = 0;
		while (oldX < end) {
			currX = oldX + currRes;
			currY = func (currX, extraArgs);
			var currD = 0.5 / epsilon * (func (currX + epsilon, extraArgs) - func (currX - epsilon, extraArgs));
			intersect = getCurveIntersect (oldD, currD, oldX, oldY, currX, currY);
			if (intersect.x > oldX && intersect.x < currX) {
				//Point is ok
				points.push (intersect);
				points.push (new Point (currX, currY));
				oldX = currX;
				oldY = currY;
				oldD = currD;
				currRes = Math.min (resMultiplier * currRes, minRes);
			}
			else {
				if (Math.abs (currRes - maxRes) < 0.0001) {
					//Give up, push a line
					points.push (new Point (currX, currY));
					points.push (new Point (currX, currY));
					oldX = currX;
					oldY = currY;
					oldD = currD;
				}
				else {
					//Make current resolution higher
					currRes = Math.max (currRes / resDivisor, maxRes);
				}
			}
		}
		return points;
	}
	public function renderCurves (curves:Array, mc:MovieClip, width:Number, height:Number):Void {
		var scaleX:Number = width / (end - start);
		var scaleY:Number = height / (endY - startY);
		var numCurves = (curves.length - 1) / 2;
		mc.lineStyle (1, 0x000000);
		mc.moveTo ((curves[0].x - start) * scaleX, (endY - curves[0].y) * scaleY);
		for (var i = 0; i < numCurves; i++) {
			var cp:Point = curves[i * 2 + 1];
			var p2:Point = curves[i * 2 + 2];
			mc.curveTo ((cp.x - start) * scaleX, (endY - cp.y) * scaleY, (p2.x - start) * scaleX, (endY - p2.y) * scaleY);
		}
	}
	/**
	 * Gets an intersect
	 */
	private function getCurveIntersect (d1:Number, d2:Number, x1:Number, y1:Number, x2:Number, y2:Number):Point {
		var intersectX = (-x2 * d2 + y2 + x1 * d1 - y1) / (d1 - d2);
		var intersectY = d1 * (intersectX - x1) + y1;
		return new Point (intersectX, intersectY);
	}
}
