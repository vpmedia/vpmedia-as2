import com.FlashDynamix.core.Dispatcher;
import com.FlashDynamix.loaders.XmlLoader;
import com.FlashDynamix.events.Event;
import com.FlashDynamix.events.EventArgs;
import com.FlashDynamix.utils.Delegate;

class com.FlashDynamix.services.YouTube extends Dispatcher {

	private var loader:XmlLoader;

	public var APIKey:String="WplekwLy_Nw";

	private static var servicesDomain:String = "http://code.flashdynamix.com/YouTube/";
	private static var proxyUrl:String= servicesDomain+"proxyRequest.aspx?url=";
	public static  var APIUrl:String="http://www.youtube.com/api2_rest";
	public static  var FLVUrl:String="http://www.youtube.com/get_video?video_id=";

	private static  var USERAPI:String="youtube.users.";
	private static  var VIDEOAPI:String="youtube.videos.";
	public static  var USERFAVVIDEOS:String=USERAPI + "list_favorite_videos";
	public static  var USERPROFILE:String=USERAPI + "get_profile";
	public static  var USERFRIENDS:String=USERAPI + "list_friends";

	public static  var VIDEOSBYTAG:String=VIDEOAPI + "list_by_tag";
	public static  var VIDEOIDDETAILS:String=VIDEOAPI + "get_details";
	public static  var USERVIDEOS:String=VIDEOAPI + "list_by_user";
	public static  var FEATUREDVIDEOS:String=VIDEOAPI + "list_featured";
	public static  var VIDEOSBYCATTAG:String=VIDEOAPI + "list_by_category_and_tag";
	public static  var VIDEOSPLAYLIST:String=VIDEOAPI + "list_by_playlist";
	public static  var VIDEOID:String = "videoid";

	public function YouTube() {
		loader=new XmlLoader();
		loader.lazyDecoding=false;

		var obj:Object=new Object();
		obj.loaded=Delegate.create(this,onLoaded);
		obj.error=Delegate.create(this,onError);

		loader.addListeners(obj);
	}
	private function onLoaded(e:EventArgs) {
		var data;
		switch (e.type) {
			case USERPROFILE :
				data=e.value.data.ut_response.user_profile;
				break;
			case USERFRIENDS :
				data=e.value.data.ut_response.friend_list;
				break;
			case VIDEOIDDETAILS :
				data=e.value.data.ut_response.video_details;
				break;
			case VIDEOID :
				data = e.value.data.video;
				break;
			default :
				data=e.value.data.ut_response.video_list;
				break;
		}
		dispatchEvent(new Event(Event.LOADED,new EventArgs(YouTube,e.type,data)));
	}
	private function onError(e:EventArgs) {
		dispatchEvent(new Event(Event.ERROR, new EventArgs(YouTube,e.type)));
	}
	public function videoIdDetails(id:String) {
		var queryVars:Object=new Object();
		queryVars.method=VIDEOIDDETAILS;
		queryVars.dev_id=APIKey;
		queryVars.video_id=id;
		loader.load(proxyUrl + APIUrl,VIDEOIDDETAILS,queryVars);
	}
	public function videosbyTag(tag:String,pg:Number,num:Number) {
		var queryVars:Object=new Object();
		queryVars.method=VIDEOSBYTAG;
		queryVars.dev_id=APIKey;
		queryVars.tag=tag;
		queryVars.page=pg != undefined?pg:1;
		queryVars.per_page=num != undefined?num:100;
		loader.load(proxyUrl + APIUrl,VIDEOSBYTAG,queryVars);
	}
	public function videosbyCategoryTag(tag:String,catId:Number,pg:Number,num:Number) {
		var queryVars:Object=new Object();
		queryVars.method=VIDEOSBYCATTAG;
		queryVars.dev_id=APIKey;
		queryVars.category_id=catId;
		queryVars.tag=tag;
		queryVars.page=pg != undefined?pg:1;
		queryVars.per_page=num != undefined?num:100;
		loader.load(proxyUrl + APIUrl,VIDEOSBYCATTAG,queryVars);
	}
	public function userFavouriteVideos(user:String) {
		var queryVars:Object=new Object();
		queryVars.method=USERFAVVIDEOS;
		queryVars.dev_id=APIKey;
		queryVars.user=user;
		loader.load(proxyUrl + APIUrl,USERFAVVIDEOS,queryVars);
	}
	public function userProfile(user:String) {
		var queryVars:Object=new Object();
		queryVars.method=USERPROFILE;
		queryVars.dev_id=APIKey;
		queryVars.user=user;
		loader.load(proxyUrl + APIUrl,USERPROFILE,queryVars);
	}
	public function userFriends(user:String) {
		var queryVars:Object=new Object();
		queryVars.method=USERFRIENDS;
		queryVars.dev_id=APIKey;
		queryVars.user=user;
		loader.load(proxyUrl + APIUrl,USERFRIENDS,queryVars);
	}
	public function userVideos(user:String,pg:Number,num:Number) {
		var queryVars:Object=new Object();
		queryVars.method=USERVIDEOS;
		queryVars.dev_id=APIKey;
		queryVars.user=user;
		queryVars.page=pg != undefined?pg:1;
		queryVars.per_page=num != undefined?num:100;
		loader.load(proxyUrl + APIUrl,USERVIDEOS,queryVars);
	}
	public function featuredVideos(user:String) {
		var queryVars:Object=new Object();
		queryVars.method=FEATUREDVIDEOS;
		queryVars.dev_id=APIKey;
		loader.load(proxyUrl + APIUrl,FEATUREDVIDEOS,queryVars);
	}
	public function videosPlaylist(id:String,pg:Number,num:Number) {
		var queryVars:Object=new Object();
		queryVars.method=VIDEOSPLAYLIST;
		queryVars.dev_id=APIKey;
		queryVars.id=id;
		queryVars.page=pg != undefined?pg:1;
		queryVars.per_page=num != undefined?num:100;
		loader.load(proxyUrl + APIUrl,VIDEOSPLAYLIST,queryVars);
	}
	public function getVideoId(id:String){
		var queryVars:Object=new Object();
		queryVars.method = VIDEOID;
		queryVars.url = "http://www.youtube.com/watch?v="+id
		loader.load(servicesDomain+"getVideoId.aspx",VIDEOID,queryVars);
	}
}