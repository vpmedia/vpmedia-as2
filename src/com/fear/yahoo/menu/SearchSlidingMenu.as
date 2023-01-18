import com.fear.app.menu.SlidingMenu;
import com.fear.yahoo.menu.SearchSlidingMenuButton;

class com.fear.yahoo.menu.SearchSlidingMenu extends SlidingMenu
{
	private var $searchButtons:Array;
	private var $shell:MovieClip;
	// assets assumed to be present in .fla
	private var webSearchButton:SearchSlidingMenuButton;
	private var imageSearchButton:SearchSlidingMenuButton;
	private var localSearchButton:SearchSlidingMenuButton;
	private var newsSearchButton:SearchSlidingMenuButton;
	private var videoSearchButton:SearchSlidingMenuButton;

	public function SearchSlidingMenu()
	{
		this.setClassDescription('com.fear.yahoo.menu.SearchSlidingMenu');
		// buttons
		this.$searchButtons = new Array(5);
		// add buttons
		this.$searchButtons.push(webSearchButton);
		this.$searchButtons.push(imageSearchButton);
		this.$searchButtons.push(localSearchButton);
		this.$searchButtons.push(newsSearchButton);
		this.$searchButtons.push(videoSearchButton);
		// context
		this.$shell = this._parent;
	}
	public function onLoad()
	{
		this.webSearchButton.searchType = 'web';
		this.imageSearchButton.searchType = 'image';
		this.localSearchButton.searchType = 'local';
		this.newsSearchButton.searchType = 'news';
		this.videoSearchButton.searchType = 'video';
		for(var item in this.$searchButtons)
		{
			this.$searchButtons[item].onMotionFinished = onMotionFinished;
			this.addButton(this.$searchButtons[item]);
		}
	}
	private function onSearchTypeChange(searchType:String)
	{
		trace('SearchSlidingMenu.onSearchTypeChange: '+ searchType);
		trace('SearchSlidingMenu.shell: '+ this.$shell);
		this.$shell.onSearchTypeChange(searchType);
	}
	private function onMotionFinished(obj)
	{
		trace('onMotionFinished: '+ obj);
	}
	public function set shell(mc:MovieClip):Void
	{
		this.$shell = mc;
	}
	public function get shell():MovieClip
	{
		return this.$shell;
	}
}