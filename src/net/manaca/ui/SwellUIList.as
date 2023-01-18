import net.manaca.ui.UIObject;
import net.manaca.ui.SwellUIListParameter;
import net.manaca.lang.exception.IllegalArgumentException;
import net.manaca.data.Collection;
import net.manaca.data.Iterator;
import net.manaca.ui.SwellUIListCell;
import net.manaca.data.list.SearchList;
import net.manaca.util.MovieClipUtil;
import net.manaca.data.Search;
import net.manaca.util.Delegate;

/**
 * 增强的列表，这里主要相对UIList来说，由于前期项目需要，所以建立此对象。
 * @author Wersling
 * @version 1.0, 2006-1-15
 */
class net.manaca.ui.SwellUIList extends UIObject implements Search {
	private var className : String = "net.manaca.ui.SwellUIList";
	private var _collection : Collection;
	private var _sulp : SwellUIListParameter;
	private var _cellList:SearchList;
	//代理事件主
	private var _el : Function;
	static private var _cell_id:Number = 0;
	public function SwellUIList() {
		super();
		_el = Delegate.create (this, onListCellRelease);
	}
	
	/**
	 * 设置列表参数
	 * @param sulp SwellUIListParameter
	 */
	public function set Parameter(sulp:SwellUIListParameter){
		if(!sulp) throw new IllegalArgumentException("缺少必要的参数",this,arguments);
		_sulp = sulp;
	}
	
	/**
	 * 建立列表
	 * @param c 一个支持 Collection 接口的数据对象
	 * @param sulp 一个参数容器
	 * @updata 2006-4-3 更新
	 * @since
	 */
	public function ShowList(c:Collection):Void{
		if(!_sulp) throw new IllegalArgumentException("缺少必要的参数",this,arguments);
		removeNowCell();
		_collection = c;
		buildCell();
	}

	/** 
	 * 移除现有的行 
	 */
	public function removeNowCell():Void{
		var i = _cellList.size();
		while(--i-(-1))
		{
			//TODO 此处删除事件是有必要的，但会降低性能
			_cellList.Get(i).removeEventListener("onListCellRelease",_el);
			MovieClipUtil.remove(MovieClip(_cellList.Get(i)));
		}
		_cellList = new SearchList();
	}
	
	/** 建立单元 */
	private function buildCell():Void{
		var _iterator:Iterator = _collection.iterator();
		var _id:Number = 0;
		while(_iterator.hasNext()){
			var v = _iterator.next();
			var celltmp : SwellUIListCell = SwellUIListCell (this.attachMovie(_sulp.cellName,"cell" + _cell_id++,this.getNextHighestDepth ()));
			celltmp.Index = _id;
			celltmp.Item = v;
			celltmp.Owner = this;
			arrange(celltmp,_id+_sulp.space);
			_id ++;
			celltmp.addEventListener ("onListCellRelease", _el);
			_cellList.push(celltmp);
		}
	}
	
	/** 调整位置 */
	private function arrange(celltmp:SwellUIListCell,i:Number):Void{
		var _w:Number = _sulp.width;
		var _h:Number = _sulp.height;
		var _l:Number = _sulp.lineTotal;
		var _t:Boolean = _sulp.train;
		
		if(_t){ //横向排列
			if (_l>1)
			{
				celltmp._x = (i%_l)*_w;
				celltmp._y = Math.floor(i/_l)*_h;
			}else
			{
				celltmp._x = 0;
				celltmp._y = _h*i;
			}
		}else{ //纵向排列
			if (_l>1)
			{
				celltmp._x = Math.floor(i/_l)*_w;
				celltmp._y = (i%_l)*_h;
			}else
			{
				celltmp._x = _w*i;
				celltmp._y = 0;
			}
		}
	}
	
	/**
	 * 单元选择
	 */
	private function onListCellRelease(o:Object):Void{
		move(search(o.target));
		this.dispatchEvent({type:"onChoose",value:this});
	}
	private function choose(b:Boolean):Void{
		getCurrent().isChoose = b;
	}
	
	/**
	 * 返回所有可用的单元
	 * @return Array
	 * @updata 2006-04-03
	 */
	public function getAvailableCell() : Array {
		return _cellList.toArray();
	}
	
	/**
	 * 获取目前选择的单元
	 */
	public function getCurrent():SwellUIListCell{
		return SwellUIListCell(_cellList.Get(getFinger()));
	}
	
	/**
     * 如果存在上一个元素，则返回 true。
     */
	public function hasBack() : Boolean {
		return _cellList.hasBack();
	}
	
	/**
     * 如果存在下一个元素，则返回 true。
     */
	public function hasNext() : Boolean {
		return _cellList.hasNext();
	}
	
	/**
     * 返回上一个可选择的元素
     * @return Object 上一个可选择的元素
     * @throws NoSuchElementException 找不到数据时抛出
     */
	public function getBack() : Object {
		choose(false);
		var sulc:SwellUIListCell = SwellUIListCell(_cellList.getBack());
		choose(true);
		return sulc;
	}

	/**
     * 返回下一个可选择的元素
     * @return Object 下一个可选择的元素
     * @throws NoSuchElementException 找不到数据时抛出
     */
	public function getNext() : Object {
		choose(false);
		var sulc:SwellUIListCell = SwellUIListCell(_cellList.getNext());
		choose(true);
		return sulc;
	}
	
	/**
     * 移动指针
     * @param 要移动的位置
     * @return 移动成功则返回 true
     * @throws NoSuchElementException 无法移动到该位置时抛出
     */
	public function move(n : Number) : Object {
		choose(false);
		var sulc:SwellUIListCell = SwellUIListCell(_cellList.move(n));
		choose(true);
		return sulc;
	}
	
	/**
	 * 查询元素位置
	 * @param 需要查询的元素
	 * @return Number 元素位置，如果没有此元素则返回－1
	 */
	public function search(o : Object) : Number {
		return _cellList.search(o);
	}
	
	/**
	 * 返回当前位置
	 * @return Number 当前位置
	 */
	public function getFinger() : Number {
		return _cellList.getFinger();
		
	}

}