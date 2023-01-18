/**
 * @author todor
 */

import gugga.navigation.NavigationButton;

class gugga.navigation.DropDownMenuItemTitle extends NavigationButton
{
	function onRollOut():Void
	{
		dispatchEvent({type:"rollOut", target:this});
	}
	
	function onRollOver():Void
	{
		dispatchEvent({type:"rollOver", target:this});
	}
}