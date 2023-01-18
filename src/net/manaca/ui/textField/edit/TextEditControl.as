import net.manaca.lang.BObject;
import net.manaca.lang.exception.IllegalArgumentException;
import net.manaca.util.Delegate;

/**
 * 
 * @author Wersling
 * @version 1.0, 2006-4-25
 */
class net.manaca.ui.textField.edit.TextEditControl extends BObject {
	private var className : String = "net.manaca.ui.textField.edit.TextEditControl";
	private var _edit_text : TextField;
	private var _isEdit : Boolean;
	//编辑记录
	private var _record : Array;
	private var _text_begin : Number;
	private var _text_end : Number;
	private var _text_cursor : Number;
	//当前文本格式化对象
	private var _currentFormat : TextFormat;
	//更新文本框状态ID
	private var _text_time_out : Number;
	
	
	public function TextEditControl(textFied:TextField) {
		super();
		
		if(textFied != undefined && (typeof textFied == "object")){
			_edit_text = textFied;
		}else{
			throw new IllegalArgumentException("在构造一个元件编辑器时缺少编辑位置参数",this,arguments);
		}
		_isEdit = false;
		_record = new Array();
		_edit_text.onSetFocus = Delegate.create(this,onTextSetFocus);
		_edit_text.onKillFocus = Delegate.create(this,onTextKillFocus);
		;
	}
	
	/**
	 * 开始编辑
	 */
	public function startEdit():Void{
		_isEdit = true;
	}
	
	/**
	 * 结束编辑
	 */
	public function endEdit():Void{
		_isEdit = false;
	}
	
	/**
	 * 指示段落的对齐方式的字符串
	 * @param  value  参数类型：String 
			<li>"left"--段落为左对齐。 </li>
			<li>"center"--段落居中。 </li>
			<li>"right"--段落为右对齐。 </li>
			<li>"justify"--段落为两端对齐。（Flash Player 8 中添加了此值。） </li>
	 * @return 返回值类型：String 
	 */
	public function set align(value:String) :Void
	{
		setTextEditPlace();
		if(value == undefined ) value = "left";
		var _nowFormat:TextFormat = _currentFormat;
		_nowFormat.align = value;
		_edit_text.setTextFormat(_text_begin, _text_end, _nowFormat);
	}
	public function get align() :String
	{
		return _currentFormat.align;
	}
	
	/**
	 * 以磅为单位指示块缩进的数字
	 * @param  value  参数类型：Number 
	 * @return 返回值类型：Number 
	 */
	public function set blockIndent(value:Number) :Void
	{
		setTextEditPlace();
		if(value == undefined ) value = 10;
		var _nowFormat:TextFormat = _currentFormat;
		_nowFormat.blockIndent = value;
		_edit_text.setTextFormat(_text_begin, _text_end, _nowFormat);
	}
	public function get blockIndent() :Number
	{
		return _currentFormat.blockIndent;
	}
	
	/**
	 * 指示文本是否为粗体字
	 * @param  value  参数类型：Boolean 
	 * @return 返回值类型：Boolean 
	 */
	public function set bold(value:Boolean) :Void
	{
		setTextEditPlace();
		if(value == undefined )value = false;
		var _nowFormat:TextFormat = _currentFormat;
		_nowFormat.bold = value;
		_edit_text.setTextFormat(_text_begin, _text_end, _nowFormat);
	}
	public function get bold() :Boolean
	{
		return _currentFormat.bold;
	}
	
	/**
	 * 指示文本为带项目符号的列表的一部分
	 * @param  value  参数类型：Boolean 
	 * @return 返回值类型：Boolean 
	 */
	public function set bullet(value:Boolean) :Void
	{
		setTextEditPlace();
		if(value == undefined ) value = null;
		var _nowFormat:TextFormat = _currentFormat;
		_nowFormat.bullet = value;
		_edit_text.setTextFormat(_text_begin, _text_end, _nowFormat);
	}
	public function get bullet() :Boolean
	{
		return _currentFormat.bullet;
	}
	
	/**
	 * 指示文本的颜色
	 * @param  value  参数类型：Number 
	 * @return 返回值类型：Number 
	 */
	public function set color(value:Number) :Void
	{
		setTextEditPlace();
		if(value == undefined ) value = 0x000000;
		var _nowFormat:TextFormat = _currentFormat;
		_nowFormat.color = value;
		_edit_text.setTextFormat(_text_begin, _text_end, _nowFormat);
	}
	public function get color() :Number
	{
		return _currentFormat.color;
	}
	
