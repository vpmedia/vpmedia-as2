import net.manaca.ui.UIList;
import net.manaca.lang.BObject;
import net.manaca.ui.core.IPages;
import net.manaca.util.Delegate;

/**
 * 针对数据的翻页效果
 * @author Wersling
 * @version 1.0, 2005-10-25
 */
class net.manaca.ui.core.Pages extends BObject implements IPages {
	private var className : String = "net.manaca.ui.core.Pages";
	//数据
	private var _Data:Array;
	//总数
	private var _totalNum:Number;
	//当前页数
	private var _nowPageNum:Number;
	//每页单元数
	private var _pageNum:Number;
	//翻页按钮
	private var _upBut:MovieClip;
	private var _downBut:MovieClip;
	//列表
	private var _List:UIList;
	
	/**
	 * 构造函数
	 * @param __Data 数据
	 * @param __pageNum 每页单元数
	 */
	public function Pages() {
		_nowPageNum = 1;
		_pageNum = 10;
	}
	
	/**
	 * 绑定列表
	 * @param _UIList 列表对象
	 */
	public function bindUIList(_List:UIList):Void{
		this._List = _List;
		_List.addEventListener("OnSelected",Delegate.create(this,onSelected));
		if(_Data) showList();
	}
	
	/**
	 * 绑定翻页按钮
	 * @param upbut 上翻页按钮
	 * @param downbut 下翻页按钮
	 */
	public function bindBut(upbut,downbut):Void{
		_upBut = upbut;
		_downBut = downbut;
		_upBut.onRelease	= Delegate.create(this,previousPage);	
		_downBut.onRelease	= Delegate.create(this,nextPage);
	}
	
	/** 上一页 */
	public function previousPage() : Boolean {
		if(isPrevious){
			_nowPageNum --;
			showList();
			return true;
		}
		return false;
	}
	
	/** 下一页 */
	public function nextPage() : Boolean {
		if(isNext){
			_nowPageNum ++;
			showList();
			return true;
		}
		return false;
	}
	/** 上一个*/
	public function getBack():Object{
		if(_List.Item == 0 && isPrevious){
			previousPage();
		}else if( _List.Item == 0 && !isPrevious ){
			setPage(totalPage);
			
		}
		return _List.getBack().Item;
	}
	/** 下一个*/
	public function getNext():Object{
		if(_List.Item == _List.length-1 && isNext){
			nextPage();
		}else if( _List.Item == _List.length-1 && !isNext ){
			setPage(1);
		}
		return _List.getNext().Item;
	}
	/**
	 * 指定某页
	 * @param num 页码
	 */
	public function setPage(num:Number):Void{
		if(num <= totalPage && num>0 ){
			_nowPageNum = num;
			showList();
		}
	}
	
	/**
	 * 显示页数据
	 */
	private function showList():Void{
		if(_nowPageNum == totalPage){
			var _NowData:Array = Data.slice((_nowPageNum-1)*pageNum,totalNum);
		}else{
			var _NowData:Array = Data.slice((_nowPageNum-1)*pageNum,(_nowPageNum)*pageNum);
		}
		if(_List) _List.ShowList(_NowData);
		this.dispatchEvent({type:"onPage",target:_NowData});
	}
	
	/**
	 * 当选择列表中间一项抛出,必须绑定列表
	 */
	private function onSelected(obj:Object):Void{
		this.dispatchEvent({type:"onChoose",target:obj.target.NonceCell.Item});
	}
	
	/**
	 * 每页显示数，默认为10
	 * @param  value 参数类型：Number 
	 * @return 返回值类型：Number 
	 */
	public function set pageNum ( value:Number) :Void
	{
		_pageNum=  value;
	}
	public function get pageNum() :Number
	{
		return _pageNum;
	}
	
	/**
	 * 数据
	 * @param  value 参数类型：Array 
	 * @return 返回值类型：Array 
	 */
	public function set Data ( value:Array) :Void
	{
		_Data =  value;
		_totalNum = value.length;
		_nowPageNum = 1;
		showList();
	}
	public function get Data() :Array
	{
		return _Data;
	}
	/** 数据长度(只读) */
	public function get totalNum():Number{ return _totalNum;}
	/** 当前页数(只读) */
	public function get nowPageNum():Number{ return _nowPageNum;}
	/** 总页数(只读) */
	public function get totalPage() :Number{ return Math.ceil(totalNum/pageNum);}
	/** 是否存在下一页(只读) */
	public function get isNext() :Boolean { return _nowPageNum< totalPage;}
	/** 是否存在上一页(只读) */
	public function get isPrevious() :Boolean{ return _nowPageNum > 1;}
}