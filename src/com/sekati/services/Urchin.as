/**
 * com.sekati.services.Urchin
 * @version 2.0.3
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */
 
import com.sekati.core.App;
import flash.external.ExternalInterface;

/**
 * Easily add Google Analytics (Urchin) tracking of Flash events
 * 
 * {@code Usage:
 * // Add google analytics javascript to your swf html page:
 * <script src="http://www.google-analytics.com/urchin.js" type="text/javascript"></script>
 * <script type="text/javascript">
 * _uacct = "UA-000000-0";
 * urchinTracker();
 * </script>
 * // enable swLiveConnect:
 * fscommand ("swLiveConnect", "true");
 * }
 * @see <a href="http://www.google.com/support/analytics/bin/answer.py?answer=27243&hl=en">http://www.google.com/support/analytics/bin/answer.py?answer=27243&hl=en</a>
 */
class com.sekati.services.Urchin {

	private static var _base:String = '/swf/';

	/**
	 * set site base
	 * @return Void
	 * {@code Usage:
	 *  Urchin.setBase("homepage"); // set optional webroot [default: "site"]
	 * }
	 */
	public static function setBase(base:String):Void {
		_base = (base) ? '/' + base + '/' : _base;
	}

	/**
	 * return site base
	 * @return String
	 */
	public static function getBase():String {
		return (_base);
	}

	/**
	 * track a page event
	 * @return Void
	 * {@code Usage
	 * 	Urchin.track("projects"); // register '/homepage/projects'
	 * 	Urchin.track("projects/page1");	// register '/homepage/projects/page1'
	 * }
	 */
	public static function track(pg:String):Void {
		if( !App.TRACK_ENABLE ) return;
		var pv:String = _base + pg;
		App.log.info( "Urchin", "* Urchin.track ('" + pv + "')" );
		ExternalInterface.call( "urchinTracker", pv );
	}

	private function Urchin() {
	}
}