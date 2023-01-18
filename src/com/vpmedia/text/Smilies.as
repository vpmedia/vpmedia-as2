// Implementations
import mx.events.EventDispatcher;
import mx.utils.Delegate;
// Define Class
class com.vpmedia.text.Smilies
{
	// START CLASS
	public var className:String = "Smilies";
	public static var version:String = "0.0.1";
	// EventDispatcher
	public var addEventListener:Function;
	public var removeEventListener:Function;
	public var dispatchEvent:Function;
	public var dispatchQueue:Function;
	// Constructor
	function Smilies ()
	{
		EventDispatcher.initialize (this);
	}
	// Get version
	public function toString ():String
	{
		return ("[" + className + "]");
	}
	public static function setOutput (__target:Object):Void
	{
		//var my_fmt:TextFormat = new TextFormat ();
		var my_fmt:TextFormat = __target.getTextFormat ();
		for (var prop in my_fmt)
		{
			trace (prop + ": " + my_fmt[prop]);
		}
		my_fmt.font = "Smilies";
		__target.embedFonts = true;
		__target.setTextFormat (my_fmt);
	}
	public static function getSmilies ():Array
	{
		var smilie_arr = new Array ();
		smilie_arr.push (":P");
		smilie_arr.push (":)");
		smilie_arr.push (":]");
		smilie_arr.push (":amused:");
		smilie_arr.push (":whistle:");
		smilie_arr.push (":dialog:");
		smilie_arr.push (":heart:");
		smilie_arr.push ("xxx");
		smilie_arr.push (":D");
		smilie_arr.push (";)");
		smilie_arr.push (":wink:");
		smilie_arr.push (":baby:");
		smilie_arr.push (":evil:");
		smilie_arr.push (":devil:");
		smilie_arr.push (":satan:");
		smilie_arr.push (":whatever:");
		smilie_arr.push (":hmmm:");
		smilie_arr.push (":neutral:");
		smilie_arr.push (":|");
		smilie_arr.push (":(");
		smilie_arr.push ("=(");
		smilie_arr.push (":cool:");
		smilie_arr.push (":2cool:");
		smilie_arr.push (":whoa:");
		smilie_arr.push (":ninja:");
		smilie_arr.push (":pissed:");
		smilie_arr.push (":sleeze:");
		smilie_arr.push (":innocent:");
		smilie_arr.push (":info:");
		smilie_arr.push (":link:");
		smilie_arr.push (":unshaven:");
		smilie_arr.push (":restricted:");
		smilie_arr.push (":warning:");
		smilie_arr.push (":exclamation:");
		smilie_arr.push (":help:");
		smilie_arr.push (":back:");
		smilie_arr.push (":at:");
		smilie_arr.push (":back2:");
		smilie_arr.push (":webcam:");
		smilie_arr.push (":email:");
		smilie_arr.push (":sync:");
		smilie_arr.push (":flame:");
		smilie_arr.push (":O");
		smilie_arr.push (":stamp:");
		smilie_arr.push (":stream:");
		smilie_arr.push (":bliss:");
		smilie_arr.push (":yawn:");
		smilie_arr.push (":sick:");
		smilie_arr.push (":jealous:");
		smilie_arr.push (":download:");
		smilie_arr.push (":flammable:");
		smilie_arr.push ("lol");
		smilie_arr.push ("LOL");
		smilie_arr.push (":postit:");
		return smilie_arr;
	}
	public static function getMessage (__mess:String):String
	{
		var sendMesg = __mess;
		sendMesg = sendMesg.split (":P").join ("<FONT FACE='Smilies' SIZE='20'><FONT COLOR='#DEA701'>&nbsp;A</FONT><FONT COLOR='#F2D300'>C</FONT><FONT COLOR='#FEEE00'>D</FONT><FONT COLOR='#FFF9AE'>B</FONT><FONT COLOR='#330000'>zI¶</FONT><FONT COLOR='#FF0000'>•&nbsp;</FONT></FONT>");
		sendMesg = sendMesg.split (":)").join ("<FONT FACE='Smilies' SIZE='20'><FONT COLOR='#DEA701'>&nbsp;A</FONT><FONT COLOR='#F2D300'>C</FONT><FONT COLOR='#FEEE00'>D</FONT><FONT COLOR='#FFF9AE'>B</FONT><FONT COLOR='#330000'>zIR&nbsp;</FONT></FONT>");
		sendMesg = sendMesg.split (":]").join ("<FONT FACE='Smilies' SIZE='20'><FONT COLOR='#DEA701'>&nbsp;A</FONT><FONT COLOR='#F2D300'>C</FONT><FONT COLOR='#FEEE00'>D</FONT><FONT COLOR='#FFF9AE'>B</FONT><FONT COLOR='#330000'>zIJ&nbsp;</FONT></FONT>");
		sendMesg = sendMesg.split (":amused:").join ("<FONT FACE='Smilies' SIZE='20'><FONT COLOR='#DEA701'>&nbsp;A</FONT><FONT COLOR='#F2D300'>C</FONT><FONT COLOR='#FEEE00'>D</FONT><FONT COLOR='#FFF9AE'>B</FONT><FONT COLOR='#330000'>zQR&nbsp;</FONT></FONT>");
		sendMesg = sendMesg.split (":whistle:").join ("<FONT FACE='Smilies' SIZE='20'><FONT COLOR='#2E0101'>&nbsp;Z</FONT><FONT COLOR='#DEA701'>A</FONT><FONT COLOR='#330001'>z</FONT><FONT COLOR='#F2D300'>C</FONT><FONT COLOR='#FEEE01'>D</FONT><FONT COLOR='#FBEC0B'>0</FONT><FONT COLOR='#060606'>1</FONT><FONT COLOR='#FDFDFA'>u</FONT><FONT COLOR='#010201'>v</FONT><FONT COLOR='#0E0E03'>t</FONT><FONT COLOR='#F70606'>2</FONT><FONT COLOR='#349504'>3&nbsp;&nbsp;</FONT></FONT>");
		sendMesg = sendMesg.split (":dialog:").join ("<FONT FACE='Smilies' SIZE='20'><FONT COLOR='#FDE200'>&nbsp;b</FONT><FONT COLOR='#101010'>a</FONT><FONT COLOR='#FFFFCC'>B&nbsp;</FONT></FONT>");
		sendMesg = sendMesg.split (":heart:").join ("<FONT FACE='Smilies' SIZE='20'><FONT COLOR='#330000'>&nbsp;p</FONT><FONT COLOR='#FF3333'>q</FONT><FONT COLOR='#FF9999'>r</FONT><FONT COLOR='#FFCCCC'>s&nbsp;</FONT></FONT>");
		sendMesg = sendMesg.split ("xxx").join ("<FONT FACE='Smilies' SIZE='20'><FONT COLOR='#330000'>&nbsp;p</FONT><FONT COLOR='#FF3333'>q</FONT><FONT COLOR='#FF9999'>r</FONT><FONT COLOR='#FFCCCC'>s&nbsp;</FONT></FONT>");
		sendMesg = sendMesg.split (":D").join ("<FONT FACE='Smilies' SIZE='20'><FONT COLOR='#DEA701'>&nbsp;A</FONT><FONT COLOR='#F2D300'>C</FONT><FONT COLOR='#FEEE00'>D</FONT><FONT COLOR='#FFF9AE'>B</FONT><FONT COLOR='#330000'>z</FONT><FONT COLOR='#0C0901'>I</FONT><FONT COLOR='#0C0902'>O</FONT><FONT COLOR='#FCFCFC'>P&nbsp;</FONT></FONT>");
		sendMesg = sendMesg.split (";)").join ("<FONT FACE='Smilies' SIZE='20'><FONT COLOR='#DEA701'>&nbsp;A</FONT><FONT COLOR='#F2D300'>C</FONT><FONT COLOR='#FEEE00'>D</FONT><FONT COLOR='#FFF9AE'>B</FONT><FONT COLOR='#330000'>z</FONT><FONT COLOR='#080401'>N</FONT><FONT COLOR='#080402'>R&nbsp;</FONT></FONT>");
		sendMesg = sendMesg.split (":wink:").join ("<FONT FACE='Smilies' SIZE='20'><FONT COLOR='#DEA701'>&nbsp;A</FONT><FONT COLOR='#F2D300'>C</FONT><FONT COLOR='#FEEE00'>D</FONT><FONT COLOR='#FFF9AE'>B</FONT><FONT COLOR='#330000'>z</FONT><FONT COLOR='#0F0701'>N</FONT><FONT COLOR='#0F0702'>M&nbsp;</FONT></FONT>");
		sendMesg = sendMesg.split (":baby:").join ("<FONT FACE='Smilies' SIZE='20'><FONT COLOR='#DEA701'>&nbsp;A</FONT><FONT COLOR='#F2D300'>C</FONT><FONT COLOR='#FEEE00'>D</FONT><FONT COLOR='#FFF9AE'>B</FONT><FONT COLOR='#330000'>z</FONT><FONT COLOR='#333399'>`</FONT><FONT COLOR='#FF33CC'>T</FONT><FONT COLOR='#3333CC'>U&nbsp;</FONT></FONT>");
		sendMesg = sendMesg.split (":evil:").join ("<FONT FACE='Smilies' SIZE='20'><FONT COLOR='#DEA701'>&nbsp;A</FONT><FONT COLOR='#F2D300'>C</FONT><FONT COLOR='#FEEE00'>D</FONT><FONT COLOR='#FFF9AE'>B</FONT><FONT COLOR='#330000'>z</FONT><FONT COLOR='#0A0101'>_V</FONT><FONT COLOR='#FBFBF8'>W</FONT><FONT COLOR='#0A0102'>w&nbsp;</FONT></FONT>");
		sendMesg = sendMesg.split (":devil:").join ("<FONT FACE='Smilies' SIZE='20'><FONT COLOR='#990010'>&nbsp;y</FONT><FONT COLOR='#DEA701'>A</FONT><FONT COLOR='#F2D300'>C</FONT><FONT COLOR='#FEEE00'>D</FONT><FONT COLOR='#FFF9AE'>B</FONT><FONT COLOR='#330000'>z</FONT><FONT COLOR='#CC0000'>Y</FONT><FONT COLOR='#2F0101'>XV</FONT><FONT COLOR='#FFFDFD'>W&nbsp;</FONT></FONT>");
		sendMesg = sendMesg.split (":satan:").join ("<FONT FACE='Smilies' SIZE='20'><FONT COLOR='#990000'>&nbsp;yA</FONT><FONT COLOR='#D11300'>C</FONT><FONT COLOR='#E51F00'>D</FONT><FONT COLOR='#1C1202'>z</FONT><FONT COLOR='#FF6666'>ª</FONT><FONT COLOR='#F9E1E1'>Y</FONT><FONT COLOR='#010911'>XJ&nbsp;</FONT></FONT>");
		sendMesg = sendMesg.split (":whatever:").join ("<FONT FACE='Smilies' SIZE='20'><FONT COLOR='#DEA701'>&nbsp;A</FONT><FONT COLOR='#F2D300'>C</FONT><FONT COLOR='#FEEE00'>D</FONT><FONT COLOR='#FFF9AE'>B</FONT><FONT COLOR='#330000'>z</FONT><FONT COLOR='#FFFFFE'>u</FONT><FONT COLOR='#050202'>t</FONT><FONT COLOR='#130305'>v</FONT><FONT COLOR='#140405'>E&nbsp;</FONT></FONT>");
		sendMesg = sendMesg.split (":hmmm:").join ("<FONT FACE='Smilies' SIZE='20'><FONT COLOR='#DEA701'>&nbsp;A</FONT><FONT COLOR='#F2D300'>C</FONT><FONT COLOR='#FEEE00'>D</FONT><FONT COLOR='#FFF9AE'>B</FONT><FONT COLOR='#330000'>z</FONT><FONT COLOR='#FFFFFE'>u</FONT><FONT COLOR='#050201'>t</FONT><FONT COLOR='#0B0B14'>v</FONT><FONT COLOR='#140415'>5&nbsp;</FONT></FONT>");
		sendMesg = sendMesg.split (":neutral:").join ("<FONT FACE='Smilies' SIZE='20'><FONT COLOR='#DEA701'>&nbsp;A</FONT><FONT COLOR='#F2D300'>C</FONT><FONT COLOR='#FEEE00'>D</FONT><FONT COLOR='#FFF9AE'>B</FONT><FONT COLOR='#080809'>z</FONT><FONT COLOR='#FCFCFA'>u</FONT><FONT COLOR='#050203'>t</FONT><FONT COLOR='#140404'>v</FONT><FONT COLOR='#141404'>4&nbsp;</FONT></FONT>");
		sendMesg = sendMesg.split (":|").join ("<FONT FACE='Smilies' SIZE='20'><FONT COLOR='#DEA701'>&nbsp;A</FONT><FONT COLOR='#F2D300'>C</FONT><FONT COLOR='#FEEE00'>D</FONT><FONT COLOR='#FFF9AE'>B</FONT><FONT COLOR='#330000'>zI4&nbsp;</FONT></FONT>");
		sendMesg = sendMesg.split (":(").join ("<FONT FACE='Smilies' SIZE='20'><FONT COLOR='#DEA701'>&nbsp;A</FONT><FONT COLOR='#F2D300'>C</FONT><FONT COLOR='#FEEE00'>D</FONT><FONT COLOR='#FFF9AE'>B</FONT><FONT COLOR='#330000'>zIK&nbsp;</FONT></FONT>");
		sendMesg = sendMesg.split ("=(").join ("<FONT FACE='Smilies' SIZE='20'><FONT COLOR='#DEA701'>&nbsp;A</FONT><FONT COLOR='#F2D300'>C</FONT><FONT COLOR='#FEEE00'>D</FONT><FONT COLOR='#FFF9AE'>B</FONT><FONT COLOR='#330000'>zLK&nbsp;</FONT></FONT>");
		sendMesg = sendMesg.split (":cool:").join ("<FONT FACE='Smilies' SIZE='20'><FONT COLOR='#DEA701'>&nbsp;A</FONT><FONT COLOR='#F2D300'>C</FONT><FONT COLOR='#FEEE00'>D</FONT><FONT COLOR='#FFF9AE'>B</FONT><FONT COLOR='#330000'>zF</FONT><FONT COLOR='#CC33FF'>G</FONT><FONT COLOR='#0F0101'>E&nbsp;</FONT></FONT>");
		sendMesg = sendMesg.split (":2cool:").join ("<FONT FACE='Smilies' SIZE='20'><FONT COLOR='#DEA701'>&nbsp;A</FONT><FONT COLOR='#F2D300'>C</FONT><FONT COLOR='#FEEE00'>D</FONT><FONT COLOR='#FFF9AE'>B</FONT><FONT COLOR='#330000'>zF</FONT><FONT COLOR='#CC33FF'>G</FONT><FONT COLOR='#230101'>O</FONT><FONT COLOR='#FFFEFE'>P&nbsp;</FONT></FONT>");
		sendMesg = sendMesg.split (":whoa:").join ("<FONT FACE='Smilies' SIZE='20'><FONT COLOR='#DEA701'>&nbsp;A</FONT><FONT COLOR='#F2D300'>C</FONT><FONT COLOR='#FEEE00'>D</FONT><FONT COLOR='#FFF9AE'>B</FONT><FONT COLOR='#330000'>z</FONT><FONT COLOR='#FFFFFE'>u</FONT><FONT COLOR='#050202'>t</FONT><FONT COLOR='#060406'>x</FONT><FONT COLOR='#160406'>4&nbsp;</FONT></FONT>");
		sendMesg = sendMesg.split (":ninja:").join ("<FONT FACE='Smilies' SIZE='20'><FONT COLOR='#DEA701'>&nbsp;A</FONT><FONT COLOR='#F2D300'>C</FONT><FONT COLOR='#FEEE00'>D</FONT><FONT COLOR='#FFF9AE'>B</FONT><FONT COLOR='#330000'>z</FONT><FONT COLOR='#FCF9FC'>9</FONT><FONT COLOR='#FC0808'>~</FONT><FONT COLOR='#020000'>?_&nbsp;</FONT></FONT>");
		sendMesg = sendMesg.split (":pissed:").join ("<FONT FACE='Smilies' SIZE='20'><FONT COLOR='#DEA701'>&nbsp;A</FONT><FONT COLOR='#F2D300'>C</FONT><FONT COLOR='#FEEE00'>D</FONT><FONT COLOR='#FFF9AE'>B</FONT><FONT COLOR='#330000'>z_4`&nbsp;</FONT></FONT>");
		sendMesg = sendMesg.split (":sleeze:").join ("<FONT FACE='Smilies' SIZE='20'><FONT COLOR='#DEA701'>&nbsp;A</FONT><FONT COLOR='#F2D300'>C</FONT><FONT COLOR='#FEEE00'>D</FONT><FONT COLOR='#FFF9AE'>B</FONT><FONT COLOR='#330001'>z</FONT><FONT COLOR='#260102'>Q</FONT><FONT COLOR='#280102'>V</FONT><FONT COLOR='#FDFCFD'>W</FONT><FONT COLOR='#210102'>I&nbsp;</FONT></FONT>");
		sendMesg = sendMesg.split (":innocent:").join ("<FONT FACE='Smilies' SIZE='20'><FONT COLOR='#DEA701'>&nbsp;A</FONT><FONT COLOR='#F2D300'>C</FONT><FONT COLOR='#FEEE00'>D</FONT><FONT COLOR='#FFF9AE'>B</FONT><FONT COLOR='#330000'>zQV</FONT><FONT COLOR='#FBFBFB'>W</FONT><FONT COLOR='#E5F0FF'>w</FONT><FONT COLOR='#031415'>`&nbsp;</FONT></FONT>");
		sendMesg = sendMesg.split (":info:").join ("<FONT FACE='Smilies' SIZE='20'><FONT COLOR='#005AB2'>&nbsp;A</FONT><FONT COLOR='#0073E3'>C</FONT><FONT COLOR='#0080FF'>D</FONT><FONT COLOR='#160408'>z</FONT><FONT COLOR='#FFFFF9'>]&nbsp;</FONT></FONT>");
		sendMesg = sendMesg.split (":link:").join ("<FONT FACE='Smilies' SIZE='20'><FONT COLOR='#005AB2'>&nbsp;A</FONT><FONT COLOR='#0073E3'>C</FONT><FONT COLOR='#0080FF'>D</FONT><FONT COLOR='#65A7FF'>ºB</FONT><FONT COLOR='#DDEEFF'>ª</FONT><FONT COLOR='#4599FF'>‹</FONT><FONT COLOR='#67A6FA'>›</FONT><FONT COLOR='#9CC0FF'>«</FONT><FONT COLOR='#000033'>z</FONT><FONT COLOR='#000066'>6&nbsp;</FONT></FONT>");
		sendMesg = sendMesg.split (":unshaven:").join ("<FONT FACE='Smilies' SIZE='20'><FONT COLOR='#DEA701'>&nbsp;A</FONT><FONT COLOR='#F2D300'>C</FONT><FONT COLOR='#FEEE00'>D</FONT><FONT COLOR='#FFF9AE'>B</FONT><FONT COLOR='#C2B302'>T</FONT><FONT COLOR='#040405'>z</FONT><FONT COLOR='#030506'>I</FONT><FONT COLOR='#06090D'>4&nbsp;</FONT></FONT>");
		sendMesg = sendMesg.split (":restricted:").join ("<FONT FACE='Smilies' SIZE='20'><FONT COLOR='#990000'>&nbsp;A</FONT><FONT COLOR='#D11300'>C</FONT><FONT COLOR='#E51F00'>D</FONT><FONT COLOR='#FBFCFB'>\\</FONT><FONT COLOR='#1C0104'>z&nbsp;</FONT></FONT>");
		sendMesg = sendMesg.split (":warning:").join ("<FONT FACE='Smilies' SIZE='20'><FONT COLOR='#990000'>&nbsp;A</FONT><FONT COLOR='#D11300'>C</FONT><FONT COLOR='#E51F00'>D</FONT><FONT COLOR='#FFFFEE'>[</FONT><FONT COLOR='#330002'>z&nbsp;</FONT></FONT>");
		sendMesg = sendMesg.split (":exclamation:").join ("<FONT FACE='Smilies' SIZE='20'><FONT COLOR='#DEA701'>&nbsp;A</FONT><FONT COLOR='#F2D300'>C</FONT><FONT COLOR='#FEEE00'>D</FONT><FONT COLOR='#FFF9AE'>B</FONT><FONT COLOR='#330000'>z[&nbsp;</FONT></FONT>");
		sendMesg = sendMesg.split (":help:").join ("<FONT FACE='Smilies' SIZE='20'><FONT COLOR='#DEA701'>&nbsp;A</FONT><FONT COLOR='#F2D300'>C</FONT><FONT COLOR='#FEEE00'>D</FONT><FONT COLOR='#FFF9AE'>B</FONT><FONT COLOR='#330000'>zH&nbsp;</FONT></FONT>");
		sendMesg = sendMesg.split (":back:").join ("<FONT FACE='Smilies' SIZE='20'><FONT COLOR='#DEA701'>&nbsp;A</FONT><FONT COLOR='#F2D300'>C</FONT><FONT COLOR='#FEEE00'>D</FONT><FONT COLOR='#FFF9AE'>B</FONT><FONT COLOR='#330000'>zh&nbsp;</FONT></FONT>");
		sendMesg = sendMesg.split (":at:").join ("<FONT FACE='Smilies' SIZE='20'><FONT COLOR='#666666'>&nbsp;@&nbsp;</FONT></FONT>");
		sendMesg = sendMesg.split (":back2:").join ("<FONT FACE='Smilies' SIZE='20'><FONT COLOR='#656363'>&nbsp;A</FONT><FONT COLOR='#FBFDFA'>h&nbsp;</FONT></FONT>");
		sendMesg = sendMesg.split (":webcam:").join ("<FONT FACE='Smilies' SIZE='20'><FONT COLOR='#0D0D0C'>&nbsp;j</FONT><FONT COLOR='#EBEEF0'>A</FONT><FONT COLOR='#FEFEFD'>C</FONT><FONT COLOR='#0089FF'>i</FONT><FONT COLOR='#070703'>z</FONT><FONT COLOR='#C9C9C9'>l</FONT><FONT COLOR='#000002'>n</FONT><FONT COLOR='#46B3FF'>o</FONT><FONT COLOR='#F7F7F5'>m</FONT><FONT COLOR='#000003'>k&nbsp;</FONT></FONT>");
		sendMesg = sendMesg.split (":email:").join ("<FONT FACE='Smilies' SIZE='20'><FONT COLOR='#060C05'>&nbsp;7</FONT><FONT COLOR='#FEFEDB'>8&nbsp;</FONT></FONT>");
		sendMesg = sendMesg.split (":sync:").join ("<FONT FACE='Smilies' SIZE='20'><FONT COLOR='#CDCCCC'>&nbsp;A</FONT><FONT COLOR='#000005'>z</FONT><FONT COLOR='#EDEDED'>D</FONT><FONT COLOR='#333336'>c&nbsp;</FONT></FONT>");
		sendMesg = sendMesg.split (":flame:").join ("<FONT FACE='Smilies' SIZE='20'><FONT COLOR='#000000'>&nbsp;$</FONT><FONT COLOR='#FF7000'>%</FONT><FONT COLOR='#FFCC00'>&amp;&nbsp;</FONT></FONT>");
		sendMesg = sendMesg.split (":O").join ("<FONT FACE='Smilies' SIZE='20'><FONT COLOR='#DEA701'>&nbsp;A</FONT><FONT COLOR='#F2D300'>C</FONT><FONT COLOR='#FBEB03'>D</FONT><FONT COLOR='#FFF9AE'>B</FONT><FONT COLOR='#080806'>z</FONT><FONT COLOR='#FDFDFC'>u</FONT><FONT COLOR='#0E0303'>t`ø&nbsp;</FONT></FONT>");
		sendMesg = sendMesg.split (":stamp:").join ("<FONT FACE='Smilies' SIZE='20'><FONT COLOR='#000011'>&nbsp;£</FONT><FONT COLOR='#EEF4FA'>§</FONT><FONT COLOR='#0080FF'>¢</FONT><FONT COLOR='#F2EEEE'>@&nbsp;</FONT></FONT>");
		sendMesg = sendMesg.split (":stream:").join ("<FONT FACE='Smilies' SIZE='20'><FONT COLOR='#333333'>&nbsp;™&nbsp;</FONT></FONT>");
		sendMesg = sendMesg.split (":bliss:").join ("<FONT FACE='Smilies' SIZE='20'><FONT COLOR='#DEA701'>&nbsp;A</FONT><FONT COLOR='#F2D300'>C</FONT><FONT COLOR='#FEEE00'>D</FONT><FONT COLOR='#FFF9AE'>B</FONT><FONT COLOR='#330000'>zQ¶</FONT><FONT COLOR='#FF0000'>•&nbsp;</FONT></FONT>");
		sendMesg = sendMesg.split (":yawn:").join ("<FONT FACE='Smilies' SIZE='20'><FONT COLOR='#DEA701'>&nbsp;A</FONT><FONT COLOR='#F2D300'>C</FONT><FONT COLOR='#FEEE00'>D</FONT><FONT COLOR='#FDF7B0'>ª</FONT><FONT COLOR='#170101'>z›</FONT><FONT COLOR='#130101'>«</FONT><FONT COLOR='#150101'>Q</FONT><FONT COLOR='#F80303'>•&nbsp;</FONT></FONT>");
		sendMesg = sendMesg.split (":sick:").join ("<FONT FACE='Smilies' SIZE='20'><FONT COLOR='#33A800'>&nbsp;A</FONT><FONT COLOR='#39BD00'>C</FONT><FONT COLOR='#5CE023'>D</FONT><FONT COLOR='#B8FF99'>B</FONT><FONT COLOR='#022F02'>z</FONT><FONT COLOR='#022C02'>`</FONT><FONT COLOR='#012A01'>5&nbsp;</FONT></FONT>");
		sendMesg = sendMesg.split (":jealous:").join ("<FONT FACE='Smilies' SIZE='20'><FONT COLOR='#33A800'>&nbsp;A</FONT><FONT COLOR='#39BD00'>C</FONT><FONT COLOR='#5CE023'>D</FONT><FONT COLOR='#B8FF99'>B</FONT><FONT COLOR='#003301'>zO</FONT><FONT COLOR='#FCFAF9'>P</FONT><FONT COLOR='#160418'>Q&nbsp;</FONT></FONT>");
		sendMesg = sendMesg.split (":download:").join ("<FONT FACE='Smilies' SIZE='20'><FONT COLOR='#33A800'>&nbsp;A</FONT><FONT COLOR='#39BD00'>C</FONT><FONT COLOR='#DDFFDE'>#</FONT><FONT COLOR='#003300'>z&nbsp;</FONT></FONT>");
		sendMesg = sendMesg.split (":flammable:").join ("<FONT FACE='Smilies' SIZE='20'><FONT COLOR='#990000'>&nbsp;A</FONT><FONT COLOR='#D11300'>C</FONT><FONT COLOR='#E51F00'>D</FONT><FONT COLOR='#090902'>z</FONT><FONT COLOR='#FDF9F9'>¡&nbsp;</FONT></FONT>");
		sendMesg = sendMesg.split ("lol").join ("<FONT FACE='Smilies' SIZE='20'><FONT COLOR='#DEA701'>&nbsp;A</FONT><FONT COLOR='#F2D300'>C</FONT><FONT COLOR='#FEEE00'>D</FONT><FONT COLOR='#2D0000'>zß</FONT><FONT COLOR='#FA0505'>•</FONT><FONT COLOR='#2D0001'>Q</FONT><FONT COLOR='#FCFCF8'>Î&nbsp;</FONT></FONT>");
		sendMesg = sendMesg.split ("LOL").join ("<FONT FACE='Smilies' SIZE='20'><FONT COLOR='#DEA701'>&nbsp;A</FONT><FONT COLOR='#F2D300'>C</FONT><FONT COLOR='#FEEE00'>D</FONT><FONT COLOR='#2D0000'>zß</FONT><FONT COLOR='#FA0505'>•</FONT><FONT COLOR='#2D0001'>Q</FONT><FONT COLOR='#FCFCF8'>Î&nbsp;</FONT></FONT>");
		sendMesg = sendMesg.split (":postit:").join ("<FONT FACE='Smilies' SIZE='20'><FONT COLOR='#2C2B01'>&nbsp;d</FONT><FONT COLOR='#FCEC04'>e</FONT><FONT COLOR='#CD0303'>f</FONT><FONT COLOR='#070707'>g&nbsp;</FONT></FONT>");
		// sendMesg = sendMesg.split(":)").join("xxxxx");
		return sendMesg;
	}
	// END CLASS
}
