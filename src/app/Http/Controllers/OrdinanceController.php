<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use db;
class OrdinanceController extends Controller
{
    //
    public function index()
    {
        $barangay_id = session('session_brgy_id');

        $ordinances = COLLECT(\DB::SELECT("SELECT O.ORDINANCE_ID,
                                            O.ORDINANCE_AUTHOR, O.ORDINANCE_TITLE, O.ORDINANCE_SANCTION, O.ORDINANCE_REMARKS,    O.ORDINANCE_DESCRIPTION, O.ACTIVE_FLAG
                                            FROM t_ordinance AS O                                            
                                            "));

        $category = \DB::TABLE('r_ordinance_category')
                    ->PLUCK('ORDINANCE_CATEGORY_NAME','ORDINANCE_CATEGORY_ID');

        $assign_official = COLLECT(\DB::SELECT("SELECT BO.BARANGAY_OFFICIAL_ID, CONCAT(RBI.LASTNAME,' ', RBI.FIRSTNAME, ' ', RBI.MIDDLENAME) AS FULLNAME
                            FROM t_barangay_official BO
                            INNER JOIN t_resident_basic_info RBI ON BO.RESIDENT_ID = RBI.RESIDENT_ID
                            WHERE BO.BARANGAY_ID = '$barangay_id'"));
                


         //dd($barangay_id);            
        return view('ordinance.ordinance', compact('ordinances','category','assign_official'));

    }

    public function store()
    {

        $ordinance_file = request()->file('file');
        $get_id = \DB::TABLE('t_ordinance')
            ->INSERTGETID(
                [
                    'ORDINANCE_TITLE'      => request('title'),
                    'ORDINANCE_DESCRIPTION'=> request('description'),
                    'ORDINANCE_AUTHOR'     => request('author'),
                    'ORDINANCE_SANCTION'   => request('santion'),

                    'ORDINANCE_REMARKS'    => request('remarks'),                    
                    
                    'ACTIVE_FLAG' => 1
                ]
            );
            foreach($ordinance_file as $value)
            {   
                \DB::TABLE('t_ordinance_images')
                ->INSERT(
                    [
                        'ORDINANCE_ID'      => $get_id,
                        'FILE_NAME'         => $value->getClientOriginalName(),
                       
                    ]
                );
                $value->move(public_path('ordinances'), $value->getClientOriginalName());  
            }   
            
            echo "good";
    }



    public function update()
    {

        $ordinance_file = request()->file('file');
        $ordinance_id = request('ordinance_id');
            \DB::TABLE('t_ordinance')
            ->where('ORDINANCE_ID',$ordinance_id)
            ->update(
                [
                    'ORDINANCE_TITLE'      => request('title'),
                    'ORDINANCE_DESCRIPTION'=> request('description'),
                    'ORDINANCE_AUTHOR'     => request('author'),
                    'ORDINANCE_SANCTION'   => request('santion'),

                    'ORDINANCE_REMARKS'    => request('remarks'),
                    
                    
                ]
            );          
            foreach($ordinance_file as $value)
            {   
                \DB::TABLE('t_ordinance_images')
                ->INSERT(
                    [
                        'ORDINANCE_ID'      => $ordinance_id,
                        'FILE_NAME'         => $value->getClientOriginalName(),
                       
                    ]
                );
                $value->move(public_path('ordinances'), $value->getClientOriginalName());  
            }   
            
            echo "good";
    }


    public function remove()
    {
       $ordinance_id =  request('ordinance_id');

       db::table('t_ordinance')
            ->where('ORDINANCE_ID', $ordinance_id)
            ->update(['ACTIVE_FLAG' => 0]);
                  
    }

    public function get_images()
    {
       $ordinance_id =  request('ordinance_id');
       $collect_images = \DB::table('t_ordinance_images')
            ->where('ORDINANCE_ID', $ordinance_id)
            ->get();
            
        echo json_encode($collect_images);                  
    }

}
