<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class IssuanceHistory extends Controller
{
    public function index(){

    	$issuancehistory = DB::table('t_issuance AS I')
            ->leftjoin('t_resident_basic_info AS R', 'I.RESIDENT_ID', 'R.RESIDENT_ID')
            ->join('r_issuance_category AS IC', 'IC.ISSUANCE_CATEGORY_ID', 'I.ISSUANCE_TYPE_ID')
            ->select(
                'I.ISSUANCE_ID'
                ,'I.ISSUANCE_NUMBER'
                ,'I.ISSUANCE_TYPE_ID'
                ,'I.ISSUANCE_PURPOSE'
                ,'I.ISSUANCE_DATE'
                ,'I.STATUS'
                ,'I.RECEIVED_BY'
                ,'R.FIRSTNAME'
                ,'R.MIDDLENAME'
                ,'R.LASTNAME'
                ,'IC.ISSUANCE_NAME'
                ,'I.REMARKS'
            )
            ->get();

            // dd($personalissuance);

            return view('certificateandforms.issuance_history', compact('issuancehistory'));
    }
}
