import ch.sfug.lang.ILanguageSource;
/**
 * @author loop
 */
class ch.sfug.lang.Language {

	private static var source:ILanguageSource;
	public static var ACTIVE:String;

	/**
	 * returns a translated keyword
	 */
	public static function get( key:String ):String {
		return source.get( key );
	}

	/**
	 * sets the source for translated key words
	 */
	public static function setSource( src:ILanguageSource ):Void {
		source = src;
	}

	/**
	 * returns the source
	 */
	public static function getSource(  ):ILanguageSource {
		return source;
	}

}