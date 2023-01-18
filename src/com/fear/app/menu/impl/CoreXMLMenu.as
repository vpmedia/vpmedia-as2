import com.fear.app.menu.ICoreXMLMenu;
import com.fear.app.menu.MenuInfo;
import com.fear.xml.SimpleXML;

class com.fear.app.menu.impl.CoreXMLMenu extends SimpleXML implements ICoreXMLMenu
{
	private var menuItemLibraryClip:String;
	
	public function CoreXMLMenu()
	{
		this.setMenuItemLibaryClip('menuitem');
		this.ignoreWhite = true;
		this.onLoad = handleLoad;
	}
	
	public function setMenuItemLibaryClip(linkageId:String)
	{
		this.menuItemLibraryClip = linkageId;
	}
	public function toString(Void):String
	{
		return 'com.fear.app.menu.impl.CoreXMLMenu';
	}
	public function init(xmlURL:String):Void{};
	public function generateMenu(m:MenuInfo):Void{};
	public function handleLoad(success:Boolean):Void{};
}
