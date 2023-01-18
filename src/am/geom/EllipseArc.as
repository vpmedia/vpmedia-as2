import am.geom.*;

class am.geom.EllipseArc extends Ellipse
{

	var startAngle: Number;
	var endAngle: Number;

	function EllipseArc ( x: Number, y: Number, xRadius: Number, yRadius: Number, startAngle: Number, endAngle: Number )
	{
		this.x = x;
		this.y = y;
		this.xRadius = xRadius;
		this.yRadius = yRadius;
		this.startAngle = startAngle;
		this.endAngle = endAngle;
	}

	function draw( mc: MovieClip ):Void
	{
		var segAngle, theta, angle, angleMid, segs, ax, ay, bx, by, cx, cy;
		var arc = endAngle - startAngle;
		segs = Math.ceil(Math.abs(arc)/(Math.PI/4));
		segAngle = arc/segs;
		theta = segAngle;
		angle = startAngle;
		ax = x + Math.cos( angle ) * xRadius;
		ay = y + Math.sin( angle ) * yRadius;
		mc.moveTo ( ax ,ay )
		if ( segs > 0 )
		{
			for (var i = 0; i<segs; i++)
			{
				angle += theta;
				angleMid = angle-(theta/2);
				bx = x+Math.cos(angle)*xRadius;
				by = y+Math.sin(angle)*yRadius;
				cx = x+Math.cos(angleMid)*(xRadius/Math.cos(theta/2));
				cy = y+Math.sin(angleMid)*(yRadius/Math.cos(theta/2));
				mc.curveTo(cx, cy, bx, by);
			}
		}
	}

	public function toString(): String
	{
		return "[class 'EllipseArc' x: " + x + " y: " + y + " xRadius: " + xRadius + " yRadius: " + yRadius + " ]";
	}


}