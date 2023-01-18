/*
 * Copyright the original author or authors.
 * 
 * Licensed under the MOZILLA PUBLIC LICENSE, Version 1.1 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *      http://www.mozilla.org/MPL/MPL-1.1.html
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
  
/**
 * @author Simon Oliver
 * @version 1.0
 */

import wilberforce.geom.circle;
import wilberforce.geom.rect;
import wilberforce.geom.IShape2D;
import wilberforce.util.textField.textFieldUtility;
import wilberforce.util.drawing.drawingUtility;
import wilberforce.util.drawing.styles.*;
import wilberforce.layout.text.textLayoutWord;
/**
* System to allow text to fill a number of different shapes, and to avoid obstacles. Allows wrapping around any shape
* implementing IShape2D. 
* Note: currently only supports geom.rect and geom.circle 
*/
class wilberforce.layout.text.textLayoutSystem implements wilberforce.container.IPagingContent
{

	var _containers:Array;
	var _blockers:Array;
	
	var _containerSegments:Array;
	
	var _movieClip:MovieClip;
	var _text:String;
	
	var _paragraphs:Array;
	var _paragraphsAsWords:Array;
	
	var _currentParagraphIndex:Number;
	var _currentWordIndex:Number;
	private var _currentTextFormat:TextFormat;
	
	private var _spaceWidth:Number;
	private var rowHeight:Number;
	
	private var _currentPage:Number;
	
	var _activeTextFields:Array;
	static var debugGreenFill:fillStyleFormat= new fillStyleFormat(0x0000FF, 50);
		
	var _asMovieClips:Boolean;
	var _wordMovieClips:Array;
	/**
	* Constructor. Creates the text layout system and binds it to a movieClip
	* @param	movieClip
	*/
	function textLayoutSystem(movieClip:MovieClip,asMovieClips:Boolean)
	{
		_containers=new Array();
		_containerSegments=new Array();
		_blockers=new Array();
		_movieClip=movieClip;
		_currentPage=0;
		_asMovieClips=asMovieClips;
	}
	
	/**
	* Add a container for text to be placed into
	* @param	shape
	*/
	public function addContainer(shape:IShape2D):Void
	{
		_containers.push(shape);
	}
	/**
	* Add a blocker that text must flow around
	* @param	shape
	*/
	public function addBlocker(shape:IShape2D):Void
	{
		_blockers.push(shape);
	}
	
	/**
	* Assign the text to the text system
	* @param	text
	*/
	public function setText(text:String,textFormat:TextFormat):Void
	{
		_text=text;
		// Break into lines
		_paragraphs=_text.split("\n");
		_paragraphsAsWords=new Array();
		for (var i:Number=0;i<_paragraphs.length;i++)
		{		
			// Break into words
			var tParaSplit:Array=_paragraphs[i].split(" ");
			var tWordArray:Array=new Array();
			for (var j:Number=0;j<tParaSplit.length;j++)
			{
				var tWord=new textLayoutWord(tParaSplit[j],textFormat,null);
				//_paragraphsAsWords.push(_paragraphs[i].split(" "));
				tWordArray.push(tWord);
			}
			_paragraphsAsWords.push(tWordArray);
			//
		}
		_currentParagraphIndex=0;
		_currentWordIndex=0;
	}
	
