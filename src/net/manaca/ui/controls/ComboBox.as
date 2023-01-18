import net.manaca.ui.controls.skin.IComboBoxSkin;
import net.manaca.ui.controls.skin.SkinFactory;
import net.manaca.ui.controls.UIComponent;
import net.manaca.ui.controls.List;
import net.manaca.ui.controls.TextInput;
import net.manaca.ui.controls.Button;
import net.manaca.ui.awt.Dimension;
import net.manaca.lang.event.ButtonEvent;
import net.manaca.util.Delegate;
import net.manaca.util.DepthControl;
import net.manaca.util.MovieClipUtil;
import net.manaca.lang.event.Event;
import net.manaca.ui.controls.listClasses.IListDataProvider;
import net.manaca.ui.controls.skin.mnc.ComboBoxSkin;

/**
 * 
 * @author Wersling
 * @version 1.0, 2006-5-23
 */
class net.manaca.ui.controls.ComboBox extends UIComponent {
	private var className : String = "net.manaca.ui.controls.ComboBox";
	private var _componentName:String = "ComboBox";
	private var _skin:IComboBoxSkin;
	
	private var _list:List;
	private var _textInput:TextInput;
	private var _button:net.manaca.ui.controls.Button;
	private var _dropdownWidth : Number;
	private var _rowCount : Number = 5;
	
	private var _listState:Boolean;
	public function ComboBox(target : MovieClip, new_name : String) {
		super(target, new_name);
//		_skin = SkinFactory.getInstance().getDefault().createComboBoxSkin();
		_skin = new ComboBoxSkin();
		_preferredSize = new Dimension(100,18);
		
		paintAll();
		init();
	}
	private function init():Void{
		_list = _skin.getList();
		_list.addEventListener(Event.CHANGE,Delegate.create(this,onChangeItem));
		
		_textInput = _skin.getTextInput();
		_textInput.addEventListener(Event.ENTER,Delegate.create(this,onTextInputEnter));
		
		_button = _skin.getClickButton();
		_button.addEventListener(ButtonEvent.RELEASE,Delegate.create(this,onClickButton));
		
		dataProvider.addListener("dataChanged",Delegate.create(this,dataChangedHandler));
		
		editable = false;
		_listState = true;
		close();
	}
	private function onTextInputEnter(e:Event):Void{
		this.text = String(e.value);
		this.dispatchEvent(new Event(Event.ENTER,e.value,this));
	}
	//选择一项目时
	private function onChangeItem(e:Event):Void{
		//this.text = _list.selectedItem.text;
		selectedItem = _list.selectedItem;
		updateTextInput();
		this.dispatchEvent(new Event(Event.CHANGE,selectedItem,this));
		close();
	}
	
	private function updateTextInput():Void{
		this.text = _list.itemToLabel(selectedItem);
	}
	
	//数据发生改变时
	private function dataChangedHandler():Void{
//		_list.updateScroll();
		if(_textInput.text == undefined || _textInput.text == ""){
//			var t:String = _list.selectedItem.label;
//			if(t == undefined && dataProvider.size() > 0)
//				t = this.dataProvider.getItemAt(0).label;
			_list.selectedIndex = 0;
			
			updateTextInput();
		}
		_skin.updateSize();
	}
	
	//点击按钮
	private function onClickButton():Void{
		DepthControl.bringToFront(this.getDisplayObject());
		setFocus();
		if(_listState){
			close();
		}else{
			open();
		}
	}
	
	//鼠标按下
	private function onMouse_Down():Void{
		if (!MovieClipUtil.mouseSuperpose(_domain) && _listState) {
			close();
		}
	}
	/**
	 * close list
	 */
	public function close():Void{
		if(_listState){
			_list.setVisible(false);
			_listState = false;
			this._domain.onMouseDown = null;
			delete this._domain.onMouseDown;
		}
	}
	
