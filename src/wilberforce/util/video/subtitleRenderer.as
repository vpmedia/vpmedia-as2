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
 
import wilberforce.dataProviders.srtSubtitleDataProvider ;

/**
* Renders subtitles onto a Video. Subtitles are provided by wilberforce.dataProviders.srtSubtitleDataProvider . 
* TODO - Port to use com.bourre.medias.video.VideoDisplay from pixlib
*/
class wilberforce.util.video.subtitleRenderer {
	
	var srtLoader;
	var ownerClip:MovieClip;
	
	var currentTime;
	var currentSubtitleIndex:Number;
	
	var currentSubtitleObject;
	var nextSubtitleObject;
	
	var loaded;
	var currentSubtitlePassed:Boolean;
	
	var renderClip:MovieClip;

	var defaultSubtitleTextformat:TextFormat;
	var defaultSubtitleBackgroundTextformat:TextFormat;
	
	var width:Number;
	var height:Number;
	 
	var fontSize:Number; 
	
	var backgroundOutlineSpacing:Number;
	
	var spacingFromBottom:Number;
	
	function subtitleRenderer(tMovieClip:MovieClip,tWidth:Number,tHeight:Number) {
		ownerClip=tMovieClip;
		srtLoader=new srtSubtitleDataProvider();
		srtLoader.addListener(this);
		currentSubtitleIndex=0;
		currentSubtitlePassed=false;
		
		renderClip=ownerClip.createEmptyMovieClip("subtitle",ownerClip.getNextHighestDepth());
		
		width=tWidth;
		height=tHeight;
		
		fontSize=22;
		
		backgroundOutlineSpacing=2;
		spacingFromBottom=7;
		
		// Define subtitle style
		defaultSubtitleTextformat=new TextFormat("_sans",fontSize,0xFFFFFF,true,false,false,null,null,null);
		defaultSubtitleBackgroundTextformat=new TextFormat("_sans",fontSize,0x000000,true,false,false,null,null,null);
	}
	
	function load(tUrl:String) {
		srtLoader.load(tUrl);
	}
	
	function dataLoaded() {
		loaded=true;
		trace("data loaded");
		
		currentTime=0;
		currentSubtitleIndex=0;
		
		// Set up the first and next object
		setupSubtitleObjects();
	}
	
	function setupSubtitleObjects() {
		//if (currentSubtitleIndex==-1) return;
		currentSubtitleObject=srtLoader.getSubtitle(currentSubtitleIndex);
		nextSubtitleObject=srtLoader.getSubtitle(currentSubtitleIndex+1);
		
		if (currentTime>currentSubtitleObject.end) currentSubtitlePassed=true;
		else currentSubtitlePassed=false;
		
		
		
		
		// If necessary, render
		if (!currentSubtitlePassed) {
			displayCurrentSubtitle();
		}
		else {
			removeCurrentSubtitle();
		}
		// If we are still waiting for the first subtitle, remove it
		if (currentTime<currentSubtitleObject.start) removeCurrentSubtitle();
	}
	
	

	
	function setTime(tSeconds:Number) {
		//trace("Setting time to "+tSeconds)
		currentTime=tSeconds;
		var currentSubtitleSearchResult=srtLoader.findIndexAtTime(tSeconds);
		currentSubtitleIndex=currentSubtitleSearchResult.index;
		currentSubtitlePassed=!currentSubtitleSearchResult.within;
		setupSubtitleObjects();
	}
	
	function increment(tSeconds) {
		currentTime+=tSeconds;
		if (tSeconds==0) return;
		//trace("time "+currentTime)
		// Have we reached the beginning of the next subtitle?
		if (currentTime>nextSubtitleObject.start) { 
			//if (currentTime>nextSubtitleObject.end) currentSubtitlePassed=true;
			//else currentSubtitlePassed=false;
			currentSubtitleIndex++;
			
			setupSubtitleObjects();
			return;
		}
		
		if (currentTime>currentSubtitleObject.end && !currentSubtitlePassed) {
			currentSubtitlePassed=true;
			
		}
	}
	
