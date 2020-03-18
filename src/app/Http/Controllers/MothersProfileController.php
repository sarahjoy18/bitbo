<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use DB;
use Carbon\Carbon;

class MothersProfileController extends Controller
{
    public function index() 
    {

        $MotherTable = DB::TABLE('t_mothers_profile AS M')
                        ->JOIN('t_resident_basic_info AS T','M.RESIDENT_ID','T.RESIDENT_ID')
                        ->WHERE('T.SEX', 'Female')
                        ->SELECT(
                                    'M.MOTHERS_ID','M.IS_PREGNANT','M.MOTHER_MOTHER_TONGUE',
                                    'M.MOTHER_OTHER_DIALECTS','M.MOTHER_EDUCATIONAL_ATTAINMENT',
                                    'T.LASTNAME','T.FIRSTNAME','T.MIDDLENAME','T.ACTIVE_FLAG'
                                )
                        ->GET();

    	return view('resident.mothersprofile', compact('MotherTable'));
      
    }

    public function loadresident()
    {
         $display_data = DB::TABLE('t_resident_basic_info AS T')
         ->WHERE('T.SEX','Female')
            ->whereNotIn('T.RESIDENT_ID',DB::TABLE('t_fathers_profile')->SELECT('RESIDENT_ID'))
            ->whereNotIn('T.RESIDENT_ID',DB::TABLE('t_mothers_profile')->SELECT('RESIDENT_ID'))
            ->whereBetween(DB::raw('(YEAR(CURDATE())-YEAR(DATE_OF_BIRTH))'),[9,99])
            ->SELECT('T.RESIDENT_ID','T.LASTNAME','T.FIRSTNAME','T.MIDDLENAME','T.QUALIFIER','T.SEX','T.DATE_OF_BIRTH','T.CIVIL_STATUS','T.OCCUPATION','T.WORK_STATUS'); 

        return datatables()->of($display_data)->addIndexColumn()->make(true);
    }

    public function store(Request $request)
    {
    	DB::TABLE('t_mothers_profile')
    	->INSERT(
            [

                'IS_PREGNANT' => request('is_pregnant'),
                'MOTHER_MOTHER_TONGUE' => request('m_tongue'),
                'MOTHER_OTHER_DIALECTS' => request('other_dialect'),
                'MOTHER_EDUCATIONAL_ATTAINMENT' => request('m_educattain'),
                'RESIDENT_ID' => request('resident_id'),
                'CREATED_AT' => Carbon::now(),
            ]
    	);
    	echo "good";
    }


    public function edit()
    {
    	DB::TABLE('t_mothers_profile')
        ->WHERE('MOTHERS_ID',request('mother_id'))
        ->UPDATE
        (
           [

                'IS_PREGNANT' => request('is_pregnant'),
                'MOTHER_MOTHER_TONGUE' => request('m_tongue'),
                'MOTHER_OTHER_DIALECTS' => request('other_dialect'),
                'MOTHER_EDUCATIONAL_ATTAINMENT' => request('m_educattain'),
                'UPDATED_AT' => Carbon::now(),
            ]
        );
        echo "good";
    }
}
