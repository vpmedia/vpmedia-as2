import net.manaca.ui.controls.esse.EsseUIComponent;
import net.manaca.ui.controls.List;
import net.manaca.lang.event.Event;
[IconFile("icon/List.png")]
/**
 * 在用户选择一个列表项时
 */
[Event("change")]
/**
 * List 组件
 * @author Wersling
 * @version 1.0, 2006-5-28
 */
class net.manaca.ui.controls.esse.MNCList extends EsseUIComponent {
	private var className : String = "net.manaca.ui.controls.esse.MNCList";
	private var _componentName:String = "MNCList";
	private var _component:List;
	private var _createFun:Function = List;

	private var _cellRenderer : Object = null;
	private var _rowHeight : Number = 20;
	private var _selectedIndex : Number = null;
	private var _selectedItem : Object = null;
	private var _labels : Array;
	private var _data : Array;
	//***************以上必须定义*********************
	public function MNCList() {
		super();
	}
	private function init():Void{
		super.init();
		rowHeight = _rowHeight;
		//cellRenderer = _cellRenderer;
		updata();
//		selectedIndex = _selectedIndex;
//		selectedItem = _selectedItem;
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
	 * 获取和设置要使用的类或元件以显示列表的每一行
	 * @param  value:Object - 
	 * @return Object 
	 */
	public function set cellRenderer(value:Object) :Void{
		_cellRenderer = value;
		_component.itemRenderer = _cellRenderer;
	}
	public function get cellRenderer() :Object{
		return _cellRenderer;
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
	[Inspectable(name="labels",type=Array,defaultValue="")]
	public function set labels(value:Array) :Void{
		_labels = value;
		updata();
	}
	public function get labels() :Array{
		return _labels;
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
	 * 获取和设置列表中每行的像素高度
	 * @param  value:Number - 
	 * @return Number 
	 */
	[Inspectable(name="rowHeight",type=Number,defaultValue=20 )]
	public function set rowHeight(value:Number) :Void{
		_rowHeight = value;
		_component.rowHeight = _rowHeight;
	}
	public function get rowHeight() :Number{
		return _rowHeight;
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
		return _selectedIndex;
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
		return _selectedItem;
	}
}