	public function setParagraphs(wordsArray:Array)
	{
		_paragraphsAsWords=wordsArray;
		_currentParagraphIndex=0;
		_currentWordIndex=0;
	}
	/**
	* Render the text assigned to the system
	* @param	textFormat 	Text format to use for rendering
	* @param	embedFont	Embed the font, if required
	*/
	public function render(embedFont:Boolean):Void
	{	
		// Hmm. For now we shall say that the size stays the same from the beginning
		
		if (_containers.length==0) return;
		//_currentTextFormat=textFormat;
		// If no leading property, force it
	
		_currentTextFormat=_paragraphsAsWords[0][0].textFormat;	
		rowHeight=_currentTextFormat.size+_currentTextFormat.leading;;

		// TODO - determine space width
		_spaceWidth=5;
		
		// First of all, create all the valid containers
		_containerSegments=new Array();		
		for (var i:Number=0;i<_containers.length;i++)
		{
			if (_containers[i] instanceof wilberforce.geom.rect) {
				_containerSegments=_containerSegments.concat(segmentsFromRect(_containers[i]));				
			}
			if (_containers[i] instanceof wilberforce.geom.circle) 
			{				
				_containerSegments=_containerSegments.concat(segmentsFromCircle(_containers[i]));
			}						
		}
		// Next we go through and check intersections with blockers
		for (var i:Number=0;i<_containerSegments.length;i++)
		{
			var tIntersection:rect=null;
			for (var j:Number=0;j<_blockers.length;j++) {
				tIntersection=null;
				
				if (_blockers[j] instanceof wilberforce.geom.rect) {
					tIntersection=_containerSegments[i].getRectIntersection(_blockers[j]);
				}
				
				else if (_blockers[j] instanceof wilberforce.geom.circle) {
					//trace("Circle test");
					// Test intersection with the circle
					
					var tIntersection2:rect=_blockers[j].getRectIntersection(_containerSegments[i]);
					
					if (tIntersection2)
					{
						//trace("COLLISION"+tIntersection2.width);
						//drawingUtility.drawRect(_movieClip,tIntersection2,null,debugGreenFill);
						tIntersection=tIntersection2;
					}
					
					
				}
				
				if (tIntersection)
				{						
					//drawingUtility.drawRect(_movieClip,tIntersection,null,debugGreenFill);
					// Does it bisect, or just cut short
					
					if (tIntersection.width==_containerSegments[i].width)
					{
						_containerSegments.splice(i,1);
						// Correct the counter							
						i--;
						// Escape the inner loop
						j=_blockers.length;
					}
					else if (tIntersection.left==_containerSegments[i].left)
					{
						// Cut the left segment
						_containerSegments[i].width=_containerSegments[i].width-tIntersection.width;
						_containerSegments[i].x=tIntersection.width+tIntersection.x;							
					}
					else if (tIntersection.right==_containerSegments[i].right)
					{
						// Cut the right segment
						_containerSegments[i].width=tIntersection.x-_containerSegments[i].x;
					}
					else {
						// Split the segment into two and splice in
						//trace("Segment split");
						var tNewSegment1=_containerSegments[i].clone();
						tNewSegment1.right=tIntersection.left;
						var tNewSegment2=_containerSegments[i].clone();
						tNewSegment2.left=tIntersection.right;
						_containerSegments.splice(i,1,tNewSegment1,tNewSegment2);
						// Increment the counter past these two new added segments
						i++;
					}
				}

			}			
		}
		
		
		// Debug redner
		//debugDrawSegments(_containerSegments);
		
		// Render segments
		renderSegments(embedFont);
	}
	
	
	/**
	* Renders the current segments
	* @param	embedFont	Embed the font, if required
	*/
	private function renderSegments(embedFont:Boolean)	
	{
		var noSegmentsLeft:Boolean=false;
		var tCurrentSegmentIndex=0;
		var currentSegmentClips:Array=new Array();
		var currentSegmentButtonsClips:Array=new Array();
		var tSegment:rect=_containerSegments[tCurrentSegmentIndex];
		var tx:Number=tSegment.x;
		var ty:Number=tSegment.y;
		var tMaxX=tx+tSegment.width;
		
		if (_asMovieClips) {
			_wordMovieClips=new Array();
		}
		
		_activeTextFields=new Array();
		var tWordCount=0;
		while (_currentParagraphIndex<_paragraphsAsWords.length && !noSegmentsLeft)
		{
			
			//trace("Paragraph "+(_currentParagraphIndex+1)+" / "+_paragraphsAsWords.length);
			var tParagraph=_paragraphsAsWords[_currentParagraphIndex];	
			currentSegmentClips=new Array();
			while (_currentWordIndex<tParagraph.length && !noSegmentsLeft)
			{				
				//tParagraph[_currentWordIndex].text;
				var tWordObject:textLayoutWord=tParagraph[_currentWordIndex]
				var tWord:String=tWordObject.text;
				
				var tTextField:TextField;
				var tNewClip:MovieClip
				if (_asMovieClips) {
					var tDepth:Number=_movieClip.getNextHighestDepth();
					tNewClip=_movieClip.createEmptyMovieClip("word"+tDepth,tDepth);
					//tNewClip._rotation=45;
					tTextField=textFieldUtility.createTextField(tNewClip,0,0,400,400,tWordObject.textFormat,tWord,false,embedFont);
				}
				else {
					tTextField=textFieldUtility.createTextField(_movieClip,0,0,400,400,tWordObject.textFormat,tWord,false,embedFont);
				}
				var tWordDimensions:rect=textFieldUtility.toRect(tTextField);
				
				
				//trace("Trying segment "+tCurrentSegmentIndex+"/"+_containerSegments.length);
				
				if (tx+tWordDimensions.width<=tMaxX)
				{
					//trace("Valid");
					if (_asMovieClips) {
						tNewClip._x=tx;
						tNewClip._y=ty;
					}
					else {
						tTextField._x=tx;
						tTextField._y=ty;
					}
					var tButtonClip=createWordButton(tWordDimensions,tWordObject,tx,ty,tTextField,tNewClip);
					//trace("Word "+tWord+" : "+tx+","+ty);
					tx+=tWordDimensions.width;
					tx+=_spaceWidth;
					_currentWordIndex++;
					currentSegmentClips.push(tTextField);
					if (tTextField) currentSegmentButtonsClips.push(tButtonClip);
					_activeTextFields.push(tTextField);
					_wordMovieClips.push(tNewClip);
				}
				else {
					// Align text if required
					var tEndLineGap:Number=tSegment.x+tSegment.width-(tx-_spaceWidth);
					alignText(currentSegmentClips,currentSegmentButtonsClips,tEndLineGap);
					currentSegmentClips=new Array();
					currentSegmentButtonsClips=new Array();
					// Next segment
					tCurrentSegmentIndex++;
					if (tCurrentSegmentIndex>=_containerSegments.length) {
						noSegmentsLeft=true;						
						tTextField.removeTextField()
					}
					else {
						tSegment=_containerSegments[tCurrentSegmentIndex];
						tx=tSegment.x;
						ty=tSegment.y;
						// Delete the clip
						tTextField.removeTextField();
						tMaxX=tx+tSegment.width;
					}
				}
			}
			// Set up the next paragraph
			_currentParagraphIndex++;
			_currentWordIndex=0;
			tCurrentSegmentIndex++;
			if (tCurrentSegmentIndex>=_containerSegments.length) noSegmentsLeft=true;
			else {
				tSegment=_containerSegments[tCurrentSegmentIndex];
				tx=tSegment.x;
				ty=tSegment.y;
				tMaxX=tx+tSegment.width;
			}
			
		}
	}	

