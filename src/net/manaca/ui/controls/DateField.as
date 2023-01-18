import net.manaca.ui.controls.UIComponent;
import net.manaca.ui.controls.skin.IDateFieldSkin;
import net.manaca.ui.controls.skin.SkinFactory;
import net.manaca.ui.awt.Dimension;
import net.manaca.ui.controls.TextInput;
import net.manaca.ui.controls.Button;
import net.manaca.util.Delegate;
import net.manaca.lang.event.ButtonEvent;
import net.manaca.util.DepthControl;
import net.manaca.ui.controls.DateChooser;
import net.manaca.util.MovieClipUtil;
import net.manaca.globalization.Locale;
import net.manaca.globalization.calendar.GregorianCalendar;
import net.manaca.text.format.DateFormat;
import net.manaca.ui.controls.skin.mnc.DateFieldSkin;

/**
 * 日期选择类
 * @author Wersling
 * @version 1.0, 2006-5-25
 */
class net.manaca.ui.controls.DateField extends UIComponent {
	private var className : String = "net.manaca.ui.controls.DateField";
	private var _componentName:String = "DateField";
	private var _skin:IDateFieldSkin;

	private var _button : Button;
	private var _textField : TextInput;
	private var _dateChooser : DateChooser;
	
	private var _dateChooserState : Boolean;

	
	function DateField(target : MovieClip, new_name : String) {
		super(target, new_name);
//		_skin = SkinFactory.getInstance().getDefault().createDateFieldSkin();
		_skin = new DateFieldSkin();
		_preferredSize = new Dimension(100,18);
		this.paintAll();
		init();
	}

	private function init() : Void {
		
		_dateChooser = _skin.getDateChooser();
		_dateChooser.addEventListener(ButtonEvent.CHANGE,Delegate.create(this,onChangeDate));
		_textField = _skin.getTextInput();
		_textField.editable = false;
		
		_button = _skin.getClickButton();
		_button.addEventListener(ButtonEvent.RELEASE,Delegate.create(this,onClickButton));
		
		_dateChooserState = true;
		close();
		showDate(_dateChooser.selectedDate);
	}
	//点击按钮
	private function onClickButton():Void{
		DepthControl.bringToFront(this.getDisplayObject());
		setFocus();
		if(_dateChooserState){
			close();
		}else{
			open();
		}
	}
	private function onChangeDate(e:ButtonEvent) : Void {
		showDate(_dateChooser.selectedDate);
		this.dispatchEvent(new ButtonEvent(ButtonEvent.CHANGE,e.value,this));
		close();
	}
	private function showDate(d:Date):Void{
		if(d != null){
			var str = locale.cultureInfo.longDate;
			var ic:GregorianCalendar = new GregorianCalendar(d);
			var td:DateFormat = new DateFormat(str,locale);
			_textField.text = td.format(ic);
		}else{
			_textField.text = "";
		}
	}
	/**
	 * close list
	 */
	public function close():Void{
		if(_dateChooserState){
			_dateChooser.setVisible(false);
			_dateChooserState = false;
			this._domain.onMouseDown = null;
			delete this._domain.onMouseDown;
		}
	}
	
	/**
	 * open list
	 */
	public function open():Void{
		if(!_dateChooserState){
			_dateChooser.setVisible(true);
			_dateChooserState = true;
			this._domain.onMouseDown = Delegate.create(this,onMouse_Down);
		}
	}
	/**
	 * 获取和设置
	 * @param  value:Locale - 
	 * @return Locale 
	 */
	public function set locale(value:Locale) :Void{
		_dateChooser.locale = value;
		showDate(_dateChooser.selectedDate);
	}
	public function get locale() :Locale{
		return _dateChooser.locale;
	}
	
	/**
	 * 获取和设置按钮提示，默认为["Back Year","Back Month","Next Month","Next Year","Current Date"]
	 * @param  value:Array - 
	 * @return Array 
	 */
	public function set toolTips(value:Array) :Void{
		_dateChooser.toolTips = value;
	}
	public function get toolTips() :Array{
		return _dateChooser.toolTips;
	}
	/**
	 * 获取和设置所选日期
	 * @param  value:Date - 
	 * @return Date 
	 */
	public function set selectedDate(value:Date) :Void{
		if(value instanceof Date){
			_dateChooser.selectedDate = value;
			showDate(_dateChooser.selectedDate);
		}
	}
	public function get selectedDate() :Date{
		return _dateChooser.selectedDate;
	}
	/**
	 * 设置选择器的大小，其值最好为：setChooserSize(width*7+10,height*8+11);
	 */
	public function setChooserSize(width:Number,height:Number):Void{
		_dateChooser.setSize(width,height);
	}
	private function getDateString(d:Date):String{
		return d.getFullYear()+"_"+(d.getMonth()+1)+"_"+d.getDate();
	}
	//鼠标按下
	private function onMouse_Down():Void{
		if (!MovieClipUtil.mouseSuperpose(_domain) && _dateChooser) {
			close();
		}
	}


}