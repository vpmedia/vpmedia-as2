class wilberforce.geom.vector2D
{

	var x:Number;
	var y:Number;
	
	function vector2D(tx:Number,ty:Number)
	{
		if (tx) {x=tx;} else {x=0;}
		if (ty) {y=ty;} else {y=0;}
	}
	
	function clone():vector2D
	{
		return new vector2D(x,y);
	}
	
	function addVector(vector:vector2D)
	{
		x+=vector.x;
		y+=vector.y;
	}
	
	function mult(factor:Number)
	{
		x*=factor;
		y*=factor;
	}
	
	function normalise():Void
	{
		var tLength=length;
		x/=tLength;
		y/=tLength;
	}
	function get length():Number
	{
		return Math.sqrt(x*x+y*y);
	}
	
	function distanceTo(tVector:vector2D):Number
	{
		var dx:Number=tVector.x-x;
		var dy:Number=tVector.y-y;
		return Math.sqrt(dx*dx+dy*dy);
	}
	
	function dot(tVector:vector2D ):Number
	{
		// Clone
		var v1:vector2D=this.clone();
		var v2:vector2D=tVector.clone();
		
		// Normalise
		v1.normalise();
		v2.normalise();
		
		return v1.x*v2.x+v1.y*v2.y;
	}
	
	function rotate(tAngle:Number):Void {
		var newx:Number = Math.cos(tAngle) * x - Math.sin(tAngle) * y;
		var newy:Number = Math.cos(tAngle) * y + Math.sin(tAngle) * x;
		x=newx
		y=newy;
	}
	
	function rotateAboutPoint(tPoint:vector2D,tAngle:Number)
	{
		// Move to origin
		x-=tPoint.x;
		y-=tPoint.y;
		
		rotate(tAngle);
		
		// Move back to area around point
		x+=tPoint.x;
		y+=tPoint.y;
	}
}