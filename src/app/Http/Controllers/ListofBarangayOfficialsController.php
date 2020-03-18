<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;


class ListofBarangayOfficialsController extends Controller
{
    public function index(Request $request)
    {
       	
       	$position_name = \DB::TABLE('r_position')
       				->WHERE('POSITION_NAME', '<>','Admin')
                    ->PLUCK('POSITION_NAME','POSITION_ID');

        $DisplayTable = $this->gettable();


         // dd($DisplayTable);
        return view('queriesreports.listofbarangayofficials', compact('DisplayTable','position_name'));
    }

    public function gettable()
    {
         $DisplayTable = COLLECT(\DB::SELECT("SELECT CONCAT(T.FIRSTNAME,' ',T.MIDDLENAME,' ',T.LASTNAME ) AS Fullname,
                                            BARANGAY_NAME ,
                                            POSITION_NAME,
                                            DATE_FORMAT(START_TERM,'%M %d %Y') AS Start_Term,
                                            DATE_FORMAT(END_TERM,'%M %d %Y') AS End_Term, BO.ACTIVE_FLAG   
                                            FROM `t_users` U        
                                            inner join r_position P ON P.POSITION_ID = U.POSITION_ID
                                            inner join t_barangay_official BO ON BO.BARANGAY_OFFICIAL_ID = U.BARANGAY_OFFICIAL_ID
                                            inner join r_barangay_information BS ON  BS.BARANGAY_ID = BO.BARANGAY_ID
                                            inner join t_resident_basic_info AS T ON BO.RESIDENT_ID = T.RESIDENT_ID
                                            where P.POSITION_NAME <> 'Admin'"));
         return $DisplayTable;
    }


    public static function filterdisplay()
    {
        try
        {
            $data = request('editcstatus');
           

            if ($data == 'All')
            {
                $DisplayTable = COLLECT(\DB::SELECT("SELECT CONCAT(T.FIRSTNAME,' ',T.MIDDLENAME,' ',T.LASTNAME ) AS Fullname,
                                            BARANGAY_NAME ,
                                            POSITION_NAME,
                                            DATE_FORMAT(START_TERM,'%M %d %Y') AS Start_Term,
                                            DATE_FORMAT(END_TERM,'%M %d %Y') AS End_Term, BO.ACTIVE_FLAG   
                                            FROM `t_users` U        
                                            inner join r_position P ON P.POSITION_ID = U.POSITION_ID
                                            inner join t_barangay_official BO ON BO.BARANGAY_OFFICIAL_ID = U.BARANGAY_OFFICIAL_ID
                                            inner join r_barangay_information BS ON  BS.BARANGAY_ID = BO.BARANGAY_ID
                                            inner join t_resident_basic_info AS T ON BO.RESIDENT_ID = T.RESIDENT_ID
                                            where P.POSITION_NAME <> 'Admin'"));
            }
            else
            {

                $DisplayTable = COLLECT(\DB::SELECT("SELECT CONCAT(T.FIRSTNAME,' ',T.MIDDLENAME,' ',T.LASTNAME ) AS Fullname,
                                            BARANGAY_NAME ,
                                            POSITION_NAME,
                                            DATE_FORMAT(START_TERM,'%M %d %Y') AS Start_Term,
                                            DATE_FORMAT(END_TERM,'%M %d %Y') AS End_Term, BO.ACTIVE_FLAG   
                                            FROM `t_users` U        
                                            inner join r_position P ON P.POSITION_ID = U.POSITION_ID
                                            inner join t_barangay_official BO ON BO.BARANGAY_OFFICIAL_ID = U.BARANGAY_OFFICIAL_ID
                                            inner join r_barangay_information BS ON  BS.BARANGAY_ID = BO.BARANGAY_ID
                                            inner join t_resident_basic_info AS T ON BO.RESIDENT_ID = T.RESIDENT_ID
                                           
                                            WHERE P.POSITION_NAME = '$data'"));

               
            }
             return response()->json($DisplayTable);
                
            
        }
        catch(\Exception $e)
        {
            return $e;
        }
    	
    }
     // \DB::enableQueryLog(); dd(\DB::getQueryLog());
   
   
    public function filterprint()
    {
        $data = request('editcstatus');
        
        if ($data == 'All')
        {
           $DisplayTable = $this->gettable();
        }
        else
        {

           
                $DisplayTable = COLLECT(\DB::SELECT("SELECT CONCAT(T.FIRSTNAME,' ',T.MIDDLENAME,' ',T.LASTNAME ) AS Fullname,
                                            BARANGAY_NAME ,
                                            POSITION_NAME,
                                            DATE_FORMAT(START_TERM,'%M %d %Y') AS Start_Term,
                                            DATE_FORMAT(END_TERM,'%M %d %Y') AS End_Term, BO.ACTIVE_FLAG   
                                            FROM `t_users` U        
                                            inner join r_position P ON P.POSITION_ID = U.POSITION_ID
                                            inner join t_barangay_official BO ON BO.BARANGAY_OFFICIAL_ID = U.BARANGAY_OFFICIAL_ID
                                            inner join r_barangay_information BS ON  BS.BARANGAY_ID = BO.BARANGAY_ID
                                            inner join t_resident_basic_info AS T ON BO.RESIDENT_ID = T.RESIDENT_ID
                                          
                                            WHERE P.POSITION_NAME = '$data'"));
        }
    	

        // $barangay_info = \DB::table('R_BARANGAY_ZONE AS Z')
        //                         ->join('R_BARANGAY_INFORMATION AS I','Z.BARANGAY_ID','I.BARANGAY_ID')
        //                         ->select('I.BARANGAY_NAME','Z.BARANGAY_ZONE_NAME')
        //                         ->get();

        $view = View('lisofbrgyofficialsprintable', compact('DisplayTable'));
        $pdf = \App::make('dompdf.wrapper');
        $pdf->loadHTML($view->render());
        return $pdf->stream();
    }
}
