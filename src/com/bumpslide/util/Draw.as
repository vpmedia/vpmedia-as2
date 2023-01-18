
/**
 * Drawing Utilities
 *
 * @author Thomas Wester
 * @author David Knape
 */

class com.bumpslide.util.Draw {

	/**
	 *  Creates a pixel sharp bounding box on a movie clip
	 * 
	 *  @param	mc
	 *  @param	boxwidth
	 *  @param	boxheight
	 *  @param	boxcolor
	 *  @param	linewidth
	 *  @param	alpha
	 */
	static public function outline (mc:MovieClip, boxwidth:Number, boxheight:Number, boxcolor:Number, linewidth:Number, alpha:Number ){
		
		//trace('createOutline ' + mc );
		if( alpha == undefined ) alpha = 100;
		if( linewidth == undefined ) linewidth = 1;// the outlineline width
	
		//round widht and height to ensure a sharp result
		boxwidth 	= Math.round(boxwidth);
		boxheight 	= Math.round(boxheight);
		
		var top = mc['top'];
		
		if( mc['top'] == undefined ){
			top = mc.createEmptyMovieClip('top', 1 );
		}else{
			//if top is defined, bottom is defined too. as we duplicate top later on, we have to remove bottom here
			mc['bottom'].removeMovieClip();
		}
		top._x = linewidth;
		// Create top line movieclip
		Draw.fill( top, boxwidth-linewidth*2, linewidth, boxcolor, alpha );
		var right = mc['right'];
		if( mc['right'] == undefined ){
			right = mc.createEmptyMovieClip('right', 2 );
		}else{
			//if right is defined, left is defined too. as we duplicate left later on, we have to remove left here
			mc['left'].removeMovieClip();
		}
		// Create right line  movieclip
		Draw.fill( right, linewidth, boxheight, boxcolor, alpha );
		right._x = boxwidth-linewidth;
		
		var bottom 	= top.duplicateMovieClip('bottom', 3);
		bottom._y = boxheight-linewidth;
		
		var left	= right.duplicateMovieClip('left', 4 );
		left._x 	= 0;
		left._y 	= 0;
	}

	/**
	 *  Creates a pseudo-rounded outline for use with the pixel aesthetic
	 * 
	 *  Not really rounded, the corners are just missing.
	 * 
	 *  @param	mc
	 *  @param	boxwidth
	 *  @param	boxheight
	 *  @param	tcolor
	 *  @param	rcolor
	 *  @param	bcolor
	 *  @param	lcolor
	 *  @param	fillcolor
	 */ 
	static public function roundedOutline(mc:MovieClip, boxwidth:Number, boxheight:Number, tcolor:Number, rcolor:Number, bcolor:Number, lcolor:Number, fillcolor:Number){
		//trace('createOutline_rounded ' + mc );
		// load up the colors css style 
		if(tcolor==undefined) tcolor = 0x333333;
		if(rcolor==undefined) rcolor = tcolor;
		if(bcolor==undefined) bcolor = tcolor;
		if(lcolor==undefined) lcolor = rcolor;
		
		var linewidth = 1;	// the outlineline width
		boxwidth 	= Math.round(boxwidth);
		boxheight 	= Math.round(boxheight);
		
		var top = mc['top'];
		if( mc['top'] == undefined ){
			top = mc.createEmptyMovieClip('top', 1 );
		}else{
			mc['bottom'].removeMovieClip();		//if top is defined, bottom is defined too. as we duplicate top later on, we have to remove bottom here
		}
		// Create top line movieclip
		Draw.fill( top, boxwidth-2, linewidth, tcolor, 100 );
		top._x = 1;
		top._y = 0;
	
		var right = mc['right'];
		if( mc['right'] == undefined ){
			right = mc.createEmptyMovieClip('right', 2 );
		}else{
			mc['left'].removeMovieClip(); 		//if right is defined, left is defined too. as we duplicate left later on, we have to remove left here
		}
		
		// Create right line  movieclip
		Draw.fill( right, linewidth, boxheight-2, rcolor, 100 );
		right._x = boxwidth-linewidth;	
		right._y = 1;	
		
		var bottom 	= top.duplicateMovieClip('bottom', 3);
		bottom._x = 1;
		bottom._y = boxheight-linewidth;
		var bottom_c = new Color( bottom );
		bottom_c.setRGB( bcolor );
		delete(bottom_c);
		
		var left	= right.duplicateMovieClip('left', 4 );
		left._x 	= 0;
		left._y 	= 1;
		var left_c	= new Color( left );
		left_c.setRGB( lcolor );
		delete (left_c);
		
		if(fillcolor!=null) {
			if( mc['fill']  == undefined ){
				mc.createEmptyMovieClip('fill', 5 );
			}
			Draw.fill( mc['fill'], boxwidth-2, boxheight-2, fillcolor, 100 );
			mc['fill']._x =1;
			mc['fill']._y =1;
		}
	}

	
	/**
	* Alias for Draw.box created for backwards compatibility
	* 
	* @param	mc
	* @param	boxWidth
	* @param	boxHeight
	* @param	boxColor
	* @param	alpha
	*/
	static public function fill (mc:MovieClip, boxWidth:Number, boxHeight:Number, boxColor:Number, alpha:Number){
		Draw.box.apply( null, arguments );
	}
	
