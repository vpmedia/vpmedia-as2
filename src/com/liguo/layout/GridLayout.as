

/**
 * Un GridLayout affiche les composants dans un matrice de 2 dimension
 * Tous les composants seront redimensionnés à la même dimension
 * 
 * usage :  myContainer.setLayout(new GridLayout(3,3));
 */

import com.liguo.layout.*;

class com.liguo.layout.GridLayout implements Layout {
	
	public static var className:String = "GridLayout";
	public static var classPackage:String = "com.liguo.layout";
	public static var version:String = "0.2.0";
	public static var author:String = "Nicolas Désy (liguorien)";
	public static var link:String = "http://www.liguorien.com";
	
	
	private var _w:Number; //le nombre de cellules horizontal
	private var _h:Number; //le nombre de cellules vertical
	
	/**
	 *@constructor
	 *@param width le nombre de cellules horizontal
	 *@param height le nombre de cellules vertical
	 */
	public function GridLayout (width:Number, height:Number) {
		_w = width;
		_h = height;		
	}
	
	
	/**
	 *Réactualise la position et la taille des enfants d'un container
	 *cette méthode est invoqué par le container en question
	 *@param c:Container Le container
	 */
	public function doLayout (c:Container) : Void {		
		
		var paddingLeft:Number = c.getPaddingLeft();
		var paddingTop:Number = c.getPaddingTop();		
		
		var cellWidth:Number = (c.getWidth() - paddingLeft - c.getPaddingRight()) / _w; 
		var cellHeight:Number = (c.getHeight() - paddingTop - c.getPaddingBottom()) / _h; 	
		
		var iX:Number = 0; //index horizontal 			
		var iY:Number = 0; //index vertical	
		
		var cp:Array = c.getComponents();
		var size:Number = cp.length;		
		var i:Number = -1;
		
		while(++i < size){					
			
			with(cp[i]){						
				resizeTo(cellWidth - getMarginLeft() - getMarginRight(), cellHeight - getMarginTop() - getMarginBottom());
				draw();
				moveTo(paddingLeft + getMarginLeft() + cellWidth*iX, paddingTop + getMarginTop() + cellHeight*iY);
			}		
			
			//si c'est la dernière cellule de la rangé		
			if(++iX >= _w){
				//on change de rangé
				iX = 0;
				iY++;
			}
		}		
	}
	
	
	/**
	 *Invoqué par le Container lorsque le layout lui est assigné
	 *@param c:Container Le container
	 */
	public function onSetLayout (c:Container) : Void {
		
	}
	
	
	/**
	 *Invoqué par le Container lorsque le layout ne lui est plus assigné
	 *@param c:Container Le container
	 */
	public function onRemoveLayout (c:Container) : Void {
		
	}
}
