import net.manaca.ui.controls.listClasses.IListItemRenderer;
import net.manaca.ui.controls.SimpleButton;
import net.manaca.ui.controls.skin.IButtonSkin;
import net.manaca.ui.controls.skin.mnc.ListCellRendererSkin;
import net.manaca.ui.awt.Dimension;
import net.manaca.ui.controls.listClasses.ListData;

/**
 * 
 * @author Wersling
 * @version 1.0, 2006-6-4
 */
class net.manaca.ui.controls.listClasses.ListItemRenderer extends SimpleButton implements IListItemRenderer {
	private var className : String = "net.manaca.ui.controls.listClasses.ListItemRenderer";
	private var _skin:IButtonSkin;
	private var _iconHolder:MovieClip;
	private var _data:ListData;
	public function ListItemRenderer(target : MovieClip, new_name : String) {
		super(target, new_name);
		init();
	}
	private function init():Void{
		_preferredSize = new Dimension(100,22);
		_skin = new ListCellRendererSkin();
		paintAll();
		
		selected = false;
		_labelHolder = _skin.getTextHolder();
		_iconHolder = _skin.getIconHolder();
	}
	/**
	 * 获取和设置文本字符位置autoSize 的可接受值为 "none"（默认值）、"left"、"right" 和 "center"。
	 * @param  value:String - 
	 * @return String 
	 */
	public function set autoSize (value:Object) :Void{
		_labelHolder.autoSize  = value;
	}
	public function get autoSize () :Object{
		return _labelHolder.autoSize ;
	}
	
	public function getRowIndex() : Object {
		return _data.rowIndex;
	}

	public function setValue(data : Object) : Void {
		_data = ListData(data);
		if(_data.icon != null){
			_iconHolder["_icon"].removeMovieClip();
			_iconHolder.attachMovie(_data.icon,"_icon",1);
		}
		label = _data.labelField;
	}
	public function getValue():Object{
		return _data;
	}
	public function setSelected(_selected : String) {
		if(_selected != undefined){
			switch (_selected) {
			    case "selected":
			        _skin.setSelected(true);
			        break;
			    case "highlighted":
			        _skin.setSelected(false);
			         _skin.onOver();
			        break;
			    case "normal":
			        _skin.setSelected(false);
			       _skin.onOut();
			        break;
			}
		}
	}

	public function remove() : Void {
		super.remove();
	}

	public function getPreferredWidth() : Number {
		return 100;
	}

	public function getPreferredHeight() : Number {
		return 20;
	}
	public function setLocation(x : Number, y : Number) : Void {
		super.setLocation(x,y);
	}

	public function setSize(width : Number, height : Number) : Void {
		super.setSize(width,height);
	}

}