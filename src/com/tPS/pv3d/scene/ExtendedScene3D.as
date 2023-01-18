import org.papervision3d.scenes.Scene3D;
import org.papervision3d.core.proto.DisplayObject3D;
import org.papervision3d.core.proto.MaterialObject3D;
import org.papervision3d.Papervision3D;

/**
 * @author tPS
 */
class com.tPS.pv3d.scene.ExtendedScene3D extends Scene3D {
	
	public function ExtendedScene3D(container : MovieClip) {
		super(container);
	}
	
	/**
	* Removes an DisplayObject3D or a Material3D element in the scene.
	*
	* @param	sceneElement	Element to add.
	*/
	public function pop( sceneElement ) : Void {
		var i:Number = objects.length;
		while(--i > -1){
			if(objects[i] == sceneElement){
				Papervision3D.log( "SceneObject3D.pop(): Object removed from Scene.");
				break;
			}
		}
		Papervision3D.log( "SceneObject3D.pop(): function end.");		
	}

}