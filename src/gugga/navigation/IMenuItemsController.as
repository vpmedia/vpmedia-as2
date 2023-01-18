import gugga.common.ICommand;
import gugga.navigation.INavigationItem;
/**
 * @author Todor Kolev
 */
interface gugga.navigation.IMenuItemsController 
{
	public function addSubItem(aItem:INavigationItem, aID:String, aAditionalData:Object, aCommand:ICommand):Void;
	
	public function addChildSubItem(aInstanceName:String, aID:String, aAditionalData:Object, aCommand:ICommand):INavigationItem;
			
	public function getSubItem(aID:String):INavigationItem;
		
	public function getSubItemRecur(aID:String):INavigationItem;
	
	public function getSubItemID(aItemInstance:INavigationItem):String;
	
	public function getSubItemIDRecur(aItemInstance:INavigationItem):String;
	
	/**
	* Selects sub item under the current MenuItemsController
	* 
	* @param aID The ID of the item that should be selected.
	*/
	public function selectSubItem(aID:String):Void;	
	
	/**
	* Selects sub item under the current MenuItemsController,
	* or under one of its sub MenuItemsController-s.
	* 
	* @param aID The ID of the item that should be selected.
	*/
	public function selectSubItemRecur(aID:String):Void;
		
	public function selectAllSubItemsTo(aID:String):Void;	
	
	public function selectSubItemsPath(aPath:String):Void;

	public function unselectAllSubItems():Void;	
	
	public function unselectAllSubItemsRecur(aID:String):Void;
		
	public function callFunctionOnAllSubItemsTo(aID:String, aFunctionName:String) : Void;	
	
	public function findSubItemParent(aID:String) : IMenuItemsController;
}