import mx.utils.Delegate;
import net.manaca.lang.exception.IllegalArgumentException;
import net.manaca.lang.exception.IllegalStateException;
import net.manaca.util.ArrayUtil;
import net.manaca.util.MovieClipUtil;
import net.manaca.ui.UIListCell;
import net.manaca.ui.UIObject;
import net.manaca.lang.exception.IllegalDataException;
/**
 * 基本的列表，在使用之前你必须设置必要的参数
 * 
 * @author Wersling
 * @version 1.0, 2005-9-1
 */
class net.manaca.ui.UIList extends UIObject
{
	private var className : String = "net.manaca.ui.UIList";	
	/* 单元名称 */
	private var _cellRender:String = "ListCell";
	/* 单元容器 */
	private var _cellList:Array = new Array();
	/* 多行的数据 */
	private var _rows : Array;
	/* 单元宽 */
	private var _cellwidth:Number;
	/* 单元高 */
	private var _cellheight:Number;
	/* 每列最多显示数 */
	private var _lineTotal:Number = 1;
	/* 被选择的单元 */
	private var _seletedcell:UIListCell;
	static private var _cellid:Number = 0;
	/** 构造函数 */
	public function UIList() {super();}
	
	/**
	 * 设置必要的参数
	 * @param cellName		必要参数，要加载的单元名称
	 * @param cellheight	必要参数，单元高度
	 * @param cellwidth	单元宽度
	 * @param lineTotal	每行显示数，默认为1
	 */
	public function setNeedParameter(cellName:String,cellheight:Number,cellwidth:Number,lineTotal:Number):Void
	{
		try{
			if(!cellName) throw new IllegalArgumentException("参数不可以为空",this,["cellName"]);
		}finally{
			_cellRender = cellName;
		}
		
		try{
			if(!cellheight) throw new IllegalArgumentException("参数不可以为空",this,["cellheight"]);
		}finally{
			_cellheight = cellheight;
		}
		
		_cellwidth = cellwidth;
		if (!cellwidth) _cellwidth = null;
		
		_lineTotal = lineTotal;
		if (!lineTotal) _lineTotal = 1;
	}
	
	/**
	 * 显示列表
	 * 传入数据必须符合Tables格式
	 */
	public function ShowList (Table : Array) : Void
	{
		_seletedcell = null;
		if( Table == undefined)
			throw new IllegalDataException("传入的数据错误或为空",this,["Table"]);
		//删除以前数据
		removeNowCell();
		_rows 		= new Array();
		_cellList	= new Array();
		_rows = Table;
		//_rows.reverse();
		if(!_cellheight){
			 throw new IllegalStateException("缺少必要数据，没有指定高度",this,["_cellheight"]);
		}else{
			buildCell();
		}
	}
	
	/** 返回上一个可选择的项目，如果指针到最后则返回最后一个 */
	public function getBack():UIListCell
	{
		var i:Number = ArrayUtil.IndexOf(_cellList,_seletedcell);
		_seletedcell.Choose = false;
		_seletedcell = _cellList[i-1];
		if (i == -1 || i <= 0) _seletedcell = _cellList[_cellList.length-1];
		_seletedcell.Choose = true;
		return _seletedcell;
	}
	
	/** 返回下一个可选择的项目，如果指针到最后则返回第一个 */
	public function getNext():UIListCell
	{
		var i:Number = ArrayUtil.IndexOf(_cellList,_seletedcell);
		_seletedcell.Choose = false;
		_seletedcell = _cellList[i+1];
		if (i == -1 || i >= _cellList.length-1) _seletedcell = _cellList[0];
		_seletedcell.Choose = true;
		return _seletedcell;
	}
	
	/**
	 * 返回当前项
	 * @return UIListCell：当前项
	 */
	public function getNonceCell():UIListCell
	{
		return _seletedcell;
	}
	
	/** 建立单元列 */
	private function buildCell():Void
	{
		for(var i:Number = 0;i<length;i++)
		{
			var celltmp : UIListCell = UIListCell (attachMovie (_cellRender,"cell" + _cellid++,this.getNextHighestDepth ()));
			celltmp.Item = _rows[i];
			celltmp.Index = i;
			celltmp.Owner = this;
			if (_lineTotal>1)
			{
				celltmp._x = (i%_lineTotal)*_cellwidth;
				celltmp._y = Math.floor(i/_lineTotal)*_cellheight;
			}else
			{
				celltmp._x = 0;
				celltmp._y = _cellheight*i;
			}
			celltmp.addEventListener ("onListCellRelease", Delegate.create (this, onListCellRelease));
			_cellList.push(celltmp);
		}
	}
	
	/** 
	 * 移除现有的行 
	 */
	public function removeNowCell():Void
	{
		var i = length;
		while(--i-(-1))
		{
			MovieClipUtil.remove(_cellList[i]);
		}
		_cellList = new Array();
	}
	
	/** 
	 * 在列表被选择的时候广播事件，此处将传递this 
	 */
	private function onListCellRelease(Obj:Object):Void
	{
		_seletedcell.Choose = false;
		_seletedcell = Obj.target;
		_seletedcell.Choose = true;
		dispatchEvent (
		{
			type : "onSelected", value : this
		});
	}
	
	/** 
	 * 设置列表当前选择项
	 * @param 选择项编号，如果为-1则表示不选择任何一项
	 */
	public function set Item(id:Number):Void
	{
		if(id == -1){
			_seletedcell.Choose = false;
			_seletedcell = null;
		}else{
			if(id < 0 || id > _cellList.length-1){
				throw new IllegalDataException("指定的列表ID： "+ id +" 不存在！",this,[id]);
			}else{
				_seletedcell.Choose = false;
				_seletedcell = _cellList[id];
				_seletedcell.Choose = true;
			}
		}
	}
	
	/** 
	 * 返回当前项ID 
	 * @return Number：当前项ID
	 */
	public function get Item():Number
	{
		return _seletedcell.Index;
	}
	
	/** 
	 * 返回列表中元素数量的非从零开始的整数
	 * @return Number
	 */
	public function get length() :Number
	{
		return _rows.length;
	}
	
	/**
	 * 每列最多显示数
	 * @param  In 参数类型：Number 参数说明：每列最多显示数
	 */
	public function get LineTotal() :Number
	{
		return _lineTotal;
	}

}
