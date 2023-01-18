/******************************************************************************* 
 * Contributors: 
 *        pawaca(pawaca@mess-up.com) - initial API and implementation 
 * Last modified:
 *        2004-11-18
 ******************************************************************************/


/**
 * @exclude
 */
class fcadmin.utils.ClassUtil
{

	static function hideStatic(theClass:Function,exclude:Object)
	{
		var hideProps:Array=new Array();
		for(var i in theClass)
		{
			if(exclude[i]==undefined)
			{
				hideProps.push(i);
			}
		}
		_global.ASSetPropFlags(theClass,hideProps,1);
	}
}