

/**
 * Le SemiFixLayout est comme un GridLayout sauf que la taille des cellules est fixe
 *� l'exeption d'une colonne et/ou rang�
 * 
 * usage : myContainer.setLayout(new SemiFixLayout([100,null,100],[100,null,100]));
 *
 *@author Nicolas Desy  aka  liguorien   http://www.liguorien.com
 */

import com.liguo.layout.*;

class com.liguo.layout.SemiFixLayout implements Layout {
		
		
	public static var className:String = "SemiFixLayout";
	public static var classPackage:String = "com.liguo.layout";
	public static var version:String = "0.2.0";
	public static var author:String = "Nicolas D�sy (liguorien)";
	public static var link:String = "http://www.liguorien.com";
		
		
	private var _horizontalAxis:Array; 
	private var _horizontalNull:Number;
	private var _horizontalReserved:Number; 
		
	private var _verticalAxis:Array; 
	private var _verticalNull:Number; 
	private var _verticalReserved:Number; 

		
	/**
	 *@constructor
	 *
	 *Les axes contiennent la taille des cellules. Si vous ne savez pas la taille d'une cellule, 
	 * vous pouvez mettre "null" et elle sera redimensionn� automatiquement 
	 *
	 *@param x:Array axe horizontal
	 *@param y:Array axe vertical
	 */
	public function SemiFixLayout (x:Array, y:Array) {	
		
		_horizontalAxis = x;
		_verticalAxis = y;		
		_horizontalReserved = _verticalReserved = 0;
		
		//calcul les espace reserv� et null pour l'axe horizontal
		var i:Number = x.length;		
		while(--i > -1)(x[i]) ? _horizontalReserved += x[i] : _horizontalNull = i;		
	
		//calcul les espace reserv� et null pour l'axe vertical			
		i = y.length;		
		while(--i > -1)(y[i]) ? _verticalReserved += y[i] : _verticalNull = i;		
	}
	
		
	/**
	 *R�actualise la position et la taille des enfants d'un container
	 *cette m�thode est invoqu� par le container en question
	 *@param c:Container Le container
	 */
	public function doLayout (c:Container) : Void {		
		
		//petite patch pour s'assurer que le clip principale du container est cr��
		c.getMC(); 
		
		var paddingLeft:Number = c.getPaddingLeft(); 
		var paddingTop:Number = c.getPaddingTop();	
		var paddingBottom:Number = c.getPaddingBottom(); 
		var paddingRight:Number = c.getPaddingRight();		
		
		//assigne la taille disponible au colonne/rang� marqu� "null" 
		_horizontalAxis[_horizontalNull] = c.getWidth() - paddingLeft - paddingRight - _horizontalReserved;
		_verticalAxis[_verticalNull] = c.getHeight() - paddingTop - paddingBottom - _verticalReserved;
				
		var maxX = _horizontalAxis.length;				
		
		var iX:Number = 0;
		var iY:Number = 0;
		var posX:Number = paddingLeft;
		var posY:Number = paddingTop;			
		
		
		//change le scope pour y acc�der dans le " with(cp[i]) "
		var aX:Array = _horizontalAxis;
		var aY:Array = _verticalAxis;
		
		var cp:Array = c.getComponents();
		var l:Number = cp.length;
		var i:Number = -1; 		
		
		//it�ration sur tout les composants
		while(++i < l){						
			
			with(cp[i]){					
				resizeTo(
					aX[iX]-getMarginLeft()-getMarginRight()-paddingRight-paddingLeft,
					aY[iY]-paddingBottom-paddingTop-getMarginTop()-getMarginBottom()
				);
				draw();
				moveTo(posX + getMarginLeft(), posY + getMarginTop());				
			}		
			
			posX += aX[iX];						
			//si c'est la derni�re cellule de la rang�			
			if(++iX >= maxX){		
				//on change de rang�
				posX = paddingTop;
				iX = 0;		
				posY += aY[iY++]; //calcule la prochaine coordonn� vertical
			}		
		}
	}
	
	
	/**
	 *Invoqu� par le Container lorsque le layout lui est assign�
	 *@param c:Container Le container
	 */
	public function onSetLayout(c:Container) : Void {
		
	}	
	
	/**
	 *Invoqu� par le Container lorsque le layout ne lui est plus assign�
	 *@param c:Container Le container
	 */
	public function onRemoveLayout(c:Container) : Void {
		
	}
}
