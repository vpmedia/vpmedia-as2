


/**
 * collection of debug functions
 * @author Tim Whitlock <tim@whiteinteractive.com>
 */
class com.timwhitlock.utils.Debug extends Object {	
	
	// incremental ID
	private static var ID:Number = 0;
	
	/**
	 * Simple debug function for inspecting AS structures
	 */
	static function varDump(Ob:Object, indent:String):Void{
	
		if( indent == null ){
			// root 
			indent = '';
			Debug.ID++;
		}
		
		if( typeof Ob != 'object' && typeof Ob != 'movieclip' ){
			varDump( {anonymous: Ob} );
			return;
		}
		
		var nElements:Number = 0;
		for( var v:String in Ob ){
			
			if( Ob[v].__vardump === Debug.ID ){
				// already done.. recursion
				_global.trace(indent + "(recursion) `" + v + '`');
				continue;
			}
			nElements++;

			var t:String = typeof Ob[v];
			switch(t){
			
			case 'null':
			case 'undefined':
				_global.trace(indent + "(NULL) `" + v + '`');
				break;
			
			case 'movieclip':
				// flag clip as read to avoid recursion
				Ob[v].__vardump = Debug.ID;
				_global.ASSetPropFlags(Ob[v],['__vardump'], 1);
				
				_global.trace(indent + "(MovieClip) `" + v + "` :" );
				varDump(Ob[v], indent + " . ");
				break;
			
			case 'object':
				// flag object as read to avoid recursion
				Ob[v].__vardump = Debug.ID;
				_global.ASSetPropFlags(Ob[v],['__vardump'], 1);
				
				// Dates
				if( Ob[v] instanceof Date ){
					_global.trace(indent + "(Date) `"+v+"` = '"+Ob[v].toString()+"'");
				}
				// Array
				else if( Ob[v] instanceof Array ){
					if( Ob[v].length ){
						_global.trace(indent + "(Array) `" + v + "` :");
						varDump(Ob[v], indent + " . ");
					}
					else{
						_global.trace(indent + "(Array) `" + v + "` : [empty]");
					}
				}
				// Object
				else {
					_global.trace(indent + "(Object) `" + v + "` :" );
					varDump(Ob[v], indent + " . ");
				}
				break;
			
			case 'number':
				if( isNaN(Ob[v]) ){
					_global.trace(indent + "(NaN) `" + v + '`');
				}
				else{
					_global.trace(indent + "(Number) `" + v + '` = ' + Ob[v]);
				}
				break;
			
			case 'function':
				_global.trace(indent + "(Function) `" + v + '`');
				break;
			
			default:
				_global.trace(indent + "("+t+") `" + v + '` = "' + Ob[v]+'"');
			}
		}
		if( nElements == 0 ){
			_global.trace(indent + "[empty]");
		}
	}



	
	
	
	
}