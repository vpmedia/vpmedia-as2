/**
 * com.sekati.transitions.Mot
 * @version 1.1.0
 * @author jason m horwitz | sekati.com | tendercreative.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */
 
import caurina.transitions.Tweener;
/**
 * Mot - Motion Styling template support for {@link caurina.transitions.Tweener}
 * {@code Usage:
 * 	Tweener.addTween(myMc, { _x:500, _y:30, base:Mot.base0 } );
 * 	Tweener.addTween(myMc, { base:Mot.fadeOut } );
 * 	Tweener.addTween(myMc, { base:Mot.fadeTo(50), onComplete:myCallBackFn} );
 * }
 */
class com.sekati.transitions.Mot {
	// easing shortcuts
	public static var i:Object = { quint:"easeInQuint", quad:"easeInQuad", quart:"easeInQuart", expo:"easeInExpo" };
	public static var o:Object = { quint:"easeOutQuint", quad:"easeOutQuad", quart:"easeOutQuart", expo:"easeOutExpo" };
	public static var io:Object = { quint:"easeInOutQuint", quad:"easeInOutQuad", quart:"easeInOutQuart", expo:"easeInOutExpo" };
	// timing shortcuts
	public static var t:Object = {s:0.3, s2:0.5, s3:0.7, d:0.3, d2:0.5, d3:1};
	// deprecated "App.mot" mc_tween2 object - kept for backwards compatability
	public static var m:Object = {e:"easeInOutQuint", e2:"easeOutQuint", e3:"easeInOutQuad", e4:"easeOutQuad", e5:"easeInOutQuart", e6:"easeOutQuart", e7:"easeInOutExpo", e8:"easeOutExpo", s:0.3, s2:0.5, d:0.5};
	// color shortcuts
	public static var col:Object = {b:0x000000, w:0xFFFFFF, r:0xFF0000, g:0x00FF00, b:0x0000FF, y:0xFFFF00, c:0x00FFFF, m:0xFF00FF};
	public static var chromo:Object = {
		month:{jan:0x00D294, feb:0x26E058, mar:0xBCFF2D, apr:0xFFFF41, may:0xFFAF0B, jun:0xFF1A33, jul:0xFF1F77, aug:0xFB48BC, sep:0xBC35B7, oct:0x2463DB, nov:0x00A3FF, dec:0x00DCFF}, day:{a1:0x00D5E1, a2:0x00D294, a3:0x00CB58, a4:0x26E058, a5:0x7AF049, a6:0xBCFF2D, a7:0xFFFF22, a8:0xFFFF41, a9:0xFFFF30, a10:0xFFAF0B, a11:0xFF6E0C, a12:0xFF1A33, p1:0xFF0041, p2:0xFF1F77, p3:0xFF37B2, p4:0xFB48BC, p5:0xE638B5, p6:0xBC35B7, p7:0x7953CB, p8:0x2463DB, p9:0x0077EB, p10:0x00A3FF, p11:0x00C8FF, p12:0x00DCFF}
	};
	// preset templates
	public static function get base0():Object { 
		return { time:t.s, transition:io.quint };
	}
	public static function get base1():Object {
		return { time:t.s, transition:io.quad };
	}
	public static function get base2():Object {
		return { time:t.s, transition:io.expo };
	}
	public static function get abase():Object {
		return {time:0.5, transition:o.quad };
	}
	public static function get abaseShort():Object {
		return {time:0.3, transition:o.quad };
	}
	public static function get abaseLong():Object {
		//return {time:1, transition:io.quad };
		return {time:0.7, transition:io.quad };
	}
	public static function get fadeIn():Object {
		return Mot.fadeTo( 100 );	
	}
	public static function get fadeOut():Object {
		return Mot.fadeTo( 0 );	
	}
	/**
	 * Return a base tween object alpha transition
	 * @param a (Number)
	 * @return Object
	 */
	public static function fadeTo(a:Number):Object {
		return { _alpha:a, time:t.s, transition:io.expo };	
	}
	/**
	 * Return a base tween object glow transition
	 * @param a (Number) alpha [0-100]
	 * @param b (Number) blur [0-255]
	 * @param c (Number) color [hex]
	 * @param s (Number) strength [0-255]
	 * @return Object
	 */
	public static function glow(a:Number, b:Number, c:Number, s:Number):Object {
		return {_Glow_alpha:a, _Glow_color:c, _Glow_quality:3, _Glow_strength:s, _Glow_blurX:b, _Glow_blurY:b};	
	}
	/**
	 * Create a small "burst" transition
	 * @param mc (MovieClip)
	 * @param c (Number) color [hex]
	 * @param cb (Function) callback
	 * @return Void
	 */	
	public static function burst(mc:MovieClip, c:Number, cb:Function):Void {
		Tweener.addTween( mc, {_scale:10, time:0.3, transition:Mot.o.quint} );
		Tweener.addTween( mc, {_Glow_alpha:100, _Glow_color:c, _Glow_quality:3, _Glow_strength:10, _Glow_blurX:25, _Glow_blurY:25, _scale:150, time:0.3, transition:io.quad, delay:0.3} );
		Tweener.addTween( mc, {_alpha:0, _scale:50, time:0.5, transition:Mot.o.quint, delay:0.6, onComplete:cb} );
	}
	/**
	 * Normalize a clip
	 * @param mc (MovieClip)
	 * @return Void
	 */
	public static function normalize(mc:MovieClip):Void {
		mc.filters = [];
		mc._xscale = 100;
		mc._yscale = 100;
		Tweener.addTween( mc, {_color:undefined, time:0} );	
	}
	/**
	 * Return a base tween object color transition
	 * @param c (Number)
	 * @return Object
	 */
	public static function colorTo(c:Number):Object {
		return { _color:c, time:t.s2, transition:io.quint };	
	}	
	/**
	 * Mot Private Constructor
	 */
	private function Mot() {
	}
}
