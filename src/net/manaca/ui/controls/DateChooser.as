import net.manaca.ui.controls.UIComponent;
import net.manaca.ui.controls.skin.IDateChooserSkin;
import net.manaca.ui.awt.Dimension;
import net.manaca.ui.controls.Panel;
import net.manaca.globalization.Locale;
import net.manaca.globalization.calendar.GregorianCalendar;
import net.manaca.text.format.DateFormat;
import net.manaca.ui.controls.dateClasses.MonthElement;
import net.manaca.ui.controls.dateClasses.DayElement;
import net.manaca.util.Delegate;
import net.manaca.lang.event.ButtonEvent;
import net.manaca.ui.controls.skin.mnc.DateChooserSkin;
import net.manaca.ui.controls.dateClasses.DateItemRenderer;
import net.manaca.ui.controls.listClasses.ListData;
[Event("change")]
/**
 * 日期选择器
 * TODO 按钮颜色显示不正常
 * TODO 1号为周日时，列表存在问题（多显示了一天）
 * @author Wersling
 * @version 1.0, 2006-5-24
 */
class net.manaca.ui.controls.DateChooser extends UIComponent {
	private var className : String = "net.manaca.ui.controls.DateChooser";
	private var _componentName = "DateChooser";
	private var _skin:IDateChooserSkin;
	private var _selectedDate : Date;
	private var _showToday : Boolean = true;
	private var _panel : Panel;
	private var _cellList:Object;
	private var _locale : Locale;
	private var _monthElement : MonthElement;

	private var _year : Number;
	private var _month : Number;
	private var _day : Number;
	
	private var _toolTips : Array;
	private var _now_SelectedDay:DateItemRenderer;
	
	private var _onSelectedDay : Function;

