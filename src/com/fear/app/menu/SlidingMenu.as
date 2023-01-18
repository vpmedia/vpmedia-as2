import com.fear.movieclip.CoreMovieClip;
import com.fear.app.menu.SlidingMenuButton;

class com.fear.app.menu.SlidingMenu extends CoreMovieClip
{
	private var $context:Object;
	private var $buttons:Array;
	// assets assumed to be present in .fla
	public var cursor:MovieClip;
	
	public function SlidingMenu()
	{
		this.setClassDescription('com.fear.app.menu.SlidingMenu');
		this.$buttons = new Array;
	}
	public function addButton(b:SlidingMenuButton)
	{
		b.menu = this;
		b.index = this.$buttons.length;
		this.$buttons.push(b);
	}
	public function set context(obj:Object):Void
	{
		this.$context = obj;
	}
}