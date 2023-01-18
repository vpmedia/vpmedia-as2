/**
 * @author loop
 */
class ch.sfug.utils.XPath {

	/**
	 * returns a node value or attribute value of a xpath command
	 */
	public static function getValue( xpath:String, node:XMLNode ):String {
		if( node == undefined ) trace( "you need a node to execute xpath: " + xpath );
		var split:Array = xpath.split( "/" );
		var lastnode:String = String( split[ split.length - 1 ] );
		//check if last node is an attribute
		if( lastnode.charAt( 0 ) == "@" ) {
			var attr:String = String( split.pop() ).substr( 1 );;
			var n:XMLNode = XMLNode( solveNode( [ node ], split )[ 0 ] );
			return n.attributes[ attr ];
		} else {
			var n:XMLNode = ( lastnode != "" ) ? XMLNode( solveNode( [ node ], split )[ 0 ] ) : node;
			return n.childNodes[0].nodeValue;
		}
	}

	/**
	 * returns an array of xmlnodes depending on the xpath query
	 */
	public static function getNodes( xpath:String, node:XMLNode ):Array {
		if( node == undefined ) trace( "you need a node to execute xpath: " + xpath );
		var split:Array = xpath.split( "/" );
		return solveNode( [ node ], split );
	}

	/**
	 * returns the first node of a xpath query
	 */
	public static function getNode( xpath:String, node:XMLNode ):XMLNode {
		return XMLNode( getNodes( xpath, node )[ 0 ] );
	}

	/**
	 * recursion break out of the path
	 * returns the xmlnode specified by the path
	 */
	private static function solveNode(nodes:Array,path:Array):Array {

		// dig deeper in the xml tree
		// get first path node
		// if we cant split more up. we are looking for the leaf
		if( path.length <= 0 || nodes == undefined ) {
			return nodes;
		} else {
			var nodename:String = String( path.shift() );
			return solveNode( getNodesOfName(nodes,nodename) , path );
		}
	}

	/**
	 * returns the childNode of the specified node that correspond to the name
	 */
	private static function getNodesOfName(nodes:Array,name:String):Array {

		var result:Array = new Array();

		for (var k : Number = 0; k < nodes.length; k++) {

			var node:XMLNode = XMLNode( nodes[ k ] );
			var num:Number = undefined;

			// check if its a name in form of: name[num]
			if( name.charAt(name.length-1) == "]" ) {
				var split:Array = name.split( "[" );
				var numtxt:String = split[ 1 ];
				name = split[ 0 ];
				num = Number( numtxt.substr( 0, numtxt.length - 1 ) );
				// check if the conversion works well, otherwise set to default 0
				if( isNaN(num) ) {
					num = 0;
				}
			}

			// counter for the [x] nodes
			var j:Number = 0;
			// do the main loop over the childs
			for( var i:Number = 0; i < node.childNodes.length; i++ ) {
				var a:XMLNode = node.childNodes[i];
				// if the names correspond increase counter for [x] check
				if( a.nodeName == name || name == "*" ) {
					// if no number is specified: no[x] take it with the same name
					if( num == undefined ) {
						result.push( a );
					} else {
						// else return node when the counter is correct
						if( j == num ) return [ a ];
					}
					j++;
				}
			}
		}

		// no node is found return null
		return result;
	}

}