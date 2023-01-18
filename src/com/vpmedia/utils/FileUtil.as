/**
 * FileUtil
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
 * Project: FileUtil
 * File: FileUtil.as
 * Created by: András Csizmadia
 *
 */
// Implementations
import com.vpmedia.core.IFramework;
class com.vpmedia.utils.FileUtil extends MovieClip implements IFramework
{
	// START CLASS
	public var className:String = "FileUtil";
	public var classPackage:String = "com.vpmedia.utils";
	public var version:String = "2.0.0";
	public var author:String = "András Csizmadia";
	//
	//Information Codes 
	public var FILECode_arr = new Array ();
	function FileUtil ()
	{
		this.FILECode_arr = new Array ();
		FILECode_arr['ai'] = "Adobe Illustrator";
		FILECode_arr['aif'] = "Audio Interchange";
		FILECode_arr['aiff'] = "Audio Interchange";
		FILECode_arr['ani'] = "Animated Cursor";
		FILECode_arr['ans'] = "ANSI Text";
		FILECode_arr['api'] = "Application Program Interface";
		FILECode_arr['app'] = "Macromedia Authorware Package";
		FILECode_arr['arc'] = "ARC Compressed";
		FILECode_arr['arj'] = "ARJ Compressed";
		FILECode_arr['asc'] = "ASCII Text";
		FILECode_arr['asf'] = "Active Streaming";
		FILECode_arr['asm'] = "Assembly Source Code";
		FILECode_arr['asp'] = "Active Server Page";
		FILECode_arr['avi'] = "AVI Movie";
		FILECode_arr['bak'] = "Backup Copy";
		FILECode_arr['bas'] = "BASIC Program";
		FILECode_arr['bat'] = "Batch";
		FILECode_arr['bk$'] = "Backup";
		FILECode_arr['bk'] = "Backup Copy";
		FILECode_arr['bmp'] = "Bitmap";
		FILECode_arr['c'] = "C Program";
		FILECode_arr['cab'] = "Microsoft Compressed";
		FILECode_arr['cdr'] = "CorelDraw";
		FILECode_arr['cdt'] = "CorelDraw Template";
		FILECode_arr['cdx'] = "CorelDraw Compressed";
		FILECode_arr['cdx'] = "FoxPro Database Index";
		FILECode_arr['cfg'] = "Configuration";
		FILECode_arr['cgi'] = "Common Gateway Interface";
		FILECode_arr['cpp'] = "C++ Program";
		FILECode_arr['css'] = "Cascading Style Sheet";
		FILECode_arr['csv'] = "Comma Delimited";
		FILECode_arr['cur'] = "Windows Cursor Image";
		FILECode_arr['dat'] = "Data";
		FILECode_arr['db'] = "Table - Paradox";
		FILECode_arr['dbc'] = "Visual FoxPro Database";
		FILECode_arr['dbf'] = "dBASE Database";
		FILECode_arr['dbt'] = "dBASE Database Text";
		FILECode_arr['doc'] = "Document file";
		FILECode_arr['drv'] = "Driver";
		FILECode_arr['dwg'] = "AutoCAD Vector";
		FILECode_arr['eml'] = "Electronic Mail";
		FILECode_arr['enc'] = "Encoded";
		FILECode_arr['eps'] = "Encapsulated PostScript";
		FILECode_arr['exe'] = "Executable";
		FILECode_arr['fax'] = "Fax";
		FILECode_arr['fnt'] = "Font";
		FILECode_arr['fon'] = "Bitmapped Font";
		FILECode_arr['fot'] = "TrueType Font";
		FILECode_arr['gif'] = "Graphics Interchange";
		FILECode_arr['gz'] = "GZIP Compressed";
		FILECode_arr['h'] = "C Header";
		FILECode_arr['hlp'] = "Help";
		FILECode_arr['htm'] = "HTML Document";
		FILECode_arr['html'] = "HTML Document";
		FILECode_arr['ico'] = "Icon";
		FILECode_arr['it'] = "MOD Music";
		FILECode_arr['jpeg'] = "JPEG Image";
		FILECode_arr['jpg'] = "JPEG Image";
		FILECode_arr['lib'] = "Library";
		FILECode_arr['log'] = "Log";
		FILECode_arr['lst'] = "List";
		FILECode_arr['mime'] = "MIME";
		FILECode_arr['mme'] = "MIME Encoded";
		FILECode_arr['mov'] = "QuickTime Movie";
		FILECode_arr['movie'] = "QuickTime movie";
		FILECode_arr['mp2'] = "MP2 Audio";
		FILECode_arr['mp3'] = "MP3 Audio";
		FILECode_arr['mpe'] = "MPEG";
		FILECode_arr['mpeg'] = "MPEG Movie";
		FILECode_arr['mpg'] = "MPEG Movie";
		FILECode_arr['pas'] = "Pascal Program";
		FILECode_arr['phps'] = "PHP Source Code";
		FILECode_arr['phtml'] = "HTML Document";
		FILECode_arr['pjx'] = "Visual FoxPro Project";
		FILECode_arr['pl'] = "Perl script";
		FILECode_arr['pps'] = "PowerPoint Slideshow";
		FILECode_arr['ppt'] = "PowerPoint Presentation";
		FILECode_arr['psd'] = "Photoshop Document";
		FILECode_arr['qt'] = "QuickTime Movie";
		FILECode_arr['qtm'] = "QuickTime Movie";
		FILECode_arr['ra'] = "Real Audio";
		FILECode_arr['ram'] = "Real Audio";
		FILECode_arr['reg'] = "Registration File";
		FILECode_arr['rm'] = "Real Media";
		FILECode_arr['s'] = "Assembly Language";
		FILECode_arr['shtml'] = "HTML Document";
		FILECode_arr['sit'] = "StuffIT Compressed";
		FILECode_arr['snd'] = "Sound File";
		FILECode_arr['swf'] = "Flash Movie";
		FILECode_arr['swp'] = "Swap Temporary File";
		FILECode_arr['sys'] = "System File";
		FILECode_arr['tar'] = "Tape Archive";
		FILECode_arr['tga'] = "TARGA Graphics";
		FILECode_arr['tgz'] = "Tape Archive";
		FILECode_arr['tif'] = "TIFF Graphics";
		FILECode_arr['tiff'] = "TIFF Graphics";
		FILECode_arr['tmp'] = "Temporary File";
		FILECode_arr['ttf'] = "TrueType Font";
		FILECode_arr['txt'] = "Text File";
		FILECode_arr['uu'] = "Uuencode Compressed";
		FILECode_arr['uue'] = "Uuencode File";
		FILECode_arr['vbp'] = "Visual Basic Project";
		FILECode_arr['vbx'] = "Visual Basic Extension";
		FILECode_arr['wab'] = "Windows Address Book";
		FILECode_arr['wav'] = "Sound File";
		FILECode_arr['xlm'] = "Excel Macro";
		FILECode_arr['xls'] = "Excel Worksheet";
		FILECode_arr['xlt'] = "Excel Template";
		FILECode_arr['xm'] = "MOD Music";
		FILECode_arr['xxe'] = "Xxencoded File";
		FILECode_arr['z'] = "Unix Archive";
		FILECode_arr['zip'] = "Archive";
	}
	// Get FILE type description.
	public function getCodeName (__id)
	{
		var __name = this.FILECode_arr[__id];
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
