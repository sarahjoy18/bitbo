<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use DB;

class BlotterSubjectsController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        $Displaycats = DB::Table('r_blotter_subjects')
                            -> select('blotter_subject_id'
                                    , 'blotter_name')
                            -> get();
        
        return view('administration.blottersubj', compact('Displaycats'));
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        //
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
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

    /**
     * Display the specified resource.
     *
     * @param  \App\blottersubject  $blottersubject
     * @return \Illuminate\Http\Response
     */
    public function show(blottersubject $blottersubject)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  \App\blottersubject  $blottersubject
     * @return \Illuminate\Http\Response
     */
    public function edit(blottersubject $blottersubject)
    {
        
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \App\blottersubject  $blottersubject
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, blottersubj $blottersubj)
    {
        $getID = $request->input('EditCatID');

        $EditCateg = DB::table('r_blotter_subjects')
                        ->where('blotter_subject_id', $getID)
                        ->upadte(['blotter_name'=>$request->input('EditCatName')
                    ]);

        return redirect('BlotterSubjects');
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  \App\blottersubject  $blottersubject
     * @return \Illuminate\Http\Response
     */
    public function destroy(blottersubject $blottersubject)
    {
        //
    }
}
