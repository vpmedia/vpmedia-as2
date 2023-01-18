import ch.sfug.events.ErrorEvent;
import ch.sfug.events.Event;
import ch.sfug.net.loader.AbstractLoader;

import TextField.StyleSheet;

/**
 * @author loop
 *
 * a class that loads a css stylesheet
 */
class ch.sfug.net.loader.CSSLoader extends AbstractLoader {

	private var css:StyleSheet;

	/**
	 * creates an xml loader
	 */
	public function CSSLoader( url:String )	{
		super( url );
		css = new StyleSheet();
		var t:CSSLoader = this;
		css.onLoad = function( suc:Boolean ) {
			t.onLoad( suc );
		};
	}

	/**
	 * starts the download the css file
	 */
	public function load( url:String ):Void {
		this.url = url;
		css.load( _url );
	}

	/**
	 * returns the css file
	 */
	public function getCSS(  ):StyleSheet {
		return css;
	}

	/**
	 * catch the event from the css to dispatch the complete event or errorevent
	 */
	private function onLoad( success:Boolean ):Void {
		if( success ) {
			dispatchEvent( new Event( Event.COMPLETE ) );
		} else {
			dispatchEvent( new ErrorEvent( ErrorEvent.ERROR, "could not load css file: " + _url ) );
		}
	}
}