	/**
	 * Draws a box on a movieclip
	 * 
	 * @param	mc
	 * @param	boxWidth
	 * @param	boxHeight
	 * @param	boxColor
	 * @param	alpha
	 */
	static public function box (mc:MovieClip, boxWidth:Number, boxHeight:Number, boxColor:Number, alpha:Number) {
		if( alpha == undefined ) alpha = 100;
		mc.clear();
		mc.beginFill( boxColor, alpha );
		mc.moveTo( 0, 0);
		mc.lineTo( boxWidth, 0);
		mc.lineTo( boxWidth, boxHeight);
		mc.lineTo( 0, boxHeight);
		mc.lineTo( 0, 0 );
		mc.endFill();
	}
	
	/**
	 * Draws pixel-perfect horizonal dashed line
	 * 
	 * @param	mc
	 * @param	width
	 * @param	dashColor
	 * @param	dashLen
	 * @param	dashGap
	 */
	static public function dashedLineHoriz( mc:MovieClip, width:Number, dashColor:Number, dashLen:Number, dashGap:Number) {
	
		mc.clear();
	
		if(dashLen==null) dashLen=3;
		if(dashGap==null) dashGap=2;
		if(dashColor==null) dashColor=0x000000;
		
		var segLength = dashLen+dashGap; 
		var boxWidth;
		for(var x=0; x<=width; x+=segLength) {
			//Debug.dTrace('dash x='+x+', width='+width);
			boxWidth = x+Math.min(width-x, dashLen);
			mc.beginFill( dashColor, 100 );
			mc.moveTo( x, 0);
			mc.lineTo( boxWidth, 0);
			mc.lineTo( boxWidth, 1);
			mc.lineTo( x, 1);
			mc.lineTo( x, 0 );
			mc.endFill();
		}		
	}
	
	