	public function getMovieClips()
	{
		return _wordMovieClips;
	}
	private function createWordButton(tWordDimensions:rect,tWordObject:textLayoutWord,x:Number,y:Number,assignedTextField:TextField,housingClip:MovieClip):MovieClip
	{
		if (!tWordObject.pressFunction && !tWordObject.rollOverFunction && !tWordObject.rollOutFunction) return null;
		//trace("here");
		//trace("func "+tWordObject.pressFunction+","+tWordObject.rollOverFunction+","+tWordObject.rollOverFunction);
		//trace("fun "+tWordObject.pressFunction);
		
		
		var tMovieClip:MovieClip;
		if (_asMovieClips)
		{
			tMovieClip=housingClip.createEmptyMovieClip("buttonClip",housingClip.getNextHighestDepth());
		}
		else {
			var tDepth=_movieClip.getNextHighestDepth();
			tMovieClip=_movieClip.createEmptyMovieClip("button"+tDepth,tDepth);
			tMovieClip._x=x;
			tMovieClip._y=y;
		}
		
		tMovieClip.assignedTextField=assignedTextField;
		
		tWordObject.assignedTextField=assignedTextField;
		tWordObject.assignedMovieClip=tMovieClip;
		
		//trace("added button at "+x+","+y+" rect "+tWordDimensions.x+","+tWordDimensions.y+" size "+tWordDimensions.width+","+tWordDimensions.height)
		drawingUtility.drawRect(tMovieClip,tWordDimensions,null,fillStyleFormat.transparentFillStyle);
		tMovieClip.onPress=tWordObject.pressFunction;
		tMovieClip.onRollOver=function()
		{
			TextField(tMovieClip.assignedTextField).setTextFormat(tWordObject.rollOverTextFormat);
			tWordObject.rollOverFunction();
		}
		tMovieClip.onRollOut=function()
		{
			TextField(tMovieClip.assignedTextField).setTextFormat(tWordObject.textFormat);
			tWordObject.rollOutFunction();
		}
		return tMovieClip;
	}
	/**
	* Align the words in the current segment
	* @param	textFieldArray
	* @param	endLineGap
	*/
	private function alignText(textFieldArray:Array,buttonArray:Array,endLineGap:Number):Void
	{
		var tGapPerWord:Number=endLineGap/textFieldArray.length;
		//_currentTextFormat.align="center";
		var tInitialTextFormat:TextFormat=_paragraphsAsWords[0][0].textFormat;	
		
		tInitialTextFormat.align="justify";
		switch (tInitialTextFormat.align)
		{
			case "left":
				// Do nothing
				break;
			case "center":
				for (var i:Number=0;i<textFieldArray.length;i++) textFieldArray[i]._x+=endLineGap/2;
				 break;							 
			case "right":
				for (var i:Number=0;i<textFieldArray.length;i++) textFieldArray[i]._x+=endLineGap;
				break;
			case "justify":
				for (var i:Number=0;i<textFieldArray.length;i++) textFieldArray[i]._x+=tGapPerWord*i;			
				break;
		}
		for (var i in buttonArray)
		{
			buttonArray[i]._x=buttonArray[i].assignedTextField._x;
		}
	}
	
