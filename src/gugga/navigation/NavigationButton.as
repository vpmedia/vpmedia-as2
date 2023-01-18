import gugga.navigation.INavigationItem;

[Event("selected")]
class gugga.navigation.NavigationButton extends gugga.components.Button implements INavigationItem
{	
	private function onRelease()
	{
		super.onRelease();
		dispatchEvent({type:"selected", target:this});
	} 
}