	private var __w : Number = 29;
	private var __h : Number = 20;
	public function DateChooser(target : MovieClip, new_name : String) {
		super(target, new_name);
//		_skin = SkinFactory.getInstance().getDefault().createDateChooserSkin();
		_skin = new DateChooserSkin();
		_preferredSize = new Dimension(213,171);
		
		this.paintAll();
		init();
	}
	private function init():Void{
		
		_panel = _skin.getPanel();
		
		_locale = Locale.getDefault();
		_toolTips = ["Back Year","Back Month","Next Month","Next Year","Current Date"];
		_selectedDate = new Date();
		_cellList = new Object();
		
		_onSelectedDay = Delegate.create(this,onSelectedDay);
		
		createWeekCell();
		createDayCell();
		createButton();
		updateSize();
		updateDate(null,"now_day");
	}
	//当选择一个日期时
	private function onSelectedDay(e:ButtonEvent) : Void {
		if(e.target != _now_SelectedDay){
			_now_SelectedDay.setSelected("normal");
			_now_SelectedDay = DateItemRenderer(e.target);
			_now_SelectedDay.setSelected("selected");
			var _day = Number(e.target.getValue().labelField);
			_selectedDate = new Date(_year,_month,_day);
			this.dispatchEvent(new ButtonEvent(ButtonEvent.CHANGE,_selectedDate,this));
		}else{
			_now_SelectedDay.setSelected("normal");
			_now_SelectedDay = null;
			_selectedDate = null;
			this.dispatchEvent(new ButtonEvent(ButtonEvent.CHANGE,_selectedDate,this));
		}
	}
	//建立日期单元
	private function createDayCell():Void{
		for (var i : Number = 0; i < 42; i++) {
			var _b:MovieClip = _panel.getBoard();
			var _day:DateItemRenderer = new DateItemRenderer(_b,"Day"+i);
			_day.availability = false;
			var t = _day.getTextFormat();
			t.align = "center";
			 _day.setTextFormat(t);
			 _day.addEventListener(ButtonEvent.RELEASE,_onSelectedDay);
			_cellList["Day"+i] = _day;
		}
	}
	/**
	 * 更新日期列表
	 */
	private function updateDateList():Void{
		var str = "E";
		var s = _monthElement.firstWeek-_locale.cultureInfo.firstDay;
		for (var i : Number = 0; i < 42; i++) {
			var _day:DateItemRenderer = DateItemRenderer(_cellList["Day"+i]);
			_day.setSelected("normal");
			if(i >= s && i <= _monthElement.size()){
				_day.availability = true;
				var de:DayElement =DayElement(_monthElement.Get(i-s));
				_day.setValue(new ListData(de.getGregorianCalendar().getDay().toString()));
				if(getDateString(_selectedDate) == getDateString(new Date(_year,_month,i-s+1))){
					_day.setSelected("selected");
					_now_SelectedDay = _day;
				}
				//颜色
				var f:TextFormat = _day.getTextFormat();
				if(de.getGregorianCalendar().getWeek() == 0) f.color = 0xff0000;
				if(de.getGregorianCalendar().getWeek() == 6) f.color = 0x0066ff;
				_day.setTextFormat(f);
			}else{
				_day.availability = false;
				_day.setValue(new ListData(""));
			}
		}
	}
	//建立星期显示单元
	private function createWeekCell():Void{
		for (var i : Number = 0; i < 7; i++) {
			var _b:MovieClip = _panel.getBoard();
			var _a_week_cell:DateItemRenderer = new DateItemRenderer(_b,"Week"+i);
			_a_week_cell.availability = false;
			_a_week_cell.setBackgroundType("border_hight_color");
			var t = _a_week_cell.getTextFormat();
			t.align = "center";
			 _a_week_cell.setTextFormat(t);
			_cellList["Week"+i] = _a_week_cell;
		}
		updateWeek();
	}
	//更新星期信息
	private function updateWeek():Void{
		var str = "E";
		for (var i : Number = 0; i < 7; i++) {
			var _week:DateItemRenderer = DateItemRenderer(_cellList["Week"+i]);
			var _d:Date = new Date(2006,3,23+i+_locale.cultureInfo.firstDay);
			var ic:GregorianCalendar = new GregorianCalendar(_d);
			//颜色
			var f:TextFormat = _week.getTextFormat();
			if(ic.getWeek() == 0) f.color = 0xff0000;
			if(ic.getWeek() == 6) f.color = 0x0066ff;
			var td:DateFormat = new DateFormat(str,_locale);
			var _s:String = td.format(ic);
			if(__w < 29) _s = _s.substr(0,1);
			_week.setValue(new ListData(_s));
			_week.setTextFormat(f);
		}
	}
	//建立按钮
	private function createButton():Void{
		var _b:MovieClip = _panel.getBoard();
		var _butList:Array = new Array();
		//up_year_but
		var _but:DateItemRenderer = new DateItemRenderer(_b,"up_year_but");
		_but.setValue(new ListData("<--"));
		_but.toolTip = _toolTips[0];
		_butList.push(_but);
		_but.addEventListener(ButtonEvent.RELEASE,Delegate.create(this,updateDate,"up_year"));
		  _cellList["up_year"] = _but;
		//up_month_but
		var _but:DateItemRenderer = new DateItemRenderer(_b,"up_month_but");
		 _but.setValue(new ListData("<"));
		 _but.toolTip = _toolTips[1];
		 _butList.push(_but);
		 _but.addEventListener(ButtonEvent.RELEASE,Delegate.create(this,updateDate,"up_month"));
		  _cellList["up_month"] = _but;
		//down_year_but
		var _but:DateItemRenderer = new DateItemRenderer(_b,"down_year_but");
		 _but.setValue(new ListData("-->"));
		  _but.toolTip = _toolTips[3];
		 _butList.push(_but);
		 _but.addEventListener(ButtonEvent.RELEASE,Delegate.create(this,updateDate,"down_year"));
		  _cellList["down_year"] = _but;
		//down_month_but
		var _but:DateItemRenderer = new DateItemRenderer(_b,"down_month_but");
		 _but.setValue(new ListData(">"));
		  _but.toolTip = _toolTips[2];
		 _butList.push(_but);
		 _but.addEventListener(ButtonEvent.RELEASE,Delegate.create(this,updateDate,"down_month"));
		 _cellList["down_month"] = _but;
		//now_day_but
		var _but:DateItemRenderer = new DateItemRenderer(_b,"now_day_but");
		 _but.toolTip = _toolTips[4];
		_butList.push(_but);
		_but.addEventListener(ButtonEvent.RELEASE,Delegate.create(this,updateDate,"now_day"));
		_cellList["now_day"] = _but;
		
		var _butlist_len:Number = _butList.length;
		for (var i : Number = 0; i < _butlist_len; i++) {
			var _but:DateItemRenderer = _butList[i];
			_but.setBackgroundType("border_hight_color");
			var t = _but.getTextFormat();
			t.align = "center";
			 _but.setTextFormat(t);
			 _but.toggle = false;
		}
		
	}
	/**
	 * 更新日期
	 */
	private function updateDate():Void{
		var _event_type:String = arguments[1];
		switch (_event_type) {
		    case "up_year":
		        _year --;
		        break;
		    case "up_month":
		        _month --;
		        break;
		    case "down_year":
		        _year ++;
		        break;
		    case "down_month":
		        _month ++;
		        break;
		    case "now_day":
		      	_year = new  Date().getFullYear();
				_month = new Date().getMonth();
		        break;
		    default:
				break;
		}
		//更新 now_day_but
		var str:String = _locale.cultureInfo.monthDate;
		
		var _d:Date = new Date(_year,_month,1);
		var ic:GregorianCalendar = new GregorianCalendar(_d);
		var td:DateFormat = new DateFormat(str,_locale);
		var _but:DateItemRenderer = DateItemRenderer(_cellList["now_day"]);
		_but.setValue(new ListData(td.format(ic)));
		
		_monthElement = new MonthElement(_year,_month);
		updateDateList();
	}
	private function updataSize() : Void {
		super.updataSize();
		__w = int(this.getSize().getWidth()-10)/7;
		__h = int(this.getSize().getHeight()-11)/8;
		if(__w != (this.getSize().getWidth()-10)/7){
			var w = __w*7+10;
		}else{
			var w = this.getSize().getWidth();
		}
		if(__h != (this.getSize().getHeight()-11)/8){
			var h = __h*8+11;
		}else{
			var h = this.getSize().getHeight();
		}
		if(w != this.getSize().getWidth() || h != this.getSize().getHeight()){
			this.setSize(w,h);
		}else{
			updateSize();
			updateWeek();
		}
	}
	//更新大小
	private function updateSize() : Void {
		for (var i : Number = 0; i < 7; i++) {
			var _cell:DateItemRenderer = DateItemRenderer(_cellList["Week"+i]);
			_cell.setSize(__w,__h);
			_cell.setLocation((__w+1)*i,0);
		}
		for (var i : Number = 0; i < 42; i++) {
			var _cell:DateItemRenderer = DateItemRenderer(_cellList["Day"+i]);
			_cell.setSize(__w,__h);
			_cell.setLocation((__w+1)*(i%7),(Math.floor(i/7)+1)*(__h+1));
		}
		var _cell:DateItemRenderer = DateItemRenderer(_cellList["up_year"]);
		_cell.setSize(__w,__h);
		_cell.setLocation(0,7*(__h+1));
		var _cell:DateItemRenderer = DateItemRenderer(_cellList["up_month"]);
		_cell.setSize(__w,__h);
		_cell.setLocation((__w+1),7*(__h+1));
		var _cell:DateItemRenderer = DateItemRenderer(_cellList["down_year"]);
		_cell.setSize(__w,__h);
		_cell.setLocation((__w+1)*6,7*(__h+1));
		var _cell:DateItemRenderer = DateItemRenderer(_cellList["down_month"]);
		_cell.setSize(__w,__h);
		_cell.setLocation((__w+1)*5,7*(__h+1));
		var _cell:DateItemRenderer = DateItemRenderer(_cellList["now_day"]);
		_cell.setSize(__w+(__w+1)*2,__h);
		_cell.setLocation((__w+1)*2,7*(__h+1));
	}
	/**
	 * 获取和设置
	 * @param  value:Locale - 
	 * @return Locale 
	 */
	public function set locale(value:Locale) :Void{
		_locale = value;
		
		updateWeek();
		updateDate();
	}
	public function get locale() :Locale{
		return _locale;
	}
	
	/**
	 * 获取和设置按钮提示，默认为["Back Year","Back Month","Next Month","Next Year","Current Date"]
	 * @param  value:Array - 
	 * @return Array 
	 */
	public function set toolTips(value:Array) :Void{
		_toolTips = value;
	}
	public function get toolTips() :Array{
		return _toolTips;
	}
	/**
	 * 获取和设置所选日期
	 * @param  value:Date - 
	 * @return Date 
	 */
	public function set selectedDate(value:Date) :Void{
		if(value instanceof Date){
			_selectedDate = value;
			
			_year = value.getFullYear();
			_month = value.getMonth();
			_monthElement = new MonthElement(_year,_month);
			updateDateList();
		}
	}
	public function get selectedDate() :Date{
		return _selectedDate;
	}
	private function getDateString(d:Date):String{
		return d.getFullYear()+"_"+(d.getMonth()+1)+"_"+d.getDate();
	}
	/**
	 * 获取和设置是否加亮显示当前日期。默认值为  true。
	 * @param  value:Boolean - 
	 * @return Boolean 
	 */
//	public function set showToday(value:Boolean) :Void{
//		_showToday = value;
//	}
//	public function get showToday() :Boolean{
//		return _showToday;
//	}


}