<?php

namespace App\Http\Controllers;

use App\Models\RBUSINESSNATURE;
use Illuminate\Http\Request;
use Carbon\Carbon;
use DB;
class BusinessCategController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        
        $displaydata = \DB::TABLE('r_business_nature')->WHERE('ACTIVE_FLAG',1)->GET();
        return view('administration.businesscat', compact('displaydata'));
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    
    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
       
        db::table('r_business_nature')
        ->insert([
            'BUSINESS_NATURE_NAME' => request('AddCatName'),
            'BUSINESS_NATURE_DESCRIPTION' => request('AddCatDesc'),
            'CREATED_AT' => \DB::RAW('CURRENT_TIMESTAMP'),
            'ACTIVE_FLAG' => 1

        ]);
        return redirect('BusinessCategory');
    }

    /**
     * Display the specified resource.
     *
     * @param  \App\businesscategs  $businesscategs
     * @return \Illuminate\Http\Response
     */
    public function show(businesscategs $businesscategs)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  \App\businesscategs  $businesscategs
     * @return \Illuminate\Http\Response
     */
    public function edit(Request $request)
    {
        $edit = RBUSINESSNATURE::FIND(request('EditCatID'));
        // dd($edit);
        $edit->BUSINESS_NATURE_NAME = request ('EditCatName');
        $edit->BUSINESS_NATURE_DESCRIPTION = request ('EditCatDesc');
        $edit->UPDATED_AT = Carbon::now();
        $edit->save();
        return redirect('BusinessCategory');
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \App\businesscategs  $businesscategs
     * @return \Illuminate\Http\Response
     */
  

    /**
     * Remove the specified resource from storage.
     *
     * @param  \App\businesscategs  $businesscategs
     * @return \Illuminate\Http\Response
     */
    public function destroy(businesscategs $businesscategs)
    {
        //
    }

}
