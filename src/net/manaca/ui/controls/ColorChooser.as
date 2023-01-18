import net.manaca.ui.controls.UIComponent;
import net.manaca.ui.controls.skin.IColorChooserSkin;
import net.manaca.ui.controls.skin.SkinFactory;
import net.manaca.ui.awt.Dimension;
import net.manaca.ui.controls.listClasses.ListBase;
import net.manaca.ui.controls.Panel;
import net.manaca.ui.controls.TextInput;
import net.manaca.util.Delegate;
import net.manaca.ui.controls.listClasses.ListDataProvider;
import net.manaca.util.MovieClipUtil;
import net.manaca.lang.event.Event;
import net.manaca.util.StringUtil;
import net.manaca.ui.controls.skin.mnc.ColorChooserSkin;
/**
 * 用户选择一个颜色时
 */
[Event("change")]
/**
 * 颜色选择器
 * @author Wersling
 * @version 1.0, 2006-5-26
 */
class net.manaca.ui.controls.ColorChooser extends ListBase {
	private var _componentName = "ColorChooser";
	private var _skin:IColorChooserSkin;
	
	private var _selectedcolor_mc:MovieClip;
	private var _panel : Panel;
	private var _input_text:TextInput;

	private var _selectedColor : Number = 0x000000;

	private var _angle : Array = [1,1,0,0];
	function ColorChooser(target : MovieClip, new_name : String) {
		super(target, new_name);
//		_skin = SkinFactory.getInstance().getDefault().createColorChooserSkin();
		_skin = new ColorChooserSkin();
		_preferredSize = new Dimension(196,153);
		this.paintAll();
		initData();
		init();
	}
	//初始化数据
	private function initData() : Void {
		__dataChangedHandler = Delegate.create(this,dataChangedHandler);
		var _arr:Array = new Array();
		for (var i : Number = 0; i < 19; i ++){
			for (var j : Number = 0; j < 12; j ++){
				if (i > 0){
					var R = Math.floor ((i - 1) / 6) * 0x33 + Math.floor (j / 6) * 0x99;
					var G = ((i - 1) % 6) * 0x33;
					var B = (j % 6) * 0x33;
				}else{
					var R = (j % 6) * 0x33;
					var G = R;
					var B = R;
				}
				
				R = R.toString (16);
				if (R.length == 1) R = "0" + R;
				G = G.toString (16);
				if (G.length == 1) G = "0" + G;
				B = B.toString (16);
				if (B.length == 1) B = "0" + B;
				_arr[j * 19 + i] = parseInt ("0x" + R + G + B, 16);
			}
		}
		_arr[6 * 19] = 0xFF0000;
		_arr[7 * 19] = 0x00FF00;
		_arr[8 * 19] = 0x0000FF;
		_arr[9 * 19] = 0xFFFF00;
		_arr[10 * 19] = 0x00FFFF;
		_arr[11 * 19] = 0xFF00FF;
		_dataProvider = new ListDataProvider(_arr);
		_dataProvider.addListener("dataChanged",__dataChangedHandler);
	}
	private function init() : Void {
		_selectedcolor_mc = _skin.getSelectedColorHoder();
		_panel = _skin.getPanel();
		_input_text = _skin.getInputText();
		
		_input_text.addEventListener(Event.ENTER,Delegate.create(this,onInputEnter));
		_input_text.maxChars = 6;
		
		selectedColor = _selectedColor;
		dataChangedHandler();
	}
	
