/**
 * com.sekati.utils.AlignUtils
 * @version 1.0.6
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */
 
import com.sekati.display.StageDisplay;

/**
 * Static class wrapping various Alignment and Scale utilities.
 */
class com.sekati.utils.AlignUtils {

	/**
	 * center align object to target
	 */
	public static  function alignCenter(item:Object,target:Object):Void {
		xAlignCenter( item, target );
		yAlignCenter( item, target );
	}

	/**
	 * horizontal center align object to target
	 */
	public static  function xAlignCenter(item:Object,target:Object):Void {
		item._x = int( target._width / 2 - item._width / 2 );
	}

	/**
	 * vertical  center  align object to target
	 */
	public static  function yAlignCenter(item:Object,target:Object):Void {
		item._y = int( target._height / 2 - item._height / 2 );
	}

	/**
	 * right align object to target
	 */
	public static  function alignRight(item:Object,target:Object):Void {
		xAlignRight( item, target );
		yAlignRight( item, target );
	}

	/**
	 * horizontal right align object to target
	 */
	public static  function xAlignRight(item:Object,target:Object):Void {
		item._x = int( target._width - item._width );
	}

	/**
	 * vertical right align object to target
	 */
	public static  function yAlignRight(item:Object,target:Object):Void {
		item._y = int( target._height - item._height );
	}

	/**
	 * left align object to target
	 */
	public static  function alignLeft(item:Object,target:Object):Void {
		xAlignLeft( item, target );
		yAlignLeft( item, target );
	}

	/**
	 * horizontal left align object to target
	 */	
	public static  function xAlignLeft(item:Object,target:Object):Void {
		item._x = int( target._x );
	}

	/**
	 * vertical left  align object to target
	 */	
	public static  function yAlignLeft(item:Object,target:Object):Void {
		item._y = int( target._y );
	}

	/**
	 * center align object to Stage
	 */
	public static  function stageAlignCenter(item:Object):Void {
		stageAlignXCenter( item );
		stageAlignYCenter( item );
	}

	/**
	 * horizontal center align object to Stage
	 */
	public static  function stageAlignXCenter(item:Object):Void {
		item._x = int( StageDisplay.$._width / 2 - item._width / 2 );
	}

	/**
	 * vertical  center align object to Stage
	 */
	public static  function stageAlignYCenter(item:Object):Void {
		item._y = int( StageDisplay.$._height / 2 - item._height / 2 );
	}

	/**
	 * Align object to Stage right
	 */
	public static  function stageAlignRight(item:Object):Void {
		item._x = int( StageDisplay.$._width - item._width );
	}

	/**
	 * Align object to Stage bottom
	 */
	public static  function stageAlignBottom(item:Object):Void {
		item._y = int( StageDisplay.$._height - item._height );
	}

	/**
	 * set scale wrapper
	 * @param item (Object) item to be scaled 
	 * @param scale (Number) scale percentage [0-100]
	 * @return Void
	 */
	public static  function scale(item:Object,scale:Number):Void {
		item._xscale = scale,
		item._yscale = scale;
	}

	/**
	 * scale target item to fit within target confines
	 * @param item (Object) item to be aligned 
	 * @param targetW (Number) target item width
	 * @param targetH (Number) target item height
	 * @param center (Boolean) center object
	 * @return Void
	 */
	public static  function scaleToFit(item:Object,targetW:Number,targetH:Number,center:Boolean):Void {
		if (item._width < targetW && item._width > item._height) {
			item._width = targetW;
			item._yscale = item._xscale;
		} else {
			item._height = targetH;
			item._xscale = item._yscale;
		}
		if (center) {
			item._x = int( targetW / 2 - item._width / 2 );
			item._y = int( targetH / 2 - item._height / 2 );
		}
	}

	/**
	 * scale while retaining original w:h ratio
	 * @param item (Object) item to be scaled
	 * @param targetW (Number) target item width
	 * @param targetH (Number) target item height
	 * @return Void
	 */
	public static  function scaleRatio(item:Object,targetW:Number,targetH:Number):Void {
		if (targetW / targetH < item._height / item._width) {
			targetW = targetH * item._width / item._height;
		} else {
			targetH = targetW * item._height / item._width;
		}
		item._width = targetW;
		item._height = targetH;
	}

	/**
	 * flip object on an axis
	 * @param obj (Object) item to flip
	 * @param axis (String) axis to flip on ["_x" or "_y"]
	 * @return Void
	 * @throws Error on invalid axis 
	 */
	public static  function flip(obj:Object,axis:String):Void {
		if (axis != "_x" && axis != "_y") {
			throw new Error( "@@@ com.sekati.utils.AlignUtils.flip() Error: expects axis param: '_x' or '_y'." );
			return;
		}
		var _scale:String = axis == "_x" ? "_xscale" : "_yscale";
		var _prop:String = axis == "_x" ? "_width" : "_height";
		obj[_scale] = -obj[_scale];
		obj[axis] -= obj[_prop];
	}

	private function AlignUtils() {
	}
}