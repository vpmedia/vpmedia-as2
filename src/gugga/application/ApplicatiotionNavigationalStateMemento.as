import gugga.collections.ArrayList;
/**
 * @author Krasimir
 */
 
class gugga.application.ApplicatiotionNavigationalStateMemento {
	// private aplication navigation state
	private var mOpenTabs:ArrayList; // ordered colection of tabs
	private var mNavigationPath:String;
	private var mPopupOpened:String;

	// private aplication navigation state accesors - accesible only to application 

	public function get OpenTabs():ArrayList
	{
		return mOpenTabs;
	}	
	public function set OpenTabs(tabs:ArrayList):Void
	{
		 mOpenTabs =tabs;
	}	

	public function get NavigationPath():String
	{
		return mNavigationPath;
	}	
	public function set NavigationPath(path:String):Void
	{
		 mNavigationPath =path;
	}	

	public function get PopupOpened():String
	{
		return mPopupOpened;
	}	
	public function set PopupOpened(id:String):Void
	{
		 mPopupOpened =id;
	}	
	
}