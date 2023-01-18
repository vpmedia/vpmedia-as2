/*
	FCEncodeInfo
	
    Created by Jesse R. Warden a.k.a. "JesterXL"
	jesterxl@jessewarden.com
	http://www.jessewarden.com
	jesse@universalmind.com
	http://www.universalmind.com
	
	This is release under a Creative Commons license. 
    More information can be found here:
    
    http://creativecommons.org/licenses/by/2.5/
*/

class com.jxl.vidconverter.vo.fcs.FCEncodeInfo
{
	public var client:Object;
	public var videoName:String;
	public var id:String;
	
	function FCEncodeInfo(client, videoName, id)
	{
		this.client = client;
		this.videoName = videoName;
		this.id = id;
	}
}