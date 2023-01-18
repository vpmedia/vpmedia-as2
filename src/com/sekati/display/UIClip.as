/**
 * com.sekati.display.UIClip
 * @version 1.0.3
 * @author jason m horwitz | sekati.com | tendercreative.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */

import com.sekati.display.EventClip;
import com.sekati.display.TextDisplay;

/**
 * UIClip - any clip which needs to respond to StageResize or StageResizeComplete (delayed) events to create Liquid Layout 
 * via {@link com.sekati.events Dispatcher} which extends {@link com.sekati.display.EventClip} for Broadcaster event core. Class
 * also adds some wrappers to {@link com.sekati.display.TextDisplay} for automatic styling.
 */
class com.sekati.display.UIClip extends EventClip {

	/**
	 * Constructor
	 */
	public function UIClip() {
		super( );
		TextDisplay.clear( _this );
	}

	/**
	 * Application has been Configured (Config & Data loaded).
	 * NOTE: Automatically applies the application stylesheet to all TextField Objects!
	 * @return Void
	 */
	public function onAppConfigured():Void {
		TextDisplay.style( _this );
	}	
}