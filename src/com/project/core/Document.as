/**
 * com.sekati.core.Document
 * @version 1.0.5
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */

import com.project.core.Bootstrap;
import com.sekati.display.BaseClip;
import com.sekati.log.Logger;
import caurina.transitions.properties.*;

/**
 * Document controller simulates an AS3 DocumentClass
 * {@code Usage on first _root frame:
 * Document.main(this);
 * }
 * @see {@link com.sekati.core.App}
 */
class com.project.core.Document extends BaseClip {

	public var log:Logger;
	private var bootstrap:Bootstrap;

	/**
	 * Constructor
	 */
	private function Document() {
		super( );
		init( );
	}

	/**
	 * Link the Document class to the _root timeline via constructor simulating an AS3 document class.
	 * @param target (MovieClip)
	 * @return Void
	 */
	public static function main(target:MovieClip):Void {
		target.__proto__ = Document.prototype;
		Function( Document ).apply( target, null );
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
		//trace( "*** Setting Movie Properties ..." );
		System.security.allowInsecureDomain( "*" );
		System.security.allowDomain( "*" );
		fscommand( "swLiveConnect", "true" );
		fscommand( "allowscale", "false" );
		fscommand( "showmenu", "false" );
		fscommand( "fullscreen", "false" );
		Stage.align = "TL";
		Stage.scaleMode = "noScale";
		_quality = "HIGH";
		_focusrect = false;
	}

	/**
	 * centralize class compositions for core functionalities (Stage, ContextMenu, misc Managers)
	 * @return Void
	 */
	private function buildCompositions():Void {
		trace( "*** - Document Initialized ..." );
		bootstrap = new Bootstrap( );
		
		log = Logger.getInstance( );
		log.isIDE = true;
		log.isLC = true;
		log.isSWF = false;
		
		// Tweener initialization ...
		FilterShortcuts.init( );
		ColorShortcuts.init( );
		DisplayShortcuts.init( );
		TextShortcuts.init( );
		SoundShortcuts.init( );	
	}
}