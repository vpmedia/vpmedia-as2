import net.manaca.ui.controls.esse.EsseUIComponent;
import net.manaca.ui.controls.ComboBox;
import net.manaca.lang.event.Event;
import net.manaca.ui.controls.TextInput;
[IconFile("icon/ComboBox.png")]
/**
 * 在用户选择一个列表项时
 */
[Event("change")]
/**
 * ComboBox 组件
 * @author Wersling
 * @version 1.0, 2006-5-28
 */
class net.manaca.ui.controls.esse.MNCComboBox extends EsseUIComponent {
	private var className : String = "net.manaca.ui.controls.esse.MNCComboBox";
	private var _componentName:String = "MNCComboBox";
	private var _component:ComboBox;
	private var _createFun:Function = ComboBox;

	private var _dropdownWidth : Number = 0;
	private var _editable : Boolean = false;
	private var _restrict : String = null;
	private var _rowCount : Number = 5;
	private var _text : String = "";
	private var _data : Array;
	private var _labels : Array;
	public function MNCComboBox() {
		super();
	}
	private function init():Void{
		super.init();
//		if(_labels.length > 0){
//			for (var i : Number = 0; i < _labels.length; i++) {
//				var o:Object = new Object();
//				o.label = _labels[i];
//				o.data = data[i];
//				_component.dataProvider.addItem(o);
//			}
//		}
		updata();
		if(_dropdownWidth > 0) dropdownWidth = _dropdownWidth;
		editable = _editable;
		restrict = _restrict;
		rowCount = _rowCount;
		text = _text;
		this.addListener(Event.CHANGE);
	
	}
	private function updata():Void{
		if(_labels.length > 0){
			_component.dataProvider.removeAll();
			for (var i : Number = 0; i < _labels.length; i++) {
				var o:Object = new Object();
				o.label = _labels[i];
				o.data = data[i];
				_component.dataProvider.addItem(o);
			}
		}
	}
	/**
	 * 关闭下拉列表
	 */
	public function close():Void{
		_component.close();
	}
	
	/**
	 * 打开下拉列表
	 */
	public function open():Void{
		_component.open();
	}
		
	/**
	 * 此对象只提供IDE方式，设置列表显示文字对应的数据
	 * @param  value:Array - 
	 * @return Array 
	 */
	[Inspectable(name="data",type=Array)]
	public function set data(value:Array) :Void{
		_data = value;
		updata();
	}
	public function get data() :Array{
		return _data;
	}
	
	/**
	 * 此对象只提供IDE方式，设置列表显示文字
	 * @param  value:Array - 
	 * @return Array 
	 */
	[Inspectable(name="labels",type=Array)]
	public function set labels(value:Array) :Void{
		_labels = value;
		updata();
	}
	public function get labels() :Array{
		return _labels;
	}
	/**
	 * 获取和设置数据源，此数据源支持所有{@see net.manaca.ui.controls.esse.IListDataProvider}方法
	 * @summary 获取和设置数据源
	 * @example
	 * 	<li>添加项：myMNCColorPicker.dataProvider.addItem({label:"Label1",icon:"icon",data:1});</li>
	 * 	<li>删除所有项：myMNCColorPicker.dataProvider.removeAll()</li>
	 * @param  value:Object - 数据源
	 * @return Object 
	 */
	public function set dataProvider(value:Object) :Void{
		_component.dataProvider = value;
	}
	public function get dataProvider() :Object{
		return _component.dataProvider;
	}
	
	/**
	 * 获取和设置下拉列表的宽度（以像素为单位）。
	 * @param  value:Number - 
	 * @return Number 
	 */
	[Inspectable(name="dropdownWidth",type=Number,defaultValue=0 )]
	public function set dropdownWidth(value:Number) :Void{
		_dropdownWidth = value;
		_component.dropdownWidth = _dropdownWidth;
	}
	public function get dropdownWidth() :Number{
		return _dropdownWidth;
	}
	
	/**
	 * 获取和设置组合框是否可以编辑，默认 false
	 * @param  value:Boolean - 
	 * @return Boolean 
	 */
	[Inspectable(name="editable",type=Boolean,defaultValue= false )]
	public function set editable(value:Boolean) :Void{
		_editable = value;
		_component.editable = _editable;
	}
	public function get editable() :Boolean{
		return _editable;
	}
	
	/**
	 * 获取列表长度
	 * @param  value:Number - 
	 * @return Number 
	 */
	public function get length() :Number{
		return _component.length;
	}
	
	/**
	 * 获取和设置用户可在组合框的文本字段中输入的字符集
	 * @param  value:String - 
	 * @return String 
	 */
	[Inspectable(name="restrict",type=String,defaultValue= null )]
	public function set restrict(value:String) :Void{
		_restrict = value;
		_component.restrict = _restrict;
	}
	public function get restrict() :String{
		return _restrict;
	}
	
	/**
	 * 获取和设置列表一次可以显示的最大项目数，默认 5
	 * @param  value:Number - 
	 * @return Number 
	 */
	[Inspectable(name="rowCount",type=Number,defaultValue= 5 )]
	public function set rowCount(value:Number) :Void{
		_rowCount = value;
		_component.rowCount = _rowCount;
	}
	public function get rowCount() :Number{
		return _rowCount;
	}
	
	/**
	 * 获取和设置单选列表的已选择索引，默认 null
	 * @param  value:Number - 
	 * @return Number 
	 */
//	[Inspectable(name="selectedIndex",type=Number,defaultValue=null )]
//	public function set selectedIndex(value:Number) :Void{
//		_selectedIndex = value;
//		_component.selectedIndex = _selectedIndex;
//	}
	public function get selectedIndex() :Number{
		return _component.selectedIndex;
	}
	
	/**
	 * 获取和设置单选列表中的项对象
	 * @param  value:Object - 
	 * @return Object 
	 */
//	[Inspectable(name="selectedItem",type=Object,defaultValue=null )]
//	public function set selectedItem(value:Object) :Void{
//		_selectedItem = value;
//		_component.selectedItem = _selectedItem;
//	}
	public function get selectedItem() :Object{
		return _component.selectedItem;
	}
	
	/**
	 * 获取和设置文本框中文本的字符串
	 * @param  value:String - 
	 * @return String 
	 */
	[Inspectable(name="text",type=String,defaultValue= "" )]
	public function set text(value:String) :Void{
		_text = value;
		_component.text = _text;
	}
	public function get text() :String{
		return _text;
	}
	
	/**
	 * 获取组合框中 TextInput 组件的引用
	 * @param  value:TextInput - 
	 * @return TextInput 
	 */
	public function get textField() :TextInput{
		return _component.textField;
	}
}