<?php

namespace App\Http\Controllers;

use App\Municipality;

use App\municipalityacc;
use App\user;
use Illuminate\Http\Request;
use Mail;
class MunicipalityController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        //
       // $MunicipalData=municipalityacc::all();
        return view('setup.municipality');
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
        $InserMunicipalAccount= new Municipality();
        $InserMunicipalAccount->add_municipal_account();
        return redirect('Municipality');
    }
    /**
     * Display the specified resource.
     *
     * @param  \App\Municipality  $municipality
     * @return \Illuminate\Http\Response
     */
    public function show(Municipality $municipality)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  \App\Municipality  $municipality
     * @return \Illuminate\Http\Response
     */
    public function edit(Municipality $municipality)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \App\Municipality  $municipality
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, Municipality $municipality)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  \App\Municipality  $municipality
     * @return \Illuminate\Http\Response
     */
    public function destroy(Request $request,Municipality $municipality)
    {
        //

    $DeleteMunicipal=municipalityacc::where('municipal_position_id',request('id'))->first();
    
    $DeleteMunicipal->delete();

    }
/*
     public function SendToEmail(Request $request)
    {

        Mail::send([], ['name'=>'Helloworld'],function($message)
        {
         
            $message->to('johnedcelzenarosa@gmail.com','Send Mail Sample')->subject('Sample mail')->setBody('Sample Body');

            echo 'success';
        });

      
 
    }
    */

}
