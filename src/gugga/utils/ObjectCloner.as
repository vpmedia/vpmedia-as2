/**
 * @author Todor Kolev
 */
class gugga.utils.ObjectCloner 
{
	public static function clone( refObj:Object ):Object 
	{
		var result:Object = new Function( refObj.__proto__.constructor)();
		copyProperties( result, refObj );
		
		return result;
	}
	
	public static function copyProperties( dstObj:Object, srcObj:Object ):Void 
	{
		var to:String;
		for( var i:String in srcObj ) 
		{
			to = typeof( srcObj[i] );

			if( to != "function" ) 
			{
				if( to == "object" ) 
				{
					if( srcObj[i] instanceof Array ) 
					{
						var p:Array = new Array();
						var q:Array = srcObj[i];
						
						for( var j:Number=0; j<q.length; j++ )
						{
							p[j] = q[j];
						}
						
						dstObj[i] = p;
					}
					else if( srcObj[i] instanceof String ) 
					{
						dstObj[i] = new String( srcObj[i] );
					}
					else if( srcObj[i] instanceof Number )
					{
						dstObj[i] = new Number( srcObj[i] );
					}
					else if( srcObj[i] instanceof Boolean )
					{
						dstObj[i] = new Boolean( srcObj[i] );
					}
					else if( srcObj[i] instanceof Date )
					{
						dstObj[i] = new Date( srcObj[i] );
					}
					else
					{
						dstObj[i] = clone( srcObj[i] );
					}
				}
				else
				{
					dstObj[i] = srcObj[i];
				}
			}
		}
	}
}