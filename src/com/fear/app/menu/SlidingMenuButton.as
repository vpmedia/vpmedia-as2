import com.fear.movieclip.CoreMovieClip;
import com.fear.app.menu.SlidingMenu;

class com.fear.app.menu.SlidingMenuButton extends CoreMovieClip
{
	private var $context:Object;
	private var $menu:SlidingMenu;
	private var $index:Number;
	
	public function SlidingMenuButton()
	{
		this.setClassDescription('com.fear.app.menu.SlidingMenuButton');
		trace('[SlidingMenuButton] button: ' + this._name + ', contstructor invoked')
	}
	// event handlers
	public function onRelease()
	{
		var ease  = mx.transitions.easing.Elastic.easeOut;
		var begin = this.$menu.cursor._x;
		var end   = this._x;
		var time  = .75;
		
		var tween = new mx.transitions.Tween(this.menu.cursor, "_x", ease, begin, end, time, true);
		tween.content = this;
		tween.onMotionFinished = function(obj)
		{
			obj.content.onMotionFinished(obj.content);
		}
	}
	// override the following method
	public function onMotionFinished(obj:MovieClip)
	{
		trace('cursor motion finished');
	}
	// properties
	public function set index(i:Number):Void
	{
		this.$index = i;
	}
	public function get index():Number
	{
		return this.$index;
	}
	public function set menu(m:SlidingMenu):Void
	{
		this.$menu = m;
	}
	public function get menu():SlidingMenu
	{
		return this.$menu;
	}
	public function set context(obj:Object):Void
	{
		this.$context = obj;
	}
	public function get context():Object
	{
		return this.$context;
	}
}