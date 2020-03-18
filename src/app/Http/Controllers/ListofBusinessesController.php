<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class ListofBusinessesController extends Controller
{
    public function index(Request $request)
    {
       	
       	$business_nature = \DB::TABLE('r_business_nature AS RBN')
                            ->PLUCK('RBN.BUSINESS_NATURE_NAME', 'BUSINESS_NATURE_ID');

        $DisplayTable = $this->gettable();

         // dd($DisplayTable);
        return view('queriesreports.listofbusinesses', compact('DisplayTable','business_nature'));
        
    	
    }
    public function gettable()
    {
        return  $DisplayTable = COLLECT(\DB::SELECT("SELECT TB.BUSINESS_NAME, RBN.BUSINESS_NATURE_NAME,RBZ.BARANGAY_ZONE_NAME, 
                                                    IFNULL(TB.BUSINESS_OR_NUMBER,'NO OR NUMBER') AS OR_NUMBER, TB.BUSINESS_ADDRESS, 
                                                    CONCAT(BUSINESS_OWNER_FIRSTNAME,' ',BUSINESS_OWNER_MIDDLENAME,' ',BUSINESS_OWNER_LASTNAME) AS FULLNAME
                                                    FROM t_business_information AS TB
                                                    INNER JOIN r_business_nature RBN
                                                    ON TB.BUSINESS_NATURE_ID = RBN.BUSINESS_NATURE_ID
                                                    INNER JOIN r_barangay_zone RBZ
                                                    ON TB.BARANGAY_ZONE_ID = RBZ.BARANGAY_ZONE_ID")); 
    }

    public function getfilterdisplay($data, $fromdate, $todate)
    {
        $fromdate != '' && $todate != '' ?        
        $DisplayTable = COLLECT(\DB::SELECT("SELECT TB.BUSINESS_NAME, RBN.BUSINESS_NATURE_NAME,RBZ.BARANGAY_ZONE_NAME, 
                                                    IFNULL(TB.BUSINESS_OR_NUMBER,'NO OR NUMBER') AS OR_NUMBER, TB.BUSINESS_ADDRESS, 
                                                    CONCAT(BUSINESS_OWNER_FIRSTNAME,' ',BUSINESS_OWNER_MIDDLENAME,' ',BUSINESS_OWNER_LASTNAME) AS FULLNAME
                                                    FROM t_business_information AS TB
                                                    INNER JOIN r_business_nature RBN
                                                    ON TB.BUSINESS_NATURE_ID = RBN.BUSINESS_NATURE_ID
                                                    INNER JOIN r_barangay_zone RBZ
                                                    ON TB.BARANGAY_ZONE_ID = RBZ.BARANGAY_ZONE_ID
                                                    WHERE RBN.BUSINESS_NATURE_NAME = '$data'
                                                    AND TB.CREATED_AT BETWEEN '$fromdate' AND '$todate'
                                                    "))
                                                    :
        $DisplayTable = COLLECT(\DB::SELECT("SELECT TB.BUSINESS_NAME, RBN.BUSINESS_NATURE_NAME,RBZ.BARANGAY_ZONE_NAME, 
                                                    IFNULL(TB.BUSINESS_OR_NUMBER,'NO OR NUMBER') AS OR_NUMBER, TB.BUSINESS_ADDRESS, 
                                                    CONCAT(BUSINESS_OWNER_FIRSTNAME,' ',BUSINESS_OWNER_MIDDLENAME,' ',BUSINESS_OWNER_LASTNAME) AS FULLNAME
                                                    FROM t_business_information AS TB
                                                    INNER JOIN r_business_nature RBN
                                                    ON TB.BUSINESS_NATURE_ID = RBN.BUSINESS_NATURE_ID
                                                    INNER JOIN r_barangay_zone RBZ
                                                    ON TB.BARANGAY_ZONE_ID = RBZ.BARANGAY_ZONE_ID
                                                    WHERE RBN.BUSINESS_NATURE_NAME = '$data'
                                                    "));

        return $DisplayTable;
        
    }

    public function filterdisplay()
    {
        $data = request('editcstatus');
        $fromdate = request('fromdate');
        $todate = request('todate');
        $data == 'All'? $response = response()->json($this->gettable())
        : $response = response()->json($this->getfilterdisplay($data, $fromdate, $todate));
       return $response;
    }
    
    public function getdata($data)
    {   $fromdate = request('fromdate');
        $todate = request('todate');
    	$data != 'All' ?
    		$DisplayTable = $this->getfilterdisplay($data,$fromdate, $todate)
        :   $DisplayTable = $this->gettable();
		return $DisplayTable;
    }
    public function filterprint()
    {
        $data = request('editcstatus');
        $DisplayTable = $this->getdata($data);
        $view = View('listofbusinessesprintable', compact('DisplayTable'));
        $pdf = \App::make('dompdf.wrapper');
        $pdf->loadHTML($view->render());
        return $pdf->stream();

    }
}
