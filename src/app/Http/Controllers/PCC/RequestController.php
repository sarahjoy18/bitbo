<?php

namespace App\Http\Controllers\PCC;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\DB;

class RequestController extends Controller
{
   public function index($typeofview){
    	$approved_business = DB::table('v_official_business_list')->where('STATUS','Approved')->get();
    	$business_nature = DB::table('v_business_nature')->get();
        $resident = DB::table('v_resident')->get();

   		$pending_application_form = DB::table('v_pending_application_form')->get();
        $approved_application_form = DB::table('v_approved_application_form')->get();
        $declined_application_form = DB::table('v_declined_application_form')->get();

        if($typeofview == "RequestPermit")
        	return view('permit_certification_clearance.permit', compact('approved_business', 'business_nature'));
        else if ($typeofview == "RequestCertification")
        	return view('permit_certification_clearance.certificate', compact('resident'));
        else if ($typeofview == "RequestClearance")
        	return view('permit_certification_clearance.clearance', compact('approved_business', 'business_nature'));
        	

   }

    public function CRUDRequestClearance(Request $request){
        // Business Permit
            $TAX_YEAR = $request->TAX_YEAR;
            $QUARTER = $request->QUARTER;
            $BARANGAY_PERMIT = $request->BARANGAY_PERMIT;
            $GARBAGE_FEE = $request->GARBAGE_FEE;
            $SIGNBOARD = $request->SIGNBOARD;
            $CTC = $request->CTC;
            $BUSINESS_TAX = $request->BUSINESS_TAX;
        // Clearance Building - A
            $A_APPLICANT_NAME = $request->A_APPLICANT_NAME;
            $A_CONSTRUCTION_ADDRESS = $request->A_CONSTRUCTION_ADDRESS;
            $A_SCOPE_OF_WORK_NAME = $request->A_SCOPE_OF_WORK_NAME;
            $A_SCOPE_OF_WORK_SPECIFY = $request->A_SCOPE_OF_WORK_SPECIFY;
            $A_PROJECT_LOCATION = $request->A_PROJECT_LOCATION;
        // Clearance Business - B
            $B_REGISTERED_NAME = $request->B_REGISTERED_NAME;
            $B_CONSTRUCTION_ADDRESS = $request->B_CONSTRUCTION_ADDRESS;
        //Clearance Zonal - C
            $C_OCT_TCT_NUMBER = $request->C_OCT_TCT_NUMBER;
            $C_TAX_DECLARATION = $request->C_TAX_DECLARATION;
            $C_BUSINESS_AREA = $request->C_BUSINESS_AREA;
            $C_AREA_CLASSIFICATION = $request->C_AREA_CLASSIFICATION;
            $C_PROJECT_LOCATION = $request->C_PROJECT_LOCATION;
            $C_PURPOSE = $request->C_PURPOSE;
            $C_APPLICANT_NAME = $request->C_APPLICANT_NAME;
            $C_CONSTRUCTION_ADDRESS = $request->C_CONSTRUCTION_ADDRESS;
        //Clearance Tricycle - D
            $D_APPLICANT_NAME = $request->D_APPLICANT_NAME;
            $D_REGISTERED_NAME = $request->D_REGISTERED_NAME;
            $D_CONSTRUCTION_ADDRESS = $request->D_CONSTRUCTION_ADDRESS;
            $D_DRIVER_LICENSE_NO = $request->D_DRIVER_LICENSE_NO;
            $D_MUDGUARD_NO = $request->D_MUDGUARD_NO;
            $D_CR_NO = $request->D_CR_NO;
            $D_OR_NO = $request->D_OR_NO;
        //Clearance General Purpose - E
            $E_PURPOSE = $request->E_PURPOSE;
            $E_REGISTERED_NAME = $request->E_REGISTERED_NAME;
            $E_CONSTRUCTION_ADDRESS = $request->E_CONSTRUCTION_ADDRESS;
        //General
            $PAPER_TYPE_CLEARANCE = $request->PAPER_TYPE_CLEARANCE;
            $PAPER_TYPE_FORM = $request->PAPER_TYPE_FORM;
            $BUSINESS_ID = $request->BUSINESS_ID;
            $APPLICANT_NAME = $request->APPLICANT_NAME;

        $clearance_type_id = DB::table('r_paper_type')
            ->where('PAPER_TYPE_NAME', $PAPER_TYPE_CLEARANCE)
            ->select('PAPER_TYPE_ID')
            ->first();
        $form_type_id = DB::table('r_paper_type')
            ->where('PAPER_TYPE_NAME', $PAPER_TYPE_FORM)
            ->select('PAPER_TYPE_ID')
            ->first();

        if($PAPER_TYPE_CLEARANCE == "Barangay Business Permit"){
            $application_form = DB::Table('t_application_form')
                ->insert(array(
                    'FORM_NUMBER' => 'SSSS-SSSS'
                    ,'PAPER_TYPE_ID' => $form_type_id->PAPER_TYPE_ID
                    ,'STATUS' => 'Pending'
                    ,'BUSINESS_ID' => $BUSINESS_ID
                    ,'RECEIVED_BY' => 'Shiela Mae A. Velga'
                    ,'REQUESTED_PAPER_TYPE_ID' => $clearance_type_id->PAPER_TYPE_ID
                    ,'APPLICANT_NAME' => $APPLICANT_NAME
                ));

            $latest_form_id = DB::table('t_application_form')->select('FORM_ID')->latest('FORM_ID')->first();

            $business_permit = DB::table('t_bf_business_permit')
                ->insert(array(
                    'TAX_YEAR' => $TAX_YEAR
                    ,'QUARTER' => $QUARTER
                    ,'BARANGAY_PERMIT' => $BARANGAY_PERMIT
                    ,'GARBAGE_FEE' => $GARBAGE_FEE
                    ,'SIGNBOARD' => $SIGNBOARD
                    ,'CTC' => $CTC
                    ,'BUSINESS_TAX' => $BUSINESS_TAX
                    ,'FORM_ID' => $latest_form_id->FORM_ID
                ));

            return response()->json(['message' => $latest_form_id] );
        }
        else if ($PAPER_TYPE_CLEARANCE == "Barangay Clearance Building"){
         $application_form = DB::Table('t_application_form')
            ->insert(array(
                'FORM_NUMBER' => 'XXXX-XXX'
                ,'PAPER_TYPE_ID' => $form_type_id->PAPER_TYPE_ID
                ,'STATUS' => 'Pending'
                ,'BUSINESS_ID' => $BUSINESS_ID
                ,'RECEIVED_BY' => 'Shiela Mae A. Velga'
                ,'REQUESTED_PAPER_TYPE_ID' => $clearance_type_id->PAPER_TYPE_ID
                ,'APPLICANT_NAME' => $APPLICANT_NAME

            ));

            $latest_form_id = DB::table('t_application_form')->select('FORM_ID')->latest('FORM_ID')->first();

            $scope_of_work = DB::table('t_bf_scope_of_work')
                ->insert(array(
                    'SCOPE_OF_WORK_NAME' => $A_SCOPE_OF_WORK_NAME
                    ,'SCOPE_OF_WORK_SPECIFY' =>$A_SCOPE_OF_WORK_SPECIFY
                ));
            $latest_scope_of_work_id = DB::table('t_bf_scope_of_work')->select('SCOPE_OF_WORK_ID')->latest('SCOPE_OF_WORK_ID')->first();

            $barangay_clearance = DB::table('t_bf_barangay_clearance')
                ->insert(array(
                    'APPLICANT_NAME' => $A_APPLICANT_NAME
                    ,'CONSTRUCTION_ADDRESS' => $A_CONSTRUCTION_ADDRESS
                    ,'PROJECT_LOCATION' => $A_PROJECT_LOCATION
                    ,'SCOPE_OF_WORK_ID' => $latest_scope_of_work_id->SCOPE_OF_WORK_ID
                    ,'FORM_ID' => $latest_form_id->FORM_ID
                ));

            return response()->json(['message' => $latest_form_id] );
        }
        else if($PAPER_TYPE_CLEARANCE == "Barangay Clearance Business"){
            $application_form = DB::Table('t_application_form')
                ->insert(array(
                    'FORM_NUMBER' => 'XXXX-XXX'
                    ,'PAPER_TYPE_ID' => $form_type_id->PAPER_TYPE_ID
                    ,'STATUS' => 'Pending'
                    ,'BUSINESS_ID' => $BUSINESS_ID
                    ,'RECEIVED_BY' => 'Shiela Mae A. Velga'
                    ,'REQUESTED_PAPER_TYPE_ID' => $clearance_type_id->PAPER_TYPE_ID
                    ,'APPLICANT_NAME' => $APPLICANT_NAME

                ));

            $latest_form_id = DB::table('t_application_form')->select('FORM_ID')->latest('FORM_ID')->first();

           $barangay_clearance = DB::table('t_bf_barangay_clearance')
                ->insert(array(
                    'REGISTERED_NAME' => $B_REGISTERED_NAME
                    ,'CONSTRUCTION_ADDRESS' => $B_CONSTRUCTION_ADDRESS
                    ,'FORM_ID' => $latest_form_id->FORM_ID
                ));

            return response()->json(['message' => $latest_form_id] );
        }
        else if($PAPER_TYPE_CLEARANCE == "Barangay Clearance Zonal"){
            $application_form = DB::Table('t_application_form')
                ->insert(array(
                    'FORM_NUMBER' => 'XXXX-XXX'
                    ,'PAPER_TYPE_ID' => $form_type_id->PAPER_TYPE_ID
                    ,'STATUS' => 'Pending'
                    ,'BUSINESS_ID' => $BUSINESS_ID
                    ,'RECEIVED_BY' => 'Shiela Mae A. Velga'
                    ,'REQUESTED_PAPER_TYPE_ID' => $clearance_type_id->PAPER_TYPE_ID
                    ,'APPLICANT_NAME' => $APPLICANT_NAME

                ));

            $latest_form_id = DB::table('t_application_form')->select('FORM_ID')->latest('FORM_ID')->first();

           $barangay_clearance = DB::table('t_bf_barangay_clearance')
                ->insert(array(
                    'OCT_TCT_NUMBER' => $C_OCT_TCT_NUMBER
                    ,'TAX_DECLARATION' => $C_TAX_DECLARATION
                    ,'BUSINESS_AREA' => $C_BUSINESS_AREA
                    ,'AREA_CLASSIFICATION' => $C_AREA_CLASSIFICATION
                    ,'PURPOSE' => $C_PURPOSE
                    ,'APPLICANT_NAME' => $C_APPLICANT_NAME
                    ,'CONSTRUCTION_ADDRESS' => $C_CONSTRUCTION_ADDRESS
                    ,'PROJECT_LOCATION' => $C_PROJECT_LOCATION
                    ,'FORM_ID' => $latest_form_id->FORM_ID
                ));

            return response()->json(['message' => $latest_form_id] );
        }
        else if($PAPER_TYPE_CLEARANCE == "Barangay Clearance Tricycle"){
            $application_form = DB::Table('t_application_form')
                ->insert(array(
                    'FORM_NUMBER' => 'XXXX-XXX'
                    ,'PAPER_TYPE_ID' => $form_type_id->PAPER_TYPE_ID
                    ,'STATUS' => 'Pending'
                    ,'BUSINESS_ID' => $BUSINESS_ID
                    ,'RECEIVED_BY' => 'Shiela Mae A. Velga'
                    ,'REQUESTED_PAPER_TYPE_ID' => $clearance_type_id->PAPER_TYPE_ID
                ));

            $latest_form_id = DB::table('t_application_form')->select('FORM_ID')->latest('FORM_ID')->first();

            $barangay_clearance = DB::table('t_bf_barangay_clearance')
                ->insert(array(
                    'APPLICANT_NAME' => $D_APPLICANT_NAME
                    ,'REGISTERED_NAME' => $D_REGISTERED_NAME
                    ,'CONSTRUCTION_ADDRESS' => $D_CONSTRUCTION_ADDRESS
                    ,'D_DRIVER_LICENSE_NO' => $D_DRIVER_LICENSE_NO
                    ,'D_MUDGUARD_NO' => $D_MUDGUARD_NO
                    ,'D_CR_NO' => $D_CR_NO
                    ,'D_OR_NO' => $D_OR_NO
                    ,'FORM_ID' => $latest_form_id->FORM_ID
                ));

            return response()->json(['message' => $latest_form_id] );
        }
        else if($PAPER_TYPE_CLEARANCE == "Barangay Clearance General Purposes"){
            $application_form = DB::Table('t_application_form')
                ->insert(array(
                    'FORM_NUMBER' => 'XXXX-XXX'
                    ,'PAPER_TYPE_ID' => $form_type_id->PAPER_TYPE_ID
                    ,'STATUS' => 'Pending'
                    ,'BUSINESS_ID' => $BUSINESS_ID
                    ,'RECEIVED_BY' => 'Shiela Mae A. Velga'
                    ,'REQUESTED_PAPER_TYPE_ID' => $clearance_type_id->PAPER_TYPE_ID
                    ,'APPLICANT_NAME' => $APPLICANT_NAME
                    
                ));

            $latest_form_id = DB::table('t_application_form')->select('FORM_ID')->latest('FORM_ID')->first();

           $barangay_clearance = DB::table('t_bf_barangay_clearance')
                ->insert(array(
                    'PURPOSE' => $E_PURPOSE
                    ,'REGISTERED_NAME' => $E_REGISTERED_NAME
                    ,'CONSTRUCTION_ADDRESS' => $E_CONSTRUCTION_ADDRESS
                    ,'FORM_ID' => $latest_form_id->FORM_ID
                ));

            return response()->json(['message' => $latest_form_id] );
        }

    }


