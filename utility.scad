
//
// ERRORS - END EXECUTION
//

    Error = function(msg) let( has=false )
        // assertion 'has' failed - HAHA!
        assert(has,msg);

    ErrorIf = function(condition,msg) let( has=!condition )
        assert(has,msg);

    module Exit(msg) {
        has=false;
        assert(has,msg);   
    }

    module ExitIf(condition,msg) {
        has=!condition;
        assert(has,msg);   
    }

//
//
//

    SELECT = function( d1, d2, d3 ) ((d1!=undef) ? d1 : (d2!=undef) ? d2 : d3 );
    IIF = function( cond, trueCond, falseCond ) ( cond ? trueCond : falseCond );
    function is_nan(x) = x!=x;
// module ThrustBearingShowroom( omitBalls=false ) {
//     if ( true ) {
//         m = ThrustBearingModels;
//         for( i=[ 0:len(m)-1] ) {            
//             echo( str( m[i][0], " = ", m[i][1], " x ", m[i][2], " x ", m[i][3] ) );
//         }
//     } else {
//         // use to be cute to display all the models
//         // but after a ton, it will just bog down
//         m = ThrustBearingModels;
//         for( i=[ 0:len(m)-1] ) {
//             translate( [ Accumulate( m,1,i )+i*20,0,0] )
//             ThrustBearing( ThrustBearingFindModel( m[i] ), omitBalls );
//         }
//     }
//     function Accumulate( list, columnNo, maxIndex, current=0 ) =
//     // return sum( list[0..N][col#] )
//     list[current][columnNo] + (
//         ( current < maxIndex )
//             ? Accumulate( list, columnNo, maxIndex, current+1 )
//             : 0
//     );
// }