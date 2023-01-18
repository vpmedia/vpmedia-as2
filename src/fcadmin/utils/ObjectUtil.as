/******************************************************************************* 
 * Contributors: 
 *        pawaca(pawaca@mess-up.com) - initial API and implementation 
 * Last modified:
 *        2004-11-4
 ******************************************************************************/

/**
 * @exclude
 */
class fcadmin.utils.ObjectUtil
{
	
	static function getProperties(obj:Object,valueSuffix:Boolean,filters:Object,ASSetPropOn:Boolean):Array
	{
		var propsPublic:Object=new Object();
		var propsInternal:Array=new Array();
		var propsOut:Array=new Array();

		
		if(ASSetPropOn)
		{
			for(var i:String in obj)
			{
				propsPublic[i]=true;
			}
			_global.ASSetPropFlags(obj,null,0,1);
			for(var i:String in obj)
			{
				if(propsPublic[i]!=true)
				{
					propsInternal.push(i);
				}
				propsOut.push(i);
			}
			_global.ASSetPropFlags(obj,propsInternal,1);
		}
		else
		{
			for(var i:String in obj)
			{
				propsOut.push(i);
			}
		}

		if(filters!=undefined)
		{			
			for(var i in filters)
			{
				propsOut[i]=null;
				delete propsOut[i];
			}
		}

		if(valueSuffix)
		{
			var len:Number=propsOut.length;
			for(var i:Number=0;i<len;i++)
			{
				propsOut[i]=propsOut[i]+"="+obj[propsOut[i]];
			}
		}

		return propsOut;
	}

}