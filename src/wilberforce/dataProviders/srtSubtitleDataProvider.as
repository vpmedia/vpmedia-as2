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
 
/**
* Reads and parses a "SubRip" .srt subtitle file, for use with the video subtitling component
* More information about SubRip is available here: http://en.wikipedia.org/wiki/SubRip
*/
class wilberforce.dataProviders.srtSubtitleDataProvider {
	
	var sourceXML:XML;
	var subtitleArray:Array;
	var totalLength:Number;
	
	var listeningObjects:Array;
	var startTime;
	
	function srtSubtitleDataProvider() {
		sourceXML=new XML();
		var _instance=this;
		listeningObjects=[];
		sourceXML.onData=function(src:String) {
			//trace("Loaded data :"+src)
			_instance.parseSrt(src);
		}
	}
	function load(tUrl:String) {
		sourceXML.load(tUrl);
		
	}
	function addListener(tObject) {
		listeningObjects.push(tObject);
	}
	function parseSrt(src:String) {
		var tLineSplit=src.split("\n");
		trace("Total lines "+tLineSplit.length);
		
		var currentPosition=0;
		subtitleArray=[];
		var currentText="";
		var currentStartTime;
		var currentEndTime;
		
		startTime=100000;
		for (var i=0;i<tLineSplit.length;i++) {
			var tLine=tLineSplit[i];
			tLine=replaceText(tLine,"\r","")
			//trace("Line:"+tLine+"*")
			var tIndex=parseInt(tLine);
			var tArrowPosition=tLine.indexOf(" --> ");
			
			// Is it a number?
			if (!isNaN(tIndex) && tIndex>0 && !(tArrowPosition>0)) {
				//trace("Found number "+tIndex)
				// Add the previous subtitle entry
				if (currentPosition>0) {
					var tSubtitleObject={};
					tSubtitleObject={text:currentText,start:currentStartTime,end:currentEndTime};
					subtitleArray.push(tSubtitleObject);
					trace("added "+currentPosition+" from "+currentStartTime+" to "+currentEndTime+" - "+currentText)
					
					// Empty up the currenttext
					currentText="";
				}
				currentPosition=tIndex;
			}
			else if (tArrowPosition>0) {				
				// Is it a time signiture?
				var tTimeSplit=tLine.split(" --> ");		
				//trace("Time found :"+tTimeSplit[0]+"...."+tTimeSplit[1]);
				currentStartTime= processTime(tTimeSplit[0]);
				if (currentStartTime<startTime) startTime=currentStartTime;
				currentEndTime= processTime(tTimeSplit[1]);
				
				// Mark the last time in the sequence
				totalLength=currentEndTime;
			}
			else {
				//trace("Length of line "+tLine.length)
				if (tLine.length>0) currentText+=tLine+"\n";
			}
		}
		// Add the final subtitle object
		tSubtitleObject={text:currentText,start:currentStartTime,end:currentEndTime};
		// Mark the last time in the sequence
		totalLength=currentEndTime;
		subtitleArray.push(tSubtitleObject);
		
		trace("total length is "+totalLength);
		// Add on a beginning object that is empty
		if (startTime!=0) {
			var tStartSubtitleObject={text:"",start:0,end:startTime};
			subtitleArray.unshift(tStartSubtitleObject)
		}
		// Add and end object that is empty
		var tEndSubtitleObject={text:"",start:totalLength,end:99999};
		subtitleArray.push(tEndSubtitleObject)
		
		for (var i in listeningObjects) listeningObjects[i].dataLoaded();
	}
	/** Parses an srt file into a number of seconds */
	function processTime(tTimeString:String) {
		var tTimeElementSplit=tTimeString.split(":");
		//00:00:14,074
		var tHours:Number=parseInt(tTimeElementSplit[0]);
		var tMinutes:Number=parseInt(tTimeElementSplit[1]);
		var tSecondsString=replaceText(tTimeElementSplit[2],",",".")
		var tSeconds:Number = parseFloat(tSecondsString);
		tMinutes+=tHours*60;
		tSeconds+=tMinutes*60;
		return tSeconds;
	}
	
	
	static public function replaceText(tString,tPat1,tPat2) {
		var tSplit=tString.split(tPat1)
		var tNewText="";
		for (var i=0;i<tSplit.length;i++) {
			tNewText+=tSplit[i];//+"</p> <br/>";
			if (i<(tSplit.length-1)) {
				tNewText+=tPat2;
			}
		}
		return tNewText;
	}
	
	function getSubtitle(tIndex:Number) {
		
		if (tIndex>=subtitleArray.length || tIndex<0) return -1;
		return subtitleArray[tIndex];
	}
	
	function findIndexAtTime(tSeconds:Number) {
		
		// If its before we begin, return -1
		//if (startTime>tSeconds) return {index:-1,within:false};
		// Jump into a proportional position as a start estimate
		var tPercentThrough=tSeconds/totalLength;
		var tTestIndex=Math.round(tPercentThrough*subtitleArray.length);
		if (tTestIndex>=subtitleArray.length) tTestIndex=subtitleArray.length-1
		var tSearchDirection=relativeTime(tTestIndex,tSeconds);
		if (tSearchDirection==0) return {index:tTestIndex,within:true};
		
		var objectFound:Boolean=false;
		while (!objectFound && tTestIndex>0 && tTestIndex<subtitleArray.length) {
			tTestIndex-=tSearchDirection;
			var tTimeTest=relativeTime(tTestIndex,tSeconds);
			
			//trace("Result is "+tTimeTest)
			if (tTimeTest==0) return {index:tTestIndex,within:true};
			if (tTimeTest!=tSearchDirection) {
				// The Item is within a gap
				
				
				// If we are searching forward, reduce the index by one to show that we are in the gap of the previous item
				
				if (tSearchDirection==-1) tTestIndex--;
				return {index:tTestIndex,within:false};
			} 
		}
		
		// Not found		
		return {index:-1,within:false};
		
	}
	
	function relativeTime(tIndex:Number,tSeconds) {
		
		var tSubtitleObject=subtitleArray[tIndex];
		//trace("Testing "+tIndex+" "+tSubtitleObject.start+"->"+tSubtitleObject.end)
		// If the object comes after the passed time
		if (tSeconds<tSubtitleObject.start) return 1;
		// If the object comes before the passed time
		if (tSeconds>tSubtitleObject.end) return -1;
		
		// Must be within
		return 0;
		
	}
	
}