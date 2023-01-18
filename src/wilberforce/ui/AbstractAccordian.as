import com.bourre.commands.Delegate;

import flash.geom.Rectangle;
import wilberforce.geom.rect;
import wilberforce.util.drawing.drawingUtility;

class wilberforce.ui.AbstractAccordian
{
	private var _container:MovieClip;
	private var _sections:Number=0;
	private var _width:Number=0;
	private var _height:Number=0;
	
	private var _sectionClips:Array;
	private var _contentClips:Array;
	private var _headerHeights:Array;
	private var _totalHeaderHeight:Number;
	private var _visiblePageHeight:Number;
	private var _sectionMasks:Array;
	
	private var _selectedSection:Number=-1;
	
	// Uses scrollrect to clip. todo - maybe remove as nested scrollrects seem to cause a crash
	private var _clipRectangle:Rectangle;

		
	function AbstractAccordian(container:MovieClip,width:Number,height:Number)
	{
		_container=container;
		_width=width;
		_height=height;
		_sectionClips=new Array();
		_contentClips=new Array();
		_headerHeights=new Array();
		_sectionMasks=new Array();
		_totalHeaderHeight=0;
		_clipRectangle= new Rectangle(0, 0, width, height);
		_container.scrollRect=_clipRectangle
	}
	
	function addSection(headerAttachName:String,headerPropertyList:Object,contentAttachName:String,contentPropertyList:Object)
	{
		var tSectionContainer:MovieClip=_container.createEmptyMovieClip("sectionContainer"+_sections,_container.getNextHighestDepth());
		_sectionClips[_sections]=tSectionContainer;
		tSectionContainer._y=_totalHeaderHeight;
		
		
		//trace("added header "+tHeader+" - "+tSectionContainer);
		if (contentAttachName)
		{
			_contentClips[_sections]=tSectionContainer.attachMovie(contentAttachName,"content",tSectionContainer.getNextHighestDepth(),contentPropertyList);
		}
		else 
		{
			// Create an empty content section
			_contentClips[_sections]=tSectionContainer.createEmptyMovieClip("content",tSectionContainer.getNextHighestDepth());
		}
		
		_sectionMasks[_sections]=tSectionContainer.createEmptyMovieClip("mask",tSectionContainer.getNextHighestDepth());
		var tHeader:MovieClip=tSectionContainer.attachMovie(headerAttachName,"header",tSectionContainer.getNextHighestDepth(),headerPropertyList);
		tHeader.onPress=Delegate.create(this,selectSection,_sections);
		
		_contentClips[_sections]._y=tHeader._height;
		
		_headerHeights[_sections]=tHeader._height;
		_totalHeaderHeight+=tHeader._height;
		_visiblePageHeight=_height-_totalHeaderHeight;
		_sections++
		updateClipping();
	}
	
	private function updateClipping()
	{
		//var tScrollRectangle=new Rectangle(0,0,_width,_visiblePageHeight);
	//=new Rectangle(0,0,_width,_visiblePageHeight);
		for (var i=0;i<_contentClips.length;i++	)
		{
			//_contentClips[i].scrollRect=tScrollRectangle;
			var tClipRect=new rect(0,0,_width,_visiblePageHeight+_headerHeights[i]);
			_sectionMasks[i].clear();
			drawingUtility.drawRect(_sectionMasks[i],tClipRect);
			//trace("Drawing mask "+i+" - "+_sectionMasks[i]);
			_contentClips[i].setMask(_sectionMasks[i]);
		}
	}
	public function getContentClip(index:Number):MovieClip
	{
		return _contentClips[index];
	}
	
	public function selectSection(index:Number):Void
	{
		var ty=0;
		var tx=0;
		for (var i:Number=0;i<_sections;i++)
		{
			
			moveSection(_sectionClips[i],tx,ty);
			ty+=_headerHeights[i];
			if (index==i) ty+=_visiblePageHeight;
		}
		_selectedSection=index;
	}
	
	// Overwrite to get animation
	public function moveSection(sectionContainer:MovieClip,x:Number,y:Number)
	{
		sectionContainer._x=x;
		sectionContainer._y=y;
		
	}
}