
/**
 * com.sekati.log.Inspector
 * @version 1.0.5
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */

/**
 * Recursively inspect an Objects contents.
 * {@code Usage:
 * 	var a = ["a", "b", ["aa"], "BB", ["aaa", "BBB"], {joe:[833, 38]}];
 * 	trace( new Inspector(a) );
 * 	}
 * }
 * @see {@link com.sekati.validate.TypeValidation}
 */
class com.sekati.log.Inspector {

	private var _result:String;

	/**
	 * Constructor - passthru to {@link recurse} loop.
	 */
	public function Inspector() {
		_result = "";
		recurse.apply( this, arguments );
	}

	/**
	 * recursively stringify objects contents
	 * @param obj (Object) target object
	 * @param path (String) optional path to prepend for verbose output
	 * @param level (Number) optional level
	 * @param maxPathLength (Number) optional max path to be used with padding
	 * @return Void
	 */	
	private function recurse(obj:Object, path:String, level:Number, maxPathLength:Number):Void {
		var padding:String;
		var paddingChar:String = " ";
		var parentType:String;
		var currentType:String;
		var newPath:String;
		//defaults
		if (level == null) {
			level = 0;
		}
		if (path == null) {
			path = "";
		}
		//maxPathLength (only defined initially)   
		if (maxPathLength == null) {
			maxPathLength = paddingRecursion( obj, path ) + 3;
		}
		//calculate parents type   
		parentType = (obj instanceof Array) ? "array" : typeof (obj);
		for (var i in obj) {
			//calculate path
			newPath = (parentType == "array") ? path + "[" + i + "]" : path + "." + i;
			//calculate this type
			currentType = (obj[i] instanceof Array) ? "array" : typeof (obj[i]);
			//find how much padding is needed for this item to print
			padding = "";
			for (var j:Number = 0; j < maxPathLength - newPath.length ; j++) {
				padding += paddingChar;
			}
			_result += (newPath + padding + obj[i] + "  (" + currentType + ")\n");
			//go deeper
			recurse( obj[i], newPath, level + 1, maxPathLength );
		}
	}

	/**
	 * Recurse through everything to find what the biggest path string 
	 * will be - strictly for formatting purposes.
	 */
	private function paddingRecursion(obj:Object, path:String, longestPath:Number):Number {
		var parentType:String;
		if (longestPath == null) {
			longestPath = 0;
		}
		//calculate parents type   
		parentType = (obj instanceof Array) ? "array" : typeof (obj);
		for (var i in obj) {
			//this levels path
			var newPath:String = (parentType == "array") ? path + "[" + i + "]" : path + "." + i;
			if (newPath.length > longestPath) {
				longestPath = newPath.length;
			}
			//outside recursion   
			var outsideRecursion:Number = paddingRecursion( obj[i], newPath, longestPath );
			if (outsideRecursion > longestPath) {
				longestPath = outsideRecursion;
			}
		}
		return longestPath;
	}

	public function toString():String {
		return _result;	
	}
}