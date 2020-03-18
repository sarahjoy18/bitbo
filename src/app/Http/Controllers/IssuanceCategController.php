<?php

namespace App\Http\Controllers;

use App\Models\RISSUANCECATEGORY;
use Illuminate\Http\Request;
USE Carbon\Carbon;
use DB;
class IssuanceCategController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {   

        $displaydata = DB::TABLE('r_issuance_category')->WHERE('ACTIVE_FLAG',1)->GET();
        return view('administration.issuancecat',compact('displaydata'));
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
        DB::TABLE('r_issuance_category')
        ->INSERT(
        [
            'ISSUANCE_NAME' => request('AddCatName'),
            //'ISSUANCE_TYPE' => request('AddCatType'),
            'ISSUANCE_DESCRIPTION' => request('AddCatDesc'),
            'CREATED_AT' => Carbon::now()
        ]);
        return redirect()->route('IssuanceCategory');               
    }


    /**
     * Display the specified resource.
     *
     * @param  \App\issuancecateg  $issuancecateg
     * @return \Illuminate\Http\Response
  
    /**
     * Show the form for editing the specified resource.
     *
     * @param  \App\issuancecateg  $issuancecateg
     * @return \Illuminate\Http\Response
     */
    public function edit()
    {

        DB::TABLE('r_issuance_category')
        ->WHERE('ISSUANCE_CATEGORY_ID',request('CategoryID'))
        ->UPDATE(
        [
            'ISSUANCE_NAME'=>request('EditCatName'), 
            //'ISSUANCE_TYPE'=>request('EditCatType'), 
            'ISSUANCE_DESCRIPTION' => request('EditCatDesc'),
            'UPDATED_AT' => Carbon::now()
        ]);
        return redirect()->route('IssuanceCategory');    

    }

    public function delete()
    {

        if(request('Status') == 1)
        {
            DB::TABLE('r_issuance_category')
            ->WHERE('ISSUANCE_CATEGORY_ID',request('CategoryID'))
            ->UPDATE(['ACTIVE_FLAG' => 0, 'UPDATED_AT' => Carbon::now()]);
        }
        else
        {
            DB::TABLE('r_issuance_category')
            ->WHERE('ISSUANCE_CATEGORY_ID',request('CategoryID'))
            ->UPDATE(['ACTIVE_FLAG' => 1, 'UPDATED_AT' => Carbon::now()]);

        }   
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \App\issuancecateg  $issuancecateg
     * @return \Illuminate\Http\Response
     */
   

    /**
     * Remove the specified resource from storage.
     *
     * @param  \App\issuancecateg  $issuancecateg
     * @return \Illuminate\Http\Response
     */
   
}
