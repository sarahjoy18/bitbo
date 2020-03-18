<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Carbon\Carbon;
use DB;

class BlottersController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */

        

    public function index(request $request)
    {
       // $blottersub = DB::table('blottersubjects')->pluck('blotter_subject_name', 'blotter_subject_id');
        $getBlotterID =  $request->input('EditBlotterIDH');

        $blottersub = DB::table('r_blotter_subjects')
                            ->select('blotter_subject_id'
                                , 'blotter_name') 
                            ->where(['active_flag' => '1'])
                            ->orderBy('created_at', 'desc')
                            ->get();

        $resident = DB::table('t_resident_basic_info')
                            ->select('resident_id'
                                , 'lastname'
                                , 'middlename'
                                , 'firstname')
                            ->orderBy('created_at', 'desc')
                            ->get();

        $dispblotter = DB::table('t_blotter AS B')                            
                            ->leftjoin('t_resident_basic_info AS R', 'B.accused_resident', '=', 'R.resident_id')
                            ->select('B.blotter_id'
                                , 'B.blotter_code'
                                , 'B.blotter_subject_id'
                                , 'B.incident_date'
                                , 'B.incident_area'
                                , 'B.complaint_name'
                                , 'B.respondent'
                                , 'B.complaint_date'
                                , 'B.complaint_statement'
                                , 'B.resolution'
                                , 'B.status'
                                , 'B.blotter_subject'
                                , 'R.resident_id'
                                , 'R.lastname'
                                , 'R.middlename'
                                , 'R.firstname'
                                , 'B.NO_OF_PATAWAG')
                            ->where(['B.status' => 'Pending'])
                            ->where(['B.ACTIVE_FLAG' => 1])
                            ->orderBy('B.complaint_date', 'desc')
                            ->get();

        $resolvedBlotter = DB::table('t_blotter AS B')
                            
                            ->leftjoin('t_resident_basic_info AS R', 'B.accused_resident', '=', 'R.resident_id')
                            ->select('B.blotter_id'
                                , 'B.blotter_code'
                                , 'B.blotter_subject_id'
                                , 'B.incident_date'
                                , 'B.incident_area'
                                , 'B.complaint_name'
                                , 'B.respondent'
                                , 'B.complaint_date'
                                , 'B.complaint_statement'
                                , 'B.resolution'
                                , 'B.closed_date'
                                , 'B.status'
                                , 'B.blotter_subject'
                                , 'R.resident_id'
                                , 'R.lastname'
                                , 'R.middlename'
                                , 'R.firstname')
                            ->where(['B.status' => 'Resolved'])
                            ->orWhere(['B.status' => 'For Referral'])                            
                            ->orderBy('B.closed_date', 'desc')
                            ->get();

       
        return view('cases.blotter', compact('dispblotter', 'blottersub', 'resident', 'resolvedBlotter'));
        // dd($blottersub); 
        
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

        $getID = DB::table('t_blotter')->insertGetId([
                                                    'blotter_subject'=>$request->input('add_blotter_subject_id'),
                                                    'incident_date'=>$request->input('add_incident_date'),
                                                    'incident_area'=>$request->input('add_incident_area'),
                                                    'complaint_name'=>$request->input('add_complainant_name'),
                                                    'respondent'=>$request->input('add_resident_id'),
                                                    'complaint_statement'=>$request->input('add_complain_statement'),
                                                    'complaint_date'=>Carbon::today()->toDateString(),
                                                    'created_at'=>\DB::RAW("CURRENT_TIMESTAMP")
                                                    ]);
        $blotterCode = "BLOT"."-".$getID;

        $updateBlot=DB::table('t_blotter')
                        ->where('blotter_id',$getID)
                        ->update([ 'blotter_code'=>$blotterCode ]);

        return redirect('Blotter');
    }

    /**
     * Display the specified resource.
     *
     * @param  \App\blotters  $blotters
     * @return \Illuminate\Http\Response
     */
   
    /**
     * Show the form for editing the specified resource.
     *
     * @param  \App\blotters  $blotters
     * @return \Illuminate\Http\Response
     */
    public function edit(Request $request)
    {
        $getID = request('blotter_id');
        $status_name = request('status_name');
        $remarks = request('remarks');
        
        
        $resolveBlot=DB::table('t_blotter')
                        ->where('blotter_id',$getID)
                        ->update([ 'resolution'=>request('remarks'), 
                            'status' => $status_name == 1 ? 'Resolved' : 'For Referral', 
                            'closed_date'=>Carbon::today()->toDateString() ]);
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \App\blotters  $blotters
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request)
    {
        $getBlotID = $request->input('EditBlotterID');

        $updateBlotter=DB::table('t_blotter')
                        ->where('blotter_id',$getBlotID)
                        ->update([ 'incident_date'=>$request->input('EditIncidentDate'), 
                            'incident_area' =>$request->input('EditIncidentArea'),
                            'complaint_name' =>$request->input('EditComplainantName'),
                            'accused_resident' =>$request->input('EditAccusedResident'),
                            'blotter_subject_id' =>$request->input('EditBlotterSubject'),
                            'complaint_statement' =>$request->input('EditComplainStatement')
                             ]);
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \App\blotters  $blotters
     * @return \Illuminate\Http\Response
     */
  

    public function patawag (Request $request)
    {
       $getBlotterID =  $request->input('EditBlotterIDH');

        $disppatawag = DB::table('t_patawag')
                            ->join('t_blotter', 't_patawag.blotter_id', '=', 't_blotter.blotter_id')
                            ->select('t_patawag.patawag_id', 't_patawag.patawag_sched_datetime', 't_patawag.patawag_sched_place', 't_patawag.status')
                            ->where('t_patawag.blotter_id', $getBlotterID)
                            ->orderBy('t_patawag.patawag_sched_datetime', 'desc')
                            ->get()->toArray();

        
        
        return response()->json(['result' => $disppatawag]);
    }

    public function remove()
    {
       $blotter_id =  request('blotter_id');

       db::table('t_blotter')
            ->where('blotter_id', $blotter_id)
            ->update(['ACTIVE_FLAG' => 0]);
                  
    }
}
