import com.bumpslide.util.*;
import org.asapframework.util.types.Point;

/**
* Simple Experiment to demonstrate a bit of circle math
*
* Copyright (c) 2006, David Knape
* Released under the open-source MIT license. 
* See LICENSE.txt for full license terms.
* 
* Compiles in FlashDevelop. No FLA necessary.
* @mtasc -swf com/bumpslide/example/applets/CircleTrigTest.swf -header 800:600:31:eeeedd -main
* @author David Knape
*/

class com.bumpslide.example.applets.CircleTrigTest extends com.bumpslide.core.MtascApplet
{
	
	// main clip content
	var main_mc : MovieClip;
	var sourceUrl : String = "CircleTrigTest.as";
	
	// public config
	var dotCount = 30; 		// number of dots on the circle
	var dotSpeed = 2; 			// pixels per frame out from center
	var maxDistance = 180; 	// distance (radius) at which we reset to 0
	var trailAmount = 40; 		// number of previous frames to keep on screen
	var rotationSpeed = 2; 	// degrees per frame, clockwise

	// private
	private var holderLevel = 0;
	private var dotRotation = 0;
	private var dotDistance = 0;
		
	/**
	 * Static main entry point
	 */
	static function main(root_mc:MovieClip) {			
		ClassUtil.applyClassToObj( CircleTrigTest, root_mc );		
	}
		
	function init() {
		createEmptyMovieClip('main_mc', 1);
		onEnterFrame = loop;			
		FramerateMonitor.display(this);
	}
		
	// this gets run on every frame
	function loop() {		
	
		// increment distance and reset to start when we hit the max
		dotDistance += dotSpeed;
		dotDistance %= maxDistance;

		// increment rotation offset and reset to 0 when we hit 360
		dotRotation += rotationSpeed; // turn x degrees on each frame
		dotRotation %= 360;
			
		// re-create and center holder
		holderLevel = ++holderLevel%trailAmount;
		var holder_mc = main_mc.createEmptyMovieClip('holder_mc', holderLevel);
		main_mc._x = Math.round( Stage.width/2 );
		main_mc._y = Math.round( Stage.height/2 );
		
		//trace('drawing dots at distance ' +dotDistance+ ' into '+holder_mc);
		for(var n=0; n<dotCount; n++) {		
			var dot_mc = holder_mc.createEmptyMovieClip('dot'+n, n);
			var angle = 360/dotCount * n + dotRotation;
			var loc = getPoint( angle, dotDistance );		
			drawPoint( dot_mc, loc.x, loc.y );		
			//trace('dot '+n+' is at '+loc.x+','+loc.y);
		}	
	}
	
	// converts angle to x,y coordinates 
	function getPoint( angleDegrees:Number, distance:Number ) : Point {
		var angleRadians = Number(angleDegrees) * Math.PI/180;
		return new Point( distance * Math.cos(angleRadians), distance * Math.sin(angleRadians));
	}

	// draw point on the stage at a given location
	function drawPoint(mc, x,y) {
		Draw.fill(mc, 1, 1, 0x333333, 100)
		mc._x = Math.round( x );
		mc._y = Math.round( y );			
	}
}

	