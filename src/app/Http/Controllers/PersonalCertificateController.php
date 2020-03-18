<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

class PersonalCertificateController extends Controller
{
    public function index(){
		$resident = DB::table('t_resident_basic_info')
			->select(
				'RESIDENT_ID'
				,'LASTNAME'
				,'MIDDLENAME'
				,'FIRSTNAME'
				,'SEX'
				,'ADDRESS_UNIT_NO'
				,'ADDRESS_PHASE'
				,'ADDRESS_BLOCK_NO'
				,'ADDRESS_HOUSE_NO'
				,'ADDRESS_STREET'
				,'ADDRESS_SUBDIVISION'
				,'ADDRESS_BUILDING'
				,'DATE_OF_BIRTH'
			)
			->get();

		$current_date = db::table('v_generatectrno')->VALUE('CTR_NO');
	
		$controlno = DB::table('t_issuance')
			->select('ISSUANCE_NUMBER')->latest('ISSUANCE_ID')->first();
			
		// dd($controlno);
		
        // $issuance_no = "";
        // if($controlno != null) {
           
        //     $sample = substr($controlno->ISSUANCE_NUMBER, -1);
        //     $incremented = intval($sample) + 1;
        //     $issuance_no = substr($controlno->ISSUANCE_NUMBER, 0, strlen($controlno->ISSUANCE_NUMBER)-1).$incremented;
        // }
        // else
        // {
        //     $current_date = db::table('v_generatectrno')->VALUE('CTR_NO');
        //     $issuance_no = $current_date."-0001";
            
        // }
        
        //dd($sample);
		
			//usage..
			// function add_no($number,$add_no) {
			//    while (strlen($number)<1) {
			//        		$number ."-000".$number;
			//    		}
			//    		return $number;
			// }

			// for($y=0;$y<1;$yumber++){
			// 	echo $current_date."".add_no($y,5)."<br/>";
			 
			// }        

       
			return view('certificateandforms.personal', compact('resident'));
    }

