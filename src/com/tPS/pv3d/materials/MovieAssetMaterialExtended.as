import org.papervision3d.materials.MovieAssetMaterial;
import flash.display.BitmapData;
import flash.geom.Matrix;

/**
 * @author tPS
 */
class com.tPS.pv3d.materials.MovieAssetMaterialExtended extends MovieAssetMaterial {
	
	function MovieAssetMaterialExtended(id : String, transparent : Boolean, attachedMovieContainer : MovieClip, initObject : Object) {
		super(id, transparent, attachedMovieContainer, initObject);
	}
	
	/**
	* Updates animated MovieClip bitmap.
	*
	* Draws the current MovieClip image onto bitmap.
	*/
	public function updateBitmap($frame:Number) : Void {
		
		var tex :BitmapData = this.bitmap;
		var mov :MovieClip  = this.movie;
		
		mov.gotoAndStop($frame);

		tex.fillRect( tex.rectangle, this.fillColor );

		var mtx:Matrix = new Matrix();
		mtx.scale( mov._xscale/100, mov._yscale/100 );

		tex.draw( mov, mtx, mov.transform.colorTransform );
	}

}