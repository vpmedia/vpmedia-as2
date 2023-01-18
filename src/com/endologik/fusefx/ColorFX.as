import com.gskinner.geom.ColorMatrix;
import com.mosesSupposes.fuse.FuseFMP;
import com.mosesSupposes.fuse.FuseKitCommon;
import com.mosesSupposes.fuse.ZigoEngine;
import com.mosesSupposes.fusefx.FuseFX;
import com.mosesSupposes.fusefx.FXProperty;
import com.mosesSupposes.fusefx.IFuseFX;

import flash.filters.ColorMatrixFilter;


/**
 * ColorFX by Graeme Asher. March 11, 2007.
 * ColorFX is free.  Please read the licenses of the supporting classes used by ColorFX.
 * ColorFX is a FuseFX extension that adds four Flash8-style ColorTransforms 
 * (brightness, contrast, saturation, hue) to ZigoEngine & Fuse.
 * ColorFX uses Grant Skinner's ColorMatrix utility.
 *
 * <br><br>
 * ColorFX assumes the target is a MovieClip. 
 * ColorFX assumes the target is in its default/base color state on 1st use.  
 * ColorFX assumes that the targets bitmap values are not being manipulated externally 
 * during or between ColorFX tweening. This can create inaccurate tweening.
 * <br><br>
 * 
 * @author  Graeme Asher - info@endologik.com
 * @version 0.3
 * @useage	ZigoEngine.doTween and Fuse examples.
 * <pre>
 * 			ZigoEngine.doTween(
 * 				mcTest,
 * 				ColorFX.BRIGHTNESS, 
 * 				-35, 
 * 				2, 
 * 				"easeInOutQuint"
 * 			);
 *
 * 			var f:Fuse = new Fuse();
 * 			f.push({
 * 				target:mcTest,
 * 				brightnessFX:100, 
 * 				contrastFX:100, 
 * 				saturationFX:100, 
 * 				hueFX:180, 
 * 				time:2,
 * 				ease:"easeInOutQuint"
 * 			});
 * </pre>
 */
 
 
class com.endologik.fusefx.ColorFX implements IFuseFX {

	public static var BRIGHTNESS:String = 'brightnessFX';
	public static var CONTRAST:String = 'contrastFX';
	public static var SATURATION:String = 'saturationFX';
	public static var HUE:String = 'hueFX';
	
	private var _prop:String;
	private var _reqVerFuseFX:Number = 0.3;
	
	
	/**
	 * Required by IFuseFX for compliance with FuseFX.
	 * @return	An array of FXProperty objects.
	 */
	public function defineProperties():Array 
	{
		// Check version.
		if(FuseFX.VERSION == undefined || FuseFX.VERSION < _reqVerFuseFX) 
		{
			FuseKitCommon.output("* ColorFX compliance error:  This version of ColorFX requires FuseFX " + _reqVerFuseFX + " or greater.  Download the latest version at http://www.mosessupposes.com/Fuse/FuseFX.html *");
			return null;
		}
		// Define properties.	
		var a:Array = [];
		a.push( new FXProperty(ColorFX, BRIGHTNESS, FuseKitCommon.ALLCOLOR) );
		a.push( new FXProperty(ColorFX, CONTRAST, FuseKitCommon.ALLCOLOR) );
		a.push( new FXProperty(ColorFX, SATURATION, FuseKitCommon.ALLCOLOR) );
		a.push( new FXProperty(ColorFX, HUE, FuseKitCommon.ALLCOLOR) );
		return a;
	}
	
	
	/**
	 * Required by IFuseFX for compliance with FuseFX.
	 * Setup, called just prior to tweening.
	 *  
	 * @param target	The tween target object (not necessary to store a hard reference!)
	 * @param prop		The tween property which has been pre-verified as one of this extension's keys.
	 * @param endval	The tween end-value passed by the user (for special cases like type checking)
	 */
	public function addTween(target:Object, prop:String, endval:Object):Boolean 
	{
		// Test compliance. Only allow MovieClips.
		if(!(target instanceof MovieClip)) 
		{
			FuseKitCommon.output("* ColorFX tween failed: the tweenable target must be a MovieClip. *"); 
			return false;
		}
		// Set the tweenable property.
		this._prop = prop;
		// Set default values if none exist for ZigoEngine compliance.
		if(!target[_prop]) target[_prop] = 0;
		// Remove any Flash 7 color tweens that are running on the target.
		ZigoEngine.removeTween(target, FuseKitCommon.ALLCOLOR);
		// Hides the properties from for-in loops.
		_global.ASSetPropFlags(target, _prop, 3, 1);
		return true;
	}


	/**
	 * Required by IFuseFX for compliance with FuseFX.
	 * Standard event fired by the engine on its update pulse just after updating the property. 
	 * @param	o	Event object sent by engine containing {target:Object, props:Array}.
	 */
	public function onTweenUpdate(o:Object):Void 
	{
		var cm:ColorMatrix = new ColorMatrix();
		cm.adjustColor(o.target.brightnessFX, o.target.contrastFX, o.target.saturationFX, o.target.hueFX);
		var cmf:ColorMatrixFilter = new ColorMatrixFilter(cm);
		FuseFMP.writeFilter(o.target, cmf);
	}


	/**
	 * Required by IFuseFX for compliance with FuseFX.
	 * Cleanup, called just prior to deletion.
	  * @param target	The original tween target, which may be missing. Passed to enable extensions to 
	 * 					avoid storing a hard reference to tween targets.
	 */
	public function destroy(target:Object):Void 
	{
		// Makes the property deletable again.
		_global.ASSetPropFlags(target, _prop, 0, 2);
 		// Don't delete properties from targets, so they can be reused.
	}
}