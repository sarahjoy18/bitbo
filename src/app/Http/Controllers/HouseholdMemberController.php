<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use DB;

class HouseholdMemberController extends Controller
{
    public function index($id)
    {
        
        //dd($id);
        
        if ($id == "null") {
            $id = 0;
        }

    	$result = db::select("call sp_gethousehold_mebers(?)",[$id]);
        //return view('queriesreports.rbi_report', compact('result','id'));
    	return view('resident.householdmembers', compact('result','id'));

    }

    public function hh_list()
    {
        return view('queriesreports.hh_list');
    }

    public function view_rbi($id)
    {
        $brgy_id = session('session_brgy_id');
        $municipalinfo = db::select("call sp_municipal_info(?)",[$brgy_id]);
        if ($id == "null" || $id == "") {
            $id = 0;
        }
        //dd($municipalinfo);
        $houseno = db::select("call sp_house_no(?)",[$id]);
        $result = db::select("call sp_gethousehold_mebers(?)",[$id]);
        return view('queriesreports.rbi_report', compact('result','id','houseno','municipalinfo'));
    }

    public function addmember()
    {
    	$relationtohead = request('reltohead');
    	db::table('t_household_members')->insert([
    		'FAMILY_HEADER_ID' => request('header_id'),
    		'RESIDENT_ID' => request('resident_id')
    	]);

    	db::table('t_resident_basic_info')->where('RESIDENT_ID', request('resident_id'))
    		->update([
    			'RELATION_TO_HOUSEHOLD_HEAD' =>  $relationtohead
    	]);

    	if (strtolower($relationtohead) == "mother") {
    		$result = db::table('t_mothers_profile')->where('resident_id',request('resident_id'))->count();
    		if($result == 0) {
    			 db::table('t_mothers_profile')->insert([
    			 	'RESIDENT_ID' => request('resident_id'),
    			 	'CREATED_AT' => DB::RAW('CURRENT_TIMESTAMP'),
    			 	'ACTIVE_FLAG' => 1
    			 ]);
    		}

    	} else if (strtolower($relationtohead) == "father"){
    		$result = db::table('t_fathers_profile')->where('resident_id',request('resident_id'))->count();
    		if($result == 0) {
    			 db::table('t_fathers_profile')->insert([
    			 	'RESIDENT_ID' => request('resident_id'),
    			 	'CREATED_AT' => DB::RAW('CURRENT_TIMESTAMP'),
    			 	'ACTIVE_FLAG' => 1
    			 ]);
    		}
    	}

    	echo "good";
    }
}
