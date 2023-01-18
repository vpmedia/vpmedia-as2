import net.manaca.lang.BObject;
import net.manaca.io.file.ILoader;
import mx.utils.Delegate;

/**
 * XML文件加载类
 * @author Wersling
 * @version 1.0, 2005-12-2
 */
class net.manaca.io.file.XmlLoader extends BObject implements ILoader {
	private var className : String = "net.manaca.io.file.XmlLoader";

	private var _xml : XML;
	private var _url : String;
	private var _intervalID : Number;
	private var _percentLoaded : Number;

	public function XmlLoader() {
		super();
		_xml = new XML ();
		_xml.ignoreWhite = true;
		_xml.onLoad = Delegate.create (this, onXMLLoad);
		//此方式只可以在Flash8中实现
		//_xml.onHTTPStatus = Delegate.create (this, onHTTPStatus);
	}
	/**
	 * 加载路径
	 * @param url 文件路径
	 * @return Boolean 如果没有传递任何参数 (null)，则返回布尔值 false；否则返回 true
	 */
	public function load(url : String) : Boolean {
		_url = url;
		Tracer.debug ("#XML# " + "开始加载" + _url);
		var b : Boolean = _xml.load (_url);
		_percentLoaded = 0;
		Tracer.debug ("#XML# " + "正在加载" + _url + "进度0%");
		_intervalID = setInterval (Delegate.create (this, checkProgress) , 80);
		dispatchEvent (
		{
			type : "onLoadProgress", value : 0
		});
		return b;
	}

	public function unload() : Boolean {
		return null;
	}
	/**
	 * 接收到来自服务器的 XML 文档时由 Flash Player 调用
	 * @param success 成功加载了 XML 对象，则值为 true；否则为 false
	 */
	private function onXMLLoad(success : Boolean) : Void{
		if (success)
		{
			clearInterval (_intervalID);
			if (_percentLoaded < 100)
			{
				dispatchEvent ({type : "onLoadProgress", scale : 100});
				Tracer.debug ("#XML# " + "正在加载" + _url + "进度100%");
			}
			Tracer.debug ("#XML# " + "加载" + _url + "完成!");
			dispatchEvent ({type : "onLoadComplete", xml : _xml});
			delete _xml;
		} 
		else
		{
			clearInterval (_intervalID);
			delete _xml;
			Tracer.warn("加载XML文件\"" + _url + "\"失败!");
			dispatchEvent ({type : "onLoadError",error:success});
		}
	}
	/**
	 * 当 Flash Player 接收来自服务器的 HTTP 状态代码时调用
	 * @param status 由服务器返回的 HTTP 状态代码。例如，值 404 表示服务器尚未找到任何与请求的 URI 匹配的内容。
	 */
	private function onHTTPStatus(status : Number) : Void{
		//TODO 这里需要实现更多的事件
		Tracer.info("onHTTPStatus: "+status);
	}
	/**
	 * 监视下载进度
	 */
	private function checkProgress() : Void
	{
		var bytesLoaded : Number = _xml.getBytesLoaded ();
		if (bytesLoaded == 0)
		{
			return;
		}
		var bytesTotal : Number = _xml.getBytesTotal ();
		if (bytesTotal == undefined || bytesTotal == 0)
		{
			return;
		}
		var percentLoaded : Number = Math.floor ((bytesLoaded / bytesTotal ) * 100);
		if (_percentLoaded != percentLoaded)
		{
			_percentLoaded = percentLoaded;
			Tracer.debug ("#XML# " + "正在加载" + _url + "进度" + _percentLoaded + "%");
			dispatchEvent ({type : "onLoadProgress", scale : _percentLoaded});
		}
	}
}