

/**
 *Le FlowLayout affiche les composants à leur dimension préféré 
 *et procède à l'alignement horizontal et vertical
 
 * usage :  myContainer.setLayout(FlowLayout.LEFT_MIDDLE);
 */

import com.liguo.layout.*;

class com.liguo.layout.FlowLayout implements Layout {
	
	
	public static var className:String = "FlowLayout";
	public static var classPackage:String = "com.liguo.layout";
	public static var version:String = "0.2.0";
	public static var author:String = "Nicolas Désy (liguorien)";
	public static var link:String = "http://www.liguorien.com";
	
	
	public static var LEFT_TOP:FlowLayout = new FlowLayout(Align.LEFT, Align.TOP);
	public static var LEFT_MIDDLE:FlowLayout = new FlowLayout(Align.LEFT, Align.MIDDLE);
	public static var LEFT_BOTTOM:FlowLayout = new FlowLayout(Align.LEFT, Align.BOTTOM);
	public static var CENTER_TOP:FlowLayout = new FlowLayout(Align.CENTER, Align.TOP);
	public static var CENTER_MIDDLE:FlowLayout = new FlowLayout(Align.CENTER, Align.MIDDLE);
	public static var CENTER_BOTTOM:FlowLayout = new FlowLayout(Align.CENTER, Align.BOTTOM);
	public static var RIGHT_TOP:FlowLayout = new FlowLayout(Align.RIGHT, Align.TOP);
	public static var RIGHT_MIDDLE:FlowLayout = new FlowLayout(Align.RIGHT, Align.MIDDLE);
	public static var RIGHT_BOTTOM:FlowLayout = new FlowLayout(Align.RIGHT, Align.BOTTOM);
	
	public var align:Align;
	public var valign:Align;
	
	/**
	 *Constructor
	 *@param a:Alignement horizontal alignement (optional, default:LEFT)
	 *@param v:Alignement vertical alignement (optional, default:TOP)
	 */
	public function FlowLayout (a:Align, v:Align) {		
		align = a ? a : Align.LEFT;
		valign = v ? v : Align.TOP;				
	}
	
	
	/**
	 *Réactualise la position et la taille des enfants d'un container
	 *cette méthode est invoqué par le container en question
	 *@param c:Container Le container
	 */
	public function doLayout (con:Container) : Void {		
		
		var rows:Array = [];		
		var nbRow:Number = 0;		
		rows[nbRow] = [];
				
		var paddingLeft:Number = con.getPaddingLeft();
		
		//largeur interne du container
		var containerWidth:Number = con.getWidth() - paddingLeft - con.getPaddingRight();
		
		//hauteur interne du container
		var containerHeight:Number = con.getHeight() - con.getPaddingBottom() - con.getPaddingTop();
		
		//les coordonné du dernier composant positioné
		var lastX:Number = paddingLeft;
		var lastY:Number = con.getPaddingTop();
		
		//la coordonné vertical la plus grande de la rangé courante
		var maxH:Number = 0;		
		
		var cp:Array = con.getComponents();		
		var size:Number = cp.length;		
		var i:Number = -1;
		
		while(++i < size){
			
			var c:Component = cp[i];			
			
			var cW:Number = c.getPreferredWidth() + c.getMarginRight() + c.getMarginLeft();
			
			//s'il y a de la place pour un autre composant sur cette rangé
			if(lastX == paddingLeft || lastX + cW < containerWidth) { 
				
				//calcul la coordonné horizontal du composant
				var posX:Number = lastX + c.getMarginLeft();
											
				c.draw(); //affiche le composant
				
				//positionne le composant une première fois (sans l'alignement)	
				c.moveTo(posX,lastY + c.getMarginTop());
				
				//calcul la coordonné horizontal du prochain composant
				lastX = posX + c.getPreferredWidth() + c.getMarginRight();		
				
				//vérifie si le composant est le plus grand de la rangé
				var posY:Number = c.getMarginTop() + c.getPreferredHeight() + c.getMarginBottom();
				if(posY > maxH){
					maxH = posY;
				}
				
				//stock le composant pour l'alignement
				rows[nbRow].push(c);
				rows[nbRow].lastX = lastX;				
			}	
			else {				
				rows[++nbRow] = [];				
				lastY += maxH;
				lastX = paddingLeft;
				maxH = 0;	
				i--;			
			}				
		} 		
		
		//** PROCÈDE À L'ALIGNEMENT **//
		
		//calcul le facteur vertical de l'alignement
		var yFactor:Number = valign.getPosition(containerHeight - (lastY + maxH));				
		var i:Number = nbRow + 1;
		while(--i > -1){	
				
			var row = rows[i];
				
			//calcul le facteur horizontal de l'alignement
			var xFactor:Number = align.getPosition(containerWidth - row.lastX);			
			var j = row.length;
			
			//positionne tous les composants de cette rangé à leur position finale
			while(--j > -1) row[j].moveBy(xFactor,yFactor);			
		}		

		var mc:MovieClip = con.getMC();
		if(!mc.__mask__){	
			_drawMask(mc);			
		}
		
		mc.__mask__._width = con.getWidth() + 1;
		mc.__mask__._height = con.getHeight() + 1;		
	}
	
	
	private function _drawMask(mc:MovieClip){			
		mc.createEmptyMovieClip("__mask__",mc.getNextHighestDepth());
		with(mc.__mask__){
			moveTo(0,0);
			beginFill(0x000000);
			lineTo(10,0);
			lineTo(10,10);
			lineTo(0,10);
			lineTo(0,0);
			endFill();				
		} 
		mc.setMask(mc.__mask__);
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
		var mc:MovieClip = c.getMC();
		if(mc.__mask__){
			mc.__mask__.removeMovieClip();
		}
	}
}