	/**
	 * open list
	 */
	public function open():Void{
		if(this.length > 0 && !_listState){
			_list.setVisible(true);
			_listState = true;
			this._domain.onMouseDown = Delegate.create(this,onMouse_Down);
		}
	}

	/** 失去焦点时触发 */
	public function onKillFocus(newFocus:UIComponent):Void{
		super.onKillFocus(newFocus);
		this.close();
	}
	
	/**
	 * 获取和设置数据源
	 * @param  value:Object - 
	 * @return Object 
	 */
	public function set dataProvider(value:Object) :Void{
		_list.dataProvider = value;
	}
	public function get dataProvider() :Object{
		return (_list.dataProvider);
	}
	
	/**
	 * 获取和设置每个项目中的一个字段用作显示文本。此属性会获得该字段的值，并将其用作标签。默认值为 "label"。
	 * @param  value:String - 
	 * @return String 
	 */
	public function set labelField(value:String) :Void{
		_list.labelField = value;
	}
	public function get labelField() :String{
		return _list.labelField;;
	}
	
	/**
	 * 获取和设置用于确定显示每个项目的哪个字段（或字段组合）的函数。
	 * 此函数会接收一个参数 item（该参数指示所呈现的项），并且必须返回一个表示要显示的文本的字符串。
	 * @param  value:Function - 
	 * @return Function 
	 */
	public function set labelFunction(value:Function) :Void{
		_list.labelFunction = value;
	}
	public function get labelFunction() :Function{
		return _list.labelFunction;
	}
	
	/**
	 * 获取和设置下拉列表的宽度（以像素为单位）。
	 * @param  value:Number - 
	 * @return Number 
	 */
	public function set dropdownWidth(value:Number) :Void{
		_dropdownWidth = value;
		_skin.updateSize();
	}
	public function get dropdownWidth() :Number{
		return _dropdownWidth;
	}
	
	/**
	 * 获取和设置组合框是否可以编辑
	 * @param  value:Boolean - 
	 * @return Boolean 
	 */
	public function set editable(value:Boolean) :Void{
		_textInput.editable = value;
	}
	public function get editable() :Boolean{
		return _textInput.editable;
	}
	
	/**
	 * 获取下拉列表的长度
	 * @param  value:Number - 
	 * @return Number 
	 */
	public function get length() :Number{
		return this.dataProvider.size();
	}
	
	/**
	 * 获取和设置用户可在组合框的文本字段中输入的字符集
	 * @param  value:String - 
	 * @return String 
	 */
	public function set restrict(value:String) :Void{
		_textInput.restrict = value;
	}
	public function get restrict() :String{
		return _textInput.restrict;
	}
	
	/**
	 * 获取和设置列表一次可以显示的最大项目数
	 * @param  value:Number - 
	 * @return Number 
	 */
	public function set rowCount(value:Number) :Void{
		_rowCount = value;
		_skin.updateSize();
	}
	public function get rowCount() :Number{
		return _rowCount;
	}
	
	/**
	 * 获取和设置下拉列表中所选项目的索引
	 * @param  value:Number - 
	 * @return Number 
	 */
	public function set selectedIndex(value:Number) :Void{
		_list.selectedIndex = value;
	}
	public function get selectedIndex() :Number{
		return _list.selectedIndex;
	}
	
	/**
	 * 获取和设置下拉列表中所选项目的值
	 * @param  value:Object - 
	 * @return Object 
	 */
	public function set selectedItem(value:Object) :Void{
		_list.selectedItem = value;
	}
	public function get selectedItem() :Object{
		return _list.selectedItem;
	}
	
	/**
	 * 获取和设置文本框中文本的字符串
	 * @param  value:String - 
	 * @return String 
	 */
	public function set text(value:String) :Void{
		_textInput.text = value;
	}
	public function get text() :String{
		return _textInput.text;
	}
	
	/**
	 * 获取组合框中 TextInput 组件的引用
	 * @param  value:TextInput - 
	 * @return TextInput 
	 */
	public function get textField() :TextInput{
		return _textInput;
	}

}