	/**
	 * 使用此文本格式的文本的字体名称
	 * @param  value  参数类型：String 
	 * @return 返回值类型：String 
	 */
	public function set font(value:String) :Void
	{
		setTextEditPlace();
		if(value == undefined ) value = null;
		var _nowFormat:TextFormat = _currentFormat;
		_nowFormat.font = value;
		_edit_text.setTextFormat(_text_begin, _text_end, _nowFormat);
	}
	public function get font() :String
	{
		return _currentFormat.font;
	}
	
	/**
	 * 指示从左边距到段落中第一个字符的缩进的整数
	 * @param  value  参数类型：Number 
	 * @return 返回值类型：Number 
	 */
	public function set indent (value:Number) :Void
	{
		setTextEditPlace();
		if(value == undefined ) value = null;
		var _nowFormat:TextFormat = _currentFormat;
		_nowFormat.indent  = value;
		_edit_text.setTextFormat(_text_begin, _text_end, _nowFormat);
	}
	public function get indent () :Number
	{
		return _currentFormat.indent ;
	}
	
	/**
	 * 指示文本是否为斜体
	 * @param  value  参数类型：Boolean 
	 * @return 返回值类型：Boolean 
	 */
	public function set italic(value:Boolean) :Void
	{
		setTextEditPlace();
		if(value == undefined )value = false;
		var _nowFormat:TextFormat = _currentFormat;
		_nowFormat.italic = value;
		_edit_text.setTextFormat(_text_begin, _text_end, _nowFormat);
	}
	public function get italic() :Boolean
	{
		return _currentFormat.italic;
	}
	
	/**
	 * 指示是启用还是禁用字距调整
	 * @param  value  参数类型：Boolean 
	 * @return 返回值类型：Boolean 
	 */
	public function set kerning(value:Boolean) :Void
	{
		setTextEditPlace();
		if(value == undefined ) value = false;
		var _nowFormat:TextFormat = _currentFormat;
		_nowFormat.kerning = value;
		_edit_text.setTextFormat(_text_begin, _text_end, _nowFormat);
	}
	public function get kerning() :Boolean
	{
		return _currentFormat.kerning;
	}
	
	/**
	 * 使用此文本格式的文本的磅值。默认值为 null，它指示该属性未定义。
	 * @param  value  参数类型：Number 
	 * @return 返回值类型：Number 
	 */
	public function set size(value:Number) :Void
	{
		setTextEditPlace();
		if(value == undefined ) value = null;
		var _nowFormat:TextFormat = _currentFormat;
		_nowFormat.size  = value;
		_edit_text.setTextFormat(_text_begin, _text_end, _nowFormat);
	}
	public function get size () :Number
	{
		return _currentFormat.size ;
	}
	
	/**
	 * 指示文本是否为下划线
	 * @param  value  参数类型：Boolean 
	 * @return 返回值类型：Boolean 
	 */
	public function set underline(value:Boolean) :Void
	{
		setTextEditPlace();
		if(value == undefined )value = false;
		var _nowFormat:TextFormat = _currentFormat;
		_nowFormat.underline = value;
		_edit_text.setTextFormat(_text_begin, _text_end, _nowFormat);
	}
	public function get underline() :Boolean
	{
		return _currentFormat.underline;
	}
	
	
	/**
	 * 设置文字选择位置
	 */
	private function setTextEditPlace():Void{
		//Selection.setFocus(_edit_text);
		Selection.setSelection(_text_begin, _text_end);
	}
	
	/**
	 * 更新文本框状态
	 * @throws updataTextFormat 改变但前文本格式化对象
	 */
	private function updateParameter() : Void {
		var _obj = Selection.getFocus(); 
		if (_obj == String(_edit_text)) {
			_text_begin = Selection.getBeginIndex(); 
			_text_end = Selection.getEndIndex(); 
			_text_cursor = Selection.getCaretIndex(); 
			var _cf = _edit_text.getTextFormat(_text_begin, _text_end);
			if(_cf != _currentFormat){
				_currentFormat = _cf;
				this.dispatchEvent({type:"updataTextFormat",value:_currentFormat});
			}
		}
	}
	
	/**
	 * 文本框获得焦点
	 */
	private function onTextSetFocus() : Void {
		clearInterval(_text_time_out);
		_text_time_out = setInterval(this,"updateParameter",100);
	}
	
	/**
	 * 文本框失去焦点
	 */
	private function onTextKillFocus() : Void {
		clearInterval(_text_time_out);
	}

}