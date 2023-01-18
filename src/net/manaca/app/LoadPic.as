import net.manaca.lang.BObject;
import net.manaca.io.file.TextLoader;
import net.manaca.util.Delegate;
import net.manaca.util.StringUtil;

/**
 * 
 * @author Wersling
 * @version 1.0, 2006-7-12
 */
class net.manaca.app.LoadPic extends BObject {
	private var className : String = "net.manaca.app.LoadPic";
	private var _path:String = "http://humor.cinews.net/piclist.asp?picid=";
	private var _id:Number = 52;
	
	private var _loader:TextLoader;
	public function LoadPic() {
		super();
		System.useCodepage =true;
		
		Tracer.setLevel("INFO");
		loadHtml(++_id);
		
	}
	public function loadHtml(id:Number):Void{
		_loader = new TextLoader();
		_loader.addEventListener("onLoadComplete",Delegate.create(this,onLoadComplete));
		_loader.addEventListener("onLoadError",Delegate.create(this,onLoadError));
		_loader.load(_path + id);
	}
	private function onLoadComplete(o) : Void {
		var _str = (o.text);
		var i = 0;
		for (var prop in _str) {
			i++;
			if(i == 3) Analyse(_str[prop]);
			
		}
		//Analyse(_str);
	}
	public function Analyse (html:String):Void{
		//trace(html);
		var title:String = StringUtil.intercept (html, "〖", "〗");
		title = StringUtil.intercept (title, "<B>", "</B>").slice(3,title.length);
		var url:String = StringUtil.intercept (html, "src=", "ALT");
		url = "http://humor.cinews.net/"+url.slice(4,url.length);
		trace("<a href="+url+"/>"+_id+":"+title+"</a>");
//		_root.text = _root.text+(_id+":"+title+"|"+url)+"\n";
		loadHtml(++_id);
	}
	private function onLoadError() : Void {
		loadHtml(_id);
	}

}