    public function CRUDRequestCertificate(Request $request){
        //GENERAL
        $CERTIFICATE_TYPE = $request->CERTIFICATE_TYPE;
        $FORM_TYPE = $request->FORM_TYPE;
        $RESIDENT_ID = $request->RESIDENT_ID;
        $APPLICANT_NAME = $request->APPLICANT_NAME;

        // RESIDENCY - A
        $A_PURPOSE = $request->A_PURPOSE;

        // CALAMITY LOAN SSS-GSIS - B
        $B_SSS_NO = $request->B_SSS_NO;
        $B_CALAMITY_NAME = $request->B_CALAMITY_NAME;
        $B_CALAMITY_DATE = $request->B_CALAMITY_DATE;

        // CALAMITY LOAN OFW - C
        $C_SSS_NO = $request->C_SSS_NO;
        $C_CALAMITY_NAME = $request->C_CALAMITY_NAME;
        $C_CALAMITY_DATE = $request->C_CALAMITY_DATE;
        $C_COUNTRY = $request->C_COUNTRY;

        // SOLO PARENT - E
        $E_CATEGORY_SINGLE_PARENT = $request->E_CATEGORY_SINGLE_PARENT;
        $E_REQUESTOR_NAME = $request->E_REQUESTOR_NAME;
        $E_CHILD_NAME = $request->E_CHILD_NAME;
        $E_CHILD_AGE = $request->E_CHILD_AGE;
        $E_IS_PWD = $request->E_IS_PWD;
        $E_CHILD_NAME_2 = $request->E_CHILD_NAME_2;
        $E_CHILD_AGE_2 = $request->E_CHILD_AGE_2;
        $E_IS_PWD_2 = $request->E_IS_PWD_2;

        // INDIGENCY - F
        $F_PURPOSE = $request->F_PURPOSE;

        $certificate_type_id = DB::table('r_paper_type')
            ->where('PAPER_TYPE_NAME', $CERTIFICATE_TYPE)
            ->select('PAPER_TYPE_ID')
            ->first();
        $form_type_id = DB::table('r_paper_type')
            ->where('PAPER_TYPE_NAME', $FORM_TYPE)
            ->select('PAPER_TYPE_ID')
            ->first();

        if($CERTIFICATE_TYPE == "Barangay Certificate Residency"){
            $application_form = DB::Table('t_application_form')
                ->insert(array(
                    'FORM_NUMBER' => 'XXXX-XXX'
                    ,'PAPER_TYPE_ID' => $form_type_id->PAPER_TYPE_ID
                    ,'STATUS' => 'Pending'
                    ,'RESIDENT_ID' => $RESIDENT_ID
                    ,'RECEIVED_BY' => 'Shiela Mae A. Velga'
                    ,'REQUESTED_PAPER_TYPE_ID' => $certificate_type_id->PAPER_TYPE_ID
                    ,'APPLICANT_NAME' => $APPLICANT_NAME
                ));

            $latest_form_id = DB::table('t_application_form')->select('FORM_ID')->latest('FORM_ID')->first();

            $barangay_certificate = DB::table('t_bf_barangay_certification')
                ->insert(array(
                    'PURPOSE' => $A_PURPOSE
                    ,'FORM_ID' => $latest_form_id->FORM_ID
                ));
            return response()->json(['message' => $certificate_type_id->PAPER_TYPE_ID.' '.$form_type_id->PAPER_TYPE_ID] );
        }

        else if($CERTIFICATE_TYPE == "Barangay Certificate Calamity Loan SSS-GSIS"){
            $application_form = DB::Table('t_application_form')
                ->insert(array(
                    'FORM_NUMBER' => 'XXXX-XXX'
                    ,'PAPER_TYPE_ID' => $form_type_id->PAPER_TYPE_ID
                    ,'STATUS' => 'Pending'
                    ,'RESIDENT_ID' => $RESIDENT_ID
                    ,'RECEIVED_BY' => 'Shiela Mae A. Velga'
                    ,'REQUESTED_PAPER_TYPE_ID' => $certificate_type_id->PAPER_TYPE_ID
                    ,'APPLICANT_NAME' => $APPLICANT_NAME
                ));

            $latest_form_id = DB::table('t_application_form')->select('FORM_ID')->latest('FORM_ID')->first();

            $barangay_certificate = DB::table('t_bf_barangay_certification')
                ->insert(array( 
                    'FORM_ID' => $latest_form_id->FORM_ID
                    ,'SSS_NO' => $B_SSS_NO
                    ,'CALAMITY_NAME' => $B_CALAMITY_NAME
                    ,'CALAMITY_DATE' => $B_CALAMITY_DATE
                ));
            return response()->json(['message' => $certificate_type_id->PAPER_TYPE_ID.' '.$form_type_id->PAPER_TYPE_ID] );
        }
        else if($CERTIFICATE_TYPE == "Barangay Certificate Calamity Loan OFW"){
            $application_form = DB::Table('t_application_form')
                ->insert(array(
                    'FORM_NUMBER' => 'XXXX-XXX'
                    ,'PAPER_TYPE_ID' => $form_type_id->PAPER_TYPE_ID
                    ,'STATUS' => 'Pending'
                    ,'RESIDENT_ID' => $RESIDENT_ID
                    ,'RECEIVED_BY' => 'Shiela Mae A. Velga'
                    ,'REQUESTED_PAPER_TYPE_ID' => $certificate_type_id->PAPER_TYPE_ID
                    ,'APPLICANT_NAME' => $APPLICANT_NAME
                ));

            $latest_form_id = DB::table('t_application_form')->select('FORM_ID')->latest('FORM_ID')->first();

            $barangay_certificate = DB::table('t_bf_barangay_certification')
                ->insert(array( 
                    'FORM_ID' => $latest_form_id->FORM_ID
                    ,'SSS_NO' => $C_SSS_NO
                    ,'CALAMITY_NAME' => $C_CALAMITY_NAME
                    ,'CALAMITY_DATE' => $C_CALAMITY_DATE
                    ,'COUNTRY' => $C_COUNTRY
                ));
            return response()->json(['message' => $certificate_type_id->PAPER_TYPE_ID.' '.$form_type_id->PAPER_TYPE_ID] );
        }
        else if($CERTIFICATE_TYPE == "Barangay Certificate SPES"){
            $application_form = DB::Table('t_application_form')
                ->insert(array(
                    'FORM_NUMBER' => 'XXXX-XXX'
                    ,'PAPER_TYPE_ID' => $form_type_id->PAPER_TYPE_ID
                    ,'STATUS' => 'Pending'
                    ,'RESIDENT_ID' => $RESIDENT_ID
                    ,'RECEIVED_BY' => 'Shiela Mae A. Velga'
                    ,'REQUESTED_PAPER_TYPE_ID' => $certificate_type_id->PAPER_TYPE_ID
                    ,'APPLICANT_NAME' => $APPLICANT_NAME
                ));

            $latest_form_id = DB::table('t_application_form')->select('FORM_ID')->latest('FORM_ID')->first();

            $barangay_certificate = DB::table('t_bf_barangay_certification')
                ->insert(array( 
                    'FORM_ID' => $latest_form_id->FORM_ID
                ));
            return response()->json(['message' => $certificate_type_id->PAPER_TYPE_ID.' '.$form_type_id->PAPER_TYPE_ID] );
        }
        else if($CERTIFICATE_TYPE == "Barangay Certificate Solo Parent"){
            $application_form = DB::Table('t_application_form')
                ->insert(array(
                    'FORM_NUMBER' => 'XXXX-XXX'
                    ,'PAPER_TYPE_ID' => $form_type_id->PAPER_TYPE_ID
                    ,'STATUS' => 'Pending'
                    ,'RESIDENT_ID' => $RESIDENT_ID
                    ,'RECEIVED_BY' => 'Shiela Mae A. Velga'
                    ,'REQUESTED_PAPER_TYPE_ID' => $certificate_type_id->PAPER_TYPE_ID
                    ,'APPLICANT_NAME' => $APPLICANT_NAME
                ));

            $latest_form_id = DB::table('t_application_form')->select('FORM_ID')->latest('FORM_ID')->first();

            $barangay_certificate = DB::table('t_bf_barangay_certification')
                ->insert(array( 
                    'FORM_ID' => $latest_form_id->FORM_ID
                    ,'CATEGORY_SINGLE_PARENT' => $E_CATEGORY_SINGLE_PARENT
                    ,'REQUESTOR_NAME' => $E_REQUESTOR_NAME
                   
                ));

            $latest_barangay_certificate_id = DB::table('t_bf_barangay_certification')->select('BARANGAY_CERTIFICATION_ID')->latest('BARANGAY_CERTIFICATION_ID')->first();

            $solo_parent_children = DB::table('t_solo_parent_children')
                ->insert(array(
                    'BARANGAY_CERTIFICATION_ID' => $latest_barangay_certificate_id->BARANGAY_CERTIFICATION_ID
                    ,'CHILD_NAME' => $E_CHILD_NAME
                    ,'CHILD_AGE' => $E_CHILD_AGE
                    ,'IS_PWD' => $E_IS_PWD
                    ,'CHILD_NAME_2' => $E_CHILD_NAME_2
                    ,'CHILD_AGE_2' => $E_CHILD_AGE_2
                    ,'IS_PWD_2' => $E_IS_PWD_2
                ));

            return response()->json(['message' => $certificate_type_id->PAPER_TYPE_ID.' '.$form_type_id->PAPER_TYPE_ID] );
        }
        else if($CERTIFICATE_TYPE == "Barangay Certificate Indigency"){
            $application_form = DB::Table('t_application_form')
                ->insert(array(
                    'FORM_NUMBER' => 'XXXX-XXX'
                    ,'PAPER_TYPE_ID' => $form_type_id->PAPER_TYPE_ID
                    ,'STATUS' => 'Pending'
                    ,'RESIDENT_ID' => $RESIDENT_ID
                    ,'RECEIVED_BY' => 'Shiela Mae A. Velga'
                    ,'REQUESTED_PAPER_TYPE_ID' => $certificate_type_id->PAPER_TYPE_ID
                    ,'APPLICANT_NAME' => $APPLICANT_NAME
                ));

            $latest_form_id = DB::table('t_application_form')->select('FORM_ID')->latest('FORM_ID')->first();

            $barangay_certificate = DB::table('t_bf_barangay_certification')
                ->insert(array( 
                    'FORM_ID' => $latest_form_id->FORM_ID
                    ,'PURPOSE' => $F_PURPOSE
                ));
            return response()->json(['message' => $certificate_type_id->PAPER_TYPE_ID.' '.$form_type_id->PAPER_TYPE_ID] );
        }
    }

