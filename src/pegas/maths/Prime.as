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

/**
 * Implements the static behaviours of the Prime Class.
 * @author eKameleon
 */
class pegas.maths.Prime 
{

	/**
	 * Defines an array of all primes between 'from' and 'n' inclusive, positive but restricted integer value, ignores decimals.
	 * @return a array representation of all primes between {@code from} and {@code n} inclusive}
	 */
	static public function findPrimeFrom(n:Number,from:Number):Array 
	{
		n |= 0 ;
        from |= 0 ;
        var i,j:Number;
        var aOut:Array = [];
        var aCount:Array = [];
        if (!from) from = 0 ;
        else from -= 1 ;
        n += 1 ;
        for (i=0 ; i<n; i++) 
        {
        	aCount[i] = 0;
        }
        var sqrtN:Number = Math.round(Math.sqrt(n+1));
        var last:Number = 2 ;
        for (i=2 ; i<=sqrtN ;i++ ) 
        {
            if (aCount[i]==0) 
            {
                for (j=last*i ; j<n ; j+=i ) 
                {
                	aCount[j] = 1 ;
                }
                last = i ;
            }
        }
        for (i=n-1 ;i>from ; i--) 
        {
        	if (aCount[i] == 0) 
        	{
        		aOut.push(i);
        	}
        }
        return aOut;
    }

	/**
	 * Defines an array of all primes between 2 and 'n' inclusive.
	 */
	static public function generatePrimes(limit:Number):Array 
	{
		var b:Boolean ;
		var a:Array = new Array() ;
		var i:Number = 1 ;
		while (++i<=limit) if (isPrime(i)) a.push(i) ;
		return a ;
	}

	/**
	 * Boolean for 'isPrime' integer condition, ignores decimals.
	 * Successive division.
	 */
	static public function isPrime(n:Number):Boolean 
	{ 
		if (n<3) return ( n == 2 ) ; 
		else if ((n%2) == 0) return false ;
		var i:Number = 3 ;
		while (i*i <= n) {
			if ( (n%i) == 0 ) return false ;
			i+= 2 ;
		}
		return true ;
	}
	
	/**
	 * Defines prime factors of 'n', positive but restricted integer value, ignores decimals.
	 * @return a string representation of the multiplication of primes of 'n'.
	 */
	static public function primeFactor(n:Number):String 
	{
        var bFlag:Boolean;
        n |= 0;
        if (n==1)
        {
        	return "1";
        }
        var temp:Number = n;
        var delim:String = "*";
        var sFactor:String = "";
        while (1) 
        {
            if (temp%2==0) 
            {
                temp /= 2;
                sFactor += 2+delim;
            }
            else 
            {
            	break;
            }
        }
        var num:Number = 3;
        while (1<temp) 
        {
            bFlag = true;
            while (bFlag) 
            {
                if (temp%num==0) 
                {
                    temp /= num;
                    sFactor += num+delim;
                }
                else 
                {
                	bFlag = false;
                }
            }
            num += 2;
        }
        return sFactor.substr(0,-1);
    }
	
	/**
	 * Defines total of relative primes of 'n'.
	 */
	static public function totient(n:Number):Number 
	{
        var k:Number = 1;
        var j:Number;
        if (n%2==0) j++;
        for (j=3;j<=n;j+=2) 
        {
        	if (Prime.isPrime(j)) 
        	{
        		k++;
        	}
        }
        return k;
    }
	
}

