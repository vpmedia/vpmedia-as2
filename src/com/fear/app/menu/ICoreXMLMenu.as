import com.fear.core.CoreInterface;

interface com.fear.app.menu.ICoreXMLMenu extends CoreInterface
{
	public function init(xmlURL:String):Void;
	public function generateMenu(m:com.fear.app.menu.MenuInfo):Void;
	public function handleLoad(success:Boolean):Void;
}