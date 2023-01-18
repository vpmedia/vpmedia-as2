/**
 * MimeUtil
 * Copyright © 2006 András Csizmadia
 * Copyright © 2006 VPmedia
 * http://www.vpmedia.hu
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
 * IN THE SOFTWARE.
 * 
 * Project: MimeUtil
 * File: MimeUtil.as
 * Created by: András Csizmadia
 *
 */
// Implementations
import com.vpmedia.core.IFramework;
class com.vpmedia.utils.MimeUtil extends MovieClip implements IFramework
{
	// START CLASS
	public var className:String = "MimeUtil";
	public var classPackage:String = "com.vpmedia.utils";
	public var version:String = "2.0.0";
	public var author:String = "András Csizmadia";
	//
	//Information Codes 
	public var MIMECode_arr = new Array ();
	function MimeUtil ()
	{
		this.MIMECode_arr[".ez"] = "application/andrew-inset";
		this.MIMECode_arr[".hqx"] = "application/mac-binhex40";
		this.MIMECode_arr[".cpt"] = "application/mac-compactpro";
		this.MIMECode_arr[".doc"] = "application/msword";
		this.MIMECode_arr[".bin"] = "application/octet-stream";
		this.MIMECode_arr[".dms"] = "application/octet-stream";
		this.MIMECode_arr[".lha"] = "application/octet-stream";
		this.MIMECode_arr[".lzh"] = "application/octet-stream";
		this.MIMECode_arr[".exe"] = "application/octet-stream";
		this.MIMECode_arr[".class"] = "application/octet-stream";
		this.MIMECode_arr[".so"] = "application/octet-stream";
		this.MIMECode_arr[".dll"] = "application/octet-stream";
		this.MIMECode_arr[".oda"] = "application/oda";
		this.MIMECode_arr[".pdf"] = "application/pdf";
		this.MIMECode_arr[".ai"] = "application/postscript";
		this.MIMECode_arr[".eps"] = "application/postscript";
		this.MIMECode_arr[".ps"] = "application/postscript";
		this.MIMECode_arr[".smi"] = "application/smil";
		this.MIMECode_arr[".smil"] = "application/smil";
		this.MIMECode_arr[".wbxml"] = "application/vnd.wap.wbxml";
		this.MIMECode_arr[".wmlc"] = "application/vnd.wap.wmlc";
		this.MIMECode_arr[".wmlsc"] = "application/vnd.wap.wmlscriptc";
		this.MIMECode_arr[".bcpio"] = "application/x-bcpio";
		this.MIMECode_arr[".vcd"] = "application/x-cdlink";
		this.MIMECode_arr[".pgn"] = "application/x-chess-pgn";
		this.MIMECode_arr[".cpio"] = "application/x-cpio";
		this.MIMECode_arr[".csh"] = "application/x-csh";
		this.MIMECode_arr[".dcr"] = "application/x-director";
		this.MIMECode_arr[".dir"] = "application/x-director";
		this.MIMECode_arr[".dxr"] = "application/x-director";
		this.MIMECode_arr[".dvi"] = "application/x-dvi";
		this.MIMECode_arr[".spl"] = "application/x-futuresplash";
		this.MIMECode_arr[".gtar"] = "application/x-gtar";
		this.MIMECode_arr[".hdf"] = "application/x-hdf";
		this.MIMECode_arr[".js"] = "application/x-javascript";
		this.MIMECode_arr[".skp"] = "application/x-koan";
		this.MIMECode_arr[".skd"] = "application/x-koan";
		this.MIMECode_arr[".skt"] = "application/x-koan";
		this.MIMECode_arr[".skm"] = "application/x-koan";
		this.MIMECode_arr[".latex"] = "application/x-latex";
		this.MIMECode_arr[".nc"] = "application/x-netcdf";
		this.MIMECode_arr[".cdf"] = "application/x-netcdf";
		this.MIMECode_arr[".sh"] = "application/x-sh";
		this.MIMECode_arr[".shar"] = "application/x-shar";
		this.MIMECode_arr[".swf"] = "application/x-shockwave-flash";
		this.MIMECode_arr[".sit"] = "application/x-stuffit";
		this.MIMECode_arr[".sv4cpio"] = "application/x-sv4cpio";
		this.MIMECode_arr[".sv4crc"] = "application/x-sv4crc";
		this.MIMECode_arr[".tar"] = "application/x-tar";
		this.MIMECode_arr[".tcl"] = "application/x-tcl";
		this.MIMECode_arr[".tex"] = "application/x-tex";
		this.MIMECode_arr[".texinfo"] = "application/x-texinfo";
		this.MIMECode_arr[".texi"] = "application/x-texinfo";
		this.MIMECode_arr[".t"] = "application/x-troff";
		this.MIMECode_arr[".tr"] = "application/x-troff";
		this.MIMECode_arr[".roff"] = "application/x-troff";
		this.MIMECode_arr[".man"] = "application/x-troff-man";
		this.MIMECode_arr[".me"] = "application/x-troff-me";
		this.MIMECode_arr[".ms"] = "application/x-troff-ms";
		this.MIMECode_arr[".ustar"] = "application/x-ustar";
		this.MIMECode_arr[".src"] = "application/x-wais-source";
		this.MIMECode_arr[".xhtml"] = "application/xhtml+xml";
		this.MIMECode_arr[".xht"] = "application/xhtml+xml";
		this.MIMECode_arr[".zip"] = "application/zip";
		this.MIMECode_arr[".au"] = "audio/basic";
		this.MIMECode_arr[".snd"] = "audio/basic";
		this.MIMECode_arr[".mid"] = "audio/midi";
		this.MIMECode_arr[".midi"] = "audio/midi";
		this.MIMECode_arr[".kar"] = "audio/midi";
		this.MIMECode_arr[".mpga"] = "audio/mpeg";
		this.MIMECode_arr[".mp2"] = "audio/mpeg";
		this.MIMECode_arr[".mp3"] = "audio/mpeg";
		this.MIMECode_arr[".aif"] = "audio/x-aiff";
		this.MIMECode_arr[".aiff"] = "audio/x-aiff";
		this.MIMECode_arr[".aifc"] = "audio/x-aiff";
		this.MIMECode_arr[".m3u"] = "audio/x-mpegurl";
		this.MIMECode_arr[".ram"] = "audio/x-pn-realaudio";
		this.MIMECode_arr[".rm"] = "audio/x-pn-realaudio";
		this.MIMECode_arr[".rpm"] = "audio/x-pn-realaudio-plugin";
		this.MIMECode_arr[".ra"] = "audio/x-realaudio";
		this.MIMECode_arr[".wav"] = "audio/x-wav";
		this.MIMECode_arr[".pdb"] = "chemical/x-pdb";
		this.MIMECode_arr[".xyz"] = "chemical/x-xyz";
		this.MIMECode_arr[".bmp"] = "image/bmp";
		this.MIMECode_arr[".gif"] = "image/gif";
		this.MIMECode_arr[".ief"] = "image/ief";
		this.MIMECode_arr[".jpeg"] = "image/jpeg";
		this.MIMECode_arr[".jpg"] = "image/jpeg";
		this.MIMECode_arr[".jpe"] = "image/jpeg";
		this.MIMECode_arr[".png"] = "image/png";
		this.MIMECode_arr[".tiff"] = "image/tiff";
		this.MIMECode_arr[".tif"] = "image/tif";
		this.MIMECode_arr[".djvu"] = "image/vnd.djvu";
		this.MIMECode_arr[".djv"] = "image/vnd.djvu";
		this.MIMECode_arr[".wbmp"] = "image/vnd.wap.wbmp";
		this.MIMECode_arr[".ras"] = "image/x-cmu-raster";
		this.MIMECode_arr[".pnm"] = "image/x-portable-anymap";
		this.MIMECode_arr[".pbm"] = "image/x-portable-bitmap";
		this.MIMECode_arr[".pgm"] = "image/x-portable-graymap";
		this.MIMECode_arr[".ppm"] = "image/x-portable-pixmap";
		this.MIMECode_arr[".rgb"] = "image/x-rgb";
		this.MIMECode_arr[".xbm"] = "image/x-xbitmap";
		this.MIMECode_arr[".xpm"] = "image/x-xpixmap";
		this.MIMECode_arr[".xwd"] = "image/x-windowdump";
		this.MIMECode_arr[".igs"] = "model/iges";
		this.MIMECode_arr[".iges"] = "model/iges";
		this.MIMECode_arr[".msh"] = "model/mesh";
		this.MIMECode_arr[".mesh"] = "model/mesh";
		this.MIMECode_arr[".silo"] = "model/mesh";
		this.MIMECode_arr[".wrl"] = "model/vrml";
		this.MIMECode_arr[".vrml"] = "model/vrml";
		this.MIMECode_arr[".css"] = "text/css";
		this.MIMECode_arr[".html"] = "text/html";
		this.MIMECode_arr[".htm"] = "text/html";
		this.MIMECode_arr[".asc"] = "text/plain";
		this.MIMECode_arr[".txt"] = "text/plain";
		this.MIMECode_arr[".rtx"] = "text/richtext";
		this.MIMECode_arr[".rtf"] = "text/rtf";
		this.MIMECode_arr[".sgml"] = "text/sgml";
		this.MIMECode_arr[".sgm"] = "text/sgml";
		this.MIMECode_arr[".tsv"] = "text/tab-seperated-values";
		this.MIMECode_arr[".wml"] = "text/vnd.wap.wml";
		this.MIMECode_arr[".wmls"] = "text/vnd.wap.wmlscript";
		this.MIMECode_arr[".etx"] = "text/x-setext";
		this.MIMECode_arr[".xml"] = "text/xml";
		this.MIMECode_arr[".xsl"] = "text/xml";
		this.MIMECode_arr[".mpeg"] = "video/mpeg";
		this.MIMECode_arr[".mpg"] = "video/mpeg";
		this.MIMECode_arr[".mpe"] = "video/mpeg";
		this.MIMECode_arr[".qt"] = "video/quicktime";
		this.MIMECode_arr[".mov"] = "video/quicktime";
		this.MIMECode_arr[".mxu"] = "video/vnd.mpegurl";
		this.MIMECode_arr[".avi"] = "video/x-msvideo";
		this.MIMECode_arr[".movie"] = "video/x-sgi-movie";
		this.MIMECode_arr[".ice"] = "x-conference-xcooltalk";
	}
	// Get MIME type description.
	public function getCodeName (__id)
	{
		var __name = this.MIMECode_arr[__id];
		if (__name == undefined)
		{
			__name = "application/octet-stream";
		}
		return __name;
	}
	/**
	 * <p>Description: Get Class version</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	public function getVersion ():String
	{
		//trace ("%%" + "getVersion" + "%%");
		var __version = this.version;
		return __version;
	}
	/**
	 * <p>Description: Get Class name</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	public function toString ():String
	{
		return ("[" + className + "]");
	}
	// END CLASS
}
