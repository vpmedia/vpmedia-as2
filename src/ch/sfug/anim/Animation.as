import ch.sfug.anim.AbstractAnimation;
import ch.sfug.data.Iterator;
import ch.sfug.events.AnimationEvent;
import ch.sfug.events.EventDispatcher;

/**
 * @author loop
 */
class ch.sfug.anim.Animation extends AbstractAnimation {

	private var childs:Array;
	private var iter:Iterator;

	public function Animation() {
		super();
		childs = new Array();
		iter = new Iterator( );
	}

	/**
	 * adds an child animation
	 */
	public function waitFor( anim:EventDispatcher, func:String ):Void {
		var obj:Object = new Object();
		obj.inst = anim;
		obj.func = ( func == undefined ) ? "start" : func;
		obj.para = arguments.slice( 2 );
		obj.wait = true;
		childs.push( obj );
	}

	/**
	 * adds an child animation that is imedieatly launched
	 */
	public function launch( inst:Object, func:String ):Void {
		if( inst == undefined) {
			trace( "you have to specify all parameters for a launch in the animation." );
		} else {
			var obj:Object = new Object();
			obj.inst = inst;
			obj.func = ( func == undefined ) ? "start" : func;
			obj.para = arguments.slice( 2 );
			obj.wait = false;
			childs.push( obj );
		}
	}

	/**
	 * sets properties of a object
	 */
	public function setProperties( obj:Object, properties:Object ):Void {
		launch( this, "adjustProperties", obj, properties );
	}

	/**
	 * will adjust property values.
	 */
	private function adjustProperties( obj:Object, properties:Object ):Void {
		for (var i:String in properties) {
			obj[ i ] = properties[ i ];
		}
	}

	/**
	 * starts the animation
	 */
	public function start():Void {
		_run = true;
		iter.data = childs;
		iter.reset();
		change( );
		dispatchEvent( new AnimationEvent( AnimationEvent.START ) );
	}

	/**
	 * moves to the next animation
	 */
	private function change( e:AnimationEvent ):Void {

		// remove listener on passed anim
		var old:EventDispatcher = EventDispatcher( e.target );
		old.removeEventListener( AnimationEvent.STOP, change, this );

		if( iter.hasNext() ) {
			var obj:Object = iter.next();
			var n:Object = obj.inst;
			var f:String = obj.func;
			var p:Array = obj.para;
			if( obj.wait ) {
				n.addEventListener( AnimationEvent.STOP, change, this );
				n[ f ].apply( n, p );
			} else {
				n[ f ].apply( n, p );
				change();
			}
			dispatchEvent( new AnimationEvent( AnimationEvent.CHANGE ) );
		} else {
			_run = false;
			dispatchEvent( new AnimationEvent( AnimationEvent.STOP ) );
		}
	}

	/**
	 * stops the animation
	 */
	public function stop() : Void {
		var c:AbstractAnimation = AbstractAnimation( iter.current().inst );
		c.removeEventListener( AnimationEvent.STOP, change, this );
		c.stop();
		_run = false;
	}

	/**
	 * removes all child animations
	 */
	public function removeChilds(  ):Void {
		for (var i : Number = 0; i < childs.length; i++) {
			var c:AbstractAnimation = AbstractAnimation( childs[ i ] );
			c.removeEventListener( AnimationEvent.STOP, change, this );
		}
		this.childs = [];
	}
}