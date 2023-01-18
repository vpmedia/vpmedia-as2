import com.jxl.shuriken.core.UIComponent;

class com.jxl.shuriken.utils.DrawUtils
{
	public static function drawBox(p_mc, p_x:Number, p_y:Number, p_width:Number, p_height:Number):Void
	{
		p_mc.moveTo(p_x, p_y);
		p_mc.lineTo(p_x + p_width, p_y);
		p_mc.lineTo(p_x + p_width, p_y + p_height);
		p_mc.lineTo(p_x, p_y + p_height);
		p_mc.lineTo(p_x, p_y);
	}
	
	public static function drawMask(p_mc:MovieClip, p_x:Number, p_y:Number, p_width:Number, p_height:Number):Void
	{
		p_mc.clear();
		p_mc.lineStyle(0, 0xFF0000);
		p_mc.beginFill(0x00FF00, 50);
		p_mc.move(p_x, p_y);
		p_mc.lineTo(p_width, 0);
		p_mc.lineTo(p_width, p_height);
		p_mc.lineTo(0, p_height);
		p_mc.lineTo(0, 0);
		p_mc.endFill();
	}
	
	public static function drawDashLineBox(p_mc:MovieClip, p_x:Number, p_y:Number, p_width:Number, p_height:Number, p_len:Number, p_gap:Number):Void
	{
		drawDashLine(p_mc, p_x, p_y, p_width, p_y, p_len, p_gap);
		drawDashLine(p_mc, p_x + p_width, p_y, p_width, p_height, p_len, p_gap);
		drawDashLine(p_mc, p_x + p_width, p_y + p_height, p_x, p_height, p_len, p_gap);
		drawDashLine(p_mc, p_x, p_y + p_height, p_x, p_y, p_len, p_gap);
	}
	
	public static function drawDashLine(p_mc:MovieClip, startx, starty, endx, endy, len, gap):Void
	{
		// ==============
		// mc.dashTo() - by Ric Ewing (ric@formequalsfunction.com) - version 1.2 - 5.3.2002
		// 
		// startx, starty = beginning of dashed line
		// endx, endy = end of dashed line
		// len = length of dash
		// gap = length of gap between dashes
		// ==============
		//
		// if too few arguments, bail
		if (arguments.length < 6) return;
		
		// init vars
		var seglength, deltax, deltay, segs, cx, cy, delta, radians;
		// calculate the legnth of a segment
		seglength = len + gap;
		// calculate the length of the dashed line
		deltax = endx - startx;
		deltay = endy - starty;
		delta = Math.sqrt((deltax * deltax) + (deltay * deltay));
		// calculate the number of segments needed
		segs = Math.floor(Math.abs(delta / seglength));
		// get the angle of the line in radians
		radians = Math.atan2(deltay,deltax);
		// start the line here
		cx = startx;
		cy = starty;
		// add these to cx, cy to get next seg start
		deltax = Math.cos(radians)*seglength;
		deltay = Math.sin(radians)*seglength;
		// loop through each seg
		for (var n = 0; n < segs; n++)
		{
			p_mc.moveTo(cx,cy);
			p_mc.lineTo(cx+Math.cos(radians)*len,cy+Math.sin(radians)*len);
			cx += deltax;
			cy += deltay;
		}
		// handle last segment as it is likely to be partial
		p_mc.moveTo(cx,cy);
		delta = Math.sqrt((endx-cx)*(endx-cx)+(endy-cy)*(endy-cy));
		if(delta>len){
			// segment ends in the gap, so draw a full dash
			p_mc.lineTo(cx+Math.cos(radians)*len,cy+Math.sin(radians)*len);
		} else if(delta>0) {
			// segment is shorter than dash so only draw what is needed
			p_mc.lineTo(cx+Math.cos(radians)*delta,cy+Math.sin(radians)*delta);
		}
		// move the pen to the end position
		p_mc.moveTo(endx,endy);
	}
	
