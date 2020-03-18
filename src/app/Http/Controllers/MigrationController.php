<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

use Yajra\Datatables\Facades\Datatables;
use App\Imports\UsersImport;
use App\Imports\ResidentsImport;
use App\Imports\OrdinancesImport;
use App\Imports\BusinessesImport;
use App\Imports\BlottersImport;
use DB;
use File;
use Excel;

class MigrationController extends Controller
{

    public function index()
    {
        return view('migration.migration');
    }
    public function export() 
    {
        //Excel::store(new ResidentsExport, 'users.xlsx');
        return Excel::download(new ResidentsExport, 'users.xlsx');
    }

    public function import_residents(Request $request) 
    {
        $extension = File::extension($request->file->getClientOriginalName());
        if ($extension == "xlsx" || $extension == "xls" || $extension == "csv") {
            Excel::import(new UsersImport, request()->file('file'));
            echo "true";
        }
       
    }

    public function import_ordinances(Request $request) 
    {
        $excel_file = request()->file('file')->getRealPath();
        $extension = File::extension($request->file->getClientOriginalName());
        if ($extension == "xlsx" || $extension == "xls" || $extension == "csv") {
        $data = Excel::import(new OrdinancesImport, $excel_file);
        echo "true";
        }

    }

    public function import_businesses(Request $request) 
    {
        $excel_file = request()->file('file')->getRealPath();
        $extension = File::extension($request->file->getClientOriginalName());        
        if ($extension == "xlsx" || $extension == "xls" || $extension == "csv") {
        $data = Excel::import(new BusinessesImport, $excel_file);
        echo "true";
        }
        
        
    }

    public function import_blotter(Request $request) 
    {
        $excel_file = request()->file('file')->getRealPath();
        $extension = File::extension($request->file->getClientOriginalName());        
        if ($extension == "xlsx" || $extension == "xls" || $extension == "csv") {
        $data = Excel::import(new BlottersImport, $excel_file);
        echo "true";
        }
        
        
    }
}
