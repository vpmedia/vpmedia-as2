import ch.sfug.events.EventDispatcher;

/**
 * a base class for widgets that stores the size and the reference to the main movieclip
 * @author loop
 */
class ch.sfug.widget.BaseWidget extends EventDispatcher {

	private var mc:MovieClip;
	private var _width:Number;
	private var _height:Number;

	public function BaseWidget( mc:MovieClip ) {
		super();
		this.mc = mc;
		this._width = mc._width;
		this._height = mc._height;
	}

	/**
	 *  getter/setter functions for the width and height
	 */
	public function set width( num:Number ):Void {
		this._width = num;
		// extend this function to handle the resizing of the widget
	}
	public function set height( num:Number ):Void {
		this._height = num;
		// extend this function to handle the resizing of the widget
	}
	public function get width(  ):Number {
		return this._width;
	}
	public function get height(  ):Number {
		return this._height;
	}

	/**
	 * returns the x, y properties of the component
	 */
	public function get x(  ):Number {
		return mc._x;
	}
	public function get y(  ):Number {
		return mc._y;
	}

	/**
	 * sets the x, y properties of the component
	 */
	public function set x( x:Number ):Void {
		mc._x = x;
	}
	public function set y( y:Number ):Void {
		mc._y = y;
	}

	/**
	 * moves the widget
	 */
	public function move( x:Number, y:Number ):Void {
		this.x = x;
		this.y = y;
	}

	/**
	 * returns the base movieclip of the widget
	 */
	public function get target(  ):MovieClip {
		return mc;
	}

}