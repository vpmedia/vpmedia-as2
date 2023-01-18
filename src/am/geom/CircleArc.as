import am.geom.*;

class am.geom.CircleArc extends Circle {

	var startAngle: Number;
	var endAngle: Number;

	function CircleArc ( x: Number, y: Number, radius: Number, startAngle: Number, endAngle: Number )
	{
		this.x = x;
		this.y = y;
		this.radius = radius;
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
		ax = x + Math.cos( angle ) * radius;
		ay = y + Math.sin( angle ) * radius;
		mc.moveTo ( ax ,ay )
		if ( segs > 0 )
		{
			for (var i = 0; i<segs; i++)
			{
				angle += theta;
				angleMid = angle-(theta/2);
				bx = x+Math.cos(angle)*radius;
				by = y+Math.sin(angle)*radius;
				cx = x+Math.cos(angleMid)*(radius/Math.cos(theta/2));
				cy = y+Math.sin(angleMid)*(radius/Math.cos(theta/2));
				mc.curveTo(cx, cy, bx, by);
			}
		}
	}

	function toString(): String
	{
		return "[class 'CircleArc' x: " + x + " y: " + y + " radius: " + radius + " ]";
	}
}