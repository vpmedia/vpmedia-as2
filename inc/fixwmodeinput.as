/*
 * ClassName: fixwmodeinput.as - Do not copy or modify this code without the authors permission!
*/
/**
 * <p>Description: Hungarian Character InputText bug-fix for transparent wmode</p>
 *
 * @author András Csizmadia
 * @version 1.0
 * @player availability Flash 6,7,8b
 * @browser compatibility Internet Explorer 6, Mozilla Firefox 1.06
 * @os compatibility Windows 2000, Windows XP SP1, SP2
 * @platform compatibility just tested on pc!
 * @last nodified 2005.08.28.
 * @comments more compatibility tests...
 */
trace ("#fixwmodeinput.as loaded.");
/**
 * FUNCTION:  fixHunInputChar 
 *
 * function fixes wmode transparent bug if key 'õ' or 'û' typed into a TextBox.
 *
 * @param   __textBox   InputText   ** TextBox reference
 *
**/
MovieClip.prototype.fixHunInputChar = function (__textBox,__isHtmlText)
{
	//trace ("** fixHunInputChar **");
	//219->õ
	if(!isHtmlText){
		isHtmlText=false;
	}
	if (Key.getCode () == 219)
	{
		//16-> SHIFT; 20-> CAPS LOCK
		if (Key.isDown (16) || Key.isToggled (20))
		{
			__textBox.text = replaceCharFromText (__textBox.text, "Õ");
		}
		else
		{
			__textBox.text = replaceCharFromText (__textBox.text, "õ");
		}
	}
	//220->û
	if (Key.getCode () == 220)
	{
		if (Key.isDown (16) || Key.isToggled (20))
		{
			__textBox.text = replaceCharFromText (__textBox.text, "Û");
		}
		else
		{
			__textBox.text = replaceCharFromText (__textBox.text, "û");
		}
	}
}
ASSetPropFlag (MovieClip.prototype, "fixHunInputChar", 1);
/**
 * FUNCTION:  replaceCharFromText 
 *
 * function replaces a Char from a String
 *
 * @param   __txt   String   ** text source to replace
 * @param   __char   String   ** a char to be replaced
 *
**/
MovieClip.prototype.replaceCharFromText = function(__txt, __char)
{
	//trace ("** replaceCharFromText **");
	var startIndex:Number = Selection.getBeginIndex ();
	var endIndex:Number = Selection.getEndIndex ();
	var __tmpstr = __txt;
	var __str = __tmpstr.substr (0, startIndex - 1);
	__str += __char;
	__str += __tmpstr.substr (startIndex);
	return __str;
}
ASSetPropFlag (MovieClip.prototype, "replaceCharFromText", 1);