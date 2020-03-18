<?php

namespace App\Http\Controllers\PCC;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\DB;


class IssuanceController extends Controller
{
    public function index(){
    	$approved_application_form = DB::table('v_approved_application_form')
            ->orderBy('FORM_DATE', 'desc')
            ->get();
    	$business_nature = DB::table('v_business_nature')->get();
        $application_form_resident = DB::table('v_application_form_resident')->where('STATUS', 'Approved')->get();

       
        return view('permit_certification_clearance.issuance', compact('approved_application_form', 'business_nature', 'application_form_resident'));
    }


    public function SpecificBusiness(Request $request){
        $FORM_ID = $request->FORM_ID;
        $REQUESTED_PAPER_TYPE = $request->REQUESTED_PAPER_TYPE;

        if ($REQUESTED_PAPER_TYPE == "Barangay Business Permit"){
            $business_permit = DB::table('v_business_permit')
            ->where('FORM_ID', $FORM_ID)
            ->get();
            return response()->json(['business_permit' => $business_permit, 'requested_paper_type' => 'Barangay Business Permit']);    
        }

        else if($REQUESTED_PAPER_TYPE == "Barangay Clearance Building")       {
            $barangay_clearance = DB::table('v_barangay_clearance')
            ->where('FORM_ID', $FORM_ID)
                ->get();

            return response()->json(['barangay_clearance' => $barangay_clearance, 'requested_paper_type' => 'Barangay Clearance Building']);    

        }

        else if($REQUESTED_PAPER_TYPE == "Barangay Clearance Business")       {
            $barangay_clearance = DB::table('v_barangay_clearance')
                ->where('FORM_ID', $FORM_ID)
                ->get();
            return response()->json(['barangay_clearance' => $barangay_clearance, 'requested_paper_type' => 'Barangay Clearance Business']);    

        }

        else if($REQUESTED_PAPER_TYPE == "Barangay Clearance Zonal")       {
            $barangay_clearance = DB::table('v_barangay_clearance')
                ->where('FORM_ID', $FORM_ID)
                ->get();
            return response()->json(['barangay_clearance' => $barangay_clearance, 'requested_paper_type' => 'Barangay Clearance Zonal']);    

        }

        else if($REQUESTED_PAPER_TYPE == "Barangay Clearance Tricycle")       {
            $barangay_clearance = DB::table('v_barangay_clearance')
                ->where('FORM_ID', $FORM_ID)
                ->get();
            return response()->json(['barangay_clearance' => $barangay_clearance, 'requested_paper_type' => 'Barangay Clearance Tricycle']);    

        }

        else if($REQUESTED_PAPER_TYPE == "Barangay Clearance General Purposes")       {
            $barangay_clearance = DB::table('v_barangay_clearance')
                ->where('FORM_ID', $FORM_ID)
                ->get();
            return response()->json(['barangay_clearance' => $barangay_clearance, 'requested_paper_type' => 'Barangay Clearance General Purposes']);    

        }
    }

    public function SpecificResident(Request $request){
        $FORM_ID = $request->FORM_ID;
        $REQUESTED_PAPER_TYPE = $request->REQUESTED_PAPER_TYPE;

        if ($REQUESTED_PAPER_TYPE == "Barangay Certificate Residency"){
            $barangay_certificate = DB::table('v_barangay_certificate')
                ->where('FORM_ID', $FORM_ID)
                ->get();
            return response()->json(['requested_paper_type' => 'Barangay Certificate Residency', 'barangay_certificate' => $barangay_certificate]);    
        }

        else if ($REQUESTED_PAPER_TYPE == "Barangay Certificate Calamity Loan SSS-GSIS"){
            $barangay_certificate = DB::table('v_barangay_certificate')
                ->where('FORM_ID', $FORM_ID)
                ->get();
            return response()->json(['requested_paper_type' => 'Barangay Certificate Calamity Loan SSS-GSIS', 'barangay_certificate' => $barangay_certificate]);    
        }

        else if ($REQUESTED_PAPER_TYPE == "Barangay Certificate Calamity Loan OFW"){
            $barangay_certificate = DB::table('v_barangay_certificate')
                ->where('FORM_ID', $FORM_ID)
                ->get();
            return response()->json(['requested_paper_type' => 'Barangay Certificate Calamity Loan OFW', 'barangay_certificate' => $barangay_certificate]);    
        }

        else if ($REQUESTED_PAPER_TYPE == "Barangay Certificate SPES"){
            $barangay_certificate = DB::table('v_barangay_certificate')
                ->where('FORM_ID', $FORM_ID)
                ->get();
            return response()->json(['requested_paper_type' => 'Barangay Certificate SPES', 'barangay_certificate' => $barangay_certificate]);    
        }

        else if ($REQUESTED_PAPER_TYPE == "Barangay Certificate Solo Parent"){
            $barangay_certificate = DB::table('v_barangay_certificate')
                ->where('FORM_ID', $FORM_ID)
                ->get();
            return response()->json(['requested_paper_type' => 'Barangay Certificate Solo Parent', 'barangay_certificate' => $barangay_certificate]);    
        }

        else if ($REQUESTED_PAPER_TYPE == "Barangay Certificate Indigency"){
            $barangay_certificate = DB::table('v_barangay_certificate')
                ->where('FORM_ID', $FORM_ID)
                ->get();
            return response()->json(['requested_paper_type' => 'Barangay Certificate Indigency', 'barangay_certificate' => $barangay_certificate]);    
        }

    }


}
