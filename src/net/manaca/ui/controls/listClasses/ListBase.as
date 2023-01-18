import net.manaca.ui.controls.listClasses.IListDataProvider;
import net.manaca.ui.controls.data.IDataFormatter;
import net.manaca.ui.controls.listClasses.ListDataFormatter;
import net.manaca.ui.controls.listClasses.ListDataProvider;
import net.manaca.lang.exception.UnsupportedOperationException;
import net.manaca.util.Delegate;
import net.manaca.ui.controls.core.ScrollControlBase;
import net.manaca.util.ObjectUtil;
import net.manaca.ui.controls.listClasses.IListItemRenderer;
import net.manaca.lang.event.Event;
import net.manaca.lang.event.ButtonEvent;
import net.manaca.data.set.HashSet;
/**
 * 只要用户交互造成选择更改就广播
 */
[Event("change")]
/**
 * 指针在列表项上滑过然后又滑离时广播
 */
[Event("itemRollOut")]
/**
 * 当指针滑过列表项时进行广播
 */
[Event("itemRollOver")]
/**
 * ListBase 负责列表的数据处理和控制，在数据发生改变时，它将扑获此事件并执行一个子类必须实现的方法 ： dataChangedHandler
 * @author Wersling
 * @version 1.0, 2006-5-22
 */
class net.manaca.ui.controls.listClasses.ListBase extends ScrollControlBase {
	private var className : String = "net.manaca.ui.controls.listClasses.ListBase";
	private var _dataProvider : IListDataProvider;
	private var __dataChangedHandler:Function;

	private var _columnWidth : Number;
	private var _rowHeight : Number;
	private var _rowCount : Number = -1;
	private var _columnCount : Number = -1;
	/** 通过设置 RowHeight 获得 */
    private var explicitRowHeight:Number;
    /** 通过设置 ColumnWidth 获得 */
	private var explicitColumnWidth:Number;
	/** 通过设置 RowCount 获得 */
	private var explicitRowCount:Number = -1;
	/** 通过设置 ColumnCount 获得 */
	private var explicitColumnCount:Number = -1;
     
	private var _wordWrap : Boolean = false;
	
	private var _multipleSelection : Boolean;
	private var _selectable : Boolean = true;
	private var _selectedIndex : Number = -1;
	private var _selectedIndices : HashSet;
	private var _isdownShiftKey:Boolean = false;
	private var _isdownCtrlKey:Boolean = false;

	private var _labelField : String = "label";
	private var _labelFunction : Function;
	private var _iconField : String = "icon";
	private var _iconFunction : Function;
	
	private var _itemRenderer;
	//存放单元的场所
	private var _carrier:MovieClip;
	
	private var __onListItemRelease : Function;
	private var __onListItemOut : Function;
	private var __onListItemOver : Function;
	private var _listItems:Array;
	
	/**
	 * 指示时候单元项显示发生改变
	 */
	private var rendererChanged : Boolean = false;
	
	private var variableRowHeight : Boolean = false;
	private var variableRowWidth : Boolean = false;
	
	static private var _item_uid:Number = 0;
	public function ListBase(target : MovieClip, new_name : String) {
		super(target, new_name);
	}
	//初始化数据
	private function initialize() : Void {
		_selectedIndices = new HashSet();
		_listItems = new Array();
		
		__onListItemRelease = Delegate.create (this, onListItemRelease);
		__onListItemOut = Delegate.create (this, onListItemOut);
		__onListItemOver = Delegate.create (this, onListItemOver);
		
		__dataChangedHandler = Delegate.create(this,dataChangedHandler);
		_dataProvider = new ListDataProvider();
		_dataProvider.addListener("dataChanged",__dataChangedHandler);
		ListBase.prototype["addItem"] = _dataProvider.addItem;
		
		//var _keyEvent:Object = new Object();
		Key.addListener(this);
	}
	//建立一个新的单元
	private function createNewItem():IListItemRenderer{
		if(typeof(_itemRenderer) == "function" ){
			return  new _itemRenderer(_carrier,"_listCell_"+_item_uid++);
		}else if(typeof(_itemRenderer) == "string"){
			return IListItemRenderer(_carrier.attachMovie(_itemRenderer,"_listCell_"+_item_uid++,_carrier.getNextHighestDepth()));
		}
	}
	
