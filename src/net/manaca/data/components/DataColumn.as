import net.manaca.data.Collection;
import net.manaca.data.collection.AbstractCollection;
import net.manaca.data.Iterator;
import net.manaca.lang.exception.IllegalArgumentException;
import net.manaca.data.components.DataTable;

/**
 * 表示 DataTable 中列的架构。
 * @author Wersling
 * @version 1.0, 2005-12-30
 */
class net.manaca.data.components.DataColumn extends AbstractCollection implements Collection {

	private var _ColumnName : String;

	private var _Table : DataTable;
	
	/**
	 * 构造函数
	 * @param columnName Column名称，必须。
	 * @exception 如果缺少columnName，将抛出 IllegalArgumentException 异常
	 */
	public function DataColumn(columnName:String,table:DataTable) {
		super();
		if(columnName != undefined){
			ColumnName = columnName;
		}else{
			throw new IllegalArgumentException("在建立DataColumn时缺少必要的参数！",this,[columnName]);
		}
		if(table) _Table = table;
	}
	
	/**
	 * 获取或设置 DataColumnCollection 中的列的名称。
	 * @param  value  参数类型：String 
	 * @return 返回值类型：String 
	 */
	public function set ColumnName(value:String) :Void
	{
		_ColumnName = value;
	}
	public function get ColumnName() :String
	{
		return _ColumnName;
	}
	
	/**
	 * 获取列所属的 DataTable。
	 * @param  value  参数类型：DataTable}
	 * @return 返回值类型： DataTable
	 */
	public function get Table() :DataTable
	{
		return _Table;
	}

	public function remove(o : Object) : Boolean {
		return null;
	}

	public function containsAll(c : Collection) : Boolean {
		return null;
	}

	public function Add(o : Object) : Boolean {
		return Boolean(_items.push(o));
	}
	
	public function addAll(c : Collection) : Boolean {
		return null;
	}

	public function removeAll(c : Collection) : Boolean {
		return null;
	}

	public function retainAll(c : Collection) : Boolean {
		return null;
	}

	public function clear() : Void {
		super.clear();
	}

	public function equals(o : Object) : Boolean {
		return null;
	}

	public function isEmpty() : Boolean {
		return null;
	}

	public function contains(o : Object) : Boolean {
		return null;
	}

	public function getItemAt(i : Number) : Object {
		return super.getItemAt(i);
	}

	public function size() : Number {
		return null;
	}

	public function toArray() : Array {
		return super.toArray();
	}

	public function iterator() : Iterator {
		return null;
	}

}