    public function PersonalPrintableData(Request $request){
    	$RESIDENT_ID = $request->RESIDENT_ID;
    	$ISSUANCE_TYPE = $request->ISSUANCE_TYPE;
    	//residency,indigency
    	$PURPOSE = $request->PURPOSE;
    	//loan sss-gsis
    	$REMARKS_CONTENT = $request->REMARKS_CONTENT;
    	$SSS_GSIS = $request->SSS_GSIS;
    	$CALAMITY_NAME = $request->CALAMITY_NAME;
    	$CALAMITY_DATE = $request->CALAMITY_DATE;
    	//OR DETAILS
    	$OR_NUMBER = $request->OR_NUMBER;
    	$OR_AMOUNT = $request->OR_AMOUNT;


    	$specific_person = DB::table('t_resident_basic_info')
    		->where('RESIDENT_ID', $RESIDENT_ID)
			->select(
				'RESIDENT_ID'
				,'LASTNAME'
				,'MIDDLENAME'
				,'FIRSTNAME'
				,'SEX'
				,'ADDRESS_UNIT_NO'
				,'ADDRESS_PHASE'
				,'ADDRESS_BLOCK_NO'
				,'ADDRESS_HOUSE_NO'
				,'ADDRESS_STREET'
				,'ADDRESS_SUBDIVISION'
				,'ADDRESS_BUILDING'
				,'CIVIL_STATUS'
				,'GSIS_NO'
				,'SSS_NO'
				,'SEX'
				,'DATE_OF_BIRTH'
			)
			->get();


		//CONTROL NO GENERATOR
		$controlno = DB::table('t_issuance')
			->select('ISSUANCE_NUMBER','ISSUANCE_ID')
			->latest('ISSUANCE_ID')
			->first();
		$current_date = db::table('v_generatectrno')->VALUE('CTR_NO');
		
		if(!$controlno)
			$issuance_number = $current_date."001";
		else{
			$lastnumberplusone = $controlno->ISSUANCE_ID+1;
			$issuance_number = $current_date."00".$lastnumberplusone;
		}
    	
			
		if($ISSUANCE_TYPE == "Barangay Certificate Residency"){	
			$insert = DB::table('t_issuance')
				->insert(array(
					'ISSUANCE_TYPE_ID' => 13
					,'RESIDENT_ID' => $RESIDENT_ID
					,'ISSUANCE_PURPOSE' => $PURPOSE
					,'ISSUANCE_DATE' => date('Y-m-d')
					,'ISSUANCE_NUMBER' => $issuance_number
					,'RECEIVED_BY' => session('session_full_name')
					,'STATUS' => "Issued"
					,'REMARKS' => $REMARKS_CONTENT
					,'OR_NUMBER' => $OR_NUMBER
					,'OR_AMOUNT' => $OR_AMOUNT
			));
		}

		else if($ISSUANCE_TYPE == "Barangay Certificate Calamity Loan SSS-GSIS"){	

			
			$insert = DB::table('t_issuance')
				->insert(array(
					'ISSUANCE_TYPE_ID' => 14
					,'RESIDENT_ID' => $RESIDENT_ID
					,'ISSUANCE_PURPOSE' => $PURPOSE
					,'ISSUANCE_DATE' => date('Y-m-d')
					,'ISSUANCE_NUMBER' => $issuance_number
					,'RECEIVED_BY' => session('session_full_name')
					,'STATUS' => "Issued"
					,'REMARKS' => $REMARKS_CONTENT
					,'OR_NUMBER' => $OR_NUMBER
					,'OR_AMOUNT' => $OR_AMOUNT
			));
		}

		else if($ISSUANCE_TYPE == "Barangay Certificate Calamity Loan OFW"){	
			$insert = DB::table('t_issuance')
				->insert(array(
					'ISSUANCE_TYPE_ID' => 15
					,'RESIDENT_ID' => $RESIDENT_ID
					,'ISSUANCE_PURPOSE' => $PURPOSE
					,'ISSUANCE_DATE' => date('Y-m-d')
					,'ISSUANCE_NUMBER' => $issuance_number
					,'RECEIVED_BY' => session('session_full_name')
					,'STATUS' => "Issued"
					,'REMARKS' => $REMARKS_CONTENT
					,'OR_NUMBER' => $OR_NUMBER
					,'OR_AMOUNT' => $OR_AMOUNT
			));
		}

		else if($ISSUANCE_TYPE == "Barangay Certificate SPES"){	
			$insert = DB::table('t_issuance')
				->insert(array(
					'ISSUANCE_TYPE_ID' => 16
					,'RESIDENT_ID' => $RESIDENT_ID
					,'ISSUANCE_PURPOSE' => $PURPOSE
					,'ISSUANCE_DATE' => date('Y-m-d')
					,'ISSUANCE_NUMBER' => $issuance_number
					,'RECEIVED_BY' => session('session_full_name')
					,'STATUS' => "Issued"
					,'REMARKS' => $REMARKS_CONTENT
					,'OR_NUMBER' => $OR_NUMBER
					,'OR_AMOUNT' => $OR_AMOUNT
			));
		}

		else if($ISSUANCE_TYPE == "Barangay Certificate Solo Parent"){	
			$insert = DB::table('t_issuance')
				->insert(array(
					'ISSUANCE_TYPE_ID' => 17
					,'RESIDENT_ID' => $RESIDENT_ID
					,'ISSUANCE_PURPOSE' => $PURPOSE
					,'ISSUANCE_DATE' => date('Y-m-d')
					,'ISSUANCE_NUMBER' => $issuance_number
					,'RECEIVED_BY' => session('session_full_name')
					,'STATUS' => "Issued"
					,'REMARKS' => $REMARKS_CONTENT
					,'OR_NUMBER' => $OR_NUMBER
					,'OR_AMOUNT' => $OR_AMOUNT
			));
		}

		else if($ISSUANCE_TYPE == "Barangay Certificate Indigency"){	
			$insert = DB::table('t_issuance')
				->insert(array(
					'ISSUANCE_TYPE_ID' => 18
					,'RESIDENT_ID' => $RESIDENT_ID
					,'ISSUANCE_PURPOSE' => $PURPOSE
					,'ISSUANCE_DATE' => date('Y-m-d')
					,'ISSUANCE_NUMBER' => $issuance_number
					,'RECEIVED_BY' =>session('session_full_name')
					,'STATUS' => "Issued"
					,'REMARKS' => $REMARKS_CONTENT
					,'OR_NUMBER' => $OR_NUMBER
					,'OR_AMOUNT' => $OR_AMOUNT
			));
		}


		return response()->json(['specific_person' => $specific_person, 'issuance_number' => $issuance_number]);
    }


   
}