    public function BusinessIssuanceRequest(Request $request){
        // Business Permit
            $TAX_YEAR = $request->TAX_YEAR;
            $QUARTER = $request->QUARTER;
            $BARANGAY_PERMIT = $request->BARANGAY_PERMIT;
            $GARBAGE_FEE = $request->GARBAGE_FEE;
            $SIGNBOARD = $request->SIGNBOARD;
            $CTC = $request->CTC;
            $BUSINESS_TAX = $request->BUSINESS_TAX;
        // Clearance Building - A
            $A_APPLICANT_NAME = $request->A_APPLICANT_NAME;
            $A_CONSTRUCTION_ADDRESS = $request->A_CONSTRUCTION_ADDRESS;
            $A_SCOPE_OF_WORK_NAME = $request->A_SCOPE_OF_WORK_NAME;
            $A_SCOPE_OF_WORK_SPECIFY = $request->A_SCOPE_OF_WORK_SPECIFY;
            $A_PROJECT_LOCATION = $request->A_PROJECT_LOCATION;
        // Clearance Business - B
            $B_REGISTERED_NAME = $request->B_REGISTERED_NAME;
            $B_CONSTRUCTION_ADDRESS = $request->B_CONSTRUCTION_ADDRESS;
        //Clearance Zonal - C
            $C_OCT_TCT_NUMBER = $request->C_OCT_TCT_NUMBER;
            $C_TAX_DECLARATION = $request->C_TAX_DECLARATION;
            $C_BUSINESS_AREA = $request->C_BUSINESS_AREA;
            $C_AREA_CLASSIFICATION = $request->C_AREA_CLASSIFICATION;
            $C_PROJECT_LOCATION = $request->C_PROJECT_LOCATION;
            $C_PURPOSE = $request->C_PURPOSE;
            $C_APPLICANT_NAME = $request->C_APPLICANT_NAME;
            $C_CONSTRUCTION_ADDRESS = $request->C_CONSTRUCTION_ADDRESS;
        //Clearance Tricycle - D
            $D_APPLICANT_NAME = $request->D_APPLICANT_NAME;
            $D_REGISTERED_NAME = $request->D_REGISTERED_NAME;
            $D_CONSTRUCTION_ADDRESS = $request->D_CONSTRUCTION_ADDRESS;
            $D_DRIVER_LICENSE_NO = $request->D_DRIVER_LICENSE_NO;
            $D_MUDGUARD_NO = $request->D_MUDGUARD_NO;
            $D_CR_NO = $request->D_CR_NO;
            $D_OR_NO = $request->D_OR_NO;
        //Clearance General Purpose - E
            $E_PURPOSE = $request->E_PURPOSE;
            $E_REGISTERED_NAME = $request->E_REGISTERED_NAME;
            $E_CONSTRUCTION_ADDRESS = $request->E_CONSTRUCTION_ADDRESS;
        //General
            $PAPER_TYPE_CLEARANCE = $request->PAPER_TYPE_CLEARANCE;
            $PAPER_TYPE_FORM = $request->PAPER_TYPE_FORM;
            $BUSINESS_ID = $request->BUSINESS_ID;
            $APPLICANT_NAME = $request->APPLICANT_NAME;


        $clearance_type_id = DB::table('r_paper_type')
            ->where('PAPER_TYPE_NAME', $PAPER_TYPE_CLEARANCE)
            ->select('PAPER_TYPE_ID')
            ->first();
        $form_type_id = DB::table('r_paper_type')
            ->where('PAPER_TYPE_NAME', $PAPER_TYPE_FORM)
            ->select('PAPER_TYPE_ID')
            ->first();

        if($PAPER_TYPE_CLEARANCE == "Barangay Business Permit"){
            $application_form = DB::Table('t_application_form')
                ->insert(array(
                    'FORM_NUMBER' => 'SSS-SSS'
                    ,'PAPER_TYPE_ID' => $form_type_id->PAPER_TYPE_ID
                    ,'STATUS' => 'Pending'
                    ,'BUSINESS_ID' => $BUSINESS_ID
                    ,'RECEIVED_BY' => 'Shiela Mae A. Velga'
                    ,'REQUESTED_PAPER_TYPE_ID' => $clearance_type_id->PAPER_TYPE_ID
                    ,'APPLICANT_NAME' => $APPLICANT_NAME

                ));

            $latest_form_id = DB::table('t_application_form')->select('FORM_ID')->latest('FORM_ID')->first();

            $business_permit = DB::table('t_bf_business_permit')
                ->insert(array(
                    'TAX_YEAR' => $TAX_YEAR
                    ,'QUARTER' => $QUARTER
                    ,'BARANGAY_PERMIT' => $BARANGAY_PERMIT
                    ,'GARBAGE_FEE' => $GARBAGE_FEE
                    ,'SIGNBOARD' => $SIGNBOARD
                    ,'CTC' => $CTC
                    ,'BUSINESS_TAX' => $BUSINESS_TAX
                    ,'FORM_ID' => $latest_form_id->FORM_ID

                ));

            return response()->json(['message' => $latest_form_id, 'applicant_name' => $APPLICANT_NAME] );
        }
        else if ($PAPER_TYPE_CLEARANCE == "Barangay Clearance Building"){
         $application_form = DB::Table('t_application_form')
            ->insert(array(
                'FORM_NUMBER' => 'XXXX-XXX'
                ,'PAPER_TYPE_ID' => $form_type_id->PAPER_TYPE_ID
                ,'STATUS' => 'Pending'
                ,'BUSINESS_ID' => $BUSINESS_ID
                ,'RECEIVED_BY' => 'Shiela Mae A. Velga'
                ,'REQUESTED_PAPER_TYPE_ID' => $clearance_type_id->PAPER_TYPE_ID
            ));

            $latest_form_id = DB::table('t_application_form')->select('FORM_ID')->latest('FORM_ID')->first();

            $scope_of_work = DB::table('t_bf_scope_of_work')
                ->insert(array(
                    'SCOPE_OF_WORK_NAME' => $A_SCOPE_OF_WORK_NAME
                    ,'SCOPE_OF_WORK_SPECIFY' =>$A_SCOPE_OF_WORK_SPECIFY
                ));
            $latest_scope_of_work_id = DB::table('t_bf_scope_of_work')->select('SCOPE_OF_WORK_ID')->latest('SCOPE_OF_WORK_ID')->first();

            $barangay_clearance = DB::table('t_bf_barangay_clearance')
                ->insert(array(
                    'APPLICANT_NAME' => $A_APPLICANT_NAME
                    ,'CONSTRUCTION_ADDRESS' => $A_CONSTRUCTION_ADDRESS
                    ,'PROJECT_LOCATION' => $A_PROJECT_LOCATION
                    ,'SCOPE_OF_WORK_ID' => $latest_scope_of_work_id->SCOPE_OF_WORK_ID
                    ,'FORM_ID' => $latest_form_id->FORM_ID
                ));

            return response()->json(['message' => $latest_form_id] );
        }
        else if($PAPER_TYPE_CLEARANCE == "Barangay Clearance Business"){
            $application_form = DB::Table('t_application_form')
                ->insert(array(
                    'FORM_NUMBER' => 'XXXX-XXX'
                    ,'PAPER_TYPE_ID' => $form_type_id->PAPER_TYPE_ID
                    ,'STATUS' => 'Pending'
                    ,'BUSINESS_ID' => $BUSINESS_ID
                    ,'RECEIVED_BY' => 'Shiela Mae A. Velga'
                    ,'REQUESTED_PAPER_TYPE_ID' => $clearance_type_id->PAPER_TYPE_ID
                ));

            $latest_form_id = DB::table('t_application_form')->select('FORM_ID')->latest('FORM_ID')->first();

           $barangay_clearance = DB::table('t_bf_barangay_clearance')
                ->insert(array(
                    'REGISTERED_NAME' => $B_REGISTERED_NAME
                    ,'CONSTRUCTION_ADDRESS' => $B_CONSTRUCTION_ADDRESS
                    ,'FORM_ID' => $latest_form_id->FORM_ID
                ));

            return response()->json(['message' => $latest_form_id] );
        }
        else if($PAPER_TYPE_CLEARANCE == "Barangay Clearance Zonal"){
            $application_form = DB::Table('t_application_form')
                ->insert(array(
                    'FORM_NUMBER' => 'XXXX-XXX'
                    ,'PAPER_TYPE_ID' => $form_type_id->PAPER_TYPE_ID
                    ,'STATUS' => 'Pending'
                    ,'BUSINESS_ID' => $BUSINESS_ID
                    ,'RECEIVED_BY' => 'Shiela Mae A. Velga'
                    ,'REQUESTED_PAPER_TYPE_ID' => $clearance_type_id->PAPER_TYPE_ID
                ));

            $latest_form_id = DB::table('t_application_form')->select('FORM_ID')->latest('FORM_ID')->first();

           $barangay_clearance = DB::table('t_bf_barangay_clearance')
                ->insert(array(
                    'OCT_TCT_NUMBER' => $C_OCT_TCT_NUMBER
                    ,'TAX_DECLARATION' => $C_TAX_DECLARATION
                    ,'BUSINESS_AREA' => $C_BUSINESS_AREA
                    ,'AREA_CLASSIFICATION' => $C_AREA_CLASSIFICATION
                    ,'PURPOSE' => $C_PURPOSE
                    ,'APPLICANT_NAME' => $C_APPLICANT_NAME
                    ,'CONSTRUCTION_ADDRESS' => $C_CONSTRUCTION_ADDRESS
                    ,'PROJECT_LOCATION' => $C_PROJECT_LOCATION
                    ,'FORM_ID' => $latest_form_id->FORM_ID
                ));

            return response()->json(['message' => $latest_form_id] );
        }
        else if($PAPER_TYPE_CLEARANCE == "Barangay Clearance Tricycle"){
            $application_form = DB::Table('t_application_form')
                ->insert(array(
                    'FORM_NUMBER' => 'XXXX-XXX'
                    ,'PAPER_TYPE_ID' => $form_type_id->PAPER_TYPE_ID
                    ,'STATUS' => 'Pending'
                    ,'BUSINESS_ID' => $BUSINESS_ID
                    ,'RECEIVED_BY' => 'Shiela Mae A. Velga'
                    ,'REQUESTED_PAPER_TYPE_ID' => $clearance_type_id->PAPER_TYPE_ID
                ));

            $latest_form_id = DB::table('t_application_form')->select('FORM_ID')->latest('FORM_ID')->first();

            $barangay_clearance = DB::table('t_bf_barangay_clearance')
                ->insert(array(
                    'APPLICANT_NAME' => $D_APPLICANT_NAME
                    ,'REGISTERED_NAME' => $D_REGISTERED_NAME
                    ,'CONSTRUCTION_ADDRESS' => $D_CONSTRUCTION_ADDRESS
                    ,'D_DRIVER_LICENSE_NO' => $D_DRIVER_LICENSE_NO
                    ,'D_MUDGUARD_NO' => $D_MUDGUARD_NO
                    ,'D_CR_NO' => $D_CR_NO
                    ,'D_OR_NO' => $D_OR_NO
                    ,'FORM_ID' => $latest_form_id->FORM_ID
                ));

            return response()->json(['message' => $latest_form_id] );
        }
        else if($PAPER_TYPE_CLEARANCE == "Barangay Clearance General Purposes"){
            $application_form = DB::Table('t_application_form')
                ->insert(array(
                    'FORM_NUMBER' => 'XXXX-XXX'
                    ,'PAPER_TYPE_ID' => $form_type_id->PAPER_TYPE_ID
                    ,'STATUS' => 'Pending'
                    ,'BUSINESS_ID' => $BUSINESS_ID
                    ,'RECEIVED_BY' => 'Shiela Mae A. Velga'
                    ,'REQUESTED_PAPER_TYPE_ID' => $clearance_type_id->PAPER_TYPE_ID
                ));

            $latest_form_id = DB::table('t_application_form')->select('FORM_ID')->latest('FORM_ID')->first();

           $barangay_clearance = DB::table('t_bf_barangay_clearance')
                ->insert(array(
                    'PURPOSE' => $E_PURPOSE
                    ,'REGISTERED_NAME' => $E_REGISTERED_NAME
                    ,'CONSTRUCTION_ADDRESS' => $E_CONSTRUCTION_ADDRESS
                    ,'FORM_ID' => $latest_form_id->FORM_ID
                ));

            return response()->json(['message' => $latest_form_id] );
        }

    }
}
