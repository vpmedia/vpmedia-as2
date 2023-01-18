import net.manaca.ui.controls.UIComponent;
import net.manaca.ui.controls.skin.IColorPickerSkin;
import net.manaca.ui.controls.skin.SkinFactory;
import net.manaca.ui.awt.Dimension;
import net.manaca.ui.controls.listClasses.IListDataProvider;
import net.manaca.ui.controls.ColorChooser;
import net.manaca.util.Delegate;
import net.manaca.ui.controls.Button;
import net.manaca.lang.event.ButtonEvent;
import net.manaca.util.DepthControl;
import net.manaca.util.MovieClipUtil;
import net.manaca.ui.controls.skin.mnc.ColorPickerSkin;
/** 在选择颜色发生改变时触发 */
[Event("change")]
/**
 * 颜色选择器
 * @author Wersling
 * @version 1.0, 2006-5-26
 */
class net.manaca.ui.controls.ColorPicker extends UIComponent {
	private var className : String = "net.manaca.ui.controls.ColorPicker";
	private var _componentName = "ColorPicker";
	private var _skin:IColorPickerSkin;
	
	private var _colorChooser:ColorChooser;
	private var _click_but:Button;
	private var _color_mc:MovieClip;
	private var _colorState:Boolean;
	
	public function ColorPicker(target : MovieClip, new_name : String) {
		super(target, new_name);
//		_skin = SkinFactory.getInstance().getDefault().createColorPickerSkin();
		_skin = new ColorPickerSkin();
		_preferredSize = new Dimension(22,20);
		this.paintAll();
		init();
	}

	private function init() : Void {
		_colorChooser = _skin.getColorChooser();
		_colorChooser.addEventListener(ButtonEvent.CHANGE,Delegate.create(this,onChangeItem));
		
		_click_but = _skin.getClickButton();
		_click_but.addEventListener(ButtonEvent.RELEASE,Delegate.create(this,onButtonClick));
		
		_color_mc = _skin.getColorHoder();
		
		_colorState = true;
		close();
	}
	private function onButtonClick() : Void {
		DepthControl.bringToFront(this.getDisplayObject());
		setFocus();
		if(_colorState){
			close();
		}else{
			open();
		}
	}
	
	//选择一个颜色
	private function onChangeItem(e:ButtonEvent) : Void {
		selectedColor = Number(e.value);
		this.dispatchEvent(new ButtonEvent(ButtonEvent.CHANGE,e.value,this));
		close();
	}
	/**
	 * close list
	 */
	public function close():Void{
		if(_colorState){
			_colorChooser.setVisible(false);
			_colorState = false;
			this._domain.onMouseDown = null;
			delete this._domain.onMouseDown;
		}
	}
	/**
	 * open list
	 */
	public function open():Void{
		if(!_colorState){
			_colorChooser.setVisible(true);
			_colorState = true;
			this._domain.onMouseDown = Delegate.create(this,onMouse_Down);
		}
	}
	/** 失去焦点时触发 */
	public function onKillFocus(newFocus:UIComponent):Void{
		super.onKillFocus(newFocus);
		this.close();
	}
	
	//鼠标外部点击
	private function onMouse_Down():Void{
		if (!MovieClipUtil.mouseSuperpose(_domain) && _colorState) {
			close();
		}
	}
	/**
	 * 获取和设置按钮四角的弧度，默认值为[1,1,1,1]
	 * @param  value  参数类型：Array 
	 * @return 返回值类型：Array 
	 */
	public function set angle(value:Array) :Void{
		_click_but.angle = value;
	}
	public function get angle() :Array{
		return _click_but.angle;
	}
	
	/**
	 * 获取和设置 颜色名称是true否false可编辑，默认 true
	 * @param  value:Boolean - 
	 * @return Boolean 
	 */
	public function set editable(value:Boolean) :Void{
		_colorChooser.editable = value;
	}
	public function get editable() :Boolean{
		return _colorChooser.editable;
	}
	
	/**
	 * 获取和设置数据源
	 * @param  value:Object - 
	 * @return Object 
	 */
	public function set dataProvider(value:Object) :Void{
		_colorChooser.dataProvider = value;
	}
	public function get dataProvider() :Object{
		return _colorChooser.dataProvider;
	}
	/**
	 * 获取和设置选择的颜色值
	 * @param  value:Number - 
	 * @return Number 
	 */
	public function set selectedColor(value:Number) :Void{
		_colorChooser.selectedColor = value;
		new Color(_color_mc).setRGB(value);
	}
	public function get selectedColor() :Number{
		return _colorChooser.selectedColor;
	}




}