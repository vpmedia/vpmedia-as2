/*
	ValueObjects
	
	Registers all ValueObjects as class objects.  For some reason, I'm having serious
	issues getting Flashcom ones to work server-side.  The castings are failing,
	even with Flash 8 vs. Flash 9, and I'm not sure what I'm doing wrong.
    
    Created by Jesse R. Warden a.k.a. "JesterXL"
	jesterxl@jessewarden.com
	http://www.jessewarden.com
	jesse@universalmind.com
	http://www.universalmind.com
	
	This is release under a Creative Commons license. 
    More information can be found here:
    
    http://creativecommons.org/licenses/by/2.5/
*/

import org.osflash.arp.ValueObjectsTemplate;

import com.jxl.vidconverter.vo.parameters.ShellParametersVO;
import com.jxl.vidconverter.vo.returns.ShellExecuteReturnVO;

import com.jxl.vidconverter.vo.fcs.FCEncodeInfo;
import com.jxl.vidconverter.vo.fcs.FCFault;
import com.jxl.vidconverter.vo.fcs.FCFaultEvent;
import com.jxl.vidconverter.vo.fcs.FCResultEvent;



class com.jxl.vidconverter.vo.ValueObjects extends ValueObjectsTemplate
{
	public function registerValueObjects():Void
	{
		registerValueObject("com.jxl.vidconverter.vo.parameters.ShellParametersVO",
						   	com.jxl.vidconverter.vo.parameters.ShellParametersVO);
		
		registerValueObject("com.jxl.vidconverter.vo.returns.ShellExecuteReturnVO",
						   	com.jxl.vidconverter.vo.returns.ShellExecuteReturnVO);
		
		registerValueObject("FCEncodeInfo",
						   	com.jxl.vidconverter.vo.fcs.FCEncodeInfo);
		
		registerValueObject("FCFault",
						   	com.jxl.vidconverter.vo.fcs.FCFault);
		
		registerValueObject("FCFaultEvent",
						   	com.jxl.vidconverter.vo.fcs.FCFaultEvent);
		
		registerValueObject("FCResultEvent",
						   	com.jxl.vidconverter.vo.fcs.FCResultEvent);
		
	}
}