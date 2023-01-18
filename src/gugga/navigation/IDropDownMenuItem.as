import gugga.navigation.DropDownMenuItemTitle;
import gugga.navigation.INavigationItem;

/**
 * @author Todor Kolev
 */
interface gugga.navigation.IDropDownMenuItem extends INavigationItem 
{
	public function registerTitleButton(aDropDownMenuItemTitle:DropDownMenuItemTitle) : Void;
	
	public function registerChildTitleButton(aInstanceName:String) : DropDownMenuItemTitle;
	
	public function open() : Void;

	public function close() : Void; 
}