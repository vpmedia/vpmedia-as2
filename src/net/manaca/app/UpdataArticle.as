import net.manaca.io.file.TextLoader;
import net.manaca.util.Delegate;
import net.manaca.util.StringUtil;
/**
 * 
 * @author Wersling
 * @version 1.0, 2006-7-14
 */
class net.manaca.app.UpdataArticle {
	private var _path:String = "china/";
	private var _id:Number = 4;
	private var _maxid:Number = 20;
	
	private var _loader:TextLoader;
	/**
	 * 构造函数
	 * @param 无
	 */
	public function UpdataArticle() {
		//System.useCodepage =true;
		Tracer.setLevel("INFO");
		loadHtml(_id);
	}
	public function loadHtml(id:Number):Void{
		_loader = new TextLoader();
		_loader.addEventListener("onLoadComplete",Delegate.create(this,onLoadComplete));
		_loader.addEventListener("onLoadError",Delegate.create(this,onLoadError));
		_loader.load(_path + "pic (" + id + ").html");
		trace(_path + "pic (" + id + ").html");
	}
	private function onLoadComplete(o) : Void {
		var _str = unescape(o.text);
		Analyse(_str);
		//Analyse(_str);
	}
	public function Analyse (html:String):Void{
		//trace(html);
		var title:String = html.split("<!---title--->")[1];
		trace(title);
		var time:String = html.split("<!---time--->")[1];
		var content:String = html.split("<!---content--->")[1];
		var source:String = StringUtil.intercept (html.split("<!---time--->")[2], "_blank", "</a>").slice(8);
		
		var _up:LoadVars = new LoadVars();
		_up.onLoad = Delegate.create(this,onSendOK);
		_up.title = title;
		_up.content = content;
		_up.from = source;
		
		var _o:LoadVars = new LoadVars();
		_o.onLoad = Delegate.create(this,onSendOK);
		_up.sendAndLoad("http://218.1.73.175:8888/htmlEditor/tingwen/tingwen.jsp",_o,"POST");

	}
	
	private function onSendOK(){
		trace("OK!");
		if(_id < _maxid)loadHtml(++_id);
	}
	private function onLoadError() : Void {
		loadHtml(_id);
	}
}