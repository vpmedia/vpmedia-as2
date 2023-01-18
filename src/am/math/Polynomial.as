class am.math.Polynomial extends Math {

	static function getQuadraticRoots ( a: Number , b: Number , c: Number ): Array {

        var b = b / a;
        var d = b * b - 4 * c / a;

		if ( d > 0 ) {

			var e = sqrt(d);

			return [ 0.5 * ( e - b ), 0.5 * ( -b - e ) ];

		} else if ( d == 0 ) {

				return [ 0.5 * -b ];

		}

		return [];

	}

	static function getCubicRoots ( c3: Number , c2: Number , c1: Number , c0: Number ): Array {

		var results = [];

		var c2 = c2 / c3;
		var c1 = c1 / c3;
		var c0 = c0 / c3;

		var a = ( 3 * c1 - c2 * c2 ) / 3;
		var b = ( 2 * c2 * c2 * c2 - 9 * c1 * c2 + 27 * c0 ) / 27;

		var offset = c2 / 3;
		var discrim = b * b / 4 + a * a * a / 27;
		var halfB = b / 2;

		if( Math.abs ( discrim ) <= .0000001 ) { discrim = 0 };

		if( discrim > 0 ){

			var e = sqrt( discrim );
			var tmp;
			var root;
			tmp =- halfB + e;

			if( tmp >= 0 ) {

				root = pow( tmp , 1 / 3 );

			} else {

				root = -pow( -tmp , 1 / 3 );

			}

			tmp = -halfB - e;

			if( tmp >= 0 ) {

				root += pow( tmp , 1 / 3 );

			} else {

				root -= pow( -tmp ,1 / 3 );

			}

			results.push( root - offset );

		} else if ( discrim < 0 ) {

			var distance=sqrt(-a/3);
			var angle=atan2(Math.sqrt(-discrim),-halfB)/3;
			var cos=cos(angle);
			var sin=sin(angle);
			var sqrt3=sqrt(3);
			results.push(2*distance*cos-offset);
			results.push(-distance*(cos+sqrt3*sin)-offset);
			results.push(-distance*(cos-sqrt3*sin)-offset);

		}else{

			var tmp;
			if( halfB >= 0 ) {
				tmp = -pow( halfB , 1 / 3 );
			} else {
				tmp = pow( -halfB , 1 / 3 );
			}
			results.push( 2 * tmp - offset );
			results.push( -tmp - offset );
		}

		return results;

	}

}