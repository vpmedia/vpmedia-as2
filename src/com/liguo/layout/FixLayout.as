

/**
 * Le FixLayout sert à afficher les composants dans une matrice dont la taille des cellules est fixe
 * 
 * usage : myContainer.setLayout(new FixLayout([50,400,50],[20,100,40]));
 */
import com.liguo.layout.*;

class com.liguo.layout.FixLayout implements Layout {
		
		
	public static var className:String = "FixLayout";
	public static var classPackage:String = "com.liguo.layout";
	public static var version:String = "0.2.0";
	public static var author:String = "Nicolas Désy (liguorien)";
	public static var link:String = "http://www.liguorien.com";
	
	
	/**
	 * axe horizontal	
	 */	
	private var _horizontalAxis:Array;
		
	/**
	 * axe vertical
	 */	
	private var _verticalAxis:Array;
		
		
	/**
	 *@constructor
	 *
	 *L'axe horizontal contient la largeur des cellule
	 *L'axe vertical contient la hauteur des cellules
	 *
	 * exemple : (ce n'est pas à l'échelle ;P )
	 *
	 * new FixLayout([10,50],[20,50]);
	 *
	 * ________________________
	 * |10x20 | 50x20         |
	 * |------|---------------|
	 * |10x50 | 50x50         |
	 * |      |               |
	 * -----------------------|
	 * 
	 *
	 *@param x:Array axe horizontal	
	 *@param y:Array axe vertical
	 */
	public function FixLayout (x:Array, y:Array) {			
		_horizontalAxis = x;
		_verticalAxis = y;			
	}
	
	
	/**
	 *assigne l'axe horizontal
	 */
	public function setHorizontalAxis (axis:Array) : Void {
		_horizontalAxis = axis;
	}
	
	/**
	 *assigne l'axe vertical
	 */
	public function setVerticalAxis (axis:Array) : Void {
		_verticalAxis = axis;
	}
	
	/**
	 *Réactualise la position et la taille des enfants d'un container
	 *cette méthode est invoqué par le container en question
	 *@param c:Container Le container
	 */
	public function doLayout (c:Container) : Void {		
		c.getMC();
		
		var paddingLeft:Number = c.getPaddingLeft(); 
		var paddingTop:Number = c.getPaddingTop();	
		var paddingBottom:Number = c.getPaddingBottom(); 
		var paddingRight:Number = c.getPaddingRight();		
		
					
		var maxX:Number = _horizontalAxis.length;				
		
		var iX:Number = 0;
		var iY:Number = 0;
		var posX:Number = paddingLeft;
		var posY:Number = paddingTop;			
		
		
		//change the axis scope
		var aX:Array = _horizontalAxis;
		var aY:Array = _verticalAxis;
		
		var cp:Array = c.getComponents(); //the components
		var l:Number = cp.length; //the number of component	
		var i:Number = -1; 		
		
		//draw the components
		while(++i < l){						
			
			with(cp[i]){					
				resizeTo(aX[iX] - getMarginLeft() - getMarginRight() - paddingRight - paddingLeft , aY[iY] - paddingBottom - paddingTop - getMarginTop() - getMarginBottom());
				draw();
				moveTo(posX + getMarginLeft(), posY + getMarginTop());				
			}		
			
			posX += aX[iX];						
			//if it's the row's end			
			if(++iX >= maxX){		
				//change row		
				posX = paddingTop;
				iX = 0;		
				posY += aY[iY++]; //compute the next row vertical position			
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
	 *Invoqué par le Container lorsque le layout ne lui est pas assigné
	 *@param c:Container Le container
	 */
	public function onRemoveLayout (c:Container) : Void {
		
	}
}