	/**
	 * 构造行和列
	 */
	private function makeRowsAndColumns(left:Number, top:Number,right:Number, bottom:Number,firstCol:Number, firstRow:Number):Void{
	}
	/**
	 * 初始化列表
	 */
	private function invalidateDisplayList():Void{
	}
	/**
	 * 返回一个String ，用于在项目中显示，这个值根据传入的数据来决定
	 * @param data:Object - 传入的数据
	 * @return  String 在项目中显示的字符串
	 */
	public function itemToLabel(data:Object):String{
		if (data == null && data == undefined)
        	return " ";
		
        if (labelFunction != null && labelFunction != undefined)
            return labelFunction(data);
		
		if(ObjectUtil.analyze(data) == ObjectUtil.TYPE_XML){
			try
            {
                if (data[labelField].length() != 0)
                	data = data[labelField];
            }
            catch (e:Error)
            {
            }
		}else if(ObjectUtil.analyze(data) == ObjectUtil.TYPE_OBJECT){
			try
            {
                if (data[labelField] != null)
                    data = data[labelField];
            }
            catch(e:Error)
            {
            }
		}
		
		if (ObjectUtil.analyze(data) == ObjectUtil.TYPE_STRING)
            return String(data);
		
        try
        {
            return data.toString();
        }
        catch(e:Error)
        {
        }
		
        return null;
	}
	/**
	 * 返回一个图标的String ，用于在项目中显示，这个值根据传入的数据来决定
	 * @param data:Object - 传入的数据
	 * @return  String 在项目中显示的图标位置
	 */
	public function itemToIcon(data:Object):String{
		if (data == null && data == undefined)
        	return null;
		
        if (iconFunction != null && iconFunction != undefined)
            return labelFunction(data);
       
        if(ObjectUtil.analyze(data) == ObjectUtil.TYPE_OBJECT){
			try
            {
                if (data[iconField] != null)
                    return data[iconField];
            }
            catch(e:Error)
            {
            }
		}
		return null;
	}
	
	/**
	 * 选择项
	 * @param item:IListItemRenderer 选择的项
	 * @param shiftKey:Boolean - 是否按下 shift 键
	 * @param ctrlKeyKey:Boolean - 是否按下 ctrlKey 键
	 */
	private function selectItem(item:IListItemRenderer,shiftKey:Boolean, ctrlKey:Boolean):Void{
//		Tracer.debug('shiftKey: ' + shiftKey);
//		Tracer.debug('ctrlKey: ' + ctrlKey);
		if(!multipleSelection){
			var _index = item.getRowIndex();
			if(_index != _selectedIndex){
				clearSelected();
				selectRow(_index - verticalScrollPosition);
				_selectedIndex = _index;
			}
		}else{
			var _index = item.getRowIndex();
			if(shiftKey){
				clearSelected();
				if(_selectedIndex <= _index){
					for (var i : Number = _selectedIndex; i <= _index; i++) {
						selectRow(i - verticalScrollPosition);
						_selectedIndices.Add(i);
					}
				}else{
					for (var i : Number = _index; i <= _selectedIndex; i++) {
						selectRow(i - verticalScrollPosition);
						_selectedIndices.Add(i);
					}
				}
				_selectedIndex = _index;
			}else if(ctrlKey){
				selectRow(_index - verticalScrollPosition);
				_selectedIndices.Add(_index);
				_selectedIndex = _index;
			}else{
				clearSelected();
				
				selectRow(_index - verticalScrollPosition);
				_selectedIndices.Add(_index);
				_selectedIndex = _index;
			}
		}
		
		//this.dispatchEvent(new Event(Event.CHANGE,null,this));
	}
	
	private function selectRow(rowIndex:Number):Void{
		_listItems[rowIndex].setSelected("selected");
	}
	/**
	 * 取消所有选择
	 */
	private function clearSelected():Void{
		if(!multipleSelection){
			_listItems[_selectedIndex - verticalScrollPosition].setSelected("normal");
		}else{
			for (var i : Number = 0; i < selectedIndices.length; i++) {
				_listItems[selectedIndices[i] - verticalScrollPosition].setSelected("normal");
			}
			_selectedIndices = new HashSet();
		}
	}
	
	/**
	 * 用户点击一个单元
	 */
	private function onListItemRelease(e:Event) : Void {
		//var _index = e.target.getRowIndex();
		selectItem(IListItemRenderer(e.target),_isdownShiftKey,_isdownCtrlKey);
		this.dispatchEvent(new Event(Event.CHANGE,selectedItems,this));
	}
	
	/**
	 * 用户点击一个单元
	 */
	private function onListItemOut(e:Event) : Void {
		
	}
	/**
	 * 用户点击一个单元
	 */
	private function onListItemOver(e:Event) : Void {
		
	}

