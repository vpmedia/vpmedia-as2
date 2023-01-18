import net.manaca.ui.controls.listClasses.IListItemRenderer;
import net.manaca.ui.UIObject;
import net.manaca.ui.controls.listClasses.ListData;
import net.manaca.lang.event.ButtonEvent;
import net.manaca.util.ColorUtil;

/**
 * BaseUIListItemRenderer 对象构造一个基本 的 MovieCilp 列表项
 * @author Wersling
 * @version 1.0, 2006-6-9
 */
class net.manaca.ui.controls.listClasses.BaseUIListItemRenderer extends UIObject implements IListItemRenderer {
	private var className : String = "net.manaca.ui.controls.listClasses.BaseUIListItemRenderer";
	private var _base_mc : MovieClip;
	private var _selected_mc : MovieClip;
	private var _iconHolder : MovieClip;
	private var _labelHolder : TextField;
	private var _data : ListData;

	private var _preferredWidth : Number;
	private var _preferredHeight : Number;
	public function BaseUIListItemRenderer() {
		super();
	}
	/** 加载完成执行 */
	public function onLoad() : Void{
		super.onLoad();
		this.useHandCursor = false;

		_preferredWidth = this._width;
		_preferredHeight = this._height;
		_selected_mc._alpha = 50;
		_selected_mc._visible = false;
		new Color(_base_mc).setRGB(0xffffff);
	}
	public function getRowIndex() : Object {
		return _data.rowIndex;
	}
	public function setSelected(_selected : String) {
		if(_selected != undefined){
			switch (_selected) {
				case "selected":
					_selected_mc._visible = true;
					break;
				case "highlighted":
					_selected_mc._visible = false;
					onOver();
					break;
				case "normal":
					_selected_mc._visible = false;
					break;
			}
		}
	}

	public function remove() : Void {
		this.removeMovieClip();
	}

	public function getPreferredWidth() : Number {
		return _preferredWidth;
	}

	public function getPreferredHeight() : Number {
		return _preferredHeight;
	}

	public function setValue(data : Object) : Void {
		if(data != _data){
			_data = ListData(data);
			if(_data.icon != null){
				_iconHolder["_icon"].removeMovieClip();
				_iconHolder.attachMovie(_data.icon,"_icon",1);
			}
			_labelHolder.text = _data.labelField;
	
			updateChildComponent();
		}
//		if(data == undefined || data == null) {
//			this._visible = false;
//		}else{
//			this._visible = true;
//		}
	}
	public function getValue() : Object {
		return _data;
	}
	public function setLocation(x : Number, y : Number) : Void {
		this._x = x;
		this._y = y;
	}

	public function setSize(width : Number, height : Number) : Void {
		if(_base_mc._width != width || _selected_mc._height != height){
			_base_mc._width = _selected_mc._width =width;
			_base_mc._height = _selected_mc._height =height;
	
			updateChildComponent();
		}
	}
	/**
	 * 设置组件是否可见
	 */
	public function setVisible(b:Boolean):Void{
		this._visible = b;
	}
	
	/**
	 * 获取组件是否可见
	 */
	public function getVisible():Boolean{
		return this._visible;
	}
	public function updateChildComponent() : Void {
		var minx : Number = 2;
		var miny : Number = 0;
		var manw : Number = this._width-2;
		var manh : Number = this._height;;
		var f : TextField = _labelHolder;
		var icon : MovieClip = _iconHolder;

		f.autoSize = true;
		var fw = f._width;
		var fh = f._height;
		var iw = icon._width;
		var ih = icon._height;
		f.autoSize = false;
		if(iw > 0 && ih >0 && fw >4){
			icon._x = minx;
			f._x = int(icon._x + iw);
		}else if(iw > 0 && ih >0){
			icon._x = minx;
		}else{
			f._width = Math.max(manw,fw);
			f._x =  minx;
		}
		f._y =  Math.max((int((manh-fh)/2))+miny,miny-2);
		icon._y = Math.max((int((manh-ih)/2))+miny,miny);
	}

	private function onPress() : Void{
		this.dispatchEvent(new ButtonEvent(ButtonEvent.PRESS));
		onDown();
	}
	private function onRelease() : Void{
		onOver();
		this.dispatchEvent(new ButtonEvent(ButtonEvent.RELEASE));
	}
	private function onReleaseOutside() : Void{
		onOut();
		this.dispatchEvent(new ButtonEvent(ButtonEvent.RELEASE_OUT_SIDE));
	}
	private function onRollOver() : Void{
		onOver();
		this.dispatchEvent(new ButtonEvent(ButtonEvent.ROLL_OVER));
	}
	private function onRollOut() : Void{
		onOut();
		this.dispatchEvent(new ButtonEvent(ButtonEvent.ROLL_OUT));
	}

	public function onOver() : Void {
		var _mc : MovieClip = _base_mc;
		if(_mc != undefined){
			var c : ColorUtil = new ColorUtil(_mc);
			c.setChangeRGB(ColorUtil.adjustBrightness2(0x00CCFF,35),6);
		}
	}

	public function onOut() : Void {
		var _mc : MovieClip = _base_mc;
		if(_mc != undefined){
			var c : ColorUtil = new ColorUtil(_mc);
			c.setChangeRGB(0xffffff,6);
		}
	}

	public function onDown() : Void {
		var _mc : MovieClip = _base_mc;
		if(_mc != undefined){
			var c : ColorUtil = new ColorUtil(_mc);
			c.setChangeRGB(0x00CCFF,6);
		}
	}
	

}