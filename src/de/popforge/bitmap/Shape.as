class de.popforge.bitmap.Shape extends MovieClip
{
	static var id: String = '__Packages.de.popforge.bitmap.Shape';
	
	static private var container: MovieClip;
	
	static public function setContainer( container: MovieClip ): Void
	{
		Shape.container = container;
		Object.registerClass( id, Shape );
	}
	
	static public function get(): Shape
	{
		if( container == undefined )
		{
			return null;
		}
		
		var d: Number = container.getNextHighestDepth();
		
		return Shape( container.attachMovie( id, d.toString(), d ) );
	}
}