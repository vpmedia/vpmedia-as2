import ch.sfug.anim.tween.AbstractTween;

/**
 * @author loop
 */
class ch.sfug.anim.tween.TimelineTween extends AbstractTween {

	private var sf:Number;
	private var ef:Number;


	public function TimelineTween( t:MovieClip, dur:Number ) {
		super(t, ( dur != undefined ) ? dur : Number.POSITIVE_INFINITY );
	}

	/**
	 * plays to a specified frame
	 */
	public function playTo( frame:Number ):Void {
		sf = target._currentframe;
		ef = frame;
		start();
	}

	/**
	 * overwrite superfunction to interpolate on the properties
	 */
	public function interpolate( c:Number, d:Number ):Void {
		var cf:Number = t._currentframe;
		if( cf == ef ) {
			super.stop();
		} else {
			if( d == Number.POSITIVE_INFINITY ) {
				// frame based
				t.gotoAndStop( cf + ( ( sf > ef ) ? -1 : 1 ) );
			} else {
				// duration based
				t.gotoAndStop( Math.round( linear( c, sf, ef - sf, d ) ) );
			}
		}
	}

	/**
	 * stops at a specified frame
	 */
	public function gotoAndStop( frame:Number ):Void {
		target.gotoAndStop( frame );
	}

	/**
	 * plays at a specified frame with no stop
	 */
	public function gotoAndPlay( frame:Number ):Void {
		if( running ) {
			if( enabled ) {
				enabled = false;
				// for not broadcasting the stop event
				stop();
				enabled = true;
			} else {
				stop();
			}
		}
		target.gotoAndPlay( frame );
	}

	/**
	 * returns the movieclip
	 */
	public function get target(  ):MovieClip {
		return MovieClip( super.target );
	}
	public function set target( mc:MovieClip ):Void {
		super.target = mc;
	}

}