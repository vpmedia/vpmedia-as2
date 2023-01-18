/*
	ShellUtils
	
	Class created to make it easier to interact with SWFStudio's API's.
	Not finished...
    
    Created by Jesse R. Warden a.k.a. "JesterXL"
	jesterxl@jessewarden.com
	http://www.jessewarden.com
	jesse@universalmind.com
	http://www.universalmind.com
	
	This is release under a Creative Commons license. 
    More information can be found here:
    
    http://creativecommons.org/licenses/by/2.5/
*/

import com.jxl.vidconverter.vo.parameters.ShellParametersVO;
import com.jxl.vidconverter.vo.returns.ShellExecuteReturnVO;

class com.jxl.vidconverter.utils.ShellUtils
{
	public static function execute(params:ShellParametersVO):ShellExecuteReturnVO
	{
		DebugWindow.debugHeader();
		DebugWindow.debug("ShellUtils::execute, params: " + params);
		//DebugWindow.debugProps(params);
		
		//var result:ShellExecuteReturnVO = ShellExecuteReturnVO(ssCore.Shell.execute(params));
		var result = ssCore.Shell.execute(params);
		
		DebugWindow.debug("result: " + result);
		DebugWindow.debugProps(result);
		DebugWindow.debug("Error props");
		DebugWindow.debugProps(result.Error);
		return result;
	}	  


}