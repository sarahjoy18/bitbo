<?php

namespace App\Http\Controllers;

use App\Models\RORDINANCECATEGORY;
use Illuminate\Http\Request;
use Carbon\Carbon;
use DB;
class OrdinanceCategController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {  
        $displaydata = DB::TABLE('r_ordinance_category')->GET();
        return view('administration.ordinancecat',compact('displaydata'));
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
        DB::TABLE('r_ordinance_category')
        ->INSERT([ 'ORDINANCE_CATEGORY_NAME' => request('AddCatName'), 'CREATED_AT' => CARBON::NOW(), 'ACTIVE_FLAG' => 1]);
        return redirect()->route('OrdinanceCategory');               
    }

    /**
     * Display the specified resource.
     *
     * @param  \App\ordinancecateg  $ordinancecateg
     * @return \Illuminate\Http\Response
     */
    public function show(ordinancecateg $ordinancecateg)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  \App\ordinancecateg  $ordinancecateg
     * @return \Illuminate\Http\Response
     */
    public function edit()
    {

        DB::TABLE('r_ordinance_category')
        ->WHERE('ORDINANCE_CATEGORY_ID',request('CategoryID'))
        ->UPDATE([ 'ORDINANCE_CATEGORY_NAME' => request('EditCatName'), 'UPDATED_AT' => CARBON::NOW() ]);
        return redirect()->route('OrdinanceCategory');    

    }


    public function delete()
    {

        if(request('Status') == 1)
        {
            DB::TABLE('r_ordinance_category')
            ->WHERE('ORDINANCE_CATEGORY_ID',request('CategoryID'))
            ->UPDATE([ 'ACTIVE_FLAG' => 0, 'UPDATED_AT' => CARBON::NOW()]);
        }
        else
        {
            DB::TABLE('r_ordinance_category')
            ->WHERE('ORDINANCE_CATEGORY_ID',request('CategoryID'))
            ->UPDATE([ 'ACTIVE_FLAG' => 1, 'UPDATED_AT' => CARBON::NOW()]);
        }   

    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \App\ordinancecateg  $ordinancecateg
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, ordinancecateg $ordinancecateg)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  \App\ordinancecateg  $ordinancecateg
     * @return \Illuminate\Http\Response
     */
    public function destroy(ordinancecateg $ordinancecateg)
    {
        //
    }
}