	private function dataChangedHandler():Void{
		removeAll();
		var l= _dataProvider.size();
		if(l < 1){
			this.setSize(125,27);
		}else{
			if(l <= 19){
				this.setSize(Math.max((l%19)*10 +1+ 4,125),42);
			}else{
				this.setSize(195,(Math.ceil(l/19))*10 +32);
			}
		}
		//建立可复用的原始元件
		var _mc:MovieClip = _panel.getBoard().createEmptyMovieClip("_mc",_panel.getBoard().getNextHighestDepth());
		_mc.beginFill(0xff0000,100);
		_mc.moveTo(0, 0);
		_mc.lineTo(9, 0);
		_mc.lineTo(9, 9);
		_mc.lineTo(0, 9);
		_mc.lineTo(0, 0);
		_mc.endFill();
		var _but:MovieClip = _panel.getBoard().createEmptyMovieClip("_but",_panel.getBoard().getNextHighestDepth());
		_but.beginFill(0xFFFFFF,100);
		_but.moveTo(0, 0);
		_but.lineTo(11, 0);
		_but.lineTo(11, 11);
		_but.lineTo(0, 11);
		_but.lineTo(0, 0);
		_but.endFill();
		
		for (var i : Number = 0; i < l; i++) {
			var _but_mc:MovieClip = _but.duplicateMovieClip("but_mc_"+i, _panel.getBoard().getNextHighestDepth(),{_x:(i%19)*10,_y:int(i/19)*10});
			_but_mc.useHandCursor = false;
			_but_mc._alpha = 0;
			_but_mc.onRollOver = Delegate.create(this,onButRollOver,_but_mc,_dataProvider.getItemAt(i));
			_but_mc.onRollOut = Delegate.create(this,onButRollOut,_but_mc);
			_but_mc.onReleaseOutside = Delegate.create(this,onButRollOut,_but_mc);
			_but_mc.onRelease = Delegate.create(this,onButRelease,_but_mc,_dataProvider.getItemAt(i));
			
			var _mc_con:MovieClip = _mc.duplicateMovieClip("colro_mc_"+i, _panel.getBoard().getNextHighestDepth(),{_x:(i%19)*10+1,_y:int(i/19)*10+1});
			new Color(_mc_con).setRGB(Number(_dataProvider.getItemAt(i)));
		}
		
		//删除原始元件
		MovieClipUtil.remove(_mc);
		MovieClipUtil.remove(_but);
	}
	//删除所有的颜色元件
	private function removeAll():Void{
		var _mc =  _panel.getBoard();
		for(var i in _mc){
			MovieClipUtil.remove(_mc[i]);
		}
	}
	private function onInputEnter(e:Event):Void{
		selectedColor = parseInt(String(e.value),16);
		this.dispatchEvent(new Event(Event.CHANGE,selectedColor,this));
	}
	//选择一个颜色
	private function onButRelease():Void{
		var mc:MovieClip = arguments[0];
		var c:Number = arguments[1];
		selectedColor = c;
		this.dispatchEvent(new Event(Event.CHANGE,c,this));
	}
	private function onButRollOver():Void{
		var mc:MovieClip = arguments[0];
		var c:Number = arguments[1];
		mc._alpha = 100;
		setInputColor(c);
		new Color(_selectedcolor_mc).setRGB(c);	
	}
	private function onButRollOut():Void{
		var mc:MovieClip = arguments[0];
		mc._alpha = 0;
		setInputColor(selectedColor);
		new Color(_selectedcolor_mc).setRGB(selectedColor);	
	}
	//设置文本框文字
	private function setInputColor(c:Number):Void{
		var _str:String = c.toString(16);
		if(_str.length < 6) _str = StringUtil.multiply("0" ,6-_str.length)+_str;
		 _input_text.text = _str.toUpperCase();
	}
//	/**
//	 * 获取和设置颜色名称
//	 * @param  value:String - 
//	 * @return String 
//	 */
//	public function set colorField(value:String) :Void{
////		_colorField = value;
//	}
//	public function get colorField() :String{
//		return null;
//	}
	/**
	 * 获取和设置按钮四角的弧度，默认值为[1,1,1,1]
	 * @param  value  参数类型：Array 
	 * @return 返回值类型：Array 
	 */
	public function set angle(value:Array) :Void{
		_angle = value;
		this.repaint();
	}
	public function get angle() :Array{
		return _angle;
	}
	/**
	 * 获取和设置 颜色名称是true否false可编辑，默认 true
	 * @param  value:Boolean - 
	 * @return Boolean 
	 */
	public function set editable(value:Boolean) :Void{
		_input_text.editable = value;
	}
	public function get editable() :Boolean{
		return _input_text.editable;
	}
	
	/**
	 * 获取和设置选择的颜色值
	 * @param  value:Number - 
	 * @return Number 
	 */
	public function set selectedColor(value:Number) :Void{
		_selectedColor = value;
		setInputColor(_selectedColor);
		new Color(_selectedcolor_mc).setRGB(_selectedColor);	
	}
	public function get selectedColor() :Number{
		return _selectedColor;
	}
}