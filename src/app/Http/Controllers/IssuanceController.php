<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use DB;
use App\Classes\Classification\KNearestNeighbors;

class IssuanceController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response 
     */
    public function index()
    {


        $nature = DB::table('r_business_nature')
        ->pluck('BUSINESS_NATURE_NAME','BUSINESS_NATURE_ID');

        $location = DB::table('r_barangay_zone')
        ->pluck('BARANGAY_ZONE_NAME','BARANGAY_ZONE_ID');

        $residents = DB::table('t_resident_basic_info')
        ->select('RESIDENT_ID','LASTNAME')
        ->where('active_flag', 1)
        ->get();

        $i = 1;

        $issuancename = DB::table('r_issuance_category')
        ->where('ISSUANCE_NAME','<>','Business')
        ->Where('active_flag', 1)
        ->pluck('ISSUANCE_NAME','ISSUANCE_CATEGORY_ID'); 

        $issuancebname = B::table('r_issuance_category')
        ->where('ISSUANCE_NAME','<>','Personal')
        ->Where('active_flag', 1)
        ->pluck('ISSUANCE_NAME','ISSUANCE_CATEGORY_ID');    

        // $personalissuances = DB::table('t_issuance')
        // ->join('r_issuance_type','t_issuance.issuance_type_id','r_issuance_type.issuance_type_id')
        // ->join('r_resident','t_issuance.resident_id','r_resident.resident_id')
        // ->select('issuance_id','resident_name','issuance_name', 'issuance_purpose','issuance_date','status','remarks')
        // ->get();

        // $records = DB::table('t_business')
        //     ->join('r_business_nature','t_business.business_nature','r_business_nature.business_nature_id')
        //     ->join('r_barangay_zone','t_business.location_id','r_barangay_zone.barangay_zone_id')
        //     ->select(
        //                 'business_name','business_nature_name','barangay_zone_name',
        //                 'business_owner','business_address',
        //                 'business_or_number','business_or_acquired_date','business_id'
        //             )
        //     ->where('t_business.active_flag', 1)
        //     ->get();

        //dd ($personalissuances);
        return view('issuance.issuance', compact('i','residents','issuancename','nature','location','issuancebname'));
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function personal()
    {
        //

        $nature = DB::table('r_business_nature')
        ->pluck('BUSINESS_NATURE_NAME','BUSINESS_NATURE_ID');

        $location = DB::table('r_barangay_zone')
        ->pluck('BARANGAY_ZONE_NAME','BARANGAY_ZONE_ID');

        $residents = DB::table('t_resident_basic_info')
        ->select('RESIDENT_ID','LASTNAME')
        ->where('active_flag', 1)
        ->get();
        $i = 1;

        
        $issuancename = DB::table('r_issuance_category')
        ->where('ISSUANCE_NAME','<>','Business')
        ->Where('active_flag', 1)
        ->pluck('ISSUANCE_NAME','ISSUANCE_CATEGORY_ID'); 

        $issuancebname = B::table('r_issuance_category')
        ->where('ISSUANCE_NAME','<>','Personal')
        ->Where('active_flag', 1)
        ->pluck('ISSUANCE_NAME','ISSUANCE_CATEGORY_ID');     

        // $personalissuances = DB::table('t_issuance')
        // ->join('r_issuance_type','t_issuance.issuance_type_id','r_issuance_type.issuance_type_id')
        // ->join('r_resident','t_issuance.resident_id','r_resident.resident_id')
        // ->select('issuance_id','resident_name','issuance_name', 'issuance_purpose','issuance_date','status','remarks')
        // ->where('issuance_type','Personal')
        // ->get();

        // $records = DB::table('t_business')
        //     ->join('r_business_nature','t_business.business_nature','r_business_nature.business_nature_id')
        //     ->join('r_barangay_zone','t_business.location_id','r_barangay_zone.barangay_zone_id')
        //     ->select(
        //                 'business_name','business_nature_name','barangay_zone_name',
        //                 'business_owner','business_address',
        //                 'business_or_number','business_or_acquired_date','business_id'
        //             )
        //     ->where('t_business.active_flag', 1)
        //     ->get();

        //dd ($personalissuances);
        return view('issuance.personal', compact('i','residents','issuancename','nature','location','issuancebname'));
    }





 public function business()
    {
        //

        $nature = DB::table('r_business_nature')
        ->pluck('BUSINESS_NATURE_NAME','BUSINESS_NATURE_ID');

        $location = DB::table('r_barangay_zone')
        ->pluck('BARANGAY_ZONE_NAME','BARANGAY_ZONE_ID');
        
        $residents = DB::table('t_resident_basic_info')
        ->select('RESIDENT_ID','LASTNAME')
        ->where('active_flag', 1)
        ->get();
        
        $i = 1;

        $issuancename = DB::table('r_issuance_category')
        ->where('ISSUANCE_NAME','<>','Business')
        ->Where('active_flag', 1)
        ->pluck('ISSUANCE_NAME','ISSUANCE_CATEGORY_ID'); 

        $issuancebname = B::table('r_issuance_category')
        ->where('ISSUANCE_NAME','<>','Personal')
        ->Where('active_flag', 1)
        ->pluck('ISSUANCE_NAME','ISSUANCE_CATEGORY_ID');      

        // $personalissuances = DB::table('t_issuance')
        // ->join('r_issuance_type','t_issuance.issuance_type_id','r_issuance_type.issuance_type_id')
        // ->join('r_resident','t_issuance.resident_id','r_resident.resident_id')
        // ->select('issuance_id','resident_name','issuance_name', 'issuance_purpose','issuance_date','status','remarks')
        // ->get();

        // $records = DB::table('t_business')
        //     ->join('t_issuance','t_issuance.business_id','t_business.business_id')
        //     ->join('r_business_nature','t_business.business_nature','r_business_nature.business_nature_id')
        //     ->join('r_barangay_zone','t_business.location_id','r_barangay_zone.barangay_zone_id')
        //     ->select(
        //                 'business_name','business_nature_name','barangay_zone_name',
        //                 'business_owner','business_address',
        //                 'business_or_number','business_or_acquired_date','t_business.business_id',
        //                 'status','remarks'
        //             )
        //     ->where('t_business.active_flag', 0)
        //     ->get();

        //dd ($personalissuances);
        return view('issuance.business', compact('i','residents','issuancename','nature','location','issuancebname'));
    }
    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
       
        if($request->ajax())
        {
            
            // DB::table('t_issuance')
            // ->insert
            // (
            //     array
            //     (
            //         'issuance_type_id' => request('personaliname'),
            //         'resident_id'      => request('residentid'),
            //         'issuance_purpose' => request('personalpurpose'),
            //         'issuance_date'    => request('personalapplied'),
            //         'status'           => 'Pending',
            //         'remarks'          => 'N/A',
            //         'created_at'       => DB::raw('CURRENT_TIMESTAMP'),
            //         'business_id'      => null
            //     )   
            // );
        }
    }

    public function storebusinesses(Request $request)
    {
        if($request->ajax())
        {

            // $last_id = DB::table('t_business')
            // ->insertGetId
            // (
            //      array
            //      (
            //         'business_name'             => request('businessname'),
            //         'business_nature'           => request('businessnature'),
            //         'location_id'               => request('location'),
            //         'business_owner'           => request('firstname').' '.request('middlename').' '.request('lastname'),
                   
                
            //         'business_address'          => request('businessaddress'),
                
            //         'created_at'                => DB::raw('CURRENT_TIMESTAMP')
            //     )

            // );

            // DB::table('t_issuance')
            // ->insert
            // (
            //     array
            //     (
            //         'issuance_type_id' => request('issuance_type'),
            //         'resident_id'      => request('residentid'),
            //         'issuance_purpose' => 'business',
            //         'status'           => 'pending',
            //         'remarks'          => 'N/A',
            //         'created_at'       => DB::raw('CURRENT_TIMESTAMP'),
            //         'business_id'      => $last_id
            //     )   
            // );
        }
    }



    public function algor()
    {
        $classifier = new KNearestNeighbors($k=4);
       
    }
    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show($id)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function edit($id)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, $id)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy($id)
    {
        //
    }
}
