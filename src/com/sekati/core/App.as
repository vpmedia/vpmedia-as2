 /**
 * com.sekati.core.App
 * @version 5.0.0
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */

import com.sekati.events.Broadcaster;
import com.sekati.log.Logger;
import com.sekati.net.NetBase;
import com.sekati.ui.ContextualMenu;
import TextField.StyleSheet;

/**
 * App is -the- static class for centralizing & storing core application instances, 
 * listeners, broadcasters, debuggers, objects, vars & constants.
 * 
 * PLEASE NOTE: This class no longer requires any initialization:
 * @see com.project.core.Bootstrap
 */
class com.sekati.core.App {

	public static var VERSION:String = 'SASAPI v1.0.0 | http://sasapi.googlecode.com | http://sekati.com';
	public static var AUTHOR:String = 'Copyright (C) 2007  jason m horwitz, sekati.com, Sekat LLC. All Rights Reserved.';
	
	public static var APP_NAME:String;
	public static var PATH:String = ( NetBase.isOnline( ) ) ? NetBase.getPath( ) : "";
	public static var CONF_URI:String = ( !_root.conf_uri ) ? App.PATH + "xml/config.xml" : _root.conf_uri;
	public static var CROSSDOMAIN_URI:String;
	public static var DATA_URI:String;
	public static var CSS_URI:String;

	public static var DEBUG_ENABLE:Boolean;
	public static var FLINK_ENABLE:Boolean;
	public static var TRACK_ENABLE:Boolean;
	public static var KEY_ENABLE:Boolean;
	public static var FLV_BUFFER_TIME:Number;
	
	public static var log:Logger;
	public static var bc:Object = Broadcaster.getInstance( );
	public static var db:Object = new Object( );
	public static var css:TextField.StyleSheet = new StyleSheet( );
	public static var cmenu:ContextualMenu = new ContextualMenu ( _root );
	
	/**
	 * Private Constructor
	 */
	private function App() {
	}
}