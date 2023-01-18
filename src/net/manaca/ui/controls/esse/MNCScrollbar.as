﻿import net.manaca.ui.controls.esse.EsseUIComponent;import net.manaca.lang.event.Event;import net.manaca.ui.controls.ScrollbarY;[IconFile("icon/Scrollbar.png")]/** * 当用户按下滚动条按钮、滚动框（滑块）或滚动轨道时，向所有已注册的侦听器广播， * 此事件抛出以下值 * <li> value:Number 当前滚动位置</li> * <li> target:Object 组件指针</li> */[Event("scroll")]/** * MNCScrollbar 组件 * @author Wersling * @edition * @usage sdf * @version 1.0, 2006-5-29 */class net.manaca.ui.controls.esse.MNCScrollbar extends EsseUIComponent{	private var className : String =  "net.manaca.ui.controls.esse.MNCScrollbar";	private var _componentName:String = "MNCScrollbar";	private var _component:ScrollbarY;	private var _createFun:Function = ScrollbarY;	private var _horizontal : Boolean = false;	private var _lineScrollSize : Number = 1;	private var _pageScrollSize : Number = 1;	private var _scrollPosition : Number;	 /**	  * 构造 MNCScrollbar	  * @param 无	  */	 public function MNCScrollbar() {	 	super();	 }	 private function init():Void{		super.init();//		horizontal = _horizontal;		lineScrollSize = _lineScrollSize;		pageScrollSize = _pageScrollSize;				this.addListener(Event.SCROLL);	}	/**	 * 设置滚动条的每页显示值、最大滚动值和最小滚动值	 * @param pageSize:Number - 每页显示值	 * @param minPos:Number - 最小滚动值	 * @param maxPos:Number - 最大滚动值	 */	public function setScrollProperties(pageSize:Number,minPos:Number, maxPos:Number):Void{		_component.setScrollProperties(pageSize,minPos, maxPos);	}//	//	/**//	 * 获取和设置滚动条是垂直方向 (false)（默认）还是水平方向 (true)。默认值为 false。//	 * @param  value:Boolean - //	 * @return Boolean //	 *///	[Inspectable(name="horizontal",type=Boolean,defaultValue= false )]//	public function set horizontal(value:Boolean) :Void{//		_horizontal = value;//		_component. = _horizontal;//	}//	public function get horizontal() :Boolean{//		return _horizontal;//	}		/**	 * 获取和设置当用户单击滚动条的箭头按钮时滚动的行数或像素数，默认值为 1	 * @param  value:Number - 	 * @return Number 	 */	[Inspectable(name="lineScrollSize",type=Number,defaultValue= 1 )]	public function set lineScrollSize(value:Number) :Void{		_lineScrollSize = value;		_component.lineScrollSize = _lineScrollSize;	}	public function get lineScrollSize() :Number{		return _lineScrollSize;	}		/**	 * 获取和设置当用户单击滚动条的轨道时滚动的行数或像素数，默认值为 1	 * @param  value:Number - 	 * @return Number 	 */	[Inspectable(name="pageScrollSize",type=Number,defaultValue= 1 )]	public function set pageScrollSize(value:Number) :Void{		_pageScrollSize = value;		_component.pageScrollSize = _pageScrollSize;	}	public function get pageScrollSize() :Number{		return _pageScrollSize;	}		/**	 * 获取和设置滚动条当前的滚动位置	 * @param  value:Number - 	 * @return Number 	 */	public function set scrollPosition(value:Number) :Void{		_scrollPosition = value;		_component.scrollPosition = _scrollPosition;	}	public function get scrollPosition() :Number{		return _scrollPosition;	}}