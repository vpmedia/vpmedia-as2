import com.fear.movieclip.CoreMovieClip;
import com.fear.yahoo.services.impl.SimpleSearchResultXML;
import com.fear.yahoo.services.views.ImageSearchResultsDisplay;
import com.fear.util.StringUtil;
import com.fear.yahoo.menu.SearchSlidingMenu;
import com.fear.app.paginator.Paginator;

class com.fear.yahoo.SearchTest extends CoreMovieClip
{
	private var $searchType:String;
	private var $searchXML:XML;
	private var $imageXML:XML;
	private var $linksNode:XMLNode;
	private var $totalResultsAvailable:Number;
	private var $totalResultsReturned:Number;
	private var $firstResultPosition;
	// assets assumed to be present in .fla
	private var paginator:Paginator;
	private var searchInput:TextField;
	private var searchResultsView:TextField;
	private var debug:TextField;
	private var scrollbar:MovieClip;
	private var imageResults:MovieClip;
	private var localSearch:MovieClip;
	private var navigation:MovieClip;
	private var btnSubmit:Button;
	
	public function SearchTest()
	{
		this.setClassDescription('com.fear.yahoo.SearchTest');
		// default
		this.$searchType = 'web';
		this.formatUI();
		this.localSearch.searchInput.onChanged = function(textfield_txt:TextField) 
		{
			_parent._parent.searchInput.text = this.text;
		}
		this.btnSubmit.onRelease = function()
		{
			_parent.submitForm();
		}
		this.handleKeyEvents();
	}
	private function handleKeyEvents()
	{
		var keyListener:Object = new Object();
		keyListener.context = this;
		keyListener.onKeyDown = function() 
		{
		   //fscommand('','onRemoteEvent(' + Key.getCode() + ')');
		   switch(Key.getCode())
		   {
			   case 13:
			   {
				   // enter key
				   this.context.submitForm();
			   }
			   break;
		   }
		   trace("Key.DOWN -> Code: "+Key.getCode()+"\tACSII: "+Key.getAscii()+"\tKey: "+chr(Key.getAscii()));
		};
		keyListener.onKeyUp = function() 
		{
		   trace("Key.UP -> Code: "+Key.getCode()+"\tACSII: "+Key.getAscii()+"\tKey: "+chr(Key.getAscii()));
		};
		Key.addListener(keyListener);
	}
	private function onSearchTypeChange(searchType:String)
	{
		trace('SearchTest.onSearchTypeChange: '+ searchType)
		this.$searchType = searchType;
		this.formatUI();
		this.submitForm();
	}
	public function submitForm():Void
	{
		var pageOffset = arguments[0];
		trace('[SearchTest] submitForm invoked')
		if(this.searchInput.text != '')
		{
			if(this.$searchType == 'local')
			{
				// pass the zip in for local search
				this.$searchXML = new SimpleSearchResultXML(this, resultHandler, this.searchInput.text, this.$searchType, this.localSearch.searchInputZip.text, this, pageOffset);
			}
			else
			{
				this.$searchXML = new SimpleSearchResultXML(this, resultHandler, this.searchInput.text, this.$searchType, undefined, this, pageOffset);
			}
		}
		else
		{
			this.searchResultsView.htmlText = '';
		}
	}
	public function next(context:MovieClip):Void
	{
		var current:Number = Number(context.searchXML.firstChild.attributes.firstResultPosition);
		trace('next invoked: '+ Number(current + 1))
		context.submitForm(Number(current + 1));
	}
	public function previous(context:MovieClip):Void
	{
		var current:Number = Number(context.searchXML.firstChild.attributes.firstResultPosition);
		trace('next invoked: '+ Number(current + 1))
		context.submitForm(Number(current - 1));
	}
	public function gotoPage(context:MovieClip, page:Number):Void
	{
		trace('gotoPage invoked: ')
		trace('context: '+context)
		trace('page: '+page)
		context.submitForm(page);
	}
	private function resultHandler(sender, success:Boolean, resultXML, context)
	{
		sender.debug.htmlText = "xml load succeeded: " + success;
		trace("xml load succeeded: " + success);
		if(success != true)
		{
			this.submitForm();
			return;
		}
		sender.debug.htmlText += "\nxml:\n"+ resultXML;
		this.$searchXML = resultXML;
		/*
		trace('context: '+this)
		trace('success: '+success)
		trace('resultXML: '+resultXML)
		*/
		var i:Number = 0;
		sender.$imageXML = new XML();
		sender.$linksNode = sender.$imageXML.createElement("images");
		// place the root into the XML tree
		sender.$imageXML.appendChild(sender.$linksNode);
		//
		trace('context: '+context)
		context.searchResultsView.htmlText = '';
		var node:XMLNode;
		var resultsArray:Array = new Array();
		// build data array from xml results
		var i = 0;
		trace('sender.imageResults._visible: '+ sender.imageResults._visible)
		trace('this.$searchXML.firstChild.childNodes: '+this.$searchXML.firstChild.childNodes.length)
		
		this.$totalResultsAvailable = this.$searchXML.firstChild.attributes.totalResultsAvailable;
		this.$totalResultsReturned = this.$searchXML.firstChild.attributes.totalResultsReturned;
		this.$firstResultPosition = this.$searchXML.firstChild.attributes.firstResultPosition;
		if(this.$totalResultsAvailable > 1000)
		{
			this.$totalResultsAvailable = 1000;
		}
		trace('[SearchTest] resultHandler found results:');
		trace("\ttotalResultsAvailable: "+ this.$totalResultsAvailable);
		trace("\ttotalResultsReturned: "+ this.$totalResultsReturned);
		trace("\tfirstResultPosition: "+ this.$firstResultPosition);
		
		trace('if: ' +this.$totalResultsReturned+' > '+10)
		if(this.$totalResultsReturned >= 10)
		{
			sender.paginator._visible = true;
			sender.paginator.init(this.$totalResultsAvailable, 10, 'pageMenuItem', this.$firstResultPosition, 8, sender);
		}
		else
		{
			sender.paginator._visible = false;
		}
		
		for(node in this.$searchXML.firstChild.childNodes)
		{
			var nodes = this.$searchXML.firstChild.childNodes[node].childNodes;
			var primaryDetailArray:Array = new Array();			
			for(var prop in nodes)
			{
				//trace(nodes[prop].nodeName+' = '+nodes[prop].firstChild.nodeValue)
				if(nodes[prop].childNodes.length > 1)
				{
					// trace(nodes[prop].nodeName + ' has children')
					primaryDetailArray[nodes[prop].nodeName] = new Array();
					for(var props in nodes[prop].childNodes)
					{
						primaryDetailArray[nodes[prop].nodeName][nodes[prop].childNodes[props].nodeName] = nodes[prop].childNodes[props].firstChild.nodeValue
					}
				}
				else
				{
					// trace(nodes[prop].nodeName + ' has NO children')
					primaryDetailArray[nodes[prop].nodeName] = nodes[prop].firstChild.nodeValue;
				}
			}
			// trace('put in: '+ primaryDetailArray.Title);
			resultsArray[i] = primaryDetailArray;
			i++;
		}
		trace('paint: '+sender.paint);
		sender.paint(resultsArray);
		sender.formatUI();
	}
	private function paint(resultsArray:Array)
	{
		for(var result in resultsArray)
		{
			trace('[SearchTest] paint invoked w/ searchtype: '+this.$searchType)
			switch(this.$searchType)
			{
				case "web":
					this.searchResultsView.htmlText += '<a target="YahooSearchResults" href="'+ resultsArray[result].Url +'"><b>'+resultsArray[result].Title + '</b></a><br/>';
					if(resultsArray[result].Summary != undefined)
					{
					   this.searchResultsView.htmlText += resultsArray[result].Summary + '<br/><br/>'
					}
				break;
				case "image":
					var itemNode:XMLNode  = this.$imageXML.createElement("item");
					itemNode.attributes.imageURL = StringUtil.strip(resultsArray[result].Url);
					itemNode.attributes.name   = StringUtil.strip(resultsArray[result].Title);
					itemNode.attributes.thumbURL = StringUtil.strip(resultsArray[result].Thumbnail.Url)
					this.$linksNode.appendChild(itemNode);
				break;
				case "local":
					if(resultsArray[result].Title != undefined)
					{
						this.searchResultsView.htmlText += '<a target="YahooSearchResults" href="'+ resultsArray[result].Url +'"><b>'+resultsArray[result].Title + '</b></a><br/>';
						if(resultsArray[result].Summary != undefined)
						{
						  this.searchResultsView.htmlText += resultsArray[result].Summary + '<br/><br/>'
						}
					}						
				break;
				case "news":
					this.searchResultsView.htmlText += '<a target="YahooSearchResults" href="'+ resultsArray[result].Url +'"><b>'+resultsArray[result].Title + '</b></a><br/>';
					if(resultsArray[result].Summary != undefined)
					{
					   this.searchResultsView.htmlText += resultsArray[result].Summary + '<br/><br/>'
					}
				break;
				case "video":
					this.searchResultsView.htmlText += '<a target="YahooSearchResults" href="'+ resultsArray[result].Url +'"><b>'+resultsArray[result].Title + '</b></a><br/>';
					if(resultsArray[result].Summary != undefined)
					{
					   this.searchResultsView.htmlText += resultsArray[result].Summary + '<br/><br/>'
					}
				break;
			}
		}
	}
	private function formatUI()
	{
		trace('[SearchTest] formatUI invoked w/ searchType: ' + this.$searchType);
		switch(this.$searchType)
		{
			case 'image':
			{
				trace('this.imageResults: '+this.imageResults);
				trace('this.$imageXML: '+this.$imageXML);
				this.scrollbar._visible = false;
				this.imageResults._visible = true;
				this.searchResultsView._visible = false;
				this.localSearch._visible = false;
				this.searchInput._visible = true;
				var imageResults = new ImageSearchResultsDisplay(this.imageResults, this.$imageXML, 'image');
			}
			break;
			case 'local':
			{
				this.localSearch.searchInput.text = this.searchInput.text;
				this.localSearch._visible = true;
				this.imageResults._visible = false;
				this.searchInput._visible = false;
			}
			break;
			default:
			{
				this.searchInput._visible = true;
				this.searchResultsView._visible = true;
				this.scrollbar._visible = true;
				this.localSearch._visible = false;
				this.imageResults._visible = false;
			}
			break;
		}
	}
	public function get searchXML():XML
	{
		return this.$searchXML;
	}
}