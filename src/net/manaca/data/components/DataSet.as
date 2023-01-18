import net.manaca.data.components.DataTable;
import net.manaca.data.set.AbstractSet;
import net.manaca.data.Set;
import net.manaca.data.Collection;
import net.manaca.data.components.IllegalDataSetXMLFormatException;
import net.manaca.lang.exception.UnsupportedOperationException;
//Source file: D:\\Wersling WAS Framework\\javacode\\was\\data\\DataSet.java

//package was.data;


/**
 * 将数据以数据库的格式保存在内存中，DataSet 由一组 DataTable 对象组成。
 * DataSet 可将数据和架构作为 XML 文档进行读写。数据和架构可通过 HTTP 传输，
 * 并在支持 XML 的任何平台上被任何应用程序使用。
 * 
 * 具体的XML格式为：
 * 
 * 	<DataSetName> ----------库名，也就是DataSet名称
 * 		<Table1> -----------表名，这里只存储一行数据，要添加多行数据必须存在复制此节点
 * 			<Rows1>test1</Rows1> --------字段名
 * 			<Rows2>test2</Rows2>
 * 		</Table1>
 * 		<Table2>
 * 			<Rows1>test1</Rows1>
 * 			<Rows2>test2</Rows2>
 * 		</Table2>
 * 	</DataSetName>
 * 	
 * <p>Example:
 * <code>
 * 		var ds : DataSet = new DataSet ("myDataSet");
 * 		//将Xml解析成DataSet
 * 		ds.ReadXml(_XML.lastChild);
 * </code>
 * 
 * @author Wersling
 * @version 1.0
 */
class net.manaca.data.components.DataSet extends AbstractSet implements Set
{
	private var className : String = "net.manaca.data.components.DataSet";
	//保存所有的表，使表名与表对应，便于查找。
	private var TableList:Object;
	//DataSet名称
	private var _DataSetName:String;
	/**
	 * 构造函数
	 * @param dataSetName DataSet 名称（可选）
	 * @roseuid 4382F46A0290
	 */
	public function DataSet(dataSetName:String)
	{
		super();
		if(dataSetName) DataSetName = dataSetName;
		TableList = new Object();
	}
	
	/** 
	 * 添加一个表，不允许添加已存在的表，允许一个null
	 * @param o - 要从此 collection 中移除的元素（如果存在）。 
	 * @return Boolean 添加是否成功
	 */
	public function Add(o : Object) : Boolean {
		var result:Boolean = false;
		
		if (!contains(o) && TableList[o.TableName] == undefined ) {
			_items.push(o);
			TableList[o.TableName] = o;
			result = true;
		}
		return(result);
	}
	
	/** 
	 * 将指定 DataSet 中的所有元素都添加到此 DataSet 中（可选操作）。 
	 * @param c - 要插入到此 DataSet 的元素。
	 * @return Boolean 在传入的 DataSet 为空时返回 False
	 */
	public function addAll(c : Collection) : Boolean {
		if(c.isEmpty()) return false;
		for (var i : Number = 0; i < c.size(); i++) {
			Add(c.getItemAt(i));
		}
		return true;
	}
	
	/** 
	 * 从此 DataSet 中移除指定表
	 * @param o - 要从此 DataSet 中移除的元素（如果存在）。
	 * @return Boolean
	 */
	public function remove(o : Object) : Boolean {
		var result  = super.remove(o);
		if(result) delete TableList[o.TableName];
		return(result);
	}
	
	/**
	 * 删除指定的表，通过表名
	 * @param tableName 
	 * @return Boolean 
	 */
	public function removeByTableName(tableName:String) :Boolean
	{
		return remove(Table(tableName)); 
	}
	
	/** 
	 * 移除此 DataSet 中的所有元素 
	 */
	public function clear() : Void {
		super.clear();
		TableList = new Object();
	}
	
