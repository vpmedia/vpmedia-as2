import net.manaca.data.components.DataRow;
import net.manaca.data.list.AbstractList;
import net.manaca.data.components.DataSet;
import net.manaca.data.collection.DataColumnCollection;
import net.manaca.data.collection.IDataColumnCollection;
/**
 * DataSet中的表
 * 
 * @author Wersling
 * @version 1.0, 2005-11-29
 */
class net.manaca.data.components.DataTable extends AbstractList{
	private var className : String = "net.manaca.data.components.DataTable";
	//表名
	private var _TableName : String;
	//
	private var _columns:IDataColumnCollection;
	/**
	 * 构造函数
	 * @param tableName 表名
	 */
	public function DataTable(tableName:String,dataSet:DataSet) {
		super();
		if(tableName != undefined)	TableName = tableName;
		
		_items = new Array ();
		_columns = new DataColumnCollection();
	}
	
	/**
	 * 添加一行数据
	 * @param xml 一行数据

	 */
	public function Add (o : Object):Boolean
	{
		return Boolean(_items.push(o));
	}
	/**
	 * 将XML转为DataTable
	 * @param xml XML数据
	 * @return Void
	 */
	public function ReadXml(xml) :Void{
		var nodes:Array = xml.childNodes;
		var node:XMLNode;
		var _row:DataRow = new DataRow();
		var nodes_length:Number = nodes.length;
		for (var i = 0; i < nodes_length; i ++){
			node = nodes[i];
			var v = node.firstChild.nodeValue;
			//修正在非DataSet数据时，将超出的部分保存为一个String，叫给其他程序处理
			if(v == undefined){
				v = "";
				var ns:Array = node.childNodes;
				var ns_length:Number = ns.length;
				if(ns_length > 0){
					for (var i : Number = 0; i < ns.length; i++) {
						v += ns[i];
					}
				}
				v = node.firstChild;
			}
			_columns.push(node.nodeName,v);
			_row[node.nodeName] = v;
		}
		_items.push(_row);
	}
	
	/**
	 * 返回表中的所有行
	 * @return Array
	 */
	public function get Rows () : Array
	{
		return _items;
	}
	
	/**
	 * 获取属于该表的列的集合。
	 * @return DataColumnCollection 属于该表的列的集合
	 */
	public function get Columns () : IDataColumnCollection
	{
		return _columns;
	}
	
	/**
	 * 返回一列数据
	 * @param columnsName 列名(字段名)
	 * @return Array 一列数据
	 */
	 public function Column(columnsName:String):Array{
	 	return _columns.getColumn(columnsName).toArray();
	 }
	 
	/**
	 * 表名
	 * @param  value  参数类型：String 
	 * @return 返回值类型：String 
	 */
	public function set TableName(value:String) :Void
	{
		_TableName = value;
	}
	public function get TableName() :String
	{
		return _TableName;
	}
}