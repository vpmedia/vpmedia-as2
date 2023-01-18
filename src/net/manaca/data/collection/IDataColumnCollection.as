import net.manaca.data.Collection;
import net.manaca.data.components.DataColumn;

/**
 * DataColumnCollection 的接口
 * @author Wersling
 * @version 1.0, 2005-12-30
 */
interface net.manaca.data.collection.IDataColumnCollection extends Collection {
	/** 
	 * 在一行中添加元素
	 * @param columnName 行名称
	 * @param value 值
	 */
	public function push(columnName:String,value:Object):Void;
	/**
	 * 检查集合是否包含具有指定名称的列。
	 * @param name 要检查的列名
	 * @return 如果存在此列则返回True
	 */
	public function Contains(name : String) : Boolean;
	
	/**
	 * 获取指定的 DataColumn
	 * @param name DataColumn 名称
	 * @return DataColumn 返回指定的 DataColumn
	 */
	public function getColumn(name : String) : DataColumn;
	
	/**
	 * 删除制定名称的行数据
	 * @param columnName 行名称
	 * @return Boolean
	 */
	public function removes(columnName:String):Boolean;
}