	/**
	 * 将XML转为DataSet
	 * @param xml XML数据
	 * @return Void
	 */
	public function ReadXml(xml) :Void{
		analyseXML(xml);
	}
	
	/**
	 * 将Object转为DataSet
	 * @param obj Object数据
	 * @return Void
	 */
	public function ReadObject(obj:Object) :Void{
		throw new UnsupportedOperationException("DataSet.ReadObject方法无法执行，需要在其子类实现",this,arguments);
	}
	
	/**
	 * 从 DataSet 写 XML 数据。
	 * @param XML 返回一个XML数据。
	 */
	public function WriteXml():XML{
		var _xmlStr:String = "<" + DataSetName + ">";
		for (var i : Number = 0; i < this.Tables.length; i++) {
			//如果存在这个表
			if(isTable(Tables[i].TableName)){
				var t:DataTable = Tables[i];
				for (var j : Number = 0; j < t.size(); j++) {
					_xmlStr += "<" + Tables[i].TableName + ">";
					var r:Array = t.Rows[j];
					for(var k in r) {
						_xmlStr += "<" + k + ">"+ r[k] +"</" + k + ">";;
					}
					_xmlStr += "</" + Tables[i].TableName + ">";
				}
			}
		}
		_xmlStr += "</" + DataSetName + ">";
		return new XML(_xmlStr);
	}
	
	/**
	 * 写 XML 架构形式的 DataSet 结构。
	 * @param XML 返回一个 DataSet 的XML结构
	 */
	public function WriteXmlSchema ():XML{
		var _xmlStr:String = "<" + DataSetName + ">";
		for (var i : Number = 0; i < this.Tables.length; i++) {
			//如果存在这个表
			if(isTable(Tables[i].TableName)){
				var t:DataTable = Tables[i];
				
				_xmlStr += "<" + Tables[i].TableName + ">";
				var r:Array = t.Rows[0];
				for(var k in r) {
					_xmlStr += "<" + k + "/>";
				}
				_xmlStr += "</" + Tables[i].TableName + ">";
			}
		}
		_xmlStr += "</" + DataSetName + ">";
		return new XML(_xmlStr);
	}
	
	/**
	 * 是否存在表
	 * @param  tableName 表名
	 * @return Boolean 如果存在则返回true
	 */
	public function isTable(tableName:String) :Boolean
	{
		var result:Boolean = false;
		if(TableList[tableName] != undefined) result = true;
		return result;
	}
	
	/**
	 * 返回一个Table，如果不存在则返回 null
	 * @param tableName 表名
	 * @return DataTable 一个数据表，如果不存在则返回 null
	 */
	public function Table(tableName:String):DataTable
	{
		if(isTable(tableName)) return TableList[tableName];
		return null;
	}
	
	/**
	 * 获取或设置当前 DataSet 的名称。
	 * @param  value  参数类型：String 
	 * @return 返回值类型：String 
	 */
	public function set DataSetName(value:String) :Void
	{
		_DataSetName = value;
	}
	public function get DataSetName() :String
	{
		return _DataSetName;
	}
	
	/**
	 * 返回所有表
	 * @return Array
	 */
	public function get Tables() :Array
	{
		return super.toArray();
	}
	
	/**
	 * 将XML转为DataSet
	 */
	private function analyseXML(xml):Void{
		if(!DataSetName) DataSetName = xml.nodeName;
		if(xml.nodeName == undefined) throw new IllegalDataSetXMLFormatException("XML格式错误",this,[xml,DataSetName]);
		var _tableNameList:Object = new Object();
		var nodes = xml.childNodes;
		var nodes_length:Number = nodes.length;
		
		for (var i = 0; i < nodes_length; i ++){
			var _TableName = nodes[i].nodeName;
			if (_tableNameList[_TableName] == undefined){
				var _DataTable:DataTable = new DataTable(_TableName);
				_tableNameList[_TableName] = _DataTable;
				Add(_DataTable);
			}
			_tableNameList[_TableName].ReadXml (nodes [i]);
		}
	}
}