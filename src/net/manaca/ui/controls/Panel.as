import net.manaca.ui.controls.UIComponent;
import net.manaca.ui.controls.skin.SkinFactory;
import net.manaca.ui.awt.Dimension;
import net.manaca.ui.controls.skin.mnc.PanelSkin;
import net.manaca.ui.controls.skin.IPanelSkin;

/**
 * 一个用于展示元素的面板，可以实现对面板以外的东西进行Mask
 * @author Wersling
 * @version 1.0, 2006-5-16
 */
class net.manaca.ui.controls.Panel extends UIComponent {
	private var className : String = "net.manaca.ui.controls.Panel";
	private var _skin:IPanelSkin;
	public function Panel(target:MovieClip,new_name:String) {
		super(target,new_name);
		_skin = new PanelSkin();
		paint();
	}
	
	public function getBoard():MovieClip{
		return _skin.getBoard();
	}
	/**
	 * 宽度
	 * @param  value  参数类型：Number 
	 * @return 返回值类型：Number 
	 */
	public function get _width() :Number{
		return this.getSize().getWidth();
	}
	
	/**
	 * 高度
	 * @param  value  参数类型：Number 
	 * @return 返回值类型：Number 
	 */
	public function get _height() :Number{
		return this.getSize().getHeight();
	}
	
}