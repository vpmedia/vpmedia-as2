import net.manaca.ui.controls.List;
import net.manaca.lang.event.ButtonEvent;
//import net.manaca.ui.controls.listClasses.ListItemRenderer;

/**
 * 
 * @author Wersling
 * @version 1.0, 2006-6-29
 */
class net.manaca.ui.controls.TileList extends List {
	private var className : String = "net.manaca.ui.controls.TileList";
	private var _columnCount : Number = 4;
	private var _rowCount : Number = 4;

	private var _leftExcursion : Number = 0;

	private var _topExcursion : Number = 0;
	public function TileList(target : MovieClip, new_name : String) {
		super(target, new_name);
	}
	private function initialize() : Void{
		super.initialize();
		setRowHeight(50);
		setColumnWidth(50);
		
		_itemRenderer  = "BaseUIListItemRenderer";
	}
	
	/**
	 * 构造行和列
	 */
	private function makeRowsAndColumns(left : Number, top : Number, right : Number, bottom : Number, firstCol : Number, firstRow : Number) : Void{
		super.makeRowsAndColumns(left,top,right,bottom,firstCol,firstRow);
		var xx : Number = left;
		var yy : Number = top;
		var ww : Number = right-left;
		var hh : Number = bottom-top;
		var _data_len : Number = _dataProvider.size();//数据长度
		var _max_len : Number = Math.min(_data_len,Math.floor(hh/_rowHeight)*_columnCount);

		var _items : Array = new Array();
		for (var i : Number = 0; i < _max_len; i++) {
			var _item;
			
			if(_listItems.length > 0){
				_item = _listItems.pop();
			}else{
				_item = createNewItem();
				if(selectable){
					_item.addEventListener(ButtonEvent.RELEASE,__onListItemRelease);
					_item.addEventListener(ButtonEvent.ROLL_OUT,__onListItemOut);
					_item.addEventListener(ButtonEvent.ROLL_OVER,__onListItemOver);
				}
			}
			//大小和位置计算
			//var rh = _item.getPreferredHeight();
			var _w:Number = explicitColumnWidth > 0 ? explicitColumnWidth : _columnWidth;
			var _h:Number = explicitRowHeight > 0 ? explicitRowHeight : _rowHeight;
			_item.setSize(_w,_h);
			
			_item.setLocation((i%_columnCount)*_columnWidth + left,Math.floor(i/_columnCount)*_rowHeight+top);
			
			_items.push(_item);
		}
		
		while(_listItems.length >0){
			var _item = _listItems.pop();
				if(selectable){
				_item.removeEventListener(ButtonEvent.RELEASE,__onListItemRelease);
				_item.removeEventListener(ButtonEvent.ROLL_OUT,__onListItemOut);
				_item.removeEventListener(ButtonEvent.ROLL_OVER,__onListItemOver);
				}
			_item.remove();
		}
		_listItems = new Array();
		_listItems = _listItems.concat(_items);

		var tr = Math.ceil(_data_len/_columnCount);
		var vr = Math.ceil(_listItems.length/_columnCount);
		
		this.setScrollBarProperties(0,0,tr,vr);
	}
	
	//更新元素
	private function dataChangedHandler() : Void {
		makeRowsAndColumns(leftExcursion,topExcursion,this.getSize().getWidth()-18,this.getSize().getHeight(),0,0);
		invalidateDisplayList();
	}
	
	/**
	 * 获取和设置元素位置象右偏移值，默认0
	 * @param  value:Number - 
	 * @return Number 
	 */
	public function set leftExcursion(value:Number) :Void{
		_leftExcursion = value;
	}
	public function get leftExcursion() :Number{
		return _leftExcursion;
	}
	
	/**
	 * 获取和设置元素位置象下偏移值，默认0
	 * @param  value:Number - 
	 * @return Number 
	 */
	public function set topExcursion(value:Number) :Void{
		_topExcursion = value;
	}
	public function get topExcursion() :Number{
		return _topExcursion;
	}
}	