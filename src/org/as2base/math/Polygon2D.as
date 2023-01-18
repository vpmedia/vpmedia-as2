import org.as2base.math.*;

class org.as2base.math.Polygon2D extends Array
{
	function Polygon2D()
	{
		splice.apply( this , [ 0 , 0 ].concat( arguments ) );
	}
	
	function draw( timeline: MovieClip ): Void
	{
		var p: Number = length - 1;
		var l: Number = p;
		
		var pt: Point2D;
		
		timeline.moveTo( pt.x , ( pt = this[ p ] ).y );
		
		while( --p > -1 )
		{
			timeline.lineTo( pt.x , ( pt = this[ p ] ).y );
		}
		
		timeline.lineTo( pt.x , ( pt = this[ l ] ).y );
	}
	
	function clone( Void ) //-- UPCASTING NOT POSSIBLE ? return Polygon2D(this.slice(0));
	{
		return this.slice(0);
	}
	
	function toString( Void ): String
	{
		return '[Polygon2D]';
	}
}