	function displayCurrentSubtitle() {
		//Remove existing subtitle
		removeCurrentSubtitle();
		
		if (currentTime<currentSubtitleObject.start) return;
		var tText=currentSubtitleObject.text;
		//trace("adding -> "+tText)
		var tx=0;
		var ty=0;
		
		//TOP ROW
		createTextField(renderClip,tx-backgroundOutlineSpacing,ty-backgroundOutlineSpacing,width,height,tText,1,true,defaultSubtitleBackgroundTextformat,false);
		createTextField(renderClip,tx,ty-backgroundOutlineSpacing,width,height,tText,1,true,defaultSubtitleBackgroundTextformat,false);
		createTextField(renderClip,tx+backgroundOutlineSpacing,ty-backgroundOutlineSpacing,width,height,tText,1,true,defaultSubtitleBackgroundTextformat,false);
		// MIDDLE
		createTextField(renderClip,tx-backgroundOutlineSpacing,ty,width,height,tText,1,true,defaultSubtitleBackgroundTextformat,false);
		createTextField(renderClip,tx,ty,width,height,tText,1,true,defaultSubtitleBackgroundTextformat,false);
		createTextField(renderClip,tx+backgroundOutlineSpacing,ty,width,height,tText,1,true,defaultSubtitleBackgroundTextformat,false);
		
		//BOTTOM ROW
		createTextField(renderClip,tx+backgroundOutlineSpacing,ty+backgroundOutlineSpacing,width,height,tText,1,true,defaultSubtitleBackgroundTextformat,false);
		createTextField(renderClip,tx,ty+backgroundOutlineSpacing,width,height,tText,1,true,defaultSubtitleBackgroundTextformat,false);
		createTextField(renderClip,tx-backgroundOutlineSpacing,ty+backgroundOutlineSpacing,width,height,tText,1,true,defaultSubtitleBackgroundTextformat,false);
		
		var tCreationData=createTextField(renderClip,tx,ty,width,height,tText,1,true,defaultSubtitleTextformat,false);
		
		// Change the position so that it aligns to the bottom
		renderClip._y=-tCreationData.height-spacingFromBottom;
	}
	
	
	function removeCurrentSubtitle() {
		for (var i in renderClip) {
			renderClip[i].removeTextField()
		}
	}
	
	public static function createTextField(tHolderClip,tx,ty,tWidth,tHeight,tText,tDepth,tCentered:Boolean,tTextFormat,tNoMultiline:Boolean) {
		//trace("Holder clip "+tHolderClip)
		
		var tDepth=tHolderClip.getNextHighestDepth();
		var tName="tfield"+tDepth;
		//if (tTextFormat==undefined) tTextFormat=defaultSubtitleTextformat;
		tHolderClip.createTextField(tName,tDepth,tx,ty,tWidth,tHeight);
		//trace("ADDING "+tPanelDataObject.title+" at "+tTextFieldPlacementX+","+tObjectPlacementY+" thumb "+tPanelDataObject.thumbnail)
		var tTextField=tHolderClip[tName];
		
		//trace("Text format is "+tTextFormat)
		
		if (tCentered) tTextFormat.align="center"
		else tTextFormat.align="left"																				
		
		if (!tNoMultiline) tTextField.wordWrap=true;
		tTextField.embedFonts=true;
		tTextField.selectable=false;
		tTextField.html=true
					
		
		// Assign the title
		tTextField.htmlText=tText;
		
		tTextField.setTextFormat(tTextFormat);
		
		
		
		tTextField._height=5+tTextField.textHeight;
		if (!tCentered) tTextField._width=5+tTextField.textWidth;
		
		var tTextHeight=tTextField.textHeight
		var tTextWidth=tTextField.textWidth
		//trace("Added "+tText+" - "+tTextHeight)
		var tCreationData={height:tTextHeight,textfield:tTextField,width:tTextWidth}
		return tCreationData;
	}
	
	
}