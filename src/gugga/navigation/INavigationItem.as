/**
 * @author todor
 */

import gugga.common.IEventDispatcher;
 
[Event("selected")]
interface gugga.navigation.INavigationItem extends IEventDispatcher
{
	public function select():Void;
	public function unselect():Void;
	
	public function show():Void;
	public function hide():Void;
}