/**
* FeedParser Class v1.0
* Author  : Mika Palmu
* Licence : Use freely, giving credit when you can.
* Website : http://www.meychi.com/
*/
class com.vpmedia.text.RssFeedParser
{
	/**
	* Variables
	*/
	private var blog:XML;
	private var container:Array;
	private var channel:Object;
	public var onParse:Function;
	public var onError:Function;
	/**
	* Constructor
	*/
	public function RssFeedParser ()
	{
		this.blog = new XML ();
		this.container = new Array ();
		this.channel = new Object ();
	}
	/**
	* Gets the container array.
	*/
	public function getItems ():Array
	{
		return this.container;
	}
	/**
	* Gets channel object.
	*/
	public function getChannel ():Object
	{
		return this.channel;
	}
	/**
	* Gets the kilobytes loaded.
	*/
	public function getKbsLoaded ():Number
	{
		var bytes = this.blog.getBytesLoaded ();
		return Math.round (bytes / 1000);
	}
	/**
	* Gets the percent loaded.
	*/
	public function getPercentLoaded ():Number
	{
		var percent = this.blog.getBytesLoaded () / this.blog.getBytesTotal () * 100;
		var rounded = Math.round (percent);
		if (rounded < 101 && rounded > 0)
		{
			return rounded;
		}
		else
		{
			return 0;
		}
	}
	/**
	* Loads the xml feed to the RSSParser.
	*/
	public function loadXML (link:String):Void
	{
		var reference = this;
		this.container = new Array ();
		this.blog.ignoreWhite = true;
		this.blog.onLoad = function (success)
		{
			if (success)
			{
				reference.parseFeed ();
			}
			else
			{
				reference.onError ("xml_loading_failed");
			}
		};
		this.blog.load (link);
	}
	/**
	* Converts the html entities
	*/
	private function convertEntities (str:String):String
	{
		var ca:Array = new Array ("&", "<", ">", "\"", "'");
		var ra:Array = new Array ("&amp;", "&lt;", "&gt;", "&quot;", "&apos;");
		for (var j = 0; j < ra.length; j++)
		{
			var s = str.split (ra[j]);
			str = new String ("");
			for (var i = 0; i < s.length; i++)
			{
				if (i == s.length - 1)
				{
					str += s[i];
				}
				else
				{
					str += s[i] + ca[j];
				}
			}
		}
		return str;
	}
	/**
	* Handles the items that contains the entry data.
	*/
	private function handleItem (subNode:XMLNode):Void
	{
		var itemNode = subNode.firstChild;
		while (itemNode != null)
		{
			if (itemNode.nodeName == "title")
			{
				var temp = itemNode.firstChild.toString ();
				var itemTitle = temp.substr (0, 1).toUpperCase () + temp.substr (1);
			}
			else if (itemNode.nodeName == "link")
			{
				var itemLink = itemNode.firstChild.toString ();
			}
			else if (itemNode.nodeName == "description")
			{
				var itemDescription = this.convertEntities (itemNode.firstChild.toString ());
			}
			else if (itemNode.nodeName == "dc:date")
			{
				var datestring = itemNode.firstChild.toString ();
				var year = datestring.substr (0, 4);
				var month = datestring.substr (5, 2);
				var day = datestring.substr (8, 2);
				var time = datestring.substr (11, 5);
				var datestamp = day + "." + month + "." + year + " - " + time;
			}
			else if (itemNode.nodeName == "dateAdd")
			{
				var datestamp = itemNode.firstChild.toString ();
			}
			else if (itemNode.nodeName == "pubDate")
			{
				var datestamp = itemNode.firstChild.toString ();
			}
			itemNode = itemNode.nextSibling;
		}
		this.container.push (new Object ({title:itemTitle, link:itemLink, desc:itemDescription, date:datestamp}));
	}
	/**
	* Parses and validates the RSS feed.
	*/
	private function parseFeed ():Void
	{
		var mainNode = blog.firstChild;
		var subNode = mainNode.firstChild;
		while (subNode != null)
		{
			if (subNode.nodeName == "item")
			{
				var itemNode = subNode;
				this.handleItem (itemNode);
			}
			else if (subNode.nodeName == "channel")
			{
				var channelNode = subNode.firstChild;
				while (channelNode != null)
				{
					if (channelNode.nodeName == "item")
					{
						this.handleItem (channelNode);
					}
					else if (channelNode.nodeName == "link")
					{
						var linkToSite = channelNode.firstChild;
					}
					else if (channelNode.nodeName == "title")
					{
						var siteTitle = this.convertEntities (channelNode.firstChild.toString ());
					}
					else if (channelNode.nodeName == "language")
					{
						var siteLang = channelNode.firstChild.toString ();
					}
					else if (channelNode.nodeName == "description")
					{
						var siteDesc = channelNode.firstChild.toString ();
					}
					channelNode = channelNode.nextSibling;
				}
			}
			subNode = subNode.nextSibling;
		}
		this.channel = new Object ({title:siteTitle, link:linkToSite, lang:siteLang, desc:siteDesc});
		this.onParse ();
	}
}
