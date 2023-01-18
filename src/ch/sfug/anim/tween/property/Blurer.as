import ch.sfug.anim.tween.AbstractTween;

import flash.filters.BlurFilter;

/**
 * @author marcel
 */
class ch.sfug.anim.tween.property.Blurer extends AbstractTween {

	private var pps:Object;

	/**
	 * creates a tween on object properties
	 * @param t the object which properies will be tweened
	 * @param d the duration of the tween in milliseconds
	 */
	public function Blurer( t:Object, d:Number ) {
		super( t, d );
	}

	/**
	 * overwrite superfunction to interpolate on the properties
	 */
	public function interpolate( c:Number, d:Number ):Void {
		for( var i:String in pps ) {
			
			var p:Object = pps[ i ];
			t[ i ] = p.easing( c, p.from, p.to - p.from, d );
		}
		
		t.filters = [new BlurFilter(t["_xBlur"],t["_yBlur"],pps["_blurQuality"])];
	}

	/**
	 * tween to a specified object
	 * @param obj an object that looks like this:
	 * { _xBlur: { from:200, to: 300, easing:func }, _yBlur: { from:200, to: 300, easing:func } }
	 * or
	 * { _xBlur: { to: 300, easing:func }, _yBlur: { to: 300, easing:func } } // starts from the actual _x property
	 * or
	 * { _xBlur: { by: 300, easing:func } } // starts from the actual _x property with the amount of 300
	 */
	public function tween( obj:Object ):Void {
		for( var i:String in obj ) {
			var p:Object = obj[ i ];
			if( p.easing == undefined ) p.easing = linear;
			if( p.from == undefined ) p.from = 0;
			// parse by
			if( p.by != undefined ) p.to = p.from + p.by;	
		}
		
		if( obj._blurQuality == undefined){ obj._blurQuality = 2;};
		
		this.pps = obj;
		this.start();
	}

	/**
	 * applies property values to the object
	 * @param obj an object that looks like this:
	 * { _xBlur:{}, _yBlur:{}, _blurQuality{} }
	 */
	public function apply( obj:Object ):Void {
		for (var i:String in obj ) {
			t[ i ] = obj[ i ];
		}
	}

	/**
	 * returns the tween object that specifies the tweening
	 */
	public function getTweenObject(  ):Object {
		return this.pps;
	}
}