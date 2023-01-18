import de.popforge.engine.w3d.TriMesh;
import de.popforge.engine.w3d.TriPoly;
import de.popforge.engine.w3d.UVCoord;
import de.popforge.engine.w3d.Vertex;

/*
 * Parsing *.ASE Files
 * AsciiExport Version  2,00 (3dmax R6)
 * 
 * can only handle one mesh definition
 * 
 * André Michelle 09/2005
 */

class de.popforge.engine.w3d.TriMeshParser
{
	static public function parseASEFormat( triMesh: TriMesh, url: String ): Void
	{
		var triPoly: TriPoly;

		var tripolies: Array;
		var vertices: Array = new Array;
		var uvCoordinates: Array = new Array;
		
		var lv: LoadVars = new LoadVars();
		
		//-- here come spaghetti, but its only a boring parser --//
		
		lv.onLoad = function( sucess: Boolean ): Void
		{
			if( !sucess ) return;
			
			var lines: Array = unescape( this ).split( '\r\n' );
			var line: String;
			var chunk: String;
			var content: String;
			
			var i: Number;
			
			while( lines.length )
			{
				line = String( lines.shift() );
				
				//-- clear white space from beginn
				line = line.substr( line.indexOf( '*' ) + 1 );
				
				//-- clear closing brackets
				if( line.indexOf( '}' ) >= 0 ) line = '';
				
				//-- get chunk description
				chunk = line.substr( 0, line.indexOf( ' ' ) );
				
				switch( chunk )
				{
					case 'MESH_NUMFACES':
					
						triMesh.triPolies = tripolies = new Array();
						
						var num: Number = parseInt( line.substr( line.lastIndexOf( ' ' ) ) );
						
						while( --num > -1 )
						{
							tripolies.push( new TriPoly( triMesh ) );
						}
						
						break;
					
					case 'MESH_VERTEX_LIST':
					
						while( ( content = String( lines.shift() ) ).indexOf( '}' ) < 0 )
						{
							content = content.substr( content.indexOf( '*' ) + 1 );
							var mvl: Array = content.split(  '\t' ); // separate here
							
							//-- switch coordinates to fit my coordinate system
							vertices.push( new Vertex( parseFloat( mvl[1] ), -parseFloat( mvl[3] ), parseFloat( mvl[2] ) ) );
						}
						
						break;
						
					case 'MESH_FACE_LIST':
					
						var num: Number = 0;
						
						while( ( content = String( lines.shift() ) ).indexOf( '}' ) < 0 )
						{
							content = content.substr( content.indexOf( '*' ) + 1 );
							
							var mfl: Array = content.split(  '\t' )[0]; // ignore: [MESH_SMOOTHING,MESH_MTLID]
							var drc: Array = mfl.split( ':' ); // separate here
							var con: String;
							
							triPoly = TriPoly( tripolies[num] );
							
							triPoly.vertices =
							[
								vertices[ parseInt( con.substr( 0, ( con = drc[2] ).lastIndexOf( ' ' ) ) ) ],
								vertices[ parseInt( con.substr( 0, ( con = drc[3] ).lastIndexOf( ' ' ) ) ) ],
								vertices[ parseInt( con.substr( 0, ( con = drc[4] ).lastIndexOf( ' ' ) ) ) ]
							];
							
							triPoly.updateNormal();
							
							num++;
						}
						break;
						
					case 'MESH_TVERTLIST':
					
						while( ( content = String( lines.shift() ) ).indexOf( '}' ) < 0 )
						{
							content = content.substr( content.indexOf( '*' ) + 1 );
							var mtvl: Array = content.split(  '\t' ); // separate here
							
							uvCoordinates.push( new UVCoord( parseFloat( mtvl[1] ), parseFloat( mtvl[2] ) ) );
						}
						break;
						
					case 'MESH_TFACELIST':
					
						var num: Number = 0;
					
						while( ( content = String( lines.shift() ) ).indexOf( '}' ) < 0 )
						{
							content = content.substr( content.indexOf( '*' ) + 1 );
							var mtfl: Array = content.split(  '\t' ); // separate here
							
							TriPoly( tripolies[num] ).uv_map =
							[
								uvCoordinates[parseInt( mtfl[1] )],								uvCoordinates[parseInt( mtfl[2] )],								uvCoordinates[parseInt( mtfl[3] )]
							];
							
							num++;
						}
						break;
				}
			}
			
			triMesh.onLoad();
		};
		
		lv.load( url );
	}	
	
	static public function fromObjectAndIndices( vertCoordinates: Array, vertIndices: Array, texCoordinates: Array, texIndices: Array ): TriMesh
	{
		var triMesh: TriMesh = new TriMesh();
		var vertices: Array = new Array;
		var uvCoordinates: Array = new Array;
		var triPoly: TriPoly;
		var vertex: Vertex;

		var i: Number;
		
		//-- parse vertices
		var vObj: Object;
		i = vertCoordinates.length;
		while( --i > -1 )
		{
			vObj = vertCoordinates[i];
			
			vertices[i] = new Vertex( vObj.x, vObj.y, vObj.z );
		}
		
		//-- parse TriPoly
		var vIArr: Array;
		var tIArr: Array;
		i = vertIndices.length;
		while( --i > -1 )
		{
			triPoly = new TriPoly( triMesh );
			vIArr = vertIndices[i];
			tIArr = texIndices[i];
			triPoly.vertices = [ vertices[ vIArr[0] ], vertices[ vIArr[1] ], vertices[ vIArr[2] ] ];
			triPoly.updateNormal();
			triPoly.uv_map =
			[
				new UVCoord( texCoordinates[tIArr[0]][0], texCoordinates[tIArr[0]][1] ),				new UVCoord( texCoordinates[tIArr[1]][0], texCoordinates[tIArr[1]][1] ),				new UVCoord( texCoordinates[tIArr[2]][0], texCoordinates[tIArr[2]][1] )
			];
			triMesh.triPolies.push( triPoly );
		}
		
		return triMesh;
	}
}