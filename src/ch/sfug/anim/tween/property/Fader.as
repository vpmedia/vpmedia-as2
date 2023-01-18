import ch.sfug.anim.tween.property.PropertyTween;

/**
 * @author loop
 */
class ch.sfug.anim.tween.property.Fader extends PropertyTween {


	/**
	 * creates a fader that handles the fading of a movieclip.
	 * @param t the target movieclip that will be faded
	 * @param d the duration of the tween in milliseconds
	 */
	public function Fader( t:MovieClip, d:Number ) {
		super(t, d);
	}

	/**
	 * fades the movieclip to a new alpha value
	 * @param alpha the new target alpha value
	 * @param ease the easign function for the alpha fade
	 */
	public function fadeTo( alpha:Number, ease:Function ):Void {
		alpha = Math.max( 0, Math.min( 100, alpha ) );
		tween( { _alpha: { to:alpha, easing:ease } } );
	}

	/**
	 * fades the movieclip by an alpha value
	 * @param alpha the alpha value to de-/increase the current alpha value
	 * @param ease the easign function for the alpha fade
	 */
	public function fadeBy( alpha:Number, ease:Function ):Void {
		tween( { _alpha: { by:alpha, easing:ease } } );
	}

	/**
	 * fades the movieclip from a value to an alpha value
	 * @param afrom the start value of the tween
	 * @param ato the end value of the tween
	 * @param ease the easign function for the alpha fade
	 */
	public function fadeFromTo( afrom:Number, ato:Number, ease:Function ):Void {
		tween( { _alpha: { from:afrom, to:ato, easing:ease } } );
	}

	/**
	 * sets the target movieclip to a new alpha value
	 */
	public function apply( alpha:Number ):Void {
		alpha = Math.max( Math.min( alpha, 100 ), 0 );
		super.apply( { _alpha: alpha } );
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
	public function toString():String {
		return super.toString() + " -> Fader";
	}

}