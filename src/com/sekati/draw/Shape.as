/**
 * com.sekati.draw.Shape
 * @version 1.0.0
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */

import com.sekati.display.BaseClip;
import com.sekati.draw.*;
import com.sekati.utils.ClassUtils;

/**
 * Shape is the core class for 
 * creating clips of drawn shapes.
 */
class com.sekati.draw.Shape {

	private var _mc:MovieClip;

	/**
	 * Shape Constructor
	 * @param target (MovieClip)
	 * @param initObject (Object) object of properties to create MovieClip with. Depth will automatically be created if none is specified
	 * @return Void
	 */
	public function Shape(target:MovieClip, initObject:Object) {
		_mc = ClassUtils.createEmptyMovieClip( com.sekati.display.BaseClip, target, "__Shape", initObject );
	}
}