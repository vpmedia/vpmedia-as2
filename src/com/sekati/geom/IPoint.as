/**
 * com.sekati.geom.IPoint
 * @version 1.0.5
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */
 
import com.sekati.core.CoreInterface;
import com.sekati.geom.Point;

/**
 * Interface describing {@link com.sekati.geom.Point}
 */
interface com.sekati.geom.IPoint extends CoreInterface {

	function isEqual(p:Point):Boolean;

	function getDistance(p:Point):Number;

	function displace(nX:Number, nY:Number):Point;

	function offset(x:Number, y:Number):Void;

	function clone():Point;
}