import com.fear.movieclip.CoreMovieClip;

class com.fear.app.paginator.Paginator extends CoreMovieClip
{
	private var $resultsTotal:Number;
	private var $limit:Number;
	private var $offset:Number;
	private var $previousOffset:Number;
	private var $nextOffset:Number;
	private var $pages:Number;
	private var $maxPages:Number;
	private var $currentPage:Number;
	private var $view:MovieClip;
	
	public function Paginator()
	{
		trace('[Paginator] constructor invoked')
		this.$limit = 10; // rows to return
		this.$maxPages = 5;
	}
	public function init(total:Number, limit:Number, linkageId:String, currentPage:Number, maxPages, context)
	{
		this.$view.removeMovieClip();
		this.$view = this.createEmptyMovieClip('$view', this.getNextHighestDepth());
		this.$resultsTotal = total;
		this.$limit = limit;
		this.$currentPage = currentPage;
		this.$maxPages = maxPages;
		trace('[Paginator] init invoked')
		if (this.$offset == undefined || this.$offset < 1) 
		{
			this.$offset = 1;
		}
		
		if (this.$offset != 1) 
		{ 
			// bypass PREV link if offset is 0
			this.$previousOffset = this.$offset - this.$limit;
			// print "<a href=\"$PHP_SELF?offset=$prevoffset\">PREV</a> &nbsp; \n";
		}
		
		// calculate number of pages needing links
		this.$pages = Math.ceil(this.$resultsTotal / this.$limit);
				
		var i = 1;
		var xOffset = 0;
		var item:MovieClip;
		if(this.$pages > 1)
		{
			item = this.$view.attachMovie(linkageId,'prev', this.$view.getNextHighestDepth());
			item.name = 'PREV';
			item.arrowRight._visible = false;
			//
			item._x = xOffset;
			xOffset += item._width;
			if(currentPage == 1)
			{
				item._alpha = 35;
				item.useHandCursor = false;
				item.onRelease = undefined;
			}
			else
			{
				item._alpha = 100;
				item.onRelease = function()
				{
					context.previous(context);
				}
			}
		}
		while(this.$pages--)
		{
			// loop thru and add links
			trace('[Paginator] adding page: ' + i);
			item = this.$view.attachMovie(linkageId,linkageId+i, this.$view.getNextHighestDepth());
			item.arrowLeft._visible = false;
			item.arrowRight._visible = false;
			//
			item._x = xOffset;
			xOffset += item._width;
			//
			item.name = i;
			item.page = i;
			item.onRelease = function()
			{
				context.gotoPage(context, this.page);
			}

			if(currentPage == i)
			{
				item.gotoAndStop('active');
				item.onRelease = undefined;
			}
			else
			{
				item.gotoAndStop('inactive')
			}
			if(i >= this.$maxPages)
			{
				break;
			}
			i++;
		}
		if(this.$pages > 1)
		{
			item = this.$view.attachMovie(linkageId,'next', this.$view.getNextHighestDepth());
			item.name = 'NEXT';
			item.arrowLeft._visible = false;
			//
			item._x = xOffset;
			xOffset += item._width;
			if(currentPage == this.$maxPages)
			{
				item._alpha = 35;
				item.useHandCursor = false;
				item.onRelease = undefined;
			}
			else
			{
				item._alpha = 100;
				item.onRelease = function()
				{
					context.next(context);
				}
			}
		}
		
		// check to see if last page
		if (!((this.$offset/this.$limit) == $pages) && this.$pages != 1) 
		{
		    // not last page so give NEXT link
		    this.$nextOffset = this.$offset + this.$limit;
		}
	}	
}