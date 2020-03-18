<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use DB;

class FathersProfileController extends Controller
{
    
    public function index() 
    {

        $FatherTable = DB::TABLE('t_fathers_profile AS F')
                        ->JOIN('t_resident_basic_info AS T','F.RESIDENT_ID','T.RESIDENT_ID')
                        ->WHERE('T.SEX', 'Male')
                        ->SELECT
                        (
                            'F.FATHERS_ID','F.FATHER_MOTHER_TONGUE',
                            'F.FATHER_OTHER_DIALECTS','F.FATHER_EDUCATIONAL_ATTAINMENT',
                            'T.LASTNAME','T.FIRSTNAME','T.MIDDLENAME','T.ACTIVE_FLAG'
                        )
                        ->GET();

         // dd($DisplayTable);
         return view('resident.fathersprofile', compact('FatherTable'));
    }   

    public function loadresident()
    {
         $display_data = DB::TABLE('t_resident_basic_info AS T')
            ->WHERE('T.SEX', 'Male')
            ->whereNotIn('T.RESIDENT_ID',DB::TABLE('T_FATHERS_PROFILE')->SELECT('RESIDENT_ID'))
            ->whereNotIn('T.RESIDENT_ID',DB::TABLE('T_MOTHERS_PROFILE')->SELECT('RESIDENT_ID'))
            ->whereBetween(DB::raw('(YEAR(CURDATE())-YEAR(DATE_OF_BIRTH))'),[18,60])
            ->SELECT('T.RESIDENT_ID','T.LASTNAME','T.FIRSTNAME','T.MIDDLENAME','T.QUALIFIER','T.SEX','T.DATE_OF_BIRTH','T.CIVIL_STATUS','T.OCCUPATION','T.WORK_STATUS'); 

        return datatables()->of($display_data)->addIndexColumn()->make(true);
    }

    public function store(Request $request)
    {
        DB::TABLE('t_fathers_profile')
        ->INSERT(
            [
                'FATHER_MOTHER_TONGUE' => request('m_tongue'),
                'FATHER_OTHER_DIALECTS' => request('other_dialect'),
                'FATHER_EDUCATIONAL_ATTAINMENT' => request('m_educattain'),
                'RESIDENT_ID' => request('resident_id')
            ]
        );
        echo "good";
    }



    public function edit()
    {
        DB::TABLE('t_fathers_profile')
        ->WHERE('FATHERS_ID',request('father_id'))
        ->UPDATE(
            [
                'FATHER_MOTHER_TONGUE' => request('m_tongue'),
                'FATHER_OTHER_DIALECTS' => request('other_dialect'),
                'FATHER_EDUCATIONAL_ATTAINMENT' => request('m_educattain')
            ]
        );
        echo "good";
    }
}
