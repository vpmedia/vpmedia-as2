import com.bumpslide.core.MtascApplet;
import com.bumpslide.util.ClassUtil;
import com.bumpslide.util.CubicBezier;
import com.bumpslide.util.Draw;

/**
 *  Interpolation Test
 *  
 *  @mtasc -swf Interpolation.swf -header 500:400:31:eeeedd -main 
 */
 
class com.bumpslide.example.applets.Interpolation extends MtascApplet {
	
	static function main(root_mc:MovieClip) : Void {			
		ClassUtil.applyClassToObj( Interpolation, root_mc );		
	}
	
	var targetPoints:Array;
	var interpolatedPoints:Array;
	var sourceUrl = "Interpolation.as";
	
	function Interpolation() {	
		super();
		onMouseDown = reset;
		reset();
		message('Click to randomize...');
	}
	
	/**
	* randomizes points, interpolates, and redraws
	*/
	function reset() {
		
		// create some random points
		targetPoints = new Array();
		for(var i=0; i<9; i++) {
			targetPoints.push({x:50+50*i, y:Math.random() * 300 + 50});
		}
			
		// interpolate
		var overshootFactor = 20;
		interpolatedPoints = CubicBezier.interpolatePiecewise( targetPoints, overshootFactor );
		
		// draw
		draw();
	}
		
	/**
	* Plots points, and draws Beziers using interpolation data
	*/
	function draw() {
		
		// create new clip to hold drawing
		var holder:MovieClip = createEmptyMovieClip('holder_mc', 1 );
		
		// draw target points as little black boxes
		for(var i=0; i<targetPoints.length; i++)
		{			
			var box:MovieClip = holder.createEmptyMovieClip('box'+i, i);
			Draw.box( box, 4, 4, 0x000000, 100);
			box._x = Math.round(targetPoints[i].x-2);
			box._y = Math.round(targetPoints[i].y-2);	
		}	
		
		// plot interpolated points
		holder.lineStyle(0, 0x880000);
		holder.moveTo(interpolatedPoints[0].x, interpolatedPoints[0].y);
		CubicBezier.drawBeziers(holder, interpolatedPoints);			
	}	
}