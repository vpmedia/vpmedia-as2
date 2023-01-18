import ch.sfug.anim.AbstractAnimation;
import ch.sfug.events.AnimationEvent;
import ch.sfug.utils.mc.MCManger;

/**
 * a class that that uses its own enerframe loop to interpolate values over a duration of time.
 *
 * note: already tried to do it with the EnterFrame class but its quite slower
 * @author loop
 */
class ch.sfug.anim.tween.AbstractTween extends AbstractAnimation {

	private var t:Object;
	private var d:Number;
	private var s:Number;
	private var b:Boolean;
	private static var ts:Array;
	private static var mc:MovieClip;
	private static var tick:Number;

	/**
	 * creates an abstract tween
	 * @param t the target object of the tween
	 * @param d the duration of the tween in milliseconds
	 */
	public function AbstractTween( t:Object, d:Number ) {
		super();
		target = t;
		duration = d;
		if( ts == undefined ) ts = new Array();
		if( mc == undefined ) mc = MCManger.getMC( "anim" );
	}

	public function start():Void {
		ts.unshift( this );
		if( ts.length == 1 ) {
			mc.onEnterFrame = update;
			tick = getTimer();
		}
		s = tick;
		_run = true;
		dispatchEvent( new AnimationEvent( AnimationEvent.START ) );
	}

	public function stop():Void {
		_run = false;
		var l:Number = ts.length;
		while (ts[--l] != this && l>-1);
		if( l > -1 ) ts.splice( l, 1 );
		if( ts.length == 0 ) delete mc.onEnterFrame;
		dispatchEvent( new AnimationEvent( AnimationEvent.STOP ) );
	}

	private static function update():Void {
		tick = getTimer();
		var c:Number = tick;
		var i:Number = ts.length;
		var te = ts;
		while( i-- ) {
			var tw = te[ i ];
			var d:Number = c - tw.s;
			if( d < tw.d ) {
				tw.interpolate( d, tw.d );
			} else {
				tw.interpolate( 1, 1 );
				tw.stop();
			}
			if( tw.b ) tw.dispatchEvent( new AnimationEvent( AnimationEvent.UPDATE ) );
		}
	}

	/**
	 * abstract function
	 * @param c the current time
	 * @param d the total time
	 */
	private function interpolate( c:Number, d:Number):Void {
		// abstract
	}

	/**
	 * the default easing function
	 */
	public static function linear( t:Number, b:Number, c:Number, d:Number ):Number {
		return b + t * c / d;
	}

	/**
	 * extend this function to check for AnimationEvent.UPDATE event
	 */
	public function addEventListener( type:String, func:Function, obj:Object ):Void {
		super.addEventListener( type, func, obj );
		b = hasEventListener( AnimationEvent.UPDATE );
	}
	public function removeEventListener( type:String, func:Function, obj:Object ):Void {
		super.removeEventListener( type, func, obj );
		b = hasEventListener( AnimationEvent.UPDATE );
	}

	/**
	 * sets/gets the duration of the tween
	 */
	public function set duration( d:Number ):Void {
		if( d > 0 ) {
			this.d = d;
		} else {
			trace( " you have to specify a duration bigger than 0 and not: " + d + " for the tween: " + this );
		}
	}
	public function get duration(  ):Number {
		return d;
	}

	/**
	 * sets/gets the target of the tween
	 */
	public function set target( t:Object ):Void {
		if( t != undefined ) {
			this.t = t;
		} else {
			trace( " you have to specify a target for the tween: " + this );
		}
	}
	public function get target(  ):Object {
		return t;
	}

	public function toString():String {
		return "AbstractTween( " + t + ", " + d + " )";
	}
}