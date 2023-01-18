/**
 * @author loop
 */
class ch.sfug.utils.mc.MCManger {

	public static var HOLDER:MovieClip;
	private static var depth:Number = 0;

	/**
	 * returns an empty movieclip that doesnt mess up with others.
	 */
	public static function getMC( name:String ):MovieClip {
		if( name == undefined ) name = "m" + depth;
		var holder:MovieClip = getHolder();
		if( holder[ name ] == undefined ) {
			return holder.createEmptyMovieClip( name, depth++ );
		} else {
			return holder[ name ];
		}
	}

	/**
	 * returns the root holder mc
	 */
	private static function getHolder(  ):MovieClip {
		if( HOLDER == undefined ) HOLDER = _root.createEmptyMovieClip( "sfug_holder", 346271 );
		return HOLDER;
	}

}