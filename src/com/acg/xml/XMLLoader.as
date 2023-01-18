
import mx.utils.Delegate;
import mx.events.EventDispatcher;
import com.acg.xml.DotXMLParser;
import com.acg.debug.debug;

/**
* XMLLoader클래스
* XML객체를 받아서 파싱후 이벤트로 전달해줍니디ㅏ.
* @author 홍준수
* @date 2007.5.21
*/

class com.acg.xml.XMLLoader extends EventDispatcher
{
	/**
	* @param LOAD_COMPLETE 로딩완료때 발생하는 이벤트
	* @param LOAD_ERROR 로딩에러시 발생하는 이벤트
	*/
	
	public static var LOAD_COMPLETE:String = "onLoadComplete";
	public static var LOAD_ERROR:String = "loadError";
	
	private var loader:XML;
	
	/**
	* XML의 경로를 받아서 파서에 넘깁니다.
	* @param targetXML XML경로
	* @param param		넘길 파라메터 ( POST방식 )
	*/

	public function XMLLoader( targetXML:String , param:Object )
	{
		EventDispatcher.initialize(this);
		
		loader = new XML();
		loader.ignoreWhite = true;
		
		/**
		* 파라메터가 있을 경우 POST방식으로 넣어줍니다.
		*/
		
		if ( param )
		{
			for ( var prop in param )
			{
				loader[ prop ] = param[prop];
			}
		}
		
		loader.onLoad = Delegate.create(this, XMLLoadOk);	
		loader.onHTTPStatus = Delegate.create( this , onStatusView );
		
		trace (" **** XML경로===" + targetXML );
/*		
		if ( targetXML == "../xml/cardlist.xml" )
		{
			targetXML = "http://twww3.hyundaicard.com/flash/xml/cardList.xml";
		}
*/		
		loader.load( targetXML );
		
	}
	
	private function onStatusView ( httpStatus:Number )
	{
		trace("********** XML 로딩상태코드   :   "+ httpStatus + " ***************** " );		
		
		var httpStatusType:String;
		
		if(httpStatus < 100) {
			httpStatusType = "flashError";
		}
		else if(httpStatus < 200) {
			httpStatusType = "informational";
		}
		else if(httpStatus < 300) {
			httpStatusType = "successful";
		}
		else if(httpStatus < 400) {
			httpStatusType = "redirection";
		}
		else if(httpStatus < 500) {
			httpStatusType = "clientError";
		}
		else if(httpStatus < 600) {
			httpStatusType = "serverError";
		}
		
		trace(" ****************** 상태 : " + httpStatusType );
	}
	
	private function XMLLoadOk(s)
	{
		if (s) {
			trace("XML 로딩성공");
			var dat = DotXMLParser.parse(loader);
			dispatchEvent({type:XMLLoader.LOAD_COMPLETE , dat:dat});
			loader = null;
		} 
		else 
		{
			dispatchEvent({type:XMLLoader.LOAD_ERROR});
		}
	}
}