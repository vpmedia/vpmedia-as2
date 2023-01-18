import ch.sfug.anim.tween.property.PropertyTween;

/**
 * @author loop
 */
class ch.sfug.anim.tween.property.Rotater extends PropertyTween {

	public function Rotater(t : Object, d : Number) {
		super(t, d);
	}

	/**
	 * rotates the movieclip to a new degree value
	 * @param degree the new target degree value
	 * @param ease the easign function for the rotation tween
	 */
	public function rotateTo( degree:Number, ease:Function ):Void {
		tween( { _rotation: { to:degree, easing:ease } } );
	}

	/**
	 * rotates the movieclip by an degree value
	 * @param degree the degree value to de-/increase the current degree value
	 * @param ease the easign function for the rotation tween
	 */
	public function rotateBy( degree:Number, ease:Function ):Void {
		tween( { _rotation: { by:degree, easing:ease } } );
	}

	/**
	 * rotates the movieclip from a value to an other degree value
	 * @param dfrom the start value of the tween
	 * @param dto the end value of the tween
	 * @param ease the easign function for the rotation tween
	 */
	public function rotateFromTo( dfrom:Number, dto:Number, ease:Function ):Void {
		tween( { _rotation: { from:dfrom, to:dto, easing:ease } } );
	}

	/**
	 * sets the target movieclip to a new rotaion
	 */
	public function apply( degree:Number ):Void {
		super.apply( { _rotation: degree } );
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
		return super.toString() + " -> Resizer";
	}

}