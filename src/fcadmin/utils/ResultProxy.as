/******************************************************************************* 
 * Contributors: 
 *        pawaca(pawaca@mess-up.com) - initial API and implementation 
 * Last modified:
 *        12/12/2004
 ******************************************************************************/

import logging.Logger;

import fcadmin.IResult;
import fcadmin.data.StatusObject;
import fcadmin.utils.ObjectUtil;

/**
 * @exclude
 */
dynamic class fcadmin.utils.ResultProxy
{

	private static var logger:Logger = Logger.getLogger("fcadmin.utils.ResultProxy");

	private var result:IResult;
	private var resultName:String;
	private var statusName:String;


	var handleResult:Function;
	var handleStatus:Function;


	function ResultProxy(result:IResult,resultName:String,statusName:String)
	{
		this.result=result;
		this.resultName=resultName;
		this.statusName=statusName;
	}

	function onResult(info)
	{
		logger.info("onStatus:\r"+ObjectUtil.getProperties(info,true).join("\r"));
		if(info.code=="NetConnection.Call.Success"||info.code=="")
		{
			if(handleResult!=undefined)
			{
				handleResult(info);
			}
			else
			{
				facadeResult(info);
			}
		}
		else
		{
			onStatus(info);
		}
	}


	function onStatus(info)
	{
		if(handleStatus!=undefined)
		{
			handleStatus(info);
		}
		else
		{
			var err:StatusObject=StatusObject.fromRawData(info);
			facadeStatus(err);
		}			
	}




	private function facadeResult()
	{
		result[resultName].apply(result,arguments)
	}

	private function facadeStatus()
	{		
		result[statusName].apply(result,arguments);
	}

}