	public static function drawRoundRect(p_mc:MovieClip, p_x:Number, p_y:Number, p_width:Number, p_height:Number, pCornerRadius:Number)
	{
		/*-------------------------------------------------------------
			mc.drawRoundRect is a method for drawing rectangles and
			rounded rectangles. Regular rectangles are
			sufficiently easy that I often just rebuilt the
			method in any file I needed it in, but the rounded
			rectangle was something I was needing more often,
			hence the method. The rounding is very much like
			that of the rectangle tool in Flash where if the
			rectangle is smaller in either dimension than the
			rounding would permit, the rounding scales down to
			fit.
		-------------------------------------------------------------*/
	
		// ==============
		// mc.drawRoundRect() - by Ric Ewing (ric@formequalsfunction.com) - version 1.1 - 4.7.2002
		// 
		// x, y = top left corner of rect
		// w = width of rect
		// h = height of rect
		// cornerRadius = [optional] radius of rounding for corners (defaults to 0)
		// ==============
		if (arguments.length<4) {
			return;
		}
		// if the user has defined cornerRadius our task is a bit more complex. :)
		if (pCornerRadius>0) {
			// init vars
			var theta, angle, cx, cy, px, py;
			// make sure that w + h are larger than 2*cornerRadius
			if (pCornerRadius>Math.min(p_width, p_height)/2) {
				pCornerRadius = Math.min(p_width, p_height)/2;
			}
			// theta = 45 degrees in radians
			theta = Math.PI/4;
			// draw top line
			p_mc.moveTo(p_x+pCornerRadius, p_y);
			p_mc.lineTo(p_x+p_width-pCornerRadius, p_y);
			//angle is currently 90 degrees
			angle = -Math.PI/2;
			// draw tr corner in two parts
			cx = p_x+p_width-pCornerRadius+(Math.cos(angle+(theta/2))*pCornerRadius/Math.cos(theta/2));
			cy = p_y+pCornerRadius+(Math.sin(angle+(theta/2))*pCornerRadius/Math.cos(theta/2));
			px = p_x+p_width-pCornerRadius+(Math.cos(angle+theta)*pCornerRadius);
			py = p_y+pCornerRadius+(Math.sin(angle+theta)*pCornerRadius);
			p_mc.curveTo(cx, cy, px, py);
			angle += theta;
			cx = p_x+p_width-pCornerRadius+(Math.cos(angle+(theta/2))*pCornerRadius/Math.cos(theta/2));
			cy = p_y+pCornerRadius+(Math.sin(angle+(theta/2))*pCornerRadius/Math.cos(theta/2));
			px = p_x+p_width-pCornerRadius+(Math.cos(angle+theta)*pCornerRadius);
			py = p_y+pCornerRadius+(Math.sin(angle+theta)*pCornerRadius);
			p_mc.curveTo(cx, cy, px, py);
			// draw right line
			p_mc.lineTo(p_x+p_width, p_y+p_height-pCornerRadius);
			// draw br corner
			angle += theta;
			cx = p_x+p_width-pCornerRadius+(Math.cos(angle+(theta/2))*pCornerRadius/Math.cos(theta/2));
			cy = p_y+p_height-pCornerRadius+(Math.sin(angle+(theta/2))*pCornerRadius/Math.cos(theta/2));
			px = p_x+p_width-pCornerRadius+(Math.cos(angle+theta)*pCornerRadius);
			py = p_y+p_height-pCornerRadius+(Math.sin(angle+theta)*pCornerRadius);
			p_mc.curveTo(cx, cy, px, py);
			angle += theta;
			cx = p_x+p_width-pCornerRadius+(Math.cos(angle+(theta/2))*pCornerRadius/Math.cos(theta/2));
			cy = p_y+p_height-pCornerRadius+(Math.sin(angle+(theta/2))*pCornerRadius/Math.cos(theta/2));
			px = p_x+p_width-pCornerRadius+(Math.cos(angle+theta)*pCornerRadius);
			py = p_y+p_height-pCornerRadius+(Math.sin(angle+theta)*pCornerRadius);
			p_mc.curveTo(cx, cy, px, py);
			// draw bottom line
			p_mc.lineTo(p_x+pCornerRadius, p_y+p_height);
			// draw bl corner
			angle += theta;
			cx = p_x+pCornerRadius+(Math.cos(angle+(theta/2))*pCornerRadius/Math.cos(theta/2));
			cy = p_y+p_height-pCornerRadius+(Math.sin(angle+(theta/2))*pCornerRadius/Math.cos(theta/2));
			px = p_x+pCornerRadius+(Math.cos(angle+theta)*pCornerRadius);
			py = p_y+p_height-pCornerRadius+(Math.sin(angle+theta)*pCornerRadius);
			p_mc.curveTo(cx, cy, px, py);
			angle += theta;
			cx = p_x+pCornerRadius+(Math.cos(angle+(theta/2))*pCornerRadius/Math.cos(theta/2));
			cy = p_y+p_height-pCornerRadius+(Math.sin(angle+(theta/2))*pCornerRadius/Math.cos(theta/2));
			px = p_x+pCornerRadius+(Math.cos(angle+theta)*pCornerRadius);
			py = p_y+p_height-pCornerRadius+(Math.sin(angle+theta)*pCornerRadius);
			p_mc.curveTo(cx, cy, px, py);
			// draw left line
			p_mc.lineTo(p_x, p_y+pCornerRadius);
			// draw tl corner
			angle += theta;
			cx = p_x+pCornerRadius+(Math.cos(angle+(theta/2))*pCornerRadius/Math.cos(theta/2));
			cy = p_y+pCornerRadius+(Math.sin(angle+(theta/2))*pCornerRadius/Math.cos(theta/2));
			px = p_x+pCornerRadius+(Math.cos(angle+theta)*pCornerRadius);
			py = p_y+pCornerRadius+(Math.sin(angle+theta)*pCornerRadius);
			p_mc.curveTo(cx, cy, px, py);
			angle += theta;
			cx = p_x+pCornerRadius+(Math.cos(angle+(theta/2))*pCornerRadius/Math.cos(theta/2));
			cy = p_y+pCornerRadius+(Math.sin(angle+(theta/2))*pCornerRadius/Math.cos(theta/2));
			px = p_x+pCornerRadius+(Math.cos(angle+theta)*pCornerRadius);
			py = p_y+pCornerRadius+(Math.sin(angle+theta)*pCornerRadius);
			p_mc.curveTo(cx, cy, px, py);
		}
		else
		{
			// cornerRadius was not defined or = 0. This makes it easy.
			p_mc.moveTo(p_x, p_y);
			p_mc.lineTo(p_x+p_width, p_y);
			p_mc.lineTo(p_x+p_width, p_y+p_height);
			p_mc.lineTo(p_x, p_y+p_height);
			p_mc.lineTo(p_x, p_y);
		}
	}
	
	public static function drawTriangle(p_mc:MovieClip, 
										p_x:Number, p_y:Number, 
										p_width:Number, p_height:Number,
										p_angle:Number):Void
	{
		p_angle = (p_angle == null) ? 0 : p_angle;
		
		switch(p_angle)
		{
			case 0:
				p_mc.moveTo(p_x, p_y);
				p_mc.lineTo(p_x + (p_width / 2), p_y - p_height);
				p_mc.lineTo(p_x + p_width, p_y);
				p_mc.lineTo(p_x, p_y);
				break;
			
			case 180:
				p_mc.moveTo(p_x, p_y);
				p_mc.lineTo(p_x + p_width, p_y);
				p_mc.lineTo(p_x + (p_width / 2), p_y + p_height);
				p_mc.lineTo(p_x, p_y);
				break;
		}
	}
	
}