	/**
	* Fill a rect with segments 
	* @param	tRect	The rect to fill
	* @return			An array of created segments
	*/
	private function segmentsFromRect(tRect:rect):Array
	{
		var segmentsArray=new Array();
		
		var tx:Number=tRect.x;
		var ty:Number=tRect.y;
						
		var tWidth=tRect.width;
		var tHeight=tRect.height
		
		var tRows=Math.floor(tRect.height/rowHeight);
		
		var tTextHeight=_currentTextFormat.size;
		
		for (var i:Number=0;i<tRows;i++)
		{			
			var recty=ty+i*rowHeight;			
			var tSegmentRect=new rect(tx,recty,tx+tWidth,recty+tTextHeight);
			segmentsArray.push(tSegmentRect);			
		}
				
		return segmentsArray;
	}
	
	/**
	* Fill a circle with segments
	* @param	tCircle	The circle to fill
	* @return			An array of created segments	
	*/
	private function segmentsFromCircle(tCircle:circle):Array
	{
		//trace("Circle");
		var segmentsArray=new Array();
		// Lets cycle through and create all the rectangles.
		var tx=tCircle.pos.x-tCircle.radius;
		var ty=tCircle.pos.y-tCircle.radius;
		
		var tWidth=tCircle.radius*2;
		var tHeight=tCircle.radius*2;
		
		var tRows=Math.floor(tHeight/rowHeight);
		var tTextHeight=_currentTextFormat.size;
		
		for (var i:Number=0;i<tRows;i++)
		{			
			ty=tCircle.pos.y-tCircle.radius+i*rowHeight;
			
			var tCircleTestY=ty;
			// We need to find the max width between the top and bottom of the rect
			// Hence if we are in the lower half of the circle, add on the textHeight
			
			if (i*rowHeight>tCircle.radius) tCircleTestY+=tTextHeight;
			var tXPosArray=tCircle.solveForY(tCircleTestY);
			//trace("X intersections "+tXPosArray[0]+","+tXPosArray[1]);
			//var tRect:rect=rect.fromDimensions(tx,ty,tWidth,tTextHeight);
			var tRect=new rect(tXPosArray[0],ty,tXPosArray[1],ty+tTextHeight);
			segmentsArray.push(tRect);			
		}
		//trace("returning segments "+segmentsArray.length);
		return segmentsArray;
	}
	
	
	/**
	* Debug function. Renders the segments
	* @param	segmentsArray
	*/
	function debugDrawSegments(segmentsArray:Array)
	{
		var greyFill:fillStyleFormat=new fillStyleFormat(0xCCCCCC, 100);
		trace("Drawing segments "+segmentsArray.length);
		for (var i=0;i<segmentsArray.length;i++) drawingUtility.drawRect(_movieClip,segmentsArray[i],null,greyFill);
	}
	
	
	function nextPage(Void):Void
	{
		
	}
	function previousPage(Void):Void
	{
		
	}
	function jumpToPage(index:Number):Void
	{
		
	}
	/** 
	* Clears all rendered elements and resets the system
	*/
	function clear():Void
	{
		_movieClip.clear();
		for (var i:Number=0;i<_activeTextFields.length;i++)
		{
			_activeTextFields[i].removeTextField();
		}
		_currentParagraphIndex=0;
		_currentWordIndex=0;
	}
		
	
}


