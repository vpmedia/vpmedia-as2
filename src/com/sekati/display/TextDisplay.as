/**
 * com.sekati.display.TextDisplay
 * @version 1.1.0
 * @author jason m horwitz | sekati.com | tendercreative.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */

import com.sekati.core.App;
import com.sekati.effects.TextEffects;
import com.sekati.effects.AnimHandler;
import com.sekati.transitions.Mot;
import com.sekati.validate.TypeValidation;
/**
 * TextDisplay - utilities for uniformly styling, clearing, and animating text in display clip classes.
 */
class com.sekati.display.TextDisplay {
	/**
	 * Clear all textfields in the object
	 * @param o (MovieClip)
	 * @return Void
	 */	
	public static function clear(o:MovieClip):Void {
		for(var i in o) { 			if (TypeValidation.isTextField( o[i] )) o[i].htmlText = ""; 		}			
	}
	/**
	 * Apply the App.css stylesheet to all textfields in the object.
	 * @param o (MovieClip)
	 * @return Void
	 */
	public static function style(o:MovieClip):Void {
		for(var i in o) { 			if (TypeValidation.isTextField( o[i] ) && !o[i].styleSheet) o[i].styleSheet = App.css; 		}		
	}
	/**
	 * Apply stylesheet to text and intro string.
	 * @param tf (TextField)
	 * @param str (String)
	 * @return Void
	 */
	public static function show(tf:TextField, str:String):Void {
		if (!tf.styleSheet) tf.styleSheet = App.css;
		tf.htmlText = str;
	}
	/**
	 * Hide a textfield (visible false, alpha 0)
	 * @param o (Array) - array of textfields or individual field
	 * @param isAnim (Boolean) - animate the transition
	 * @return Void
	 * @see TextDisplay.reveal()
	 */
	public static function hide(o:Array, isAnim:Boolean):Void {
		if (TypeValidation.isArray( o )) {
			for(var i:Number = 0; i < o.length ; i++) { 
				if (TypeValidation.isTextField( o[i] )) {
					o[i].stopTween( );
					if (!isAnim) {
						o[i]._alpha = 0;
						o[i]._visible = false;
					} else {
						o[i].alphaTo( 0, 1, Mot.o.quint, 0.1 * i, function():Void { 							o[i]._visible = false; 						} );	
					}
				}
			}	
		}
	}
	/**
	 * Reveal a textfield (visible true, alpha 100)
	 * @param o (Array) - array of textfields
	 * @param isAnim (Boolean) - animate the transition
	 * @return Void
	 * @see TextDisplay.hide()
	 */
	public static function reveal(o:Array, isAnim:Boolean):Void {
		if (TypeValidation.isArray( o )) {
			for(var i:Number = 0; i < o.length ; i++) { 
				if (TypeValidation.isTextField( o[i] )) {
					o[i].stopTween( );
					if(!isAnim) {
						o[i]._alpha = 100;
						o[i]._visible = true;
					} else {
						o[i]._visible = true;
						o[i].alphaTo( 100, 0.3, Mot.o.quint, 0.1 * i );							
					}
				}
			}	
		}
	}
	/**
	 * anim text - atype wrapper.
	 * @param tf (TextField)
	 * @param str (String)
	 * @param cb (Function)
	 * @return Void
	 */
	public static function anim(tf:TextField, str:String, cb:Function):Void {
		if (!tf.styleSheet) tf.styleSheet = App.css;
		TextEffects.atype( tf, str, cb );
		//TextEffects.pushtype(tf, str, 10, true, cb);
	}
	/**
	 * anim text - push wrapper.
	 * @param tf (TextField)
	 * @param str (String)
	 * @param ms (Number)
	 * @param cb (Function)
	 * @return Void
	 */	
	public static function push(tf:TextField, str:String, ms:Number, cb:Function):Void {
		if (!tf.styleSheet) tf.styleSheet = App.css;
		var t:Number = (!ms) ? 10 : ms;
		TextEffects.pushtype( tf, str, t, true, cb );		
	}
	/**
	 * stop tween wrapper.
	 * @param tf (TextField)
	 * @return Void
	 */
	public static function stopEffect(tf:TextField):Void {
		AnimHandler.destroy( tf );
	}
	private function TextDisplay() {
	}
}