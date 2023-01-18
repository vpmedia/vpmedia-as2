import ch.sfug.anim.tween.property.PropertyTween;

/**
 * @author loop
 */
class ch.sfug.anim.tween.property.Resizer extends PropertyTween {


	/**
	 * creates a resize that handles the resizing ( _width, _height ) of a movieclip.
	 * @param t the target movieclip that will be moved
	 * @param d the duration of the tween in milliseconds
	 */
	public function Resizer( t:MovieClip, d:Number ) {
		super(t, d);
	}

	/**
	 * resizes the movieclip to a new size from the current
	 * @param w the target width of the movieclip
	 * @param easeWBoth the easing function for the width resizing and if no easeH is specified also for the height resizing
	 * @param h the target height of the movieclip
	 * @param easeH the easing function for the height resizing
	 */
	public function sizeTo( w:Number, h:Number, easeWBoth:Function, easeH:Function ):Void {
		var obj:Object = new Object();
		if( w != undefined ) obj._width = { to: w, easing:easeWBoth };
		if( h != undefined ) obj._height = { to: h, easing:( easeH == undefined ) ? easeWBoth : easeH };
		tween( obj );
	}

	/**
	 * resizes the movieclip by an width amount and a height amount
	 * @param wamount the amount on which the width should be resized
	 * @param easeWBoth the easing function for the width resizing and if no easeH is specified also for the height resizing
	 * @param h the amount on which the height should be resized
	 * @param easeH the easing function for the height resizing
	 */
	public function sizeBy( wamount:Number, hamount:Number, easeWBoth:Function, easeH:Function ):Void {
		var obj:Object = new Object();
		if( wamount != undefined ) obj._width = { by: wamount, easing:easeWBoth };
		if( hamount != undefined || hamount != 0 ) obj._height = { by: hamount, easing:( easeH == undefined ) ? easeWBoth : easeH };
		tween( obj );
	}

	/**
	 * resizes only the width
	 */
	public function sizeToW( w:Number, ease:Function ):Void {
		tween( { _width: { to:w, easing:ease } } );
	}

	/**
	 * resizes only the width
	 */
	public function sizeToH( h:Number, ease:Function ):Void {
		tween( { _height: { to:h, easing:ease } } );
	}

	/**
	 * sets a new size for the movieclip
	 */
	public function apply( w:Number, h:Number ):Void {
		if( w == undefined ) w = target._width;
		if( h == undefined ) h = target._height;
		super.apply( { _width: w, _height: h } );
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