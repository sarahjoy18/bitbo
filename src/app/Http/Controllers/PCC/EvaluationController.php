<?php

namespace App\Http\Controllers\PCC;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\DB;


class EvaluationController extends Controller
{
    public function index(){
        $businessNotApproved = DB::table('v_official_business_list')->where('STATUS', 'Pending')->get();
        $application_form_resident = DB::table('v_application_form_resident')->where('STATUS', 'Pending')->get();
          $pending_application_form = DB::table('v_pending_application_form')
            ->orderBy('FORM_DATE', 'desc')
            ->get();
        $approved_application_form = DB::table('v_approved_application_form')->get();
        $declined_application_form = DB::table('v_declined_application_form')->get();
        return view('permit_certification_clearance.verification', compact('businessNotApproved', 'pending_application_form', 'application_form_resident'));

    }
    // BUSINESS
    public function CRUDBusinessApproval(Request $request){
    	$BUSINESS_ID = $request->BUSINESS_ID;
    	$STATUS = $request->STATUS;
    	$APPROVED_BY = $request->APPROVED_BY;

    	$insert = DB::table('t_business_approval')
    		->insert(array(
    			'BUSINESS_ID' => $BUSINESS_ID
    			,'STATUS' => 'Evaluated'
    			,'APPROVED_BY' => $APPROVED_BY
    			,'DATE_APPROVED' => date('Y-m-d')
    		));

    	$updateBusinessStatus = DB::table('t_business_information')
    		->where('BUSINESS_ID', $BUSINESS_ID)
    		->update(array(
    			'STATUS' => $STATUS
    		));
    }
    
    //ISSUANCE
    public function IssuanceEvaluation(Request $request){
        $OR_NO = $request->OR_NO;
        $OR_DATE = $request->OR_DATE;
        $OR_AMOUNT = $request->OR_AMOUNT;
        $FORM_ID = $request->FORM_ID;
        $PAPER_TYPE_ID = $request->PAPER_TYPE_ID;
        $EVALUATED_BY = $request->EVALUATED_BY;
        $EVALUATION_STATUS = $request->EVALUATION_STATUS;
        $REMARKS = $request->REMARKS;
        $BUSINESS_ID = $request->BUSINESS_ID;

        $ap_evaluation = DB::table('t_application_form_evaluation')
            ->insert(array(
                'FORM_ID' => $FORM_ID
                ,'EVALUATED_BY' => $EVALUATED_BY
                ,'EVALUATION_STATUS' => $EVALUATION_STATUS
                ,'DATE_EVALUATED' => date('Y-m-d')
                ,'REMARKS' => $REMARKS
            ));

        $application_form = DB::table('t_application_form')
            ->where('FORM_ID', $FORM_ID)
            ->update(array(
                'STATUS' => $EVALUATION_STATUS
            ));
        if($EVALUATION_STATUS == "Approved"){
            $clearance_certification = DB::table('t_clearance_certification')
                ->insert(array(
                    'CONTROL_NO' => 'XXXX-XXX'
                    ,'ISSUED_DATE' => date('Y-m-d')
                    ,'OR_NO' => $OR_NO
                    ,'OR_DATE' => $OR_DATE
                    ,'OR_AMOUNT' => $OR_AMOUNT
                    ,'FORM_ID' => $FORM_ID
                    ,'PAPER_TYPE_ID' => $PAPER_TYPE_ID
                ));
        }

    }
}
