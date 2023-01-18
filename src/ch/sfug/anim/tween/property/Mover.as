import ch.sfug.anim.tween.property.PropertyTween;

/**
 * @author loop
 */
class ch.sfug.anim.tween.property.Mover extends PropertyTween {


	/**
	 * creates a mover that handles the moving of a movieclip.
	 * @param t the target movieclip that will be moved
	 * @param d the duration of the tween in milliseconds
	 */
	public function Mover( t:MovieClip, d:Number ) {
		super(t, d);
	}

	/**
	 * moves the movieclip to a new position from the current
	 * @param x the target x position of the tween
	 * @param easeXBoth the easing function for the x movement and if no easeY is specified also for the y movement
	 * @param y the target y porition of the tween
	 * @param easeY the easing function for the y movement
	 */
	public function moveTo( x:Number, y:Number, easeXBoth:Function, easeY:Function ):Void {
		var obj:Object = new Object();
		if( x != undefined ) obj._x = { to: x, easing:easeXBoth };
		if( y != undefined ) obj._y = { to: y, easing:( easeY == undefined ) ? easeXBoth : easeY };
		tween( obj );
	}

	/**
	 * moves the movieclip to a new x position
	 * @param x the new x position after the tween
	 * @param ease the easing function for the movement
	 */
	public function moveToX( x:Number, ease:Function ):Void {
		var obj:Object = new Object();
		obj._x = { to: x, easing: ease };
		tween( obj );
	}

	/**
	 * moves the movieclip to a new y position
	 * @param x the new y position after the tween
	 * @param ease the easing function for the movement
	 */
	public function moveToY( y:Number, ease:Function ):Void {
		var obj:Object = new Object();
		obj._y = { to: y, easing: ease };
		tween( obj );
	}

	/**
	 * moves the movieclip from a position to a position
	 * @param xfrom the start x position of the tween
	 * @param xto the end x position of the tween
	 * @param yfrom the start y position of the tween
	 * @param yto the end y position of the tween
	 * @param easeXBoth the easing function for the x movement and if no easeY is specified also for the y movement
	 * @param easeY the easing function for the y movement
	 */
	public function moveFromTo( xfrom:Number, xto:Number, yfrom:Number, yto:Number, easeXBoth:Function, easeY:Function ):Void {
		var obj:Object = new Object();
		if( xfrom != undefined && xto != undefined ) obj._x = { from: xfrom, to: xto, easing:easeXBoth };
		if( yfrom != undefined && yto != undefined ) obj._y = { from: yfrom, to: yto, easing:( easeY == undefined ) ? easeXBoth : easeY };
		tween( obj );
	}

	/**
	 * moves the movieclip by an x amount and a y amount
	 * @param xamount the amount on which the x pos should be moved
	 * @param yamount the amount on which the y pos should be moved
	 * @param easeXBoth the easing function for the x movement and if no easeY is specified also for the y movement
	 * @param easeY the easing function for the y movement
	 */
	public function moveBy( xamount:Number, yamount:Number, easeXBoth:Function, easeY:Function ):Void {
		var obj:Object = new Object();
		if( xamount != undefined ) obj._x = { by: xamount, easing:easeXBoth };
		if( yamount != undefined || yamount != 0 ) obj._y = { by: yamount, easing:( easeY == undefined ) ? easeXBoth : easeY };
		tween( obj );
	}

	/**
	 * sets the target movieclip to a new position
	 */
	public function apply( x:Number, y:Number ):Void {
		if( x == undefined ) x = target._x;
		if( y == undefined ) y = target._y;
		super.apply( { _x: x, _y: y } );
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
		return super.toString() + " -> Mover";
	}

}