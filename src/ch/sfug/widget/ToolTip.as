import ch.sfug.controls.EventButton;
import ch.sfug.events.ButtonEvent;
import ch.sfug.widget.BaseWidget;

/**
 * this is a tooltip class where you can register tooltips to eventbuttons with the corresponding textmessage.
 *
 * the movieclip for the tooltip needs:
 * - a bg movieclip labeled with "bg"
 * - a textfield labeled with "label"
 *
 * the rest should be calculated automatically.
 *
 * <pre>
 * // a simple tooltip example:
 * import ch.sfug.widget.ToolTip;
 * import ch.sfug.display.EventButton;
 * tt = new ToolTip( tooltip );
 * tt.register( new EventButton( but ), "this is a test" );
 * </pre>
 *
 * @see ch.sfug.display.EventButton
 * @author loop
 */

class ch.sfug.widget.ToolTip extends BaseWidget {

	private var texts:Object;
	private var txtf:TextField;

	public function ToolTip( mc:MovieClip ) {
		super( mc );

		// check for assets
		if( mc.bg == undefined ) trace( "you need a movieclip called 'bg' inside the tooltip that represents the background of the tooltip" );
		if( mc.label == undefined ) trace( "you need a textfield called 'label' inside the tooltip that will be the textfield for the messages" );

		hide();
		this.texts = new Object();
		this.txtf = mc.label;
		txtf.autoSize = "left";
	}

	/**
	 * registers a eventbutton with a text
	 */
	public function register( eb:EventButton, txt:String ):Void {
		eb.addEventListener( ButtonEvent.ROLLOVER, onRollOver, this );
		eb.addEventListener( ButtonEvent.ROLLOUT, onRollOut, this );
		eb.addEventListener( ButtonEvent.DRAGOUT, onRollOut, this );
		texts[ eb.target ] = txt;
	}

	/**
	 * unregisters a button
	 */
	public function unregister( eb:EventButton ):Void {
		eb.removeEventListener( ButtonEvent.ROLLOVER, onRollOver, this );
		eb.removeEventListener( ButtonEvent.ROLLOUT, onRollOut, this );
		eb.removeEventListener( ButtonEvent.DRAGOUT, onRollOut, this );
		delete texts[ eb.target ];
	}

	/**
	 * shows the tooltip
	 */
	private function show(  ):Void {
		onMouseMove();
		mc._visible = true;
		Mouse.addListener( this );
	}

	/**
	 * hides the tooltip
	 */
	private function hide(  ):Void {
		mc._visible = false;
		Mouse.removeListener( this );
	}

	/**
	 * will be called if one of the registered buttons is rolled over
	 */
	private function onRollOver( e:ButtonEvent ):Void {
		txtf.text = texts[ e.target.target ];
		adjustBackground();
		show();
	}

	/**
	 * will be called if one of the registered buttons is rolled out
	 */
	private function onRollOut( e:ButtonEvent ):Void {
		hide();
	}

	/**
	 * catch the event of the mouse
	 */
	private function onMouseMove(  ):Void {
		adjustPosition();
	}

	/**
	 * adjusts the background of the tooltip when text changes
	 */
	private function adjustBackground(  ):Void {
		mc.bg._height = txtf._height + 10;
		mc.bg._width = txtf._width + 10;
		txtf._y = mc.bg._y + 5;
	}

	/**
	 * adjusts the position of the tooltip when the mouse moves
	 */
	private function adjustPosition(  ):Void {
		this.mc._x = this.mc._parent._xmouse;
		this.mc._y = this.mc._parent._ymouse;
		var gp:Object = getGlobal( mc );
		var l:Number = gp.x + mc.bg._x + mc._width;
		var r:Number = gp.x + mc.bg._x;
		var t:Number = gp.y + mc.bg._y;
		var b:Number = gp.y + mc.bg._y + mc._height;
		if( l > Stage.width ) mc._x -= l - Stage.width;
		if( r < 0 ) mc._x += -r;
		if( t < 0 ) mc._y += -t;
		if( b > Stage.height ) mc._y -= b - Stage.height;
	}

	/**
	 * returns the global position of the mc
	 */
	private function getGlobal( mc:MovieClip ):Object {
		var pos:Object = { x:0, y:0 };
		mc.localToGlobal( pos );
		return pos;
	}

}