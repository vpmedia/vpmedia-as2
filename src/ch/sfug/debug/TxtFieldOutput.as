import ch.sfug.debug.DebugOutput;

/**
 * traces the log to the textfield. only the newest log entry will be displayed if you have a one line textfield<br>
 *
 * @author $LastChangedBy: $
 * @version $LastChangedRevision: $
 */
class ch.sfug.debug.TxtFieldOutput implements DebugOutput {

	private var txtfield:TextField;
	private var ishtml:Boolean;

	public function TxtFieldOutput( txtfield:TextField, html:Boolean ) {
		this.ishtml = ( html != undefined ) ? html : false;
		this.txtfield = txtfield;
	}

	/**
	 * appends the nex text
	 */
	public function append( txt:String ):Void {
		if( this.ishtml ) {
			this.txtfield.htmlText = txt + "\n" + this.txtfield.text;
		} else {
			this.txtfield.text = txt + "\n" + this.txtfield.text;
		}
	}

	/**
	 * implements interface
	 */
	public function clear(  ):Void {
		if( this.ishtml ) {
			this.txtfield.htmlText = "";
		} else {
			this.txtfield.text = "";
		}
	}
}