import org.papervision3d.objects.Points;
import org.papervision3d.core.proto.CameraObject3D;
import org.papervision3d.core.proto.SceneObject3D;
import org.papervision3d.core.geom.Vertex3D;
import com.tPS.pv3d.core.ControlVertex3D;
import com.tPS.utils.DataDumper;

/**
 * @author tPS
 */
 
 /**
* The SplineShape DisplayObject3D class lets you create and display flat vector shapes
*/
class com.tPS.pv3d.objects.SplineShape extends Points {
	
	private var fillStyle:Object;
	private var lineStyle:Object;
	
	public function SplineShape(vertices : Array, initObject : Object, $fs:Object, $ls:Object) {
		super(vertices, initObject);
		fillStyle = ($fs != undefined) ? $fs : {type:"color",col:0x000000, alpha:100};
		lineStyle = ($ls != undefined) ? $ls : {thickness:1, rgb:0xFFFFFF, alpha:100, pixelHinting:true, noScale:"none", capsStyle:"none", jointStyle:"miter", miterLimit:4};
	}
	

	// ___________________________________________________________________________________________________
	//                                                                                         R E N D E R
	// RRRRR  EEEEEE NN  NN DDDDD  EEEEEE RRRRR
	// RR  RR EE     NNN NN DD  DD EE     RR  RR
	// RRRRR  EEEE   NNNNNN DD  DD EEEE   RRRRR
	// RR  RR EE     NN NNN DD  DD EE     RR  RR
	// RR  RR EEEEEE NN  NN DDDDD  EEEEEE RR  RR

	/**
	* Render object.
	*
	* @param	scene	Stats object to update.
	*/
	public function render( scene :SceneObject3D )
	{
		// Render
		var container      :MovieClip        = this._container || scene.container;
		container.clear();
		container.lineStyle(lineStyle.thickness,lineStyle.rgb,lineStyle.alpha,lineStyle.pixelHinting,lineStyle.noScale,lineStyle.capsStyle,lineStyle.jointStyle,lineStyle.miterLimit);
		container.beginFill(fillStyle.col,fillStyle.alpha);
				
		var vertex:Vertex3D;
		var cntrlVert:Vertex3D;
		var i:Number = 0;
		var m:Number = vertices.length;
		container.moveTo(vertices[i].screen.x, vertices[i].screen.y);
		
		while(++i < m){
			vertex = vertices[i];			
			//draw curve is last Vertice was a Control
			if(cntrlVert != null){
				container.curveTo( vertex.screen.x, vertex.screen.y, cntrlVert.screen.x, cntrlVert.screen.y);
				cntrlVert = null;
			}else{
				//skip if vertex is a controlpoint
				if(vertex instanceof ControlVertex3D){
					cntrlVert = vertex;
				}else{
				//just draw a line
					container.lineTo(vertex.screen.x, vertex.screen.y);
				}
			}
		}
		
		container.endFill();
		
	}
	
	
	public function set _fillStyle($fs:Object) : Void {
		fillStyle = $fs;
	}
	
	public function set _lineStyle($ls:Object) : Void {
		lineStyle = $ls;
	}
	
	
}