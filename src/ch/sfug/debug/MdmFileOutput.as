import ch.sfug.debug.DebugOutput;

/**
 * a class that logs to a file with MDM Zinc<br>
 *
 * @author $LastChangedBy: $
 * @version $LastChangedRevision: $
 */
class ch.sfug.debug.MdmFileOutput implements DebugOutput {

	private var path:String;

	public function MdmFileOutput( filepath:String ) {
		if( this.isAbsolutPath( filepath ) ) {
			this.path = filepath;
		} else {
			this.path = ( filepath != undefined ) ? filepath : "log.txt";
		}
		this.clear();
	}

	/**
	 * implements interface
	 */
	public function append( txt:String ):Void {
		mdm.FileSystem.appendFile( this.path, txt + "\n\n" );
	}

	/**
	 * implements interface
	 */
	public function clear(  ):Void {
		mdm.FileSystem.saveFile( this.path, "" );
	}

	/**
	 * checks if the filepath is a absolut file path
	 */
	private function isAbsolutPath( path:String ):Boolean {
		return path.substr( 2, 3 ) == ":\\";
	}

}