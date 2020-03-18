<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class BusinessController extends Controller
{
    public function index($typeOfView){
    	$approved_business = DB::table('v_official_business_list')->where('STATUS','Approved')->get();
    	$business_nature = DB::table('v_business_nature')->get();
        $line_of_business = DB::table('v_line_of_business')->get();
        $businessNotApproved = DB::table('v_official_business_list')->where('STATUS', 'Pending')->get();


        if($typeOfView == "business_registration")
    		return view('business.business_registration', compact('approved_business', 'business_nature', 'line_of_business'));
    	else if ($typeOfView == "business_evaluation")
        	return view('business.business_evaluation', compact('businessNotApproved'));
    }

    // REGISTRATION
    public function CRUDBusinessApplication(Request $request){
    	$BUSINESS_NAME = $request->BUSINESS_NAME;
    	$TRADE_NAME = $request->TRADE_NAME;
    	$BUSINESS_NATURE_ID = $request->BUSINESS_NATURE_ID;
    	$BUSINESS_OWNER_FIRSTNAME = $request->BUSINESS_OWNER_FIRSTNAME;
    	$BUSINESS_OWNER_MIDDLENAME = $request->BUSINESS_OWNER_MIDDLENAME;
    	$BUSINESS_OWNER_LASTNAME = $request->BUSINESS_OWNER_LASTNAME;
    	$BUSINESS_ADDRESS = $request->BUSINESS_ADDRESS;
    	$BUSINESS_OR_NUMBER = $request->BUSINESS_OR_NUMBER;
    	$TIN_NO = $request->TIN_NO;
    	$DTI_REGISTRATION_NO = $request->DTI_REGISTRATION_NO;
        $DTI_NO_DATE = $request->DTI_NO_DATE;

    	$TYPE_OF_BUSINESS = $request->TYPE_OF_BUSINESS;
    	$BUSINESS_POSTAL_CODE = $request->BUSINESS_POSTAL_CODE;
    	$BUSINESS_EMAIL_ADD = $request->BUSINESS_EMAIL_ADD;
    	$BUSINESS_TELEPHONE_NO = $request->BUSINESS_TELEPHONE_NO;
    	$BUSINESS_MOBILE_NO = $request->BUSINESS_MOBILE_NO;
    	$OWNER_ADDRESS = $request->OWNER_ADDRESS;
    	$OWNER_POSTAL_CODE = $request->OWNER_POSTAL_CODE;
    	$OWNER_EMAIL_ADD = $request->OWNER_EMAIL_ADD;
    	$OWNER_TELEPHONE_NO = $request->OWNER_TELEPHONE_NO;
    	$OWNER_MOBILE_NO = $request->OWNER_MOBILE_NO;
    	$EMERGENCY_CONTACT_PERSON = $request->EMERGENCY_CONTACT_PERSON;
    	$EMERGENCY_PERSON_CONTACT_NO = $request->EMERGENCY_PERSON_CONTACT_NO;
    	$EMERGENCY_PERSON_EMAIL_ADD = $request->EMERGENCY_PERSON_EMAIL_ADD;
    	$BUSINESS_AREA = $request->BUSINESS_AREA;
    	$NO_EMPLOYEE_ESTABLISHMENT = $request->NO_EMPLOYEE_ESTABLISHMENT;
    	$NO_EMPLOYEE_LGU = $request->NO_EMPLOYEE_LGU;

        $NO_FEMALE_EMPLOYEE = $request->NO_FEMALE_EMPLOYEE;
        $NO_MALE_EMPLOYEE = $request->NO_MALE_EMPLOYEE;
        $NO_FEMALE_LGU = $request->NO_FEMALE_LGU;
        $NO_MALE_LGU = $request->NO_MALE_LGU;

    	$LESSOR_NAME = $request->LESSOR_NAME;
    	$LESSOR_ADDRESS = $request->LESSOR_ADDRESS;
    	$LESSOR_CONTACT_NO = $request->LESSOR_CONTACT_NO;
        // $LESSOR_TELEPHONE = $request->LESSOR_TELEPHONE;
        // $LESSOR_MOBILE_NO = $request->LESSOR_MOBILE_NO;
    	$LESSOR_EMAIL_ADD = $request->LESSOR_EMAIL_ADD;
    	$MONTHLY_RENTAL = $request->MONTHLY_RENTAL;
    	// $BUSINESS_OR_ACQUIRED_DATE = $request->BUSINESS_OR_ACQUIRED_DATE;
    	// $LINE_OF_BUSINESS_ID = $request->LINE_OF_BUSINESS_ID;
    	// $NO_OF_UNITS = $request->NO_OF_UNITS;
    	// $CAPITALIZATION = $request->CAPITALIZATION;
    	// $GROSS_RECEIPTS_ESSENTIAL = $request->GROSS_RECEIPTS_ESSENTIAL;
    	// $GROSS_RECEIPTS_NON_ESSENTIAL = $request->GROSS_RECEIPTS_NON_ESSENTIAL;
        // BUSINESS ADDRESS
        $BUILDING_NUMBER = $request->BUILDING_NUMBER;
        $BUILDING_NAME = $request->BUILDING_NAME;
        $UNIT_NO =$request->UNIT_NO;
        $STREET = $request->STREET;
        $SITIO = $request->SITIO;
        $SUBDIVISION = $request->SUBDIVISION;
        // RENEWAL
        $REFERENCED_BUSINESS_ID = $request->REFERENCED_BUSINESS_ID;
        $NEW_RENEW_STATUS = $request->NEW_RENEW_STATUS;

    
    	$insert = DB::table('t_business_information')
    		->insert(array(
    			'BUSINESS_NAME' => $BUSINESS_NAME
    			,'TRADE_NAME' => $TRADE_NAME
    			,'BUSINESS_NATURE_ID' => $BUSINESS_NATURE_ID
    			,'BUSINESS_OWNER_FIRSTNAME' => $BUSINESS_OWNER_FIRSTNAME
    			,'BUSINESS_OWNER_MIDDLENAME' => $BUSINESS_OWNER_MIDDLENAME
    			,'BUSINESS_OWNER_LASTNAME' => $BUSINESS_OWNER_LASTNAME
    			,'BUSINESS_ADDRESS' => $BUSINESS_ADDRESS
    			,'BUSINESS_OR_NUMBER' => $BUSINESS_OR_NUMBER
    			,'TIN_NO' => $TIN_NO
    			,'DTI_REGISTRATION_NO' => $DTI_REGISTRATION_NO
    			,'TYPE_OF_BUSINESS' => $TYPE_OF_BUSINESS
    			,'BUSINESS_POSTAL_CODE' => $BUSINESS_POSTAL_CODE
    			,'BUSINESS_EMAIL_ADD' => $BUSINESS_EMAIL_ADD
    			,'BUSINESS_TELEPHONE_NO' => $BUSINESS_TELEPHONE_NO
    			,'BUSINESS_MOBILE_NO' => $BUSINESS_MOBILE_NO
    			,'OWNER_ADDRESS' => $OWNER_ADDRESS
    			,'OWNER_POSTAL_CODE' => $OWNER_POSTAL_CODE
    			,'OWNER_EMAIL_ADD' => $OWNER_EMAIL_ADD
    			,'OWNER_TELEPHONE_NO' => $OWNER_TELEPHONE_NO
    			,'OWNER_MOBILE_NO' => $OWNER_MOBILE_NO
    			,'EMERGENCY_CONTACT_PERSON' => $EMERGENCY_CONTACT_PERSON
    			,'EMERGENCY_PERSON_CONTACT_NO' => $EMERGENCY_PERSON_CONTACT_NO
    			,'EMERGENCY_PERSON_EMAIL_ADD' => $EMERGENCY_PERSON_EMAIL_ADD
    			,'BUSINESS_AREA' => $BUSINESS_AREA
    			,'NO_EMPLOYEE_ESTABLISHMENT' => $NO_EMPLOYEE_ESTABLISHMENT
    			,'NO_EMPLOYEE_LGU' => $NO_EMPLOYEE_LGU
    			,'LESSOR_NAME' => $LESSOR_NAME
    			,'LESSOR_ADDRESS' => $LESSOR_ADDRESS
    			,'LESSOR_CONTACT_NO' => $LESSOR_CONTACT_NO
                // ,'LESSOR_TELEPHONE' => $LESSOR_TELEPHONE
                // ,'LESSOR_MOBILE_NO' => $LESSOR_MOBILE_NO
    			,'LESSOR_EMAIL_ADD' => $LESSOR_EMAIL_ADD
    			,'MONTHLY_RENTAL' => $MONTHLY_RENTAL 
    			// ,'BUSINESS_OR_ACQUIRED_DATE'   => $BUSINESS_OR_ACQUIRED_DATE
    			,'CREATED_AT' => date('Y-m-d')
    			,'STATUS' => 'Pending'
                ,'BUILDING_NUMBER' => $BUILDING_NUMBER
                ,'BUILDING_NAME' => $BUILDING_NAME
                ,'UNIT_NO' => $UNIT_NO
                ,'STREET' => $STREET
                // ,'SITIO' => $SITIO
                // ,'SUBDIVISION' => $SUBDIVISION
                ,'REFERENCED_BUSINESS_ID' => $REFERENCED_BUSINESS_ID
                ,'NEW_RENEW_STATUS' => $NEW_RENEW_STATUS
    		));

    	// $LASTEST_BUSINESS_ID = DB::table('t_business_information')->select('BUSINESS_ID')->latest('BUSINESS_ID')->first();


    	// $inserBusinessActivity = DB::table('t_bf_business_activity')
    	// 	->insert(array(
    	// 		'LINE_OF_BUSINESS_ID' => $LINE_OF_BUSINESS_ID
    	// 		,'NO_OF_UNITS' => $NO_OF_UNITS
    	// 		,'CAPITALIZATION' => $CAPITALIZATION
    	// 		,'GROSS_RECEIPTS_ESSENTIAL' => $GROSS_RECEIPTS_ESSENTIAL
    	// 		,'GROSS_RECEIPTS_NON_ESSENTIAL' => $GROSS_RECEIPTS_NON_ESSENTIAL
    	// 		,'BUSINESS_ID' => $LASTEST_BUSINESS_ID->BUSINESS_ID
    	// 	));
    }

    public function SpecificBusiness(Request $request){
        $BUSINESS_ID = $request->BUSINESS_ID;

        $specific_business = DB::table('v_business_information')
            ->where('BUSINESS_ID', $BUSINESS_ID)
            ->get();
            return response()->json(['specific_business' => $specific_business]);
    }

    // EVALUATION
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
}
