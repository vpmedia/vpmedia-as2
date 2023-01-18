/**
 * com.sekati.ui.IScrollable
 * @version 1.0.0
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */
 
import com.sekati.core.CoreInterface;
/**
 * Interface describing {@link com.sekati.ui.Scroll} and other Scrollable ui classes.
 */
interface com.sekati.ui.IScrollable extends CoreInterface {
	function init():Void;
	function slideContent(pos:Number, sec:Number):Void;
	function slideScroller(pos:Number, sec:Number):Void;
	function isScrollable():Boolean;
	function isDragging():Boolean;
	function isMouseInArea():Boolean;
}