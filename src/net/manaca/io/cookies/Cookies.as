/**
 * 本地数据存储
 * @author Wersling
 * @version 1.0, 2005-9-13
 */
class net.manaca.io.cookies.Cookies
{
	private var className:String = "net.manaca.io.cookies.Cookies";
	//SharedObject对象
	private var _fso:SharedObject;
	/**
	 * 构造本地数据存储	 * @param 无	 */
	public function Cookies(cookiesName:String)
	{
		_fso = SharedObject.getLocal(cookiesName, "/");
	}
	/** 清空数据 */
	public function clear():Void
	{
		_fso.clear();
	}
	/** 获取文件大小 */
	public function getSize():Number
	{
		return _fso.getSize();
	}
	/**
	 * 设置数据
	 * @param  value 参数类型：Object 
	 * @return 返回值类型：Object 
	 */
	public function set data(value:Object):Void
	{
		_fso.data = value;
		var flushResult:Object = _fso.flush();
		switch (flushResult)
		{
			case 'pending':
				Tracer.info("保存 Cookies 数据出错，缺少存储空间！");
			    break;
			case true:
				//Tracer.info("保存 Cookies 数据成功！");
			    break;
			case false:
				//Tracer.info("保存 Cookies 数据失败！");
			    break;
		}
	}
	public function get data():Object
	{
		return _fso.data;
	}
}