	/**
	 * 获取和设置要使用的类或元件以显示列表的每一行
	 * @param  value:String - 
	 * @return String 
	 */
	public function set itemRenderer(o) :Void{
		if(o != null) _itemRenderer = o;
		rendererChanged = true;
	}
	public function get itemRenderer()
	{
		return _itemRenderer;
	}
	/**
	 * 获取和设置每个项目中的一个字段用作显示文本。此属性会获得该字段的值，并将其用作标签。默认值为 "label"。
	 * @param  value:String - 
	 * @return String 
	 */
	public function set labelField(value:String) :Void{
		_labelField = value;
		invalidateDisplayList();
	}
	public function get labelField() :String{
		return _labelField;
	}
	
	/**
	 * 获取和设置用于确定显示每个项目的哪个字段（或字段组合）的函数。
	 * 此函数会接收一个参数 item（该参数指示所呈现的项），并且必须返回一个表示要显示的文本的字符串。
	 * @param  value:Function - 
	 * @return Function 
	 */
	public function set labelFunction(value:Function) :Void{
		_labelFunction = value;
		invalidateDisplayList();
	}
	public function get labelFunction() :Function{
		return _labelFunction;
	}
	
	/**
	 * 获取和设置用作图标标识符的字段名称。如果字段的值为 undefined，则使用 defaultIcon 样式所指定的默认图标。如果 defaultIcon 样式为 undefined，则不使用任何图标。
	 * @param  value:String - 
	 * @return String 
	 */
	public function set iconField(value:String) :Void{
		_iconField = value;
		invalidateDisplayList();
	}
	public function get iconField() :String{
		return _iconField;
	}
	
	/**
	 * 获取和设置一个函数，用于确定每行将使用哪个图标来显示其项目。此函数会接收参数 item（该参数指示所呈现的项），并且必须返回一个表示图标元件标识符的字符串
	 * @param  value:Function - 
	 * @return Function 
	 */
	public function set iconFunction(value:Function) :Void{
		_iconFunction = value;
		invalidateDisplayList();
	}
	public function get iconFunction() :Function{
		return _iconFunction;
	}
	/**
	 * 获取和设置是否允许自动换行，默认 false
	 * @param  value:Boolean - 
	 * @return Boolean 
	 */
	public function set wordWrap(value:Boolean) :Void{
		_wordWrap = value;
	}
	public function get wordWrap() :Boolean{
		return _wordWrap;
	}
	/**
	 * 获取和设置列数
	 * @param  value:Number - 
	 * @return Number 
	 */
	public function set columnCount(value:Number) :Void{
		explicitColumnCount = value;
		
		if(_columnCount != value){
			_columnCount = value;
		}
		
	}
	public function get columnCount() :Number{
		return _columnCount;
	}
	
	/**
	 * 获取和设置行数
	 * @param  value:Number - 
	 * @return Number 
	 */
	public function set rowCount(value:Number) :Void{
		explicitRowCount = value;
		
		if(_rowCount != value){
			_rowCount = value;
			
		}
	}
	public function get rowCount() :Number{
		return _rowCount;
	}
	/**
	 * 获取和设置列宽
	 * @param  value:Number - 
	 * @return Number 
	 */
	public function set columnWidth(value:Number) :Void{
		explicitColumnWidth = value;
		variableRowWidth = true;
		if(_columnWidth != value){
			_columnWidth = value;
			
		}
	}
	public function get columnWidth() :Number{
		return _columnWidth;
	}
	
	private function setColumnWidth(value:Number):Void{
		columnWidth = value;
	}
	/**
	 * 获取和设置行高
	 * @param  value:Number - 
	 * @return Number 
	 */
	public function set rowHeight(value:Number) :Void{
		explicitRowHeight = value;
		variableRowHeight = true;
		if(_rowHeight != value){
			_rowHeight = value;
			
		}
		
	}
	public function get rowHeight() :Number{
		return _rowHeight;
	}
	
