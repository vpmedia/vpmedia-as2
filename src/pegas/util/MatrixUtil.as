/*

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  
           http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is PEGAS Framework.
  
  The Initial Developer of the Original Code is
  ALCARAZ Marc (aka eKameleon)  <vegas@ekameleon.net>.
  Portions created by the Initial Developer are Copyright (C) 2004-2007
  the Initial Developer. All Rights Reserved.
  
  Contributor(s) :
  
*/

import pegas.geom.Matrix;

/**
 * Static tool class to manipulate and transform {@code Matrix} references.
 * @author eKameleon
 */
class pegas.util.MatrixUtil 
{
	
	/**
	 * Returns {@code true} if the Matrix is the identity.
	 * @return {@code true} if the Matrix is the identity.
	 */
	static public function isIdentity( m:Matrix ):Boolean
	{
		var r:Number = m.r ;
		var c:Number = m.c ;
		for( var i:Number = 0 ; i<r ; i++ )
		{
			for( var j:Number = 0; j < c ; j++ )
			{
				if( i == j ) 
				{
					if( m[i][j] !=1 )
					{
						return false ;
					}
				}
				else 
				{
					if( m[i][j] != 0 ) 
					{
						return false ;
					}
				}
			}
		}
		return true ;
	}
	
}