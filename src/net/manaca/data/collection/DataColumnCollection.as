import net.manaca.data.Collection;
import net.manaca.data.collection.AbstractCollection;
import net.manaca.data.Iterator;
import net.manaca.data.collection.IDataColumnCollection;
import net.manaca.data.components.DataColumn;
import net.manaca.data.collection.IllegalDataColumnCollectionXMLFormatException;
import net.manaca.data.collection.IllegalDataColumnCollectionArgumentException;

/**
 * 表示 DataTable 的 DataColumn 对象的集合。
 * @author Wersling
 * @version 1.0, 2005-12-30
 */
class net.manaca.data.collection.DataColumnCollection extends AbstractCollection implements IDataColumnCollection {
	private var className : String = "net.manaca.data.collection.DataColumnCollection";
	private var _columnList:Object;
	public function DataColumnCollection() {
		super();
		_columnList = new Object();
	}
	
	/** 
	 * 在一行中添加元素
	 * @param columnName 行名称
	 * @param value 值
	 */
	public function push(columnName:String,value:Object):Void{
		if(_columnList[columnName] != undefined){
			_columnList[columnName].Add(value);
		}else{
			var dc:DataColumn = new DataColumn(columnName);
			dc.Add(value);
			_columnList[columnName] = dc;
			_items.push(dc);
		}
	}
	
	/**
	 * 检查集合是否包含具有指定名称的列。
	 * @param name 要检查的列名
	 * @return 如果存在此列则返回True
	 */
	public function Contains(name : String) : Boolean {
		for (var i : Number = 0; i < _items.length; i++) {
			if(_items[i].ColumnName == name){
				return true;
			}
		}
		return false;
	}
	
	/**
	 * 获取指定的 DataColumn
	 * @param name DataColumn 名称
	 * @return DataColumn 返回指定的 DataColumn
	 */
	public function getColumn(name : String) : DataColumn {
		for (var i : Number = 0; i < _items.length; i++) {
			if(_items[i].ColumnName == name){
				return _items[i];
			}
		}
		return null;
	}
	
	/**
	 * 获取 DataColumn 集合
	 * @return Object DataColumn 集合
	 */
	public function get Columns() : Array {
		return _items;
	}
	
	/**
	 * 删除制定名称的行数据
	 * @param columnName 行名称
	 * @return Boolean
	 */
	public function removes(columnName:String):Boolean{
		return remove(getColumn(columnName));
	}
	
	/** 
	 * 从此 column 中移除指定元素的单个实例 
	 * @param o - 要从此 column 中移除的元素（如果存在）。
	 * @return Boolean
	 */
	public function remove(o : Object) : Boolean {
		var dc:DataColumn = DataColumn(o);
		if(dc.ColumnName == undefined) throw new IllegalDataColumnCollectionArgumentException("在执行DataColumnCollection.remove()方法中，传入参数错误！",this,[o]);
		return super.remove(o);
	}
	
	/**
	 * 如果此 DataColumn 包含指定 DataColumn 中的所有元素，则返回 true 
	 * @param c - 将检查是否包含在此 DataColumn 中的 DataColumn。
	 * @return Boolean
	 */
	public function containsAll(c : Collection) : Boolean {
		var dc:DataColumn = DataColumn(c);
		if(dc.ColumnName == undefined) throw new IllegalDataColumnCollectionArgumentException("在执行DataColumnCollection.containsAll()方法中，传入参数错误！",this,[c]);
		return Contains(dc.ColumnName);
	}
	public function clear() : Void {
		super.clear();
		_columnList = new Object();
	}
}