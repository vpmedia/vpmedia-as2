import net.manaca.ui.controls.UIComponent;
import net.manaca.ui.controls.skin.IProgressBarSkin;
import net.manaca.ui.controls.skin.SkinFactory;
import net.manaca.ui.awt.Dimension;
import net.manaca.ui.controls.Label;
import net.manaca.text.format.MessageFormat;
import net.manaca.ui.controls.skin.mnc.ProgressBarSkin;

/**
 * ProgressBar 组件显示加载内容的进度
 * @author Wersling
 * @version 1.0, 2006-5-19
 */
class net.manaca.ui.controls.ProgressBar extends UIComponent {
	private var className : String = "net.manaca.ui.controls.ProgressBar";
	private var _componentName = "ProgressBar";
	private var _skin:IProgressBarSkin;
	private var _indeterminate : Boolean;
	private var _label : String = "LOADING {3}%";
	private var _mode : String;
	private var _source : Object;
	private var _value : Number = 5;
	private var _total : Number = 100;
	private var _bar:MovieClip;
	private var _textFild : Label;
	private var _conversion : Number =1;
	public function ProgressBar(target : MovieClip, new_name : String) {
		super(target, new_name);
//		_skin = SkinFactory.getInstance().getDefault().createProgressBarSkin();
		_skin = new ProgressBarSkin();
		_preferredSize = new Dimension(100,25);
		this.paintAll();
		init();
	}
	
	private function init():Void{
		_bar = _skin.getBar();
		_textFild = _skin.getLabel();
	}
	private function updateBar():Void{
		_bar._width = this.getSize().getWidth()*this.percentComplete/100;
		_textFild.text = MessageFormat.formatSingle(_label,[null,Math.ceil(_value/_conversion),Math.ceil(total/_conversion),this.percentComplete]);
	}
	
	/**
	 * 在进度栏处于手动模式时，设置进度栏的状态以反映已经完成的进度量
	 * @param completed:Number - 已完成的
	 * @param total:Number - 总量
	 */
	public function setProgress(completed:Number, total:Number):Void{
		if(completed != undefined) _value = completed;
		if(total != undefined) _total = total;
		updateBar();
	}
	
	/**
	 * 获取和设置设置进入值的转换值。它除当前值和总值，将它们向下取整，然后在 label 属性中显示转换后的值。默认值为 1。
	 * @param  value:Number - 
	 * @return Number 
	 */
	public function set conversion(value:Number) :Void{
		_conversion = value;
	}
	public function get conversion() :Number{
		return _conversion;
	}
	
	/**
	 * 获取和设置加载源的大小是否是未知的
	 * @param  value:Boolean - 
	 * @return Boolean 
	 */
	public function set indeterminate(value:Boolean) :Void{
		_indeterminate = value;
	}
	public function get indeterminate() :Boolean{
		return _indeterminate;
	}
	
	/**
	 * 获取和设置进度栏随附的文本
	 * @param  value:String - 加载进度的文本，默认 LOADING {3}%
	 * <li> 1 是当前已加载字节数的占位符</li>
	 * <li> 2 是总共要加载的字节数的占位符</li>
	 * <li> 3 是已加载内容所占百分比的占位符</li>
	 * @example
	 * 	LOADING {2}
	 * @return String 
	 */
	public function set label(value:String) :Void{
		_label = value;
	}
	public function get label() :String{
		return _label;
	}
		
	/**
	 * 获取和设置进度栏加载内容的模式。此值可以是 "event"（事件模式）、"polled"（轮询模式）或 "manual"（手动模式）。 默认manual
	 * @param  value:String - 
	 * @return String 
	 */
	public function set mode(value:String) :Void{
		_mode = value;
	}
	public function get mode() :String{
		return _mode;
	}
	
	/**
	 * 只读；指示加载百分比的数字
	 * @param  value:Number - 
	 * @return Number 
	 */
	public function get percentComplete() :Number{
		return int((value/total)*100);
	}
	
	/**
	 * 获取和设置对要加载的实例的引用，该实例的加载进程将会显示.默认值为 undefined。
	 * @param  value:Object - 
	 * @return Object 
	 */
	public function set source(value:Object) :Void{
		_source = value;
	}
	public function get source() :Object{
		return _source;
	}
	
	/**
	 * 获取和设置
	 * @param  value:Number - 
	 * @return Number 
	 */
	public function get value() :Number{
		return _value;
	}
	
	/**
	 * 获取和设置
	 * @param  value:Number - 
	 * @return Number 
	 */
	public function get total() :Number{
		return _total;
	}
	
}