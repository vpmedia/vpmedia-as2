﻿import net.manaca.ui.controls.esse.EsseUIComponent;import net.manaca.lang.event.Event;import net.manaca.ui.controls.TextArea;import TextField.StyleSheet;[IconFile("icon/TextArea.png")]///**// * 在用户选择一个列表项时// *///[Event("change")]/** * MNCTextArea 组件 * @author Wersling * @version 1.0, 2006-5-29 */class net.manaca.ui.controls.esse.MNCTextArea extends EsseUIComponent{	private var className : String =  "net.manaca.ui.controls.esse.MNCTextArea";	private var _componentName:String = "MNCTextArea";	private var _component:TextArea;	private var _createFun:Function = TextArea;	private var _editable : Boolean = true;	private var _hScrollPolicy : String = "off";	private var _html : Boolean = false;	private var _maxChars : Number = null;	private var _text : String = "";	private var _styleSheet : StyleSheet = null;	private var _wordWrap : Boolean = true;	 /**	  * 构造 MNCTextArea	  * @param 无	  */	 public function MNCTextArea() {	 	super();	 }	 private function init():Void{		super.init();		editable = _editable;		hScrollPolicy = _hScrollPolicy;		html = _html;		maxChars = _maxChars;		text = _text;		wordWrap = _wordWrap;		_component.text = _text;		//_component.onChanged();		//this.addListener(Event.CHANGE);	}		/**	 * 获取和设置该字段是 (true) 否 (false) 可编辑，默认 true	 * @param  value:Boolean - 	 * @return Boolean 	 */	[Inspectable(name="editable",type=Boolean,defaultValue= true )]	public function set editable(value:Boolean) :Void{		_editable = value;		_component.editable = _editable;	}	public function get editable() :Boolean{		return _editable;	}		/**	 * 获取和设置水平滚动条是始终打开 (on)、从不打开 (off) 还是在需要时打开 (auto)。默认值为 off。	 * @summary 获取和设置水平滚动条是始终打开	 * @param  value:String - 	 * @return String 	 */	[Inspectable(name="hScrollPolicy",type=String,defaultValue="off" )]	public function set hScrollPolicy(value:String) :Void{		_hScrollPolicy = value;		_component.horizontalScrollPolicy = _hScrollPolicy;	}	public function get hScrollPolicy() :String{		return _hScrollPolicy;	}		/**	 * 获取和设置文本区域的内容是否可以采用 HTML 格式,默认值为 false	 * @param  value:Boolean - 	 * @return Boolean 	 */	[Inspectable(name="html",type=Boolean,defaultValue=false )]	public function set html(value:Boolean) :Void{		_html = value;		_component.html = _html;	}	public function get html() :Boolean{		return _html;	}		/**	 * 获取文本区域中的字符数	 * @param  value:Number - 	 * @return Number 	 */	public function get length() :Number	{		return _component.length;	}		/**	 * 获取和设置文本区域最多可以容纳的字符数，默认为 null	 * @param  value:Number - 	 * @return Number 	 */	[Inspectable(name="maxChars",type=Number,defaultValue=null )]	public function set maxChars(value:Number) :Void{		_maxChars = value;		_component.maxChars = _maxChars;	}	public function get maxChars() :Number{		return _maxChars;	}		/**	 * 获取和设置文本内容	 * @param  value:String - 	 * @return String 	 */	[Inspectable(name="text",type=String,defaultValue="" )]	public function set text(value:String) :Void{		_text = value;		_component.text = _text;	}	public function get text() :String{		return _text;	}		/**	 * 获取和设置文本样式表	 * @param  value:StyleSheet - 	 * @return StyleSheet 	 */	public function set styleSheet(value:StyleSheet) :Void{		_styleSheet = value;		_component.styleSheet = _styleSheet;	}	public function get styleSheet() :StyleSheet{		return _styleSheet;	}		/**	 * 获取和设置文本是 (true) 否 (false) 自动换行,默认值为 true	 * @param  value:Boolean - 	 * @return Boolean 	 */	[Inspectable(name="wordWrap",type=Boolean,defaultValue= true )]	public function set wordWrap(value:Boolean) :Void{		_wordWrap = value;		_component.wordWrap = _wordWrap;	}	public function get wordWrap() :Boolean{		return _wordWrap;	}}