
/**
* Value object used to store result in RssService
* 
*/
class com.bumpslide.data.types.RssFeed
{
	
	// required elements
	var title:String;
	var link:String;
	var description:String;
	
	
	
	var pubData:String;
	var language:String;
	var generator:String;
	
	// collection of type RssItem
	var items:Array; 
	
}

