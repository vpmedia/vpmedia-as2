import ch.sfug.debug.DebugOutput;

/**
 * a main logger where you can attach different Loggers for textfield, trace etc..<br>
 *
 * @author $LastChangedBy: $
 * @version $LastChangedRevision: $
 */
class ch.sfug.debug.Debug {

	private static var instance:Debug;
	private var outputs:Array;
	private var rawlog:String;

	/**
	 * @return singleton instance of Logger
	 */
	public static function getInstance() : Debug {
		if (instance == null) instance = new Debug();
		return instance;
	}

	private function Debug() {
		this.outputs = new Array();
	}

	/**
	 * appends a new LoggerOutput to the logger
	 */
	public static function appendOutput( lo:DebugOutput ):Void {
		getInstance().addOutput( lo );
	}

	/**
	 * returns the whole log
	 */
	public static function getLogText(  ):String {
		return getInstance().getRawLog();
	}

	/**
	 * clears the log
	 */
	public static function clear(  ):Void {
		getInstance().clearLog();
	}

	/**
	 * append to the logger
	 */
	public static function log( msgobj:Object, clas:String, file:String, num:Number ):Void {
		var txt:String = msgobj.toString();
		if( clas != undefined ) txt += " class: " + clas;
		if( file != undefined ) txt += " file: " + file;
		if( num != undefined ) txt += " line number: " + num;
		getInstance().delegate( txt );
	}

	/**
	 * delegates the log append command
	 */
	public function delegate( txt:String ):Void {
		if( this.outputs.length > 0 ) {
			var d:Date = new Date();
			txt = d.getHours() + ":" + d.getMinutes() + ":" + d.getSeconds() + " : " + txt;
			this.rawlog = txt + "\n\n" + this.rawlog;
			for( var i:Number = 0; i < this.outputs.length; i++ ) {
				var log:DebugOutput = DebugOutput( this.outputs[ i ] );
				log.append( txt );
			}
		}
	}

	/**
	 * appends a logger to the Logger class
	 */
	public function addOutput( lo:DebugOutput ):Void {
		this.outputs.push( lo );
	}

	/**
	 * returns the raw log text
	 */
	public function getRawLog(  ):String {
		return this.rawlog;
	}

	/**
	 * clears the log
	 */
	public function clearLog(  ):Void {
		for( var i:Number = 0; i < this.outputs.length; i++ ) {
			var log:DebugOutput = DebugOutput( this.outputs[ i ] );
			log.clear(  );
		}
	}


}