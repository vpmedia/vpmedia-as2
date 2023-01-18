import com.fear.app.menu.SlidingMenu;
import com.fear.app.menu.SlidingMenuButton;

class com.fear.yahoo.menu.SearchSlidingMenuButton extends SlidingMenuButton
{
	private var $searchType:String;
	
	public function SearchSlidingMenuButton()
	{
		this.setClassDescription('com.fear.yahoo.menu.SearchSlidingMenuButton');
	}
	public function onRelease()
	{
		super.onRelease();
	}
	public function onPress()
	{
		this.menu.onSearchTypeChange(this.searchType);
	}
	// properties
	public function get searchType():String
	{
		return this.$searchType;
	}
	public function set searchType(t:String):Void
	{
		this.$searchType = t;
	}
}