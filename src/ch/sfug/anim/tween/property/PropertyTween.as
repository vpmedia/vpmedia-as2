import ch.sfug.anim.tween.AbstractTween;
import ch.sfug.events.AnimationEvent;

/**
 * @author loop
 */
class ch.sfug.anim.tween.property.PropertyTween extends AbstractTween {

	private var pps:Object;

	/**
	 * creates a tween on object properties
	 * @param t the object which properies will be tweened
	 * @param d the duration of the tween in milliseconds
	 */
	public function PropertyTween( t:Object, d:Number ) {
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
	}

	/**
	 * tween to a specified object
	 * @param obj an object that looks like this:
	 * { _x: { from:200, to: 300, easing:func } }
	 * or
	 * { _x: { to: 300, easing:func } } // starts from the actual _x property
	 * or
	 * { _x: { by: 300, easing:func } } // starts from the actual _x property with the amount of 300
	 */
	public function tween( obj:Object ):Void {
		for( var i:String in obj ) {
			var p:Object = obj[ i ];
			if( p.easing == undefined ) p.easing = linear;
			if( p.from == undefined ) p.from = t[ i ];
			// parse by
			if( p.by != undefined ) p.to = p.from + p.by;
		}
		this.pps = obj;
		this.start();
	}

	/**
	 * applies property values to the object
	 * @param obj an object that looks like this:
	 * { _x:200, _y:300 }
	 */
	public function apply( obj:Object ):Void {
		for (var i:String in obj ) {
			t[ i ] = obj[ i ];
		}
		if( hasEventListener( AnimationEvent.UPDATE ) ) dispatchEvent( new AnimationEvent( AnimationEvent.UPDATE ) );
	}

	/**
	 * returns the tween object that specifies the tweening
	 */
	public function getTweenObject(  ):Object {
		return this.pps;
	}

	public function toString():String {
		var t:String = "";
		for( var i:String in pps ) {
			t += i + " to: " + pps[ i ].to;
		}
		return super.toString() + " -> PropertyTween with: " + t;
	}
}