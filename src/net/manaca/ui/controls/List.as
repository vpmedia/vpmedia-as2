import net.manaca.ui.controls.skin.IListSkin;
import net.manaca.ui.awt.Dimension;
import net.manaca.lang.event.Event;
import net.manaca.util.Delegate;
import net.manaca.ui.controls.Panel;
import net.manaca.lang.event.ButtonEvent;
import net.manaca.ui.controls.listClasses.ListBase;
import net.manaca.ui.controls.IContainers;
import net.manaca.ui.controls.skin.mnc.ListSkin;
import net.manaca.ui.controls.listClasses.ListData;
import net.manaca.ui.controls.listClasses.ListItemRenderer;
import net.manaca.data.list.ArrayList;

/**
 * List 负责将数据单列显示，可以设置每行元素的高度。在需要的时候，可以使用垂直滚动条
 * @author Wersling
 * @version 1.0, 2006-5-19
 */
class net.manaca.ui.controls.List extends ListBase {
	private var className : String = "net.manaca.ui.controls.List";
	private var _componentName = "List";
	private var _skin : IListSkin;

	private var _selectable : Boolean = true;
	private var _multipleSelection : Boolean = false;
	private var _columnCount : Number = 1;
	private var _rowHeight : Number = 20;

	private var _panel : Panel;

	public function List(target : MovieClip, new_name : String) {
		super(target, new_name);
		initialize();
	}

	private function initialize() : Void{
		_skin = new ListSkin();
		_preferredSize = new Dimension(100,104);
		this.paintAll();
		
		_panel = _skin.getPanel();
		_carrier = _panel.getBoard().createEmptyMovieClip("_carrier",_panel.getBoard().getNextHighestDepth());
		_itemRenderer  = ListItemRenderer;

		super.initialize();
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
		var _max_len : Number = Math.min(_data_len,Math.floor(hh/_rowHeight));

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
			//var rh = _item.getPreferredHeight();
			var _w = ww;
			var _h = _rowHeight;

			_item.setSize(_w,_h);
			_item.setLocation(left,i*_rowHeight+top);
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

		var tr = Math.ceil( _dataProvider.size());
		var vr = Math.floor(_listItems.length);
		
		this.setScrollBarProperties(0,0,tr,vr);
	}

	private function _makeRowsAndColumns(left : Number, top : Number, right : Number, bottom : Number, firstCol : Number, firstRow : Number) : Void{
		super.makeRowsAndColumns(left,top,right,bottom,firstCol,firstRow);
		//trace("makeRowsAndColumns " + left + " " + top + " " + right + " " + bottom + " " + firstCol + " " + firstRow);
		var xx : Number = left;
		var yy : Number = top;
		var ww : Number = right-left;
		var hh : Number = bottom-top;

		var _now_w : Number = 0;
		var _now_h : Number = 0;

		var colNum : Number = 0;
		var rowNum : Number = 1;

		var _data_len : Number = _dataProvider.size();//数据长度
		//var _item_len : Number = _listItems.length;//已有元素长度
		var _now_len : Number = 0;//当前的元素数
		var _items : Array = new Array();
		
		while(yy < bottom && _now_len < _data_len){
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

			var rh = _item.getPreferredHeight();
			var rw = _item.getPreferredWidth();
			var _w = variableRowWidth ? explicitColumnWidth : rw;
			var _h = variableRowHeight ? explicitRowHeight : rh;

			if(explicitColumnCount != -1){
				 if(colNum < explicitColumnCount){
					colNum++;
					_now_w += _w;
				 }else{

					colNum = 1;
					_now_w = _w;
					rowNum ++;
					_now_h += _h;
				 }
			}else{
				if((_now_w + _w) < ww ){
					colNum++;
					_now_w += _w;
				}else{
					_columnCount = colNum;
					colNum = 1;
					_now_w = _w;
					rowNum ++;
					_now_h += _h;
				}
			}
			
			if(explicitRowCount != -1){
				if(rowNum > explicitRowCount ){
					_listItems.push(_item);
					break;
				}
			}else{
				if(_now_h + _h > hh){
					_listItems.push(_item);
					break;
				}
			}

			_item.setSize(_w,_h);
			_item.setLocation(_now_w-_w,_now_h);

			_now_len++;
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

		var tr = Math.ceil( _dataProvider.size()/_columnCount);
		var vr = Math.floor(_listItems.length/_columnCount);
		this.setScrollBarProperties(0,0,tr,vr);
	}
	/**
	 * 制造一个列表数据对象
	 */
	private function makeListData(data : Object, rowNum : Number) : ListData{
		return new ListData(itemToLabel(data), itemToIcon(data), data,this, rowNum);
	}
	/**
	 * 更新项目数据
	 */
	private function invalidateDisplayList() : Void{
		var a = getTimer();
		var _sl : Number = _verticalScrollPosition * this.columnCount;
		
		if(multipleSelection){
			var _items : Array = selectedItems;
			var _arrayList : ArrayList = new ArrayList(_items);
		}
		var _len:Number = _listItems.length;
		for (var i : Number = 0; i < _len; i++) {
			var _data:Object = _dataProvider.getItemAt(i+_sl);
			if(_data != undefined){
				_listItems[i].setValue(makeListData(_dataProvider.getItemAt(i+_sl),i+_sl));
				if(!multipleSelection){
					if(_dataProvider.getItemAt(i+_sl) == selectedItem){
						_listItems[i].setSelected("selected");
					}else{
						_listItems[i].setSelected("normal");
					}
				}else{
					if(_arrayList.contains(_dataProvider.getItemAt(i+_sl))){
						_listItems[i].setSelected("selected");
					}else{
						_listItems[i].setSelected("normal");
					}
				}
				_listItems[i].setVisible(true);
			}else{
				_listItems[i].setVisible(false);
			}
		}
		//trace(getTimer() -a);
	}
	//更新元素
	private function dataChangedHandler() : Void {
		makeRowsAndColumns(0,0,this.getSize().getWidth()-18,this.getSize().getHeight(),0,0);
		invalidateDisplayList();
	}
	
	//列表位置发生改变
	private function scrollHandler(event : Event) : Void {
		super.scrollHandler(event);
		invalidateDisplayList();
	}
	
	/**
	 * 更新组件
	 */
	public function Update(o : IContainers) : Void{
		var s : Dimension = Dimension(o.getState());
		this.setSize(s.getWidth(),s.getHeight());
	}

	private function updataSize() : Void {
		//makeRowsAndColumns();
		dataChangedHandler();
	}

}