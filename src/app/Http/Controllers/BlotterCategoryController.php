<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Carbon\Carbon;
class BlotterCategoryController extends Controller
{
    public function index() 
    {
    	$displaydata = \DB::TABLE('r_blotter_subjects')->WHERE('ACTIVE_FLAG', 1)->GET();
    	return view('administration.blottersubj', compact('displaydata'));
    	//dd($displaydata);
    }


    public function store(Request $request)
    {
    	
    	\DB::TABLE('r_blotter_subjects')
    	->INSERT(
    		[
    			'BLOTTER_NAME' => request('AddCatName'), 
    			'CREATED_AT' => CARBON::NOW(), 
    			'ACTIVE_FLAG' => 1
    		]);
    	return redirect('BlotterSubjects');
    }

    public function edit(Request $request) {

    	\DB::TABLE('r_blotter_subjects')
    	->WHERE('BLOTTER_SUBJECT_ID', request('EditCatID'))
    	->UPDATE(
    		[
    			'BLOTTER_NAME' => request('EditCatName'), 
    			'UPDATED_AT' => CARBON::NOW() 
    		]);
    	return redirect('BlotterSubjects');
    }
}
