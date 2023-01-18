/**
 * com.sekati.log.ConsoleDocument
 * @version 1.0.7
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */

import com.sekati.display.BaseClip;
import com.sekati.log.Console;

/**
 * ConsoleDocument controller simulates an AS3 DocumentClass
 * {@code Usage on first _root frame:
 * ConsoleDocument.main(this);
 * }
 */
class com.sekati.log.ConsoleDocument extends BaseClip {

	/**
	 * Constructor
	 */
	private function ConsoleDocument() {
		super( );
		init( );
	}

	/**
	 * Link the ConsoleDocument class to the _root timeline via constructor simulating an AS3 document class.
	 * @param target (MovieClip)
	 * @return Void
	 */
	public static function main(target:MovieClip):Void {
		target.__proto__ = ConsoleDocument.prototype;
		Function( ConsoleDocument ).apply( target, null );
	}

	/**
	 * General movie setup and class compositions.
	 * @return Void
	 */
	private function init():Void {
		setMovieProps( );
		buildCompositions( );
	}

	/**
	 * general movie setup
	 * @return Void
	 */
	private function setMovieProps():Void {
		System.security.allowInsecureDomain( "*" );
		System.security.allowDomain( "*" );
		fscommand( "swLiveConnect", "true" );
		fscommand( "allowscale", "false" );
		fscommand( "showmenu", "false" );
		fscommand( "fullscreen", "false" );
		Stage.align = "TL";
		Stage.scaleMode = "noScale";
		_quality = "LOW";
		_focusrect = false;
	}

	/**
	 * centralize class compositions for core functionalities (Stage, ContextMenu, misc Managers)
	 * @return Void
	 */
	private function buildCompositions():Void {
		Console.getInstance( );
	}
}