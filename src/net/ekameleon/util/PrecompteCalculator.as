/*

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  
           http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is net.ekameleon Framework.
  
  The Initial Developer of the Original Code is
  ALCARAZ Marc (aka eKameleon)  <vegas@ekameleon.net>.
  Portions created by the Initial Developer are Copyright (C) 2004-2005
  the Initial Developer. All Rights Reserved.
  
  Contributor(s) :
  
*/

package net.ekameleon.util
{
	
	public class AgessaCalculator
	{
		
		// ----o Constructor
		
		public function AgessaCalculator( value:Number=0 )
		{
		
			this.value = isNaN(value) ? 0 : value ;
			
		}
		
		// ----o Constants
		
		static public const MAX_PERCENT:Number = 0.1 ;
		static public const MIN_PERCENT:Number = 0.97 ;
		
		static public const CSG:Number = 7.5 ;
		static public const CRDS:Number = 0.5 ;
		
		// ----o Private Properties
		
		public var value:uint ;
		
		// -----o Public Methods

		public function get authors():Number
		{
			return Math.round(value / 100) ;
		}

		/**
		 * Renvoi le total des cotisations à reverser à l'agessa.
		 */
		public function get contributions():Number
		{
			return crds + csg + widowhood + authors ;
		}
	
		/**
		 * Renvoi le montant du C.R.D.S.
		 */
		public function get crds():Number
		{
			return Math.round(CRDS * (value * MIN_PERCENT) / 100) ;
		}

		/**
		 * Renvoi le montant de la C.S.G.
		 */
		public function get csg():Number
		{
			return Math.round(CSG * (value * MIN_PERCENT) / 100) ;
		}
		
		/**
		 * Renvoi le total à reverser à l'artiste.
		 */
		public function get total():Number
		{
			return value - (crds + csg + widowhood) ;
		}	
		
		/**
		 * Renvoi la cotisation de maladie veuvage 0.85% du montant brut HT
		 */
		public function get widowhood():Number
		{
			return Math.round(0.85 * value / 100) ;
		}

		public function toFormatString():String
		{
			var calculator:AgessaCalculator = this ;
			var s:String = "" ;
			s += "> Montant brut HT : " + calculator.value + " €\r" ;
			s += "  * Cotisation maladie veuvage 0.85 % du montant brut HT : " + calculator.widowhood + " €\r" ;
			s += "  * C.S.G taux 7.50 % de 97 % du montant brut HT : " + calculator.csg + " €\r" ;
			s += "  * C.R.D.S taux 0.50 % de 97% du montant brut HT : " + calculator.crds + " \r" ;
			s += "  * Contribution à acquitter par le diffuseur (1% du brut HT) : " + calculator.authors + " €\r" ;
			s += "> Total des cotisations : " + calculator.contributions + " €\r" ;
			s += "> Total à reverser : " + calculator.total + " €\r"  ;
			return s ;
		}
		
	}
}