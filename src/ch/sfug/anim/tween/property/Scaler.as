import ch.sfug.anim.tween.property.PropertyTween;

/**
 * @author loop
 */
class ch.sfug.anim.tween.property.Scaler extends PropertyTween {


	/**
	 * creates a scaler that handles the scaling of a movieclip.
	 * @param t the target movieclip that will be moved
	 * @param d the duration of the tween in milliseconds
	 */
	public function Scaler( t:MovieClip, d:Number ) {
		super(t, d);
	}

	/**
	 * scales the movieclip to a new scale value from the current
	 * @param x the target x scaling
	 * @param easeXBoth the easing function for the x scaling and if no easeY is specified also for the y scaling
	 * @param y the target y scaling
	 * @param easeY the easing function for the y scaling
	 */
	public function scaleTo( x:Number, y:Number, easeXBoth:Function, easeY:Function ):Void {
		var obj:Object = new Object();
		if( x != undefined ) obj._xscale = { to: x, easing:easeXBoth };
		if( y != undefined ) obj._yscale = { to: y, easing:( easeY == undefined ) ? easeXBoth : easeY };
		tween( obj );
	}

	public function scaleToX( x:Number, ease:Function ):Void {
		var obj:Object = new Object();
		obj._xscale = { to: x, easing: ease };
		tween( obj );
	}

	public function scaleToY( y:Number, ease:Function ):Void {
		var obj:Object = new Object();
		obj._yscale = { to: y, easing: ease };
		tween( obj );
	}

	public function scaleFromTo( xfrom:Number, xto:Number, yfrom:Number, yto:Number, easeXBoth:Function, easeY:Function ):Void {
		var obj:Object = new Object();
		if( xfrom != undefined && xto != undefined ) obj._xscale = { from: xfrom, to: xto, easing:easeXBoth };
		if( yfrom != undefined && yto != undefined ) obj._yscale = { from: yfrom, to: yto, easing:( easeY == undefined ) ? easeXBoth : easeY };
		tween( obj );
	}

	public function scaleBy( xamount:Number, yamount:Number, easeXBoth:Function, easeY:Function ):Void {
		var obj:Object = new Object();
		if( xamount != undefined ) obj._xscale = { by: xamount, easing:easeXBoth };
		if( yamount != undefined || yamount != 0 ) obj._yscale = { by: yamount, easing:( easeY == undefined ) ? easeXBoth : easeY };
		tween( obj );
	}

	/**
	 * sets a new scaling
	 */
	public function apply( x:Number, y:Number ):Void {
		if( x == undefined ) x = target._xscale;
		if( y == undefined ) y = target._yscale;
		super.apply( { _xscale: x, _yscale: y } );
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
		return super.toString() + " -> Scaler";
	}

}