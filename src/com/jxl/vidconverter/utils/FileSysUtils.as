/*
	FileSysUtils
	
	Class created to make it easier to interact with SWFStudio's API's.
    
    Created by Jesse R. Warden a.k.a. "JesterXL"
	jesterxl@jessewarden.com
	http://www.jessewarden.com
	jesse@universalmind.com
	http://www.universalmind.com
	
	This is release under a Creative Commons license. 
    More information can be found here:
    
    http://creativecommons.org/licenses/by/2.5/
*/

import com.jxl.vidconverter.vo.parameters.CopyFileParametersVO;

class com.jxl.vidconverter.utils.FileSysUtils
{
	
	public static function copyFile(params:CopyFileParametersVO):CopyFileParametersVO
	{
		var result:CopyFileParametersVO = CopyFileParametersVO(ssCore.FileSys.copyFile(params));
		return result;
	}
	
}