	private function setRowHeight(value:Number):Void{
		rowHeight = value;
	}
	/**
	 * 获取和设置是 (true) 否 (false) 为可选择列表。默认值为 true。
	 * @param  value:Boolean - 
	 * @return Boolean 
	 */
	public function set selectable(value:Boolean) :Void{
		if(_selectable != value){
			_selectable = value;
			if(_selectable){
				for (var i : Number = 0; i < _listItems.length; i++) {
					var _cell = _listItems[i];
						_cell.addEventListener(ButtonEvent.RELEASE,__onListItemRelease);
						_cell.addEventListener(ButtonEvent.ROLL_OUT,__onListItemOut);
						_cell.addEventListener(ButtonEvent.ROLL_OVER,__onListItemOver);
				}
			}else{
				for (var i : Number = 0; i < _listItems.length; i++) {
					var _cell = _listItems[i];
						_cell.removeEventListener(ButtonEvent.RELEASE,__onListItemRelease);
						_cell.removeEventListener(ButtonEvent.ROLL_OUT,__onListItemOut);
						_cell.removeEventListener(ButtonEvent.ROLL_OVER,__onListItemOver);
				}
				clearSelected();
			}
		}
	}
	public function get selectable() :Boolean{
		return _selectable;
	}
	/**
	 * 获取和设置选择的ID
	 * @param  value:Number - 
	 * @return Number 
	 */
	public function set selectedIndex(value:Number) :Void{
		if(selectable && _selectedIndex != value) {
			_selectedIndex = value;
			if(_multipleSelection) selectedIndices.Add(value);
			invalidateDisplayList();
		}
	}
	public function get selectedIndex() :Number{
		if(!selectable) return -1;
		return _selectedIndex;
	}
	
	/**
	 * 获取和设置所有选择的项
	 * @param  value:Array - 
	 * @return Array 
	 */
	public function set selectedIndices(value:Array) :Void{
		if(selectable){
			for (var i : Number = 0; i < value.length; i++) {
				_selectedIndices.Add(value[i]);
			}
			invalidateDisplayList();
		}
	}
	public function get selectedIndices() :Array{
		if(!selectable) return null;
		return _selectedIndices.toArray();
	}
	
	/**
	 * 获取和设置所有选择的值
	 * @param  value:Array - 
	 * @return Array 
	 */
	public function set selectedItems(value:Array) :Void{
		if(selectable){
			for (var i : Number = 0; i < value.length; i++) {
				_selectedIndices.Add(_dataProvider.getItemIndex(value[i]));
			}
			invalidateDisplayList();
		}
	}
	public function get selectedItems() :Array{
		if(!selectable) return null;
		if(selectedIndices.length < 1 || _dataProvider.size() < 1) return null;
		
		var _arr:Array = new Array();
		for (var i : Number = 0; i < _selectedIndices.size(); i++) {
			_arr.push(_dataProvider.getItemAt(Number(_selectedIndices.getItemAt(i))));
		}
		return _arr;
	}
	/**
	 * 获取和设置单选列表中的已选择项目
	 * @param  value:Object - 
	 * @return Object 
	 */
	public function set selectedItem(value:Object){
		if(selectable) selectedIndex = _dataProvider.getItemIndex(value);
	}
	public function get selectedItem() :Object{
		if(!selectable) return null;
		return _dataProvider.getItemAt(selectedIndex);
	}
	
	/**
	 * 获取和设置列表中是 (true) 否 (false) 允许多选
	 * @param  value:Boolean - 
	 * @return Boolean 
	 */
	public function set multipleSelection(value:Boolean) :Void{
		_multipleSelection = value;
	}
	public function get multipleSelection() :Boolean{
		return _multipleSelection;
	}
	/**
	 * 获取数据长度
	 * @param  value:Number - 
	 * @return Number 
	 */
	public function get length() :Number{
		return _dataProvider.size();
	}
	/**
	 * 获取和设置数据
	 * @param  value:Object - 
	 * @return Object 
	 */
	public function set dataProvider(value) :Void{
		if(_dataProvider != undefined) {
			_dataProvider.removeListener("dataChanged",__dataChangedHandler);
		}
		var _listDataFormatter:IDataFormatter = new ListDataFormatter();
		_dataProvider = _listDataFormatter.format(value);
		_dataProvider.addListener("dataChanged",__dataChangedHandler);
		
		dataChangedHandler();
		//_dataProvider.updateViews();
	}
	public function get dataProvider():Object{
		return _dataProvider;
	}
	private function dataChangedHandler() : Void {
		throw new UnsupportedOperationException("ListBase.dataChangedHandler方法无法执行，需要在其子类实现",this);
	}
	
	private function onKeyDown():Void{
		if(multipleSelection){
			switch (Key.getCode()) {
			    case Key.SHIFT :
			    	_isdownShiftKey = true;
			    	break;
			    case Key.CONTROL :
			    	_isdownCtrlKey = true;
			   	 	break;
			}
		}
	}
	private function onKeyUp():Void{
		_isdownShiftKey = _isdownCtrlKey = false;
	}
}