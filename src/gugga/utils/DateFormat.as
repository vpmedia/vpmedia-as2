/**
 * @author Todor Kolev
 */
class gugga.utils.DateFormat 
{
	/* 
	Darron Schall (darron@alumni.lehigh.edu)
	August 27, 2003
	
	ActionScript port of ColdFusion's DateFormat function.  
	
	@param theDate - a Flash Date Object
	@param format - see http://livedocs.macromedia.com/coldfusion/6.1/htmldocs/functi59.htm for more information on valid formats
	
	Revision History:
	Rev Date		Who		Description
	1.0 8/27/03		darron	Initial Release
	
	--------------------------------------
	License For Use
	--------------------------------------
	Redistribution and use in source and binary forms, with or without modification,
	are permitted provided that the following conditions are met:
	
	1. Redistributions of source code must retain the above copyright notice, this
	list of conditions and the following disclaimer.
	
	2. Redistributions in binary form must reproduce the above copyright notice,
	this list of conditions and the following disclaimer in the documentation
	and/or other materials provided with the distribution.
	
	3. The name of the author may not be used to endorse or promote products derived
	from this software without specific prior written permission.
	
	THIS SOFTWARE IS PROVIDED BY THE AUTHOR "AS IS" AND ANY EXPRESS OR IMPLIED
	WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
	MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
	EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
	EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT
	OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
	INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
	CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
	IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY
	OF SUCH DAMAGE.
	*/
	public static function format(theDate:Date, format:String) : String 
	{
		/*
		if (!(theDate instanceof Date)) {
			trace("Error in dateFormat - first parameter must be a date object");
			return;
		}
		*/
		
		var months = {};
		months["Jan"] = {m:1, n:"January"};
		months["Feb"] = {m:2, n:"February"};
		months["Mar"] = {m:3, n:"March"};
		months["Apr"] = {m:4, n:"April"};
		months["May"] = {m:5, n:"May"};
		months["Jun"] = {m:6, n:"June"};
		months["Jul"] = {m:7, n:"July"};
		months["Aug"] = {m:8, n:"August"};
		months["Sep"] = {m:9, n:"September"};
		months["Oct"] = {m:10, n:"October"};
		months["Nov"] = {m:11, n:"November"};
		months["Dec"] = {m:12, n:"December"};
		var days = {};
		days["Sun"] = {m:1, n:"Sunday"};
		days["Mon"] = {m:1, n:"Monday"};
		days["Tue"] = {m:1, n:"Tuesday"};
		days["Wed"] = {m:1, n:"Wednesday"};
		days["Thu"] = {m:1, n:"Thursday"};
		days["Fri"] = {m:1, n:"Friday"};
		days["Sat"] = {m:1, n:"Saturday"};
		
		var parts = theDate.toString().split(" ");
		var dayOfWeek = parts[0];
		var month = parts[1];
		var day = parts[2];
		var year = parts[5];
		
		var retString = "";
			
		// search for the mask words and replace with the appropriate mask
		if (format.indexOf("short") != -1) {
			format = format.split("short").join("m/d/y");
		} else if (format.indexOf("medium") != -1) {
			format = format.split("medium").join("mmm d, yyyy");
		} else if (format.indexOf("long") != -1) {
			format = format.split("long").join("mmmm d, yyyy");
		} else if (format.indexOf("full") != -1) {
			format = format.split("full").join("dddd, mmmm d, yyyy");
		}
		
		
		// used to store what character set we're processing
		var currentlyProcessing = '';
		// how many of the characters have we run into?
		var count = 0;
		
		// loop through the format and replace values when we can
		for (var i = 0; i < format.length; i++) {
			switch (format.charAt(i)) {
				case 'd':
				case 'm':
				case 'y':
					// if we've been processing one set of characters and
					// stumbled across a new set, we need to update
					// the return string
					if (currentlyProcessing != '') {
						if (currentlyProcessing != format.charAt(i)) {
							// processing a new character, so figure out what we've 
							// been processing, update the processing character,
							// and re-set the count
							retString += maskReplace(currentlyProcessing, count, dayOfWeek, month, day, year, months, days);
							currentlyProcessing = format.charAt(i);
							count = 0;
						} 
					} else {
						currentlyProcessing = format.charAt(i);	
					}
					count++;
					break;
					
				default:
					// we're stumbled upong a character thats not a mask character
					// so if we've been processing something, replace it
					// for the return string and reset what we've processing
					// to nothing
					if (currentlyProcessing != '') {
						retString += maskReplace(currentlyProcessing, count, dayOfWeek, month, day, year, months, days);
						count = 0;
						currentlyProcessing = '';
					}
					// just add the character we've run into to the return string
					retString += format.charAt(i);
			}
		}
		
		// after we're done, we need to check to see if we're still processing anything
		if (count > 0) {
			retString += maskReplace(currentlyProcessing, count, dayOfWeek, month, day, year, months, days);
		}
		
		// finally, return the string with the mask replace with actual values
		return retString;	
	}
	
	/*
	Darron Schall
	August 27, 2003
	
	Private "helper" function for dateFormat. Not meant to be called directly.
	*/
	private static function maskReplace(which, count, dayOfWeek, month, day, year, months, days) {
		switch(which) {
			case 'd':
				switch (count) {
					case 1: return day;
					case 2: return (day<10) ? "0"+day : day;
					case 3: return dayOfWeek;
					case 4: return days[dayOfWeek].n;
				}
				break;
			case 'y':
				switch (count) {
					case 1: return parseInt(year.substr(2,2));
					case 2: return year.substr(2, 2);
					case 4: return year;
				}
			
			case 'm':
				switch (count) {
					case 1: return months[month].m;
					case 2: return (months[month].m<10) ? "0"+months[month].m : months[month].m;
					case 3: return month;
					case 4: return months[month].n;
				}
		}
	}
}