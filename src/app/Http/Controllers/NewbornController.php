<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Maatwebsite\Excel\Facades\Excel;
use App\Exports\NewbornExport;
use Carbon\Carbon;


class NewbornController extends Controller
{
    public function index(){
    	$newborn = DB::table('t_resident_basic_info AS R')
            ->join('t_hs_newborn AS NB', 'NB.RESIDENT_ID', 'R.RESIDENT_ID')
            ->where('R.DATE_OF_BIRTH', '>=', Carbon::today()->subDays(28))
    		->select(
    			 'R.RESIDENT_ID'
                ,'R.FIRSTNAME'
                ,'R.MIDDLENAME'
                ,'R.LASTNAME'
                ,'R.ADDRESS_UNIT_NO'
                ,'R.ADDRESS_PHASE'
                ,'R.ADDRESS_BLOCK_NO'
                ,'R.ADDRESS_HOUSE_NO'
                ,'R.ADDRESS_STREET'
                ,'R.ADDRESS_SUBDIVISION'
                ,'R.ADDRESS_BUILDING'
                ,'R.DATE_OF_BIRTH'
                ,'NB.NEWBORN_ID'
    		)
    		->get();

        $nonresident = DB::table('t_nonresident_basic_info AS NR')
            ->join('t_hs_newborn AS NB', 'NB.NONRESIDENT_ID', 'NR.NONRESIDENT_ID')
            ->where('NR.BIRTHDATE', '>=', Carbon::today()->subDays(28))
            ->select(
                 'NR.NONRESIDENT_ID'
                ,'NR.FIRST_NAME'
                ,'NR.MIDDLE_NAME'
                ,'NR.LAST_NAME'
                ,'NR.BIRTHDATE'
            )->get();

            $fdsa = DB::table('t_nonresident_basic_info')
                ->select()
                ->get();
           // dd($fdsa);
    	return view('healthservices.newborn', compact('newborn', 'nonresident'));
    }

    public function Export(){

        return Excel::download(new NewbornExport, 'newborn.xlsx');
    }

    public function CRUDNewborn(Request $request){
    	$RESIDENT_ID = $request->RESIDENT_ID;
    	$TYPE_OF_HOME_RECORD = $request->TYPE_OF_HOME_RECORD;
    	$BIRTH_WEIGHT = $request->BIRTH_WEIGHT;
    	$BIRTH_LENGTH = $request->BIRTH_LENGTH;
    	$HAD_BCG = $request->HAD_BCG;
    	$HAD_HEPA_B = $request->HAD_HEPA_B;
    	$HAD_NEWBORN_SCREENING = $request->HAD_NEWBORN_SCREENING;
    	$HAD_BREASTFEED = $request->HAD_BREASTFEED;
    	$DO_A = $request->DO_A;
    	$DO_B = $request->DO_B;
    	$DO_C = $request->DO_C;
    	$DO_D = $request->DO_D;
    	$DO_E = $request->DO_E;
    	$DO_F = $request->DO_F;
    	$SOURCE_OF_SERVICE_RESERVED = $request->SOURCE_OF_SERVICE_RESERVED;		
    	$NEWBORN_ID = $request->NEWBORN_ID;
    	$CRUD_STATUS = $request->CRUD_STATUS;

        $FIRSTNAME = $request->FIRSTNAME;
        $MIDDLENAME = $request->MIDDLENAME;
        $LASTNAME = $request->LASTNAME;
        $SEX = $request->SEX;
        $BIRTHDATE = $request->BIRTHDATE;


    	if($CRUD_STATUS == "Add"){
    		$update = DB::table('t_hs_newborn')
             ->where('NEWBORN_ID', $NEWBORN_ID)
             ->update(
                array(
                    'TYPE_OF_HOME_RECORD' => $TYPE_OF_HOME_RECORD
                    ,'BIRTH_WEIGHT' => $BIRTH_WEIGHT
                    ,'BIRTH_LENGTH' => $BIRTH_LENGTH
                    ,'HAD_BCG' => $HAD_BCG
                    ,'HAD_HEPA_B' => $HAD_HEPA_B
                    ,'HAD_NEWBORN_SCREENING' => $HAD_NEWBORN_SCREENING
                    ,'HAD_BREASTFEED' => $HAD_BREASTFEED
                    ,'DO_A' => $DO_A
                    ,'DO_B' => $DO_B
                    ,'DO_C' => $DO_C
                    ,'DO_D' => $DO_D
                    ,'DO_E' => $DO_E
                    ,'DO_F' => $DO_F
                    ,'SOURCE_OF_SERVICE_RESERVED' => $SOURCE_OF_SERVICE_RESERVED
                    ,'UPDATED_AT' =>  date('Y-m-d')
                )
             );      	
    	}
    	if($CRUD_STATUS == "Update"){
    		$update = DB::table('t_hs_newborn')
    		 ->where('NEWBORN_ID', $NEWBORN_ID)
    		 ->update(
    		 	array(
					'TYPE_OF_HOME_RECORD' => $TYPE_OF_HOME_RECORD
					,'BIRTH_WEIGHT' => $BIRTH_WEIGHT
					,'BIRTH_LENGTH' => $BIRTH_LENGTH
					,'HAD_BCG' => $HAD_BCG
					,'HAD_HEPA_B' => $HAD_HEPA_B
					,'HAD_NEWBORN_SCREENING' => $HAD_NEWBORN_SCREENING
					,'HAD_BREASTFEED' => $HAD_BREASTFEED
					,'DO_A' => $DO_A
					,'DO_B' => $DO_B
					,'DO_C' => $DO_C
					,'DO_D' => $DO_D
					,'DO_E' => $DO_E
					,'DO_F' => $DO_F
					,'SOURCE_OF_SERVICE_RESERVED' => $SOURCE_OF_SERVICE_RESERVED
					,'UPDATED_AT' =>  date('Y-m-d')
    		 	)
    		 );
    	}

        if($CRUD_STATUS == "Add_NonResident"){
            $insertNonResident = DB::table('t_nonresident_basic_info')
                ->insert(array(
                    'FIRST_NAME' => $FIRSTNAME
                    ,'MIDDLE_NAME' => $MIDDLENAME
                    ,'LAST_NAME' => $LASTNAME
                    ,'SEX' => $SEX
                    ,'BIRTHDATE' => $BIRTHDATE
                ));

            $nonresident_recent = DB::table('t_nonresident_basic_info')->select('NONRESIDENT_ID')->latest('NONRESIDENT_ID')->first();

            $insertNewborn = DB::table('t_hs_newborn')
                ->insert(
                    array(
                        'NONRESIDENT_ID' => $nonresident_recent->NONRESIDENT_ID
                        ,'TYPE_OF_HOME_RECORD' => $TYPE_OF_HOME_RECORD
                        ,'BIRTH_WEIGHT' => $BIRTH_WEIGHT
                        ,'BIRTH_LENGTH' => $BIRTH_LENGTH
                        ,'HAD_BCG' => $HAD_BCG
                        ,'HAD_HEPA_B' => $HAD_HEPA_B
                        ,'HAD_NEWBORN_SCREENING' => $HAD_NEWBORN_SCREENING
                        ,'HAD_BREASTFEED' => $HAD_BREASTFEED
                        ,'DO_A' => $DO_A
                        ,'DO_B' => $DO_B
                        ,'DO_C' => $DO_C
                        ,'DO_D' => $DO_D
                        ,'DO_E' => $DO_E
                        ,'DO_F' => $DO_F
                        ,'SOURCE_OF_SERVICE_RESERVED' => $SOURCE_OF_SERVICE_RESERVED
                        ,'CREATED_AT' => date('Y-m-d')
                        ,'ACTIVE_FLAG' => 1
                    )
                );          
            return response()->json(['message' => $nonresident_recent]);
        }

    }

