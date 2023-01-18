/**
 * @author todor
 */

import gugga.common.IEventDispatcher;
import gugga.navigation.INavigationItem;

[Event("navigate")] 
interface gugga.navigation.INavigation extends IEventDispatcher
{
	public function getSelectedItem():INavigationItem;	
	public function setSelectedItem(aValue:INavigationItem):Void;

	public function getSelectedItemID():String;	
	public function setSelectedItemID(aValue:String):Void;

	public function selectSubItemsPath(aPath:String):Void;

	public function enable():Void;
	public function disable():Void;
	
	public function show():Void;
	public function hide():Void;
	
	public function start():Void;
}