	/**
	* Draws a rounded rectangle.
	* 
	* modified version of mc.drawRect() - by Ric Ewing (ric@formequalsfunction.com)
	* see http://www.adobe.com/devnet/flash/articles/adv_draw_methods.html
	* 
	* @param	mc
	* @param	w
	* @param	h
	* @param	cornerRadius
	* @param	thickness
	* @param	color
	* @param	alpha
	*/
	static public function roundedRectangle( mc:MovieClip, w:Number, h:Number, cornerRadius:Number, thickness:Number, color:Number, alpha:Number ) {
	
		if(thickness==null) thickness=0;
		if(color==null) color=0x000000;
		if(alpha==null) alpha=100;
		
		mc.lineStyle(thickness, color, alpha);
		mc.clear();
				
		// init vars
		var theta, angle, cx, cy, px, py;
		// make sure that w + h are larger than 2*cornerRadius
		if (cornerRadius>Math.min(w, h)/2) {
			cornerRadius = Math.min(w, h)/2;
		}
		// theta = 45 degrees in radians
		theta = Math.PI/4;
		// draw top line
		mc.moveTo(cornerRadius, 0);
		mc.lineTo(w-cornerRadius, 0);
		//angle is currently 90 degrees
		angle = -Math.PI/2;
		// draw tr corner in two parts
		cx = w-cornerRadius+(Math.cos(angle+(theta/2))*cornerRadius/Math.cos(theta/2));
		cy = cornerRadius+(Math.sin(angle+(theta/2))*cornerRadius/Math.cos(theta/2));
		px = w-cornerRadius+(Math.cos(angle+theta)*cornerRadius);
		py = cornerRadius+(Math.sin(angle+theta)*cornerRadius);
		mc.curveTo(cx, cy, px, py);
		angle += theta;
		cx = w-cornerRadius+(Math.cos(angle+(theta/2))*cornerRadius/Math.cos(theta/2));
		cy = cornerRadius+(Math.sin(angle+(theta/2))*cornerRadius/Math.cos(theta/2));
		px = w-cornerRadius+(Math.cos(angle+theta)*cornerRadius);
		py = cornerRadius+(Math.sin(angle+theta)*cornerRadius);
		mc.curveTo(cx, cy, px, py);
		// draw right line
		mc.lineTo(w, h-cornerRadius);
		// draw br corner
		angle += theta;
		cx = w-cornerRadius+(Math.cos(angle+(theta/2))*cornerRadius/Math.cos(theta/2));
		cy = h-cornerRadius+(Math.sin(angle+(theta/2))*cornerRadius/Math.cos(theta/2));
		px = w-cornerRadius+(Math.cos(angle+theta)*cornerRadius);
		py = h-cornerRadius+(Math.sin(angle+theta)*cornerRadius);
		mc.curveTo(cx, cy, px, py);
		angle += theta;
		cx = w-cornerRadius+(Math.cos(angle+(theta/2))*cornerRadius/Math.cos(theta/2));
		cy = h-cornerRadius+(Math.sin(angle+(theta/2))*cornerRadius/Math.cos(theta/2));
		px = w-cornerRadius+(Math.cos(angle+theta)*cornerRadius);
		py = h-cornerRadius+(Math.sin(angle+theta)*cornerRadius);
		mc.curveTo(cx, cy, px, py);
		// draw bottom line
		mc.lineTo(cornerRadius, h);
		// draw bl corner
		angle += theta;
		cx = cornerRadius+(Math.cos(angle+(theta/2))*cornerRadius/Math.cos(theta/2));
		cy = h-cornerRadius+(Math.sin(angle+(theta/2))*cornerRadius/Math.cos(theta/2));
		px = cornerRadius+(Math.cos(angle+theta)*cornerRadius);
		py = h-cornerRadius+(Math.sin(angle+theta)*cornerRadius);
		mc.curveTo(cx, cy, px, py);
		angle += theta;
		cx = cornerRadius+(Math.cos(angle+(theta/2))*cornerRadius/Math.cos(theta/2));
		cy = h-cornerRadius+(Math.sin(angle+(theta/2))*cornerRadius/Math.cos(theta/2));
		px = cornerRadius+(Math.cos(angle+theta)*cornerRadius);
		py = h-cornerRadius+(Math.sin(angle+theta)*cornerRadius);
		mc.curveTo(cx, cy, px, py);
		// draw left line
		mc.lineTo(0, cornerRadius);
		// draw tl corner
		angle += theta;
		cx = cornerRadius+(Math.cos(angle+(theta/2))*cornerRadius/Math.cos(theta/2));
		cy = cornerRadius+(Math.sin(angle+(theta/2))*cornerRadius/Math.cos(theta/2));
		px = cornerRadius+(Math.cos(angle+theta)*cornerRadius);
		py = cornerRadius+(Math.sin(angle+theta)*cornerRadius);
		mc.curveTo(cx, cy, px, py);
		angle += theta;
		cx = cornerRadius+(Math.cos(angle+(theta/2))*cornerRadius/Math.cos(theta/2));
		cy = cornerRadius+(Math.sin(angle+(theta/2))*cornerRadius/Math.cos(theta/2));
		px = cornerRadius+(Math.cos(angle+theta)*cornerRadius);
		py = cornerRadius+(Math.sin(angle+theta)*cornerRadius);
		mc.curveTo(cx, cy, px, py);
		
	}
	
	
	/**
	 * Draws a wedge
	 * 
	 * Based on the drawMethods by Ric Ewing
	 * 		
	 * @param	clip
	 * @param	x centerpoint
	 * @param	y centerpoint
	 * @param	startAngle starting angle in degrees
	 * @param	arc sweep of the wedge
	 * @param	radius of wedge
	 * @param	yRadius optional yRadius
	 */
	public static function wedge(clip:MovieClip, x:Number, y:Number, startAngle:Number, arc:Number, radius:Number, yRadius:Number) {
		
		if (arguments.length<5) {
			return;
		}
		// move to x,y position
		clip.moveTo(x, y);
		// if yRadius is undefined, yRadius = radius
		if (yRadius == undefined) {
			yRadius = radius;
		}
		// Init vars
		var segAngle:Number;
		var theta:Number;
		var angle:Number;
		var angleMid:Number;
		var segs:Number;
		var ax:Number;
		var ay:Number;
		var bx:Number;
		var by:Number;
		var cx:Number;
		var cy:Number;
		
		// limit sweep to reasonable numbers
		if (Math.abs(arc)>360) {
			arc = 360;
		}
		// Flash uses 8 segments per circle, to match that, we draw in a maximum
		// of 45 degree segments. First we calculate how many segments are needed
		// for our arc.
		segs = Math.ceil(Math.abs(arc)/45);
		// Now calculate the sweep of each segment.
		segAngle = arc/segs;
		// The math requires radians rather than degrees. To convert from degrees
		// use the formula (degrees/180)*Math.PI to get radians.
			theta = -(segAngle/180)*Math.PI;
		// convert angle startAngle to radians
		angle = -(startAngle/180)*Math.PI;
		// draw the curve in segments no larger than 45 degrees.
		if (segs>0) {
			// draw a line from the center to the start of the curve
			ax = x+Math.cos(startAngle/180*Math.PI)*radius;
			ay = y+Math.sin(-startAngle/180*Math.PI)*yRadius;
			clip.lineTo(ax, ay);
			// Loop for drawing curve segments
			for (var i = 0; i<segs; i++) {
				angle += theta;
				angleMid = angle-(theta/2);
				bx = x+Math.cos(angle)*radius;
				by = y+Math.sin(angle)*yRadius;
				cx = x+Math.cos(angleMid)*(radius/Math.cos(theta/2));
				cy = y+Math.sin(angleMid)*(yRadius/Math.cos(theta/2));
				clip.curveTo(cx, cy, bx, by);
			}
			// close the wedge by drawing a line to the center
			clip.lineTo(x, y);
		}
		
		clip.endFill();
	}
	
	
}