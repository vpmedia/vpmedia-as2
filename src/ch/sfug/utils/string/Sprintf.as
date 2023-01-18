/**
 * @author loop
 */
class ch.sfug.utils.string.Sprintf {

	/**
	 * simple version doesn not check types just concats..
	 * replaces %n ( Number ) and %s ( String ) in a string with the passed arguments
	 */
	public static function format( txt:String ):String {
		var args:Array = arguments.slice( 1 );
		var fullsplit:Array = new Array();
		var res:String = "";
		var nsplit:Array = txt.split( "%n" );
		for (var i : Number = 0; i < nsplit.length; i++) {
			fullsplit = fullsplit.concat( nsplit[ i ].split( "%s" ) );
		}
		for (var i : Number = 0; i < fullsplit.length; i++) {
			if( args[ i ] != undefined ) {
				res += fullsplit[ i ] + args[ i ];
			} else {
				res += fullsplit[ i ];
			}
		}
		return res;

	}

}