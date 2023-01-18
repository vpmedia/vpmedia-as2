import net.manaca.lang.BObject;
import net.manaca.io.file.ILoader;
import mx.utils.Delegate;

/**
 * 文本文件加载类
 * @author Wersling
 * @version 1.0, 2005-12-2
 * @see
 * @use
 * <pre>
 * _loader = new TextLoader();
	_loader.load("http://www.wersling.com");
 * </pre>
 */
class net.manaca.io.file.TextLoader extends BObject implements ILoader{
	private var className : String = "net.manaca.io.file.TextLoader";
	
	private var _text : LoadVars;
	private var _url : String;
	private var _intervalID : Number;
	private var _percentLoaded : Number;
	
	public function TextLoader() {
		super();
		_text = new LoadVars ();
		_text.onLoad = Delegate.create (this, onTextLoad);
		_text.onHTTPStatus = Delegate.create (this, onHTTPStatus);
	}
	/**
	 * 加载路径
	 * @param url 文件路径
	 * @return Boolean 如果没有传递任何参数 (null)，则返回布尔值 false；否则返回 true
	 */
	public function load(url : String) : Boolean {
		_url = url;
		Tracer.debug ("#TEXT# " + "开始加载" + _url);
		var b:Boolean = _text.load (_url);
		_percentLoaded = 0;
		Tracer.debug ("#TEXT# " + "正在加载" + _url + "进度0%");
		_intervalID = setInterval (Delegate.create (this, checkProgress) , 80);
		dispatchEvent (
		{
			type : "progress", value : 0
		});
		return b;
	}
	/**
	 * 将 my_lv 对象中的变量发送到指定的 URL
	 * @param url 文件路径
	 * @param target 一个字符串；将在其中出现任何响应的浏览器窗口或帧,
	 * 		"_self" 指定当前窗口中的当前帧。 
	 * 		"_blank" 指定一个新窗口。 
	 * 		"_parent" 指定当前帧的父级。 
	 *		 "_top" 指定当前窗口中的顶级帧。
	 * @param method 一个字符串；HTTP 协议的 GET 或 POST 方法。默认值为 POST。
	 */
	/*public function send(url:String, target:String, method:String) : Boolean{
		return _text.send(url,target,method);
	}*/
	public function unload() : Boolean {
		return null;
	}
	/**
	 * 接收到来自服务器的 XML 文档时由 Flash Player 调用
	 * @param success 成功加载了 XML 对象，则值为 true；否则为 false
	 */
	private function onTextLoad(success:Boolean):Void{
		if (success)
		{
			clearInterval (_intervalID);
			if (_percentLoaded < 100)
			{
				dispatchEvent ({type : "onLoadProgress", scale : 100});
				Tracer.debug ("#TEXT# " + "正在加载" + _url + "进度100%");
			}
			Tracer.debug ("#TEXT# " + "加载" + _url + "完成!");
			dispatchEvent ({type : "onLoadComplete", text : _text});
			delete _text;
		} 
		else
		{
			clearInterval (_intervalID);
			delete _text;
			Tracer.warn("加载TEXT文件\"" + _url + "\"失败!");
			dispatchEvent ({type : "onLoadError",error:success});
		}
	}
	/**
	 * 当 Flash Player 接收来自服务器的 HTTP 状态代码时调用
	 * @param status 由服务器返回的 HTTP 状态代码。例如，值 404 表示服务器尚未找到任何与请求的 URI 匹配的内容。
	 */
	private function onHTTPStatus(status:Number):Void{
		//TODO 这里需要实现更多的事件
		Tracer.info("onHTTPStatus: "+status);
	}
	/**
	 * 监视下载进度
	 */
	private function checkProgress():Void
	{
		var bytesLoaded : Number = _text.getBytesLoaded();
		if (bytesLoaded == 0)
		{
			return;
		}
		var bytesTotal : Number = _text.getBytesTotal();
		if (bytesTotal == undefined || bytesTotal == 0)
		{
			return;
		}
		var percentLoaded : Number = Math.floor ((bytesLoaded / bytesTotal ) * 100);
		if (_percentLoaded != percentLoaded)
		{
			_percentLoaded = percentLoaded;
			Tracer.debug ("#TEXT# " + "正在加载" + _url + "进度" + _percentLoaded + "%");
			dispatchEvent ({type : "onLoadProgress", scale : _percentLoaded});
		}
	}
}