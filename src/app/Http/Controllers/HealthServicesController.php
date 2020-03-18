<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Maatwebsite\Excel\Facades\Excel;
use App\Exports\InfantExport;
use App\Exports\ChildExport;
use App\Exports\PregnantExport;
use App\Exports\PostpartumExport;
use App\Exports\ChronicCoughExport;
use App\Exports\ChronicDiseasesExport;
use App\Exports\PWDExport;
use App\Exports\ElderlyExport;
use App\Exports\AdolescentExport;
use App\Exports\FamilyPlanningExport;
use App\Exports\NonFamilyPlanningExport;
use Carbon\Carbon;

class HealthServicesController extends Controller
{
	public function ResidentDisplay($typeofview){
		
		$resident = DB::table('t_resident_basic_info')
			->select(
				'RESIDENT_ID','FIRSTNAME','MIDDLENAME','LASTNAME'
				,'ADDRESS_UNIT_NO','ADDRESS_PHASE','ADDRESS_BLOCK_NO','ADDRESS_HOUSE_NO','ADDRESS_STREET','ADDRESS_SUBDIVISION','ADDRESS_BUILDING'
				,'DATE_OF_BIRTH'
			)
			->get();

		if ($typeofview == "ChronicCough"){

			$resident = collect(DB::select('
				SELECT R.RESIDENT_ID, R.FIRSTNAME, R.MIDDLENAME, R.LASTNAME, R.ADDRESS_UNIT_NO, R.ADDRESS_PHASE, R.ADDRESS_BLOCK_NO, R.ADDRESS_HOUSE_NO, R.ADDRESS_STREET, R.ADDRESS_SUBDIVISION, R.ADDRESS_BUILDING, R.DATE_OF_BIRTH, "POSITIVE" AS ILLNESS_STATUS
				FROM t_resident_basic_info AS R
				LEFT JOIN t_hs_chronic_cough AS CC
				ON R.RESIDENT_ID = CC.RESIDENT_ID
				WHERE CC.CHRONIC_COUGH_ID IS NOT  NULL
				UNION
				SELECT R.RESIDENT_ID, R.FIRSTNAME, R.MIDDLENAME, R.LASTNAME, R.ADDRESS_UNIT_NO, R.ADDRESS_PHASE, R.ADDRESS_BLOCK_NO, R.ADDRESS_HOUSE_NO, R.ADDRESS_STREET, R.ADDRESS_SUBDIVISION, R.ADDRESS_BUILDING, R.DATE_OF_BIRTH, "NEGATIVE" AS ILLNESS_STATUS
				FROM t_resident_basic_info AS R
				LEFT JOIN t_hs_chronic_cough AS CC
				ON R.RESIDENT_ID = CC.RESIDENT_ID
				WHERE CC.CHRONIC_COUGH_ID IS  NULL            	
            '));
			

			//may cough
			$nonresident = DB::table('t_nonresident_basic_info AS NR')
				->join('t_hs_chronic_cough AS CC', 'CC.NONRESIDENT_ID', 'NR.NONRESIDENT_ID')
				->select(
					  'NR.NONRESIDENT_ID'
	                ,'NR.FIRST_NAME'
	                ,'NR.MIDDLE_NAME'
	                ,'NR.LAST_NAME'
	                ,'NR.BIRTHDATE'
				)
				->get();


			return view('healthservices.chroniccough', compact('resident',  'nonresident'));
		}

		else if ($typeofview == "ChronicDiseases"){
			$resident = DB::table('t_resident_basic_info')
			->whereNotIn('RESIDENT_ID', DB::table('t_hs_chronic_disease')->select('RESIDENT_ID'))
			->select(
				'RESIDENT_ID','FIRSTNAME','MIDDLENAME','LASTNAME'
				,'ADDRESS_UNIT_NO','ADDRESS_PHASE','ADDRESS_BLOCK_NO','ADDRESS_HOUSE_NO','ADDRESS_STREET','ADDRESS_SUBDIVISION','ADDRESS_BUILDING'
				,'DATE_OF_BIRTH'
			)
			->get();	
			$chronicdiseases = DB::table('t_resident_basic_info AS R')
				->join('t_hs_chronic_disease AS CD' , 'CD.RESIDENT_ID', 'R.RESIDENT_ID')
				->select(
					'CD.CHRONIC_DISEASE_ID','R.RESIDENT_ID','R.FIRSTNAME','R.MIDDLENAME','R.LASTNAME'
					,'R.ADDRESS_UNIT_NO','R.ADDRESS_PHASE','R.ADDRESS_BLOCK_NO','R.ADDRESS_HOUSE_NO','R.ADDRESS_STREET','R.ADDRESS_SUBDIVISION','R.ADDRESS_BUILDING'
					,'R.DATE_OF_BIRTH'
				)
				->get();
			return view('healthservices.chronicdiseases', compact('resident', 'chronicdiseases'));
		}
		
		else if ($typeofview == "Pregnant"){
			$resident = DB::table('t_resident_basic_info')
			->whereNotIn('RESIDENT_ID', DB::table('t_hs_pregnant')->select('RESIDENT_ID'))
			->where('SEX', 'Female')
			->select(
				'RESIDENT_ID','FIRSTNAME','MIDDLENAME','LASTNAME'
				,'ADDRESS_UNIT_NO','ADDRESS_PHASE','ADDRESS_BLOCK_NO','ADDRESS_HOUSE_NO','ADDRESS_STREET','ADDRESS_SUBDIVISION','ADDRESS_BUILDING'
				,'DATE_OF_BIRTH'
			)
			->get();
			$pregnant = DB::table('t_resident_basic_info AS R')
			->where('SEX', 'Female')
			->join('t_hs_pregnant AS P', 'P.RESIDENT_ID', 'R.RESIDENT_ID')

			->select(
				'P.PREGNANT_ID','R.RESIDENT_ID','R.FIRSTNAME','R.MIDDLENAME','R.LASTNAME'
				,'R.ADDRESS_UNIT_NO','R.ADDRESS_PHASE','R.ADDRESS_BLOCK_NO','R.ADDRESS_HOUSE_NO','R.ADDRESS_STREET','R.ADDRESS_SUBDIVISION','R.ADDRESS_BUILDING'
				,'R.DATE_OF_BIRTH'
			)
			->get();

			
			return view('healthservices.pregnant', compact('resident', 'pregnant'));
		}
		
			else if ($typeofview == "PWD"){
			
				$resident = DB::table('t_resident_basic_info')
				->whereNotIn('RESIDENT_ID', DB::table('t_hs_pwd')->select('RESIDENT_ID'))
				->select(
					'RESIDENT_ID','FIRSTNAME','MIDDLENAME','LASTNAME'
					,'ADDRESS_UNIT_NO','ADDRESS_PHASE','ADDRESS_BLOCK_NO','ADDRESS_HOUSE_NO','ADDRESS_STREET','ADDRESS_SUBDIVISION','ADDRESS_BUILDING'
					,'DATE_OF_BIRTH'
				)
				->get();
				$pwd = DB::table('t_resident_basic_info AS R')
				->join('t_hs_pwd AS PWD', 'PWD.RESIDENT_ID', 'R.RESIDENT_ID')
				->select(
					'PWD.PWD_ID','R.RESIDENT_ID','R.FIRSTNAME','R.MIDDLENAME','R.LASTNAME'
					,'R.ADDRESS_UNIT_NO','R.ADDRESS_PHASE','R.ADDRESS_BLOCK_NO','R.ADDRESS_HOUSE_NO','R.ADDRESS_STREET','R.ADDRESS_SUBDIVISION','R.ADDRESS_BUILDING'
					,'R.DATE_OF_BIRTH'
				)
				->get();
				// dd($pwd);
				return view('healthservices.pwd', compact('resident', 'pwd'));
		}

		else if ($typeofview == "Elderly"){			
			$elderlyResident = collect(DB::select('SELECT 
				DATEDIFF(CURRENT_DATE, `DATE_OF_BIRTH`) AS DifferenceDOBCUR
				,RESIDENT_ID 
				,FIRSTNAME,MIDDLENAME,LASTNAME
				,ADDRESS_UNIT_NO,ADDRESS_PHASE,ADDRESS_BLOCK_NO,ADDRESS_HOUSE_NO,ADDRESS_STREET,ADDRESS_SUBDIVISION,ADDRESS_BUILDING
				,DATE_OF_BIRTH
				FROM `t_resident_basic_info`
				WHERE DATEDIFF(CURRENT_DATE, `DATE_OF_BIRTH`) >= 21900'));
			$elderly = DB::table('t_resident_basic_info AS R')
				->join('t_hs_elderly AS E' , 'E.RESIDENT_ID', 'R.RESIDENT_ID')
				->select(
					'E.ELDERLY_ID','R.RESIDENT_ID','R.FIRSTNAME','R.MIDDLENAME','R.LASTNAME'
					,'R.ADDRESS_UNIT_NO','R.ADDRESS_PHASE','R.ADDRESS_BLOCK_NO','R.ADDRESS_HOUSE_NO','R.ADDRESS_STREET','R.ADDRESS_SUBDIVISION','R.ADDRESS_BUILDING'
					,'R.DATE_OF_BIRTH'
				)
				->get();
			return view('healthservices.elderly', compact('elderlyResident', 'elderly'));
		}

		else if ($typeofview == "Postpartum"){
			$PregnantResident = DB::table('t_resident_basic_info AS R')
			->join('t_hs_pregnant AS P','R.resident_id','P.resident_id')
			->whereIn('R.RESIDENT_ID', DB::table('t_hs_pregnant')->select('RESIDENT_ID'))
			->select('R.RESIDENT_ID', 'P.PREGNANT_ID','R.FIRSTNAME','R.MIDDLENAME','R.LASTNAME'
				,'R.ADDRESS_UNIT_NO','R.ADDRESS_PHASE','R.ADDRESS_BLOCK_NO','R.ADDRESS_HOUSE_NO','R.ADDRESS_STREET','R.ADDRESS_SUBDIVISION','R.ADDRESS_BUILDING'
				,'R.DATE_OF_BIRTH')
			->get();

			$postpartum =DB::table('t_resident_basic_info AS R')
			->join('t_hs_pregnant AS P','R.resident_id','P.resident_id')
			->join('t_hs_post_partum AS PP', 'PP.PREGNANT_ID', 'P.PREGNANT_ID')
			->whereIn('R.RESIDENT_ID', DB::table('t_hs_pregnant')->select('RESIDENT_ID'))
			->select('PP.POST_PATRUM_ID','R.RESIDENT_ID', 'P.PREGNANT_ID','R.FIRSTNAME','R.MIDDLENAME','R.LASTNAME'
				,'R.ADDRESS_UNIT_NO','R.ADDRESS_PHASE','R.ADDRESS_BLOCK_NO','R.ADDRESS_HOUSE_NO','R.ADDRESS_STREET','R.ADDRESS_SUBDIVISION','R.ADDRESS_BUILDING'
				,'R.DATE_OF_BIRTH')
			->get();
			// dd($postpartum);
			return view('healthservices.postpartum', compact('PregnantResident', 'postpartum'));
		}

		else if ($typeofview == "Adolescent"){
			$adolescentResident = collect(DB::select('SELECT 
				DATEDIFF(CURRENT_DATE, `DATE_OF_BIRTH`) AS DifferenceDOBCUR
				,RESIDENT_ID,FIRSTNAME,MIDDLENAME,LASTNAME
				,ADDRESS_UNIT_NO,ADDRESS_PHASE,ADDRESS_BLOCK_NO,ADDRESS_HOUSE_NO,ADDRESS_STREET,ADDRESS_SUBDIVISION,ADDRESS_BUILDING
				,DATE_OF_BIRTH
				FROM `t_resident_basic_info`
				WHERE DATEDIFF(CURRENT_DATE, `DATE_OF_BIRTH`) >= 4015 AND DATEDIFF(CURRENT_DATE, `DATE_OF_BIRTH`) <= 6935'));

			$adolescent = DB::table('t_resident_basic_info AS R')
				->join('t_hs_adolescent AS A' , 'A.RESIDENT_ID', 'R.RESIDENT_ID')
				->select(
					'A.ADOLESCENT_ID','R.RESIDENT_ID','R.FIRSTNAME','R.MIDDLENAME','R.LASTNAME'
					,'R.ADDRESS_UNIT_NO','R.ADDRESS_PHASE','R.ADDRESS_BLOCK_NO','R.ADDRESS_HOUSE_NO','R.ADDRESS_STREET','R.ADDRESS_SUBDIVISION','R.ADDRESS_BUILDING'
					,'R.DATE_OF_BIRTH'
				)
				->get();
			
			return view('healthservices.adolescent', compact('adolescentResident', 'adolescent'));
		}

		else if ($typeofview == "FPUserVisitation"){
			$residentFP = DB::table('t_resident_basic_info AS R')
			->whereIn('R.RESIDENT_ID', DB::table('t_hs_family_planning')->select('RESIDENT_ID'))
			->join('t_hs_family_planning AS FP', 'FP.RESIDENT_ID', 'R.RESIDENT_ID')
			->select(
				'FP.FD_ID','R.RESIDENT_ID','R.FIRSTNAME','R.MIDDLENAME','R.LASTNAME'
				,'R.ADDRESS_UNIT_NO','R.ADDRESS_PHASE','R.ADDRESS_BLOCK_NO','R.ADDRESS_HOUSE_NO','R.ADDRESS_STREET','R.ADDRESS_SUBDIVISION','R.ADDRESS_BUILDING'
				,'R.DATE_OF_BIRTH'
			)
			->get();

			$visitation = DB::table('t_resident_basic_info AS R')
			->join('t_hs_family_planning AS FP', 'FP.RESIDENT_ID', 'R.RESIDENT_ID')
			->join('t_hs_family_planning_users_visitations AS FPUV', 'FPUV.FP_ID', 'FP.FD_ID')
			->select(
				'FP.FD_ID','R.RESIDENT_ID','R.FIRSTNAME','R.MIDDLENAME','R.LASTNAME'
				,'R.ADDRESS_UNIT_NO','R.ADDRESS_PHASE','R.ADDRESS_BLOCK_NO','R.ADDRESS_HOUSE_NO','R.ADDRESS_STREET','R.ADDRESS_SUBDIVISION','R.ADDRESS_BUILDING'
				,'R.DATE_OF_BIRTH'
			)
			->get();
			return view('healthservices.fpuservisitation', compact('residentFP', 'visitation'));
		}

		else if($typeofview == "FamilyPlanning"){
			$residentFP = DB::table('t_resident_basic_info')
			->whereNotIn('RESIDENT_ID', DB::table('t_hs_family_planning')->select('RESIDENT_ID'))
			->whereNotIn('RESIDENT_ID', DB::table('t_hs_non_family_planning_users')->select('RESIDENT_ID'))
			->select(
				'RESIDENT_ID','FIRSTNAME','MIDDLENAME','LASTNAME'
				,'ADDRESS_UNIT_NO','ADDRESS_PHASE','ADDRESS_BLOCK_NO','ADDRESS_HOUSE_NO','ADDRESS_STREET','ADDRESS_SUBDIVISION','ADDRESS_BUILDING'
				,'DATE_OF_BIRTH'
			)
			->get();
			$FPnNFPuser = collect(DB::select('
				SELECT R.RESIDENT_ID, R.FIRSTNAME,MIDDLENAME, R.LASTNAME,R.ADDRESS_UNIT_NO,R.ADDRESS_PHASE,R.ADDRESS_BLOCK_NO,R.ADDRESS_HOUSE_NO,R.ADDRESS_STREET,R.ADDRESS_SUBDIVISION,R.ADDRESS_BUILDING,R.DATE_OF_BIRTH, 
				"FP_USER" AS USER_TYPE
				FROM t_resident_basic_info AS R
				INNER JOIN t_hs_family_planning AS FP
				ON	R.RESIDENT_ID = FP.RESIDENT_ID
				UNION
				SELECT 
				R.RESIDENT_ID, R.FIRSTNAME,MIDDLENAME, R.LASTNAME,R.ADDRESS_UNIT_NO,R.ADDRESS_PHASE,R.ADDRESS_BLOCK_NO,R.ADDRESS_HOUSE_NO,R.ADDRESS_STREET,R.ADDRESS_SUBDIVISION,R.ADDRESS_BUILDING,R.DATE_OF_BIRTH, 
				"NON_FP_USER"
				FROM t_resident_basic_info AS R
				INNER JOIN t_hs_non_family_planning_users AS NFP
				ON R.RESIDENT_ID = NFP.RESIDENT_ID
				'));
				return view('healthservices.familyplanning', compact('residentFP', 'FPnNFPuser'));
		}

		else if ($typeofview == "Infant"){
			$infant_resident = DB::table('t_resident_basic_info AS R')
	            ->join('t_hs_newborn AS NB', 'NB.RESIDENT_ID', 'R.RESIDENT_ID')
	            ->join('t_hs_infant AS I', 'I.NEW_BORN_ID', 'NB.NEWBORN_ID')
	            ->where('R.DATE_OF_BIRTH', '>=', Carbon::today()->subDays(365))
	            ->where('R.DATE_OF_BIRTH', '<=', Carbon::today()->subDays(29))
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
	                ,'I.INFANT_ID'
	    		)
	    		->get();

	    	$infant_nonresident = DB::table('t_nonresident_basic_info AS NR')
	            ->join('t_hs_newborn AS NB', 'NB.NONRESIDENT_ID', 'NR.NONRESIDENT_ID')
	            ->join('t_hs_infant AS I', 'I.NEW_BORN_ID', 'NB.NEWBORN_ID')
	            ->where('NR.BIRTHDATE', '>=', Carbon::today()->subDays(365))
	            ->where('NR.BIRTHDATE', '<=', Carbon::today()->subDays(29))
	            ->select(
	                 'NR.NONRESIDENT_ID'
	                ,'NR.FIRST_NAME'
	                ,'NR.MIDDLE_NAME'
	                ,'NR.LAST_NAME'
	                ,'NR.BIRTHDATE'
	                ,'I.INFANT_ID'
	            )->get();

			// dd($infant_nonresident);
			return view('healthservices.infants', compact('infant_resident', 'infant_nonresident'));
		}
		
		else if ($typeofview == "Child"){

			$child_resident = DB::table('t_resident_basic_info AS R')
	            ->join('t_hs_newborn AS NB', 'NB.RESIDENT_ID', 'R.RESIDENT_ID')
	            ->join('t_hs_infant AS I', 'I.NEW_BORN_ID', 'NB.NEWBORN_ID')
	            ->join('t_hs_child AS C', 'C.INFANT_ID', 'I.INFANT_ID')
	            ->where('R.DATE_OF_BIRTH', '>=', Carbon::today()->subYear(11))
	            ->where('R.DATE_OF_BIRTH', '<=', Carbon::today()->subYear(1))
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
	                ,'I.INFANT_ID'
	                ,'C.CHILD_ID'
	    		)
	    		->get();

	    	$child_nonresident = DB::table('t_nonresident_basic_info AS NR')
	            ->join('t_hs_newborn AS NB', 'NB.NONRESIDENT_ID', 'NR.NONRESIDENT_ID')
	            ->join('t_hs_infant AS I', 'I.NEW_BORN_ID', 'NB.NEWBORN_ID')
	            ->join('t_hs_child AS C', 'C.INFANT_ID', 'I.INFANT_ID')
	            ->where('NR.BIRTHDATE', '>=', Carbon::today()->subYear(11))
	            ->where('NR.BIRTHDATE', '<=', Carbon::today()->subYear(1))
	            ->select(
	                 'NR.NONRESIDENT_ID'
	                ,'NR.FIRST_NAME'
	                ,'NR.MIDDLE_NAME'
	                ,'NR.LAST_NAME'
	                ,'NR.BIRTHDATE'
	                ,'I.INFANT_ID'
	                ,'C.CHILD_ID'
	            )->get();

			// dd($child_nonresident);
			return view('healthservices.child', compact('child_resident', 'child_nonresident'));	
		}
		
	}

	public function Export($exporttype){

		if($exporttype == "InfantExport")
			return Excel::download(new InfantExport, 'infant.xlsx');
		else if($exporttype == "ChildExport")
			return Excel::download(new ChildExport, 'child.xlsx');
		else if($exporttype == "PregnantExport")
			return Excel::download(new PregnantExport, 'pregnant.xlsx');
		else if($exporttype == "PostpartumExport")
			return Excel::download(new PostpartumExport, 'postpartum.xlsx');
		else if($exporttype == "ChronicCoughExport")
			return Excel::download(new ChronicCoughExport, 'chroniccough.xlsx');
		else if($exporttype == "ChronicDiseasesExport")
			return Excel::download(new ChronicDiseasesExport, 'chronicdiseases.xlsx');
		else if($exporttype == "PWDExport")
			return Excel::download(new PWDExport, 'pwd.xlsx');
		else if($exporttype == "ElderlyExport")
			return Excel::download(new ElderlyExport, 'elderly.xlsx');
		else if($exporttype == "AdolescentExport")
			return Excel::download(new AdolescentExport, 'adolescent.xlsx');
		else if($exporttype == "FamilyPlanningExport")
			return Excel::download(new FamilyPlanningExport, 'fp_user.xlsx');
		else if($exporttype == "NonFamilyPlanningExport")
			return Excel::download(new NonFamilyPlanningExport, 'nonfp_user.xlsx');
	}


	public function CRUDChild(Request $request){
		$TYPE_OF_HOME_RECORD = $request->TYPE_OF_HOME_RECORD;
		$SOURCE_OF_SERVICE_RESERVED = $request->SOURCE_OF_SERVICE_RESERVED;
		$HAD_DEWORMING = $request->HAD_DEWORMING;
		$HAD_MMR_12_15_MO = $request->HAD_MMR_12_15_MO;
		$HAD_VITAMIN_A_12_59_MO = $request->HAD_VITAMIN_A_12_59_MO;
		$OPT_DATE = $request->OPT_DATE;
		$OPT_WEIGHT = $request->OPT_WEIGHT;
		$OPT_HEIGHT = $request->OPT_HEIGHT;
		$GP_APRIL_DEWORMING = $request->GP_APRIL_DEWORMING;
		$GP_OCTOBER_DEWORMING = $request->GP_OCTOBER_DEWORMING;
		$DO_A = $request->DO_A;
		$DO_B = $request->DO_B;
		$DO_C = $request->DO_C;
		$INFANT_ID = $request->INFANT_ID;
		$CRUD_STATUS = $request->CRUD_STATUS;
		$CHILD_ID = $request->CHILD_ID;

		$FIRSTNAME = $request->FIRSTNAME;
        $MIDDLENAME = $request->MIDDLENAME;
        $LASTNAME = $request->LASTNAME;
        $SEX = $request->SEX;
        $BIRTHDATE = $request->BIRTHDATE;


		if($CRUD_STATUS == "Update_Child"){

			$update = DB::table('t_hs_child')
			->where('CHILD_ID', $CHILD_ID)
			->update(
				array(
				'TYPE_OF_HOME_RECORD' => $TYPE_OF_HOME_RECORD
				,'SOURCE_OF_SERVICE_RESERVED' => $SOURCE_OF_SERVICE_RESERVED
				,'HAD_DEWORMING' => $HAD_DEWORMING
				,'HAD_MMR_12_15_MO' => $HAD_MMR_12_15_MO
				,'HAD_VITAMIN_A_12_59_MO' => $HAD_VITAMIN_A_12_59_MO
				,'OPT_DATE' => $OPT_DATE
				,'OPT_WEIGHT' => $OPT_WEIGHT
				,'OPT_HEIGHT' => $OPT_HEIGHT
				,'GP_APRIL_DEWORMING' => $GP_APRIL_DEWORMING
				,'GP_OCTOBER_DEWORMING' => $GP_OCTOBER_DEWORMING
				,'DO_A' => $DO_A
				,'DO_B' => $DO_B
				,'DO_C' => $DO_C
				,'UPDATED_AT' => DB::RAW('CURRENT_TIMESTAMP')
				)
			);
			return response()->json(['message' => "Nakapasok nang Update_Child"]);
		}

		else if($CRUD_STATUS == "Add_NonResident"){

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
                        ,'CREATED_AT' => date('Y-m-d')
                        ,'ACTIVE_FLAG' => 1
                    )
                );          

            $newborn_nonresident_recent = DB::table('t_hs_newborn')->select('NEWBORN_ID')->latest('NEWBORN_ID')->first();

            $insertInfant = DB::table('t_hs_infant')
				->insert(
					array(
						'NEW_BORN_ID' => $newborn_nonresident_recent->NEWBORN_ID
						,'CREATED_AT' => DB::RAW('CURRENT_TIMESTAMP')
						,'ACTIVE_FLAG' => 1
					)
				);

			$infant_nonresident_recent = DB::table('t_hs_infant')->select('INFANT_ID')->latest('INFANT_ID')->first();

			$insert = DB::table('t_hs_child')
				->insert(array(
					'TYPE_OF_HOME_RECORD' => $TYPE_OF_HOME_RECORD
					,'SOURCE_OF_SERVICE_RESERVED' => $SOURCE_OF_SERVICE_RESERVED
					,'HAD_DEWORMING' => $HAD_DEWORMING
					,'HAD_MMR_12_15_MO' => $HAD_MMR_12_15_MO
					,'HAD_VITAMIN_A_12_59_MO' => $HAD_VITAMIN_A_12_59_MO
					,'OPT_DATE' => $OPT_DATE
					,'OPT_WEIGHT' => $OPT_WEIGHT
					,'OPT_HEIGHT' => $OPT_HEIGHT
					,'GP_APRIL_DEWORMING' => $GP_APRIL_DEWORMING
					,'GP_OCTOBER_DEWORMING' => $GP_OCTOBER_DEWORMING
					,'DO_A' => $DO_A
					,'DO_B' => $DO_B
					,'DO_C' => $DO_C
					,'INFANT_ID' => $infant_nonresident_recent->INFANT_ID
					,'CREATED_AT' => DB::RAW('CURRENT_TIMESTAMP')
					,'ACTIVE_FLAG' => 1
				));

			return response()->json(['message' => "NASA ADD NON RESIDENT CHILD"]);
		}
	}

	public function SpecificChild(Request $request){
		$CHILD_ID = $request->CHILD_ID;
		$NONRESIDENT = $request->NONRESIDENT;

		$specific_child = DB::table('t_hs_child')
			->where('CHILD_ID', $CHILD_ID)
			->select(
				'TYPE_OF_HOME_RECORD' 
				,'SOURCE_OF_SERVICE_RESERVED'
				,'HAD_DEWORMING' 
				,'HAD_MMR_12_15_MO'
				,'HAD_VITAMIN_A_12_59_MO' 
				,'OPT_DATE' 
				,'OPT_WEIGHT'
				,'OPT_HEIGHT' 
				,'GP_APRIL_DEWORMING' 
				,'GP_OCTOBER_DEWORMING' 
				,'DO_A' 
				,'DO_B' 
				,'DO_C'
			)
			->get();
			return response()->json(['specific_child' => $specific_child] );
	}


	public function CRUDInfant(Request $request){
		$NEW_BORN_ID = $request->NEW_BORN_ID;
		$INFANT_ID = $request->INFANT_ID;
		$TYPE_OF_HOME_RECORD = $request->TYPE_OF_HOME_RECORD;
		$OPT_DATE = $request->OPT_DATE;
		$OPT_WEIGHT = $request->OPT_WEIGHT;
		$OPT_HEIGHT = $request->OPT_HEIGHT;
		$GP_APRIL_VIT_A = $request->GP_APRIL_VIT_A;
		$GP_OCTOBER_VIT_A = $request->GP_OCTOBER_VIT_A;
		$SOURCE_OF_SERVICE_RECEIVED = $request->SOURCE_OF_SERVICE_RECEIVED;
		$HAD_BREASTFEED = $request->HAD_BREASTFEED;
		$HAD_PENTA_1 = $request->HAD_PENTA_1;
		$HAD_PENTA_2 = $request->HAD_PENTA_2;
		$HAD_PENTA_3 = $request->HAD_PENTA_3;
		$HAD_OPV_1 = $request->HAD_OPV_1;
		$HAD_OPV_2 = $request->HAD_OPV_2;
		$HAD_OPV_3 = $request->HAD_OPV_3;
		$HAD_ROTA_1 = $request->HAD_ROTA_1;
		$HAD_ROTA_2 = $request->HAD_ROTA_2;
		$HAD_MEASLES = $request->HAD_MEASLES;
		$HAD_VITAMIN_A = $request->HAD_VITAMIN_A;
		$DO_A = $request->DO_A;
		$DO_B = $request->DO_B;
		$DO_C = $request->DO_C;
		$DO_D = $request->DO_D;
		$DO_E = $request->DO_E;
		$DO_F = $request->DO_F;
		$DO_G = $request->DO_G;
		$DO_H = $request->DO_H;
		$CRUD_STATUS = $request->CRUD_STATUS;

		$FIRSTNAME = $request->FIRSTNAME;
        $MIDDLENAME = $request->MIDDLENAME;
        $LASTNAME = $request->LASTNAME;
        $SEX = $request->SEX;
        $BIRTHDATE = $request->BIRTHDATE;

		if($CRUD_STATUS == "Add_Infant"){
			$update = DB::table('t_hs_infant')
				->where('INFANT_ID', $INFANT_ID)
				->update(
					array(
						'TYPE_OF_HOME_RECORD' => $TYPE_OF_HOME_RECORD
						,'OPT_DATE' => $OPT_DATE
						,'OPT_WEIGHT' => $OPT_WEIGHT
						,'OPT_HEIGHT' => $OPT_HEIGHT
						,'GP_APRIL_VIT_A' => $GP_APRIL_VIT_A
						,'GP_OCTOBER_VIT_A' => $GP_OCTOBER_VIT_A
						,'SOURCE_OF_SERVICE_RECEIVED' => $SOURCE_OF_SERVICE_RECEIVED
						,'HAD_BREASTFEED' => $HAD_BREASTFEED
						,'HAD_PENTA_1' => $HAD_PENTA_1
						,'HAD_PENTA_2' => $HAD_PENTA_2
						,'HAD_PENTA_3' => $HAD_PENTA_3
						,'HAD_OPV_1' => $HAD_OPV_1
						,'HAD_OPV_2' => $HAD_OPV_2
						,'HAD_OPV_3' => $HAD_OPV_3
						,'HAD_ROTA_1' => $HAD_ROTA_1
						,'HAD_ROTA_2' => $HAD_ROTA_2
						,'HAD_MEASLES' => $HAD_MEASLES
						,'HAD_VITAMIN_A' => $HAD_VITAMIN_A
						,'DO_A' => $DO_A
						,'DO_B' => $DO_B
						,'DO_C' => $DO_C
						,'DO_D' => $DO_D
						,'DO_E' => $DO_E
						,'DO_F' => $DO_F
						,'DO_G' => $DO_G
						,'DO_H' => $DO_H
						,'UPDATED_AT' => DB::RAW('CURRENT_TIMESTAMP')
					)
				);
			return response()->json(['message' => "Nakapasok nang Add_Infant"]);
		}

		else if($CRUD_STATUS == "Update_Infant"){
			$update = DB::table('t_hs_infant')
			->where('INFANT_ID', $INFANT_ID)
			->update(
				array(
					'TYPE_OF_HOME_RECORD' => $TYPE_OF_HOME_RECORD
					,'OPT_DATE' => $OPT_DATE
					,'OPT_WEIGHT' => $OPT_WEIGHT
					,'OPT_HEIGHT' => $OPT_HEIGHT
					,'GP_APRIL_VIT_A' => $GP_APRIL_VIT_A
					,'GP_OCTOBER_VIT_A' => $GP_OCTOBER_VIT_A
					,'SOURCE_OF_SERVICE_RECEIVED' => $SOURCE_OF_SERVICE_RECEIVED
					,'HAD_BREASTFEED' => $HAD_BREASTFEED
					,'HAD_PENTA_1' => $HAD_PENTA_1
					,'HAD_PENTA_2' => $HAD_PENTA_2
					,'HAD_PENTA_3' => $HAD_PENTA_3
					,'HAD_OPV_1' => $HAD_OPV_1
					,'HAD_OPV_2' => $HAD_OPV_2
					,'HAD_OPV_3' => $HAD_OPV_3
					,'HAD_ROTA_1' => $HAD_ROTA_1
					,'HAD_ROTA_2' => $HAD_ROTA_2
					,'HAD_MEASLES' => $HAD_MEASLES
					,'HAD_VITAMIN_A' => $HAD_VITAMIN_A
					,'DO_A' => $DO_A
					,'DO_B' => $DO_B
					,'DO_C' => $DO_C
					,'DO_D' => $DO_D
					,'DO_E' => $DO_E
					,'DO_F' => $DO_F
					,'DO_G' => $DO_G
					,'DO_H' => $DO_H
					,'UPDATED_AT' => DB::RAW('CURRENT_TIMESTAMP')
				)
			);
			// return response()->json(['message' => $HAD_BREASTFEED]);
		}

		else if($CRUD_STATUS == "Add_NonResident"){
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
                        ,'CREATED_AT' => date('Y-m-d')
                        ,'ACTIVE_FLAG' => 1
                    )
                );          

            $newborn_nonresident_recent = DB::table('t_hs_newborn')->select('NEWBORN_ID')->latest('NEWBORN_ID')->first();

            $insertInfant = DB::table('t_hs_infant')
				->insert(
					array(
						'NEW_BORN_ID' => $newborn_nonresident_recent->NEWBORN_ID
						,'TYPE_OF_HOME_RECORD' => $TYPE_OF_HOME_RECORD
						,'OPT_DATE' => $OPT_DATE
						,'OPT_WEIGHT' => $OPT_WEIGHT
						,'OPT_HEIGHT' => $OPT_HEIGHT
						,'GP_APRIL_VIT_A' => $GP_APRIL_VIT_A
						,'GP_OCTOBER_VIT_A' => $GP_OCTOBER_VIT_A
						,'SOURCE_OF_SERVICE_RECEIVED' => $SOURCE_OF_SERVICE_RECEIVED
						,'HAD_BREASTFEED' => $HAD_BREASTFEED
						,'HAD_PENTA_1' => $HAD_PENTA_1
						,'HAD_PENTA_2' => $HAD_PENTA_2
						,'HAD_PENTA_3' => $HAD_PENTA_3
						,'HAD_OPV_1' => $HAD_OPV_1
						,'HAD_OPV_2' => $HAD_OPV_2
						,'HAD_OPV_3' => $HAD_OPV_3
						,'HAD_ROTA_1' => $HAD_ROTA_1
						,'HAD_ROTA_2' => $HAD_ROTA_2
						,'HAD_MEASLES' => $HAD_MEASLES
						,'HAD_VITAMIN_A' => $HAD_VITAMIN_A
						,'DO_A' => $DO_A
						,'DO_B' => $DO_B
						,'DO_C' => $DO_C
						,'DO_D' => $DO_D
						,'DO_E' => $DO_E
						,'DO_F' => $DO_F
						,'DO_G' => $DO_G
						,'DO_H' => $DO_H
						,'CREATED_AT' => DB::RAW('CURRENT_TIMESTAMP')
						,'ACTIVE_FLAG' => 1
					)
				);
           
            // return response()->json(['message' => $newborn_nonresident_recent]);
        }
	}
	
	public function SpecificInfant(Request $request){
		$INFANT_ID = $request->INFANT_ID;
		$NONRESIDENT = $request->NONRESIDENT;

		// if($NONRESIDENT == "FALSE"){
			$specific_infant = DB::table('t_hs_infant')
				->where('INFANT_ID', $INFANT_ID)
				->select(
					'INFANT_ID'
					,'NEW_BORN_ID' 
					,'TYPE_OF_HOME_RECORD' 
					,'OPT_DATE' 
					,'OPT_WEIGHT' 
					,'OPT_HEIGHT' 
					,'GP_APRIL_VIT_A' 
					,'GP_OCTOBER_VIT_A' 
					,'SOURCE_OF_SERVICE_RECEIVED' 
					,'HAD_BREASTFEED' 
					,'HAD_PENTA_1' 
					,'HAD_PENTA_2'
					,'HAD_PENTA_3' 
					,'HAD_OPV_1' 
					,'HAD_OPV_2' 
					,'HAD_OPV_3' 
					,'HAD_ROTA_1'
					,'HAD_ROTA_2' 
					,'HAD_MEASLES' 
					,'HAD_VITAMIN_A' 
					,'DO_A'
					,'DO_B'
					,'DO_C' 
					,'DO_D' 
					,'DO_E' 
					,'DO_F'
					,'DO_G'
					,'DO_H'
				)
				->get();
		return response()->json(['specific_infant' => $specific_infant]);
		// }

		// else if($NONRESIDENT == "TRUE"){
		// 	$specific_infant = DB::table('t_hs_infant')
		// 		->where('INFANT_ID', $INFANT_ID)
		// 		->select(
		// 			'INFANT_ID'
		// 			,'NEW_BORN_ID' 
		// 			,'TYPE_OF_HOME_RECORD' 
		// 			,'OPT_DATE' 
		// 			,'OPT_WEIGHT' 
		// 			,'OPT_HEIGHT' 
		// 			,'GP_APRIL_VIT_A' 
		// 			,'GP_OCTOBER_VIT_A' 
		// 			,'SOURCE_OF_SERVICE_RECEIVED' 
		// 			,'HAD_BREASTFEED' 
		// 			,'HAD_PENTA_1' 
		// 			,'HAD_PENTA_2'
		// 			,'HAD_PENTA_3' 
		// 			,'HAD_OPV_1' 
		// 			,'HAD_OPV_2' 
		// 			,'HAD_OPV_3' 
		// 			,'HAD_ROTA_1'
		// 			,'HAD_ROTA_2' 
		// 			,'HAD_MEASLES' 
		// 			,'HAD_VITAMIN_A' 
		// 			,'DO_A'
		// 			,'DO_B'
		// 			,'DO_C' 
		// 			,'DO_D' 
		// 			,'DO_E' 
		// 			,'DO_F'
		// 			,'DO_G'
		// 			,'DO_H'
		// 		)
		// 		->get();
		// return response()->json(['specific_infant' => $specific_infant] );
		// }
		
	}

	public function CRUDFPVisitation(Request $request){
		$fp_id = $request->fp_id;
		$visitation_date = $request->visitation_date;
		$visitation_remarks = $request->visitation_remarks;

		$FPuserAddVisitation = DB::table('t_hs_family_planning_users_visitations')
		->insert(
			array(
				'FP_ID' => $fp_id
				,'VISITATION_DATE' => $visitation_date
				,'VISITATION_REMARKS' => $visitation_remarks
				,'CREATED_AT' => DB::RAW('CURRENT_TIMESTAMP')
				,'ACTIVE_FLAG' => 1
			)
		);
	}

	public function CRUDFamilyPlanning(Request $request){
		
		//BOTH FP & NON FP
		$RESIDENT_ID = $request->RESIDENT_ID;
		$CRUD_STATUS = $request->CRUD_STATUS;
		//FP ONLY
		$FP_METHOD = $request->FP_METHOD;
		$FP_SOURCE = $request->FP_SOURCE;
		//NON FP ONLY
		$IS_INTERESTED_IN_FP = $request->IS_INTERESTED_IN_FP;
		$REASONS_NOT_USING = $request->REASONS_NOT_USING;
		$DATE_OF_VISIT = $request->DATE_OF_VISIT;


		if($CRUD_STATUS == "Add_FP"){
			$FPuserInsert = DB::table('t_hs_family_planning')
			->insert(array(
				'RESIDENT_ID' => $RESIDENT_ID
				,'FP_METHOD' => $FP_METHOD
				,'FP_SOURCE' => $FP_SOURCE
				,'CREATED_AT' => DB::RAW('CURRENT_TIMESTAMP')
				,'ACTIVE_FLAG' => 1
			));

			return response()->json(['message' => "Nakapasok nang Add_FP?"]);
		}

		else if($CRUD_STATUS == "Add_NonFP"){

			$NonFPuserInsert = DB::table('t_hs_non_family_planning_users')
			->insert(
				array(
					'RESIDENT_ID' => $RESIDENT_ID
					,'IS_INTERESTED_IN_FP' => $IS_INTERESTED_IN_FP
					,'REASONS_NOT_USING' => $REASONS_NOT_USING
					,'DATE_OF_VISIT' => $DATE_OF_VISIT
					,'CREATED_AT' => DB::RAW('CURRENT_TIMESTAMP')
					,'ACTIVE_FLAG' => 1
			
				)
			);
			return response()->json(['message' => "Nakapasok nang Add_NFP?"]);
		}
	}

	public function CRUDAdolescent(Request $request){
		$resident_id = $request->resident_id;
		$mmrtd_date = $request->mmrtd_date;
		$is_referred = $request->is_referred;
		$date_of_visit = $request->date_of_visit;
		$remarks = $request->remarks;
		$cs_diabetic = $request->cs_diabetic;
		$cs_mataas_presyon = $request->cs_mataas_presyon;
		$cs_cancer = $request->cs_cancer;
		$cs_bukol = $request->cs_bukol;


		$adolescentInsert = DB::table('t_hs_adolescent')
		->insert(array(
			'RESIDENT_ID' => $resident_id
			,'MMRTD_DATE' => $mmrtd_date
			,'IS_REFERRED' => $is_referred
			,'DATE_OF_VISIT' => $date_of_visit
			,'REMARKS' => $remarks
			,'CS_DIABETIC' => $cs_diabetic
			,'CS_MATAAS_PRESYON' => $cs_mataas_presyon
			,'CS_CANCER' => $cs_cancer
			,'CS_BUKOL' => $cs_bukol
			,'CREATED_AT' => DB::RAW('CURRENT_TIMESTAMP')
			,'ACTIVE_FLAG' => 1
					// ,'' => $
		));
	}

	public function CRUDPostpartum(Request $request){
		$pregnant_id = $request->pregnant_id;
		$birth_place = $request->birth_place;
		$birth_coordinator = $request->birth_coordinator;
		$is_fp_user = $request->is_fp_user;
		$interested_in_fp = $request->interested_in_fp;
		// $source_of_service_received = $request->source_of_service_received;
		$birth_date = $request->birth_date;
		$had_breastfedd_1_hr = $request->had_breastfedd_1_hr;
		$had_postnatal_24_hrs = $request->had_postnatal_24_hrs;
		$had_postnatal_72_hrs = $request->had_postnatal_72_hrs;
		$had_postnatal_7_days = $request->had_postnatal_7_days;
		$pp_do_a = $request->pp_do_a;
		$pp_do_b = $request->pp_do_b;
		$pp_do_c = $request->pp_do_c;
		$pp_do_d = $request->pp_do_d;
		$ferrous_sulfate = $request->ferrous_sulfate;
		$vitamin_a = $request->vitamin_a;
		$ssr = $request->ssr;
		$CRUD_STATUS = $request->CRUD_STATUS;
		$post_partum_id = $request->post_partum_id;

		if($CRUD_STATUS == "Add"){
			$PostpartumInsert = DB::table('t_hs_post_partum')
				->insert(array(
					'PREGNANT_ID' => $pregnant_id
					,'BIRTH_PLACE' => $birth_place
					,'BIRTH_COORDINATOR' => $birth_coordinator
					,'IS_FP_USER' => $is_fp_user
					,'INTERESTED_IN_FP' => $interested_in_fp
					,'BIRH_DATE' => $birth_date
					,'HAD_BREASTFEED_1_HR' => $had_breastfedd_1_hr
					,'HAD_POSTNATAL_24_HRS' => $had_postnatal_24_hrs
					,'HAD_POSTNATAL_72_HRS' => $had_postnatal_72_hrs
					,'HAD_POSTNATAL_7_DAYS' => $had_postnatal_7_days
					,'DO_A' => $pp_do_a
					,'DO_B' => $pp_do_b
					,'DO_C' => $pp_do_c
					,'DO_D' => $pp_do_d
					,'ferrous_sulfate' => $ferrous_sulfate
					,'vitamin_a' => $vitamin_a
					,'SOURCE_OF_SERVICE_RECEIVED' => $ssr
					,'CREATED_AT' => DB::RAW('CURRENT_TIMESTAMP')
					,'ACTIVE_FLAG' => 1
						// ,'' => $
			));
		}
		if($CRUD_STATUS == "Update"){
			$PostpartUpdate = DB::table('t_hs_post_partum')
				->where('POST_PATRUM_ID', $post_partum_id)
				->update(array(
					'BIRTH_PLACE' => $birth_place
					,'BIRTH_COORDINATOR' => $birth_coordinator
					,'IS_FP_USER' => $is_fp_user
					,'INTERESTED_IN_FP' => $interested_in_fp
					,'BIRH_DATE' => $birth_date
					,'HAD_BREASTFEED_1_HR' => $had_breastfedd_1_hr
					,'HAD_POSTNATAL_24_HRS' => $had_postnatal_24_hrs
					,'HAD_POSTNATAL_72_HRS' => $had_postnatal_72_hrs
					,'HAD_POSTNATAL_7_DAYS' => $had_postnatal_7_days
					,'DO_A' => $pp_do_a
					,'DO_B' => $pp_do_b
					,'DO_C' => $pp_do_c
					,'DO_D' => $pp_do_d
					,'ferrous_sulfate' => $ferrous_sulfate
					,'vitamin_a' => $vitamin_a
					,'SOURCE_OF_SERVICE_RECEIVED' => $ssr
					,'UPDATED_AT' => DB::RAW('CURRENT_TIMESTAMP')
				));
		}



		
		// return route('Postpartum');
	}

	public function SpecificPostpartum(Request $request){
		$postpartum_id = $request->postpartum_id;

		$specific_postpartum = DB::table('t_hs_post_partum')
			->where('POST_PATRUM_ID', $postpartum_id)
			->select()
			->get();
		return response()->json(['specific_postpartum'=> $specific_postpartum]);
	}

	public function CRUDElderly(Request $request){
		$resident_id = $request->resident_id;
		$had_flue_vaccine = $request->had_flue_vaccine;
		$had_pneumoccocal = $request->had_pneumoccocal;
		$remarks = $request->remarks;

    		// dd($had_flue_vaccine);
		$elderlyInsert = DB::table('t_hs_elderly')
		->insert(array(
			'RESIDENT_ID' => $resident_id
			,'HAD_FLUE_VACCINE' => $had_flue_vaccine
			,'HAD_PNEUMOCCOCAL' => $had_pneumoccocal
			,'REMARKS' => $remarks
			// ,'CREATED_AT' => DB::RAW('CURRENT_TIMESTAMP')
			// ,'ACTIVE_FLAG' => 1
		));
	}

	public function CRUDPWD(Request $request){
		$resident_id = $request->resident_id;
		$disability = $request->disability;
		$date_of_death = $request->date_of_death;
		$reason_of_death = $request->reason_of_death;

		$pwdInsert = DB::table('t_hs_pwd')
		->insert(array(
			'RESIDENT_ID' => $resident_id
			,'DISABILITY' => $disability
			,'DATE_OF_DEATH' => $date_of_death
			,'REASON_OF_DEATH' => $reason_of_death
			,'CREATED_AT' => DB::RAW('CURRENT_TIMESTAMP')
			,'ACTIVE_FLAG' => 1
		));

	}

	

public function CRUDPregnant(Request $request){
		$RESIDENT_ID = $request->RESIDENT_ID;
		$TYPE_OF_HOME_RECORD = $request->TYPE_OF_HOME_RECORD;
		$NUMBER_OF_MONTHS_PREGNANT = $request->NUMBER_OF_MONTHS_PREGNANT;
		$HAD_BIRTH_PLAN = $request->HAD_BIRTH_PLAN;
		$BLOOD_TYPE = $request->BLOOD_TYPE;
		$DUE_DATE = $request->DUE_DATE;
		$PREGNANCY_CONCLUSION = $request->PREGNANCY_CONCLUSION;
		$HAD_FERRO_SULFATE_FOLIC_ACID = $request->HAD_FERRO_SULFATE_FOLIC_ACID;
		$HAD_TETANOUS_TOXOID_1 = $request->HAD_TETANOUS_TOXOID_1;
		$HAD_TETANOUS_TOXOID_2 = $request->HAD_TETANOUS_TOXOID_2;
		$HAD_TETANOUS_TOXOID_3 = $request->HAD_TETANOUS_TOXOID_3;
		$HAD_TETANOUS_TOXOID_4 = $request->HAD_TETANOUS_TOXOID_4;
		$HAD_TETANOUS_TOXOID_5 = $request->HAD_TETANOUS_TOXOID_5;
		$PRENATAL_CHECKUP_1TRI = $request->PRENATAL_CHECKUP_1TRI;
		$PRENATAL_CHECKUP_2TRI = $request->PRENATAL_CHECKUP_2TRI;
		$PRENATAL_CHECKUP_3TRI = $request->PRENATAL_CHECKUP_3TRI;
		$DO_A = $request->DO_A;
		$DO_B = $request->DO_B;
		$DO_C = $request->DO_C;
		$DO_D = $request->DO_D;
		$DO_E = $request->DO_E;
		$DO_F = $request->DO_F;
		$DO_G = $request->DO_G;
		$CRUD_STATUS = $request->CRUD_STATUS;
		$PREGNANT_ID = $request->PREGNANT_ID;

		

		if ($CRUD_STATUS == "SpecificPregnant"){
			$specific_pregnant = DB::table("t_hs_pregnant")
				->where('PREGNANT_ID', $PREGNANT_ID)
				->select()
				->get();
			return response()->json(['specific_pregnant' => $specific_pregnant] );
		}

		if($CRUD_STATUS == "RetrievePregnancyRecord"){
			$GET_PREGNANT_ID = DB::table('t_hs_pregnant')
				->select('RESIDENT_ID')
				->where('PREGNANT_ID', $PREGNANT_ID)
				->first();
			$pregnancyRecordWithpregnantid = DB::table('t_hs_pregnant')
				->where('RESIDENT_ID', $GET_PREGNANT_ID->RESIDENT_ID)
				->select('DUE_DATE', 'PREGNANCY_CONCLUSION','CREATED_AT' )
				->get();
			return response()->json(['pregnancy_history' => $pregnancyRecordWithpregnantid] );
		}
		else if ($CRUD_STATUS == "Add"){
			$PregnantInsert = DB::table('t_hs_pregnant')
				->insert(
					array(
						'RESIDENT_ID' => $RESIDENT_ID
						,'TYPE_OF_HOME_RECORD' => $TYPE_OF_HOME_RECORD
						,'NUMBER_OF_MONTHS_PREGNANT' => $NUMBER_OF_MONTHS_PREGNANT
						,'HAD_BIRTH_PLAN' => $HAD_BIRTH_PLAN
						,'BLOOD_TYPE' => $BLOOD_TYPE
						,'DUE_DATE' => $DUE_DATE
						,'PREGNANCY_CONCLUSION' => $PREGNANCY_CONCLUSION
						,'HAD_FERRO_SULFATE_FOLIC_ACID' => $HAD_FERRO_SULFATE_FOLIC_ACID
						,'HAD_TETANOUS_TOXOID_1' => $HAD_TETANOUS_TOXOID_1
						,'HAD_TETANOUS_TOXOID_2' => $HAD_TETANOUS_TOXOID_2
						,'HAD_TETANOUS_TOXOID_3' => $HAD_TETANOUS_TOXOID_3
						,'HAD_TETANOUS_TOXOID_4' => $HAD_TETANOUS_TOXOID_4
						,'HAD_TETANOUS_TOXOID_5' => $HAD_TETANOUS_TOXOID_5
						,'PRENATAL_CHECKUP_1TRI' => $PRENATAL_CHECKUP_1TRI
						,'PRENATAL_CHECKUP_2TRI' => $PRENATAL_CHECKUP_2TRI
						,'PRENATAL_CHECKUP_3TRI' => $PRENATAL_CHECKUP_3TRI
						,'DO_A' => $DO_A
						,'DO_B' => $DO_B
						,'DO_C' => $DO_C
						,'DO_D' => $DO_D
						,'DO_E' => $DO_E
						,'DO_F' => $DO_F
						,'DO_G' => $DO_G
						,'CREATED_AT' => DB::RAW('CURRENT_TIMESTAMP')
						,'ACTIVE_FLAG' => 1
					)
				);
		}
		else if($CRUD_STATUS =="Update"){
			$update = DB::table('t_hs_pregnant')
				->where('PREGNANT_ID', $PREGNANT_ID)
				->update(array(
						'TYPE_OF_HOME_RECORD' => $TYPE_OF_HOME_RECORD
						,'NUMBER_OF_MONTHS_PREGNANT' => $NUMBER_OF_MONTHS_PREGNANT
						,'HAD_BIRTH_PLAN' => $HAD_BIRTH_PLAN
						,'BLOOD_TYPE' => $BLOOD_TYPE
						,'DUE_DATE' => $DUE_DATE
						,'PREGNANCY_CONCLUSION' => $PREGNANCY_CONCLUSION
						,'HAD_FERRO_SULFATE_FOLIC_ACID' => $HAD_FERRO_SULFATE_FOLIC_ACID
						,'HAD_TETANOUS_TOXOID_1' => $HAD_TETANOUS_TOXOID_1
						,'HAD_TETANOUS_TOXOID_2' => $HAD_TETANOUS_TOXOID_2
						,'HAD_TETANOUS_TOXOID_3' => $HAD_TETANOUS_TOXOID_3
						,'HAD_TETANOUS_TOXOID_4' => $HAD_TETANOUS_TOXOID_4
						,'HAD_TETANOUS_TOXOID_5' => $HAD_TETANOUS_TOXOID_5
						,'PRENATAL_CHECKUP_1TRI' => $PRENATAL_CHECKUP_1TRI
						,'PRENATAL_CHECKUP_2TRI' => $PRENATAL_CHECKUP_2TRI
						,'PRENATAL_CHECKUP_3TRI' => $PRENATAL_CHECKUP_3TRI
						,'DO_A' => $DO_A
						,'DO_B' => $DO_B
						,'DO_C' => $DO_C
						,'DO_D' => $DO_D
						,'DO_E' => $DO_E
						,'DO_F' => $DO_F
						,'DO_G' => $DO_G
						,'UPDATED_AT' => DB::RAW('CURRENT_TIMESTAMP')
				));
		}

	}

	public function ChronicCough(Request $request){
		$resident_id = $request->resident_id;
		$had_more_than_2_weeks = $request->had_more_than_2_weeks;
		$date_of_visit = $request->date_of_visit;
		$remarks = $request->remarks;
		$CRUD_STATUS  = $request->CRUD_STATUS;

		$FIRSTNAME = $request->FIRSTNAME;
        $MIDDLENAME = $request->MIDDLENAME;
        $LASTNAME = $request->LASTNAME;
        $SEX = $request->SEX;
        $BIRTHDATE = $request->BIRTHDATE;

        if($CRUD_STATUS == "Add_Resident"){
        	 $chronicCoughInsert = DB::table('t_hs_chronic_cough')
				->insert(
					array(
						'RESIDENT_ID' => $request->resident_id
						,'HAD_MORE_THAN_2_WEEKS' =>  $request->had_more_than_2_weeks
						,'DATE_OF_VISIT' => $request->date_of_visit
						,'REMARKS' => $request->remarks
						,'CREATED_AT' => date('Y-m-d')
						,'ACTIVE_FLAG' => 1
					));
        	return response()->json(['message' => 'This is Add_Resident'] );
        }
        else if($CRUD_STATUS == "Add_NonResident"){
			$insertNonResident = DB::table('t_nonresident_basic_info')
                ->insert(array(
                    'FIRST_NAME' => $FIRSTNAME
                    ,'MIDDLE_NAME' => $MIDDLENAME
                    ,'LAST_NAME' => $LASTNAME
                    ,'SEX' => $SEX
                    ,'BIRTHDATE' => $BIRTHDATE
                ));

            $nonresident_recent = DB::table('t_nonresident_basic_info')->select('NONRESIDENT_ID')->latest('NONRESIDENT_ID')->first();

            $chronicCoughInsert = DB::table('t_hs_chronic_cough')
			->insert(
				array(
					'NONRESIDENT_ID' => $nonresident_recent->NONRESIDENT_ID
					,'HAD_MORE_THAN_2_WEEKS' =>  $request->had_more_than_2_weeks
					,'DATE_OF_VISIT' => $request->date_of_visit
					,'REMARKS' => $request->remarks
					,'CREATED_AT' => date('Y-m-d')
					,'ACTIVE_FLAG' => 1
				));
	        	return response()->json(['message' => 'This is Add_NonResident'] );	
        }

        else if ($CRUD_STATUS == "SpecificResidentHistory"){
        	
        	$specific_illness = DB::table('t_hs_chronic_cough')
				->where('RESIDENT_ID', $resident_id)
				->select()
				->get();

        	return response()->json(['specific_illness' => $specific_illness, 'resident_id'=> $resident_id]);
        }

        else if ($CRUD_STATUS == "SpecificNonResidentHistory"){
        	
        	$specific_illness = DB::table('t_hs_chronic_cough')
				->where('NONRESIDENT_ID', $resident_id)
				->select()
				->get();

        	return response()->json(['specific_illness' => $specific_illness]);
        }


	}

	public function ChronicDiseases(Request $request){
		$resident_id = $request->resident_id;
		$chronic_disease_name = $request->chronic_disease_name;
		$had_high_fever = $request->had_high_fever;
		$date_of_visit = $request->date_of_visit;
		$remarks = $request->remarks;

    	//insert chronic disease table
		$chronicDiseasesInsert = DB::table('t_hs_chronic_disease')
		->insert(array(
			'RESIDENT_ID' => $resident_id
			,'CHRONIC_DISEASE_NAME' => $chronic_disease_name
			,'HAD_HIGH_FEVER' => $had_high_fever
			,'DATE_OF_VISIT' => $date_of_visit
			,'REMARKS' => $remarks
			,'CREATED_AT' => date('Y-m-d')
			,'ACTIVE_FLAG' => 1
		));

	}


}