import net.manaca.ui.controls.listClasses.ListItemRenderer;
import net.manaca.ui.controls.skin.mnc.DateCellRendererSkin;
import net.manaca.ui.awt.Dimension;

/**
 * 单个日期元素
 * @author Wersling
 * @version 1.0, 2006-7-3
 */
class net.manaca.ui.controls.dateClasses.DateItemRenderer extends ListItemRenderer {
	private var className : String = "net.manaca.ui.controls.dateClasses.DateItemRenderer";
	private var _skin:DateCellRendererSkin;
	private var _availability : Boolean;
	public function DateItemRenderer(target : MovieClip, new_name : String) {
		super(target, new_name);
	}
	private function init():Void{
		_preferredSize = new Dimension(29,20);
		_skin = new DateCellRendererSkin();
		paintAll();
		
		selected = false;
		_labelHolder = _skin.getTextHolder();
		_iconHolder = _skin.getIconHolder();
	}
	/**
	 * 获取和设置可用性
	 * @param  value:Boolean - 
	 * @return Boolean 
	 */
	public function set availability(value:Boolean) :Void{
		this.getDisplayObject().enabled = value;
	}
	public function get availability() :Boolean{
		return this.getDisplayObject().enabled;
	}
	
	public function setBackgroundType(color_type:String):Void{
		_skin.setBackground(color_type);
	}
	public function toString():String{
		return this._domain.toString();
	}
}