/**
 * com.sekati.core.FWDepth
 * @version 1.0.3
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */
 
/**
 * FrameWork Depth Manager to avoid collisions, uses negative depths for safety where appropriate
 */
class com.sekati.core.FWDepth {

	public static var ExpressInstall:Number = 10000000;
	public static var BaseLoader:Number = 15999;
	public static var FramePulse:Number = -666;
	public static var FLVAudioContainer:Number = -667;
	public static var SoundCenter:Number = -668;
	public static var ScreenProtector:Number = 9996;
	public static var FauxView:Number = 9995;

	private function FWDepth() {
	}
}