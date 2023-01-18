import mx.utils.Delegate;
import net.manaca.data.components.DataSet;
import net.manaca.lang.BObject;
import net.manaca.io.file.XmlLoader;
/**
 * 将XML数据加载并加工成DataSet
 * @author Wersling
 * @version 1.0, 2005-10-8
 */
class net.manaca.data.components.DataManufacture extends BObject {
	private var _obj;
	private var _fun:Function;
	private var _Xml : XmlLoader;
	/**
	 * 构造函数 
	 *@param 事例化本类的对象
	 *@param 事例化本类的对象的函数，用来在处理完时调用
	 *@param Xml文件路径
	 */
	public function DataManufacture(obj,fun:Function,path:String) {
		_obj = obj;
		_fun = fun;
		loadXml(path);
	}
	/**
	 * 加载XML数据 
	 * @param XML路径
	 */
	private function loadXml(path:String):Void
	{
		_Xml = new XmlLoader ();
		_Xml.load (path);
		_Xml.addEventListener ("onLoadComplete", Delegate.create (this, loadXmlComplete));
	}
	/** 加载数据完成 */
	private function loadXmlComplete (eventObj:Object) : Void
	{
		parseXML (eventObj.xml);
	}
	/** 加工数据为DataSet */
	private function parseXML (_XML:XML) : Void
	{
		var action : String = _XML.lastChild.nodeName;
		var params : DataSet = new DataSet ();
		//将Xml解析成DataSet
		params.ReadXml(_XML.lastChild);
		//发出数据
		_fun.apply(_obj,[params,action]);
		delete _Xml;
	}
}