/**
 * This code is free for any use. Please feel free to modify it if you improve it.
 * @author Martin Wood
 */
class Paginator {
	private var pages:Array;
	private var textBox:TextField;
	private var fullText:String;
	private var words:Array;
	private var currentWordIndex:Number;
	private var startIndex:Number;
	private var endIndex:Number;
	private var currentPage:Number;
	public function Paginator () {
		reset ();
	}
	private function reset ():Void {
		pages = [];
		currentWordIndex = 0;
		startIndex = 0;
		endIndex = 0;
		currentPage = 0;
	}
	public function getNumberOfPages ():Number {
		return pages.length - 1;
	}
	public function getPage (index:Number):String {
		if (index < pages.length) {
			return pages[index];
		}
		else {
			return "";
		}
	}
	public function createPages (text:String, tb:TextField):Array {
		reset ();
		fullText = text;
		textBox = tb;
		// clear text box
		textBox.text = "";
		createWordList ();
		// Create local variables here so we dont re-create them in the loop.
		var word:String = "";
		var firstWord:String = "";
		while (currentWordIndex < words.length) {
			textBox.text = "";
			// remove any blanks at start of page
			removeBlankWords ();
			// remove and whitespace that is part of the first word
			words[currentWordIndex] = stripLeadingWhitespace (words[currentWordIndex]);
			// keep adding words until we need to scroll.
			while (textBox.maxscroll == 1 && currentWordIndex < words.length) {
				textBox.text += words[currentWordIndex] + " ";
				currentWordIndex++;
			}
			// see if last word is two words with just newlines inbetween
			checkLastWord ();
			// update end index
			if (currentWordIndex < words.length - 1) {
				endIndex = currentWordIndex - 1;
			}
			else {
				endIndex = currentWordIndex;
			}
			// create text for page and increment page counter
			pages[currentPage++] = words.slice (startIndex, endIndex).join (" ");
			// move start index to current end
			startIndex = endIndex;
		}
		return pages;
	}
	private function removeBlankWords ():Void {
		// assume we have blank words
		var isWhitespace:Boolean = true;
		var word:String = "";
		while (isWhitespace && currentWordIndex < words.length) {
			word = words[currentWordIndex];
			if (word == "\r") {
				// Just a newline char, so move forwards.
				currentWordIndex++;
			}
			else {
				// its a normal word, so start here.
				isWhitespace = false;
				// if its not the first word in the document we need
				// to step backwards one word
				if (currentWordIndex > 0) {
					currentWordIndex--;
				}
			}
		}
	}
	private function stripLeadingWhitespace (text:String):String {
		var result:String = text;
		for (var n:Number = 0; n < text.length; n++) {
			if (text.charAt (n) != "\r") {
				return result;
			}
			else {
				result = text.substring (n, text.length);
			}
		}
		return result;
	}
	private function stripTrailingWhitespace (text:String):String {
		var result:String = text;
		for (var n:Number = text.length - 1; n >= 0; n--) {
			if (text.charAt (n) != "\r") {
				return result;
			}
			else {
				result = text.substring (0, n);
			}
		}
		return result;
	}
	private function checkLastWord ():Void {
		// check if the last word that doesnt fit has a newline at the end
		// if it does, see if it will on the current page without the newline.
		// test last word
		var lastWord:String = words[currentWordIndex - 1];
		var nlIndex:Number = lastWord.lastIndexOf ("\r", lastWord.length);
		// if there is a newline which isnt the last char of the word
		if (nlIndex != -1 && (nlIndex != (lastWord.length - 1))) {
			var remainingText:String = lastWord.substring (nlIndex + 1, lastWord.length);
			lastWord = lastWord.substring (0, nlIndex);
			lastWord = stripTrailingWhitespace (lastWord);
			// fill text box again
			textBox.text = words.slice (startIndex, currentWordIndex - 1).join (" ");
			textBox.text += " " + lastWord;
			// if the text still fits, bring the last word into this page
			if (textBox.maxscroll == 1) {
				words[currentWordIndex - 1] = lastWord;
				// and check if the piece after this word contains text.
				if (remainingText.length > 1) {
					// insert remaining as new word
					var front:Array = words.slice (0, currentWordIndex);
					var back:Array = words.slice (currentWordIndex, words.length);
					front.push (remainingText);
					words = front.concat (back);
					currentWordIndex = front.length - 1;
				}
				else {
					// include last word
					currentWordIndex++;
				}
			}
			else {
				currentWordIndex--;
			}
		}
	}
	private function createWordList ():Void {
		// collapse windows newlines into flash player style (same as old mac)
		fullText = fullText.split ("\r\n").join ("\r");
		fullText = fullText.split ("\n").join ("\r");
		words = fullText.split (" ");
	}
}
