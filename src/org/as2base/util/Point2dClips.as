import org.as2base.math.Point2D;

class org.as2base.util.Point2dClips extends MovieClip
{
	static function attach( timeline: MovieClip, linkageId: String ): Point2D
	{
		Object.registerClass( linkageId , Point2dClips );
		
		var d: Number = timeline.getNextHighestDepth();
		
		return timeline.attachMovie.call( timeline, linkageId, d.toString(), d );
	}
	
	function Point2dClips()
	{
		_global.ASSetPropFlags( Point2D.prototype , null , 8 , 1 );
		
		for( var i in Point2D.prototype )
		{
			if( i != '__proto__' && i != 'constructor' )
			{
				this[i] = Point2D.prototype[i];
			}
		}
		
		_global.ASSetPropFlags( Point2D.prototype , null , 7 );
	}
	function onLoad( Void ): Void
	{
		onPress = startDrag;
		onRelease = onReleaseOutside = stopDrag;
	}
	
	function get x(): Number
	{
		return _x;
	}
	
	function get y(): Number
	{
		return _y;
	}
	
	function set x( x: Number ): Void
	{
		_x = x;
	}
	
	function set y( y: Number ): Void
	{
		_y = y;
	}
}