    public function SpecificNewborn(Request $request){
    	$RESIDENT_ID = $request->RESIDENT_ID;
        $NONRESIDENT = $request->NONRESIDENT;

        if($NONRESIDENT == "FALSE"){
            $specific_resident = DB::table('t_hs_newborn')
                ->where('RESIDENT_ID', $RESIDENT_ID)
                ->select(
                    'RESIDENT_ID' 
                    ,'NEWBORN_ID'
                    ,'TYPE_OF_HOME_RECORD'
                    ,'BIRTH_WEIGHT'
                    ,'BIRTH_LENGTH' 
                    ,'HAD_BCG'
                    ,'HAD_HEPA_B'
                    ,'HAD_NEWBORN_SCREENING' 
                    ,'HAD_BREASTFEED' 
                    ,'DO_A'
                    ,'DO_B'
                    ,'DO_C' 
                    ,'DO_D' 
                    ,'DO_E'
                    ,'DO_F'
                    ,'SOURCE_OF_SERVICE_RESERVED' 
                    ,'CREATED_AT' 
                    ,'ACTIVE_FLAG'
                )
                ->get();
            return response()->json(['specific_resident' => $specific_resident, 'message' => $NONRESIDENT] );
        }
            // return response()->json(['message' => 'ito na TRUE'] );

          if ($NONRESIDENT == "TRUE"){
             $specific_resident = DB::table('t_hs_newborn')
                ->where('NONRESIDENT_ID', $RESIDENT_ID)
                ->select(
                    'NONRESIDENT_ID' 
                    ,'NEWBORN_ID'
                    ,'TYPE_OF_HOME_RECORD'
                    ,'BIRTH_WEIGHT'
                    ,'BIRTH_LENGTH' 
                    ,'HAD_BCG'
                    ,'HAD_HEPA_B'
                    ,'HAD_NEWBORN_SCREENING' 
                    ,'HAD_BREASTFEED' 
                    ,'DO_A'
                    ,'DO_B'
                    ,'DO_C' 
                    ,'DO_D' 
                    ,'DO_E'
                    ,'DO_F'
                    ,'SOURCE_OF_SERVICE_RESERVED' 
                    ,'CREATED_AT' 
                    ,'ACTIVE_FLAG'
                )
                ->get();
            return response()->json(['specific_resident' => $specific_resident, 'message' => $NONRESIDENT] );
        }

    	
    }
}
