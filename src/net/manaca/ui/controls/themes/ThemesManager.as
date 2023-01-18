import net.manaca.data.map.KeyMap;
import net.manaca.lang.BObject;
import net.manaca.ui.controls.ComponentManager;
import net.manaca.ui.controls.themes.Themes;
import net.manaca.ui.controls.themes.Sapphire;

/**
 * 样式管理器
 * @author Wersling
 * @version 1.0, 2006-5-12
 */
class net.manaca.ui.controls.themes.ThemesManager extends BObject {
	private var className : String = "net.manaca.ui.controls.themes.ThemesManager";
	static private var _default_themes:Themes;
	static private var _themes_map:KeyMap = new KeyMap();
	
	
	private function ThemesManager() {
		super();
	}
	/**
	 * 返回默认主题
	 * @return Themes 默认主题，默认 MMThemes
	 */
	public static function getDefault():Themes{
		return (_default_themes != undefined) ?_default_themes : new Sapphire();
	}
	
	/**
	 * 获取指定的组件名称的样式
	 * @param name 组件名称
	 * @return Themes 默认主题
	 */
	public static function getThemes(name:String):Themes{
		if(_themes_map.containsKey(name))
			return Themes(_themes_map.get(name));
		else
			return getDefault();
	}
	
	/**
	 * 设置默认主题
	 * @param Themes 默认主题
	 */
	public static function setDefault(default_themes:Themes):Void{
		_default_themes = default_themes;
		disposalComponent();
	}
	
	/**
	 * 设置指定组件的主题
	 * @param name 组件名称
	 * @param themes 主题
	 */
	public static function setThemes(name:String ,themes:Themes){
		_themes_map.put(name,themes);
		disposalComponent(name);
	}
	
	/**
	 * 处理组件主题
	 */
	private static function disposalComponent(name:String):Void{
		var _arr:Array = ComponentManager.getComponentList(name);
		if(_arr.length > 0){
			for (var i : Number = 0; i < _arr.length; i++) {
				_arr[i].setThemes(_default_themes);
			}
		}
	}
}