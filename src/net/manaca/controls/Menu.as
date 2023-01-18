import net.manaca.ui.UIObject;
import net.manaca.lang.exception.IllegalArgumentException;
import net.manaca.ui.UIList;
import net.manaca.ui.UIListCell;
import mx.utils.Delegate;
import net.manaca.util.MovieClipUtil;

/**
 * 菜单
 * @author Wersling
 * @version 1.0, 2005-12-5
 */
class net.manaca.controls.Menu extends UIObject {
	private var className : String = "net.manaca.controls.Menu";
	//菜单级别
	private var level:Number;
	//所有菜单列表
	private var allList:Array;
	//编号
	private var id:Number;
	//列表Y坐标
	private var _Py:Number;
	//显示方向，默认为9
	private var _way : Number;
	/**
	 * 构造函数
	 * @param 无
	 */
	public function Menu() {
		super();
		level = id = 0;
		allList = new Array();
		way = 9;
	}
	/**
	 * 传入XMLNode数据，并建立菜单
	 * @param xmlNode XMLNode数据
	 */
	public function setXMLNode(xmlNode:XMLNode):Void{
		if(!xmlNode) throw new IllegalArgumentException("在创建菜单时传入的XMLNode数据错误！",this,[xmlNode]);
		//--建立一级菜单
		var list:UIList = createList(xmlNode);
		list["level"]  = level;
		allList.push(list);
	}
	/**
	 * 创建一个菜单的列表
	 */
	private function createList(xmlNode:XMLNode):UIList{
		id ++;
		var _List:UIList = UIList(this.attachMovie("WAS_Menu_List","WAS_Menu_List"+id,this.getNextDepth()));
		_List.setNeedParameter("WAS_Menu_Item",16,68,1);
		_List.ShowList(xmlNode.childNodes);
		_List.addEventListener("onSelected",Delegate.create(this,OnSelected));
		return _List;
	}
	/**
	 * 如果一个菜单被选择
	 */
	private function OnSelected(obj:Object):Void{
		var x:UIList = obj.value;
		//获取Y坐标
		_Py = x.getNonceCell()._y + x._y;
		var node:XMLNode = XMLNode(x.getNonceCell().Item);
		//如果存在子菜单
		if(node.childNodes.length > 0){
			level = x["level"]+1;
			closeLevelList(level);
			showList(XMLNode(x.getNonceCell().Item));
		}else{
			close(node);
		}
	}
	/**
	 * 显示一个新的菜单列表
	 * @param xml
	 */
	private function showList(xml:XMLNode):Void{
		var list:UIList = createList(xml);
		list["level"]  = level;
		//位置
		//右下
		if(way == 9){
			list._x = 100 * level;
			list._y = _Py;
		}
		//左下
		if(way == 7){
			list._x = -100 * level;
			list._y = _Py;
		}
		//左上
		if(way == 1){
			list._x = -100 * level;
			list._y = _Py - list._height + 16;
		}
		//右上
		if(way == 3){
			list._x = 100 * level;
			list._y = _Py - list._height + 16;
		}
		/*list._x = 101 * evel;
		list._y = _Py;*/
		//trace('getGlobal(list).x: ' + getGlobal(list).x);
		if(getGlobal(list).x + list._width > 550){
			trace(1);
		}
		//添加到菜单列表
		allList.push(list);
	}
	/**
	 * 关闭指定级别菜单
	 */
	private function closeLevelList(l:Number):Void{
		for (var i : Number = 0; i < allList.length; i++) {
			if(allList[i]["level"] >= l){
				MovieClipUtil.remove(allList[i]);
				delete allList[i];
			}
		}
	}
	/**
	 * 关闭菜单
	 */
	private function close(xn:XMLNode):Void{
		closeLevelList(0);
		level = id = 0;
		allList = new Array();
		//如果有选择
		if(xn){
			this.dispatchEvent({type:"change",value:xn.attributes});
		}
	}
	/**
	 * 鼠标在外部点击则关闭
	 */
	private function onMouseDown():Void{
		if(!this.hitTest(_root._xmouse,_root._ymouse,true)){
			close();
		}
	}
	private function getGlobal(mc:MovieClip):Object{
		var myPoint:Object = {x:0, y:0}; 
		mc.localToGlobal(myPoint);
		return myPoint;
	}
	/**
	 * 设置菜单显示方向，九宫格方式，如：9为右下，1为左上，852不可以设置
	 * 123
	 * 456
	 * 789
	 * @param  value  参数类型：Number 
	 * @return 返回值类型：Number 
	 */
	public function set way(value:Number) :Void
	{
		_way = value;
	}
	public function get way() :Number
	{
		return _way;
	}
}