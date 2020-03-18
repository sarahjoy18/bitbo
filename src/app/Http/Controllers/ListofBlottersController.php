<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use DB;

class ListofBlottersController extends Controller
{
    public function index(Request $request)
    {
       	
       	$DisplayTable = DB::table('t_blotter AS B')
                            ->join('r_blotter_subjects AS BS', 'B.blotter_subject_id', '=', 'BS.blotter_subject_id')
                            ->leftjoin('t_resident_basic_info AS R', 'B.accused_resident', '=', 'R.resident_id')
                            ->select('B.blotter_id'
                                , 'B.blotter_code'
                                , 'B.blotter_subject_id'
                                , 'B.incident_date'
                                , 'B.incident_area'
                                , 'B.complaint_name'
                                , 'B.complaint_date'
                                , 'B.complaint_statement'
                                , 'B.resolution'
                                , 'B.status'
                                , 'BS.blotter_subject_id'
                                , 'BS.blotter_name'
                                , 'R.resident_id'
                                , 'R.lastname'
                                , 'R.middlename'
                                , 'R.firstname')
                           // ->where(['B.status' => 'Pending'])
                            ->orderBy('B.complaint_date', 'desc')
                            ->get();


         //dd($DisplayTable);
        return view('queriesreports.listofblotters', compact('DisplayTable'));

        
    }
    public function gettable()
    {
    	return $blotters = COLLECT(\DB::SELECT("SELECT B.blotter_id, B.blotter_code, B.blotter_subject_id, B.incident_date, B.incident_area, B.complaint_name, B.complaint_date, B.complaint_statement, B.resolution, B.status, BS.blotter_subject_id, BS.blotter_name, R.resident_id, R.lastname, R.middlename, R.firstname
                            FROM `t_blotter` AS B
                            INNER JOIN r_blotter_subjects AS BS
                            ON B.blotter_subject_id = BS.blotter_subject_id
                            LEFT JOIN t_resident_basic_info AS R
                            ON B.accused_resident = R.resident_id"));
        //return response()->json($blotters);
    }
    public function getfilter($data,$fromdate,$todate)
    {   
        $fromdate != '' && $todate != '' ?        
        $DisplayTable = COLLECT(\DB::SELECT("SELECT B.blotter_id, B.blotter_code, B.blotter_subject_id, B.incident_date, B.incident_area, B.complaint_name, B.complaint_date, B.complaint_statement, B.resolution, B.status, BS.blotter_subject_id, BS.blotter_name, R.resident_id, R.lastname, R.middlename, R.firstname
                                                FROM `t_blotter` AS B
                                                INNER JOIN r_blotter_subjects AS BS
                                                ON B.blotter_subject_id = BS.blotter_subject_id
                                                LEFT JOIN t_resident_basic_info AS R
                                                ON B.accused_resident = R.resident_id
                                                where B.status ='$data'
                                                AND B.CREATED_AT BETWEEN '$fromdate' AND '$todate'
                                            "))
        :
        $DisplayTable = COLLECT(\DB::SELECT("SELECT B.blotter_id, B.blotter_code, B.blotter_subject_id, B.incident_date, B.incident_area, B.complaint_name, B.complaint_date, B.complaint_statement, B.resolution, B.status, BS.blotter_subject_id, BS.blotter_name, R.resident_id, R.lastname, R.middlename, R.firstname
                                                FROM `t_blotter` AS B
                                                INNER JOIN r_blotter_subjects AS BS
                                                ON B.blotter_subject_id = BS.blotter_subject_id
                                                LEFT JOIN t_resident_basic_info AS R
                                                ON B.accused_resident = R.resident_id
                                                where B.status ='$data'                                          
                                            "));
        
        
        return $DisplayTable;
                                        
    } 

    public function filterdisplay()
    {
       	
            
            $data = request('editcstatus');
            $fromdate = request('fromdate');
            $todate = request('todate');
            
            $data == 'All' ? $response = response()->json($this->gettable())
            : $response = response()->json($this->getfilter($data, $fromdate, $todate));
            return $response;
        
    }
     // \DB::enableQueryLog(); dd(\DB::getQueryLog());
    public function getdata($data)
    {
    	if ($data != 'All')
    	{
    		$DisplayTable = $this->getfilter($data);
    	}
    	else
    	{
    		$DisplayTable = $this->gettable();
    	}
    	

		return $DisplayTable;

    }
    public function filterprint()
    {
        $data = request('editcstatus');
       
        $DisplayTable = $this->getdata($data);

        // $barangay_info = \DB::table('r_barangay_zone as z')
        //                         ->join('r_barangay_information as i','z.barangay_id','i.barangay_id')
        //                         ->select('i.barangay_name','z.barangay_zone_name')
        //                         ->get();


        $view = View('listofblottersprintable', compact('DisplayTable'));
        $pdf = \App::make('dompdf.wrapper');
        $pdf->loadHTML($view->render());
        return $pdf->stream();

        // return $DisplayTable;
    }
}
